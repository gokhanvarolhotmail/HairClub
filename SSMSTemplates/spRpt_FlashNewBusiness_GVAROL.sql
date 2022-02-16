USE [HC_BI_Reporting]
GO
-- https://hairclub.zendesk.com/agent/tickets/15293
-- Missing Inperson or virtual net sales are missing
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashNewBusiness
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB1 Flash
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		New Version - Rachelen Hut 12/12/2018
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers

01/07/2020 - RH - (TrackIT 4257) Added S_SurAmt
01/16/2020 - RH - Changed to SUM(CASE WHEN SC.SalesCodeDescription NOT LIKE 'Add-On%' THEN ISNULL(FST.NB_MDPAmt, 0) ELSE 0 END) for MDP Count and Amount (per Rev and MO)
01/23/2020 - RH - Returned NB_MDPCnt and NB_MDPAmt back to the original code since this issue has been fixed in the extract.
01/30/2020 - RH - Moved the code to add Laser count and amount further up in the stored procedure to correct the amount for NetNB1Sales in #Sales; also removed the code in the same section for #Sales that defined NB_MDPAmt since this was fixed in the extract.
03/11/2020 - RH - (TrackIT 7697) Added the new values S_PRPCnt and S_PRPAmt to Surgery totals, and to the #Sales table
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_FlashNewBusiness 'C', '11/01/2020', '11/30/2020', 3
EXEC spRpt_FlashNewBusiness 'C', '07/02/2021', '07/02/2021', 3
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FlashNewBusiness_GVAROL]
    @sType  CHAR(1)
  , @begdt  SMALLDATETIME
  , @enddt  SMALLDATETIME
  , @Filter INT
AS
SET FMTONLY OFF ;

SET NOCOUNT OFF ;

DECLARE @PartitionDate DATETIME =
        ( SELECT CAST(( CAST(MONTH(@begdt) AS VARCHAR(2)) + CAST('/1/' AS VARCHAR(3)) + CAST(YEAR(@begdt) AS VARCHAR(4))) AS DATETIME)) ;

