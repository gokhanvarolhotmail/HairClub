IF OBJECT_ID('tempdb..#SalesCodes') IS NOT NULL
   DROP TABLE #SalesCodes
IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
   DROP TABLE #Centers


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

CREATE TABLE #Centers (
	RowID INT IDENTITY(1, 1)
,	CenterID INT
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

/********************************** Get list of centers *************************************/
INSERT  INTO #Centers
 SELECT  ctr.CenterID
        FROM    cfgCenter ctr
                INNER JOIN lkpCenterType ct
                    ON ct.CenterTypeID = ctr.CenterTypeID
 WHERE ctr.isActiveFlag = 1 AND ctr.CenterDescription LIKE '%Diego%'


DECLARE	@TotalCount INT
,		@LoopCount INT
,		@CenterID INT


SET @TotalCount = (SELECT COUNT(*) FROM #Centers c)
SET @LoopCount = 1


WHILE @LoopCount <= @TotalCount
BEGIN
	SET @CenterID = (SELECT c.CenterID FROM #Centers c WHERE c.RowID = @LoopCount)


	--Insert cfgSalesCodeCenter Records
	INSERT  INTO cfgSalesCodeCenter (
					CenterID
			,		SalesCodeID
			,		PriceRetail
			,		TaxRate1ID
			,		TaxRate2ID
			,		QuantityMaxLevel
			,		QuantityMinLevel
			,		CenterCost
			,		IsActiveFlag
			,		CreateDate
			,		CreateUser
			,		LastUpdate
			,		LastUpdateUser
			)
			SELECT  @CenterID
			,       sc.SalesCodeID
			,       NULL
			,       (SELECT CCTR.CenterTaxRateID FROM cfgCenterTaxRate CCTR WHERE CCTR.CenterID = @CenterID AND CCTR.TaxTypeID = 1)
			,       NULL
			,       0
			,       0
			,		s.CenterCost
			,       1
			,       GETUTCDATE()
			,       s.CreateUser
			,       GETUTCDATE()
			,       s.CreateUser
			FROM    cfgSalesCode sc
					INNER JOIN #SalesCodes s
						ON s.SalesCodeDescriptionShort = sc.SalesCodeDescriptionShort
					LEFT OUTER JOIN cfgSalesCodeCenter sccNew
						ON sccNew.SalesCodeID = sc.SalesCodeID
						   AND sccNew.CenterID = @CenterID
			WHERE   sccNew.SalesCodeCenterID IS NULL


	-- Insert datSalesCodeCenterInventory Records
	INSERT  INTO datSalesCodeCenterInventory (
				[SalesCodeCenterID]
			,	[QuantityOnHand]
			,	[QuantityPar]
			,	[IsActive]
			,	[CreateDate]
			,	[CreateUser]
			,	[LastUpdate]
			,	[LastUpdateUser]
			)
			SELECT  scc.SalesCodeCenterID
			,       0
			,		0
			,		1
			,       GETUTCDATE()
			,       s.CreateUser
			,       GETUTCDATE()
			,       s.CreateUser
			FROM    cfgSalesCodeCenter scc
					INNER JOIN cfgSalesCode sc
						ON scc.SalesCodeID = sc.SalesCodeID
					INNER JOIN #SalesCodes s
						ON s.SalesCodeDescriptionShort = sc.SalesCodeDescriptionShort
					INNER JOIN cfgSalesCodeDistributor scd
						ON scd.SalesCodeID = s.SalesCodeID
					LEFT OUTER JOIN datSalesCodeCenterInventory scciNew
						ON scc.SalesCodeCenterID = scciNew.SalesCodeCenterID
			WHERE   scc.CenterID = @CenterID
					AND s.IsInventoried = 1
					AND scciNew.SalesCodeCenterInventoryID IS NULL


	SET @CenterID = NULL

	SET @LoopCount = @LoopCount + 1
END


UPDATE scc
SET
		scc.IsActiveFlag = 0
,		scc.LastUpdateUser = 'TFS #14975'
,		scc.LastUpdate = GETUTCDATE()
FROM cfgSalesCodeCenter scc
INNER JOIN cfgCenter c ON
	c.CenterID = scc.CenterID
INNER JOIN lkpCenterType ct ON
	ct.CenterTypeID = c.CenterTypeID
INNER JOIN cfgSalesCode sc ON
	sc.SalesCodeID = scc.SalesCodeID
where sc.LastUpdateUser IN ('TFS #14975')


UPDATE scc
SET
		scc.IsActiveFlag = 1
,		scc.LastUpdateUser = 'TFS #14975'
,		scc.LastUpdate = GETUTCDATE()
FROM cfgSalesCodeCenter scc
INNER JOIN cfgCenter c ON
	c.CenterID = scc.CenterID
INNER JOIN lkpCenterType ct ON
	ct.CenterTypeID = c.CenterTypeID
INNER JOIN cfgSalesCode sc ON
	sc.SalesCodeID = scc.SalesCodeID
where c.CenterDescription LIKE '%Diego%' and sc.LastUpdateUser IN ('TFS #14975') AND c.IsActiveFlag = 1
