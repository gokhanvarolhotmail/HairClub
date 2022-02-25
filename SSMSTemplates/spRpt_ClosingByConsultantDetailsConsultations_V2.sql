-- SQL06
GO
USE [HC_BI_Reporting] ;
GO
/***********************************************************************
PROCEDURE:				spRpt_ClosingByConsultantDetailsConsultations
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Closing By Consultant Details
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		05/28/2013
------------------------------------------------------------------------
NOTES:
@Type = 1 for Consultations, 2 for Bebacks, 3 for Referrals
------------------------------------------------------------------------
CHANGE HISTORY:

09/05/2013 - MB - Added Solution Sold in instaces of ShowSale (WO# 90946)
04/29/2014 - RH - Added ROW_NUMBER() OVER PARTITION BY code to find the latest appointment when more than one appointment occurred on the same day for the same person
07/25/2014 - RH - Added ContactGender from the table HC_BI_MKTG_DDS.bi_mktg_dds.DimContact (#103324)
04/24/2015 - RH - Rewrote the query to be optimized and to remove duplicates (#114013)
04/21/2015 - RH - Added code to exclude/include certain Referrals from Consultations (#114151)
06/16/2015 - DL - Rewrote the query to match the NB Flash (#114151)
07/30/2015 - RH - Added ability to select a single center as @CenterType (#115654)
11/17/2017 - RH - Changed logic to find Employee/Performer; added joins on SFDC_LeadID and SFDC_TaskID (#144996)
11/29/2017 - RH - Removed restriction of "only center employees" since there could be visiting stylists (#145135)
04/24/2018 - RH - (#125957) Replaced Corporate Regions with Areas, changed CenterSSID to CenterNumber
05/01/2018 - RH - (#149662) Added IsActiveFlag = 1 for employees to remove dupes
07/05/2018 - RH - (#148614) Added Sort Order for Regions or Areas
02/04/2019 - RH - (Case #7942) Added two missing indexes on FAR and DimClientPhone; separated Phone, Email and Address query
03/08/2019 - DL - Changed INNER JOINs to use the SFDC Ids
03/08/2019 - DL - Removed the check on the IsActiveFlag on the DimEmployee table
04/11/2019 - RH - Added Referrals, Bebacks; Added PostEXT to EXT; Added @Type to find Consultations, Bebacks and Referrals in the drill-down
05/20/2019 - JL - Revised drill down to center employee level
08/20/2019 - RH - Changed join on DimContact to SFDC_LeadID and join on DimActivityDemographic to SFDC_TaskID

------------------------------------------------------------------------
SAMPLE EXECUTION:1, '01/01/2021', '07/14/2021'

EXEC spRpt_ClosingByConsultantDetailsConsultations 1, 207, null, '01/1/2021', '07/14/2021',1
EXEC spRpt_ClosingByConsultantDetailsConsultations 2, 6, 0, '1/1/2019', '1/31/2019',1
EXEC spRpt_ClosingByConsultantDetailsConsultations 211, 211, 0, '1/1/2020', '1/31/2020',1

EXEC spRpt_ClosingByConsultantDetailsConsultations 1, 0, 0, '4/2/2019', '4/23/2019', 1
EXEC spRpt_ClosingByConsultantDetailsConsultations 1, 0, 0, '5/2/2019', '5/9/2019', 3
EXEC spRpt_ClosingByConsultantDetailsConsultations 1, 264, 17165, '3/1/2021', '3/10/2021', 1
EXEC spRpt_ClosingByConsultantDetailsConsultations 1, 231,  -1, '5/2/2019', '5/20/2019', 3

***********************************************************************/
ALTER PROCEDURE [dbo].[spRpt_ClosingByConsultantDetailsConsultations_V2]
    @CenterType INT
  , @Center     INT
  , @EmployeeID INT
  , @StartDate  DATETIME
  , @EndDate    DATETIME
  , @Type       INT
AS
SET FMTONLY OFF ;

SET NOCOUNT OFF ;