/********************************** Create temp table objects *************************************/
CREATE TABLE [#Centers]
(
    [MainGroupID]             INT
  , [MainGroup]               VARCHAR(50)
  , [MainGroupSortOrder]      INT
  , [CenterNumber]            INT
  , [CenterSSID]              INT
  , [CenterDescription]       VARCHAR(50)
  , [CenterDescriptionNumber] VARCHAR(104)
) ;

CREATE TABLE [#Task]
(
    [FullDate]            DATETIME
  , [Id]                  NVARCHAR(18)
  , [CenterNumber]        INT
  , [Action__c]           NVARCHAR(50)
  , [Result__c]           NVARCHAR(50)
  , [SourceCode]          NVARCHAR(50)
  , [Accomodation]        NVARCHAR(50)
  , [ExcludeFromConsults] INT
  , [ExcludeFromBeBacks]  INT
  , [BeBacksToExclude]    INT
) ;

CREATE TABLE [#Consultations]
(
    [CenterNumber]          INT
  , [ActivityKey]           INT
  , [ActionCodeSSID]        NVARCHAR(10)
  , [ResultCodeSSID]        NVARCHAR(10)
  , [ActivityDate]          DATETIME
  , [Consultations]         INT
  , [InPersonConsultations] INT
  , [VirtualConsultations]  INT
  , [ExcludeFromConsults]   BIT
) ;

CREATE TABLE [#BeBacks]
(
    [CenterNumber]        INT
  , [ActivityKey]         INT
  , [ActionCodeSSID]      NVARCHAR(10)
  , [ResultCodeSSID]      NVARCHAR(10)
  , [ActivityDate]        DATETIME
  , [BeBacks]             INT
  , [ExcludeFromConsults] BIT
  , [ExcludeFromBeBacks]  BIT
) ;

CREATE TABLE [#Referrals] ( [CenterNumber] INT, [ActivityKey] INT, [ActionCodeSSID] NVARCHAR(10), [ResultCodeSSID] NVARCHAR(10), [ActivityDate] DATETIME, [Referrals] INT ) ;

CREATE TABLE [#NB_ARBalance] ( [CenterNumber] INT, [NB_ARBalance] MONEY ) ;

CREATE TABLE [#Sales]
(
    [CenterNumber]    INT
  , [NB1Applications] INT
  , [GrossNB1Count]   INT
  , [NetNB1Count]     INT
  , [NetNB1Sales]     INT
  , [NetTradCount]    INT
  , [NetTradSales]    DECIMAL(18, 4)
  , [NetEXTCount]     INT
  , [NetEXTSales]     DECIMAL(18, 4)
  , [NetXtrCount]     INT --Added 11/7/2014 RH
  , [NetXtrSales]     DECIMAL(18, 4)
  , [NetGradCount]    INT
  , [NetGradSales]    DECIMAL(18, 4)
  , [SurgeryCount]    INT
  , [SurgerySales]    DECIMAL(18, 4)
  , [PostEXTCount]    INT
  , [PostEXTSales]    DECIMAL(18, 4)
  , [ClientARBalance] DECIMAL(18, 4)
  , [NB_MDPCnt]       INT
  , [NB_MDPAmt]       DECIMAL(18, 4)
  , [LaserCnt]        INT
  , [LaserAmt]        DECIMAL(18, 4)
  , [S_PRPCnt]        INT
  , [S_PRPAmt]        DECIMAL(18, 4)
) ;

CREATE TABLE [#Budget] ( [CenterNumber] INT, [PartitionDate] DATETIME, [AccountID] INT, [NBNetCnt_InclPEXT_Budget] INT, [NBNetAMT_InclPEXT_Budget] DECIMAL(18, 4)) ;

CREATE TABLE [#SUM_Budget] ( [CenterNumber] INT, [PartitionDate] DATETIME, [NBNetCnt_InclPEXT_Budget] INT, [NBNetAMT_InclPEXT_Budget] DECIMAL(18, 4)) ;

/********************************** Get list of centers *************************************/
IF @sType = 'C' AND @Filter = 2 --By Area Managers
    BEGIN
        INSERT INTO [#Centers]
        SELECT
            [cma].[CenterManagementAreaSSID] AS [MainGroupID]
          , [cma].[CenterManagementAreaDescription] AS [MainGroup]
          , [cma].[CenterManagementAreaSortOrder] AS [MainGroupSortOrder]
          , [dc].[CenterNumber]
          , [dc].[CenterSSID]
          , [dc].[CenterDescription]
          , [dc].[CenterDescriptionNumber]
        FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [dc]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [CT] ON [CT].[CenterTypeKey] = [dc].[CenterTypeKey]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterManagementArea] AS [cma] ON [dc].[CenterManagementAreaSSID] = [cma].[CenterManagementAreaSSID]
        WHERE [dc].[Active] = 'Y' AND [cma].[Active] = 'Y' AND [CT].[CenterTypeDescriptionShort] IN ('C', 'HW') ;
    END ;

IF @sType = 'C' AND @Filter = 3 -- By Centers
    BEGIN
        INSERT INTO [#Centers]
        SELECT
            [dc].[CenterNumber] AS [MainGroupID]
          , [dc].[CenterDescriptionNumber] AS [MainGroup]
          , [dc].[CenterNumber] AS [MainGroupSortOrder]
          , [dc].[CenterNumber]
          , [dc].[CenterSSID]
          , [dc].[CenterDescription]
          , [dc].[CenterDescriptionNumber]
        FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [dc]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [CT] ON [CT].[CenterTypeKey] = [dc].[CenterTypeKey]
        WHERE [dc].[Active] = 'Y' AND [CT].[CenterTypeDescriptionShort] IN ('C', 'HW') ;
    END ;

IF @sType = 'F' --Always By Regions for Franchises
    BEGIN
        INSERT INTO [#Centers]
        SELECT
            [dr].[RegionSSID] AS [MainGroupID]
          , [dr].[RegionDescription] AS [MainGroup]
          , [dr].[RegionSortOrder] AS [MainGroupSortOrder]
          , [dc].[CenterNumber]
          , [dc].[CenterSSID]
          , [dc].[CenterDescription]
          , [dc].[CenterDescriptionNumber]
        FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [dc]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [CT] ON [CT].[CenterTypeKey] = [dc].[CenterTypeKey]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimRegion] AS [dr] ON [dc].[RegionSSID] = [dr].[RegionSSID]
        WHERE [CT].[CenterTypeDescriptionShort] IN ('F', 'JV') AND [dc].[Active] = 'Y' ;
    END ;

/********************************** Get Task data *************************************/
INSERT INTO [#Task]
SELECT
    CAST([t].[ActivityDate] AS DATE) AS [FullDate]
  , [t].[Id]
  , ISNULL(ISNULL([t].[CenterNumber__c], [t].[CenterID__c]), 100)
  , [t].[Action__c]
  , [t].[Result__c]
  , [t].[SourceCode__c]
  , [t].[Accommodation__c]
  , CASE WHEN (( [t].[Action__c] = 'Be Back'
               OR [t].[SourceCode__c] IN ('REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF', 'BOSBIOEMREF', 'BOSNCREF'
                                        , '4Q2016LWEXLD', 'REFEROTHER', 'IPREFCLRERECA12476', 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF'
                                        , 'IPREFCLRERECA12476DP', 'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'))
              AND [t].[ActivityDate] < '12/1/2020' ) THEN 1
        ELSE 0
    END AS [ExcludeFromConsults]
  , CASE WHEN [t].[SourceCode__c] IN ('CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF', 'BOSBIOEMREF', 'BOSBIODMREF'
                                      , '4Q2016LWEXLD', 'REFEROTHER')
         AND [t].[ActivityDate] < '12/1/2020' THEN 1 ELSE 0 END AS [ExcludeFromBeBacks]
  , CASE WHEN ( [t].[Action__c] = 'Be Back' AND [t].[ActivityDate] < '12/1/2020' ) THEN 1 ELSE 0 END AS [BeBacksToExclude]
FROM [HC_BI_SFDC].[dbo].[Task] AS [t] -----??? sf new dfinition
WHERE LTRIM(RTRIM([t].[Action__c])) IN ('Appointment', 'Be Back', 'In House', 'Recovery')
  AND CAST([t].[ActivityDate] AS DATE) BETWEEN @begdt AND @enddt
  AND ISNULL([t].[IsDeleted], 0) = 0
OPTION( RECOMPILE ) ;

CREATE NONCLUSTERED INDEX [IDX_Task_FullDate] ON [#Task]( [FullDate] ) ;

CREATE NONCLUSTERED INDEX [IDX_Task_Id] ON [#Task]( [Id] ) ;

CREATE NONCLUSTERED INDEX [IDX_Task_CenterNumber] ON [#Task]( [CenterNumber] ) ;

CREATE NONCLUSTERED INDEX [IDX_Task_Action__c] ON [#Task]( [Action__c] ) ;

CREATE NONCLUSTERED INDEX [IDX_Task_Result__c] ON [#Task]( [Result__c] ) ;

CREATE NONCLUSTERED INDEX [IDX_Task_SourceCode] ON [#Task]( [SourceCode] ) ;

UPDATE STATISTICS [#Task] ;

/********************************** Get consultations and bebacks *************************************/
/*INSERT  INTO #Consultations
		SELECT	DC.CenterNumber
		,		A.ActivityKey
		,		A.ActionCodeSSID
		,		A.ResultCodeSSID
		,		DD.FullDate
		,		CASE WHEN Consultation = 1 THEN 1 ELSE 0 END AS 'Consultations'
		,		CASE WHEN ISNULL(FAR.Accomodation, 'In Person Consult') = 'In Person Consult' AND Consultation = 1 THEN 1 ELSE 0 END AS 'InPersonConsultations'
		,		CASE WHEN ISNULL(FAR.Accomodation, 'In Person Consult') <> 'In Person Consult' AND Consultation = 1 THEN 1 ELSE 0 END AS 'VirtualConsultations'
		,		CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5) THEN CASE WHEN DD.FullDate < '12/1/2020' THEN 0 ELSE 1 END END AS 'ExcludeFromConsults'
		FROM	HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON FAR.CenterKey = DC.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FAR.ActivityDueDateKey = DD.DateKey
				INNER JOIN #Centers CTR
					ON DC.CenterNumber = CTR.CenterNumber
				INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
					ON A.ActivityKey = FAR.ActivityKey
		WHERE	DD.FullDate BETWEEN @begdt AND @enddt
				AND FAR.Show = 1*/
INSERT INTO [#Consultations]
SELECT
    [t].[CenterNumber]
  , -1
  , -1
  , -1
  , [t].[FullDate]
  , CASE WHEN ISNULL([t].[Result__c], '') IN ('Completed', 'Show Sale', 'Show No Sale')
         AND ISNULL([t].[ExcludeFromConsults], 0) = 0
         AND ISNULL([t].[Action__c], '') IN ('Appointment', 'In House', 'Recovery', 'be back') THEN 1 ELSE 0 END AS [Consultations]
  , CASE WHEN ( ISNULL([t].[Accomodation], 'In Person Consult') = 'In Person Consult' OR [t].[Accomodation] LIKE 'center%' OR [t].[Accomodation] = 'Company' )
          AND ISNULL([t].[Result__c], '') IN ('Completed', 'Show No Sale', 'Show Sale')
          AND ISNULL([t].[Action__c], '') IN ('Appointment', 'In House', 'Recovery', 'Be Back')
          AND
  --ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
  ISNULL([t].[ExcludeFromConsults], 0) = 0 THEN 1
        ELSE 0
    END AS [InPersonConsultations]
  , CASE WHEN ( ISNULL([t].[Accomodation], 'In Person Consult') LIKE 'virtual%' OR ISNULL([t].[Accomodation], 'In Person Consult') LIKE 'Video%' )
          AND ISNULL([t].[Result__c], '') IN ('Completed', 'Show No Sale', 'Show Sale')
          AND ISNULL([t].[Action__c], '') IN ('Appointment', 'In House', 'Recovery', 'Be Back')
          AND
  -- ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
  ISNULL([t].[ExcludeFromConsults], 0) = 0 THEN 1
        ELSE 0
    END AS [VirtualConsultations]
  , [t].[ExcludeFromConsults]
FROM [#Task] AS [t] ;

/*
    INSERT INTO #BeBacks
    SELECT DC.CenterNumber
         , A.ActivityKey
         , A.ActionCodeSSID
         , A.ResultCodeSSID
         , DD.FullDate
         , CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5) THEN 1 ELSE 0 END AS 'BeBacks'
         , CASE WHEN DD.FullDate < '12/1/2020' THEN 0 ELSE 1 END                 AS 'ExcludeFromConsults'
         , CASE
               WHEN FAR.BOSRef = 1 THEN 1
               WHEN FAR.BOSOthRef = 1 THEN 1
               WHEN FAR.HCRef = 1 THEN 1
               ELSE 0
        END                                                                      AS 'ExcludeFromBeBacks'
    FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
             INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                        ON FAR.CenterKey = DC.CenterKey
             INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                        ON FAR.ActivityDueDateKey = DD.DateKey
             INNER JOIN #Centers CTR
                        ON DC.CenterNumber = CTR.CenterNumber
             INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
                        ON A.ActivityKey = FAR.ActivityKey
    WHERE DD.FullDate BETWEEN @begdt AND @enddt
      AND FAR.Show = 1
*/
INSERT INTO [#BeBacks]
SELECT
    [t].[CenterNumber]
  , -1
  , -1
  , -1
  , [t].[FullDate]
  , CASE WHEN [t].[Action__c] IN ('Be Back')
          AND ISNULL([t].[Result__c], '') IN ('BB Manual Credit', 'No Show', 'Show No Sale', 'Show Sale', 'Completed', 'Scheduled', 'No_Show', 'Confirmed')
          AND ISNULL([t].[ExcludeFromBeBacks], 0) = 0 THEN 1
        ELSE 0
    END AS [BeBacks]
  , [t].[ExcludeFromConsults]
  , [t].[ExcludeFromBeBacks]
FROM [#Task] AS [t] ;

/*
    INSERT INTO #Referrals
    SELECT CTR.CenterNumber
         , A.ActivityKey
         , A.ActionCodeSSID
         , A.ResultCodeSSID
         , DD.FullDate
         , CASE
               WHEN FAR.BOSRef = 1 THEN 1
               WHEN FAR.BOSOthRef = 1 THEN 1
               WHEN FAR.HCRef = 1 THEN 1
               ELSE 0
        END AS 'Referrals'
    FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
             INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                        ON FAR.CenterKey = DC.CenterKey
             INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                        ON FAR.ActivityDueDateKey = DD.DateKey
             INNER JOIN #Centers CTR
                        ON DC.CenterNumber = CTR.CenterNumber
             INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
                        ON A.ActivityKey = FAR.ActivityKey
             INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
                        ON DS.SourceKey = FAR.SourceKey
    WHERE DD.FullDate BETWEEN @begdt AND @enddt
      AND DS.Media IN ('Referrals', 'Referral')
      AND FAR.Show = 1
      AND FAR.BOSAppt <> 1
      AND DS.OwnerType <> 'Bosley Consult'

*/
INSERT INTO [#Referrals]
SELECT
    [t].[CenterNumber]
  , -1
  , -1
  , -1
  , [t].[FullDate]
  , 1 AS [Referrals]
FROM [#Task] AS [t]
WHERE [t].[SourceCode] IN ('CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'BOSDMREF', 'BOSREF', 'BOSNCREF', 'REFEROTHER', 'IPREFCLRERECA12476'
                         , 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP', 'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF'
                         , 'IPREFCLRERECA12476MP', 'bosref', 'other-bos') ;

/******************************** Get New Business AR balances *************************************/
INSERT INTO [#NB_ARBalance]
SELECT DISTINCT
       [s].[CenterNumber]
     , SUM([s].[NB_ARBalance]) AS [NB_ARBalance]
FROM( SELECT
          [c].[CenterNumber]
        , [c].[CenterDescription]
        , [CLT].[ClientIdentifier]
        , [CLT].[ClientKey]
        , [CLT].[ClientLastName]
        , [CLT].[ClientFirstName]
        , [M].[MembershipDescription]
        , [currentclient].[ClientMembershipKey]
        , [CLT].[ClientARBalance] AS [NB_ARBalance]
      FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimClient] AS [CLT]
      INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [c] ON [CLT].[CenterSSID] = [c].[CenterSSID]
      INNER JOIN [#Centers] AS [CTR] ON [CTR].[CenterNumber] = [c].[CenterNumber]
      OUTER APPLY( SELECT
                       [ClientIdentifier]
                     , [CenterSSID]
                     , [Membership]
                     , [ClientMembershipKey]
                     , [RevenueGroupSSID]
                   FROM [dbo].fnGetCurrentMembershipDetailsByClientKey([CLT].[ClientKey]) ) AS [currentclient]
      INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] AS [M] ON [currentclient].[ClientMembershipKey] = [M].[MembershipKey]
      WHERE [CLT].[ClientARBalance] > 0 AND [M].[RevenueGroupDescription] = 'New Business' ) AS [s]
GROUP BY [s].[CenterNumber] ;

/********************************** Get sales data *************************************************/
INSERT INTO [#Sales]
SELECT DISTINCT
       [c].[CenterNumber]
     , SUM(ISNULL([FST].[NB_AppsCnt], 0)) AS [NB1Applications]
     , SUM(ISNULL([FST].[NB_GrossNB1Cnt], 0)) + SUM(ISNULL([FST].[NB_MDPCnt], 0)) AS [GrossNB1Count]
     , ( SUM(ISNULL([FST].[NB_TradCnt], 0)) + SUM(ISNULL([FST].[NB_GradCnt], 0)) + SUM(ISNULL([FST].[NB_ExtCnt], 0)) + SUM(ISNULL([FST].[S_PostExtCnt], 0))
         + SUM(ISNULL([FST].[NB_XTRCnt], 0)) + SUM(ISNULL([FST].[S_SurCnt], 0)) + SUM(ISNULL([FST].[NB_MDPCnt], 0)) + SUM(ISNULL([FST].[S_PRPCnt], 0))) AS [NetNB1Count] --No Laser count here per Rev
     , ( SUM(ISNULL([FST].[NB_TradAmt], 0)) + SUM(ISNULL([FST].[NB_GradAmt], 0)) + SUM(ISNULL([FST].[NB_ExtAmt], 0)) + SUM(ISNULL([FST].[S_PostExtAmt], 0))
         + SUM(ISNULL([FST].[NB_XTRAmt], 0)) + SUM(ISNULL([FST].[NB_MDPAmt], 0)) + SUM(ISNULL([FST].[S_SurAmt], 0)) + SUM(ISNULL([FST].[NB_LaserAmt], 0))
         + SUM(ISNULL([FST].[S_PRPAmt], 0))) AS [NetNB1Sales]
     , SUM(ISNULL([FST].[NB_TradCnt], 0)) AS [NetTradCount]
     , SUM(ISNULL([FST].[NB_TradAmt], 0)) AS [NetTradSales]
     , SUM(ISNULL([FST].[NB_ExtCnt], 0)) AS [NetEXTCount]
     , SUM(ISNULL([FST].[NB_ExtAmt], 0)) AS [NetEXTSales]
     , SUM(ISNULL([FST].[NB_XTRCnt], 0)) AS [NetXtrCount]
     , SUM(ISNULL([FST].[NB_XTRAmt], 0)) AS [NetXtrSales]
     , SUM(ISNULL([FST].[NB_GradCnt], 0)) AS [NetGradCount]
     , SUM(ISNULL([FST].[NB_GradAmt], 0)) AS [NetGradSales]
     , SUM(ISNULL([FST].[S_SurCnt], 0)) + SUM(ISNULL([FST].[S_PRPCnt], 0)) AS [SurgeryCount]
     , SUM(ISNULL([FST].[S_SurAmt], 0)) + SUM(ISNULL([FST].[S_PRPAmt], 0)) AS [SurgerySales]
     , SUM(ISNULL([FST].[S_PostExtCnt], 0)) AS [PostEXTCount]
     , SUM(ISNULL([FST].[S_PostExtAmt], 0)) AS [PostEXTSales]
     , SUM(ISNULL([CLT].[ClientARBalance], 0)) AS [ClientARBalance]
     , SUM(ISNULL([FST].[NB_MDPCnt], 0)) AS [NB_MDPCnt]
     , SUM(ISNULL([FST].[NB_MDPAmt], 0)) AS [NB_MDPAmt]
     , SUM(ISNULL([FST].[NB_LaserCnt], 0)) AS [LaserCnt]
     , SUM(ISNULL([FST].[NB_LaserAmt], 0)) AS [LaserAmt]
     , SUM(ISNULL([FST].[S_PRPCnt], 0)) AS [S_PRPCnt]
     , SUM(ISNULL([FST].[S_PRPAmt], 0)) AS [S_PRPAmt]
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] AS [FST]
INNER JOIN [HC_BI_ENT_DDS].[bief_dds].[DimDate] AS [DD] ON [FST].[OrderDateKey] = [DD].[DateKey]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesCode] AS [SC] ON [FST].[SalesCodeKey] = [SC].[SalesCodeKey]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] AS [SO] ON [FST].[SalesOrderKey] = [SO].[SalesOrderKey]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrderDetail] AS [SOD] ON [FST].[SalesOrderDetailKey] = [SOD].[SalesOrderDetailKey]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimClientMembership] AS [CM] ON [SO].[ClientMembershipKey] = [CM].[ClientMembershipKey]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] AS [m] ON [CM].[MembershipKey] = [m].[MembershipKey]
INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [c] --Keep HomeCenter-based
    ON [CM].[CenterKey] = [c].[CenterKey]
INNER JOIN [#Centers] ON [c].[CenterNumber] = [#Centers].[CenterNumber]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimClient] AS [CLT] ON [FST].[ClientKey] = [CLT].[ClientKey]
WHERE [DD].[FullDate] BETWEEN @begdt AND @enddt AND [SC].[SalesCodeKey] NOT IN (665, 654, 393, 668) AND [SO].[IsVoidedFlag] = 0
GROUP BY [c].[CenterNumber]
OPTION( RECOMPILE ) ;

/********************************** Get budget data *************************************************/

--Description
--10231 - NB - Net Sales (Incl PEXT) #
--10233 - NB - Net Sales (Incl PEXT) $
INSERT INTO [#Budget]
SELECT DISTINCT
       [CTR].[CenterNumber]
     , [FA].[PartitionDate]
     , [FA].[AccountID]
     , CASE WHEN [FA].[AccountID] = 10231 THEN SUM(ISNULL([FA].[Budget], 0))ELSE 0 END AS [NBNetCnt_InclPEXT_Budget]
     , CASE WHEN [FA].[AccountID] = 10233 THEN SUM(ISNULL([FA].[Budget], 0))ELSE 0 END AS [NBNetAMT_InclPEXT_Budget]
FROM [HC_Accounting].[dbo].[FactAccounting] AS [FA]
INNER JOIN [#Centers] AS [CTR] ON [FA].[CenterID] = [CTR].[CenterNumber]
WHERE [FA].[PartitionDate] = @PartitionDate AND [FA].[AccountID] IN (10231, 10233)
GROUP BY [CTR].[CenterNumber]
       , [FA].[PartitionDate]
       , [FA].[AccountID]
OPTION( RECOMPILE ) ;

INSERT INTO [#SUM_Budget]
SELECT DISTINCT
       [b].[CenterNumber]
     , [b].[PartitionDate]
     , SUM([b].[NBNetCnt_InclPEXT_Budget]) AS [NBNetCnt_InclPEXT_Budget]
     , SUM([b].[NBNetAMT_InclPEXT_Budget]) AS [NBNetAMT_InclPEXT_Budget]
FROM [#Budget] AS [b]
GROUP BY [b].[CenterNumber]
       , [b].[PartitionDate] ;

/********************************** Display By Main Group/Center *************************************/
SELECT
    CASE WHEN [CT].[CenterTypeDescriptionShort] = 'C' THEN 'Corporate' WHEN [CT].[CenterTypeDescriptionShort] = 'HW' THEN 'Total Hair Solutions' ELSE
                                                                                                                                                 'Franchise' END AS [TYPE]
  , CASE WHEN [CT].[CenterTypeDescriptionShort] = 'C' THEN 1 WHEN [CT].[CenterTypeDescriptionShort] = 'HW' THEN 3 ELSE 2 END AS [TypeID]
  , [c].[MainGroupID]
  , [c].[MainGroup]
  , [c].[MainGroupSortOrder]
  , [c].[CenterNumber] AS [CenterID]
  , [c].[CenterDescription]
  , [c].[CenterDescriptionNumber] AS [CenterDescriptionNumber]
  , ISNULL([o_C].[Consultations], 0) AS [consultations]
  , ISNULL([o_B].[BeBacks], 0) AS [BeBacks]
  , ISNULL([o_C].[BeBacksToExclude], 0) AS [BeBacksToExclude]
  , ( ISNULL([o_C].[Consultations], 0) - ISNULL([o_B].[BeBacks], 0)) AS [FirstTimeConsultations]
  , ISNULL([o_C].[InPersonConsultations], 0) AS [InPersonConsultations]
  , ISNULL([o_C].[VirtualConsultations], 0) AS [VirtualConsultations]
  , ISNULL([o_R].[Referrals], 0) AS [Referrals]
  , ISNULL([s].[GrossNB1Count], 0) AS [GrossNB1Count]
  , ISNULL([s].[NetNB1Count], 0) AS [NetNB1Count]
  , ISNULL([s].[NetNB1Sales], 0) AS [NetNB1Sales]
  , ISNULL([s].[NetTradCount], 0) + ISNULL([s].[NetGradCount], 0) AS [NetXPCount]
  , ISNULL([s].[NetTradSales], 0) + ISNULL([s].[NetGradSales], 0) AS [NetXPSales]
  , ISNULL([s].[NetEXTCount], 0) + ISNULL([s].[PostEXTCount], 0) AS [NetEXTCount]
  , ISNULL([s].[NetEXTSales], 0) + ISNULL([s].[PostEXTSales], 0) AS [NetEXTSales]
  , ISNULL([s].[NetXtrCount], 0) AS [NetXtrCount]
  , ISNULL([s].[NetXtrSales], 0) AS [NetXtrSales]
  , ISNULL([s].[SurgeryCount], 0) AS [SurgeryCount]
  , ISNULL([s].[SurgerySales], 0) AS [SurgerySales]
  , ISNULL([s].[PostEXTCount], 0) AS [PostEXTCount]
  , ISNULL([s].[PostEXTSales], 0) AS [PostEXTSales]
  , ISNULL([s].[NB1Applications], 0) AS [NB1Applications]
  , [dbo].[DIVIDE_DECIMAL](ISNULL([s].[NetNB1Sales], 0), ISNULL([s].[NetNB1Count], 0)) AS [per_nb1_revenue]
  , [dbo].[DIVIDE_DECIMAL](ISNULL([s].[NetNB1Count], 0), ( ISNULL([o_C].[Consultations], 0) - ISNULL([o_B].[BeBacks], 0))) AS [close_pct]
  , [dbo].[DIVIDE](
        ( ISNULL([s].[NetTradCount], 0) + ISNULL([s].[NetGradCount], 0))
      , ( ISNULL([s].[NetTradCount], 0) + ISNULL([s].[NetGradCount], 0) + ISNULL([s].[NetEXTCount], 0) + ISNULL([s].[PostEXTCount], 0)
          + ISNULL([s].[NetXtrCount], 0) + ISNULL([s].[NB_MDPCnt], 0))) AS [per_Bio]
  , [dbo].[DIVIDE](
        ( ISNULL([s].[NetEXTCount], 0) + ISNULL([s].[PostEXTCount], 0))
      , ( ISNULL([s].[NetTradCount], 0) + ISNULL([s].[NetGradCount], 0) + ISNULL([s].[NetEXTCount], 0) + ISNULL([s].[PostEXTCount], 0)
          + ISNULL([s].[NetXtrCount], 0) + ISNULL([s].[NB_MDPCnt], 0))) AS [per_EXT]
  , [dbo].[DIVIDE](
        ( ISNULL([s].[SurgeryCount], 0))
      , ( ISNULL([s].[NetTradCount], 0) + ISNULL([s].[NetGradCount], 0) + ISNULL([s].[NetEXTCount], 0) + ISNULL([s].[PostEXTCount], 0)
          + ISNULL([s].[NetXtrCount], 0) + ISNULL([s].[SurgeryCount], 0) + ISNULL([s].[NB_MDPCnt], 0))) AS [per_Sur]
  , [dbo].[DIVIDE](
        ISNULL([s].[NetXtrCount], 0)
      , ( ISNULL([s].[NetTradCount], 0) + ISNULL([s].[NetGradCount], 0) + ISNULL([s].[NetEXTCount], 0) + ISNULL([s].[PostEXTCount], 0)
          + ISNULL([s].[SurgeryCount], 0) + ISNULL([s].[NetXtrCount], 0) + ISNULL([s].[NB_MDPCnt], 0))) AS [per_Xtr]
  , [dbo].[DIVIDE](
        ISNULL([s].[NB_MDPCnt], 0)
      , ( ISNULL([s].[NetTradCount], 0) + ISNULL([s].[NetGradCount], 0) + ISNULL([s].[NetEXTCount], 0) + ISNULL([s].[PostEXTCount], 0)
          + ISNULL([s].[SurgeryCount], 0) + ISNULL([s].[NetXtrCount], 0) + ISNULL([s].[NB_MDPCnt], 0))) AS [per_MDP]
  , ISNULL([NB].[NB_ARBalance], 0) AS [NB_ARBalance]
  , ISNULL([s].[NB_MDPCnt], 0) AS [NB_MDPCnt]
  , ISNULL([s].[NB_MDPAmt], 0) AS [NB_MDPAmt]
  , ISNULL([s].[LaserCnt], 0) AS [LaserCnt]
  , ISNULL([s].[LaserAmt], 0) AS [LaserAmt]
  , ISNULL([BUD].[NBNetCnt_InclPEXT_Budget], 0) AS [NBNetCnt_InclPEXT_Budget]
  , ISNULL([BUD].[NBNetAMT_InclPEXT_Budget], '0.00') AS [NBNetAMT_InclPEXT_Budget]
  , ISNULL([s].[S_PRPCnt], 0) AS [S_PRPCnt]
  , ISNULL([s].[S_PRPAmt], 0) AS [S_PRPAmt]
FROM [#Centers] AS [c]
INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [CTR] ON [c].[CenterSSID] = [CTR].[CenterSSID]
INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [CT] ON [CTR].[CenterTypeKey] = [CT].[CenterTypeKey]
LEFT OUTER JOIN [#Sales] AS [s] ON [s].[CenterNumber] = [c].[CenterNumber]
LEFT OUTER JOIN [#NB_ARBalance] AS [NB] ON [NB].[CenterNumber] = [c].[CenterNumber]
LEFT OUTER JOIN [#SUM_Budget] AS [BUD] ON [c].[CenterNumber] = [BUD].[CenterNumber]
OUTER APPLY( SELECT
                 SUM(ISNULL([cons].[Consultations], 0)) AS [Consultations]
               , SUM(ISNULL([cons].[InPersonConsultations], 0)) AS [InPersonConsultations]
               , SUM(ISNULL([cons].[VirtualConsultations], 0)) AS [VirtualConsultations]
               , SUM(CASE WHEN ISNULL([cons].[ExcludeFromConsults], 0) = 1 THEN 1 ELSE 0 END) AS [BeBacksToExclude]
             FROM [#Consultations] AS [cons]
             WHERE [cons].[CenterNumber] = [c].[CenterNumber] ) AS [o_C]
OUTER APPLY( SELECT SUM(CASE WHEN [bb].[BeBacks] = 1 THEN 1 ELSE 0 END) AS [BeBacks] FROM [#BeBacks] AS [bb] WHERE [bb].[CenterNumber] = [c].[CenterNumber] ) AS [o_B]
OUTER APPLY( SELECT SUM(ISNULL([r].[Referrals], 0)) AS [Referrals] FROM [#Referrals] AS [r] WHERE [r].[CenterNumber] = [c].[CenterNumber] ) AS [o_R] ;
GO
