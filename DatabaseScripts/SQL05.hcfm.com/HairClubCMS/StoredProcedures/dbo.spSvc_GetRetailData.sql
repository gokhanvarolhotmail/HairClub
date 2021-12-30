/* CreateDate: 02/03/2021 18:16:06.610 , ModifyDate: 03/15/2021 15:03:26.360 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetRetailData
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		9/28/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetRetailData 2, NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetRetailData]
(
	@CenterType INT
,	@StartDate DATETIME = NULL
,	@EndDate DATETIME = NULL
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CurrentDate DATETIME


SET @CurrentDate = GETDATE()


-- Set Dates If Parameters are NULL
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentDate), 0))
		SET @EndDate = DATEADD(DAY, -1, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
   END


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	CenterID INT
,	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	CenterType NVARCHAR(50)
)

CREATE TABLE #UTCDate (
	TimeZoneID INT
,	UTCOffset INT
,	UsesDayLightSavingsFlag BIT
,	UTCStartDate DATETIME
,	UTCEndDate DATETIME
)

CREATE TABLE #RetailData (
	CenterNumber INT
,	CenterDescription NVARCHAR(103)
,	InvoiceNumber NVARCHAR(50)
,	ClientIdentifier INT
,	ClientName NVARCHAR(180)
,	Membership NVARCHAR(50)
,	MembershipStatus NVARCHAR(100)
,	OrderDate DATETIME
,	SalesCode NVARCHAR(15)
,	Description NVARCHAR(50)
,	SalesCodeDepartmentID INT
,	Department NVARCHAR(100)
,	Price DECIMAL(18,2)
,	Tax DECIMAL(18,2)
,	Total DECIMAL(18,2)
,	Consultant NVARCHAR(105)
,	ConsultantPayrollID NVARCHAR(20)
,	Stylist NVARCHAR(105)
,	StylistPayrollID NVARCHAR(20)
)


/********************************** Get list of centers *******************************************/
IF @CenterType = 0 OR @CenterType = 2
BEGIN
	INSERT	INTO #Center
			SELECT	ctr.CenterID
			,		ctr.CenterNumber
			,		ctr.CenterDescriptionFullCalc
			,		ct.CenterTypeDescriptionShort
			FROM	cfgCenter ctr WITH (NOLOCK)
					INNER JOIN lkpCenterType ct WITH (NOLOCK)
						ON ct.CenterTypeID = ctr.CenterTypeID
			WHERE	ct.CenterTypeDescriptionShort IN ( 'C', 'HW' )
					AND ctr.IsActiveFlag = 1
END


IF	@CenterType = 0 OR @CenterType = 8
BEGIN
	INSERT	INTO #Center
			SELECT	ctr.CenterID
			,		ctr.CenterNumber
			,		ctr.CenterDescriptionFullCalc
			,		ct.CenterTypeDescriptionShort
			FROM	cfgCenter ctr WITH (NOLOCK)
					INNER JOIN lkpCenterType ct WITH (NOLOCK)
						ON ct.CenterTypeID = ctr.CenterTypeID
			WHERE	ct.CenterTypeDescriptionShort IN ( 'JV', 'F' )
					AND ctr.IsActiveFlag = 1
END


CREATE NONCLUSTERED INDEX IDX_Center_CenterID ON #Center ( CenterID );
CREATE NONCLUSTERED INDEX IDX_Center_CenterNumber ON #Center ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_Center_CenterType ON #Center ( CenterType );


