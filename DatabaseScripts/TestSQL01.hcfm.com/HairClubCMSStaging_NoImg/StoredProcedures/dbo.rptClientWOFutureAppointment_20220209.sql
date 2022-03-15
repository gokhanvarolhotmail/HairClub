/* CreateDate: 11/20/2019 11:00:54.880 , ModifyDate: 02/09/2022 08:12:17.253 */
GO
/*===============================================================================================
-- Procedure Name:			rptClientWOFutureAppointment
-- Procedure Description:
--
-- Created By:				JCL
-- Implemented By:			JCL
-- Last Modified By:		JCL
--
-- Date Created:			11/7/2019
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES: @Status = 1 for Active, 2 for Canceled, 3 for All
--------------------------------------------------------------------------------------------------------
CHANGE HISTORY:
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [rptClientWOFutureAppointment] 849, '7/1/2019', '7/31/2019', 2, 1, NULL, 1
EXEC [rptClientWOFutureAppointment] 201, '8/1/2019', '8/30/2019', 2, 1, NULL, 2


EXEC [rptClientWOFutureAppointment] 201, '10/27/2019', '12/11/2019', 0, 0, NULL, 1


EXEC [rptClientWOFutureAppointment] '4/19/2020', '5/30/2020', 213, 0, 0, 1
================================================================================================*/
CREATE PROCEDURE [dbo].[rptClientWOFutureAppointment_20220209]
(

	@StartDate DATETIME
,	@EndDate DATETIME
,	@CenterID INT
,   @RevenueGroupID INT
,	@BusinessSegmentID INT
,	@Status INT
--,	@MembershipID VARCHAR(150)		--NULL All
)
AS
BEGIN
	SET NOCOUNT ON;


--DECLARE @MembershipID VARCHAR(150) = NULL
--SET @MembershipID = '0'

/**************** Split MembershipID's into a temp table *****************************************************/
/*
1	Corporate Centers
2	Franchise Centers
3	Joint Ventures
*/
CREATE TABLE #Center(CenterID INT
)

IF @CenterID = '1'
	INSERT INTO   #Center
	SELECT        CenterID
	FROM          cfgCenter WITH (NOLOCK)
	WHERE         Centertypeid = 1 AND IsActiveFlag = 1
ELSE IF @CenterID = '2'
	INSERT INTO   #Center
	SELECT        CenterID
	FROM          cfgCenter WITH (NOLOCK)
	WHERE         Centertypeid = 2 AND IsActiveFlag = 1
ELSE IF @CenterID = '3'
	INSERT INTO   #Center
	SELECT        CenterID
	FROM          cfgCenter WITH (NOLOCK)
	WHERE         Centertypeid = 3 AND IsActiveFlag = 1
ELSE
	INSERT INTO   #Center
	SELECT        CenterID
	FROM          cfgCenter WITH (NOLOCK)
	WHERE         Centerid = @CenterID AND IsActiveFlag = 1


CREATE TABLE #RevGroup(RevGroupID INT
)

IF @RevenueGroupID = '0'
	INSERT INTO   #RevGroup
	SELECT        RevenueGroupID
	FROM          lkpRevenueGroup WITH (NOLOCK)
	WHERE         (RevenueGroupID IN (1, 2, 3, 4))
ELSE
	INSERT INTO   #RevGroup
	SELECT        RevenueGroupID
	FROM          lkpRevenueGroup WITH (NOLOCK)
	WHERE         (RevenueGroupID = @RevenueGroupID)


CREATE TABLE #BusSegment(BusSegmentID INT
)

IF @BusinessSegmentID = '0'
	INSERT INTO #BusSegment
	SELECT BusinessSegmentID
	FROM   lkpBusinessSegment WITH (NOLOCK)
	WHERE  (BusinessSegmentID IN (1, 2, 6))
ELSE
	INSERT INTO #BusSegment
	SELECT BusinessSegmentID
	FROM   lkpBusinessSegment WITH (NOLOCK)
	WHERE  (BusinessSegmentID = @BusinessSegmentID)


CREATE TABLE #Multiples( MembershipID INT
)

