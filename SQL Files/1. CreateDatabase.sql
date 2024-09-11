use master 
go 

if exists( select 1 from sys.databases where name = 'TelecomDB' )
begin 
	use master
	drop database TelecomDB
end

create database TelecomDB
go