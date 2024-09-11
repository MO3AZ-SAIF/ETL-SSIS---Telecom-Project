use TelecomDB
go 

-- Create Destination For Destination Errors
if exists( select 1 from sys.tables where name = 'err_source_output' )
begin
	drop table err_source_output
end
CREATE TABLE err_source_output (
	id int identity(1,1),
    FlatFileSourceErrorOutput varchar(max),
   	ErrorCode int,
    ErrorColumn int,
	audit_id int default -1
)
go

-- Create Destination For Source Errors 

if exists( select 1 from sys.tables where name = 'err_destination_output' )
begin
	drop table err_destination_output
end
CREATE TABLE err_destination_output (
    id int,
    imsi varchar(9),
    imei varchar(14),
    subscriber_id int,
    cell int,
    lac int,
    event_type varchar(2),
    event_ts datetime,
    tac varchar(8),
    snr varchar(6),
    ErrorCode int,
    ErrorColumn int,
	audit_id int default -1
)
go