-- SQL05
GO
USE [HC_BI_MKTG_STAGE] ;
GO
CREATE SCHEMA [Audit] ;
GO
-- DROP TRIGGER [bi_mktg_stage].[TRG_bi_mktg_stage_DimActivityDemographic_Log]
-- DROP TABLE [Audit].[bi_mktg_stage_DimActivityDemographic]

CREATE TABLE [Audit].[bi_mktg_stage_DimActivityDemographic]
(
    [LogId]                    INT            NOT NULL
  , [LogUser]                  VARCHAR(1000)  NOT NULL
  , [LogAppName]               VARCHAR(1000)  NOT NULL
  , [LogDate]                  DATETIME2(7)   NOT NULL
  , [Action]                   CHAR(1)  NOT NULL
  , [DataPkgKey]               [INT]          NULL
  , [ActivityDemographicKey]   [INT]          NULL
  , [ActivityDemographicSSID]  [VARCHAR](10)  NULL
  , [ActivitySSID]             [VARCHAR](10)  NULL
  , [ContactSSID]              [VARCHAR](10)  NULL
  , [GenderSSID]               [CHAR](1)      NULL
  , [GenderDescription]        [VARCHAR](50)  NULL
  , [EthnicitySSID]            [VARCHAR](10)  NULL
  , [EthnicityDescription]     [VARCHAR](50)  NULL
  , [OccupationSSID]           [VARCHAR](10)  NULL
  , [OccupationDescription]    [VARCHAR](50)  NULL
  , [MaritalStatusSSID]        [VARCHAR](10)  NULL
  , [MaritalStatusDescription] [VARCHAR](50)  NULL
  , [Birthday]                 [DATE]         NULL
  , [Age]                      [INT]          NULL
  , [AgeRangeSSID]             [VARCHAR](10)  NULL
  , [AgeRangeDescription]      [VARCHAR](50)  NULL
  , [HairLossTypeSSID]         [VARCHAR](50)  NULL
  , [HairLossTypeDescription]  [VARCHAR](50)  NULL
  , [NorwoodSSID]              [VARCHAR](50)  NULL
  , [LudwigSSID]               [VARCHAR](50)  NULL
  , [Performer]                [VARCHAR](50)  NULL
  , [PriceQuoted]              [MONEY]        NULL
  , [SolutionOffered]          [VARCHAR](100) NULL
  , [NoSaleReason]             [VARCHAR](200) NULL
  , [DateSaved]                [DATE]         NULL
  , [ModifiedDate]             [DATETIME]     NULL
  , [IsNew]                    [TINYINT]      NULL
  , [IsType1]                  [TINYINT]      NULL
  , [IsType2]                  [TINYINT]      NULL
  , [IsDelete]                 [TINYINT]      NULL
  , [IsDuplicate]              [TINYINT]      NULL
  , [IsInferredMember]         [TINYINT]      NULL
  , [IsException]              [TINYINT]      NULL
  , [IsHealthy]                [TINYINT]      NULL
  , [IsRejected]               [TINYINT]      NULL
  , [IsAllowed]                [TINYINT]      NULL
  , [IsFixed]                  [TINYINT]      NULL
  , [SourceSystemKey]          [NVARCHAR](50) NULL
  , [RuleKey]                  [INT]          NULL
  , [DataQualityAuditKey]      [INT]          NULL
  , [IsNewDQA]                 [TINYINT]      NULL
  , [IsValidated]              [TINYINT]      NULL
  , [IsLoaded]                 [TINYINT]      NULL
  , [CDC_Operation]            [VARCHAR](2)   NULL
  , [DiscStyleSSID]            [NVARCHAR](10) NULL
  , [SFDC_TaskID]              [NVARCHAR](18) NULL
  , [SFDC_LeadID]              [NVARCHAR](18) NULL
  , [SFDC_PersonAccountID]     [NVARCHAR](18) NULL
) ;
GO
CREATE CLUSTERED INDEX [bi_mktg_stage_DimActivityDemographic_PKC]
ON [Audit].[bi_mktg_stage_DimActivityDemographic]
( [LogId]
, [DataPkgKey]
, [ActivityDemographicSSID] ASC
, [IsException] ASC
, [IsNew] ASC
, [IsType1] ASC
, [IsType2] ASC
, [IsDelete] ASC
, [IsInferredMember] ASC
, [Action]
) ;
GO
-- DROP TRIGGER [bi_mktg_stage].[TRG_bi_mktg_stage_DimActivityDemographic_Log]
GO
CREATE TRIGGER [bi_mktg_stage].[TRG_bi_mktg_stage_DimActivityDemographic_Log]
ON [bi_mktg_stage].[DimActivityDemographic]
FOR INSERT, DELETE, UPDATE
AS
SET NOCOUNT ON ;

