/****** Object:  ExternalDataSource [hceimfilesystemprod]    Script Date: 1/7/2022 4:05:01 PM ******/
CREATE EXTERNAL DATA SOURCE [hceimfilesystemprod] WITH (TYPE = HADOOP, LOCATION = N'wasbs://hc-eim-filesystem-prod@hceimdlakeprod.blob.core.windows.net', CREDENTIAL = [hceimdlakeprod])
GO