--IF ISNULL(@MembershipID,'0') = '0'
--IF @MembershipID = '0'
--BEGIN
	INSERT INTO #Multiples
	SELECT MembershipID
	FROM dbo.cfgMembership WITH (NOLOCK)
	WHERE MembershipID <> 57
	 AND (RevenueGroupID  IN (SELECT RevGroupID FROM #RevGroup))
--END
--ELSE
--BEGIN
--	INSERT INTO #Multiples
--	SELECT item
--	FROM dbo.fnSplit(@MembershipID,',')
--END

--SELECT '#Multiples' AS Tablename, MembershipID FROM #Multiples

/**************** Find the cancel membership id ******* *****************************************************/

DECLARE @CANCEL_MEMBERSHIPID INT
SELECT @CANCEL_MEMBERSHIPID = (SELECT MembershipID From cfgMembership WITH (NOLOCK) WHERE MembershipDescriptionShort = 'CANCEL')

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
,	CurrentStatus NVARCHAR(100)
,	RevenueGroupID INT
,	RevenueGroupDescription  NVARCHAR(50)
,	RevenueGroupDescriptionShort  NVARCHAR(15)
,	BusinessSegmentID INT
,	BusinessSegmentDescription NVARCHAR(50)
,	BusinessSegmentDescriptionShort NVARCHAR(15)
,	EndDate DATETIME
,	HomePhone NVARCHAR(15)
--,	WorkPhone BIGINT
,	LastAppointmentDate DATETIME
,	DaysSinceLastAppointment INT
,	NextAppointmentDate DATETIME
--,	AnniversaryDate DATETIME
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
From datClient CLT WITH (NOLOCK)
	INNER JOIN datClientMembership CM  WITH (NOLOCK)
		ON (CLT.CurrentBioMatrixClientMembershipGUID = CM.ClientMembershipGUID
			OR CLT.CurrentSurgeryClientMembershipGUID	= CM.ClientMembershipGUID
			OR CLT.CurrentExtremeTherapyClientMembershipGUID = CM.ClientMembershipGUID
			OR CLT.CurrentXtrandsClientMembershipGUID = CM.ClientMembershipGUID )
	INNER JOIN #center ctr WITH (NOLOCK)
		ON ctr.CenterID = CLT.CenterID
	INNER JOIN #Multiples MULTI WITH (NOLOCK)
		ON CM.MembershipID = MULTI.MembershipID
	INNER JOIN dbo.cfgMembership M WITH (NOLOCK)
		ON MULTI.MembershipID = M.MembershipID
	INNER JOIN dbo.lkpClientMembershipStatus CMS WITH (NOLOCK)
		ON CM.ClientMembershipStatusID = CMS.ClientMembershipStatusID
WHERE --CLT.CenterID = @CenterID
    --CLT.CenterID IN (SELECT Centerid FROM #center)
	CM.MembershipID <> @CANCEL_MEMBERSHIPID
	--AND M.BusinessSegmentID = @BusinessSegmentID
	AND M.BusinessSegmentID IN (SELECT BusSegmentID FROM #BusSegment)
	AND CM.MembershipID IN (SELECT MembershipID FROM #Multiples)
	AND M.RevenueGroupID IN (SELECT RevGroupID FROM #RevGroup)
	--AND (M.RevenueGroupID = @RevenueGroupID OR @RevenueGroupID = 0)
	--AND CM.EndDate BETWEEN @StartDate AND @EndDate


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
FROM #Membership TMP WITH (NOLOCK)
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
							  FROM      datClientMembership DCM WITH (NOLOCK)
										INNER JOIN cfgMembership DM WITH (NOLOCK)
											ON DM.MembershipID = DCM.MembershipID
										INNER JOIN lkpClientMembershipStatus DCMS WITH (NOLOCK)
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
		FROM	datAppointment APPT WITH (NOLOCK)
				INNER JOIN #Membership MBR WITH (NOLOCK)
					ON APPT.ClientGUID = MBR.ClientGUID
				INNER JOIN dbo.datClientMembership CM WITH (NOLOCK)
					ON APPT.ClientMembershipGUID = CM.ClientMembershipGUID
				LEFT OUTER JOIN dbo.datAppointmentEmployee AE WITH (NOLOCK)
					ON APPT.AppointmentGUID = AE.AppointmentGUID
				LEFT OUTER JOIN dbo.datEmployee E WITH (NOLOCK)
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

SELECT @MembershipReveueID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment WITH (NOLOCK) WHERE SalesCodeDepartmentDescriptionShort = 'MRRevenue'
SELECT @MembershipPaymentID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment  WITH (NOLOCK) WHERE SalesCodeDepartmentDescriptionShort = 'MSARPmt'
SET @OneYearAgo = DATEADD(DAY,-365,GETDATE())


INSERT INTO #LastPayment
SELECT ROW_NUMBER() OVER ( PARTITION BY MBR.ClientGUID ORDER BY MBR.ClientGUID, SO.OrderDate DESC ) AS Rank2
,	MBR.ClientGUID
	,	SO.InvoiceNumber
	,	SO.OrderDate
	,	SC.SalesCodeDescription
	,	TT.TenderTypeDescription
	,	SOT.[Amount] as TenderAmount
FROM #Membership MBR WITH (NOLOCK)
	INNER JOIN  datSalesOrder SO WITH (NOLOCK)
		ON SO.ClientGUID = MBR.ClientGUID
	INNER JOIN datSalesOrderDetail SOD WITH (NOLOCK)
		ON SO.SalesOrderGUID = SOD.SalesOrderGUID
	INNER JOIN cfgSalesCode SC WITH (NOLOCK)
		ON SOD.SalesCodeId = SC.SalesCodeID
	INNER JOIN datSalesOrderTender SOT WITH (NOLOCK)
		ON SO.SalesOrderGUID = SOT.SalesOrderGUID
	INNER JOIN lkpTenderType TT  WITH (NOLOCK)
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
	--,	CASE WHEN CLT.Phone1TypeID = 2 THEN CLT.Phone1
	--			WHEN CLT.Phone2TypeID = 2 THEN CLT.Phone2
	--			WHEN CLT.Phone3TypeID = 2 THEN CLT.Phone3
	--		ELSE CAST(CLT.Phone2TypeID AS VARCHAR) END AS 'WorkPhone'
	,	dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID) AS 'LastAppointment'
	,	DATEDIFF(DAY,dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID), getdate()) AS 'DaysSinceLastAppointment'
	,	dbo.fn_GetNextAppointmentDate(TMP.ClientMembershipGUID) AS 'NextAppointmentDate'
	--,	CLT.AnniversaryDate
	,	LP.OrderDate AS 'LastPaymentDate'
	,	LP.SalesCodeDescription
	,	LP.TenderTypeDescription
	,	LP.TenderAmount
	,	LV.LastStylist
	,	DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) AS 'DateDiff'
	,	CASE WHEN DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) > 31 THEN 1 ELSE 0 END AS 'Over31Days' ----Over 31 days between successful Last Payment Date and Membership End Date
FROM #Membership TMP WITH (NOLOCK)
		INNER JOIN datClient CLT WITH (NOLOCK)
			ON CLT.ClientGUID = TMP.ClientGUID
			--AND CLT.CenterID = @CenterID
		INNER JOIN cfgMembership M WITH (NOLOCK)
			ON M.MembershipID = TMP.MembershipID
		INNER JOIN lkpBusinessSegment BS WITH (NOLOCK)
			ON TMP.BusinessSegmentID = BS.BusinessSegmentID
		INNER JOIN dbo.lkpRevenueGroup RG WITH (NOLOCK)
			ON TMP.RevenueGroupID = RG.RevenueGroupID
		LEFT JOIN #Current CURR WITH (NOLOCK)
			ON CURR.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastVisit LV WITH (NOLOCK)
			ON LV.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastPayment LP WITH (NOLOCK)
			ON LP.ClientGUID = CLT.ClientGUID
WHERE   --TMP.EndDate BETWEEN @StartDate AND @EndDate
		dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID) BETWEEN @StartDate AND @EndDate
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
	--,	CASE WHEN CLT.Phone1TypeID = 2 THEN CLT.Phone1
	--			WHEN CLT.Phone2TypeID = 2 THEN CLT.Phone2
	--			WHEN CLT.Phone3TypeID = 2 THEN CLT.Phone3
	--		ELSE CAST(CLT.Phone2TypeID AS VARCHAR) END AS 'WorkPhone'
	,	dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID) AS 'LastAppointment'
	,	DATEDIFF(DAY,dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID), getdate()) AS 'DaysSinceLastAppointment'
	,	dbo.fn_GetNextAppointmentDate(TMP.ClientMembershipGUID) AS 'NextAppointmentDate'
	--,	CLT.AnniversaryDate
	,	LP.OrderDate AS 'LastPaymentDate'
	,	LP.SalesCodeDescription
	,	LP.TenderTypeDescription
	,	LP.TenderAmount
	,	LV.LastStylist
	,	DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) AS 'DateDiff'
	,	CASE WHEN DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) > 31 THEN 1 ELSE 0 END AS 'Over31Days' ----Over 31 days between successful Last Payment Date and Membership End Date
