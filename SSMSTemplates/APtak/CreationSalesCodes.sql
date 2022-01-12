IF OBJECT_ID('tempdb..#SalesCodes') IS NOT NULL
   DROP TABLE #SalesCodes
   

/********************************** Create temp table objects *************************************/
CREATE TABLE #SalesCodes (
	RowID INT IDENTITY(1, 1)
,	CopyFromSalesCodeDescriptionShort NVARCHAR(15)
,	NewSalesCodeDescriptionShort NVARCHAR(15)
,	NewSalesCodeDescription NVARCHAR(50)
,	NewSalesCodePrice MONEY
,	NewSalesCodeInterCompanyPrice MONEY
,	FifteenPercentDiscount MONEY
,	TwentyPercentDiscount MONEY
,	ServiceDuration INT
,	IsRefundable BIT
,	IsDiscountable BIT
,	Product NVARCHAR(50)
,	IsSerializedInventory INT
,	SerialNumberRegEx NVARCHAR(300)
,	IsInventoried BIT
,	InventorySalesCodeID INT
,	Brand NVARCHAR(100)
,	Size NVARCHAR(20)
,	SalesCodeDepartment NVARCHAR(100)
,	GeneralLedger NVARCHAR(100)
,	QuantityPerPack INT
,	CanOrderFlag BIT
,	AddToDistributorFlag BIT
,	CenterCost MONEY
,	CopyCenterPrice BIT
,	CopyMembershipPrice BIT
,	CreateUser NVARCHAR(25)
)


INSERT	INTO #SalesCodes
		SELECT	tsc.CopyFromSalesCodeDescriptionShort
		,		tsc.NewSalesCodeDescriptionShort
		,		tsc.NewSalesCodeDescription
		,		tsc.NewSalesCodePrice
		,		tsc.NewSalesCodeInterCompanyPrice
		,		tsc.FifteenPercentDiscount
		,		tsc.TwentyPercentDiscount
		,		tsc.ServiceDuration
		,		tsc.IsRefundable
		,		tsc.IsDiscountable
		,		tsc.Product
		,		tsc.IsSerializedInventory
		,		tsc.SerialNumberRegEx
		,		tsc.IsInventoried
		,		tsc.InventorySalesCodeID
		,		tsc.Brand
		,		tsc.Size
		,		tsc.SalesCodeDepartment
		,		tsc.GeneralLedger
		,		tsc.QuantityPerPack
		,		tsc.CanOrderFlag
		,		tsc.AddToDistributorFlag
		,		tsc.CenterCost
		,		tsc.CopyCenterPrice
		,		tsc.CopyMembershipPrice
		,		tsc.CreateUser
		FROM	Log4Net.dbo.tmpSalesCodeCreation tsc
		WHERE	tsc.CreateUser = 'TFS #14975'


DECLARE	@TotalCount INT
,		@LoopCount INT
,		@NewSalesCodeDescriptionShort NVARCHAR(15)
,       @NewSalesCodeDescription NVARCHAR(50)
,       @NewSalesCodePrice MONEY
,       @NewSalesCodeInterCompanyPrice MONEY
,       @ServiceDuration INT
,       @IsRefundable BIT
,       @IsDiscountable BIT
,       @Product NVARCHAR(50)
,       @CopyCenterPrice BIT
,       @CopyMembershipPrice BIT
,       @CanOrderFlag BIT
,		@AddToDistributorFlag BIT
,		@IsInventoried BIT
,		@CenterCost MONEY
,       @CopyFromSalesCodeDescriptionShort NVARCHAR(15)
,       @User NVARCHAR(25)
,       @CopyFromSalesCodeID INT
,       @NewSalesCodeID INT
,		@SerialNumberRegEx NVARCHAR(300)
,		@InventorySalesCodeID INT
,		@CasePackUnitOfMeasureID INT
,		@EachPackUnitOfMeasureID INT


