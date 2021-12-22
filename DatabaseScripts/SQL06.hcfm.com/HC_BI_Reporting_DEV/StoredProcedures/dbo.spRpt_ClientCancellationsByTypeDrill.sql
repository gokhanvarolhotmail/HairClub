/* CreateDate: 12/26/2013 10:23:50.380 , ModifyDate: 01/17/2018 16:31:12.713 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_ClientCancellationsByTypeDrill
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Client Cancellations Drill Down
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		12/23/2013
------------------------------------------------------------------------
NOTES:
@CancelType = "NB", @CancelType = "PCP"
@Filter = 1 Corporate Regions, 2  Area Managers, 3 Franchise Regions, 4 Centers

12/23/2013 - DL - Rewrote stored procedure (#95426)
02/10/2014 - DL - Updated procedure to join on DimMembershipOrderReason table (#97253)
08/01/2014 - RH - Added Employee1FullName and the latest Employee2FullName
09/15/2014 - DL - Added Gender column (#106414)
05/08/2015 - DL - Added Client Contact columns (#114292)
10/05/2016 - RH - Changed to use synonym [dbo].[synHairclubCMS_datClientMembership] (#127443); removed unused columns; Added #Final for SSRS to work properly
11/07/2016 - RH - Changed parameters to include "By Area Managers", "By Centers" and "By NB" or "By PCP"; Added @MainGroupID (#126190)
12/05/2016 - RH - Added Current Membership Status and Current Membership for active clients; Added @CenterType (#132709)
01/05/2017 - RH - Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description (#132688)
01/13/2017 - RH - Removed the 'Guarantee' in ISNULL(CT.CancelReasonDescription, 'Guarantee') AS 'CancelReasonDescription' (#133903)
03/06/2017 - RH - Added a GROUP BY to remove duplicates in the final statement
01/16/2018 - RH - Removed Regions for Corporate, Added @Filter to be consistent with the other reports (#145957)
------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC spRpt_ClientCancellationsByTypeDrill 'C', '12/15/2017', '1/17/2018',  'NB', 2, 2
EXEC spRpt_ClientCancellationsByTypeDrill 'C', '12/15/2017', '1/17/2018',  'NB', 3, 213

EXEC spRpt_ClientCancellationsByTypeDrill 'F', '12/15/2017', '1/17/2018',  'PCP', 1, 6
EXEC spRpt_ClientCancellationsByTypeDrill 'F', '12/15/2017', '1/17/2018',  'PCP', 3, 745
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ClientCancellationsByTypeDrill]
(		@CenterType NVARCHAR(1)
	,	@StartDate DATETIME
    ,	@EndDate DATETIME
	,	@CancelType VARCHAR(3)
	,	@Filter INT
	,	@MainGroupID INT
	)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
		MainGroupID INT
,		MainGroup VARCHAR(50)
,		CenterSSID INT
,		CenterDescription VARCHAR(255)
,		CenterDescriptionNumber VARCHAR(50)
)


CREATE TABLE #Cancel(
	CenterSSID INT
,	CenterDescriptionNumber NVARCHAR(100)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientName NVARCHAR(150)
,   Address1 NVARCHAR(50)
,	[State] NVARCHAR(10)
,   City NVARCHAR(50)
,	PostalCode NVARCHAR(15)
,	HomePhone NVARCHAR(15)
,	Gender NVARCHAR(50)
,	EmailAddress NVARCHAR(100)
,	ClientMembershipKey INT
,   Department INT
,   Code NVARCHAR(15)
,	[Date] DATETIME
,	MembershipKey INT
,	Membership NVARCHAR(50)
,	Employee1Initials NVARCHAR(102)
,	Employee2Initials NVARCHAR(2)
,   CancelReasonDescription NVARCHAR(100)
,	RevenueGroupDescriptionShort NVARCHAR(10)
,   FreeFormCancelReason NVARCHAR(100)
)


CREATE TABLE #Stylist(
	OrderDate DATETIME
,	ClientKey INT
,	CenterKey INT
,	Employee2Initials NVARCHAR(102)
,	TPRANK INT
)

--DROP TABLE #Final
CREATE TABLE #Final(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterSSID INT
,	CenterDescriptionNumber NVARCHAR(100)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientName NVARCHAR(155)
,	Address1  NVARCHAR(150)
,	[State]  NVARCHAR(50)
,	City   NVARCHAR(50)
,	PostalCode   NVARCHAR(20)
,	HomePhone   NVARCHAR(20)
,	Gender  NVARCHAR(15)
,	EmailAddress   NVARCHAR(150)
,	[Date] DATETIME
,	Employee1Initials  NVARCHAR(102)
,	CancelReasonDescription  NVARCHAR(150)
,	Member1   NVARCHAR(50)
,	Employee2Initials NVARCHAR(2)
,	FreeFormCancelReason  NVARCHAR(MAX)
,	CurrentMembership NVARCHAR(150)
,	CurrentMembershipStatus NVARCHAR(50)
,	CancelType NVARCHAR(3)
)


/******************* Find Centers ************************************************************************/
-- 1 By Franchise Region, 2 By Area Manager, 3 By Center */

