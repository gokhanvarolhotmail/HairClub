/* CreateDate: 12/26/2013 11:26:56.880 , ModifyDate: 05/10/2019 10:37:35.423 */
GO
/******************************************************************************************************************
PROCEDURE:				spRpt_ClientCancellationsByReasonDrill
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Client Cancellations Drill Down
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		12/23/2013
------------------------------------------------------------------------------------------------------------------
NOTES:
@CancelType = 'NB' or 'PCP'
@Filter = 1 Franchise Regions, 2  Area Managers, 3 Centers
------------------------------------------------------------------------------------------------------------------
CHANGE HISTORY:

12/23/2013 - DL - Rewrote stored procedure (#95426)
02/10/2014 - DL - Updated procedure to join on DimMembershipOrderReason table (#97253)
08/11/2014 - RH - Added Employee1FullName and the latest Employee2FullName
09/15/2014 - DL - Added Gender column (#106414)
05/08/2015 - DL - Added Client Contact columns (#114292)
10/05/2016 - RH - Changed to use synonym [dbo].[synHairclubCMS_datClientMembership] (#127443)
11/07/2016 - RH - Changed parameters to include "By Area Managers", "By Centers" and "By NB" or "By PCP" (#126190)
12/05/2016 - RH - Added Current Membership Status and Current Membership for active clients (#132709)
01/05/2017 - RH - Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description (#132688)
01/16/2018 - RH - Removed Regions for Corporate, Added @CenterType and @Filter to be consistent with the other reports (#145957)
------------------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ClientCancellationsByReasonDrill '5/1/2019', '5/9/2019', 'C', 'PCP', 0, 'All'
EXEC spRpt_ClientCancellationsByReasonDrill '5/1/2019', '5/9/2019', 'C', 'PCP', 10, 'Data Entry Error'

EXEC spRpt_ClientCancellationsByReasonDrill '5/1/2019', '5/9/2019', 'F', 'PCP', 10, 'Data Entry Error'
*******************************************************************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ClientCancellationsByReasonDrill]
(
		@StartDate DATETIME
,		@EndDate DATETIME
,		@CenterType NVARCHAR(1)
,		@CancelType VARCHAR(3)
,		@CancelReasonID INT
,		@CancelReason VARCHAR(100)
)

AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterDescriptionNumber VARCHAR(50)
)

CREATE TABLE #Cancel(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterSSID INT
,	CenterDescriptionNumber NVARCHAR(100)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientName NVARCHAR(150)
,   Address1 NVARCHAR(50)
,   Address2 NVARCHAR(50)
,	[State] NVARCHAR(10)
,   City NVARCHAR(50)
,	PostalCode NVARCHAR(15)
,	Country NVARCHAR(10)
,	HomePhone NVARCHAR(15)
,	WorkPhone NVARCHAR(15)
,   CellPhone NVARCHAR(15)
,	Gender NVARCHAR(50)
,	EmailAddress NVARCHAR(100)
,	ClientMembershipKey INT
,   Department INT
,   Code NVARCHAR(15)
,	[Date] DATETIME
,	TicketNumber NVARCHAR(50)
,	TransactionNumber INT
,	MembershipKey INT
,	Membership NVARCHAR(50)
,	Employee1Initials NVARCHAR(2)
,	Employee2Initials NVARCHAR(2)
,	CancelReasonID INT
,   CancelReasonDescription NVARCHAR(100)
,	RevenueGroupDescriptionShort NVARCHAR(10)
,   FreeFormCancelReason NVARCHAR(MAX)
)

CREATE TABLE #Stylist(OrderDate DATETIME
	,	ClientKey INT
	,	CenterKey INT
	,	Employee2Initials NVARCHAR(2)
	,	TPRANK INT
)

CREATE TABLE #Final(
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterSSID INT
,	CenterDescriptionNumber NVARCHAR(100)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientName NVARCHAR(150)
,   Address1 NVARCHAR(50)
,   Address2 NVARCHAR(50)
,	[State] NVARCHAR(10)
,   City NVARCHAR(50)
,	PostalCode NVARCHAR(15)
,	Country NVARCHAR(10)
,	HomePhone NVARCHAR(15)
,	WorkPhone NVARCHAR(15)
,   CellPhone NVARCHAR(15)
,	Gender NVARCHAR(50)
,	EmailAddress NVARCHAR(100)
,   Department INT
,   Code NVARCHAR(15)
,	[Date] DATETIME
,	TicketNumber NVARCHAR(50)
,	TransactionNumber INT
,	Employee1Initials NVARCHAR(2)
,	Employee2Initials NVARCHAR(2)
,	MembershipKey INT
,	Membership NVARCHAR(50)
,	CancelReasonDescription NVARCHAR(100)
,	RevenueGroupDescriptionShort NVARCHAR(10)
,   FreeFormCancelReason NVARCHAR(MAX)
,	CurrentMembership NVARCHAR(50)
,	CurrentMembershipStatus NVARCHAR(50)
,	CancelType NVARCHAR(3)
)




/******************* Find Centers ************************************************************************/

