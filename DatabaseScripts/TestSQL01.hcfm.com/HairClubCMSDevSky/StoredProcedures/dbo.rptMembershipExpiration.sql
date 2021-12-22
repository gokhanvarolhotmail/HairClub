/* CreateDate: 02/18/2013 07:43:35.660 , ModifyDate: 09/13/2019 15:29:51.840 */
GO
/*===============================================================================================
-- Procedure Name:			rptMembershipExpiration
-- Procedure Description:
--
-- Created By:				Hdu
-- Implemented By:			Hdu
-- Last Modified By:		Hdu
--
-- Date Created:			10/11/2012
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES: @Status = 1 for Active, 2 for Canceled, 3 for All
--------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
	10/17/12	MLM		Modified the table Structure to tied RegisterLog to RegisterClose
	10/30/12	MLM		Modified the Query to return results from RegisterTender Table
	02/06/13	MLM		Remove the IsActive Filter
	05/29/13	MLM		Added CTE to get only the last Membership for a Client
	04/02/14	RMH		(#99234) Removed New Client(ShowNoSale) from the stored procedure - this is MembershipID = 57.
	05/09/17	RMH		(#137110) Added @RevenueGroupID and @BusinessSegmentID; @MembershipID is now multi-select
	05/17/17	RMH		(#137110) Added Anniversary Date
	08/30/2017  RMH		(#140314) Added LastPaymentDate, SalesCodeDescription, TenderTypeDescription, TenderAmount, LastStylist, Over31Days
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [rptMembershipExpiration] 849, '7/1/2019', '7/31/2019', 2, 1, NULL, 1
EXEC [rptMembershipExpiration] 201, '8/1/2019', '8/30/2019', 2, 1, NULL, 2
================================================================================================*/
CREATE PROCEDURE [dbo].[rptMembershipExpiration]
(
	@CenterID INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@RevenueGroupID INT
,	@BusinessSegmentID INT
,	@MembershipID VARCHAR(150) = NULL		--NULL All
,	@Status INT
)
AS
BEGIN
	SET NOCOUNT ON;



/**************** Split MembershipID's into a temp table *****************************************************/

CREATE TABLE #Multiples( MembershipID INT
)

IF ISNULL(@MembershipID,'0') = '0'
BEGIN
	INSERT INTO #Multiples
	SELECT MembershipID
	FROM dbo.cfgMembership
	WHERE MembershipID <> 57
	 AND RevenueGroupID = @RevenueGroupID
END
ELSE
BEGIN
	INSERT INTO #Multiples
	SELECT item
	FROM dbo.fnSplit(@MembershipID,',')
END

--SELECT '#Multiples' AS Tablename, MembershipID FROM #Multiples

/**************** Find the cancel membership id ******* *****************************************************/

DECLARE @CANCEL_MEMBERSHIPID INT
SELECT @CANCEL_MEMBERSHIPID = (SELECT MembershipID From cfgMembership WHERE MembershipDescriptionShort = 'CANCEL')

/************** Create temp tables **************************************************************************/


CREATE TABLE #Membership( Ranking INT
,	ClientIdentifier INT
,	CenterID INT
,	ClientGUID UNIQUEIDENTIFIER
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	MembershipID INT
,	BeginDate DATETIME
,	EndDate DATETIME
,	ClientMembershipStatusID INT
,	ClientMembershipStatusDescription NVARCHAR(100)
,	RevenueGroupID INT
,	BusinessSegmentID INT
)

CREATE TABLE #LastPayment(
	Rank2 INT
,	ClientGUID NVARCHAR(50)
,	InvoiceNumber NVARCHAR(50)
,	OrderDate DATETIME
,	SalesCodeDescription NVARCHAR(50)
,	TenderTypeDescription NVARCHAR(50)
,	TenderAmount MONEY
)

CREATE TABLE #Expiration(
	ClientFullNameCalc  NVARCHAR(250)
