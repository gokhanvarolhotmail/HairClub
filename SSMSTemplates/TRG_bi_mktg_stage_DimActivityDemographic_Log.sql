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
    [LogId]                    INT              NOT NULL
  , [LogUser]                  VARCHAR(8000)    NOT NULL
  , [LogAppName]               VARCHAR(8000)    NOT NULL
  , [LogDate]                  DATETIME2(7)     NOT NULL
  , [Action]                   VARCHAR(4000)    NOT NULL
  , [DataPkgKey]               [INT]            NULL
  , [ActivityDemographicKey]   [INT]            NULL
  , [ActivityDemographicSSID]  [VARCHAR](8000)  NULL
  , [ActivitySSID]             [VARCHAR](8000)  NULL
  , [ContactSSID]              [VARCHAR](8000)  NULL
  , [GenderSSID]               [VARCHAR](8000)  NULL
  , [GenderDescription]        [VARCHAR](8000)  NULL
  , [EthnicitySSID]            [VARCHAR](8000)  NULL
  , [EthnicityDescription]     [VARCHAR](8000)  NULL
  , [OccupationSSID]           [VARCHAR](8000)  NULL
  , [OccupationDescription]    [VARCHAR](8000)  NULL
  , [MaritalStatusSSID]        [VARCHAR](8000)  NULL
  , [MaritalStatusDescription] [VARCHAR](8000)  NULL
  , [Birthday]                 [DATE]           NULL
  , [Age]                      [INT]            NULL
  , [AgeRangeSSID]             [VARCHAR](8000)  NULL
  , [AgeRangeDescription]      [VARCHAR](8000)  NULL
  , [HairLossTypeSSID]         [VARCHAR](8000)  NULL
  , [HairLossTypeDescription]  [VARCHAR](8000)  NULL
  , [NorwoodSSID]              [VARCHAR](8000)  NULL
  , [LudwigSSID]               [VARCHAR](8000)  NULL
  , [Performer]                [VARCHAR](8000)  NULL
  , [PriceQuoted]              [MONEY]          NULL
  , [SolutionOffered]          [VARCHAR](8000)  NULL
  , [NoSaleReason]             [VARCHAR](8000)  NULL
  , [DateSaved]                [DATE]           NULL
  , [ModifiedDate]             [DATETIME]       NULL
  , [IsNew]                    [TINYINT]        NULL
  , [IsType1]                  [TINYINT]        NULL
  , [IsType2]                  [TINYINT]        NULL
  , [IsDelete]                 [TINYINT]        NULL
  , [IsDuplicate]              [TINYINT]        NULL
  , [IsInferredMember]         [TINYINT]        NULL
  , [IsException]              [TINYINT]        NULL
  , [IsHealthy]                [TINYINT]        NULL
  , [IsRejected]               [TINYINT]        NULL
  , [IsAllowed]                [TINYINT]        NULL
  , [IsFixed]                  [TINYINT]        NULL
  , [SourceSystemKey]          [NVARCHAR](4000) NULL
  , [RuleKey]                  [INT]            NULL
  , [DataQualityAuditKey]      [INT]            NULL
  , [IsNewDQA]                 [TINYINT]        NULL
  , [IsValidated]              [TINYINT]        NULL
  , [IsLoaded]                 [TINYINT]        NULL
  , [CDC_Operation]            [VARCHAR](8000)  NULL
  , [DiscStyleSSID]            [NVARCHAR](4000) NULL
  , [SFDC_TaskID]              [NVARCHAR](4000) NULL
  , [SFDC_LeadID]              [NVARCHAR](4000) NULL
  , [SFDC_PersonAccountID]     [NVARCHAR](4000) NULL
) ;
GO
CREATE CLUSTERED INDEX [bi_mktg_stage_DimActivityDemographic_PKC] ON [Audit].[bi_mktg_stage_DimActivityDemographic]( [LogId], [DataPkgKey], [Action] ) ;
GO
--DROP TRIGGER [bi_mktg_stage].[TRG_bi_mktg_stage_DimActivityDemographic_Log]
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
  , '' AS [LogUser]
  --, SUSER_SNAME() AS [LogUser]
  --, APP_NAME() AS [LogAppName]
  , '' AS [LogAppName]
  , GETDATE() AS [LogDate]
  , '' AS [Action]
  , NULL AS [DataPkgKey]
  , NULL AS [ActivityDemographicKey]
  , NULL AS [ActivityDemographicSSID]
  , NULL AS [ActivitySSID]
  , NULL AS [ContactSSID]
  , NULL AS [GenderSSID]
  , NULL AS [GenderDescription]
  , NULL AS [EthnicitySSID]
  , NULL AS [EthnicityDescription]
  , NULL AS [OccupationSSID]
  , NULL AS [OccupationDescription]
  , NULL AS [MaritalStatusSSID]
  , NULL AS [MaritalStatusDescription]
  , NULL AS [Birthday]
  , NULL AS [Age]
  , NULL AS [AgeRangeSSID]
  , NULL AS [AgeRangeDescription]
  , NULL AS [HairLossTypeSSID]
  , NULL AS [HairLossTypeDescription]
  , NULL AS [NorwoodSSID]
  , NULL AS [LudwigSSID]
  , NULL AS [Performer]
  , NULL AS [PriceQuoted]
  , NULL AS [SolutionOffered]
  , NULL AS [NoSaleReason]
  , NULL AS [DateSaved]
  , NULL AS [ModifiedDate]
  , NULL AS [IsNew]
  , NULL AS [IsType1]
  , NULL AS [IsType2]
  , NULL AS [IsDelete]
  , NULL AS [IsDuplicate]
  , NULL AS [IsInferredMember]
  , NULL AS [IsException]
  , NULL AS [IsHealthy]
  , NULL AS [IsRejected]
  , NULL AS [IsAllowed]
  , NULL AS [IsFixed]
  , NULL AS [SourceSystemKey]
  , NULL AS [RuleKey]
  , NULL AS [DataQualityAuditKey]
  , NULL AS [IsNewDQA]
  , NULL AS [IsValidated]
  , NULL AS [IsLoaded]
  , NULL AS [CDC_Operation]
  , NULL AS [DiscStyleSSID]
  , NULL AS [SFDC_TaskID]
  , NULL AS [SFDC_LeadID]
  , NULL AS [SFDC_PersonAccountID]