IF @Filter = 1 AND @CenterType = 'F'
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS 'MainGroupID'
				,		DR.RegionDescription AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON DC.CenterTypeKey = CT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE   CT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
						AND DC.RegionSSID = @MainGroupID
	END
ELSE
IF @Filter = 2 AND @CenterType = 'C'
	BEGIN
		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
				,		CMA.CenterManagementAreaDescription AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON DC.CenterTypeKey = CT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE DC.Active = 'Y'
						AND CMA.Active = 'Y'
						AND CT.CenterTypeDescriptionShort = 'C'
						AND CMA.CenterManagementAreaSSID = @MainGroupID
	END
ELSE
IF @Filter = 3 AND @CenterType = 'C'
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterSSID AS 'MainGroupID'
				,		DC.CenterDescriptionNumber AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON DC.CenterTypeKey = CT.CenterTypeKey
				WHERE   DC.Active = 'Y'
						AND CT.CenterTypeDescriptionShort = 'C'
						AND DC.CenterSSID = @MainGroupID
	END
ELSE
IF @Filter = 3 AND @CenterType = 'F'
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterSSID AS 'MainGroupID'
				,		DC.CenterDescriptionNumber AS 'MainGroup'
				,		DC.CenterSSID
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON DC.CenterTypeKey = CT.CenterTypeKey
				WHERE   DC.Active = 'Y'
						AND CT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.CenterSSID = @MainGroupID
	END



/***************** Gather All Cancel Transactions into one table **************************************/

INSERT INTO #Cancel
SELECT	DC.CenterSSID
,		DC.CenterDescriptionNumber
,		CLT.ClientKey
,		CLT.ClientIdentifier
,		CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
,       CLT.ClientAddress1 AS 'Address1'
,		CLT.StateProvinceDescriptionShort AS 'State'
,       CLT.City
,		CLT.PostalCode
,       ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Home' THEN CLT.ClientPhone1
             WHEN CLT.ClientPhone2TypeDescriptionShort = 'Home' THEN CLT.ClientPhone2
             WHEN CLT.ClientPhone3TypeDescriptionShort = 'Home' THEN CLT.ClientPhone3
        END, '') AS 'HomePhone'
,		CLT.ClientGenderDescription AS 'Gender'
,		CLT.ClientEMailAddress AS 'EmailAddress'
,		FST.ClientMembershipKey
,       DSC.SalesCodeDepartmentSSID AS 'Department'
,       DSC.SalesCodeDescriptionShort AS 'Code'
,		DD.FullDate AS 'Date'
,		DM.MembershipKey AS 'MembershipKey'
,		DM.MembershipDescription AS 'Membership'
,		DSOD.Employee1Initials AS 'Employee1Initials'
,		CASE WHEN DSOD.Employee2Initials IS NULL THEN '' ELSE DSOD.Employee2Initials END AS 'Employee2Initials'
,       DMOR.MembershipOrderReasonDescription AS 'CancelReasonDescription'
,		DM.RevenueGroupDescriptionShort
,		CM.MembershipCancelReasonDescription AS 'FreeFormCancelReason'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON FST.ClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN [dbo].[synHairclubCMS_datClientMembership] CM
			ON CM.ClientMembershipGUID = DCM.ClientMembershipSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DCM.MembershipSSID = DM.MembershipSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON DCM.CenterKey = DC.CenterKey
		INNER JOIN #Centers
			ON DC.CenterSSID = #Centers.CenterSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON DSOD.SalesOrderKey = DSO.SalesOrderKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembershipOrderReason DMOR
            ON DSOD.MembershipOrderReasonID = DMOR.MembershipOrderReasonID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND ( DSC.SalesCodeDepartmentSSID IN ( 1099 )
              OR ( DSC.SalesCodeDepartmentSSID IN ( 1010 )
                   AND DSC.SalesCodeDescriptionShort IN ( 'TXFROUT' ) ) )