-- 1 By Franchise Region, 2 By Area Manager, 3 By Center */

IF @CenterType = 'F'
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
	END
ELSE
IF @CenterType = 'C'
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
	END


/************ Gather All Cancel Transactions into one table ********************************************/

INSERT INTO #Cancel
SELECT	DISTINCT
		MainGroupID
,		MainGroup
,		DC.CenterSSID AS 'CenterSSID'
,		DC.CenterDescriptionNumber
,		CLT.ClientKey
,		CLT.ClientIdentifier
,		CLT.ClientFullName + ' (' + CONVERT(VARCHAR, CLT.ClientIdentifier) + ')' AS 'ClientName'
,       CLT.ClientAddress1 AS 'Address1'
,       CLT.ClientAddress2 AS 'Address2'
,		CLT.StateProvinceDescriptionShort AS 'State'
,       CLT.City
,		CLT.PostalCode
,		CLT.CountryRegionDescriptionShort AS 'Country'
,       ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Home' THEN CLT.ClientPhone1
             WHEN CLT.ClientPhone2TypeDescriptionShort = 'Home' THEN CLT.ClientPhone2
             WHEN CLT.ClientPhone3TypeDescriptionShort = 'Home' THEN CLT.ClientPhone3
        END, '') AS 'HomePhone'
,       ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Work' THEN CLT.ClientPhone1
             WHEN CLT.ClientPhone2TypeDescriptionShort = 'Work' THEN CLT.ClientPhone2
             WHEN CLT.ClientPhone3TypeDescriptionShort = 'Work' THEN CLT.ClientPhone3
        END, '') AS 'WorkPhone'
,       ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Mobile' THEN CLT.ClientPhone1
             WHEN CLT.ClientPhone2TypeDescriptionShort = 'Mobile' THEN CLT.ClientPhone2
             WHEN CLT.ClientPhone3TypeDescriptionShort = 'Mobile' THEN CLT.ClientPhone3
        END, '') AS 'CellPhone'
