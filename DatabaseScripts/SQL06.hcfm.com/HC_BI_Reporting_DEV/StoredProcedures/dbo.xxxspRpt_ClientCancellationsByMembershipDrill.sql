/* CreateDate: 12/26/2013 10:20:49.037 , ModifyDate: 01/06/2017 09:29:46.533 */
GO
/***********************************************************************
PROCEDURE:				spRpt_ClientCancellationsByMembershipDrill
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Client Cancellations Drill Down
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		12/23/2013
------------------------------------------------------------------------
NOTES:

12/23/2013 - DL - Rewrote stored procedure (#95426)
02/10/2014 - DL - Updated procedure to join on DimMembershipOrderReason table (#97253)
08/11/2014 - RH - Added Employee1FullName and the latest Employee2FullName (Executive Task)
09/15/2014 - DL - Added Gender column (#106414)
05/08/2015 - DL - Added Client Contact columns (#114292)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ClientCancellationsByMembershipDrill '6/1/2014', '6/30/2014', 'PCPX', 201, 'BRZ'
***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_ClientCancellationsByMembershipDrill]
(
	@StartDate DATETIME,
	@EndDate DATETIME,
	@CancelType VARCHAR(50),
	@Center INT,
	@Membership VARCHAR(75)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterSSID INT
	,	CenterKey INT
)

CREATE TABLE #cancel(
	Center INT
,	CenterName NVARCHAR(100)
,	ClientKey INT
,	ClientIdentifier INT
,	ClientName NVARCHAR(150)
,   Address1 NVARCHAR(50)
,   Address2 NVARCHAR(50)
,	State NVARCHAR(10)
,   City NVARCHAR(50)
,	PostalCode NVARCHAR(15)
,	Country NVARCHAR(10)
,	HomePhone NVARCHAR(15)
,	WorkPhone NVARCHAR(15)
,   CellPhone NVARCHAR(15)
,	Gender NVARCHAR(50)
,	EmailAddress NVARCHAR(100)
,	ClientMembershipKey INT
,	Region	INT
,   Department INT
,   Code NVARCHAR(15)
,	[Date] DATETIME
,	TicketNumber NVARCHAR(50)
,	TransactionNumber INT
,   Performer NVARCHAR(5)
,	MembershipKey INT
,	Membership NVARCHAR(50)
,   FirstName NVARCHAR(50)
,   LastName NVARCHAR(50)
,	Employee1FullName NVARCHAR(102)
,	Employee2FullName NVARCHAR(102)
,   CancelReasonDescription NVARCHAR(100)
,	RevenueGroupDescriptionShort NVARCHAR(10)
)

CREATE TABLE #stylist(OrderDate DATETIME
	,	ClientKey INT
	,	CenterKey INT
	,	Employee2FullName NVARCHAR(102)
	,	TPRANK INT
)


/********************************** Get list of centers *************************************/
IF @Center BETWEEN 201 AND 896 -- A Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
				,	CenterKey
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   DC.CenterSSID = @Center
				AND DC.Active = 'Y'
	END
ELSE IF @Center IN ( -2, 2, 3, 4, 5, 6, 1, 7, 8, 9, 10, 11, 12, 13, 14, 15 ) -- A Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
				,	CenterKey
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
		WHERE   DR.RegionSSID = @Center
				AND DC.Active = 'Y'
	END

INSERT INTO #cancel
SELECT	DC.CenterSSID AS 'CenterSSID'
,		DC.CenterDescriptionNumber AS 'CenterName'
,		CLT.ClientKey
,		CLT.ClientIdentifier
,		CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
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
,		DR.RegionSSID AS 'Region'
,       DSC.SalesCodeDepartmentSSID AS 'Department'
,       DSC.SalesCodeDescriptionShort AS 'Code'
,		DD.FullDate AS 'Date'
,		CASE WHEN DSO.TicketNumber_Temp = 0 THEN CONVERT(VARCHAR, DSO.InvoiceNumber) ELSE CONVERT(VARCHAR, DSO.TicketNumber_Temp) END AS 'TicketNumber'
,		CASE WHEN DSOD.TransactionNumber_Temp = -1 THEN CONVERT(VARCHAR, DSOD.SalesOrderDetailKey) ELSE CONVERT(VARCHAR, DSOD.TransactionNumber_Temp) END AS 'TransactionNumber'
,       DE1.EmployeeInitials AS 'Performer'
,		DM.MembershipKey AS 'MembershipKey'
,		DM.MembershipDescriptionShort AS 'Membership'
,       DE1.EmployeeFirstName AS 'FirstName'
,       DE1.EmployeeLastName AS 'LastName'
,		DSOD.Employee1FullName
,		DSOD.Employee2FullName
,       DMOR.MembershipOrderReasonDescription AS 'CancelReasonDescription'
,		DM.RevenueGroupDescriptionShort
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON FST.ClientMembershipKey = DCM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DCM.MembershipSSID = DM.MembershipSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON DCM.CenterKey = DC.CenterKey
		INNER JOIN #Centers
			ON DC.ReportingCenterSSID = #Centers.CenterSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
            ON DC.RegionKey = DR.RegionKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON DSOD.SalesOrderKey = DSO.SalesOrderKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembershipOrderReason DMOR
            ON DSOD.MembershipOrderReasonID = DMOR.MembershipOrderReasonID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE1
			ON FST.Employee1Key = DE1.EmployeeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSC.SalesCodeDepartmentSSID IN ( 1010, 1099 )
