IF OBJECT_ID('tempdb..#SalesCodes') IS NOT NULL
   DROP TABLE #SalesCodes
IF OBJECT_ID('tempdb..#Memberships') IS NOT NULL
   DROP TABLE #Memberships


/********************************** Create temp table objects *************************************/
CREATE TABLE #SalesCodes (
	RowID INT IDENTITY(1, 1)
,	SalesCodeID INT
,	SalesCodeDescriptionShort NVARCHAR(15)
,	SalesCodeDescription NVARCHAR(50)
,	IsInventoried BIT
,	CenterCost MONEY
,	CreateUser NVARCHAR(25)
)

CREATE TABLE #Memberships (
	RowID INT IDENTITY(1, 1)
,	MembershipID INT
)


/********************************** Get list of sales codes *************************************/
INSERT	INTO #SalesCodes
        SELECT  sc.SalesCodeID
		,		sc.SalesCodeDescriptionShort
		,		sc.SalesCodeDescription
		,		tsc.IsInventoried
		,		tsc.CenterCost
		,		sc.CreateUser
        FROM    cfgSalesCode sc
				LEFT OUTER JOIN Log4Net.dbo.tmpSalesCodeCreation tsc
					ON tsc.NewSalesCodeDescriptionShort = sc.SalesCodeDescriptionShort
        WHERE   tsc.LastUpdateUser IN ('TFS #14975')


/********************************** Get list of memberships *************************************/
INSERT  INTO #Memberships
		SELECT	m.MembershipID
		FROM	cfgMembership m

DECLARE	@TotalCount INT
,		@LoopCount INT
,		@MembershipID INT


SET @TotalCount = (SELECT COUNT(*) FROM #Memberships M)
SET @LoopCount = 1


WHILE @LoopCount <= @TotalCount
BEGIN
	SET @MembershipID = (SELECT M.MembershipID FROM #Memberships M WHERE M.RowID = @LoopCount)


	--Insert Missing cfgSalesCodeMembership Records
	INSERT  INTO cfgSalesCodeMembership (
				SalesCodeCenterID
			,	MembershipID
			,	Price
			,	TaxRate1ID
			,	TaxRate2ID
			,	IsActiveFlag
			,	CreateDate
			,	CreateUser
			,	LastUpdate
			,	LastUpdateUser
			)
			SELECT  scc.SalesCodeCenterID
			,       @MembershipID
			,       NULL
			,       NULL
			,       NULL
			,       1
			,       GETUTCDATE()
			,       s.CreateUser
			,       GETUTCDATE()
			,       s.CreateUser
			FROM    cfgSalesCodeCenter scc
					INNER JOIN #SalesCodes s
						ON s.SalesCodeID = scc.SalesCodeID
					LEFT OUTER JOIN cfgSalesCodeMembership scmNew
						ON scmNew.SalesCodeCenterID = scc.SalesCodeCenterID
							AND scmNew.MembershipID = @MembershipID
			WHERE   scmNew.SalesCodeMembershipID IS NULL


	SET @MembershipID = NULL


	SET @LoopCount = @LoopCount + 1
END


