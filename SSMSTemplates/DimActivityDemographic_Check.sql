SELECT * FROM [bi_mktg_stage].[DimActivityDemographic] WHERE isnew = 1 ORDER BY [ModifiedDate] DESC
SELECT TOP 100 * FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] ORDER BY rowtimestamp DESC


SELECT TOP 100 * FROM [HC_BI_MKTG_DDS].[Audit].[bi_mktg_dds_DimActivityDemographic]
SELECT TOP 100 * FROM [HC_BI_MKTG_STAGE].[Audit].[bi_mktg_stage_DimActivityDemographic]

-- SQL05
SELECT TOP 1000
       *
FROM [HC_BI_MKTG_STAGE].[bi_mktg_stage].[DimActivityDemographic]
ORDER BY [ModifiedDate] DESC ;


SELECT * FROM sys.synonyms WHERE OBJECT_ID = OBJECT_ID('[bi_mktg_stage].[synHC_DDS_DimActivityDemographic]')


