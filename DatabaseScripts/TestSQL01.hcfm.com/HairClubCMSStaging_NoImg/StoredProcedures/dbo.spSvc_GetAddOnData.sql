/* CreateDate: 05/28/2020 09:54:05.817 , ModifyDate: 07/01/2020 10:21:52.117 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetAddOnData
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		5/28/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetAddOnData
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetAddOnData]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CenterType INT
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @CenterType = 2
SET @StartDate = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, CURRENT_TIMESTAMP), 0))
SET @EndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, GETDATE())) + 1 , 0))


SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Center (
	CenterID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
)

CREATE TABLE #Client (
	SalesCode NVARCHAR(15)
,	SalesCodeDescription NVARCHAR(50)
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	MembershipID INT
,	Membership NVARCHAR(50)
,	ClientTotal INT
)

CREATE TABLE #DistinctMembership (
	MembershipID INT
)

CREATE TABLE #MembershipAccum (
	MembershipID INT
,	MembershipDescription NVARCHAR(50)
,	MembershipDescriptionShort NVARCHAR(10)
,	SystemsAvailable INT
,	ServicesAvailable INT
,	SolutionsAvailable INT
,	ProductKitsAvailable INT
)


/********************************** Get list of centers *******************************************/
IF @CenterType = 0 OR @CenterType = 2
	BEGIN
		INSERT  INTO #Center
				SELECT  ctr.CenterID
				,		ctr.CenterDescriptionFullCalc
				,		ct.CenterTypeDescriptionShort
				FROM    cfgCenter ctr WITH (NOLOCK)
						INNER JOIN lkpCenterType ct WITH (NOLOCK)
							ON ct.CenterTypeID = ctr.CenterTypeID
				WHERE   ct.CenterTypeDescriptionShort IN ( 'C' )
						AND ctr.IsActiveFlag = 1
	END


IF @CenterType = 0 OR @CenterType = 8
	BEGIN
		INSERT  INTO #Center
				SELECT  ctr.CenterID
				,		ctr.CenterDescriptionFullCalc
				,		ct.CenterTypeDescriptionShort
				FROM    cfgCenter ctr WITH (NOLOCK)
						INNER JOIN lkpCenterType ct WITH (NOLOCK)
							ON ct.CenterTypeID = ctr.CenterTypeID
				WHERE   ct.CenterTypeDescriptionShort IN ( 'JV', 'F' )
						AND ctr.IsActiveFlag = 1
	END


/********************************** Convert @StartDate and @EndDate to UTC ***********************************************/
SELECT  tz.TimeZoneID
,       tz.UTCOffset
,       tz.UsesDayLightSavingsFlag
,       tz.IsActiveFlag
,       dbo.GetUTCFromLocal(@StartDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCStartDate'
,       dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCEndDate'
INTO    #UTCDate
FROM    HairClubCMS.dbo.lkpTimeZone tz
WHERE   tz.IsActiveFlag = 1


/********************************** Get Client Data *************************************/
INSERT	INTO #Client
		SELECT  sc.SalesCodeDescriptionShort
		,		sc.SalesCodeDescription
		,		cm.ClientMembershipGUID
		,		m.MembershipID
		,		m.MembershipDescription AS 'Membership'
		,		COUNT(*) AS 'ClientTotal'
		FROM    HairClubCMS.dbo.datSalesOrderDetail sod
				INNER JOIN HairClubCMS.dbo.datSalesOrder so
					ON so.SalesOrderGUID = sod.SalesOrderGUID
				INNER JOIN HairClubCMS.dbo.cfgSalesCode sc
					ON sc.SalesCodeID = sod.SalesCodeID
				INNER JOIN HairClubCMS.dbo.cfgCenter ctr
					ON ctr.CenterID = so.CenterID
				INNER JOIN HairClubCMS.dbo.lkpTimeZone tz
					ON tz.TimeZoneID = ctr.TimeZoneID
				JOIN #UTCDate u
					ON u.TimeZoneID = tz.TimeZoneID
				INNER JOIN #Center c
					ON c.CenterID = ctr.CenterID
				INNER JOIN HairClubCMS.dbo.datClient clt
					ON clt.ClientGUID = so.ClientGUID
				INNER JOIN HairClubCMS.dbo.datClientMembership cm
					ON cm.ClientMembershipGUID = so.ClientMembershipGUID
				INNER JOIN HairClubCMS.dbo.cfgMembership m
					ON m.MembershipID = cm.MembershipID
		WHERE   so.OrderDate BETWEEN u.UTCStartDate AND u.UTCEndDate
				AND sc.SalesCodeDescriptionShort IN ( 'ADDONSH', 'ADDONLH', 'ADDONOM', 'ADDONEL', 'ADDONRS', 'ADDONCIH', 'ADDONCIHNB' )
				AND so.IsVoidedFlag = 0
		GROUP BY sc.SalesCodeDescriptionShort
		,		sc.SalesCodeDescription
		,		cm.ClientMembershipGUID
		,		m.MembershipID
		,		m.MembershipDescription


/********************************** Get Distinct Membership Data *************************************/
INSERT	INTO #DistinctMembership
		SELECT	DISTINCT
				MembershipID
		FROM	#Client c


/********************************** Get Membership Accum Data *************************************/
INSERT	INTO #MembershipAccum
		SELECT	m.MembershipID
		,		m.MembershipDescription
		,		m.MembershipDescriptionShort
		,		SUM(CASE WHEN a.AccumulatorID IN ( 8 ) THEN ISNULL(ma.InitialQuantity, 0) ELSE 0 END) AS 'SystemsAvailable'
		,       SUM(CASE WHEN a.AccumulatorID IN ( 9 ) THEN ISNULL(ma.InitialQuantity, 0) ELSE 0 END) AS 'ServicesAvailable'
		,       SUM(CASE WHEN a.AccumulatorID IN ( 10 ) THEN ISNULL(ma.InitialQuantity, 0) ELSE 0 END) AS 'SolutionsAvailable'
		,       SUM(CASE WHEN a.AccumulatorID IN ( 11 ) THEN ISNULL(ma.InitialQuantity, 0) ELSE 0 END) AS 'ProductKitsAvailable'
		FROM	cfgMembershipAccum ma
				INNER JOIN cfgAccumulator a
					ON a.AccumulatorID = ma.AccumulatorID
				INNER JOIN cfgMembership m
					ON m.MembershipID = ma.MembershipID
				INNER JOIN #DistinctMembership dm
					ON dm.MembershipID = m.MembershipID
		WHERE	a.AccumulatorID IN ( 8, 9, 10, 11 )
		GROUP BY m.MembershipID
		,		m.MembershipDescription
		,		m.MembershipDescriptionShort


/********************************** Combine & Return Data *************************************/
DECLARE	@SHRevenue DECIMAL(18,2) = 50.00
DECLARE	@HCCost DECIMAL(18,2) = 10.00


SELECT	c.SalesCodeDescription AS 'Add-On'
,		c.Membership
,		ma.SystemsAvailable AS 'SystemsTotal'
,		SUM(c.ClientTotal) AS 'AddOnSalesTotal'
,		( ( ma.SystemsAvailable * @SHRevenue ) * SUM(c.ClientTotal) ) AS 'ExpectedRevenue'
FROM	#Client c
		INNER JOIN #MembershipAccum ma
			ON ma.MembershipID = c.MembershipID
GROUP BY c.SalesCodeDescription
,		c.Membership
,		ma.SystemsAvailable

END
GO
