/****** Object:  ExternalDataSource [src_43f5836f22bc49dcae801b0e781a13bf]    Script Date: 1/7/2022 4:05:01 PM ******/
CREATE EXTERNAL DATA SOURCE [src_43f5836f22bc49dcae801b0e781a13bf] WITH (TYPE = HADOOP, LOCATION = N'abfss://hc-staging-datafactory@hceimdlakeprod.dfs.core.windows.net/', CREDENTIAL = [cred_43f5836f22bc49dcae801b0e781a13bf])
GO
