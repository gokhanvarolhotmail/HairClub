/****** Object:  User [nchavez@hairclub.com]    Script Date: 1/7/2022 4:02:11 PM ******/
CREATE USER [nchavez@hairclub.com] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_datawriter', @membername = N'nchavez@hairclub.com'
GO
sys.sp_addrolemember @rolename = N'db_datareader', @membername = N'nchavez@hairclub.com'
GO
