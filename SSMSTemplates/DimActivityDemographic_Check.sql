USE [HC_BI_MKTG_DDS] ;

SELECT TOP 100
       *
FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic]
ORDER BY [RowTimeStamp] DESC ;

SELECT TOP 100
       *
FROM [HC_BI_MKTG_STAGE].[bi_mktg_stage].[DimActivityDemographic]
ORDER BY [ModifiedDate] DESC ;

-- Audit
SELECT TOP 100
       *
FROM [HC_BI_MKTG_DDS].[Audit].[bi_mktg_dds_DimActivityDemographic] ;

SELECT TOP 100
       *
FROM [HC_BI_MKTG_STAGE].[Audit].[bi_mktg_stage_DimActivityDemographic] ;

SELECT *
FROM [sys].[synonyms]
WHERE [object_id] = OBJECT_ID('[bi_mktg_stage].[synHC_DDS_DimActivityDemographic]') ;
