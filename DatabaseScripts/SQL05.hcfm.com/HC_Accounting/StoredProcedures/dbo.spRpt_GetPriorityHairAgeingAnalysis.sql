/* CreateDate: 05/01/2020 14:50:15.010 , ModifyDate: 06/24/2020 16:56:41.197 */
GO
/***********************************************************************
PROCEDURE:				spRpt_GetPriorityHairAgeingAnalysis
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Accounting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		5/1/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_GetPriorityHairAgeingAnalysis '1/1/2020', '4/30/2020'the
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_GetPriorityHairAgeingAnalysis]
(
	@StartDate DATETIME,
	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


CREATE TABLE #HairSystem (
	HairSystemOrderNumber NVARCHAR(50)
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	HairSystemOrderDate DATETIME
,	CostContract MONEY
,	CostFactoryShipped MONEY
,	CurrentStatusCode NVARCHAR(10)
,	CurrentStatus NVARCHAR(100)
)

CREATE TABLE #HairSystemTransactions (
	RowID INT
,	HairSystemOrderNumber NVARCHAR(50)
,	CenterNumber INT
,	CenterDescription NVARCHAR(50)
,	ClientIdentifier INT
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Membership NVARCHAR(50)
,	TransactionDate DATETIME
,	StatusToCode NVARCHAR(10)
,	StatusTo NVARCHAR(100)
,	PriorityReason NVARCHAR(100)
)


/********************************** Convert @StartDate and @EndDate to UTC ***********************************************/
SELECT  tz.TimeZoneID
,       tz.UTCOffset
,       tz.UsesDayLightSavingsFlag
,       tz.IsActiveFlag
,       HairClubCMS.dbo.GetUTCFromLocal(@StartDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCStartDate'
,       HairClubCMS.dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'UTCEndDate'
INTO    #UTCDates
FROM    HairClubCMS.dbo.lkpTimeZone tz
WHERE   tz.IsActiveFlag = 1


/********************************** Get Hair System Data *************************************/
INSERT	INTO #HairSystem
		SELECT	DISTINCT
				hso.HairSystemOrderNumber
		,		NULL AS 'CenterNumber'
		,		NULL AS 'CenterDescription'
		,		CAST(hso.HairSystemOrderDate AS DATE) AS 'HairSystemOrderDate'
		,		hso.CostContract
		,		hso.CostFactoryShipped
		,		cs.HairSystemOrderStatusDescriptionShort AS 'CurrentStatusCode'
		,		cs.HairSystemOrderStatusDescription AS 'CurrentStatus'
		FROM	HairClubCMS.dbo.datHairSystemOrderTransaction hsot
				INNER JOIN HairClubCMS.dbo.datHairSystemOrder hso
					ON hso.HairSystemOrderGUID = hsot.HairSystemOrderGUID
				INNER JOIN HairClubCMS.dbo.cfgCenter ctr
					ON ctr.CenterID = hsot.CenterID
				INNER JOIN HairClubCMS.dbo.lkpCenterType ct
					ON ct.CenterTypeID = ctr.CenterTypeID
				INNER JOIN HairClubCMS.dbo.lkpTimeZone tz
					ON tz.TimeZoneID = ctr.TimeZoneID
				JOIN #UTCDates u
					ON u.TimeZoneID = tz.TimeZoneID
				INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus cs --Current Status
					ON cs.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
				INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus sf --Status From
					ON sf.HairSystemOrderStatusID = hsot.PreviousHairSystemOrderStatusID
				INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus st --Status To
					ON st.HairSystemOrderStatusID = hsot.NewHairSystemOrderStatusID
		WHERE	hsot.HairSystemOrderTransactionDate BETWEEN u.UTCStartDate AND u.UTCEndDate
				AND ct.CenterTypeDescriptionShort = 'C'
				AND ( ( sf.HairSystemOrderStatusDescriptionShort = 'CENT' AND st.HairSystemOrderStatusDescriptionShort = 'PRIORITY' )
						OR ( sf.HairSystemOrderStatusDescriptionShort = 'HQ-Recv' AND st.HairSystemOrderStatusDescriptionShort = 'PRIORITY' )
						OR ( sf.HairSystemOrderStatusDescriptionShort = 'HQ-Ship' AND st.HairSystemOrderStatusDescriptionShort = 'PRIORITY' )
						OR ( sf.HairSystemOrderStatusDescriptionShort = 'QANEEDED' AND st.HairSystemOrderStatusDescriptionShort = 'PRIORITY' )
						OR ( sf.HairSystemOrderStatusDescriptionShort = 'PRIORITY' AND st.HairSystemOrderStatusDescriptionShort = 'APPLIED' )
						OR ( sf.HairSystemOrderStatusDescriptionShort = 'PRIORITY' AND st.HairSystemOrderStatusDescriptionShort = 'DISPOSED' )
						OR ( sf.HairSystemOrderStatusDescriptionShort = 'PRIORITY' AND st.HairSystemOrderStatusDescriptionShort = 'TRAIN' )
						OR ( cs.HairSystemOrderStatusDescriptionShort = 'PRIORITY' ) )


CREATE NONCLUSTERED INDEX IDX_HairSystem_HairSystemOrderNumber ON #HairSystem ( HairSystemOrderNumber );
CREATE NONCLUSTERED INDEX IDX_HairSystem_CurrentStatusCode ON #HairSystem ( CurrentStatusCode );


UPDATE	hs
SET		hs.CenterNumber = ctr.CenterNumber
,		hs.CenterDescription = ctr.CenterDescription
FROM	#HairSystem hs
		INNER JOIN HairClubCMS.dbo.datHairSystemOrder hso
			ON hso.HairSystemOrderNumber = hs.HairSystemOrderNumber
		INNER JOIN HairClubCMS.dbo.cfgCenter ctr
			ON ctr.CenterID = hso.CenterID


UPDATE STATISTICS #HairSystem;


/********************************** Get Hair System Transaction Data *************************************/
INSERT	INTO #HairSystemTransactions
		SELECT	ROW_NUMBER() OVER ( PARTITION BY hso.HairSystemOrderNumber, st.HairSystemOrderStatusDescriptionShort ORDER BY hsot.HairSystemOrderTransactionDate ) AS 'RowID'
		,		hso.HairSystemOrderNumber
		,		ctr.CenterNumber
		,		ctr.CenterDescription
		,		clt.ClientIdentifier
		,		clt.FirstName
		,		clt.LastName
		,		m.MembershipDescription AS 'Membership'
		,		CAST(hsot.HairSystemOrderTransactionDate AS DATE) AS 'TransactionDate'
		,		st.HairSystemOrderStatusDescriptionShort AS 'StatusToCode'
		,		st.HairSystemOrderStatusDescription AS 'StatusTo'
		,		ISNULL(prhr.HairSystemOrderPriorityReasonDescription, '') AS 'PriorityReason'
		FROM	HairClubCMS.dbo.datHairSystemOrderTransaction hsot
				INNER JOIN HairClubCMS.dbo.datHairSystemOrder hso
					ON hso.HairSystemOrderGUID = hsot.HairSystemOrderGUID
				INNER JOIN #HairSystem hs
					ON hs.HairSystemOrderNumber = hso.HairSystemOrderNumber
				INNER JOIN HairClubCMS.dbo.cfgCenter ctr
					ON ctr.CenterID = hsot.CenterID
				INNER JOIN HairClubCMS.dbo.datClient clt
					ON clt.ClientGUID = hsot.ClientGUID
				INNER JOIN HairClubCMS.dbo.datClientMembership cm
					ON cm.ClientMembershipGUID = hsot.ClientMembershipGUID
				INNER JOIN HairClubCMS.dbo.cfgMembership m
					ON m.MembershipID = cm.MembershipID
				INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus cs --Current Status
					ON cs.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
				INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus sf --Status From
					ON sf.HairSystemOrderStatusID = hsot.PreviousHairSystemOrderStatusID
				INNER JOIN HairClubCMS.dbo.lkpHairSystemOrderStatus st --Status To
					ON st.HairSystemOrderStatusID = hsot.NewHairSystemOrderStatusID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpHairSystemOrderPriorityReason prhr
					ON prhr.HairSystemOrderPriorityReasonID = hsot.HairSystemOrderPriorityReasonID
		WHERE	( ( st.HairSystemOrderStatusDescriptionShort = 'CENT' )
					OR ( st.HairSystemOrderStatusDescriptionShort = 'PRIORITY' )
					OR ( st.HairSystemOrderStatusDescriptionShort = hs.CurrentStatusCode ) )


CREATE NONCLUSTERED INDEX IDX_HairSystemTransactions_RowID ON #HairSystemTransactions ( RowID );
CREATE NONCLUSTERED INDEX IDX_HairSystemTransactions_HairSystemOrderNumber ON #HairSystemTransactions ( HairSystemOrderNumber );
CREATE NONCLUSTERED INDEX IDX_HairSystemTransactions_StatusToCode ON #HairSystemTransactions ( StatusToCode );


UPDATE STATISTICS #HairSystemTransactions;


/********************************** Combine and Return Data *************************************/
SELECT	hs.HairSystemOrderNumber
,		hs.CenterNumber AS 'HSOCenterNumber'
,		hs.CenterDescription AS 'HSOCenterDescription'
,		hs.HairSystemOrderDate
,		ISNULL(hst_cent.TransactionDate, hst_prh.TransactionDate) AS '1stReceivedAtCenterDate'
,		hst_prh.TransactionDate AS '1stChangedToPriorityDate'
,		hst_cs.TransactionDate AS 'CurrentStatusDate'
,		hs.CurrentStatus
,		hst_prh.CenterNumber AS 'PriorityStatusClientCenterNumber'
,		hst_prh.CenterDescription AS 'PriorityStatusClientCenterDescription'
,		hst_prh.ClientIdentifier AS 'PriorityStatusClientIdentifier'
,		hst_prh.FirstName AS 'PriorityStatusClientFirstName'
,		hst_prh.LastName AS 'PriorityStatusClientLastName'
,		hst_prh.Membership AS 'PriorityStatusClientMembership'
,		hst_prh.PriorityReason AS 'PriorityReason'
,		hs.CostContract
,		hs.CostFactoryShipped
FROM	#HairSystem hs
		LEFT OUTER JOIN #HairSystemTransactions hst_cent
			ON hst_cent.HairSystemOrderNumber = hs.HairSystemOrderNumber
				AND hst_cent.StatusToCode = 'CENT'
				AND hst_cent.RowID = 1
		LEFT OUTER JOIN #HairSystemTransactions hst_prh
			ON hst_prh.HairSystemOrderNumber = hs.HairSystemOrderNumber
				AND hst_prh.StatusToCode = 'PRIORITY'
				AND hst_prh.RowID = 1
		LEFT OUTER JOIN #HairSystemTransactions hst_cs
			ON hst_cs.HairSystemOrderNumber = hs.HairSystemOrderNumber
				AND hst_cs.StatusToCode = hs.CurrentStatusCode
				AND hst_cs.RowID = 1

END
GO