FROM( SELECT
          'D' AS [Action]
        , [d].[DataPkgKey]
        , [d].[ActivityDemographicKey]
        , LTRIM(RTRIM([d].[ActivityDemographicSSID])) AS [ActivityDemographicSSID]
        , LTRIM(RTRIM([d].[ActivitySSID])) AS [ActivitySSID]
        , LTRIM(RTRIM([d].[ContactSSID])) AS [ContactSSID]
        , LTRIM(RTRIM([d].[GenderSSID])) AS [GenderSSID]
        , LTRIM(RTRIM([d].[GenderDescription])) AS [GenderDescription]
        , LTRIM(RTRIM([d].[EthnicitySSID])) AS [EthnicitySSID]
        , LTRIM(RTRIM([d].[EthnicityDescription])) AS [EthnicityDescription]
        , LTRIM(RTRIM([d].[OccupationSSID])) AS [OccupationSSID]
        , LTRIM(RTRIM([d].[OccupationDescription])) AS [OccupationDescription]
        , LTRIM(RTRIM([d].[MaritalStatusSSID])) AS [MaritalStatusSSID]
        , LTRIM(RTRIM([d].[MaritalStatusDescription])) AS [MaritalStatusDescription]
        , [d].[Birthday]
        , [d].[Age]
        , LTRIM(RTRIM([d].[AgeRangeSSID])) AS [AgeRangeSSID]
        , LTRIM(RTRIM([d].[AgeRangeDescription])) AS [AgeRangeDescription]
        , LTRIM(RTRIM([d].[HairLossTypeSSID])) AS [HairLossTypeSSID]
        , LTRIM(RTRIM([d].[HairLossTypeDescription])) AS [HairLossTypeDescription]
        , LTRIM(RTRIM([d].[NorwoodSSID])) AS [NorwoodSSID]
        , LTRIM(RTRIM([d].[LudwigSSID])) AS [LudwigSSID]
        , LTRIM(RTRIM([d].[Performer])) AS [Performer]
        , [d].[PriceQuoted]
        , LTRIM(RTRIM([d].[SolutionOffered])) AS [SolutionOffered]
        , LTRIM(RTRIM([d].[NoSaleReason])) AS [NoSaleReason]
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
        , LTRIM(RTRIM([d].[SourceSystemKey])) AS [SourceSystemKey]
        , [d].[RuleKey]
        , [d].[DataQualityAuditKey]
        , [d].[IsNewDQA]
        , [d].[IsValidated]
        , [d].[IsLoaded]
        , LTRIM(RTRIM([d].[CDC_Operation])) AS [CDC_Operation]
        , LTRIM(RTRIM([d].[DiscStyleSSID])) AS [DiscStyleSSID]
        , LTRIM(RTRIM([d].[SFDC_TaskID])) AS [SFDC_TaskID]
        , LTRIM(RTRIM([d].[SFDC_LeadID])) AS [SFDC_LeadID]
        , LTRIM(RTRIM([d].[SFDC_PersonAccountID])) AS [SFDC_PersonAccountID]
      FROM [Deleted] AS [d]
      UNION ALL
      SELECT
          'I' AS [Action]
        , [i].[DataPkgKey]
        , [i].[ActivityDemographicKey]
        , LTRIM(RTRIM([i].[ActivityDemographicSSID])) AS [ActivityDemographicSSID]
        , LTRIM(RTRIM([i].[ActivitySSID])) AS [ActivitySSID]
        , LTRIM(RTRIM([i].[ContactSSID])) AS [ContactSSID]
        , LTRIM(RTRIM([i].[GenderSSID])) AS [GenderSSID]
        , LTRIM(RTRIM([i].[GenderDescription])) AS [GenderDescription]
        , LTRIM(RTRIM([i].[EthnicitySSID])) AS [EthnicitySSID]
        , LTRIM(RTRIM([i].[EthnicityDescription])) AS [EthnicityDescription]
        , LTRIM(RTRIM([i].[OccupationSSID])) AS [OccupationSSID]
        , LTRIM(RTRIM([i].[OccupationDescription])) AS [OccupationDescription]
        , LTRIM(RTRIM([i].[MaritalStatusSSID])) AS [MaritalStatusSSID]
        , LTRIM(RTRIM([i].[MaritalStatusDescription])) AS [MaritalStatusDescription]
        , [i].[Birthday]
        , [i].[Age]
        , LTRIM(RTRIM([i].[AgeRangeSSID])) AS [AgeRangeSSID]
        , LTRIM(RTRIM([i].[AgeRangeDescription])) AS [AgeRangeDescription]
        , LTRIM(RTRIM([i].[HairLossTypeSSID])) AS [HairLossTypeSSID]
        , LTRIM(RTRIM([i].[HairLossTypeDescription])) AS [HairLossTypeDescription]
        , LTRIM(RTRIM([i].[NorwoodSSID])) AS [NorwoodSSID]
        , LTRIM(RTRIM([i].[LudwigSSID])) AS [LudwigSSID]
        , LTRIM(RTRIM([i].[Performer])) AS [Performer]
        , [i].[PriceQuoted]
        , LTRIM(RTRIM([i].[SolutionOffered])) AS [SolutionOffered]
        , LTRIM(RTRIM([i].[NoSaleReason])) AS [NoSaleReason]
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
        , LTRIM(RTRIM([i].[SourceSystemKey])) AS [SourceSystemKey]
        , [i].[RuleKey]
        , [i].[DataQualityAuditKey]
        , [i].[IsNewDQA]
        , [i].[IsValidated]
        , [i].[IsLoaded]
        , LTRIM(RTRIM([i].[CDC_Operation])) AS [CDC_Operation]
        , LTRIM(RTRIM([i].[DiscStyleSSID])) AS [DiscStyleSSID]
        , LTRIM(RTRIM([i].[SFDC_TaskID])) AS [SFDC_TaskID]
        , LTRIM(RTRIM([i].[SFDC_LeadID])) AS [SFDC_LeadID]
        , LTRIM(RTRIM([i].[SFDC_PersonAccountID])) AS [SFDC_PersonAccountID]
      FROM [Inserted] AS [i] ) AS [k] ;
GO
DISABLE TRIGGER [bi_mktg_stage].[TRG_bi_mktg_stage_DimActivityDemographic_Log] ON [bi_mktg_stage].[DimActivityDemographic] ;
GO
ENABLE TRIGGER [bi_mktg_stage].[TRG_bi_mktg_stage_DimActivityDemographic_Log] ON [bi_mktg_stage].[DimActivityDemographic] ;
GO

--DROP TRIGGER [bi_mktg_stage].[TRG_bi_mktg_stage_DimActivityDemographic_Log]
GO
/*
SET XACT_ABORT ON 
BEGIN TRANSACTION ;

UPDATE [k]
SET [k].[CDC_Operation] = 'Test'
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