SET @TotalCount = ( SELECT COUNT(*) FROM #SalesCodes sc )
SET @LoopCount = 1


WHILE @LoopCount <= @TotalCount
BEGIN
	SET @NewSalesCodeDescriptionShort = (SELECT sc.NewSalesCodeDescriptionShort FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @NewSalesCodeDescription = (SELECT sc.NewSalesCodeDescription FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @NewSalesCodePrice = (SELECT sc.NewSalesCodePrice FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @NewSalesCodeInterCompanyPrice = (SELECT sc.NewSalesCodeInterCompanyPrice FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @ServiceDuration = (SELECT sc.ServiceDuration FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @IsRefundable = (SELECT sc.IsRefundable FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @IsDiscountable = (SELECT sc.IsDiscountable FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @Product = (SELECT sc.Product FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @CopyCenterPrice = (SELECT sc.CopyCenterPrice FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @CopyMembershipPrice = (SELECT sc.CopyMembershipPrice FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @CenterCost = (SELECT sc.CenterCost FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @CanOrderFlag = (SELECT sc.CanOrderFlag FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @AddToDistributorFlag = (SELECT sc.AddToDistributorFlag FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @IsInventoried = (SELECT sc.IsInventoried FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @CopyFromSalesCodeDescriptionShort = (SELECT sc.CopyFromSalesCodeDescriptionShort FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)
	SET @User = (SELECT sc.CreateUser FROM #SalesCodes sc WHERE sc.RowID = @LoopCount)


	-- Get the SalesCodeID which is being Copied 
	SELECT @CopyFromSalesCodeID = sc.SalesCodeID FROM cfgSalesCode sc WHERE sc.SalesCodeDescriptionShort = @CopyFromSalesCodeDescriptionShort


	PRINT 'Inserting Sales Code ' + @NewSalesCodeDescriptionShort

	INSERT  INTO dbo.cfgSalesCode ( 
				SalesCodeSortOrder
			,	SalesCodeDescription
			,	SalesCodeDescriptionShort
			,	SalesCodeTypeID
			,	SalesCodeDepartmentID
			,	VendorID
			,	Barcode
			,	PriceDefault
			,	GLNumber
			,	ServiceDuration
			,	CanScheduleFlag
			,	FactoryOrderFlag
			,	isRefundableFlag
			,	InventoryFlag
			,	SurgeryCloseoutFlag
			,	TechnicalProfileFlag
			,	AdjustContractPaidAmountFlag
			,	IsPriceAdjustableFlag
			,	IsDiscountableFlag
			,	IsActiveFlag
			,	CreateDate
			,	CreateUser
			,	LastUpdate
			,	LastUpdateUser
			,	IsARTenderRequiredFlag
			,	CanOrderFlag
			,	IsQuantityAdjustableFlag
			,	IsPhotoEnabledFlag
			,	IsEXTOnlyProductFlag
			,	HairSystemID
			,	SaleCount
			,	IsSalesCodeKitFlag
			,	BiOGeneralLedgerID
			,	EXTGeneralLedgerID
			,	SURGeneralLedgerID
			,	BrandID
			,	Product
			,	Size
			,	IsRefundablePayment
			,	IsNSFChargebackFee
			,	InterCompanyPrice
			,	IsQuantityRequired
			,	XTRGeneralLedgerID
			,	IsBosleySalesCode
			,	IsVisibleToConsultant
			,	IsSerialized
			,	InventorySalesCodeID
			,	QuantityPerPack
			,	PackUnitOfMeasureID
			)
			SELECT  sc.SalesCodeSortOrder
			,       @NewSalesCodeDescription
			,       @NewSalesCodeDescriptionShort
			,       sc.SalesCodeTypeID
			,       sc.SalesCodeDepartmentID
			,       sc.VendorID
			,       sc.Barcode
			,       ISNULL(@NewSalesCodePrice, sc.PriceDefault) AS PriceDefault
			,       sc.GLNumber
			,       ISNULL(@ServiceDuration, sc.ServiceDuration) AS ServiceDuration
			,       sc.CanScheduleFlag
			,       sc.FactoryOrderFlag
			,       @IsRefundable
			,       sc.InventoryFlag
			,       sc.SurgeryCloseoutFlag
			,       sc.TechnicalProfileFlag
			,       sc.AdjustContractPaidAmountFlag
			,       sc.IsPriceAdjustableFlag
			,       @IsDiscountable
			,       sc.IsActiveFlag
			,       GETUTCDATE() AS CreateDate
			,       @User
			,       GETUTCDATE() AS LastUpdate
			,       @User
			,       sc.IsARTenderRequiredFlag
			,       @CanOrderFlag
			,       sc.IsQuantityAdjustableFlag
			,       sc.IsPhotoEnabledFlag
			,       sc.IsEXTOnlyProductFlag
			,       sc.HairSystemID
			,       sc.SaleCount
			,       sc.IsSalesCodeKitFlag
			,       sc.BiOGeneralLedgerID
			,       sc.EXTGeneralLedgerID
			,       sc.SURGeneralLedgerID
			,       sc.BrandID
			,       ISNULL(@Product, sc.Product) AS Product
			,       sc.Size
			,       sc.IsRefundablePayment
			,       sc.IsNSFChargebackFee
			,       ISNULL(@NewSalesCodeInterCompanyPrice, sc.InterCompanyPrice) AS InterCompanyPrice
			,		sc.IsQuantityRequired
			,		sc.XTRGeneralLedgerID
			,		sc.IsBosleySalesCode
			,		sc.IsVisibleToConsultant
			,		sc.IsSerialized
			,		@InventorySalesCodeID
			,		sc.QuantityPerPack
			,		sc.PackUnitOfMeasureID
			FROM    cfgSalesCode sc
					LEFT OUTER JOIN cfgSalesCode scNew
						ON scNew.SalesCodeDescriptionShort = @NewSalesCodeDescriptionShort
			WHERE   sc.SalesCodeID = @CopyFromSalesCodeID
					AND scNew.SalesCodeID IS NULL


	-- Get the New SalesCodeID 
	SELECT @NewSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = @NewSalesCodeDescriptionShort


	-- Create the cfgAccumulatorJoin Record(s)
	PRINT 'Inserting Accums for ' + @NewSalesCodeDescriptionShort

	INSERT  INTO cfgAccumulatorJoin (
				AccumulatorJoinSortOrder
			,	AccumulatorJoinTypeID
			,	SalesCodeID
			,	AccumulatorID
			,	AccumulatorDataTypeID
			,	AccumulatorActionTypeID
			,	AccumulatorAdjustmentTypeID
			,	IsActiveFlag
			,	CreateDate
			,	CreateUser
			,	LastUpdate
			,	LastUpdateUser
			,	HairSystemOrderProcessID
			,	IsEligibleForInterCompanyTransaction
			)
			SELECT  aj.AccumulatorJoinSortOrder
			,       aj.AccumulatorJoinTypeID
			,       @NewSalesCodeID AS SalesCodeID
			,       aj.AccumulatorID
			,       aj.AccumulatorDataTypeID
			,       aj.AccumulatorActionTypeID
			,       aj.AccumulatorAdjustmentTypeId
			,       aj.IsActiveFlag
			,       GETUTCDATE() AS CreateDate
			,       @User
			,       GETUTCDATE() AS LastUpdate
			,       @User
			,       aj.HairSystemOrderProcessID
			,		aj.IsEligibleForInterCompanyTransaction
			FROM    cfgAccumulatorJoin aj
					INNER JOIN cfgSalesCode sc
						ON sc.SalesCodeID = aj.SalesCodeID
					LEFT OUTER JOIN cfgAccumulatorJoin ajNew
						ON ajNew.SalesCodeID = @NewSalesCodeID
			WHERE   aj.SalesCodeID = @CopyFromSalesCodeID
					AND ajNew.AccumulatorJoinID IS NULL


	-- cfgSalesCodeCenter 
	PRINT 'Inserting Sales Code Center records for ' + @NewSalesCodeDescriptionShort

	INSERT  INTO cfgSalesCodeCenter (
				CenterID
			,	SalesCodeID
			,	PriceRetail
			,	TaxRate1ID
			,	TaxRate2ID
			,	QuantityMaxLevel
			,	QuantityMinLevel
			,	IsActiveFlag
			,	CreateDate
			,	CreateUser
			,	LastUpdate
			,	LastUpdateUser
			,	AgreementID
			,	CenterCost
			)
			SELECT  scc.CenterID
			,       @NewSalesCodeID AS SalesCodeID
			,       IIF(@CopyCenterPrice = 1, scc.PriceRetail, NULL) AS PriceRetail
			,       scc.TaxRate1ID
			,       scc.TaxRate2ID
			,       scc.QuantityMaxLevel
			,       scc.QuantityMinLevel
			,       1
			,       GETUTCDATE() AS CreateDAte
			,       @User
			,       GETUTCDATE() AS LastUpdate
			,       @User
			,		scc.AgreementID
			,		@CenterCost
			FROM    cfgSalesCodeCenter scc
					INNER JOIN cfgSalesCode sc
						ON sc.SalesCodeID = scc.SalesCodeID
					LEFT OUTER JOIN cfgSalesCodeCenter sccNew
						ON sccNew.SalesCodeID = @NewSalesCodeID
							AND sccNew.CenterID = scc.CenterID
			WHERE   scc.SalesCodeID = @CopyFromSalesCodeID
					AND sccNew.SalesCodeCenterID IS NULL


	-- cfgSalesCodeMembership
	PRINT 'Inserting Sales Code Membership records for ' + @NewSalesCodeDescriptionShort

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
			SELECT  sccNew.SalesCodeCenterID
			,       scm.MembershipID
			,       IIF(@CopyMembershipPrice = 1, scm.Price, NULL) AS Price
			,       scm.TaxRate1ID
			,       scm.TaxRate2ID
			,       scm.IsActiveFlag
			,       GETUTCDATE() AS CreateDate
			,       @User
			,       GETUTCDATE() AS LastUpdate
			,       @User
			FROM    cfgSalesCodeCenter scc
					INNER JOIN cfgSalesCodeCenter sccNew
						ON scc.CenterID = sccNew.CenterID
						   AND sccNew.SalesCodeID = @NewSalesCodeID
					INNER JOIN cfgSalesCodeMembership scm
						ON scm.SalesCodeCenterID = scc.SalesCodeCenterID
					INNER JOIN cfgMembership m
						ON scm.MembershipID = m.MembershipID
					OUTER APPLY ( SELECT    x_scm.*
								  FROM      cfgSalesCodeMembership x_scm
								  WHERE     x_scm.SalesCodeCenterID = sccNew.SalesCodeCenterID
											AND x_scm.MembershipID = m.MembershipID
								) n_scm
			WHERE   scc.SalesCodeID = @CopyFromSalesCodeID
					AND n_scm.SalesCodeMembershipID IS NULL


	IF @IsInventoried = 1
	BEGIN
		-- datSalesCodeCenterInventory
		PRINT 'Inserting Sales Code Center Inventory records for ' + @NewSalesCodeDescriptionShort

		INSERT  INTO datSalesCodeCenterInventory (
					SalesCodeCenterID
				,	QuantityOnHand
				,	QuantityPar
				,	IsActive
				,	CreateDate
				,	CreateUser
				,	LastUpdate
				,	LastUpdateUser
				)
				SELECT  scc.SalesCodeCenterID
				,       0
				,		0
				,		1
				,       GETUTCDATE()
				,       @User
				,       GETUTCDATE()
				,       @User
				FROM    cfgSalesCodeCenter scc
						INNER JOIN cfgSalesCode sc 
							ON scc.SalesCodeID = sc.SalesCodeID
						LEFT OUTER JOIN datSalesCodeCenterInventory scciNew 
							ON scc.SalesCodeCenterID = scciNew.SalesCodeCenterID
				WHERE   scc.SalesCodeID = @NewSalesCodeID
						AND scciNew.SalesCodeCenterInventoryID IS NULL
	END


	IF @AddToDistributorFlag = 1
	BEGIN
		-- cfgSalesCodeDistributor
		PRINT 'Inserting Sales Code Distributor records for ' + @NewSalesCodeDescriptionShort

		INSERT	INTO cfgSalesCodeDistributor
				(		SalesCodeID
				,		CenterID
				,		ItemSKU
				,		PackSKU
				,		ItemName
				,		ItemDescription
				,		IsActive
				,		QuantityAvailable
				,		AllowDropShipments
				,		AllowCenterOrder
				,		CreateDate
				,		CreateUser
				,		LastUpdate
				,		LastUpdateUser
				)
				SELECT  sc.SalesCodeID
				,		1091 AS 'CenterID' -- IFS Distributor
				,		sc.SalesCodeDescriptionShort AS 'ItemSKU'
				,		REPLACE(s.NewSalesCodeDescriptionShort, '-', '') AS 'PackSKU'
				,		sc.SalesCodeDescription AS 'ItemName'
				,		sc.SalesCodeDescription AS 'ItemDescription'
				,		1 AS 'IsActive'
				,		0 AS 'QuantityAvailable'
				,		0 AS 'AllowDropShipments'
				,		sc.CanOrderFlag AS 'AllowCenterOrder'
				,		GETUTCDATE() AS 'CreateDate'
				,		@User AS 'CreateUser'
				,		GETUTCDATE() AS 'LastUpdate'
				,		@User AS 'LastUpdateUser'
				FROM    cfgSalesCode sc
						INNER JOIN #SalesCodes s
							ON s.NewSalesCodeDescriptionShort = sc.SalesCodeDescriptionShort 
	END


	UPDATE	tsc
	SET		tsc.IsProcessedFlag = 1
	,		tsc.ProcessedDate = GETDATE()
	,		tsc.LastUpdate = GETDATE()
	,		tsc.LastUpdateUser = @User
	FROM	Log4Net.dbo.tmpSalesCodeCreation tsc
	WHERE	tsc.NewSalesCodeDescriptionShort = @NewSalesCodeDescriptionShort
			AND ISNULL(tsc.IsProcessedFlag, 0) = 0


	SET @NewSalesCodeDescriptionShort = NULL
	SET @NewSalesCodeDescription = NULL
	SET @NewSalesCodePrice = NULL
	SET @NewSalesCodeInterCompanyPrice = NULL
	SET @ServiceDuration = NULL
	SET @IsRefundable = NULL
	SET @IsDiscountable = NULL
	SET @Product = NULL
	SET @CopyCenterPrice = NULL
	SET @CopyMembershipPrice = NULL
	SET @CenterCost = NULL
	SET @CanOrderFlag = NULL
	SET @IsInventoried = NULL
	SET @CopyFromSalesCodeDescriptionShort = NULL
	SET @CopyFromSalesCodeID = NULL
	SET @NewSalesCodeID = NULL


	SET @LoopCount = @LoopCount + 1
END


-- Apply 15% and 20% discounts (if required)
UPDATE	scm
SET		Price = CASE WHEN scm.MembershipID IN ( 26, 65, 66, 89 ) THEN ROUND(sc.FifteenPercentDiscount, 2) ELSE ROUND(sc.TwentyPercentDiscount, 2) END
,		LastUpdate = GETUTCDATE()
,		LastUpdateUser = @User
FROM    cfgSalesCodeMembership scm
		INNER JOIN cfgSalesCodeCenter scc
			ON scc.SalesCodeCenterID = scm.SalesCodeCenterID
		INNER JOIN cfgCenter ctr
			ON ctr.CenterID = scc.CenterID
		INNER JOIN cfgSalesCode csc
			ON csc.SalesCodeID = scc.SalesCodeID
		INNER JOIN #SalesCodes sc
			ON sc.NewSalesCodeDescriptionShort = csc.SalesCodeDescriptionShort
WHERE	scm.MembershipID IN ( 28, 67, 68, 26, 65, 66, 89, 91 )
		AND ( ISNULL(sc.FifteenPercentDiscount, 0) <> 0
				AND ISNULL(sc.TwentyPercentDiscount, 0) <> 0 )
		AND ctr.CenterNumber LIKE '[2]%'


SET @CasePackUnitOfMeasureID = (SELECT UnitOfMeasureID FROM lkpUnitOfMeasure WHERE UnitOfMeasureDescriptionShort = 'CASE')
SET @EachPackUnitOfMeasureID = (SELECT UnitOfMeasureID FROM lkpUnitOfMeasure WHERE UnitOfMeasureDescriptionShort = 'EACH')


UPDATE  sc
SET     SalesCodeDepartmentID = dep.SalesCodeDepartmentID
,		GLNumber = gl.GeneralLedgerID
,       BIOGeneralLedgerID = gl.GeneralLedgerID
,       EXTGeneralLedgerID = gl.GeneralLedgerID
,       XTRGeneralLedgerID = gl.GeneralLedgerID
,       SURGeneralLedgerID = gl.GeneralLedgerID
,		BrandID = lb.BrandID
,		Size = s.Size
,		QuantityPerPack = s.QuantityPerPack
,		PackUnitOfMeasureID = CASE WHEN s.QuantityPerPack > 1 THEN @CasePackUnitOfMeasureID ELSE @EachPackUnitOfMeasureID END
,		InventorySalesCodeID = CASE WHEN ISNULL(s.InventorySalesCodeID, 0) = 0 THEN NULL ELSE s.InventorySalesCodeID END
,		SerialNumberRegEx = CASE WHEN s.IsSerializedInventory = 1 THEN s.SerialNumberRegEx ELSE NULL END -- E.g. ^CRX[A-Za-z0-9]{10,20}$ or ^N[A-Za-z0-9]{5,10}$
,		PackSKU = CASE WHEN s.IsInventoried = 1 THEN REPLACE(s.NewSalesCodeDescriptionShort, '-', '') ELSE NULL END
,		IsActiveFlag = 1
,       LastUpdate = GETUTCDATE()
,       LastUpdateUser = s.CreateUser
FROM    cfgSalesCode sc
        INNER JOIN #SalesCodes s
            ON s.NewSalesCodeDescriptionShort = sc.SalesCodeDescriptionShort
		LEFT JOIN lkpBrand lb
			ON lb.BrandDescription = s.Brand
				AND lb.IsActiveFlag = 1
		LEFT JOIN lkpGeneralLedger gl
			ON gl.GeneralLedgerDescription = s.GeneralLedger
		LEFT JOIN lkpSalesCodeDepartment dep
			ON dep.SalesCodeDepartmentDescription = s.SalesCodeDepartment

UPDATE cfgSalesCode 
SET CanOrderFlag = 1
WHERE LastUpdateUser = 'TFS #14975'