,	MembershipID INT
,	MembershipDescription NVARCHAR(50)
,	CurrentMembership NVARCHAR(50)
,	CurrentStatus NVARCHAR(50)
,	RevenueGroupID INT
,	RevenueGroupDescription  NVARCHAR(50)
,	RevenueGroupDescriptionShort  NVARCHAR(15)
,	BusinessSegmentID INT
,	BusinessSegmentDescription NVARCHAR(50)
,	BusinessSegmentDescriptionShort NVARCHAR(15)
,	EndDate DATETIME
,	HomePhone BIGINT
,	WorkPhone BIGINT
,	LastAppointmentDate DATETIME
,	NextAppointmentDate DATETIME
,	AnniversaryDate DATETIME
,	LastPaymentDate DATETIME
,	SalesCodeDescription NVARCHAR(50)
,	TenderTypeDescription NVARCHAR(50)
,	TenderAmount MONEY
,	LastStylist NVARCHAR(2)
,	[DateDiff] INT
,	Over31Days INT
)

/************** Find Memberships that are not cancelled ******************************************************/

INSERT INTO #Membership
Select ROW_NUMBER() OVER(PARTITION BY CM.ClientGUID ORDER BY CLT.ClientGUID, CM.EndDate DESC) as Ranking
	,	CLT.ClientIdentifier
	,	CLT.CenterID
	,	CM.ClientGUID
	,	CM.ClientMembershipGUID
	,	CM.MembershipID
	,	CM.BeginDate
	,	CM.EndDate
	,	CM.ClientMembershipStatusID
	,	CMS.ClientMembershipStatusDescription
	,	M.RevenueGroupID
	,	M.BusinessSegmentID
From datClient CLT
	INNER JOIN datClientMembership CM
		ON (CLT.CurrentBioMatrixClientMembershipGUID = CM.ClientMembershipGUID
			OR CLT.CurrentSurgeryClientMembershipGUID	= CM.ClientMembershipGUID
			OR CLT.CurrentExtremeTherapyClientMembershipGUID = CM.ClientMembershipGUID
			OR CLT.CurrentXtrandsClientMembershipGUID = CM.ClientMembershipGUID )
	INNER JOIN #Multiples MULTI
		ON CM.MembershipID = MULTI.MembershipID
	INNER JOIN dbo.cfgMembership M
		ON MULTI.MembershipID = M.MembershipID
	INNER JOIN dbo.lkpClientMembershipStatus CMS
		ON CM.ClientMembershipStatusID = CMS.ClientMembershipStatusID
