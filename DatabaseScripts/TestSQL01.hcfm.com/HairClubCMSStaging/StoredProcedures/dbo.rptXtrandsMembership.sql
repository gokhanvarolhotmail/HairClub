/* CreateDate: 05/20/2014 08:46:42.050 , ModifyDate: 11/12/2014 16:31:26.623 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				rptXtrandsMembership
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	Hairclub CMS
RELATED REPORT:			rptXtrandsMembership
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		05/19/2014
------------------------------------------------------------------------
CHANGE HISTORY:
06/11/2014	RH	Changed cm.ContractPaidAmount to clt.ARBalance
10/21/2014  KM	Added Xtrands6 and Xtrands Membership Solutions (75 and 76)
11/11/2014	RH	Moved the stored procedure to SQL06.HC_BI_Reporting
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC rptXtrandsMembership '10/01/2014', '10/31/2014'

***********************************************************************/

CREATE PROCEDURE [dbo].[rptXtrandsMembership]
(
	@StartDate		DATETIME
	,	@EndDate	DATETIME
	--,	@CenterIDArray	NVARCHAR(MAX)
) AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;


--CREATE TABLE #centerarray
--	(CenterID INT)
--INSERT INTO #centerarray
--	(CenterID )
--SELECT item AS CenterID
--FROM dbo.fnSplit(@CenterIDArray,',')

