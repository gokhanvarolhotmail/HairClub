/*===============================================================================================
-- Procedure Name:                  rptReceivables
-- Procedure Description:
--
-- Created By:                Mike Maass
-- Implemented By:            Mike Maass
-- Last Modified By:          Mike Maass
--
-- Date Created:              01/15/2013
-- Date Implemented:
-- Date Last Modified:        01/15/2013
--
-- Destination Server:        HairclubCMS
-- Destination Database:
-- Related Application:       Hairclub CMS
================================================================================================
**NOTES**
03/08/2013	MLM		Allow Positive ARBalances on Report
03/15/2013	MLM		Added Membership Column
12/28/2013  MVT		Modified for performance
06/19/2015	RMH		Modified to find FinanceAR - New Business
07/15/2015	RMH		(WO#116799) Show any NB clients that have converted as Recurring Business
07/31/2015	RMH		Added Cancelled clients
08/24/2015	RMH		Added to remove any NB clients that have cancelled from #FinanceAR and #Receivables
09/11/2015  RMH		(#118532) Added code to find Membership Status using the function [dbo.fnGetCurrentMembershipDetailsByCenterID]
06/02/2016	RMH		(#126859) Added a GROUP BY to the final select to remove any possible duplicates
04/27/2017  PRM     Updated to reference new datClientPhone table
01/03/2018	RMH		Rewrote the select statements and added EFTStatusDescription, EFTAccountTypeDescription, ClientMembershipStatusDescription, CCDeclined, Canceled, CancelDate (#137116,#144611,#145460,#145808)
01/10/2018	RMH		Added verbiage for CC Declines (#137116)
06/20/2018  RMH		Added a GroupBy at the end to remove duplicates (#150852)
05/15/2019	DSL		Rewrote stored procedure to eliminate duplicates
================================================================================================
Sample Execution:
EXEC rptReceivables 227, 0
================================================================================================*/

CREATE PROCEDURE [dbo].[rptReceivables]
	@CenterIDs nvarchar(MAX),
	@Multiplier int = 0
AS
BEGIN

DECLARE @StartPayDate DATETIME
DECLARE @EndPayDate DATETIME

 --DECLARE @CenterIDs nvarchar(MAX) = 207
 --DECLARE 	@Multiplier int = 0

CREATE TABLE #Center (
	CenterID INT
)

CREATE TABLE #PayPeriod (
	ID INT IDENTITY(1,1)
,	PayPeriodKey INT
,	StartDate DATETIME
,	EndDate DATETIME
,	Description NVARCHAR(50)
)


/* Get Center Data */
INSERT	INTO #Center
		SELECT	item AS 'CenterID'
		FROM	dbo.fnSplit(@CenterIDs, ',')


/* Get Pay Period Data */
INSERT	INTO #PayPeriod
		SELECT	TOP 2
				PayPeriodKey
		,		StartDate
		,		EndDate
		,		CONVERT(VARCHAR, StartDate, 101) + ' - ' + CONVERT(VARCHAR, EndDate, 101) AS 'Description'
		FROM	Commission_lkpPayPeriods_TABLE PP
		WHERE	PP.PayGroup IN ( 1 )
				AND PP.PayDate <= DATEADD(MONTH, 1, GETUTCDATE())
				AND PP.PayDate > DATEADD(MONTH, -1, GETUTCDATE())
		ORDER BY PP.StartDate DESC