INSERT [Audit].[bi_mktg_stage_DimActivityDemographic]( [LogId]
                                                     , [LogUser]
                                                     , [LogAppName]
                                                     , [LogDate]
                                                     , [Action]
                                                     , [DataPkgKey]
                                                     , [ActivityDemographicKey]
                                                     , [ActivityDemographicSSID]
                                                     , [ActivitySSID]
                                                     , [ContactSSID]
                                                     , [GenderSSID]
                                                     , [GenderDescription]
                                                     , [EthnicitySSID]
                                                     , [EthnicityDescription]
                                                     , [OccupationSSID]
                                                     , [OccupationDescription]
                                                     , [MaritalStatusSSID]
                                                     , [MaritalStatusDescription]
                                                     , [Birthday]
                                                     , [Age]
                                                     , [AgeRangeSSID]
                                                     , [AgeRangeDescription]
                                                     , [HairLossTypeSSID]
                                                     , [HairLossTypeDescription]
                                                     , [NorwoodSSID]
                                                     , [LudwigSSID]
                                                     , [Performer]
                                                     , [PriceQuoted]
                                                     , [SolutionOffered]
                                                     , [NoSaleReason]
                                                     , [DateSaved]
                                                     , [ModifiedDate]
                                                     , [IsNew]
                                                     , [IsType1]
                                                     , [IsType2]
                                                     , [IsDelete]
                                                     , [IsDuplicate]
                                                     , [IsInferredMember]
                                                     , [IsException]
                                                     , [IsHealthy]
                                                     , [IsRejected]
                                                     , [IsAllowed]
                                                     , [IsFixed]
                                                     , [SourceSystemKey]
                                                     , [RuleKey]
                                                     , [DataQualityAuditKey]
                                                     , [IsNewDQA]
                                                     , [IsValidated]
                                                     , [IsLoaded]
                                                     , [CDC_Operation]
                                                     , [DiscStyleSSID]
                                                     , [SFDC_TaskID]
                                                     , [SFDC_LeadID]
                                                     , [SFDC_PersonAccountID] )
SELECT
    ISNULL(( SELECT TOP 1 [LogId] + 1 FROM [Audit].[bi_mktg_stage_DimActivityDemographic] ORDER BY [LogId] DESC ), 1) AS [LogId]
  , SUSER_SNAME() AS [LogUser]
  , APP_NAME() AS [LogAppName]
  , GETDATE() AS [LogDate]
  , [k].[Action]
  , [k].[DataPkgKey]
  , [k].[ActivityDemographicKey]
  , [k].[ActivityDemographicSSID]
  , [k].[ActivitySSID]
  , [k].[ContactSSID]
  , [k].[GenderSSID]
  , [k].[GenderDescription]
  , [k].[EthnicitySSID]
  , [k].[EthnicityDescription]
  , [k].[OccupationSSID]
  , [k].[OccupationDescription]
  , [k].[MaritalStatusSSID]
  , [k].[MaritalStatusDescription]
  , [k].[Birthday]
  , [k].[Age]
  , [k].[AgeRangeSSID]
  , [k].[AgeRangeDescription]
  , [k].[HairLossTypeSSID]
  , [k].[HairLossTypeDescription]
  , [k].[NorwoodSSID]
  , [k].[LudwigSSID]
  , [k].[Performer]
  , [k].[PriceQuoted]
  , [k].[SolutionOffered]
  , [k].[NoSaleReason]
  , [k].[DateSaved]
  , [k].[ModifiedDate]
  , [k].[IsNew]
  , [k].[IsType1]
  , [k].[IsType2]
  , [k].[IsDelete]
  , [k].[IsDuplicate]
  , [k].[IsInferredMember]
  , [k].[IsException]
  , [k].[IsHealthy]
  , [k].[IsRejected]
  , [k].[IsAllowed]
  , [k].[IsFixed]
  , [k].[SourceSystemKey]
  , [k].[RuleKey]
  , [k].[DataQualityAuditKey]
  , [k].[IsNewDQA]
  , [k].[IsValidated]
  , [k].[IsLoaded]
  , [k].[CDC_Operation]
  , [k].[DiscStyleSSID]
  , [k].[SFDC_TaskID]
  , [k].[SFDC_LeadID]
  , [k].[SFDC_PersonAccountID]