ORDER BY DD.FullDate
,		DSO.InvoiceNumber

--Remove commas for Employee2FullName

UPDATE #cancel
SET Employee2FullName = NULL
WHERE LTRIM(RTRIM(Employee2FullName)) = ','

---Populate the #stylist table with the latest stylist

INSERT INTO #stylist
SELECT  OrderDate
      , ClientKey
      , CenterKey
      , Employee2FullName
      , TPRANK FROM
		(SELECT DSOD.OrderDate
		,	FST.ClientKey
		,	FST.CenterKey
		,	DSOD.Employee2FullName
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


SELECT  CT.Center
,       CT.CenterName
,		CT.ClientKey
,		CT.ClientIdentifier
,		CT.ClientName
,		CT.Address1
,		CT.Address2
,		CT.State
,		CT.City
,		CT.PostalCode
,		CT.Country
,		CT.HomePhone
,		CT.WorkPhone
,		CT.CellPhone
,		CT.Gender
,		CT.EmailAddress
,       CT.Date
,       CT.TicketNumber AS 'ticket_no'
,       CT.TransactionNumber AS 'transact_no'
,       CT.Performer
,       CT.FirstName AS 'First_Name'
,       CT.LastName AS 'Last_Name'
,		CT.Employee1FullName
,       ISNULL(CT.CancelReasonDescription, 'Unknown') AS 'CancelReasonDescription'
,       CT.Membership AS 'Member1'
,       'NB1X' AS CancelType
,		ISNULL(CT.Employee2FullName,S.Employee2FullName) AS 'Employee2FullName'
FROM   #cancel CT
	LEFT JOIN #stylist S
			ON CT.ClientKey = S.ClientKey
WHERE   CT.Department = 1099
        AND CT.RevenueGroupDescriptionShort = 'NB'
        AND CT.Code <> 'TXFROUT'
        AND CT.Membership = @Membership
UNION
SELECT  CT.Center
,       CT.CenterName
,		CT.ClientKey
,		CT.ClientIdentifier
,		CT.ClientName
,		CT.Address1
,		CT.Address2
,		CT.State
,		CT.City
,		CT.PostalCode
,		CT.Country
,		CT.HomePhone
,		CT.WorkPhone
,		CT.CellPhone
,		CT.Gender
,		CT.EmailAddress
,       CT.Date
,       CT.TicketNumber AS 'ticket_no'
,       CT.TransactionNumber AS 'transact_no'
,       CT.Performer
,       CT.FirstName AS 'First_Name'
,       CT.LastName AS 'Last_Name'
,		CT.Employee1FullName
,       ISNULL(CT.CancelReasonDescription, 'Unknown') AS 'CancelReasonDescription'
,       CT.Membership AS 'Member1'
,       'PCPX' AS CancelType
,		ISNULL(CT.Employee2FullName,S.Employee2FullName) AS 'Employee2FullName'
FROM   #cancel CT
	LEFT JOIN #stylist S
			ON CT.ClientKey = S.ClientKey
WHERE   CT.Department = 1099
        AND CT.RevenueGroupDescriptionShort = 'PCP'
        AND CT.Membership = @Membership
UNION
SELECT  CT.Center
,       CT.CenterName
,		CT.ClientKey
,		CT.ClientIdentifier
,		CT.ClientName
,		CT.Address1
,		CT.Address2
,		CT.State
,		CT.City
,		CT.PostalCode
,		CT.Country
,		CT.HomePhone
,		CT.WorkPhone
,		CT.CellPhone
,		CT.Gender
,		CT.EmailAddress
,       CT.Date
,       CT.TicketNumber AS 'ticket_no'
,       CT.TransactionNumber AS 'transact_no'
,       CT.Performer
,       CT.FirstName AS 'First_Name'
,       CT.LastName AS 'Last_Name'
,		CT.Employee1FullName
,       ISNULL(CT.CancelReasonDescription, 'Unknown') AS 'CancelReasonDescription'
,       CT.Membership AS 'Member1'
,       'TXFROUT' AS CancelType
,		ISNULL(CT.Employee2FullName,S.Employee2FullName) AS 'Employee2FullName'
FROM   #cancel CT
	LEFT JOIN #stylist S
			ON CT.ClientKey = S.ClientKey
WHERE   CT.Department = 1010
        AND CT.Code = 'TXFROUT'
        AND CT.Membership = @Membership

END
GO