FROM #Membership TMP WITH (NOLOCK)
		INNER JOIN datClient CLT WITH (NOLOCK)
			ON CLT.ClientGUID = TMP.ClientGUID
			--AND CLT.CenterID = @CenterID
		INNER JOIN cfgMembership M WITH (NOLOCK)
			ON M.MembershipID = TMP.MembershipID
		INNER JOIN lkpBusinessSegment BS WITH (NOLOCK)
			ON TMP.BusinessSegmentID = BS.BusinessSegmentID
		INNER JOIN dbo.lkpRevenueGroup RG WITH (NOLOCK)
			ON TMP.RevenueGroupID = RG.RevenueGroupID
		LEFT JOIN #Current CURR WITH (NOLOCK)
			ON CURR.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastVisit LV WITH (NOLOCK)
			ON LV.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastPayment LP WITH (NOLOCK)
			ON LP.ClientGUID = CLT.ClientGUID
WHERE --TMP.EndDate BETWEEN @StartDate AND @EndDate
        dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID) BETWEEN @StartDate AND @EndDate
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
	--,	CASE WHEN CLT.Phone1TypeID = 2 THEN CLT.Phone1
	--			WHEN CLT.Phone2TypeID = 2 THEN CLT.Phone2
	--			WHEN CLT.Phone3TypeID = 2 THEN CLT.Phone3
	--		ELSE CAST(CLT.Phone2TypeID AS VARCHAR) END AS 'WorkPhone'
	,	dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID) AS 'LastAppointment'
	,	DATEDIFF(DAY,dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID), getdate()) AS 'DaysSinceLastAppointment'
	,	dbo.fn_GetNextAppointmentDate(TMP.ClientMembershipGUID) AS 'NextAppointmentDate'
	--,	CLT.AnniversaryDate
	,	LP.OrderDate AS 'LastPaymentDate'
	,	LP.SalesCodeDescription
	,	LP.TenderTypeDescription
	,	LP.TenderAmount
	,	LV.LastStylist
	,	DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) AS 'DateDiff'
	,	CASE WHEN DATEDIFF(DAY,LP.OrderDate,TMP.EndDate) > 31 THEN 1 ELSE 0 END AS 'Over31Days' ----Over 31 days between successful Last Payment Date and Membership End Date
