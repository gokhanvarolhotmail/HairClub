/* CreateDate: 04/10/2014 08:41:30.587 , ModifyDate: 01/17/2018 15:24:39.330 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            rptPermanentClientTransferTransactions
 Procedure Description:
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              12/12/2013
 Destination Server:        HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
**NOTES**
--Select first @MyCenter INT (type in the single CenterSSID)

--Select @ClientType INT - (mine or others)
--1 - Clients transferred to my center
--2 - Clients transferred from my center

--Select @OtherCenter VARCHAR(1): 'A = ALL, C = Corporate, F = Franchise, S = Single'

--If @OtherCenter = 'S' then @SingleCenter INT (type in the single CenterSSID)

1.	Clients transferred to my center = @ClientType = 1
	@OtherCenter =
	[A]	View those who transferred to either corporate or franchise centers
	[C]	View those who transferred to corporate centers
	[F] View those who transferred to franchise centers
	[S]	View those who transferred to from a single selected center
2.	Clients transferred from my center = @ClientType = 2
	@OtherCenter =
	[A]	View those whose original center was either corporate OR franchise centers
	[C] View those whose original center was a corporate center
	[F] View those whose original center was a franchise center
	[S] View those whose original center was a single selected center
================================================================================================
Change History:
09/17/2017 - RH - Added EmployeeInitials
01/17/2018 - RH - Removed Region; Changed employee information to UserLogin
================================================================================================

Sample Execution:

EXEC rptPermanentClientTransferTransactions '1/01/2017','12/31/2017', 271, 1,'A', NULL --1 - Clients transferred to my center

EXEC rptPermanentClientTransferTransactions '1/01/2017','1/31/2017', 271, 2,'A', NULL --2 - Clients transferred from my center

EXEC rptPermanentClientTransferTransactions '4/01/2014','4/10/2014', 896, 1,'C', NULL --1 - Clients transferred to my center

EXEC rptPermanentClientTransferTransactions '4/01/2014','4/10/2014', 896, 2,'C', NULL --2 - Clients transferred from my center

EXEC rptPermanentClientTransferTransactions '4/01/2014','4/10/2014', 201, 1,'F', NULL --1 - Clients transferred to my center

EXEC rptPermanentClientTransferTransactions '4/01/2014','4/10/2014', 283, 2,'F', NULL --2 - Clients transferred from my center

EXEC rptPermanentClientTransferTransactions '4/01/2014','4/10/2014', 896, 1,'S', 201 --1 - Clients transferred to my center

EXEC rptPermanentClientTransferTransactions '4/01/2014','4/10/2014', 896, 2,'S', 201 --2 - Clients transferred from my center

================================================================================================
*/

CREATE PROCEDURE [dbo].[rptPermanentClientTransferTransactions]
	@StartDate DATETIME
	,	@EndDate DATETIME
	,	@MyCenter INT
	,	@ClientType INT
	,	@OtherCenter VARCHAR(1)
	,	@SingleCenter INT = NULL