SET @StartPayDate = (SELECT StartDate FROM #PayPeriod WHERE ID = 2)
SET @EndPayDate = (SELECT EndDate FROM #PayPeriod WHERE ID = 2)


/* Get Client Data */
SELECT	clt.CenterID
,		clt.ClientIdentifier
,		clt.ClientGUID
,		clt.FirstName
,		clt.LastName
,		clt.ARBalance
,		cp1.PhoneNumber AS 'Phone1'
,		cp2.PhoneNumber AS 'Phone2'
INTO	#Client
FROM	datClient clt
		INNER JOIN #Center c
			ON c.CenterID = clt.CenterID
		LEFT OUTER JOIN datClientPhone cp1
			ON cp1.ClientGUID = clt.ClientGUID
				AND cp1.ClientPhoneSortOrder = 1
		LEFT OUTER JOIN datClientPhone cp2
			ON cp2.ClientGUID = clt.ClientGUID
				AND cp2.ClientPhoneSortOrder = 2
WHERE	ISNULL(clt.ARBalance, 0) <> 0


/* Get Client Membership that created the AR Balance */
SELECT  c.CenterID
,		c.ClientIdentifier
,		c.ClientGUID
,		c.FirstName
,		c.LastName
,		c.ARBalance
,		x_AR.SalesOrderGUID
,       x_AR.ClientMembershipGUID
,		x_AR.Membership
,		x_AR.RevenueGroup
,		x_AR.BeginDate
,		x_AR.EndDate
,		x_AR.MembershipStatus
,		x_AR.MonthlyFee
INTO	#AR
FROM    #Client c
		CROSS APPLY (
			SELECT	ROW_NUMBER() OVER ( PARTITION BY ar.ClientGUID ORDER BY ar.CreateDate DESC ) AS 'RowID'
			,		ar.ClientGUID
			,		ar.SalesOrderGUID
			,		dcm.ClientMembershipGUID
			,		m.MembershipDescription AS 'Membership'
			,		rg.RevenueGroupDescription AS 'RevenueGroup'
			,		dcm.BeginDate
			,		dcm.EndDate
			,		cms.ClientMembershipStatusDescription AS 'MembershipStatus'
			,		dcm.MonthlyFee
			FROM	datAccountReceivable ar
					INNER JOIN datSalesOrder so
						ON so.SalesOrderGUID = ar.SalesOrderGUID
					INNER JOIN datClientMembership dcm
						ON dcm.ClientMembershipGUID = so.ClientMembershipGUID
					INNER JOIN cfgMembership m
						ON m.MembershipID = dcm.MembershipID
						INNER JOIN lkpRevenueGroup rg
							ON rg.RevenueGroupID = m.RevenueGroupID
					INNER JOIN lkpClientMembershipStatus cms
						ON cms.ClientMembershipStatusID = dcm.ClientMembershipStatusID
			WHERE	ar.ClientGUID = c.ClientGUID
					AND m.RevenueGroupID IN ( 1, 2 ) --New Business, Recurring Business
					AND so.IsVoidedFlag = 0
					AND so.IsWrittenOffFlag = 0
        ) x_AR
WHERE	x_AR.RowID = 1


/* Get Client EFT Data */
SELECT	a.CenterID
,		a.ClientGUID
,		a.ClientIdentifier
,		a.FirstName
,		a.LastName
,		a.ARBalance
,		m.MembershipDescription AS 'Membership'
,		dcm.ClientMembershipGUID
,		dcm.BeginDate
,		dcm.EndDate
,		cms.ClientMembershipStatusDescription AS 'MembershipStatus'
,		CASE dce.FeePayCycleID
			WHEN 1 THEN '1st of Month'
			WHEN 2 THEN '15th of Month'
		END AS 'PayCycle'
,		eat.EFTAccountTypeDescription AS 'AccountType'
,		CAST(ROUND(dcm.MonthlyFee, 2) AS MONEY) AS 'MonthlyFee'
,		est.EFTStatusDescription AS 'EFTStatus'
INTO	#ClientEFT
FROM	#AR a
		INNER JOIN datClientEFT dce
			ON dce.ClientMembershipGUID = a.ClientMembershipGUID
		INNER JOIN lkpEFTAccountType eat
			ON eat.EFTAccountTypeID = dce.EFTAccountTypeID
		INNER JOIN lkpEFTStatus est
			ON est.EFTStatusID = dce.EFTStatusID
		INNER JOIN datClientMembership dcm
			ON dcm.ClientMembershipGUID = dce.ClientMembershipGUID
		INNER JOIN cfgMembership m
			ON m.MembershipID = dcm.MembershipID
		INNER JOIN lkpClientMembershipStatus cms
			ON cms.ClientMembershipStatusID = dcm.ClientMembershipStatusID

/* Get Last Appointment Data */
SELECT  a.ClientGUID
,       MAX(AppointmentDate) AS 'LastAppointmentDate'
INTO	#LastAppointment
FROM    datAppointment a
		INNER JOIN #Client c
			ON c.ClientGUID = a.ClientGUID
WHERE   a.AppointmentDate < CAST(GETDATE() AS DATE)
		AND a.IsDeletedFlag = 0
		AND a.CheckedInFlag = 1
GROUP BY a.ClientGUID


/* Get Next Appointment Data */
SELECT  a.ClientGUID
,       MIN(AppointmentDate) AS 'NextAppointmentDate'
INTO	#NextAppointment
FROM    datAppointment a
		INNER JOIN #Client c
			ON c.ClientGUID = a.ClientGUID
WHERE   a.AppointmentDate >= CAST(GETDATE() AS DATE)
		AND a.IsDeletedFlag = 0
		AND a.CheckedInFlag = 0
GROUP BY a.ClientGUID


/* Get Last Payment Data */
SELECT  c.ClientGUID
,       MAX(so.OrderDate) AS 'LastPaymentDate'
INTO	#LastPayment
FROM    datSalesOrder so
		INNER JOIN #Client c
			ON c.ClientGUID = so.ClientGUID
		INNER JOIN datSalesOrderDetail sod
			ON sod.SalesOrderGUID = so.SalesOrderGUID
		INNER JOIN datSalesOrderTender sot
			ON sot.SalesOrderGUID = so.SalesOrderGUID
		INNER JOIN cfgSalesCode sc
			ON sc.SalesCodeID = sod.SalesCodeID
WHERE   sc.SalesCodeDepartmentID IN ( 2020, 2025 )
		AND sc.SalesCodeDescription NOT LIKE '%Laser%'
		AND sc.SalesCodeDescription NOT LIKE '%Capillus%'
		AND sc.SalesCodeDescription NOT LIKE '%EFT%'
		AND sot.Amount <> 0
		AND so.IsVoidedFlag = 0
GROUP BY c.ClientGUID


/* Get Pay Cycle Transactions Data */
SELECT	pct.ClientGUID
INTO	#PayCycleTransaction
FROM	datPayCycleTransaction pct
		INNER JOIN #Client c
			ON c.ClientGUID = pct.ClientGUID
WHERE	pct.CreateDate BETWEEN @StartPayDate AND @EndPayDate
		AND ( LTRIM(RTRIM(pct.Verbiage)) LIKE '%Decline%'
				OR	LTRIM(RTRIM(pct.Verbiage)) LIKE 'Decline%'
				OR	LTRIM(RTRIM(pct.Verbiage)) LIKE 'INVALID%CARD%'
				OR	LTRIM(RTRIM(pct.Verbiage)) IN ( 'AUTH  DECLINED  200', 'LOST/STOLEN CARD215', 'EXPIRED CARD', 'NO  MATCH', 'Card Expired', 'CARDHLDR DECLINE200', 'CARD NO. ERROR', 'INV ACCT NUM', 'INVLD ACCT', 'INV CVV2 MATCH', 'INV MER ID', 'UNSUPPORTED CARD TYPE', 'INVALID EXP DATE205'
,													'EXPIRATION DATE MUST BE IN FUTURE', 'INVALID EXP DATE', 'INVLD EXP DATE' ))
GROUP BY pct.ClientGUID


/**/

SELECT
t1.ARchoice,
CASE WHEN t1.ARchoice <> 0 OR t1.ARchoice IS NOT NULL THEN (cli.ARBalance - t1.ARchoice) ELSE cli.ARBalance END AS 'RegularAR',
cli.ClientGUID,
cli.clientidentifier
INTO #CorrectAR
FROM(
	SELECT SUM(ar.RemainingBalance) AS 'ARchoice'
		,ar.ClientGUID
	FROM datAccountReceivable ar
	JOIN lkpAccountReceivableType art
		ON art.AccountReceivableTypeID = ar.AccountReceivableTypeID
	WHERE art.AccountReceivableTypeDescriptionShort = 'ChoiceFina' AND ar.IsClosed = 0
	GROUP BY ar.ClientGUID
	) AS t1
FULL OUTER JOIN datClient cli ON cli.ClientGUID = t1.ClientGUID


/* Combine Data & Return Results */
SELECT	c.CenterID
,		c.ClientGUID
,		c.ClientIdentifier
,		c.FirstName
,		c.LastName
,		c.Phone1
,		c.Phone2
,		car.RegularAR/*c.ARBalance*/ AS 'ReceivableAmount'
,		a.Membership AS 'MembershipDescription'
,		a.RevenueGroup AS 'BusinessTypeDescription'
,		a.MembershipStatus AS 'ClientMembershipStatusDescription'
,		ce.PayCycle AS 'FeePayCycleDescription'
,		ce.AccountType AS 'EFTAccountTypeDescription'
,		a.MonthlyFee
,		ce.EFTStatus AS 'EFTStatusDescription'
,		la.LastAppointmentDate AS 'PreviousAppointmentDate'
,		na.NextAppointmentDate
,		lp.LastPaymentDate
,		CASE WHEN pct.ClientGUID IS NULL THEN 0 ELSE 1 END AS 'CCDeclined'
,		CASE WHEN a.MembershipStatus = 'Canceled' THEN 1 ELSE 0 END AS 'Canceled'
,		CASE WHEN a.MembershipStatus = 'Canceled' THEN a.EndDate ELSE NULL END AS 'CancelDate'
FROM	#Client c
		LEFT OUTER JOIN #AR a
			ON a.ClientGUID = c.ClientGUID
		LEFT OUTER JOIN #ClientEFT ce
			ON ce.ClientGUID = c.ClientGUID
		LEFT OUTER JOIN #LastAppointment la
			ON la.ClientGUID = c.ClientGUID
		LEFT OUTER JOIN #NextAppointment na
			ON na.ClientGUID = c.ClientGUID
		LEFT OUTER JOIN #LastPayment lp
			ON lp.ClientGUID = c.ClientGUID
		LEFT OUTER JOIN #PayCycleTransaction pct
			ON pct.ClientGUID = c.ClientGUID
		LEFT OUTER JOIN #CorrectAR car
			ON c.ClientGUID = car.ClientGUID
ORDER BY FirstName


END