/******** Populate the #Stylist table with the latest stylist  ********************************************/

INSERT INTO #Stylist
SELECT  OrderDate
      , ClientKey
      , CenterKey
      , Employee2Initials
      , TPRANK FROM
		(SELECT DSOD.OrderDate
		,	FST.ClientKey
		,	FST.CenterKey
		,	DSOD.Employee2Initials
		,	ROW_NUMBER() OVER(PARTITION BY FST.ClientKey ORDER BY DSOD.OrderDate DESC) TPRANK
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
			ON FST.SalesOrderKey = DSOD.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCDept
			ON DSC.SalesCodeDepartmentKey = DSCDept.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision DSCDiv
			ON DSCDept.SalesCodeDivisionKey = DSCDiv.SalesCodeDivisionKey
		WHERE DSCDiv.SalesCodeDivisionSSID = 50
		AND DSOD.OrderDate >= DATEADD(MONTH,-12,@StartDate)  --For the past 12 months
		AND FST.ClientKey IN(SELECT ClientKey FROM #cancel)
	) trans
WHERE  TPRANK = 1
AND trans.CenterKey IN (SELECT CenterKey FROM #Centers)


/************ Find Clients with other active memberships/ Converted Clients ************************/

SELECT  #Cancel.CenterSSID
,		#Cancel.ClientKey
,		#Cancel.ClientIdentifier
,		#Cancel.ClientName
,		DCM.MembershipDescriptionShort
,		DCM.MembershipStatus
,		DCM.RevenueGroupSSID
INTO    #Converted
FROM    #Cancel
        CROSS APPLY dbo.fnGetCurrentMembershipDetailsByClientID(#Cancel.ClientIdentifier) DCM


/************ Populate #Final ************************************************************************/

INSERT INTO #Final
SELECT	CTR.MainGroupID
,	CTR.MainGroup
,	CT.CenterSSID
,	CT.CenterDescriptionNumber
,	CT.ClientKey
,	CT.ClientIdentifier
,	CT.ClientName
,	CT.Address1
,	CT.[State]
,	CT.City
,	CT.PostalCode
,	CT.HomePhone
,	CT.Gender
,	CT.EmailAddress
,	CT.[Date]
,	CT.Employee1Initials
,	ISNULL(CT.CancelReasonDescription, '') AS 'CancelReasonDescription'
,	CT.Membership AS 'Member1'
,	ISNULL(CT.Employee2Initials,S.Employee2Initials) AS 'Employee2Initials'
,	ISNULL(CT.FreeFormCancelReason, '') AS 'FreeFormCancelReason'
,	#Converted.MembershipDescriptionShort AS 'CurrentMembership'
,	#Converted.MembershipStatus AS 'CurrentMembershipStatus'
,	@CancelType AS 'CancelType'
FROM   #Cancel CT
INNER JOIN #Centers CTR
	ON CTR.CenterSSID = CT.CenterSSID
LEFT JOIN #Stylist S
	ON CT.ClientKey = S.ClientKey
LEFT JOIN #Converted
	ON CT.ClientIdentifier = #Converted.ClientIdentifier
WHERE  CT.Department = 1099
    AND CT.RevenueGroupDescriptionShort = @CancelType



SELECT MainGroupID
,	MainGroup
,	CenterSSID
,	CenterDescriptionNumber
,	ClientKey
,	ClientIdentifier
,	ClientName
,	Address1
,	[State]
,	City
,	PostalCode
,	HomePhone
,	Gender
,	EmailAddress
,	[Date]
,	Employee1Initials
,	CancelReasonDescription
,	Member1
,	Employee2Initials
,	FreeFormCancelReason
,	CurrentMembership
,	CurrentMembershipStatus
,	CancelType
FROM #Final
GROUP BY MainGroupID
,	MainGroup
,	CenterSSID
,	CenterDescriptionNumber
,	ClientKey
,	ClientIdentifier
,	ClientName
,	Address1
,	[State]
,	City
,	PostalCode
,	HomePhone
,	Gender
,	EmailAddress
,	[Date]
,	Employee1Initials
,	CancelReasonDescription
,	Member1
,	Employee2Initials
,	FreeFormCancelReason
,	CurrentMembership
,	CurrentMembershipStatus
,	CancelType


END
GO
