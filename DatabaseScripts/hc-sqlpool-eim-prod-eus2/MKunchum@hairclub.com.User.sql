/****** Object:  User [MKunchum@hairclub.com]    Script Date: 1/7/2022 4:02:11 PM ******/
CREATE USER [MKunchum@hairclub.com] FROM  EXTERNAL PROVIDER  WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'MKunchum@hairclub.com'
GO
