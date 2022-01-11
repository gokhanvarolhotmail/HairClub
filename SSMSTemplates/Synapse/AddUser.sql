use master
go
CREATE LOGIN [gvarol@hairclub.com] FROM EXTERNAL PROVIDER;
ALTER SERVER ROLE sysadmin ADD MEMBER [gvarol@hairclub.com];


CREATE USER [gvarol@hairclub.com] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
CREATE USER [MKunchum@hairclub.com] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]

EXEC sp_addrolemember 'db_owner', 'gvarol@hairclub.com';
EXEC sp_addrolemember 'db_owner', 'MKunchum@hairclub.com';

EXEC sp_addrolemember 'db_datareader', 'TJaved@hairclub.com';


SELECT GETDATE(), * FROM sys.database_principals ORDER BY NAME

