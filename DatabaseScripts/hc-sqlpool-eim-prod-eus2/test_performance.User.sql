/****** Object:  User [test_performance]    Script Date: 1/7/2022 4:02:11 PM ******/
CREATE USER [test_performance] WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_datareader', @membername = N'test_performance'
GO
