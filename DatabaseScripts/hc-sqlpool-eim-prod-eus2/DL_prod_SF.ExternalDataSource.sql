/****** Object:  ExternalDataSource [DL_prod_SF]    Script Date: 1/7/2022 4:05:01 PM ******/
CREATE EXTERNAL DATA SOURCE [DL_prod_SF] WITH (TYPE = HADOOP, LOCATION = N'wasbs://hc-eim-filesystem-prod@hceimdlakeprod.blob.core.windows.net', CREDENTIAL = [datalakeprod])
GO
