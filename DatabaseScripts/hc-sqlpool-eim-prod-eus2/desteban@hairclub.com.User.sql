/****** Object:  User [desteban@hairclub.com]    Script Date: 1/7/2022 4:02:11 PM ******/
CREATE USER [desteban@hairclub.com] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_datareader', @membername = N'desteban@hairclub.com'
GO
