/****** Object:  User [jreyes@hairclub.com]    Script Date: 1/7/2022 4:02:11 PM ******/
CREATE USER [jreyes@hairclub.com] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'jreyes@hairclub.com'
GO
sys.sp_addrolemember @rolename = N'db_datareader', @membername = N'jreyes@hairclub.com'
GO
sys.sp_addrolemember @rolename = N'db_datawriter', @membername = N'jreyes@hairclub.com'
GO
