CREATE USER [EIMResourceAdministration@hairclub.com] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO



EXEC sp_addrolemember 'db_owner', 'MKunchum@hairclub.com';
EXEC sp_addrolemember 'db_datareader', 'TJaved@hairclub.com';


SELECT GETDATE(), * FROM sys.database_principals ORDER BY NAME
