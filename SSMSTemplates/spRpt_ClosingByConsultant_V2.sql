/***********************************************************************
PROCEDURE:				spRpt_ClosingByConsultant
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Closing By Consultant
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		08/13/2012
------------------------------------------------------------------------
NOTES:
@CenterType = 1 for Corporate, 2 for Franchise, or CenterNumber

------------------------------------------------------------------------
CHANGE HISTORY:
01/06/2020 - RH - Uncommented SUM(ISNULL(FST.S_SurAmt, 0)) for NetNB1Sales
03/13/2020 - RH - TrackIT 7697 Added S_PRPCnt and S_PRPAmt to Surgery, NetNB1Count, NetNB1Sales
-----------------------------------------------------------------------
SAMPLE EXECUTION:


EXEC spRpt_ClosingByConsultant 1, '06/01/2021', '07/27/2021'
***********************************************************************/
ALTER PROCEDURE [dbo].[spRpt_ClosingByConsultant_V2]
    @CenterType INT
  , @StartDate  DATETIME
  , @EndDate    DATETIME
AS
SET FMTONLY OFF ;

/********************************** Create temp table objects *************************************/
CREATE TABLE [#Centers]
(
    [MainGroupID]                INT
  , [MainGroup]                  VARCHAR(50)
  , [MainGroupSortOrder]         INT
  , [CenterKey]                  INT
  , [CenterNumber]               INT
  , [CenterSSID]                 INT
  , [CenterDescription]          VARCHAR(50)
  , [CenterDescriptionNumber]    VARCHAR(104)
  , [CenterTypeDescriptionShort] VARCHAR(2)
) ;

CREATE TABLE [#Consultations]
(
    [ClientGUID]            UNIQUEIDENTIFIER
  , [MainGroup]             VARCHAR(50)
  , [CenterNumber]          INT
  , [ActivityKey]           INT
  , [ActionCodeSSID]        NVARCHAR(10)
  , [ResultCodeSSID]        NVARCHAR(10)
  , [ActivityDate]          DATE
  , [Performer]             NVARCHAR(50)
  , [Consultations]         INT
  , [InPersonConsultations] INT
  , [VirtualConsultations]  INT
  , [ExcludeFromConsults]   BIT
  , [Accommodation]         VARCHAR(50)
) ;

CREATE TABLE [#Task]
(
    [ClientGUID]          UNIQUEIDENTIFIER
  , [FullDate]            DATETIME
  , [Id]                  NVARCHAR(18)
  , [CenterNumber]        INT
  , [Action__c]           NVARCHAR(50)
  , [Result__c]           NVARCHAR(50)
  , [SourceCode]          NVARCHAR(50)
  , [Accommodation]       NVARCHAR(50)
  , [ExcludeFromConsults] INT
  , [ExcludeFromBeBacks]  INT
  , [BeBacksToExclude]    INT
  , [Performer]           NVARCHAR(150)
) ;

CREATE TABLE [#BeBacks]
(
    [MainGroup]           VARCHAR(50)
  , [CenterNumber]        INT
  , [ActivityKey]         INT
  , [ActionCodeSSID]      NVARCHAR(10)
  , [ResultCodeSSID]      NVARCHAR(10)
  , [ActivityDate]        DATE
  , [Performer]           NVARCHAR(50)
  , [BeBacks]             INT
  , [ExcludeFromConsults] BIT
  , [ExcludeFromBeBacks]  BIT
  , [Accommodation]       VARCHAR(50)
) ;

CREATE TABLE [#Referrals]
(
    [MainGroup]      VARCHAR(50)
  , [CenterNumber]   INT
  , [ActivityKey]    INT
  , [ActionCodeSSID] NVARCHAR(10)
  , [ResultCodeSSID] NVARCHAR(10)
  , [ActivityDate]   DATE
  , [Performer]      NVARCHAR(50)
  , [Referrals]      INT
  , [Accommodation]  VARCHAR(50)
) ;

CREATE TABLE [#CombinedData]
(
    [MainGroup]             VARCHAR(50)
  , [CenterNumber]          INT
  , [FullDate]              DATETIME
  , [EmployeeFullName]      NVARCHAR(250)
  , [Consultations]         INT
  , [BeBacks]               INT
  , [BeBacksToExclude]      INT
  , [Referrals]             INT
  , [NetNB1Count]           INT
  , [NetNB1Sales]           MONEY
  , [XTRPlus]               INT
  , [EXT]                   INT
  , [Xtrands]               INT
  , [Surgery]               INT
  , [NB_MDPCnt]             INT
  , [Accommodation]         VARCHAR(50)
  , [VirtualConsultations]  INT
  , [InPersonConsultations] INT
) ;

IF @CenterType = 1 --Corporate
    BEGIN
        INSERT INTO [#Centers]
        SELECT
            [CMA].[CenterManagementAreaSSID] AS [MainGroupID]
          , [CMA].[CenterManagementAreaDescription] AS [MainGroup]
          , [CMA].[CenterManagementAreaSortOrder] AS [MainGroupSortOrder]
          , [DC].[CenterKey]
          , [DC].[CenterNumber]
          , [DC].[CenterSSID]
          , [DC].[CenterDescription]
          , [DC].[CenterDescriptionNumber]
          , [DCT].[CenterTypeDescriptionShort]
        FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [DC]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [DCT] ON [DC].[CenterTypeKey] = [DCT].[CenterTypeKey]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterManagementArea] AS [CMA] ON [CMA].[CenterManagementAreaSSID] = [DC].[CenterManagementAreaSSID]
        WHERE [DCT].[CenterTypeDescriptionShort] = 'C' AND [DC].[Active] = 'Y'
        OPTION( RECOMPILE ) ;
    END ;
ELSE IF @CenterType = 2 --Franchise
    BEGIN
        INSERT INTO [#Centers]
        SELECT
            [DR].[RegionSSID] AS [MainGroupID]
          , [DR].[RegionDescription] AS [MainGroup]
          , [DR].[RegionSortOrder] AS [MainGroupSortOrder]
          , [DC].[CenterKey]
          , [DC].[CenterNumber]
          , [DC].[CenterSSID]
          , [DC].[CenterDescription]
          , [DC].[CenterDescriptionNumber]
          , [DCT].[CenterTypeDescriptionShort]
        FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [DC]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [DCT] ON [DC].[CenterTypeKey] = [DCT].[CenterTypeKey]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimRegion] AS [DR] ON [DC].[RegionKey] = [DR].[RegionKey]
        WHERE [DCT].[CenterTypeDescriptionShort] IN ('F', 'JV') AND [DC].[Active] = 'Y'
        OPTION( RECOMPILE ) ;
    END ;
ELSE
    BEGIN
        --One center is selected
        INSERT INTO [#Centers]
        SELECT
            CASE WHEN [DCT].[CenterTypeDescriptionShort] = 'C' THEN [CMA].[CenterManagementAreaSSID] ELSE [DR].[RegionSSID] END AS [MainGroupID]
          , CASE WHEN [DCT].[CenterTypeDescriptionShort] = 'C' THEN [CMA].[CenterManagementAreaDescription] ELSE [DR].[RegionDescription] END AS [MainGroup]
          , CASE WHEN [DCT].[CenterTypeDescriptionShort] = 'C' THEN [CMA].[CenterManagementAreaSortOrder] ELSE [DR].[RegionSortOrder] END AS [MainGroupSortOrder]
          , [DC].[CenterKey]
          , [DC].[CenterNumber]
          , [DC].[CenterSSID]
          , [DC].[CenterDescription]
          , [DC].[CenterDescriptionNumber]
          , [DCT].[CenterTypeDescriptionShort]
        FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [DC]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [DCT] ON [DC].[CenterTypeKey] = [DCT].[CenterTypeKey]
        LEFT JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimRegion] AS [DR] ON [DC].[RegionKey] = [DR].[RegionKey]
        LEFT JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterManagementArea] AS [CMA] ON [CMA].[CenterManagementAreaSSID] = [DC].[CenterManagementAreaSSID]
        WHERE [DC].[CenterSSID] = @CenterType AND [DC].[Active] = 'Y'
        OPTION( RECOMPILE ) ;
    END ;

/************************* After the Center table is populated, then reset the parameters, so the detail drill-downs will work properly ********************/
IF( SELECT TOP 1 [CenterTypeDescriptionShort] FROM [#Centers] ) = 'C'
    BEGIN
        SET @CenterType = 1 ;
    END ;
ELSE
    BEGIN
        SET @CenterType = 2 ;
    END ;

/********************************** Get Task data *************************************/
INSERT INTO [#Task]( [ClientGUID]
                   , [FullDate]
                   , [Id]
                   , [CenterNumber]
                   , [Action__c]
                   , [Result__c]
                   , [SourceCode]
                   , [Accommodation]
                   , [ExcludeFromConsults]
                   , [ExcludeFromBeBacks]
                   , [BeBacksToExclude]
                   , [Performer] )
SELECT
    [appt].[ClientGUID]
  , [t].[ActivityDate] AS [FullDate]
  , [t].[Id]
  , COALESCE([t].[CenterNumber__c], [t].[CenterID__c], 100) AS [CenterNumber]
  , [t].[Action__c]
  , [t].[Result__c]
  , [t].[SourceCode__c]
  , [t].[Accommodation__c] AS [Accommodation]
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
  , ISNULL(REPLACE([t].[Performer__c], ',', ''), REPLACE([de].[EmployeeFullNameCalc], ',', '')) AS [Performer]
FROM [HC_BI_SFDC].[dbo].[Task] AS [t] -----??? sf new definition
LEFT OUTER JOIN [SQL05].[HairClubCMS].[dbo].[datAppointment] AS [appt] WITH( NOLOCK )ON [appt].[SalesforceTaskID] = [t].[Id]
                                                                                    AND [t].[ActivityDate] = [appt].[AppointmentDate]
                                                                                    AND [appt].[ClientGUID] IS NOT NULL
LEFT OUTER JOIN [SQL05].[HairClubCMS].[dbo].[datAppointmentEmployee] AS [datapptemp] ON [appt].[AppointmentGUID] = [datapptemp].[AppointmentGUID]
LEFT OUTER JOIN [SQL05].[HairClubCMS].[dbo].[datEmployee] AS [de] ON [de].[EmployeeGUID] = [datapptemp].[EmployeeGUID]
WHERE LTRIM(RTRIM([t].[Action__c])) IN ('Appointment', 'Be Back', 'In House', 'Recovery')
  AND [t].[ActivityDate] BETWEEN @StartDate AND @EndDate
  AND ISNULL([t].[IsDeleted], 0) = 0
OPTION( RECOMPILE ) ;

/********************************** Get consultations *************************************/
INSERT INTO [#Consultations]
SELECT
    [t].[ClientGUID]
  , [CTR].[MainGroup]
  , [t].[CenterNumber]
  , -1
  , -1
  , -1
  , [t].[FullDate]
  , [t].[Performer]
  , 1 AS [Consultations]
  , CASE WHEN ( ISNULL([t].[Accommodation], 'In Person Consult') = 'In Person Consult' OR [t].[Accommodation] LIKE 'center%' OR [t].[Accommodation] = 'Company' )
          AND [t].[Result__c] IN ('Completed', 'Show Sale')
          AND [t].[Action__c] IN ('Appointment', 'In House', 'Recovery')
          AND ISNULL([t].[ExcludeFromConsults], 0) = 0 THEN 1
        --      AND ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
        ELSE 0
    END AS [InPersonConsultations]
  , CASE WHEN ( [t].[Accommodation] LIKE 'virtual%' OR [t].[Accommodation] LIKE 'Video%' )
          AND [t].[Result__c] IN ('Completed', 'Show Sale')
          AND [t].[Action__c] IN ('Appointment', 'In House', 'Recovery')
          AND ISNULL([t].[ExcludeFromConsults], 0) = 0 THEN 1
        --      AND ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
        ELSE 0
    END AS [VirtualConsultations]
  , [t].[ExcludeFromConsults]
  , [t].[Accommodation]
FROM [#Task] AS [t]
INNER JOIN [#Centers] AS [CTR] ON [t].[CenterNumber] = [CTR].[CenterNumber]
WHERE [t].[Result__c] IN ('Completed', 'Show Sale', 'Show no sale', 'Reschedule')
  AND ISNULL([t].[ExcludeFromConsults], 0) = 0
  AND [t].[Action__c] IN ('Appointment', 'In House', 'Recovery', 'Be Back')
OPTION( RECOMPILE ) ;

INSERT INTO [#BeBacks]
SELECT
    [CTR].[MainGroup]
  , [t].[CenterNumber]
  , -1
  , -1
  , -1
  , [t].[FullDate]
  , [t].[Performer]
  , CASE WHEN [t].[Action__c] IN ('Be Back')
          AND ISNULL([t].[Result__c], '') IN ('BB Manual Credit', 'No Show', 'Show No Sale', 'Show Sale', 'Completed', 'Scheduled', 'No_Show', 'Confirmed')
          AND ISNULL([t].[ExcludeFromBeBacks], 0) = 0 THEN 1
        ELSE 0
    END AS [BeBacks]
  , [t].[ExcludeFromConsults]
  , [t].[ExcludeFromBeBacks]
  , [t].[Accommodation]
FROM [#Task] AS [t]
INNER JOIN [#Centers] AS [CTR] ON [t].[CenterNumber] = [CTR].[CenterNumber] ;

INSERT INTO [#Referrals]
SELECT
    [CTR].[MainGroup]
  , [t].[CenterNumber]
  , -1
  , -1
  , -1
  , [t].[FullDate]
  , [t].[Performer]
  , 1 AS [Referrals]
  , [t].[Accommodation]
FROM [#Task] AS [t]
INNER JOIN [#Centers] AS [CTR] ON [t].[CenterNumber] = [CTR].[CenterNumber]
WHERE [t].[SourceCode] IN ('CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'BOSDMREF', 'BOSREF', 'BOSNCREF', 'REFEROTHER', 'IPREFCLRERECA12476'
                         , 'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP', 'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF'
                         , 'IPREFCLRERECA12476MP', 'bosref', 'other-bos') ;

SELECT
    [MainGroup]
  , [CenterNumber]
  , [Performer]
  , [ActivityDate] AS [FullDate]
  , SUM([Consultations]) AS [Consultations]
  , SUM(CASE WHEN ISNULL([ExcludeFromConsults], 0) = 1 THEN 1 ELSE 0 END) AS [BeBacksToExclude] --to validate
  , [Accommodation]
  , MAX([VirtualConsultations]) AS [VirtualConsultations]
  , MAX([InPersonConsultations]) AS [InPersonConsultations]
INTO [#NetConsultations]
FROM [#Consultations]
GROUP BY [MainGroup]
       , [CenterNumber]
       , [Performer]
       , [Accommodation]
       , [ActivityDate] ;

SELECT
    [MainGroup]
  , [CenterNumber]
  , [Performer]
  , SUM([BeBacks]) AS [BeBacks]
  , [ActivityDate] AS [FullDate]
  , [Accommodation]
INTO [#NetBeBacks]
FROM [#BeBacks]
GROUP BY [MainGroup]
       , [CenterNumber]
       , [Performer]
       , [Accommodation]
       , [ActivityDate] ;

SELECT
    [MainGroup]
  , [CenterNumber]
  , [Performer]
  , SUM([Referrals]) AS [Referrals]
  , [Accommodation]
  , [ActivityDate] AS [FullDate]
INTO [#NetReferrals]
FROM [#Referrals]
GROUP BY [MainGroup]
       , [CenterNumber]
       , [Performer]
       , [Accommodation]
       , [ActivityDate] ;

/********************************** Get sales data *************************************/
SELECT
    [c].[MainGroup]
  , [ctr].[CenterNumber]
  , [DD].[FullDate] AS [FullDate]
  , ISNULL([SOD].[Employee1FullName], 'Unknown, Unknown') AS [EmployeeFullName]
  , SUM(ISNULL([FST].[NB_TradCnt], 0)) + SUM(ISNULL([FST].[NB_ExtCnt], 0)) + SUM(ISNULL([FST].[NB_XTRCnt], 0)) + SUM(ISNULL([FST].[NB_GradCnt], 0))
    + SUM(ISNULL([FST].[S_SurCnt], 0)) + SUM(ISNULL([FST].[S_PostExtCnt], 0)) + SUM(ISNULL([FST].[NB_MDPCnt], 0)) + SUM(ISNULL([FST].[S_PRPCnt], 0)) AS [NetNB1Count]
  , SUM(ISNULL([FST].[NB_TradAmt], 0)) + SUM(ISNULL([FST].[NB_ExtAmt], 0)) + SUM(ISNULL([FST].[NB_XTRAmt], 0)) + SUM(ISNULL([FST].[NB_GradAmt], 0))
    + SUM(ISNULL([FST].[S_SurAmt], 0)) + SUM(ISNULL([FST].[S_PostExtAmt], 0)) + SUM(ISNULL([FST].[NB_MDPAmt], 0)) + SUM(ISNULL([FST].[NB_LaserAmt], 0))
    + SUM(ISNULL([FST].[S_PRPAmt], 0)) AS [NetNB1Sales]
  , SUM(ISNULL([FST].[NB_TradCnt], 0)) + SUM(ISNULL([FST].[NB_GradCnt], 0)) AS [XTRPlus]
  , SUM(ISNULL([FST].[NB_ExtCnt], 0)) + SUM(ISNULL([FST].[S_PostExtCnt], 0)) AS [EXT]
  , SUM(ISNULL([FST].[NB_XTRCnt], 0)) AS [Xtrands]
  , SUM(ISNULL([FST].[S_SurCnt], 0)) + SUM(ISNULL([FST].[S_PRPCnt], 0)) AS [Surgery]
  , SUM(ISNULL([FST].[NB_MDPCnt], 0)) AS [NB_MDPCnt]
  , MAX([cs].[Accommodation]) AS [Accommodation]
INTO [#NetSales]
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] AS [FST]
INNER JOIN [HC_BI_ENT_DDS].[bief_dds].[DimDate] AS [DD] ON [FST].[OrderDateKey] = [DD].[DateKey]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesCode] AS [SC] ON [FST].[SalesCodeKey] = [SC].[SalesCodeKey]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] AS [SO] ON [FST].[SalesOrderKey] = [SO].[SalesOrderKey]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrderDetail] AS [SOD] ON [FST].[SalesOrderDetailKey] = [SOD].[SalesOrderDetailKey]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimClientMembership] AS [CM] ON [SO].[ClientMembershipKey] = [CM].[ClientMembershipKey]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] AS [m] ON [CM].[MembershipKey] = [m].[MembershipKey]
INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [ctr] ON [ctr].[CenterKey] = [CM].[CenterKey]
INNER JOIN [#Centers] AS [c] ON [c].[CenterNumber] = [ctr].[CenterNumber]
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimClient] AS [CLT] ON [FST].[ClientKey] = [CLT].[ClientKey]
LEFT JOIN( SELECT [t].[ClientGUID], MAX([t].[Accommodation]) AS [Accommodation] FROM [#Consultations] AS [t] GROUP BY [t].[ClientGUID] ) AS [cs] ON [cs].[ClientGUID] = [CLT].[ClientSSID]
WHERE [DD].[FullDate] BETWEEN @StartDate AND @EndDate AND [SC].[SalesCodeKey] NOT IN (665, 654, 393, 668) AND [SO].[IsVoidedFlag] = 0
GROUP BY [c].[MainGroup]
       , [ctr].[CenterNumber]
       , [SOD].[Employee1FullName]
       , [DD].[FullDate]
OPTION( RECOMPILE ) ;

/********************************** Combine Results *************************************/
INSERT INTO [#CombinedData]( [MainGroup]
                           , [CenterNumber]
                           , [FullDate]
                           , [EmployeeFullName]
                           , [Consultations]
                           , [BeBacks]
                           , [BeBacksToExclude]
                           , [Referrals]
                           , [NetNB1Count]
                           , [NetNB1Sales]
                           , [XTRPlus]
                           , [EXT]
                           , [Xtrands]
                           , [Surgery]
                           , [NB_MDPCnt]
                           , [Accommodation]
                           , [VirtualConsultations]
                           , [InPersonConsultations] )
SELECT
    [NC].[MainGroup]
  , [NC].[CenterNumber]
  , [NC].[FullDate]
  , [NC].[Performer] AS [EmployeeFullName]
  , [NC].[Consultations]
  , 0 AS [BeBacks]
  , [NC].[BeBacksToExclude]
  , 0 AS [Referrals]
  , 0 AS [NetNB1Count]
  , 0 AS [NetNB1Sales]
  , 0 AS [XTRPlus]
  , 0 AS [EXT]
  , 0 AS [Xtrands]
  , 0 AS [Surgery]
  , 0 AS [NB_MDPCnt]
  , [NC].[Accommodation]
  , ISNULL([NC].[VirtualConsultations], 0) AS [VirtualConsultations]
  , ISNULL([NC].[InPersonConsultations], 0) AS [InPersonConsultations]
FROM [#NetConsultations] AS [NC]
UNION
SELECT
    [NB].[MainGroup]
  , [NB].[CenterNumber]
  , [NB].[FullDate]
  , [NB].[Performer] AS [EmployeeFullName]
  , 0 AS [Consultations]
  , [NB].[BeBacks]
  , 0 AS [BeBacksToExclude]
  , 0 AS [Referrals]
  , 0 AS [NetNB1Count]
  , 0 AS [NetNB1Sales]
  , 0 AS [XTRPlus]
  , 0 AS [EXT]
  , 0 AS [Xtrands]
  , 0 AS [Surgery]
  , 0 AS [NB_MDPCnt]
  , [NB].[Accommodation]
  , 0 AS [VirtualConsultations]
  , 0 AS [InPersonConsultations]
FROM [#NetBeBacks] AS [NB]
UNION
SELECT
    [NS].[MainGroup]
  , [NS].[CenterNumber]
  , [NS].[FullDate]
  , [NS].[EmployeeFullName]
  , 0 AS [Consultations]
  , 0 AS [BeBacks]
  , 0 AS [BeBacksToExclude]
  , 0 AS [Referrals]
  , [NS].[NetNB1Count]
  , [NS].[NetNB1Sales]
  , [NS].[XTRPlus]
  , [NS].[EXT]
  , [NS].[Xtrands]
  , [NS].[Surgery]
  , [NS].[NB_MDPCnt]
  , [NS].[Accommodation]
  , 0 AS [VirtualConsultations]
  , 0 AS [InPersonConsultations]
FROM [#NetSales] AS [NS]
UNION
SELECT
    [REF].[MainGroup]
  , [REF].[CenterNumber]
  , [REF].[FullDate]
  , [REF].[Performer] AS [EmployeeFullName]
  , 0 AS [Consultations]
  , 0 AS [BeBacks]
  , 0 AS [BeBacksToExclude]
  , [REF].[Referrals]
  , 0 AS [NetNB1Count]
  , 0 AS [NetNB1Sales]
  , 0 AS [XTRPlus]
  , 0 AS [EXT]
  , 0 AS [Xtrands]
  , 0 AS [Surgery]
  , 0 AS [NB_MDPCnt]
  , [REF].[Accommodation]
  , 0 AS [VirtualConsultations]
  , 0 AS [InPersonConsultations]
FROM [#NetReferrals] AS [REF] ;

SELECT
    [CD].[MainGroup]
  , [CD].[CenterNumber]
  , [CD].[FullDate]
  , CASE WHEN [CD].[EmployeeFullName] = ',' THEN 'Unknown, Unknown' WHEN [CD].[EmployeeFullName] IS NULL THEN 'Unknown, Unknown' ELSE
                                                                                                                                 ISNULL(
                                                                                                                                 [CD].[EmployeeFullName]
                                                                                                                                 , 'Unknown, Unknown')END AS [EmployeeFullName]
  , SUM([CD].[Consultations]) AS [Consultations]
  , SUM([CD].[BeBacks]) AS [BeBacks]
  , SUM([CD].[BeBacksToExclude]) AS [BeBacksToExclude]
  , SUM([CD].[Referrals]) AS [Referrals]
  , SUM([CD].[NetNB1Count]) AS [NetNB1Count]
  , SUM([CD].[NetNB1Sales]) AS [NetNB1Sales]
  , SUM([CD].[XTRPlus]) AS [XTRPlus]
  , SUM([CD].[EXT]) AS [EXT]
  , SUM([CD].[Xtrands]) AS [Xtrands]
  , SUM([CD].[Surgery]) AS [Surgery]
  , SUM([CD].[NB_MDPCnt]) AS [NB_MDPCnt]
  , [CD].[Accommodation]
  , SUM([CD].[VirtualConsultations]) AS [VirtualConsultations]
  , SUM([CD].[InPersonConsultations]) AS [InPersonConsultations]
INTO [#NetSalesEmployee]
FROM [#CombinedData] AS [CD]
GROUP BY [CD].[MainGroup]
       , [CD].[CenterNumber]
       , CASE WHEN [CD].[EmployeeFullName] = ',' THEN 'Unknown, Unknown' WHEN [CD].[EmployeeFullName] IS NULL THEN 'Unknown, Unknown' ELSE
                                                                                                                                      ISNULL(
                                                                                                                                      [CD].[EmployeeFullName]
                                                                                                                                      , 'Unknown, Unknown')END
       , [CD].[Accommodation]
       , [CD].[FullDate] ;

/********************************** Display Results *************************************/
SELECT
    [R].[FullDate]
  , [C].[MainGroupID] AS [RegionID]
  , [C].[MainGroup] AS [Region]
  , [C].[MainGroupSortOrder] AS [RegionSortOrder]
  , [C].[CenterNumber] AS [CenterID]
  , [C].[CenterSSID]
  , [C].[CenterDescription]
  , [C].[CenterDescriptionNumber] AS [Center]
  , NULL AS [Performer]
  , NULL AS [EmployeeKey]
  , CASE WHEN [R].[EmployeeFullName] = ',' THEN 'Unknown, Unknown' ELSE ISNULL(REPLACE([R].[EmployeeFullName], ',', ''), 'Unknown, Unknown')END AS [PerformerName]
  , [R].[Consultations] AS [Consultations]
  , [R].[BeBacks] AS [BeBacks]
  , [R].[BeBacksToExclude]
  , [R].[Referrals] AS [Referrals]
  , ISNULL([R].[NetNB1Count], 0) AS [NetSale]
  , ISNULL([R].[NetNB1Sales], 0) AS [NetRevenue]
  , ISNULL([R].[XTRPlus], 0) AS [XTRPlus]
  , ISNULL([R].[EXT], 0) AS [EXT]
  , ISNULL([R].[Xtrands], 0) AS [Xtrands]
  , ISNULL([R].[Surgery], 0) AS [Surgery]
  , ISNULL([R].[NB_MDPCnt], 0) AS [NB_MDPCnt]
  , ISNULL([dbo].[DIVIDE_DECIMAL](ISNULL([R].[NetNB1Count], 0), ( ISNULL([R].[Consultations], 0) - ISNULL([R].[BeBacksToExclude], 0))), 0) AS [ConversionPercent]
  , ISNULL([dbo].[DIVIDE_DECIMAL]([R].[XTRPlus], [R].[NetNB1Count]), 0) AS [XTRPlusPercent]
  , ISNULL([dbo].[DIVIDE_DECIMAL]([R].[EXT], [R].[NetNB1Count]), 0) AS [EXTPercent]
  , ISNULL([dbo].[DIVIDE_DECIMAL]([R].[Xtrands], [R].[NetNB1Count]), 0) AS [XtrandsPercent]
  , ISNULL([dbo].[DIVIDE_DECIMAL]([R].[Surgery], [R].[NetNB1Count]), 0) AS [SurgeryPercent]
  , ISNULL([dbo].[DIVIDE_DECIMAL]([R].[NB_MDPCnt], [R].[NetNB1Count]), 0) AS [MDPPercent]
  , [R].[Accommodation]
  , ISNULL([R].[VirtualConsultations], 0) AS [VirtualConsultations]
  , ISNULL([R].[InPersonConsultations], 0) AS [InPersonConsultations]
INTO [#Results]
FROM [#NetSalesEmployee] AS [R]
INNER JOIN [#Centers] AS [C] ON [C].[CenterNumber] = [R].[CenterNumber]
WHERE( [R].[Consultations] <> 0
     OR ISNULL([R].[BeBacks], 0) <> 0
     OR ISNULL([R].[Referrals], 0) <> 0
     OR ISNULL([R].[NetNB1Count], 0) <> 0
     OR ISNULL([R].[NetNB1Sales], 0) <> 0 )
OPTION( RECOMPILE ) ;

/*****************UPDATE records with EmployeeKey for Performer and EmployeeKey *****************************/
UPDATE
    [r]
SET
    [r].[Performer] = ISNULL([E].[EmployeeKey], -1)
FROM [#Results] AS [r]
LEFT JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimEmployee] AS [E] ON REPLACE(REPLACE(LTRIM([r].[PerformerName]), ' ', ''), ',', '') = REPLACE(
                                                                                                                                    REPLACE(
                                                                                                                                    LTRIM(
                                                                                                                                    [E].[EmployeeFullName])
                                                                                                                                    , ' ', ''), ',', '')
WHERE [r].[Performer] IS NULL ;

UPDATE
    [r]
SET
    [r].[EmployeeKey] = ISNULL([E].[EmployeeKey], -1)
FROM [#Results] AS [r]
LEFT JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimEmployee] AS [E] ON REPLACE(REPLACE(LTRIM([r].[PerformerName]), ' ', ''), ',', '') = REPLACE(
                                                                                                                                    REPLACE(
                                                                                                                                    LTRIM(
                                                                                                                                    [E].[EmployeeFullName])
                                                                                                                                    , ' ', ''), ',', '')
WHERE [r].[EmployeeKey] IS NULL ;

UPDATE [r]
SET [r].[Performer] = -1
FROM [#Results] AS [r]
WHERE [r].[PerformerName] = 'Unknown, Unknown' AND [r].[Performer] = NULL ;

UPDATE [r]
SET [r].[EmployeeKey] = -1
FROM [#Results] AS [r]
WHERE [r].[PerformerName] = 'Unknown, Unknown' AND [r].[EmployeeKey] = NULL ;

UPDATE [r]
SET [r].[PerformerName] = 'Unknown, Unknown'
FROM [#Results] AS [r]
WHERE( [r].[PerformerName] IS NULL OR [r].[PerformerName] = '' ) ;

/***************** Combine 'Unknown, Unknown' records into one per center ***************************************/
SELECT
    [FullDate]
  , [RegionID]
  , [Region]
  , [RegionSortOrder]
  , [CenterID] --CenterNumber
  , [CenterSSID]
  , [CenterDescription]
  , [Center]
  , [Performer]
  , [EmployeeKey]
  , [PerformerName]
  , SUM([Consultations]) AS [Consultations]
  , SUM([BeBacks]) AS [BeBacks]
  , SUM([BeBacksToExclude]) AS [BeBacksToExclude]
  , SUM([Referrals]) AS [Referrals]
  , SUM([NetSale]) AS [NetSale]
  , SUM([NetRevenue]) AS [NetRevenue]
  , SUM([XTRPlus]) AS [XTRPlus]
  , SUM([EXT]) AS [EXT]
  , SUM([Xtrands]) AS [Xtrands]
  , SUM([Surgery]) AS [Surgery]
  , SUM([NB_MDPCnt]) AS [NB_MDPCnt]
  , MAX([ConversionPercent]) AS [ConversionPercent]
  , MAX([XTRPlusPercent]) AS [XTRPlusPercent]
  , MAX([EXTPercent]) AS [EXTPercent]
  , MAX([XtrandsPercent]) AS [XtrandsPercent]
  , MAX([SurgeryPercent]) AS [SurgeryPercent]
  , MAX([MDPPercent]) AS [MDPPercent]
  , [Accommodation]
  , SUM([VirtualConsultations]) AS [VirtualConsultations]
  , SUM([InPersonConsultations]) AS [InPersonConsultations]
FROM [#Results]
GROUP BY [RegionID]
       , [Region]
       , [RegionSortOrder]
       , [CenterID]
       , [CenterSSID]
       , [CenterDescription]
       , [Center]
       , [Performer]
       , [EmployeeKey]
       , [PerformerName]
       , [Accommodation]
       , [FullDate] ;
GO
RETURN ;

EXEC [dbo].[spRpt_ClosingByConsultant_V2] @CenterType = 1, @StartDate = '20220201', @EndDate = '20220222' ;
