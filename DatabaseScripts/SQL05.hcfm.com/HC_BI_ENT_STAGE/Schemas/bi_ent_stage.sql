CREATE SCHEMA [bi_ent_stage]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contains objects related to BI Staging Data' , @level0type=N'SCHEMA',@level0name=N'bi_ent_stage'
GO