AS
BEGIN

	SET @EndDate = DATEADD(DAY,1,@EndDate)

	/**********Create temp tables**********************************/

	IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
	BEGIN
		DROP TABLE #Centers
	END
	CREATE TABLE #Centers (
		CenterID INT
	,	CenterDescriptionFullCalc VARCHAR(255)
	)

	IF OBJECT_ID('tempdb..#transfer') IS NOT NULL
	BEGIN
		DROP TABLE #transfer
	END

	CREATE TABLE #transfer
		(SalesCodeDescription	NVARCHAR(50)
	,	NewCenterID INT
	,	NewCenter	NVARCHAR(103)
	,	Client	NVARCHAR(103)
	,	PreviousClientMembershipGUID UNIQUEIDENTIFIER
	,	MembershipDescription  NVARCHAR(50)
	,	MembershipEndDate DATETIME
	,	SalesCodeDescriptionShort	NVARCHAR(15)
	,	OriginalCenterID INT
	,	OriginalCenter	NVARCHAR(103)
	,	CreateDate	DATETIME
	,	SalesOrderTypeID	INT
	,	EmployeeGUID UNIQUEIDENTIFIER
	,	UserLogin NVARCHAR(50)
	,	RevenueTransferred	MONEY
	)


	/********************************** Get list of centers *************************************/

	IF @OtherCenter = 'A'  --for ALL
	BEGIN
		INSERT  INTO #Centers
				SELECT  C.CenterID
				,		C.CenterDescriptionFullCalc
				FROM dbo.cfgCenter C
				INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = C.CenterTypeID
				WHERE CT.CenterTypeDescriptionShort = 'C'
						AND C.IsActiveFlag = 1
	END
	ELSE
	IF @OtherCenter = 'C' --Corporate
	BEGIN
		INSERT  INTO #Centers
		SELECT  C.CenterID
				,		C.CenterDescriptionFullCalc
		FROM dbo.cfgCenter C
		INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = C.CenterTypeID
		WHERE CT.CenterTypeDescriptionShort = 'C'
				AND C.IsActiveFlag = 1

	END
	IF @OtherCenter = 'F'  --Franchise
	BEGIN
		INSERT  INTO #Centers
		SELECT  C.CenterID
			,		C.CenterDescriptionFullCalc
		FROM dbo.cfgCenter C
		INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = C.CenterTypeID
		WHERE CT.CenterTypeDescriptionShort IN('F','JV')
				AND C.IsActiveFlag = 1

	END
	IF @OtherCenter = 'S'  --Single
	BEGIN
		INSERT  INTO #Centers
		SELECT  C.CenterID
		,		C.CenterDescriptionFullCalc
		FROM dbo.cfgCenter C
		INNER JOIN dbo.lkpCenterType CT
					ON CT.CenterTypeID = C.CenterTypeID
		WHERE CONVERT(VARCHAR, C.CenterID) = @SingleCenter
			AND C.IsActiveFlag = 1

	END

--SELECT * FROM #Centers

	/************ Populate the temp table #transfer **********************************/

	IF @ClientType = 1 --Clients transferred to my center
	BEGIN
		INSERT INTO #transfer
		SELECT sc.SalesCodeDescription
			,	so.CenterID as 'NewCenterID'
			,	c.CenterDescriptionFullCalc AS 'NewCenter'
			,	cl.ClientFullNameCalc AS 'Client'
			,	sod.PreviousClientMembershipGUID AS 'PreviousClientMembershipGUID'
			,	m.MembershipDescription AS 'MembershipDescription'
			,	orig_cm.EndDate AS 'MembershipEndDate'
			,	sc.SalesCodeDescriptionShort AS 'SalesCodeDescriptionShort'
			,	orig_cm.CenterID as 'OriginalCenterID'
			,	c2.CenterDescriptionFullCalc AS 'OriginalCenter'
			,	so.CreateDate AS 'CreateDate'
			,	so.SalesOrderTypeID AS 'SalesOrderTypeID'
			,	so.EmployeeGUID AS 'EmployeeGUID'
			,	e.UserLogin
			,	ISNULL(d_tran.Amount, 0.0) as 'RevenueTransferred'