WHERE CLT.CenterID = @CenterID
	AND CM.MembershipID <> @CANCEL_MEMBERSHIPID
	AND M.BusinessSegmentID = @BusinessSegmentID
	AND CM.MembershipID IN (SELECT MembershipID FROM #Multiples)
	AND M.RevenueGroupID = @RevenueGroupID
	AND CM.EndDate BETWEEN @StartDate AND @EndDate


/*********************** Find current membership, membership status and end date *********************************/


SELECT TMP.ClientIdentifier
,	TMP.CenterID
,	CMD.ClientGUID
,	CMD.MembershipDescription
,	CMD.MembershipDescriptionShort
,	CMD.ClientMembershipStatusDescription
,	CMD.ClientMembershipStatusDescriptionShort
,	CMD.MembershipSortOrder
,	CMD.ContractPrice
,	CMD.MonthlyFee
,	CMD.BeginDate
,	CMD.EndDate
,	CMD.BusinessSegmentID
,	CMD.RevenueGroupID
,	CMD.ClientMembershipIdentifier
INTO #Current
FROM #Membership TMP
CROSS APPLY ( SELECT TOP 1
										DCM.ClientMembershipGUID
							  ,         DM.MembershipID
							  ,         DM.MembershipDescription
							  ,			DM.MembershipDescriptionShort
							  ,         DCMS.ClientMembershipStatusDescription
							  ,         DCMS.ClientMembershipStatusDescriptionShort
							  ,			DM.MembershipSortOrder
							  ,         DCM.ContractPrice
							  ,         DCM.MonthlyFee
							  ,         DCM.BeginDate
							  ,         DCM.EndDate
							  ,			DM.BusinessSegmentID
							  ,			DM.RevenueGroupID
							  ,         DCM.ClientMembershipIdentifier
							  ,			DCM.ClientGUID
							  FROM      datClientMembership DCM
										INNER JOIN cfgMembership DM
											ON DM.MembershipID = DCM.MembershipID
										INNER JOIN lkpClientMembershipStatus DCMS
											ON DCMS.ClientMembershipStatusID = DCM.ClientMembershipStatusID
							  WHERE     TMP.ClientGUID = DCM.ClientGUID
							  ORDER BY  DCM.EndDate DESC
							) CMD



/********************************** Get Last Visit *************************************/

SELECT q.ClientGUID
,	q.LastVisitDate
,	q.LastStylist
INTO #LastVisit
FROM(
		SELECT	ROW_NUMBER() OVER ( PARTITION BY MBR.ClientGUID ORDER BY MBR.ClientGUID, APPT.AppointmentDate DESC ) AS Ranking
		,   MBR.ClientGUID
		,	APPT.AppointmentDate AS 'LastVisitDate'
		,	E.EmployeeInitials AS 'LastStylist'
		FROM	datAppointment APPT
				INNER JOIN #Membership MBR
					ON APPT.ClientGUID = MBR.ClientGUID
				INNER JOIN dbo.datClientMembership CM
					ON APPT.ClientMembershipGUID = CM.ClientMembershipGUID
				LEFT OUTER JOIN dbo.datAppointmentEmployee AE
					ON APPT.AppointmentGUID = AE.AppointmentGUID
				LEFT OUTER JOIN dbo.datEmployee E
					ON AE.EmployeeGUID = E.EmployeeGUID
		WHERE   APPT.IsDeletedFlag = 0
		AND APPT.AppointmentDate < GETDATE()
		AND APPT.CheckoutTime IS NOT NULL
		GROUP BY MBR.ClientGUID
		,	APPT.AppointmentDate
		,	E.EmployeeInitials
	)q
WHERE Ranking = 1

/*************** Find Last Payment Info *********************************************************************/

DECLARE @MembershipReveueID INT
DECLARE @MembershipPaymentID INT
DECLARE @OneYearAgo DATETIME

SELECT @MembershipReveueID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment where SalesCodeDepartmentDescriptionShort = 'MRRevenue'
SELECT @MembershipPaymentID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment where SalesCodeDepartmentDescriptionShort = 'MSARPmt'
SET @OneYearAgo = DATEADD(DAY,-365,GETDATE())


INSERT INTO #LastPayment
SELECT ROW_NUMBER() OVER ( PARTITION BY MBR.ClientGUID ORDER BY MBR.ClientGUID, SO.OrderDate DESC ) AS Rank2
,	MBR.ClientGUID
	,	SO.InvoiceNumber
	,	SO.OrderDate
	,	SC.SalesCodeDescription
	,	TT.TenderTypeDescription
	,	SOT.[Amount] as TenderAmount
FROM #Membership MBR
	INNER JOIN  datSalesOrder SO
		ON SO.ClientGUID = MBR.ClientGUID
	INNER JOIN datSalesOrderDetail SOD
		ON SO.SalesOrderGUID = SOD.SalesOrderGUID
	INNER JOIN cfgSalesCode SC
		ON SOD.SalesCodeId = SC.SalesCodeID
	INNER JOIN datSalesOrderTender SOT
		ON SO.SalesOrderGUID = SOT.SalesOrderGUID
	INNER JOIN lkpTenderType TT
		ON SOT.TenderTypeID = TT.TenderTypeID
WHERE (SC.SalesCodeDepartmentID  = @MembershipReveueID OR SC.SalesCodeDepartmentID = @MembershipPaymentID)
	AND SO.IsVoidedFlag = 0
	AND TT.TenderTypeDescription IN('Check','Cash','Credit Card') --Only successful payments
	AND SO.OrderDate > @OneYearAgo
	AND SOT.[Amount] > 0


/********************* Select statement **************************************************************************/
IF @Status = 1         --Active
BEGIN
INSERT INTO #Expiration
SELECT CLT.ClientFullNameCalc
	,	M.MembershipID
	,	M.MembershipDescription
	,	CURR.MembershipDescription AS 'CurrentMembership'
	,	CURR.ClientMembershipStatusDescription AS 'CurrentStatus'
	,	TMP.RevenueGroupID
	,	RG.RevenueGroupDescription
	,	RG.RevenueGroupDescriptionShort
	,	TMP.BusinessSegmentID
	,	BS.BusinessSegmentDescription
	,	BS.BusinessSegmentDescriptionShort
	,	TMP.EndDate
	,	CASE WHEN CLT.Phone1TypeID = 1 THEN CLT.Phone1
				WHEN CLT.Phone2TypeID = 1 THEN CLT.Phone2
				WHEN CLT.Phone3TypeID = 1 THEN CLT.Phone3
			ELSE CAST(CLT.Phone1TypeID AS VARCHAR) END AS 'HomePhone'
	,	CASE WHEN CLT.Phone1TypeID = 2 THEN CLT.Phone1
				WHEN CLT.Phone2TypeID = 2 THEN CLT.Phone2
				WHEN CLT.Phone3TypeID = 2 THEN CLT.Phone3
			ELSE CAST(CLT.Phone2TypeID AS VARCHAR) END AS 'WorkPhone'
	,	dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID) AS 'LastAppointmentDate'
	,	dbo.fn_GetNextAppointmentDate(TMP.ClientMembershipGUID) AS 'NextAppointmentDate'
	,	CLT.AnniversaryDate
	,	LP.OrderDate AS 'LastPaymentDate'
	,	LP.SalesCodeDescription
	,	LP.TenderTypeDescription
	,	LP.TenderAmount
	,	LV.LastStylist
	,	DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) AS 'DateDiff'
	,	CASE WHEN DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) > 31 THEN 1 ELSE 0 END AS 'Over31Days' ----Over 31 days between successful Last Payment Date and Membership End Date
