/****** Object:  ExternalDataSource [src_a20c636d6d0a432ea005d6eab2864c0b]    Script Date: 1/7/2022 4:05:02 PM ******/
CREATE EXTERNAL DATA SOURCE [src_a20c636d6d0a432ea005d6eab2864c0b] WITH (TYPE = HADOOP, LOCATION = N'abfss://hc-staging-datafactory@hceimdlakeprod.dfs.core.windows.net/', CREDENTIAL = [cred_a20c636d6d0a432ea005d6eab2864c0b])
GO