,		CLT.ClientGenderDescription AS 'Gender'
,		CLT.ClientEMailAddress AS 'EmailAddress'
,		DCM.ClientMembershipKey
,       DSC.SalesCodeDepartmentSSID AS 'Department'
,       DSC.SalesCodeDescriptionShort AS 'Code'
,		DD.FullDate AS 'Date'
,		CASE WHEN DSO.TicketNumber_Temp = 0 THEN CONVERT(VARCHAR, DSO.InvoiceNumber) ELSE CONVERT(VARCHAR, DSO.TicketNumber_Temp) END AS 'TicketNumber'
,		CASE WHEN DSOD.TransactionNumber_Temp = -1 THEN CONVERT(VARCHAR, DSOD.SalesOrderDetailKey) ELSE CONVERT(VARCHAR, DSOD.TransactionNumber_Temp) END AS 'TransactionNumber'
,		DM.MembershipKey AS 'MembershipKey'
,		DM.MembershipDescription AS 'Membership'
,		DSOD.Employee1Initials
,		DSOD.Employee2Initials
,       ISNULL(DMOR.MembershipOrderReasonID, -1) AS 'CancelReasonID'
,       ISNULL(DMOR.MembershipOrderReasonDescription, 'Unknown') AS 'CancelReasonDescription'
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
GROUP BY MainGroupID
,		MainGroup
,		CLT.ClientFullName + ' (' + CONVERT(VARCHAR, CLT.ClientIdentifier) + ')'
       , ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Home'
       THEN CLT.ClientPhone1
       WHEN CLT.ClientPhone2TypeDescriptionShort = 'Home'
       THEN CLT.ClientPhone2
       WHEN CLT.ClientPhone3TypeDescriptionShort = 'Home'
       THEN CLT.ClientPhone3
       END ,'')
       , ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Work'
       THEN CLT.ClientPhone1
       WHEN CLT.ClientPhone2TypeDescriptionShort = 'Work'
       THEN CLT.ClientPhone2
       WHEN CLT.ClientPhone3TypeDescriptionShort = 'Work'
       THEN CLT.ClientPhone3
       END ,'')
       , ISNULL(CASE WHEN CLT.ClientPhone1TypeDescriptionShort = 'Mobile'
       THEN CLT.ClientPhone1
       WHEN CLT.ClientPhone2TypeDescriptionShort = 'Mobile'
       THEN CLT.ClientPhone2
       WHEN CLT.ClientPhone3TypeDescriptionShort = 'Mobile'
       THEN CLT.ClientPhone3
       END ,'')
       , CASE WHEN DSO.TicketNumber_Temp = 0
       THEN CONVERT(VARCHAR ,DSO.InvoiceNumber)
       ELSE CONVERT(VARCHAR ,DSO.TicketNumber_Temp)
       END
       , CASE WHEN DSOD.TransactionNumber_Temp = -1
       THEN CONVERT(VARCHAR ,DSOD.SalesOrderDetailKey)
       ELSE CONVERT(VARCHAR ,DSOD.TransactionNumber_Temp)
       END
       , ISNULL(DMOR.MembershipOrderReasonID ,-1)
       , ISNULL(DMOR.MembershipOrderReasonDescription ,'Unknown')
       , DC.CenterSSID
       , DC.CenterDescriptionNumber
       , CLT.ClientKey
       , CLT.ClientIdentifier
       , CLT.ClientAddress1
       , CLT.ClientAddress2
       , CLT.StateProvinceDescriptionShort
       , CLT.City
       , CLT.PostalCode
       , CLT.CountryRegionDescriptionShort
       , CLT.ClientGenderDescription
       , CLT.ClientEMailAddress
       , DCM.ClientMembershipKey
       , DSC.SalesCodeDepartmentSSID
       , DSC.SalesCodeDescriptionShort
       , DD.FullDate
       , DM.MembershipKey
       , DM.MembershipDescription
       , DSOD.Employee1Initials
       , DSOD.Employee2Initials
       , DM.RevenueGroupDescriptionShort
	   , CM.MembershipCancelReasonDescription



/********** Populate the #Stylist table with the latest stylist *****************************************/

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
		AND FST.ClientKey IN(SELECT ClientKey FROM #Cancel)
		AND Employee2Initials IS NOT NULL
	) trans
