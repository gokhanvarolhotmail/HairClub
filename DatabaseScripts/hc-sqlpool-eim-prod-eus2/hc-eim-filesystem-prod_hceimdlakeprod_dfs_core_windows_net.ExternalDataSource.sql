/****** Object:  ExternalDataSource [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net]    Script Date: 1/7/2022 4:05:01 PM ******/
CREATE EXTERNAL DATA SOURCE [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net] WITH (TYPE = HADOOP, LOCATION = N'abfss://hc-eim-filesystem-prod@hceimdlakeprod.dfs.core.windows.net')
GO
