-- SQL05
GO
USE [HC_BI_MKTG_DDS] ;
GO
CREATE SCHEMA [Audit] ;
GO
-- DROP TRIGGER [bi_mktg_stage].[TRG_bi_mktg_dds_DimActivityDemographic_Log]
-- DROP TABLE [Audit].[bi_mktg_dds_DimActivityDemographic]
--CREATE TABLE [bi_mktg_dds].[DimActivityDemographic]

CREATE TABLE [Audit].[bi_mktg_dds_DimActivityDemographic]
(
    [LogId]                    INT            NOT NULL
  , [LogUser]                  VARCHAR(1000)  NOT NULL
  , [LogAppName]               VARCHAR(1000)  NOT NULL
  , [LogDate]                  DATETIME2(7)   NOT NULL
  , [Action]                   CHAR(1)        NOT NULL
  , [ActivityDemographicKey]   [INT]          NOT NULL
  , [ActivityDemographicSSID]  [VARCHAR](10)  NULL
  , [ActivitySSID]             [VARCHAR](10)  NULL
  , [ContactSSID]              [VARCHAR](10)  NULL
  , [GenderSSID]               [CHAR](1)      NOT NULL
  , [GenderDescription]        [VARCHAR](50)  NOT NULL
  , [EthnicitySSID]            [VARCHAR](10)  NOT NULL
  , [EthnicityDescription]     [VARCHAR](50)  NOT NULL
  , [OccupationSSID]           [VARCHAR](10)  NOT NULL
  , [OccupationDescription]    [VARCHAR](50)  NOT NULL
  , [MaritalStatusSSID]        [VARCHAR](10)  NOT NULL
  , [MaritalStatusDescription] [VARCHAR](50)  NOT NULL
  , [Birthday]                 [DATE]         NOT NULL
  , [Age]                      [INT]          NOT NULL
  , [AgeRangeSSID]             [VARCHAR](10)  NOT NULL
  , [AgeRangeDescription]      [VARCHAR](50)  NOT NULL
  , [HairLossTypeSSID]         [VARCHAR](50)  NOT NULL
  , [HairLossTypeDescription]  [VARCHAR](50)  NOT NULL
  , [NorwoodSSID]              [VARCHAR](50)  NOT NULL
  , [LudwigSSID]               [VARCHAR](50)  NOT NULL
  , [Performer]                [VARCHAR](50)  NOT NULL
  , [PriceQuoted]              [MONEY]        NOT NULL
  , [SolutionOffered]          [VARCHAR](100) NOT NULL
  , [NoSaleReason]             [VARCHAR](200) NOT NULL
  , [DateSaved]                [DATE]         NOT NULL
  , [RowIsCurrent]             [TINYINT]      NOT NULL
  , [RowStartDate]             [DATETIME]     NOT NULL
  , [RowEndDate]               [DATETIME]     NOT NULL
  , [RowChangeReason]          [VARCHAR](200) NOT NULL
  , [RowIsInferred]            [TINYINT]      NOT NULL
  , [InsertAuditKey]           [INT]          NOT NULL
  , [UpdateAuditKey]           [INT]          NOT NULL
  , [RowTimeStamp]             BINARY(8)    NOT NULL
  , [DiscStyleSSID]            [NVARCHAR](10) NULL
  , [SFDC_TaskID]              [NVARCHAR](18) NULL
  , [SFDC_LeadID]              [NVARCHAR](18) NULL
  , [SFDC_PersonAccountID]     [NVARCHAR](18) NULL
) ;
GO
CREATE CLUSTERED INDEX [bi_mktg_dds_DimActivityDemographic_PKC] ON [Audit].[bi_mktg_dds_DimActivityDemographic]
( [LogId], [ActivityDemographicKey] ASC, [Action] ) ;
GO
-- DROP TRIGGER [bi_mktg_stage].[TRG_bi_mktg_dds_DimActivityDemographic_Log]
GO
CREATE TRIGGER [bi_mktg_dds].[TRG_bi_mktg_dds_DimActivityDemographic_Log]
ON [bi_mktg_dds].[DimActivityDemographic]
FOR INSERT, DELETE, UPDATE
AS
SET NOCOUNT ON ;