/********************************** Convert @StartDate and @EndDate to UTC ***********************************************/
INSERT	INTO #UTCDate
		SELECT	tz.TimeZoneID
		,		tz.UTCOffset
		,		tz.UsesDayLightSavingsFlag
		,		dbo.GetUTCFromLocal(@StartDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCStartDate'
		,		dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCEndDate'
		FROM	lkpTimeZone tz
		WHERE	tz.IsActiveFlag = 1


CREATE NONCLUSTERED INDEX IDX_UTCDate_TimeZoneID ON #UTCDate ( TimeZoneID );
CREATE NONCLUSTERED INDEX IDX_UTCDate_UTCStartDate ON #UTCDate ( UTCStartDate );
CREATE NONCLUSTERED INDEX IDX_UTCDate_UTCEndDate ON #UTCDate ( UTCEndDate );


/********************************** Get Retail Data ***********************************************/
INSERT	INTO #RetailData
		SELECT	c.CenterNumber
		,		c.CenterDescription
		,		so.InvoiceNumber
		,		clt.ClientIdentifier
		,		CONVERT(VARCHAR, clt.ClientIdentifier) + ' - ' + clt.ClientFullNameAltCalc AS 'ClientName'
		,		m.MembershipDescription AS 'Membership'
		,		cms.ClientMembershipStatusDescription AS 'MembershipStatus'
		,		dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'OrderDate'
		,		sc.SalesCodeDescriptionShort AS 'SalesCode'
		,		sc.SalesCodeDescription AS 'Description'
		,		dep.SalesCodeDepartmentID
		,		dep.SalesCodeDepartmentDescription AS 'Department'
		,		sod.ExtendedPriceCalc AS 'Price'
		,		sod.TotalTaxCalc AS 'Tax'
		,		sod.PriceTaxCalc AS 'Total'
		,		ISNULL(REPLACE(con.EmployeeFullNameCalc, ',', ''), '') AS 'Consultant'
		,		ISNULL(con.EmployeePayrollID, '') AS 'ConsultantPayrollID'
		,		ISNULL(REPLACE(sty.EmployeeFullNameCalc, ',', ''), '') AS 'Stylist'
		,		ISNULL(sty.EmployeePayrollID, '') AS 'StylistPayrollID'
		FROM	datSalesOrderDetail sod
				INNER JOIN datSalesOrder so
					ON so.SalesOrderGUID = sod.SalesOrderGUID
				INNER JOIN cfgSalesCode sc
					ON sc.SalesCodeID = sod.SalesCodeID
				INNER JOIN lkpSalesCodeDepartment dep
					ON dep.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
				INNER JOIN lkpSalesCodeDivision div
					ON div.SalesCodeDivisionID = dep.SalesCodeDivisionID
				INNER JOIN cfgCenter ctr
					ON ctr.CenterID = so.CenterID
				INNER JOIN lkpTimeZone tz
					ON tz.TimeZoneID = ctr.TimeZoneID
				JOIN #UTCDate u
					ON u.TimeZoneID = tz.TimeZoneID
				INNER JOIN #Center c
					ON c.CenterID = ctr.CenterID
				INNER JOIN datClient clt
					ON clt.ClientGUID = so.ClientGUID
				INNER JOIN datClientMembership cm
					ON cm.ClientMembershipGUID = so.ClientMembershipGUID
				INNER JOIN lkpClientMembershipStatus cms
					ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
				INNER JOIN cfgMembership m
					ON m.MembershipID = cm.MembershipID
				LEFT OUTER JOIN datEmployee csh
					ON csh.EmployeeGUID = so.EmployeeGUID
				LEFT OUTER JOIN datEmployee con
					ON con.EmployeeGUID = sod.Employee1GUID
				LEFT OUTER JOIN datEmployee sty
					ON sty.EmployeeGUID = sod.Employee2GUID
		WHERE	so.OrderDate BETWEEN u.UTCStartDate AND u.UTCEndDate
				AND m.MembershipDescriptionShort NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP' ) /* Exclude Employee memberships */
				AND div.SalesCodeDivisionID = 30
				AND so.IsVoidedFlag = 0


CREATE NONCLUSTERED INDEX IDX_RetailData_CenterNumber ON #RetailData ( CenterNumber );
CREATE NONCLUSTERED INDEX IDX_RetailData_CenterDescription ON #RetailData ( CenterDescription );
CREATE NONCLUSTERED INDEX IDX_RetailData_Consultant ON #RetailData ( Consultant );
CREATE NONCLUSTERED INDEX IDX_RetailData_ConsultantPayrollID ON #RetailData ( ConsultantPayrollID );
CREATE NONCLUSTERED INDEX IDX_RetailData_Stylist ON #RetailData ( Stylist );
CREATE NONCLUSTERED INDEX IDX_RetailData_StylistPayrollID ON #RetailData ( StylistPayrollID );


UPDATE STATISTICS #RetailData;


/********************************** Import Results ***********************************************/
TRUNCATE TABLE tmpRetailData


INSERT	INTO tmpRetailData
		SELECT	rd.CenterNumber
		,		rd.CenterDescription
		,		rd.InvoiceNumber
		,		rd.ClientIdentifier
		,		rd.ClientName
		,		rd.Membership
		,		rd.MembershipStatus
		,		rd.OrderDate
		,		rd.SalesCode
		,		rd.Description
		,		rd.SalesCodeDepartmentID
		,		rd.Department
		,		rd.Price
		,		rd.Tax
		,		rd.Total
		,		rd.Consultant
		,		rd.ConsultantPayrollID
		,		rd.Stylist
		,		rd.StylistPayrollID
		FROM	#RetailData rd

END
GO