FROM( SELECT
          'D' AS [Action]
        , [d].[DataPkgKey]
        , [d].[ActivityDemographicKey]
        , [d].[ActivityDemographicSSID]
        , [d].[ActivitySSID]
        , [d].[ContactSSID]
        , [d].[GenderSSID]
        , [d].[GenderDescription]
        , [d].[EthnicitySSID]
        , [d].[EthnicityDescription]
        , [d].[OccupationSSID]
        , [d].[OccupationDescription]
        , [d].[MaritalStatusSSID]
        , [d].[MaritalStatusDescription]
        , [d].[Birthday]
        , [d].[Age]
        , [d].[AgeRangeSSID]
        , [d].[AgeRangeDescription]
        , [d].[HairLossTypeSSID]
        , [d].[HairLossTypeDescription]
        , [d].[NorwoodSSID]
        , [d].[LudwigSSID]
        , [d].[Performer]
        , [d].[PriceQuoted]
        , [d].[SolutionOffered]
        , [d].[NoSaleReason]
        , [d].[DateSaved]
        , [d].[ModifiedDate]
        , [d].[IsNew]
        , [d].[IsType1]
        , [d].[IsType2]
        , [d].[IsDelete]
        , [d].[IsDuplicate]
        , [d].[IsInferredMember]
        , [d].[IsException]
        , [d].[IsHealthy]
        , [d].[IsRejected]
        , [d].[IsAllowed]
        , [d].[IsFixed]
        , [d].[SourceSystemKey]
        , [d].[RuleKey]
        , [d].[DataQualityAuditKey]
        , [d].[IsNewDQA]
        , [d].[IsValidated]
        , [d].[IsLoaded]
        , [d].[CDC_Operation]
        , [d].[DiscStyleSSID]
        , [d].[SFDC_TaskID]
        , [d].[SFDC_LeadID]
        , [d].[SFDC_PersonAccountID]
      FROM [Deleted] AS [d]
      UNION ALL
      SELECT
          'I' AS [Action]
        , [i].[DataPkgKey]
        , [i].[ActivityDemographicKey]
        , [i].[ActivityDemographicSSID]
        , [i].[ActivitySSID]
        , [i].[ContactSSID]
        , [i].[GenderSSID]
        , [i].[GenderDescription]
        , [i].[EthnicitySSID]
        , [i].[EthnicityDescription]
        , [i].[OccupationSSID]
        , [i].[OccupationDescription]
        , [i].[MaritalStatusSSID]
        , [i].[MaritalStatusDescription]
        , [i].[Birthday]
        , [i].[Age]
        , [i].[AgeRangeSSID]
        , [i].[AgeRangeDescription]
        , [i].[HairLossTypeSSID]
        , [i].[HairLossTypeDescription]
        , [i].[NorwoodSSID]
        , [i].[LudwigSSID]
        , [i].[Performer]
        , [i].[PriceQuoted]
        , [i].[SolutionOffered]
        , [i].[NoSaleReason]
        , [i].[DateSaved]
        , [i].[ModifiedDate]
        , [i].[IsNew]
        , [i].[IsType1]
        , [i].[IsType2]
        , [i].[IsDelete]
        , [i].[IsDuplicate]
        , [i].[IsInferredMember]
        , [i].[IsException]
        , [i].[IsHealthy]
        , [i].[IsRejected]
        , [i].[IsAllowed]
        , [i].[IsFixed]
        , [i].[SourceSystemKey]
        , [i].[RuleKey]
        , [i].[DataQualityAuditKey]
        , [i].[IsNewDQA]
        , [i].[IsValidated]
        , [i].[IsLoaded]
        , [i].[CDC_Operation]
        , [i].[DiscStyleSSID]
        , [i].[SFDC_TaskID]
        , [i].[SFDC_LeadID]
        , [i].[SFDC_PersonAccountID]
      FROM [Inserted] AS [i] ) AS [k] ;
GO
DISABLE TRIGGER [bi_mktg_stage].[TRG_bi_mktg_stage_DimActivityDemographic_Log] ON [bi_mktg_stage].[DimActivityDemographic] ;
GO
ENABLE TRIGGER [bi_mktg_stage].[TRG_bi_mktg_stage_DimActivityDemographic_Log] ON [bi_mktg_stage].[DimActivityDemographic] ;
GO

-- DROP TRIGGER [bi_mktg_stage].[TRG_bi_mktg_stage_DimActivityDemographic_Log]
GO
/*
SET XACT_ABORT ON 
BEGIN TRANSACTION ;

UPDATE [k]
SET [k].[CDC_Operation] = 'x'
FROM( SELECT TOP 10 * FROM [bi_mktg_stage].[DimActivityDemographic] AS [k] ) AS [k] ;

SELECT *
FROM [Audit].[bi_mktg_stage_DimActivityDemographic] ;

ROLLBACK ;
*/
GO
RETURN ;

SELECT ',' + CASE WHEN [collation_name] <> '' THEN 'LTRIM(RTRIM(' + QUOTENAME([name]) + ')) as ' + QUOTENAME([name])ELSE QUOTENAME([name])END
FROM [sys].[columns]
WHERE [object_id] = OBJECT_ID('[bi_mktg_stage].[DimActivityDemographic]')
ORDER BY [column_id] ;