/********************************** Create temp table objects *************************************/
CREATE TABLE [#Centers]
(
    [MainGroupID]        INT
  , [MainGroup]          VARCHAR(50)
  , [MainGroupSortOrder] INT
  , [CenterKey]          INT
  , [CenterNumber]       INT
  , [CenterSSID]         INT
  , [CenterDescription]  VARCHAR(255)
  , [CenterType]         VARCHAR(50)
) ;

CREATE TABLE [#NetConsultations]
(
    [RegionID]        INT
  , [Region]          NVARCHAR(50)
  , [RegionSortOrder] INT
  , [CenterId]        INT
  , [Center]          NVARCHAR(255)
  , [Performer]       NVARCHAR(50)
  , [ActivityDueDate] DATETIME
  , [ActivitySSID]    NVARCHAR(18)
  , [ActivityKey]     INT
  , [SFDC_LeadID]     NVARCHAR(18)
  , [ActionCode]      NVARCHAR(50)
  , [ResultCode]      NVARCHAR(50)
  , [NoSaleReason]    NVARCHAR(200)
  , [SolutionOffered] NVARCHAR(100)
  , [PriceQuoted]     DECIMAL(18, 4)
  , [ContactFullName] NVARCHAR(102)
  , [ContactGender]   NVARCHAR(50)
  , [Type]            NVARCHAR(15)
) ;

CREATE TABLE [#Employee] ( [CenterSSID] INT, [CenterNumber] INT, [EmployeeFullName] NVARCHAR(102), [EmployeeKey] INT ) ;

/********************************** Get list of centers *************************************/
IF( @CenterType = 1 AND LEN(@Center) > 2 ) --Corporate, a single center
    BEGIN
        INSERT INTO [#Centers]
        SELECT
            [CMA].[CenterManagementAreaSSID]
          , [CMA].[CenterManagementAreaDescription]
          , [CMA].[CenterManagementAreaSortOrder]
          , [DC].[CenterKey]
          , [DC].[CenterNumber]
          , [DC].[CenterSSID]
          , [DC].[CenterDescriptionNumber]
          , [DCT].[CenterTypeDescriptionShort]
        FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [DC]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [DCT] ON [DC].[CenterTypeKey] = [DCT].[CenterTypeKey]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterManagementArea] AS [CMA] ON [CMA].[CenterManagementAreaSSID] = [DC].[CenterManagementAreaSSID]
        WHERE [DCT].[CenterTypeDescriptionShort] = 'C' AND [DC].[Active] = 'Y' AND ( [DC].[CenterSSID] = @Center )
        OPTION( RECOMPILE ) ;
    END ;
ELSE IF( @CenterType = 2 AND LEN(@Center) > 2 ) --Franchise, a single center
    BEGIN
        INSERT INTO [#Centers]
        SELECT
            [DR].[RegionSSID]
          , [DR].[RegionDescription]
          , [DR].[RegionSortOrder]
          , [DC].[CenterKey]
          , [DC].[CenterNumber]
          , [DC].[CenterSSID]
          , [DC].[CenterDescriptionNumber]
          , [DCT].[CenterTypeDescriptionShort]
        FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [DC]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [DCT] ON [DC].[CenterTypeKey] = [DCT].[CenterTypeKey]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimRegion] AS [DR] ON [DC].[RegionSSID] = [DR].[RegionSSID]
        WHERE [DCT].[CenterTypeDescriptionShort] IN ('F', 'JV') AND [DC].[Active] = 'Y' AND ( [DC].[CenterSSID] = @Center )
        OPTION( RECOMPILE ) ;
    END ;
ELSE IF( @CenterType = 1 AND @Center BETWEEN ( -2 ) AND 25 ) -- An Area has been selected.
    BEGIN
        INSERT INTO [#Centers]
        SELECT
            [CMA].[CenterManagementAreaSSID]
          , [CMA].[CenterManagementAreaDescription]
          , [CMA].[CenterManagementAreaSortOrder]
          , [DC].[CenterKey]
          , [DC].[CenterNumber]
          , [DC].[CenterSSID]
          , [DC].[CenterDescriptionNumber]
          , [DCT].[CenterTypeDescriptionShort]
        FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [DC]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [DCT] ON [DC].[CenterTypeKey] = [DCT].[CenterTypeKey]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterManagementArea] AS [CMA] ON [CMA].[CenterManagementAreaSSID] = [DC].[CenterManagementAreaSSID]
        WHERE [DCT].[CenterTypeDescriptionShort] IN ('C') AND [DC].[Active] = 'Y' AND ( [CMA].[CenterManagementAreaSSID] = @Center OR @Center = 0 )
        OPTION( RECOMPILE ) ;
    END ;
ELSE IF( @CenterType = 2 AND @Center BETWEEN ( -2 ) AND 25 ) -- A Region has been selected.
    BEGIN
        INSERT INTO [#Centers]
        SELECT
            [DR].[RegionSSID]
          , [DR].[RegionDescription]
          , [DR].[RegionSortOrder]
          , [DC].[CenterKey]
          , [DC].[CenterNumber]
          , [DC].[CenterSSID]
          , [DC].[CenterDescriptionNumber]
          , [DCT].[CenterTypeDescriptionShort]
        FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [DC]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [DCT] ON [DC].[CenterTypeKey] = [DCT].[CenterTypeKey]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimRegion] AS [DR] ON [DC].[RegionSSID] = [DR].[RegionSSID]
        WHERE [DCT].[CenterTypeDescriptionShort] IN ('F', 'JV') AND [DC].[Active] = 'Y' AND ( [DR].[RegionSSID] = @Center OR @Center = 0 )
        OPTION( RECOMPILE ) ;
    END ;
ELSE IF( LEN(@CenterType) > 2 ) --A center has been selected
    BEGIN
        INSERT INTO [#Centers]
        SELECT
            [DC].[CenterSSID] AS [MainGroupID]
          , [DC].[CenterDescriptionNumber] AS [MainGroup]
          , [DC].[CenterNumber] AS [MainGroupSortOrder]
          , [DC].[CenterKey]
          , [DC].[CenterNumber]
          , [DC].[CenterSSID]
          , [DC].[CenterDescriptionNumber]
          , [DCT].[CenterTypeDescriptionShort]
        FROM [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [DC]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenterType] AS [DCT] ON [DC].[CenterTypeKey] = [DCT].[CenterTypeKey]
        WHERE( [DC].[CenterSSID] = @CenterType OR @CenterType = 0 ) AND [DCT].[CenterTypeDescriptionShort] IN ('C', 'F', 'JV') AND [DC].[Active] = 'Y'
        OPTION( RECOMPILE ) ;
    END ;

--Get list of employees based on @EmployeeID parameter passed
IF @EmployeeID = 0
    BEGIN
        INSERT INTO [#Employee]
        SELECT
            [ctr].[CenterSSID]
          , [ctr].[CenterNumber]
          , [de].[EmployeeFullName]
          , [de].[EmployeeKey]
        FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimEmployee] AS [de]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [ctr] ON [ctr].[CenterSSID] = [de].[CenterSSID]
        WHERE( [ctr].[CenterSSID] = @Center OR @Center = 0 ) AND [de].[UserLogin] NOT LIKE '%INACTIVE%'
        GROUP BY [ctr].[CenterSSID]
               , [ctr].[CenterNumber]
               , [de].[EmployeeFullName]
               , [de].[EmployeeKey]
        OPTION( RECOMPILE ) ;
    END ;
ELSE
    BEGIN
        INSERT INTO [#Employee]
        SELECT
            [ctr].[CenterSSID]
          , [ctr].[CenterNumber]
          , [de].[EmployeeFullName]
          , [de].[EmployeeKey]
        FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimEmployee] AS [de]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [ctr] ON [ctr].[CenterSSID] = [de].[CenterSSID]
        WHERE( [ctr].[CenterSSID] = @Center OR @Center = 0 ) AND [de].[EmployeeKey] = @EmployeeID
        GROUP BY [ctr].[CenterSSID]
               , [ctr].[CenterNumber]
               , [de].[EmployeeFullName]
               , [de].[EmployeeKey]
        OPTION( RECOMPILE ) ;
    END ;

/********************************** Get consultations *************************************/
IF @Type = 1
    BEGIN
        INSERT INTO [#NetConsultations]
        SELECT DISTINCT
               [C].[MainGroupID] AS [RegionID]
             , [C].[MainGroup] AS [Region]
             , [C].[MainGroupSortOrder] AS [RegionSortOrder]
             , [C].[CenterNumber] AS [CenterId]
             , [C].[CenterDescription] AS [Center]
             , [DAD].[Performer]
             , [DA].[ActivityDueDate]
             , [DA].[SFDC_TaskID]
             , [DA].[ActivityKey]
             , [DC].[SFDC_LeadID]
             , ISNULL([DA].[ActionCodeDescription], '') AS [ActionCode]
             , ISNULL([DA].[ResultCodeDescription], '') AS [ResultCode]
             , ISNULL([DAD].[NoSaleReason], '') AS [NoSaleReason]
             , [DAD].[SolutionOffered]
             , ISNULL([DAD].[PriceQuoted], '') AS [PriceQuoted]
             , [DC].[ContactFullName]
             , ISNULL([DAD].[GenderDescription], [DC].[ContactGender]) AS [ContactGender]
             , 'Consultation' AS [Type]
        FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[vwFactActivityResults] AS [FAR] WITH( NOLOCK )
        INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivity] AS [DA] WITH( NOLOCK )ON [FAR].[ActivityKey] = [DA].[ActivityKey]
        INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimContact] AS [DC] WITH( NOLOCK )ON [DC].[ContactKey] = [FAR].[ContactKey]
        INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic] AS [DAD] WITH( NOLOCK )ON [DA].[SFDC_TaskID] = [DAD].[SFDC_TaskID]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [CTR] WITH( NOLOCK )ON [DA].[CenterSSID] = [CTR].[CenterNumber] AND [CTR].[Active] = 'Y'
        INNER JOIN [#Centers] AS [C] ON [CTR].[CenterSSID] = [C].[CenterSSID]
        INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimSource] AS [DS] WITH( NOLOCK )ON [DA].[SourceSSID] = [DS].[SourceSSID]
        INNER JOIN [HC_BI_ENT_DDS].[bief_dds].[DimDate] AS [DD] ON [DD].[DateKey] = [FAR].[ActivityDueDateKey]
        LEFT JOIN [#Employee] AS [E] ON [DAD].[Performer] = [E].[EmployeeFullName]
        WHERE [DD].[FullDate] BETWEEN @StartDate AND @EndDate
          AND [FAR].[Show] = 1
          AND ( [E].[EmployeeKey] = @EmployeeID OR @EmployeeID = 0 OR ISNULL(@EmployeeID, '') = '' OR @EmployeeID = -1 )
        OPTION( RECOMPILE ) ;
    END ;
/********************************** Get BeBacks *************************************/
ELSE IF @Type = 2
    BEGIN
        INSERT INTO [#NetConsultations]
        SELECT DISTINCT
               [C].[MainGroupID] AS [RegionID]
             , [C].[MainGroup] AS [Region]
             , [C].[MainGroupSortOrder] AS [RegionSortOrder]
             , [C].[CenterNumber] AS [CenterId]
             , [C].[CenterDescription] AS [Center]
             , [DAD].[Performer]
             , [DA].[ActivityDueDate]
             , [DA].[SFDC_TaskID]
             , [DA].[ActivityKey]
             , [DC].[SFDC_LeadID]
             , ISNULL([DA].[ActionCodeDescription], '') AS [ActionCode]
             , ISNULL([DA].[ResultCodeDescription], '') AS [ResultCode]
             , ISNULL([DAD].[NoSaleReason], '') AS [NoSaleReason]
             , [DAD].[SolutionOffered]
             , ISNULL([DAD].[PriceQuoted], '') AS [PriceQuoted]
             , [DC].[ContactFullName]
             , ISNULL([DAD].[GenderDescription], [DC].[ContactGender]) AS [ContactGender]
             , 'BeBack' AS [Type]
        FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[vwFactActivityResults] AS [FAR] WITH( NOLOCK )
        INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivity] AS [DA] WITH( NOLOCK )ON [FAR].[ActivityKey] = [DA].[ActivityKey]
        INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimContact] AS [DC] WITH( NOLOCK )ON [DC].[ContactKey] = [FAR].[ContactKey]
        INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic] AS [DAD] WITH( NOLOCK )ON [DA].[SFDC_TaskID] = [DAD].[SFDC_TaskID]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [CTR] WITH( NOLOCK )ON [DA].[CenterSSID] = [CTR].[CenterNumber] AND [CTR].[Active] = 'Y'
        INNER JOIN [#Centers] AS [C] ON [CTR].[CenterSSID] = [C].[CenterSSID]
        INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimSource] AS [DS] WITH( NOLOCK )ON [DA].[SourceSSID] = [DS].[SourceSSID]
        INNER JOIN [HC_BI_ENT_DDS].[bief_dds].[DimDate] AS [DD] WITH( NOLOCK )ON [DD].[DateKey] = [FAR].[ActivityDueDateKey]
        LEFT JOIN [#Employee] AS [E] WITH( NOLOCK )ON [DAD].[Performer] = [E].[EmployeeFullName]
        WHERE [DD].[FullDate] BETWEEN @StartDate AND @EndDate
          AND [FAR].[Show] = 1
          AND ( [FAR].[BeBack] = 1 OR [FAR].[ActionCodeKey] = 5 )
          AND ( [E].[EmployeeKey] = @EmployeeID OR @EmployeeID = 0 OR ISNULL(@EmployeeID, '') = '' OR @EmployeeID = -1 )
        OPTION( RECOMPILE ) ;
    END ;

/********************************** Get Referrals *************************************/
ELSE IF @Type = 3
    BEGIN
        INSERT INTO [#NetConsultations]
        SELECT DISTINCT
               [C].[MainGroupID] AS [RegionID]
             , [C].[MainGroup] AS [Region]
             , [C].[MainGroupSortOrder] AS [RegionSortOrder]
             , [C].[CenterNumber] AS [CenterId]
             , [C].[CenterDescription] AS [Center]
             , [E].[EmployeeKey]
             , [DA].[ActivityDueDate]
             , [DA].[SFDC_TaskID]
             , [DA].[ActivityKey]
             , [DC].[SFDC_LeadID]
             , ISNULL([DA].[ActionCodeDescription], '') AS [ActionCode]
             , ISNULL([DA].[ResultCodeDescription], '') AS [ResultCode]
             , ISNULL([DAD].[NoSaleReason], '') AS [NoSaleReason]
             , [DAD].[SolutionOffered]
             , ISNULL([DAD].[PriceQuoted], '') AS [PriceQuoted]
             , [DC].[ContactFullName]
             , ISNULL([DAD].[GenderDescription], [DC].[ContactGender]) AS [ContactGender]
             , CASE WHEN [FAR].[BOSRef] = 1 THEN 'BOSRef' WHEN [FAR].[BOSOthRef] = 1 THEN 'BOSOthRef' WHEN [FAR].[HCRef] = 1 THEN 'HCRef' ELSE 'Referral' END AS [Type]
        FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[vwFactActivityResults] AS [FAR] WITH( NOLOCK )
        INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivity] AS [DA] WITH( NOLOCK )ON [FAR].[ActivityKey] = [DA].[ActivityKey]
        INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimContact] AS [DC] WITH( NOLOCK )ON [DC].[ContactKey] = [FAR].[ContactKey]
        LEFT JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityDemographic] AS [DAD] WITH( NOLOCK )ON [DA].[SFDC_TaskID] = [DAD].[SFDC_TaskID]
        INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimCenter] AS [CTR] WITH( NOLOCK )ON [DA].[CenterSSID] = [CTR].[CenterNumber] AND [CTR].[Active] = 'Y'
        INNER JOIN [#Centers] AS [C] ON [CTR].[CenterSSID] = [C].[CenterSSID]
        INNER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimSource] AS [DS] WITH( NOLOCK )ON [DA].[SourceSSID] = [DS].[SourceSSID]
        LEFT JOIN [#Employee] AS [E] WITH( NOLOCK )ON [DAD].[Performer] = [E].[EmployeeFullName]
        WHERE [DA].[ActivityDueDate] BETWEEN @StartDate AND @EndDate
          AND [DS].[Media] IN ('Referrals', 'Referral')
          AND [FAR].[Show] = 1
          AND [FAR].[BOSAppt] <> 1
          AND [DS].[OwnerType] <> 'Bosley Consult'
          AND ( [E].[EmployeeKey] = @EmployeeID OR @EmployeeID = 0 OR ISNULL(@EmployeeID, '') = '' OR @EmployeeID = -1 )
        OPTION( RECOMPILE ) ;
    END ;

/********* Find Phone, Email and Address ******************************************************************************************/
SELECT DISTINCT
       [nc].[SFDC_LeadID]
INTO [#Consultations]
FROM [#NetConsultations] AS [nc]
OPTION( RECOMPILE ) ;

SELECT
    ROW_NUMBER() OVER ( PARTITION BY [DCP].[SFDC_LeadID] ORDER BY [DCP].[ContactPhoneKey] DESC ) AS [RowID]
  , [DCP].[SFDC_LeadID]
  , [DCP].[AreaCode] + [DCP].[PhoneNumber] AS [PhoneNumber]
INTO [#Phone]
FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimContactPhone] AS [DCP]
INNER JOIN [#Consultations] AS [c] ON [c].[SFDC_LeadID] = [DCP].[SFDC_LeadID]
OPTION( RECOMPILE ) ;

SELECT
    ROW_NUMBER() OVER ( PARTITION BY [DCE].[SFDC_LeadID] ORDER BY [DCE].[ContactEmailKey] DESC ) AS [RowID]
  , [DCE].[SFDC_LeadID]
  , [DCE].[Email] AS [EmailAddress]
INTO [#Email]
FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimContactEmail] AS [DCE]
INNER JOIN [#Consultations] AS [c] ON [c].[SFDC_LeadID] = [DCE].[SFDC_LeadID]
OPTION( RECOMPILE ) ;

SELECT
    ROW_NUMBER() OVER ( PARTITION BY [DCA].[SFDC_LeadID] ORDER BY [DCA].[ContactAddressKey] DESC ) AS [RowID]
  , [DCA].[SFDC_LeadID]
  , [DCA].[AddressLine1] + ' ' + [DCA].[AddressLine2] + ' ' + [DCA].[City] + ' ' + [DCA].[StateCode] + ', ' + [DCA].[ZipCode] AS [MailingAddress]
INTO [#Address]
FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimContactAddress] AS [DCA]
INNER JOIN [#Consultations] AS [c] ON [c].[SFDC_LeadID] = [DCA].[SFDC_LeadID]
OPTION( RECOMPILE ) ;

SELECT
    [NC].[SFDC_LeadID]
  , [p].[PhoneNumber]
  , [e].[EmailAddress]
  , [a].[MailingAddress]
INTO [#LeadDetails]
FROM [#NetConsultations] AS [NC]
LEFT OUTER JOIN [#Phone] AS [p] ON [NC].[SFDC_LeadID] = [p].[SFDC_LeadID] AND [p].[RowID] = 1
LEFT JOIN [#Email] AS [e] ON [NC].[SFDC_LeadID] = [e].[SFDC_LeadID] AND [e].[RowID] = 1
LEFT OUTER JOIN [#Address] AS [a] ON [NC].[SFDC_LeadID] = [a].[SFDC_LeadID] AND [a].[RowID] = 1
GROUP BY [NC].[SFDC_LeadID]
       , [p].[PhoneNumber]
       , [e].[EmailAddress]
       , [a].[MailingAddress]
OPTION( RECOMPILE ) ;

/********************************** Display Results *************************************/
SELECT
    [NC].[RegionID]
  , [NC].[Region]
  , [NC].[RegionSortOrder]
  , [NC].[CenterId]
  , [NC].[Center]
  , [NC].[Performer]
  , [NC].[ActivityDueDate]
  , [NC].[ActivitySSID]
  , [NC].[SFDC_LeadID]
  , [NC].[ActionCode]
  , [NC].[ResultCode]
  , [NC].[NoSaleReason]
  , [NC].[SolutionOffered]
  , [NC].[PriceQuoted]
  , [ld].[PhoneNumber]
  , [ld].[EmailAddress]
  , [ld].[MailingAddress]
  , [NC].[ContactFullName]
  , [NC].[ContactGender]
  , [NC].[Type]
FROM [#NetConsultations] AS [NC]
LEFT OUTER JOIN [#LeadDetails] AS [ld] ON [ld].[SFDC_LeadID] = [NC].[SFDC_LeadID]
ORDER BY [NC].[ActivityDueDate]
OPTION( RECOMPILE ) ;
GO