SELECT lstatus.BeginDate
		,	lstatus.EndDate
		,	m.MembershipDescription
		,	clt.CenterID
		,	c.CenterDescriptionFullCalc
		,	clt.ClientIdentifier
		,	clt.ClientFullNameCalc
		,	MAX(cm.ContractPrice) AS 'ContractPrice'
		,	MAX(cm.ContractPaidAmount) AS 'ContractPaidAmount'
		,	cm.MonthlyFee
		,	firstserv.EmployeeInitials
		,	clt.ClientGUID
		,	cm.ClientMembershipGUID
		,	m.MembershipID
		,	preck.OrderDate AS 'PreCheck'
		,	firstserv.OrderDate AS 'FirstService'
		,	firstserv.Employee2GUID AS 'Employee2GUID'
		,	lastserv.OrderDate AS 'LastService'
        ,	ahs.AccumQuantityRemainingCalc AS 'RemainingStrands'
		,	lstatus.ClientMembershipStatusDescription

	FROM dbo.datAppointment ap
	INNER JOIN dbo.datAppointmentEmployee ae
		ON ae.AppointmentGUID = ap.AppointmentGUID

	INNER JOIN datClient clt
		ON clt.ClientGUID = ap.ClientGUID
	INNER JOIN cfgCenter c
		ON clt.CenterID = c.CenterID
	INNER JOIN datClientMembership cm
		ON cm.ClientMembershipGUID = ap.ClientMembershipGUID
	INNER JOIN cfgMembership m
		ON m.MembershipID = cm.MembershipID


	LEFT OUTER JOIN (
				-- Get Pre-Check Data
				SELECT  ClientGUID
					,	MAX(OrderDate) AS OrderDate
					,	sod.SalesCodeID
					,	sod.Employee1GUID
				FROM dbo.datSalesOrder so
				INNER JOIN dbo.datSalesOrderDetail sod
					ON sod.SalesOrderGUID = so.SalesOrderGUID
				WHERE sod.SalesCodeID = 775  --Xtrands (Pre Check)
				GROUP BY so.ClientGUID,sod.SalesCodeID, sod.Employee1GUID
			) preck
		ON ap.ClientGUID = preck.ClientGUID

	LEFT OUTER JOIN (
				-- Get First Service Data
				SELECT  ClientGUID
					,	OrderDate
					,	sod.SalesCodeID
					,	sod.Employee2GUID
					,	e.EmployeeInitials
					,   ROW_NUMBER() OVER ( PARTITION BY ClientGUID ORDER BY OrderDate ) AS 'Ranking'
				FROM dbo.datSalesOrder so
				INNER JOIN dbo.datSalesOrderDetail sod
					ON sod.SalesOrderGUID = so.SalesOrderGUID
				INNER JOIN datEmployee e
					ON e.EmployeeGUID = sod.Employee2GUID
				WHERE sod.SalesCodeID = 773  --Xtrands Service (New)
			) firstserv
		ON ap.ClientGUID = firstserv.ClientGUID
			AND firstserv.Ranking = 1

	LEFT OUTER JOIN (
				-- Get Last Service Data
				SELECT  ClientGUID
					,	OrderDate
					,	sod.SalesCodeID
					,	sod.Employee1GUID
					,   ROW_NUMBER() OVER ( PARTITION BY ClientGUID ORDER BY OrderDate DESC ) AS 'Ranking'
				FROM dbo.datSalesOrder so
				INNER JOIN dbo.datSalesOrderDetail sod
					ON sod.SalesOrderGUID = so.SalesOrderGUID
				WHERE sod.SalesCodeID IN (774,788)  --Xtrands Service (Member)
			) lastserv
		ON ap.ClientGUID = lastserv.ClientGUID
			AND lastserv.Ranking = 1

			/*SalesCodeID	SalesCodeDescription	SalesCodeDescriptionShort
				774			Xtrands Service (Member)	XTRMBRSRV
				788			EXT Service - Xtrands		EXTSVCXTD
			*/

		LEFT OUTER JOIN (
				-- Get Latest Status
				SELECT  ClientGUID
				,	BeginDate
				,	EndDate
					,	dcm.ClientMembershipStatusID
					,	cms.ClientMembershipStatusDescription
					,   ROW_NUMBER() OVER ( PARTITION BY ClientGUID ORDER BY EndDate DESC ) AS 'Ranking'
				FROM dbo.datClientMembership dcm
				INNER JOIN cfgMembership M
					ON dcm.MembershipID = M.MembershipID
				INNER JOIN dbo.lkpClientMembershipStatus cms
					ON dcm.ClientMembershipStatusID = cms.ClientMembershipStatusID
				WHERE MembershipDescription LIKE '%Xtrands%'	--11/11/2014 currently MembershipID's are 70,71,75,76
			) lstatus
		ON ap.ClientGUID = lstatus.ClientGUID
			AND lstatus.Ranking = 1

		--Accumulators - Total Remaining
	LEFT JOIN datClientMembershipAccum ahs
		ON ahs.ClientMembershipGUID = cm.ClientMembershipGUID AND ahs.AccumulatorID = 40 --Xtrands (Strands)


	WHERE cm.MembershipID IN (70,71,75,76) --Xtrands (New) or Xtrands Membership
	AND lstatus.BeginDate BETWEEN @StartDate AND @EndDate
	--AND ap.ClientGUID = 'D982D6B6-0ACD-4E38-B6E2-38D631052A0F' --For Testing
	AND lstatus.ClientMembershipStatusID = 1 --Active
	AND cm.ContractPaidAmount > '0.00'

	--AND clt.CenterID IN(SELECT CenterID FROM #centerarray)

	GROUP BY lstatus.BeginDate
,	lstatus.EndDate
		,	m.MembershipDescription
		,	clt.CenterID
		,	c.CenterDescriptionFullCalc
		,	clt.ClientIdentifier
		,	clt.ClientFullNameCalc
		,	cm.MonthlyFee
		,	firstserv.EmployeeInitials
		,	clt.ClientGUID
		,	cm.ClientMembershipGUID
		,	m.MembershipID
		,	preck.OrderDate
		,	firstserv.OrderDate
		,	firstserv.Employee2GUID
		,	lastserv.OrderDate
        ,	ahs.AccumQuantityRemainingCalc
		,	lstatus.ClientMembershipStatusDescription



END
GO