WHERE  TPRANK = 1
AND trans.CenterKey IN (SELECT CenterKey FROM #Centers)

/************ Find Clients with other active memberships/ Converted Clients ************************/

--SELECT  #Cancel.CenterSSID
--,		#Cancel.ClientKey
--,		#Cancel.ClientIdentifier
--,		#Cancel.ClientName
--,		DCM.Membership
--,		DCM.MembershipStatus
--,		DCM.RevenueGroupSSID
--INTO    #Converted
--FROM    #Cancel
--        CROSS APPLY dbo.fnGetCurrentMembershipDetailsByClientID(#Cancel.ClientIdentifier) DCM

SELECT  DISTINCT
		#Cancel.CenterSSID
	,	#Cancel.ClientKey
	,	#Cancel.ClientIdentifier
	,	#Cancel.ClientName
	,	DCM.MembershipDescriptionShort AS 'Membership'
	,	DCM.MembershipStatus AS 'MembershipStatus'
	,	DCM.RevenueGroupSSID
INTO    #Converted
FROM    #Cancel
        CROSS APPLY dbo.fnGetCurrentMembershipDetailsByClientID(#Cancel.ClientIdentifier) DCM


/**************** Final select statement ************************************************************/

IF @CancelReasonID = 0
BEGIN
INSERT INTO #Final
SELECT DISTINCT
		CT.MainGroupID
,		MainGroup
,		CT.CenterSSID
,		CT.CenterDescriptionNumber
,		CT.ClientKey
,		CT.ClientIdentifier
,		CT.ClientName
,		CT.Address1
,		CT.Address2
,		CT.[State]
,		CT.City
,		CT.PostalCode
,		CT.Country
,		CT.HomePhone
,		CT.WorkPhone
,		CT.CellPhone
,		CT.Gender
,		CT.EmailAddress
,		CT.Department
,		CT.Code
,		CT.[Date]
,		CT.TicketNumber
,		CT.TransactionNumber
,		CT.Employee1Initials
,		ISNULL(CT.Employee2Initials,S.Employee2Initials) AS 'Employee2Initials'
,		CT.MembershipKey
,		CT.Membership
,		CT.CancelReasonDescription
,		CT.RevenueGroupDescriptionShort
,		ISNULL(CT.FreeFormCancelReason, '') AS 'FreeFormCancelReason'
,		#Converted.Membership AS 'CurrentMembership'
,		#Converted.MembershipStatus AS 'CurrentMembershipStatus'
,		@CancelType AS 'CancelType'
FROM   #Cancel CT
LEFT JOIN #Stylist S
	ON CT.ClientKey = S.ClientKey
LEFT JOIN #Converted
	ON CT.ClientIdentifier = #Converted.ClientIdentifier
WHERE CT.RevenueGroupDescriptionShort = @CancelType
GROUP BY CT.MainGroupID
,		CT.MainGroup
,		ISNULL(CT.Employee2Initials ,S.Employee2Initials)
,		ISNULL(CT.FreeFormCancelReason ,'')
,		CT.CenterSSID
,		CT.CenterDescriptionNumber
,		CT.ClientKey
,		CT.ClientIdentifier
,		CT.ClientName
,		CT.Address1
,		CT.Address2
,		CT.[State]
,		CT.City
,		CT.PostalCode
,		CT.Country
,		CT.HomePhone
,		CT.WorkPhone
,		CT.CellPhone
,		CT.Gender
,		CT.EmailAddress
,		CT.Department
,		CT.Code
,		CT.[Date]
,		CT.TicketNumber
,		CT.TransactionNumber
,		CT.Employee1Initials
,		CT.MembershipKey
,		CT.Membership
,		CT.CancelReasonDescription
,		CT.RevenueGroupDescriptionShort
,		#Converted.Membership
,		MembershipStatus
END
ELSE
BEGIN
INSERT INTO #Final
SELECT  DISTINCT
		CT.MainGroupID
,		CT.MainGroup
,		CT.CenterSSID
,		CT.CenterDescriptionNumber
,		CT.ClientKey
,		CT.ClientIdentifier
,		CT.ClientName
,		CT.Address1
,		CT.Address2
,		CT.[State]
,		CT.City
,		CT.PostalCode
,		CT.Country
,		CT.HomePhone
,		CT.WorkPhone
,		CT.CellPhone
,		CT.Gender
,		CT.EmailAddress
,		CT.Department
,		CT.Code
,		CT.[Date]
,		CT.TicketNumber
,		CT.TransactionNumber
,		CT.Employee1Initials
,		ISNULL(CT.Employee2Initials,S.Employee2Initials) AS 'Employee2Initials'
,		CT.MembershipKey
,		CT.Membership
,		CT.CancelReasonDescription
,		CT.RevenueGroupDescriptionShort
,		ISNULL(CT.FreeFormCancelReason, '') AS 'FreeFormCancelReason'
,		#Converted.Membership AS 'CurrentMembership'
,		#Converted.MembershipStatus AS 'CurrentMembershipStatus'
,		@CancelType AS 'CancelType'
FROM   #Cancel CT
LEFT JOIN #Stylist S
	ON CT.ClientKey = S.ClientKey
LEFT JOIN #Converted
	ON CT.ClientIdentifier = #Converted.ClientIdentifier
WHERE	CT.CancelReasonID = @CancelReasonID
	AND CT.RevenueGroupDescriptionShort = @CancelType
GROUP BY CT.MainGroupID
,		CT.MainGroup
,		ISNULL(CT.Employee2Initials ,S.Employee2Initials)
,		ISNULL(CT.FreeFormCancelReason ,'')
,		CT.CenterSSID
,		CT.CenterDescriptionNumber
,		CT.ClientKey
,		CT.ClientIdentifier
,		CT.ClientName
,		CT.Address1
,		CT.Address2
,		CT.[State]
,		CT.City
,		CT.PostalCode
,		CT.Country
,		CT.HomePhone
,		CT.WorkPhone
,		CT.CellPhone
,		CT.Gender
,		CT.EmailAddress
,		CT.Department
,		CT.Code
,		CT.[Date]
,		CT.TicketNumber
,		CT.TransactionNumber
,		CT.Employee1Initials
,		CT.MembershipKey
,		CT.Membership
,		CT.CancelReasonDescription
,		CT.RevenueGroupDescriptionShort
,		#Converted.Membership
,		MembershipStatus
   END

SELECT DISTINCT * FROM #Final

END
GO
