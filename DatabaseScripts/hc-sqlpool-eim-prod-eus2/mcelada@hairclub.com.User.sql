/****** Object:  User [mcelada@hairclub.com]    Script Date: 1/7/2022 4:02:11 PM ******/
CREATE USER [mcelada@hairclub.com] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_datareader', @membername = N'mcelada@hairclub.com'
GO
sys.sp_addrolemember @rolename = N'db_datawriter', @membername = N'mcelada@hairclub.com'
GO