FROM #Membership TMP WITH (NOLOCK)
		INNER JOIN datClient CLT WITH (NOLOCK)
			ON CLT.ClientGUID = TMP.ClientGUID
			--AND CLT.CenterID = @CenterID
		INNER JOIN cfgMembership M WITH (NOLOCK)
			ON M.MembershipID = TMP.MembershipID
		INNER JOIN lkpBusinessSegment BS WITH (NOLOCK)
			ON TMP.BusinessSegmentID = BS.BusinessSegmentID
		INNER JOIN dbo.lkpRevenueGroup RG WITH (NOLOCK)
			ON TMP.RevenueGroupID = RG.RevenueGroupID
		LEFT JOIN #Current CURR WITH (NOLOCK)
			ON CURR.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastVisit LV WITH (NOLOCK)
			ON LV.ClientGUID = CLT.ClientGUID
		LEFT JOIN #LastPayment LP WITH (NOLOCK)
			ON LP.ClientGUID = CLT.ClientGUID
WHERE   --TMP.EndDate BETWEEN @StartDate AND @EndDate
		dbo.fn_GetPreviousAppointmentDate(TMP.ClientMembershipGUID) BETWEEN @StartDate AND @EndDate
		AND (TMP.Ranking = 1 OR TMP.Ranking IS NULL)
		AND (LP.Rank2 = 1 OR LP.Rank2 IS NULL)

END

SELECT distinct
    ClientFullNameCalc
--,	MembershipID
,	MembershipDescription
--,	CurrentMembership
--,	CurrentStatus
--,	RevenueGroupID
--,	RevenueGroupDescription
--,	RevenueGroupDescriptionShort
--,	BusinessSegmentID
--,	BusinessSegmentDescription
--,	BusinessSegmentDescriptionShort
,	EndDate
,	HomePhone
,	LastAppointmentDate
,	DaysSinceLastAppointment
,	NextAppointmentDate
,	LastPaymentDate
,	SalesCodeDescription
,	TenderTypeDescription
,	TenderAmount
,	LastStylist
,	[DateDiff]
--,	Over31Days
FROM #Expiration WITH (NOLOCK)
WHERE ISNULL(NextAppointmentDate, '')  = ''

END
GO