INSERT [Audit].[bi_mktg_dds_DimActivityDemographic]( [LogId]
                                                   , [LogUser]
                                                   , [LogAppName]
                                                   , [LogDate]
                                                   , [Action]
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
                                                   , [RowIsCurrent]
                                                   , [RowStartDate]
                                                   , [RowEndDate]
                                                   , [RowChangeReason]
                                                   , [RowIsInferred]
                                                   , [InsertAuditKey]
                                                   , [UpdateAuditKey]
                                                   , [RowTimeStamp]
                                                   , [DiscStyleSSID]
                                                   , [SFDC_TaskID]
                                                   , [SFDC_LeadID]
                                                   , [SFDC_PersonAccountID] )
SELECT
    ISNULL(( SELECT TOP 1 [LogId] + 1 FROM [Audit].[bi_mktg_dds_DimActivityDemographic] ORDER BY [LogId] DESC ), 1) AS [LogId]
  , SUSER_SNAME() AS [LogUser]
  , APP_NAME() AS [LogAppName]
  , GETDATE() AS [LogDate]
  , [k].[Action]
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
  , [k].[RowIsCurrent]
  , [k].[RowStartDate]
  , [k].[RowEndDate]
  , [k].[RowChangeReason]
  , [k].[RowIsInferred]
  , [k].[InsertAuditKey]
  , [k].[UpdateAuditKey]
  , [k].[RowTimeStamp]
  , [k].[DiscStyleSSID]
  , [k].[SFDC_TaskID]
  , [k].[SFDC_LeadID]
  , [k].[SFDC_PersonAccountID]
FROM( SELECT
          'D' AS [Action]
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
        , [RowIsCurrent]
        , [RowStartDate]
        , [RowEndDate]
        , [RowChangeReason]
        , [RowIsInferred]
        , [InsertAuditKey]
        , [UpdateAuditKey]
        , [RowTimeStamp]
        , [DiscStyleSSID]
        , [SFDC_TaskID]
        , [SFDC_LeadID]
        , [SFDC_PersonAccountID]
      FROM [Deleted] AS [d]
      UNION ALL
      SELECT
          'I' AS [Action]
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
        , [RowIsCurrent]
        , [RowStartDate]
        , [RowEndDate]
        , [RowChangeReason]
        , [RowIsInferred]
        , [InsertAuditKey]
        , [UpdateAuditKey]
        , [RowTimeStamp]
        , [DiscStyleSSID]
        , [SFDC_TaskID]
        , [SFDC_LeadID]
        , [SFDC_PersonAccountID]
      FROM [Inserted] AS [i] ) AS [k] ;
GO
DISABLE TRIGGER [bi_mktg_stage].[TRG_bi_mktg_dds_DimActivityDemographic_Log] ON [bi_mktg_stage].[DimActivityDemographic] ;
GO
ENABLE TRIGGER [bi_mktg_stage].[TRG_bi_mktg_dds_DimActivityDemographic_Log] ON [bi_mktg_stage].[DimActivityDemographic] ;
GO

-- DROP TRIGGER [bi_mktg_stage].[TRG_bi_mktg_dds_DimActivityDemographic_Log]
GO
/*
SET XACT_ABORT ON
BEGIN TRANSACTION ;

UPDATE [k]
SET [k].[ActivitySSID] = [ActivitySSID]
FROM( SELECT TOP 10 * FROM [bi_mktg_dds].[DimActivityDemographic] AS [k] ) AS [k] ;

SELECT *
FROM [Audit].[bi_mktg_dds_DimActivityDemographic] ;

ROLLBACK ;
*/
GO
RETURN ;

SELECT ',' + CASE WHEN [collation_name] <> '' THEN 'LTRIM(RTRIM(' + QUOTENAME([name]) + ')) as ' + QUOTENAME([name])ELSE QUOTENAME([name])END
FROM [sys].[columns]
WHERE [object_id] = OBJECT_ID('[bi_mktg_stage].[DimActivityDemographic]')
ORDER BY [column_id] ;