FROM datSalesOrder so
    INNER JOIN datClient cl ON cl.ClientGUID = so.ClientGUID
    INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
    INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
    INNER JOIN datClientMembership orig_cm ON orig_cm.ClientMembershipGUID = sod.PreviousClientMembershipGUID
	INNER JOIN dbo.cfgMembership m ON m.MembershipID = orig_cm.MembershipID
	INNER JOIN dbo.datEmployee e ON e.EmployeeGUID = so.EmployeeGUID
	INNER JOIN dbo.cfgCenter c ON so.CenterID = c.CenterID
	INNER JOIN dbo.cfgCenter c2 ON orig_cm.CenterID = c2.CenterID
    OUTER APPLY
    (
            SELECT TOP(1) d_sod.ExtendedPriceCalc as Amount FROM datSalesOrder d_so
                    INNER JOIN datSalesOrderDetail d_sod ON d_so.SalesOrderGUID = d_sod.SalesOrderGUID
                    INNER JOIN cfgSalesCode d_sc ON d_sc.SalesCodeID = d_sod.SalesCodeID
                    WHERE d_so.IsClosedFlag = 1 and d_so.IsVoidedFlag = 0
                        AND d_so.ClientMembershipGUID = so.ClientMembershipGUID
                        AND d_sc.SalesCodeDescriptionShort = 'CLTXFRREV'
                        AND CAST(d_so.OrderDate AS DATE) = CAST(so.OrderDate AS DATE)
    ) d_tran

		WHERE so.OrderDate BETWEEN @StartDate AND @EndDate
		AND so.IsClosedFlag = 1
		and so.IsVoidedFlag = 0
		AND sc.SalesCodeDescriptionShort = 'TXFRIN'
		AND m.MembershipDescription <> 'New Client (ShowNoSale)'
			AND so.CenterID = @MyCenter--Tranferred to center
			AND orig_cm.CenterID IN(SELECT CenterID FROM #Centers) --Tranferred from center


	END
	ELSE
	BEGIN --@ClientType = 2 --Clients transferred from my center
		INSERT INTO #transfer
			SELECT sc.SalesCodeDescription
			,	so.CenterID as 'NewCenterID'
			,	c.CenterDescriptionFullCalc AS 'NewCenter'
			,	cl.ClientFullNameCalc AS 'Client'
			,	sod.PreviousClientMembershipGUID AS 'PreviousClientMembershipGUID'
			,	m.MembershipDescription AS 'MembershipDescription'
			,	orig_cm.EndDate AS 'MembershipEndDate'
			,	sc.SalesCodeDescriptionShort AS 'SalesCodeDescriptionShort'
			,	orig_cm.CenterID as 'OriginalCenterID'
			,	c2.CenterDescriptionFullCalc AS 'OriginalCenter'
			,	so.CreateDate AS 'CreateDate'
			,	so.SalesOrderTypeID AS 'SalesOrderTypeID'
			,	so.EmployeeGUID AS 'EmployeeGUID'
			,	e.UserLogin
			,	ISNULL(d_tran.Amount, 0.0) as 'RevenueTransferred'

FROM datSalesOrder so
    INNER JOIN datClient cl ON cl.ClientGUID = so.ClientGUID
    INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
    INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
    INNER JOIN datClientMembership orig_cm ON orig_cm.ClientMembershipGUID = sod.PreviousClientMembershipGUID
	INNER JOIN dbo.cfgMembership m ON m.MembershipID = orig_cm.MembershipID
	INNER JOIN dbo.datEmployee e ON e.EmployeeGUID = so.EmployeeGUID
	INNER JOIN dbo.cfgCenter c ON so.CenterID = c.CenterID
	INNER JOIN dbo.cfgCenter c2 ON orig_cm.CenterID = c2.CenterID
    OUTER APPLY
    (
            SELECT TOP(1) d_sod.ExtendedPriceCalc as Amount FROM datSalesOrder d_so
                    INNER JOIN datSalesOrderDetail d_sod ON d_so.SalesOrderGUID = d_sod.SalesOrderGUID
                    INNER JOIN cfgSalesCode d_sc ON d_sc.SalesCodeID = d_sod.SalesCodeID
                    WHERE d_so.IsClosedFlag = 1 and d_so.IsVoidedFlag = 0
                        AND d_so.ClientMembershipGUID = so.ClientMembershipGUID
                        AND d_sc.SalesCodeDescriptionShort = 'CLTXFRREV'
                        AND CAST(d_so.OrderDate AS DATE) = CAST(so.OrderDate AS DATE)
    ) d_tran

		WHERE so.OrderDate BETWEEN @StartDate AND @EndDate
		AND so.IsClosedFlag = 1
		and so.IsVoidedFlag = 0
		AND sc.SalesCodeDescriptionShort = 'TXFRIN'
		AND m.MembershipDescription <> 'New Client (ShowNoSale)'
			AND so.CenterID IN(SELECT CenterID FROM #Centers)  --Tranferred to center
			AND orig_cm.CenterID = @MyCenter  --Tranferred from center

		END

SELECT SalesCodeDescription
     , NewCenterID
     , NewCenter
     , Client
     , MembershipDescription
     , MembershipEndDate
     , SalesCodeDescriptionShort
     , OriginalCenterID
     , OriginalCenter
     , CreateDate
     , SalesOrderTypeID
     , EmployeeGUID
     , UserLogin
     , RevenueTransferred
FROM #transfer
GROUP BY SalesCodeDescription
       , NewCenterID
       , NewCenter
       , Client
       , MembershipDescription
       , MembershipEndDate
       , SalesCodeDescriptionShort
       , OriginalCenterID
       , OriginalCenter
       , CreateDate
       , SalesOrderTypeID
       , EmployeeGUID
       , UserLogin
       , RevenueTransferred

END
GO
