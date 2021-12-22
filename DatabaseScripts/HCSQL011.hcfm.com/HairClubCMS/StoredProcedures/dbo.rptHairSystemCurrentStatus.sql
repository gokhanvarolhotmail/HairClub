/* CreateDate: 12/31/2010 13:23:30.813 , ModifyDate: 11/19/2020 15:03:51.063 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				rptHairSystemCurrentStatus

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		11/18/10

LAST REVISION DATE: 	08/15/11

--------------------------------------------------------------------------------------------------------
NOTES:

01/14/2011 - MLM - Add Handling for Corporate, Franchise, And Joint Venture Groups
01/21/2011 - MLM - Changed the join on HairSystemOrder from CenterID to ClientHomeCenterID
01/25/2011 - MLM - Changed the Stored Procedure to Pass in the EmployeeGUID instead of UserLogin
02/11/2011 - MLM - Added IncAll Parameters to 'Hack' around the Select All
02/25/2011 - MLM - Exclude Center 100 from corporate Centers Group
03/01/2011 - MLM - Removed Measuredby and EnteredBy
07/06/2011 - AMH - Changed Center Join to be off of CenterID instead of ClientHomeCenterID
08/11/2011 - MVT - Modified to check ClientHomeCenterID when searchin for orders in 'ORDER' status.
08/15/2011 - MVT - Modified so that Security is checked on the home center for the user if searching for orders in 'ORDER' status.
02/01/2012 - HDU - Tried to speed up the report by minimizing the fnSplit function call in the main query by using @Tables and redesigning the query to use left joins
03/15/2012 - HDU - Fix error in query.
07/31/2014 - RMH - Commented out the ORDER BY and added Sorting to the report to speed up the query.
09/21/2016 - RMH - Rewrote the stored procedure to not use Employee GUID for security (#130255)
05/22/2018 - RMH - (#146745) Added MembershipStatus and MembershipEndDate
03/04/2020 - DSL - Changed the way #Center was populated to accomodate when a specific Center Type is selected
11/18/2020 - AAM - (TFS14698) Add homeCenter.CenterDescription
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC rptHairSystemCurrentStatus 100, '1', '1', '10'

EXEC rptHairSystemCurrentStatus  100
	,	'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,45,46,47,48,49,50,51,52,44'
	,	'31,17,18,11,10,12,1,13,14,15,16,80,22,23,24,28,29,79,34,35,32,33,2,9,56,3,4,6,7,8,81,19,20,25,26,27,36,37,21'
	,	'4'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptHairSystemCurrentStatus]
 (		@CenterID INT
	,	@MembershipIDs NVARCHAR(MAX)
	,	@HairSystemIDs NVARCHAR(MAX)
	,	@HairSystemOrderStatusIDs NVARCHAR(MAX)
	)
AS
BEGIN
	SET NOCOUNT ON;

	--DROP TABLE #Member
	--DROP TABLE #HairSystem
	--DROP TABLE #Status
	--DROP TABLE #Centers

/**************** Create temp tables *******************************************************/


CREATE TABLE #Centers ( CenterID INT, CenterNumber INT )

CREATE TABLE #Status (StatusID NVARCHAR(MAX))

CREATE TABLE #HairSystem (HairSystemID NVARCHAR(MAX))

CREATE TABLE #Member (MemberID NVARCHAR(MAX))

/************** Find OrderStatusID where status description is 'ORDER' ************************************/

DECLARE @OrderStatusID INT
SET @OrderStatusID = (SELECT HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'ORDER') --8

/************* Populate the temp tables by splitting the strings *****************************************/

IF @CenterID = 1 --Corporate Centers
BEGIN
	INSERT  INTO #Centers
			SELECT  ctr.CenterID
			,		ctr.CenterNumber
			FROM	cfgCenter ctr
					INNER JOIN lkpCenterType ct
						ON ct.CenterTypeID = ctr.CenterTypeID
			WHERE	ct.CenterTypeDescriptionShort = 'C'
					AND ctr.IsActiveFlag = 1
END
ELSE IF @CenterID = 2 --Franchise Centers
BEGIN
	INSERT  INTO #Centers
			SELECT  ctr.CenterID
			,		ctr.CenterNumber
			FROM	cfgCenter ctr
					INNER JOIN lkpCenterType ct
						ON ct.CenterTypeID = ctr.CenterTypeID
			WHERE	ct.CenterTypeDescriptionShort = 'F'
					AND ctr.IsActiveFlag = 1
END
ELSE IF @CenterID = 3 --Joint Venture Centers
BEGIN
	INSERT  INTO #Centers
			SELECT  ctr.CenterID
			,		ctr.CenterNumber
			FROM	cfgCenter ctr
					INNER JOIN lkpCenterType ct
						ON ct.CenterTypeID = ctr.CenterTypeID
			WHERE	ct.CenterTypeDescriptionShort = 'JV'
					AND ctr.IsActiveFlag = 1
END
ELSE
BEGIN
	INSERT  INTO #Centers
			SELECT  ctr.CenterID
			,		ctr.CenterNumber
			FROM	cfgCenter ctr
					INNER JOIN lkpCenterType ct
						ON ct.CenterTypeID = ctr.CenterTypeID
			WHERE	ctr.CenterID = @CenterID
					AND ctr.IsActiveFlag = 1
END


INSERT INTO #Status
SELECT item FROM fnSplit(@HairSystemOrderStatusIDs, ',') --Only one status may be selected