FROM #Membership TMP
		INNER JOIN datClient CLT
			ON CLT.ClientGUID = TMP.ClientGUID
			AND CLT.CenterID = @CenterID
		INNER JOIN cfgMembership M
			ON M.MembershipID = TMP.MembershipID
		INNER JOIN lkpBusinessSegment BS
			ON TMP.BusinessSegmentID = BS.BusinessSegmentID
		INNER JOIN dbo.lkpRevenueGroup RG
			ON TMP.RevenueGroupID = RG.RevenueGroupID
		LEFT JOIN #Current CURR
			ON CURR.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastVisit LV
			ON LV.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastPayment LP
			ON LP.ClientGUID = CLT.ClientGUID
WHERE TMP.EndDate BETWEEN @StartDate AND @EndDate
		AND (TMP.Ranking = 1 OR TMP.Ranking IS NULL)
		AND (LP.Rank2 = 1 OR LP.Rank2 IS NULL)
		AND CURR.ClientMembershipStatusDescriptionShort = 'A'
END
ELSE
IF @Status = 2
BEGIN
INSERT INTO #Expiration
SELECT CLT.ClientFullNameCalc
	,	M.MembershipID
	,	M.MembershipDescription
	,	CURR.MembershipDescription AS 'CurrentMembership'
	,	CURR.ClientMembershipStatusDescription AS 'CurrentStatus'
	,	TMP.RevenueGroupID
	,	RG.RevenueGroupDescription
	,	RG.RevenueGroupDescriptionShort
	,	TMP.BusinessSegmentID
	,	BS.BusinessSegmentDescription
	,	BS.BusinessSegmentDescriptionShort
	,	TMP.EndDate
	,	CASE WHEN CLT.Phone1TypeID = 1 THEN CLT.Phone1
				WHEN CLT.Phone2TypeID = 1 THEN CLT.Phone2
				WHEN CLT.Phone3TypeID = 1 THEN CLT.Phone3
			ELSE CAST(CLT.Phone1TypeID AS VARCHAR) END AS 'HomePhone'
	,	CASE WHEN CLT.Phone1TypeID = 2 THEN CLT.Phone1
				WHEN CLT.Phone2TypeID = 2 THEN CLT.Phone2
				WHEN CLT.Phone3TypeID = 2 THEN CLT.Phone3
			ELSE CAST(CLT.Phone2TypeID AS VARCHAR) END AS 'WorkPhone'
	,	dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID) AS 'LastAppointmentDate'
	,	dbo.fn_GetNextAppointmentDate(TMP.ClientMembershipGUID) AS 'NextAppointmentDate'
	,	CLT.AnniversaryDate
	,	LP.OrderDate AS 'LastPaymentDate'
	,	LP.SalesCodeDescription
	,	LP.TenderTypeDescription
	,	LP.TenderAmount
	,	LV.LastStylist
	,	DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) AS 'DateDiff'
	,	CASE WHEN DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) > 31 THEN 1 ELSE 0 END AS 'Over31Days' ----Over 31 days between successful Last Payment Date and Membership End Date
