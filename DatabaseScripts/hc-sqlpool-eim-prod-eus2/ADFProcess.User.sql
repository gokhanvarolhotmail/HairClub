/****** Object:  User [ADFProcess]    Script Date: 1/7/2022 4:02:11 PM ******/
CREATE USER [ADFProcess] WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_datareader', @membername = N'ADFProcess'
GO
sys.sp_addrolemember @rolename = N'db_datawriter', @membername = N'ADFProcess'
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'ADFProcess'
GO
