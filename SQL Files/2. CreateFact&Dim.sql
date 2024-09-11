use TelecomDB
go 

-- Delete Audit Dimension if it exists.
if exists( select 1 from sys.tables where name = 'AuditDim' )
begin
	if exists( select 1 from sys.foreign_keys 
	where name = 'fk_audit_dim')
	begin
		alter table TelecomFact
		drop constraint fk_audit_dim
	end
	drop table AuditDim
end
go 

-- Create Audit Dimension 
Create table AuditDim(
	id int identity(1,1) not null,
	batch_id int,
	package_name nvarchar(255),
	file_name nvarchar(255),
	rows_extracted int,
	rows_inserted int,
	rows_rejected int,
	created_at datetime default(getdate()),
	updated_at datetime default(getdate()),
	SuccessfulProcessingInd nchar(1) not null default 'N'
	constraint pk_audit_id primary key (id)
); 
go

-- Delete the fact table and foreign key constraint if they exist.
if exists( select 1 from sys.tables where name = 'TelecomFact' )
begin
	drop table TelecomFact
end
go

-- Insert Unknown Record For Error Handling 
SET IDENTITY_INSERT AuditDim ON
insert into AuditDim (id, batch_id, package_name, file_name, rows_extracted, rows_inserted, rows_rejected)
values (-1,0, 'Unknown','Unknown',null,null,null)
SET IDENTITY_INSERT AuditDim OFF

-- Create Fact table
create table TelecomFact(
	id int identity(1,1) not null,
	transaction_id int not null,
	IMSI varchar(9) not null,
	subscriber_id int not null,
	TAC varchar(8) not null, 
	SNR varchar(6) not null,
	IMEI varchar(14) not null,
	CELL int not null,
	LAC int not null,
	event_type varchar(2) not null,
	event_ts datetime not null,
	audit_id int not null default (-1),
	constraint pk_fact_id primary key (id),
	constraint fk_audit_dim foreign key (audit_id) references AuditDim(id)
);
go