FROM #Membership TMP
		INNER JOIN datClient CLT
			ON CLT.ClientGUID = TMP.ClientGUID
			AND CLT.CenterID = @CenterID
		INNER JOIN cfgMembership M
			ON M.MembershipID = TMP.MembershipID
		INNER JOIN lkpBusinessSegment BS
			ON TMP.BusinessSegmentID = BS.BusinessSegmentID
		INNER JOIN dbo.lkpRevenueGroup RG
			ON TMP.RevenueGroupID = RG.RevenueGroupID
		LEFT JOIN #Current CURR
			ON CURR.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastVisit LV
			ON LV.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastPayment LP
			ON LP.ClientGUID = CLT.ClientGUID
WHERE TMP.EndDate BETWEEN @StartDate AND @EndDate
		AND (TMP.Ranking = 1 OR TMP.Ranking IS NULL)
		AND (LP.Rank2 = 1 OR LP.Rank2 IS NULL)
		AND CURR.ClientMembershipStatusDescriptionShort IN ('C','E')
END
ELSE
IF @Status = 3
BEGIN
INSERT INTO #Expiration
SELECT CLT.ClientFullNameCalc
	,	M.MembershipID
	,	M.MembershipDescription
	,	CURR.MembershipDescription AS 'CurrentMembership'
	,	CURR.ClientMembershipStatusDescription AS 'CurrentStatus'
	,	TMP.RevenueGroupID
	,	RG.RevenueGroupDescription
	,	RG.RevenueGroupDescriptionShort
	,	TMP.BusinessSegmentID
	,	BS.BusinessSegmentDescription
	,	BS.BusinessSegmentDescriptionShort
	,	TMP.EndDate
	,	CASE WHEN CLT.Phone1TypeID = 1 THEN CLT.Phone1
				WHEN CLT.Phone2TypeID = 1 THEN CLT.Phone2
				WHEN CLT.Phone3TypeID = 1 THEN CLT.Phone3
			ELSE CAST(CLT.Phone1TypeID AS VARCHAR) END AS 'HomePhone'
	,	CASE WHEN CLT.Phone1TypeID = 2 THEN CLT.Phone1
				WHEN CLT.Phone2TypeID = 2 THEN CLT.Phone2
				WHEN CLT.Phone3TypeID = 2 THEN CLT.Phone3
			ELSE CAST(CLT.Phone2TypeID AS VARCHAR) END AS 'WorkPhone'
	,	dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID) AS 'LastAppointmentDate'
	,	dbo.fn_GetNextAppointmentDate(TMP.ClientMembershipGUID) AS 'NextAppointmentDate'
	,	CLT.AnniversaryDate
	,	LP.OrderDate AS 'LastPaymentDate'
	,	LP.SalesCodeDescription
	,	LP.TenderTypeDescription
	,	LP.TenderAmount
	,	LV.LastStylist
	,	DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) AS 'DateDiff'
	,	CASE WHEN DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) > 31 THEN 1 ELSE 0 END AS 'Over31Days' ----Over 31 days between successful Last Payment Date and Membership End Date
FROM #Membership TMP
		INNER JOIN datClient CLT
			ON CLT.ClientGUID = TMP.ClientGUID
			AND CLT.CenterID = @CenterID
		INNER JOIN cfgMembership M
			ON M.MembershipID = TMP.MembershipID
		INNER JOIN lkpBusinessSegment BS
			ON TMP.BusinessSegmentID = BS.BusinessSegmentID
		INNER JOIN dbo.lkpRevenueGroup RG
			ON TMP.RevenueGroupID = RG.RevenueGroupID
		LEFT JOIN #Current CURR
			ON CURR.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastVisit LV
			ON LV.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastPayment LP
			ON LP.ClientGUID = CLT.ClientGUID
WHERE TMP.EndDate BETWEEN @StartDate AND @EndDate
		AND (TMP.Ranking = 1 OR TMP.Ranking IS NULL)
		AND (LP.Rank2 = 1 OR LP.Rank2 IS NULL)
END


SELECT * FROM #Expiration





END
GO
