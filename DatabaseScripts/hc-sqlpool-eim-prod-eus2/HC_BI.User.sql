/****** Object:  User [HC_BI]    Script Date: 1/7/2022 4:02:11 PM ******/
CREATE USER [HC_BI] WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_datareader', @membername = N'HC_BI'
GO