IF @HairSystemIDs = '1'			--Include all hair systems
BEGIN
INSERT INTO #HairSystem
SELECT HairSystemID FROM dbo.cfgHairSystem WHERE IsActiveFlag = 1
END
ELSE
BEGIN
INSERT INTO #HairSystem
SELECT item FROM fnSplit(@HairSystemIDs, ',')
END

IF @MembershipIDs = '1'			--Include all memberships
BEGIN
INSERT INTO #Member
SELECT MembershipID FROM dbo.cfgMembership WHERE IsActiveFlag = 1
END
ELSE
BEGIN
INSERT INTO #Member
SELECT item FROM fnSplit(@MembershipIDs, ',')
END

/***************** Main select statement ****************************************************************/

SELECT hso.HairSystemOrderGUID
,	CASE WHEN hso.HairSystemOrderStatusID = @OrderStatusID THEN homeCenter.CenterID
		ELSE center.CenterID END AS 'CenterID'
,	CASE WHEN hso.HairSystemOrderStatusID = @OrderStatusID THEN homeCenter.CenterDescriptionFullCalc
		ELSE center.CenterDescriptionFullCalc END AS 'CenterDescriptionFullCalc'
,	hso.HairSystemOrderNumber
,	hsos.HairSystemOrderStatusID
,	hsos.HairSystemOrderStatusDescriptionShort
,	hso.HairSystemOrderDate
,	hs.HairSystemID
,	hs.HairSystemDescriptionShort
,	m.MembershipID
,	m.MembershipDescription
,	c.ClientGUID
,	c.ClientFullNameCalc
,	emp.EmployeeGUID AS 'MeasuredByGUID'
,	emp.EmployeeInitials AS 'MeasuredBy'
,	emp2.EmployeeGUID AS 'OrderedByGUID'
,	emp2.EmployeeInitials AS 'OrderedBy'
,	COALESCE(hsotCurrent.HairSystemOrderTransactionDate,hso.CreateDate) AS 'CurrentStatusDate'
,	cm.EndDate
,	cm.ClientMembershipStatusID
,	CMS.ClientMembershipStatusDescription
,   homeCenter.CenterDescriptionFullCalc as 'ClientHomeCenter'
FROM dbo.datHairSystemOrder hso
	INNER JOIN dbo.lkpHairSystemOrderStatus hsos
		ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
	LEFT JOIN #Status st1
		ON CAST(st1.StatusID AS INT) = hsos.HairSystemOrderStatusID AND st1.StatusID <> @OrderStatusID
	INNER JOIN dbo.cfgHairSystem hs
		ON hso.HairSystemID = hs.HairSystemID
	LEFT JOIN #HairSystem hs1
		ON CAST(hs1.HairSystemID AS INT) = hs.HairSystemID
	INNER JOIN dbo.datClient c
		ON hso.ClientGUID = c.ClientGUID
	INNER JOIN dbo.datClientMembership cm
		ON cm.ClientMembershipGUID = hso.ClientMembershipGUID
	INNER JOIN dbo.lkpClientMembershipStatus CMS
		ON CMS.ClientMembershipStatusID = cm.ClientMembershipStatusID
	INNER JOIN dbo.cfgMembership m
		ON cm.MembershipID = m.MembershipID
	LEFT JOIN #Member m1
		ON  CAST(m1.MemberID AS INT) = m.MembershipID
	INNER JOIN dbo.cfgCenter center
		ON hso.CenterID = center.CenterID
	LEFT JOIN #Centers ct1
		ON CAST(ct1.CenterID AS INT) = center.CenterID
	INNER JOIN dbo.cfgCenter homeCenter
		ON hso.ClientHomeCenterID = homeCenter.CenterID
	LEFT JOIN #Centers ct2
		ON CAST(ct2.CenterID AS INT) = homeCenter.CenterID
	LEFT OUTER JOIN [dbo].datHairSystemOrderTransaction hsotCurrent
		ON hso.HairSystemOrderGUID = hsotCurrent.HairSystemOrderGUID
		AND hsotCurrent.NewHairSystemOrderStatusID = hso.HairSystemOrderStatusID
		AND hsotCurrent.NewHairSystemOrderStatusID <> ISNULL(hsotCurrent.PreviousHairSystemOrderStatusID,999)
		AND hsotCurrent.HairSystemOrderTransactionDate = (
			SELECT MAX(HairSystemOrderTransactionDate)
			FROM dbo.datHairSystemOrderTransaction
			WHERE NewHairSystemOrderStatusID = hso.HairSystemOrderStatusID and hso.HairSystemOrderGUID = HairSystemOrderGUID and
			NewHairSystemOrderStatusID <> ISNULL(hsotCurrent.PreviousHairSystemOrderStatusID,999))
	LEFT OUTER JOIN datEmployee emp
		ON hso.MeasurementEmployeeGUID = emp.EmployeeGUID
	LEFT OUTER JOIN datEmployee emp2
		ON hso.OrderedByEmployeeGUID = emp2.EmployeeGUID
WHERE 	(
		(ct1.CenterID IS NOT NULL AND hsos.HairSystemOrderStatusID <> @OrderStatusID)
		OR
		(ct2.CenterID IS NOT NULL AND hsos.HairSystemOrderStatusID = @OrderStatusID)
	)
	AND hsos.HairSystemOrderStatusID = @HairSystemOrderStatusIDs

END
GO
