/* CreateDate: 06/25/2012 09:47:42.900 , ModifyDate: 05/28/2018 22:03:28.250 */
GO
/*
==============================================================================
PROCEDURE:				mtnGetAccountingPriorityBillingExport

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		06/13/2012

LAST REVISION DATE: 	07/09/2012

==============================================================================
DESCRIPTION:  Billing file for Priority Hair Systems (IsStockInventoryFlag = true).
				Included in the billing file when shipped from either corporate
				or center and have an associated Transfer Request record either in Shipped
				or completed Status (use latest record if more than 1 exist).
==============================================================================
NOTES:
		* 06/13/2012 MVT - Created
		* 07/09/2012 MVT - Modified so that a single file is generated for Corporate
							and Franchise billing.
		* 08/21/2012 MVT - Fixed issue with Freight calculation for the Total on the Accounting
							Export Batch Record.
		* 09/17/2017 SAL - Updated to join union selects to datAccountingExportBatchDetail.CenterID to cfgCenter and
								Updated to return cfgCenter.CenterNumber As CenterID.
		* 05/08/2018 SAL - Added a join from the transaction's ClientHomeCenterID for the "Ship From" batch record,
								updated to include returning the ClientHomeCenterNumber As BillingCenterId, and
								changed CenterNumber to be returned as ShippingCenterId versus CenterId (TFS#10684)

==============================================================================
SAMPLE EXECUTION: [mtnGetAccountingPriorityBillingExport] '06/01/2012', '06/05/2012', '07/09/2012', 'Test.csv', null, 'sa', 0, 100
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnGetAccountingPriorityBillingExport]
	@BeginDate datetime,
	@EndDate datetime,
	@InvoiceDate datetime, -- informational, only written to batch record
	@ExportFileName nvarchar(200),
	@BatchGUID uniqueidentifier,
	@User nvarchar(25),
	@SkipCount int,
	@PageSize int
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @CenterType as char


	/**********************************************/
	-- CONSTANTS
	/**********************************************/
	DECLARE @PriorityBatchTypeConst as nvarchar(15)  = 'Priority'
	DECLARE @ShipFromCorpHairSystemOrderProcessDescription as nvarchar(15) = 'SHIPFCORP'
	DECLARE @ShipFromCenterHairSystemOrderProcessDescription as nvarchar(15) = 'SHIPFCTR'

	DECLARE @CompletedInventoryTransferRequestStatus as nvarchar(15) = 'Completed'
	DECLARE @ShippedInventoryTransferRequestStatus as nvarchar(15) = 'Shipped'

	DECLARE @CorpCenter as integer = 100
	DECLARE @CorpCenterType as char = 'C'
	DECLARE @FranchiseCenterType as char = 'F'
	DECLARE @JointCenterType as nvarchar(2) = 'JV'
	DECLARE @CorpType as nvarchar(20) = 'Corporate'
	DECLARE @FranchiseType as nvarchar(20) = 'Franchise'

	DECLARE @HairClubForKidsMembershipShortDesc as nvarchar(10) = 'HCFK'
	DECLARE @EmployeeMembershipShortDesc as nvarchar(10) = 'EMPLOYEE'
	DECLARE @EmployeeExtMembershipShortDesc as nvarchar(10) = 'EMPLOYEXT'
	DECLARE @ModelMembershipShortDesc as nvarchar(10) = 'MODEL'
	DECLARE @ModelExtMembershipShortDesc as nvarchar(10) = 'MODELEXT'

	/**********************************************/
	-- Create an AccountingExportBatch record
	/**********************************************/
	DECLARE @AccountingExportBatchGUID as uniqueidentifier
	DECLARE @AccountingExportBatchTypeID as int
	DECLARE @AccountingBatchNumber as int
	DECLARE @ReceiveFromFactoryShipmentTypeID as int

	IF @BatchGUID is null
		SET @AccountingExportBatchGUID = newid()
	ELSE
		SET @AccountingExportBatchGUID = @BatchGUID


	-------------------------------------------
	-- SET End Date
	-------------------------------------------
	--SET @EndDate = DATEADD(Second, -1, DATEADD(Day, 1, @EndDate))


    SELECT  TimeZoneID
    ,       [UTCOffset]
    ,       [UsesDayLightSavingsFlag]
    ,       [IsActiveFlag]
    ,       dbo.GetUTCFromLocal(@BeginDate, [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCStartDate]
    ,       dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCEndDate]
    INTO    #UTCDateParms
    FROM    dbo.lkpTimeZone
    WHERE   [IsActiveFlag] = 1;


BEGIN TRANSACTION

BEGIN TRY

	-- Check if creating a new Accounting Export Batch.
	-- If @BatchGUID has a value, then re-generating
	IF @BatchGUID is null
	BEGIN
		-------------------------------------------
		-- SET Accounting Export Batch Number
		-------------------------------------------
		DECLARE @BatchNumber TABLE	(
				Number nvarchar(40)
		)

		INSERT INTO @BatchNumber(Number)
		EXEC dbo.mtnGetAccountingExportBatchNumber

		SET @AccountingBatchNumber = (SELECT CONVERT(Integer, Number) FROM @BatchNumber)

		-------------------------------------------
		-- SET Batch Type ID
		-------------------------------------------
		SET @AccountingExportBatchTypeID = (SELECT l.AccountingExportBatchTypeID FROM dbo.lkpAccountingExportBatchType l WHERE  l.AccountingExportBatchTypeDescriptionShort = @PriorityBatchTypeConst)


		INSERT INTO dbo.datAccountingExportBatch (AccountingExportBatchGUID, AccountingExportBatchTypeID, AccountingExportBatchNumber, BatchRunDate, BatchBeginDate, BatchEndDate, BatchInvoiceDate, ExportFileName, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
			(@AccountingExportBatchGUID, @AccountingExportBatchTypeID, @AccountingBatchNumber, GETUTCDATE(), @BeginDate, @EndDate, @InvoiceDate, @ExportFileName, GETUTCDATE(), @User, GETUTCDATE(), @User)

		-------------------------------------------
		-- Select Distinct transactions by Hair System Order
		-------------------------------------------
		DECLARE @Transactions TABLE	(
				TransactionGUID uniqueidentifier,
				PRIMARY KEY ( TransactionGUID )
		)


		-- Transactions for Shipped from Corp Process
		INSERT INTO @Transactions(TransactionGUID)
		SELECT MAX(convert(nvarchar(40),h.HairSystemOrderTransactionGUID))
		FROM datHairSystemOrderTransaction h
			INNER JOIN datHairSystemOrder hso ON hso.HairSystemOrderGUID = h.HairSystemOrderGUID
			INNER JOIN cfgCenter htcntr ON htcntr.CenterID = h.CenterID
			--INNER JOIN lkpCenterType ct ON htcntr.CenterTypeID = ct.CenterTypeID
			INNER JOIN cfgCenter prhtcntr ON prhtcntr.CenterID = h.PreviousCenterID
			--INNER JOIN lkpCenterType prct ON prhtcntr.CenterTypeID = prct.CenterTypeID
			INNER JOIN dbo.lkpHairSystemOrderProcess hsop ON h.HairSystemOrderProcessID = hsop.HairSystemOrderProcessID
			INNER JOIN lkpTimeZone tz ON prhtcntr.TimeZoneID = tz.TimeZoneID  -- Time zone of center doing the shipping
			---
			INNER JOIN datInventoryShipmentDetail isd ON h.InventoryShipmentDetailGUID = isd.InventoryShipmentDetailGUID
			---
			JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID
			---
			LEFT OUTER JOIN datClientMembership cm ON h.ClientMembershipGUID = cm.ClientMembershipGUID
			LEFT OUTER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
		WHERE
				h.HairSystemOrderTransactionGUID NOT IN
							(SELECT abd.HairSystemOrderTransactionGUID FROM datAccountingExportBatchDetail abd
										INNER JOIN datAccountingExportBatch ab
										ON abd.AccountingExportBatchGUID = ab.AccountingExportBatchGUID
										WHERE ab.AccountingExportBatchTypeID = @AccountingExportBatchTypeID)

				AND h.HairSystemOrderTransactionDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
				AND (
						hsop.HairSystemOrderProcessDescriptionShort = @ShipFromCorpHairSystemOrderProcessDescription
						OR hsop.HairSystemOrderProcessDescriptionShort = @ShipFromCenterHairSystemOrderProcessDescription
					)
				AND isd.PriorityHairSystemCenterContractPricingID IS NOT NULL -- A Priority System at time of shipment
		GROUP BY h.HairSystemOrderGUID


		-------------------------------------------
		-- Populate Account Export Batch Detail
		-------------------------------------------
		--Populate detail for Billing
		INSERT INTO	dbo.datAccountingExportBatchDetail (AccountingExportBatchDetailGUID, AccountingExportBatchGUID, HairSystemOrderGUID, HairSystemOrderTransactionGUID, CreateDate, CreateUser, LastUpdate, LastUpdateUser, InventoryShipmentGUID, CenterID )
		SELECT NEWID(), @AccountingExportBatchGUID, h.HairSystemOrderGUID, h.HairSystemOrderTransactionGUID, GETUTCDATE(), @User, GETUTCDATE(), @User, isd.InventoryShipmentGUID, h.CenterID
		FROM dbo.datHairSystemOrderTransaction h
			INNER JOIN cfgCenter cntr ON cntr.CenterID = h.CenterID
			INNER JOIN lkpCenterType ct ON cntr.CenterTypeID = ct.CenterTypeID
			INNER JOIN dbo.datInventoryShipmentDetail isd ON h.InventoryShipmentDetailGUID = isd.InventoryShipmentDetailGUID
		WHERE h.HairSystemOrderTransactionGUID IN
						(SELECT TransactionGUID FROM @Transactions)


		--Populate detail for Credit
		INSERT INTO	dbo.datAccountingExportBatchDetail (AccountingExportBatchDetailGUID, AccountingExportBatchGUID, HairSystemOrderGUID, HairSystemOrderTransactionGUID, CreateDate, CreateUser, LastUpdate, LastUpdateUser, InventoryShipmentGUID, CenterID )
		SELECT NEWID(), @AccountingExportBatchGUID, h.HairSystemOrderGUID, h.HairSystemOrderTransactionGUID, GETUTCDATE(), @User, GETUTCDATE(), @User, isd.InventoryShipmentGUID, h.PreviousCenterID
		FROM dbo.datHairSystemOrderTransaction h
			INNER JOIN cfgCenter cntr ON cntr.CenterID = h.PreviousCenterID
			INNER JOIN lkpCenterType ct ON cntr.CenterTypeID = ct.CenterTypeID
			INNER JOIN dbo.datInventoryShipmentDetail isd ON h.InventoryShipmentDetailGUID = isd.InventoryShipmentDetailGUID
		WHERE h.HairSystemOrderTransactionGUID IN
						(SELECT TransactionGUID FROM @Transactions)


		-------------------------------------------
		-- Create temp table to store Center Freight charge
		-------------------------------------------
		DECLARE @CenterFreight TABLE  (
		InventoryShipmentGUID uniqueidentifier NOT NULL,
		CenterId int NOT NULL,
		FreightCharge decimal(9,2) NOT NULL )


		-------------------------------------------
		-- Determine Freight charge for each center
		-------------------------------------------
		-- Build Center Freight Charges
		INSERT INTO @CenterFreight (InventoryShipmentGUID, CenterId, FreightCharge)
		SELECT ebd.InventoryShipmentGUID, h.CenterID, (cntr.AccountingExportFreightPerItemRate * Count(*)) +  cntr.AccountingExportFreightBaseRate
		FROM dbo.datAccountingExportBatchDetail ebd
			INNER JOIN dbo.datHairSystemOrderTransaction h ON ebd.HairSystemOrderTransactionGUID = h.HairSystemOrderTransactionGUID
			INNER JOIN dbo.cfgConfigurationCenter cntr ON cntr.CenterID = h.CenterID
			INNER JOIN dbo.datHairSystemOrder hso ON h.HairSystemOrderGUID = hso.HairSystemOrderGUID
		WHERE ebd.AccountingExportBatchGUID = @AccountingExportBatchGUID
		GROUP BY ebd.InventoryShipmentGUID, h.CenterID, cntr.AccountingExportFreightPerItemRate, cntr.AccountingExportFreightBaseRate


		-------------------------------------------
		-- Update invoice and Invoice Amount and Total Freight Amount on the
		-- header record.
		-------------------------------------------
		-- Update For Billing First ( Positive amounts for "Ship To" Centers)
		UPDATE dbo.datAccountingExportBatch SET
			InvoiceAmount = (SELECT ISNULL(SUM(sd.PriorityTransferFee), 0)
								FROM dbo.datAccountingExportBatchDetail abd
									INNER JOIN dbo.datHairSystemOrderTransaction ht ON abd.HairSystemOrderTransactionGUID = ht.HairSystemOrderTransactionGUID
											AND abd.CenterID = ht.CenterID  -- only check the Ship To center
									INNER JOIN dbo.datHairSystemOrder hso ON ht.HairSystemOrderGUID = hso.HairSystemOrderGUID
									INNER JOIN dbo.datInventoryShipmentDetail sd on ht.InventoryShipmentDetailGUID = sd.InventoryShipmentDetailGUID
								WHERE abd.AccountingExportBatchGUID = @AccountingExportBatchGUID
								)
		WHERE AccountingExportBatchGUID = @AccountingExportBatchGUID


		-- Update For Credit First ( Negative amounts for "Ship From" Centers)
		UPDATE dbo.datAccountingExportBatch SET
			InvoiceAmount = ISNULL(InvoiceAmount, 0) - (SELECT ISNULL(SUM(sd.PriorityTransferFee), 0) -- Since it's a credit, subtract from total
								FROM dbo.datAccountingExportBatchDetail abd
									INNER JOIN dbo.datHairSystemOrderTransaction ht ON abd.HairSystemOrderTransactionGUID = ht.HairSystemOrderTransactionGUID
											AND abd.CenterID = ht.PreviousCenterID -- only check the Ship From center
									INNER JOIN dbo.datHairSystemOrder hso ON ht.HairSystemOrderGUID = hso.HairSystemOrderGUID
									INNER JOIN dbo.datInventoryShipmentDetail sd on ht.InventoryShipmentDetailGUID = sd.InventoryShipmentDetailGUID
								WHERE abd.AccountingExportBatchGUID = @AccountingExportBatchGUID
								)
		WHERE AccountingExportBatchGUID = @AccountingExportBatchGUID


		-------------------------------------------
		-- Update invoice and Freight Amount on the
		-- detail record.
		-------------------------------------------

		-- Update Freight for Billing Detail Records
		UPDATE abd
		 SET
			FreightAmount = (SELECT ISNULL(cf.FreightCharge, 0)
					 FROM @CenterFreight cf WHERE cf.InventoryShipmentGUID = abd.InventoryShipmentGUID)
		FROM dbo.datAccountingExportBatchDetail abd
			INNER JOIN dbo.datHairSystemOrderTransaction ht ON abd.HairSystemOrderTransactionGUID = ht.HairSystemOrderTransactionGUID
											AND abd.CenterID = ht.CenterID  -- only update the Ship To center records
		WHERE abd.AccountingExportBatchGUID = @AccountingExportBatchGUID


		-- Update Freight for Credit Detail Records
		UPDATE abd
		 SET
			FreightAmount = (SELECT (ISNULL(cf.FreightCharge, 0) * -1) -- Credit Freight charge as negative
					 FROM @CenterFreight cf WHERE cf.InventoryShipmentGUID = abd.InventoryShipmentGUID)
		FROM dbo.datAccountingExportBatchDetail abd
			INNER JOIN dbo.datHairSystemOrderTransaction ht ON abd.HairSystemOrderTransactionGUID = ht.HairSystemOrderTransactionGUID
											AND abd.CenterID = ht.PreviousCenterID  -- only update the Ship To center records
		WHERE abd.AccountingExportBatchGUID = @AccountingExportBatchGUID


		-------------------------------------------
		-- Update Total Freight on the Accounting Export Batch Record
		-------------------------------------------

		UPDATE datAccountingExportBatch SET
			FreightAmount = (SELECT ISNULL(SUM(abd.FreightAmount), 0)
								FROM dbo.datAccountingExportBatchDetail abd
								WHERE abd.AccountingExportBatchGUID = @AccountingExportBatchGUID)
		WHERE AccountingExportBatchGUID = @AccountingExportBatchGUID

	END


	-------------------------------------------
	-- Select for Export
	-------------------------------------------
	SELECT r.ShippingMenifest,
		r.BatchGUID,
		r.BatchId,
		r.ShipmentMethod,
		--r.CenterId,
		r.ShippingCenterId,
		r.BillingCenterId,
		r.InvoiceDate,
		r.ShipDate,
		r.ReceiveDate,
		r.Membership,
		r.ClientNumber,
		r.ClientName,
		r.SystemType,
		r.FactoryOrderNumber,
		r.Price,
		r.Quantity,
		r.Freight
	FROM
	(
		SELECT Row_Number() OVER(Order by u.FactoryOrderNumber, u.Price desc) as RowNumber,
			u.ShippingMenifest,
			u.BatchGUID,
			u.BatchId,
			u.ShipmentMethod,
			--u.CenterId,
			u.ShippingCenterId,
			u.BillingCenterId,
			u.InvoiceDate,
			u.ShipDate,
			u.ReceiveDate,
			u.Membership,
			u.ClientNumber,
			u.ClientName,
			u.SystemType,
			u.FactoryOrderNumber,
			u.Price,
			u.Quantity,
			u.Freight
		FROM
		(
			SELECT
				s.ShipmentNumber as ShippingMenifest,
				@AccountingExportBatchGUID AS BatchGUID,
				CONVERT(NVarChar, eb.BatchEndDate, 101) + ' Prod_Inv' as BatchId,
				'OTH' as ShipmentMethod,
				--ebdctr.CenterNumber as CenterId,
				ebdctr.CenterNumber as ShippingCenterId,
				ebdctr.CenterNumber as BillingCenterId,	-- Billing Center same as Shipping Center for "Ship To" transaction
				eb.BatchInvoiceDate as InvoiceDate,
				s.ShipDate AS ShipDate, -- Ship to Center From Corporate date
				cast(null as DATE) AS ReceiveDate,  -- not relevent for Priority
				mem.MembershipDescriptionShort as Membership,
				c.ClientIdentifier as ClientNumber,
				c.ClientFullNameAlt2Calc as ClientName,
				hs.HairSystemDescriptionShort as SystemType,
				hso.HairSystemOrderNumber as FactoryOrderNumber,
				ISNULL(sd.PriorityTransferFee, 0.00) AS Price,
				1 as Quantity,
				ISNULL(ebd.FreightAmount, 0.00) as Freight
			 FROM  dbo.datAccountingExportBatchDetail ebd
				INNER JOIN dbo.cfgCenter ebdctr on ebd.CenterID = ebdctr.CenterID
				INNER JOIN dbo.datAccountingExportBatch eb ON eb.AccountingExportBatchGUID = ebd.AccountingExportBatchGUID
				INNER JOIN dbo.datHairSystemOrderTransaction h ON ebd.HairSystemOrderTransactionGUID = h.HairSystemOrderTransactionGUID
							AND h.CenterID = ebd.CenterId  -- Billing detail records for "Ship To" Center
				INNER JOIN dbo.datHairSystemOrder hso ON h.HairSystemOrderGUID = hso.HairSystemOrderGUID
				INNER JOIN dbo.cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
				INNER JOIN dbo.datInventoryShipmentDetail sd ON h.InventoryShipmentDetailGUID = sd.InventoryShipmentDetailGUID
				INNER JOIN dbo.datInventoryShipment s ON sd.InventoryShipmentGUID = s.InventoryShipmentGUID
				INNER JOIN dbo.datClient c ON h.ClientGUID = c.ClientGUID
				INNER JOIN dbo.datClientMembership cm ON h.ClientMembershipGUID = cm.ClientMembershipGUID
				INNER JOIN dbo.cfgMembership mem ON cm.MembershipID = mem.MembershipID
				INNER JOIN cfgCenter cntr ON cntr.CenterID = @CorpCenter  -- Corporate center
				INNER JOIN lkpTimeZone tz ON cntr.TimeZoneID = tz.TimeZoneID
			WHERE ebd.AccountingExportBatchGUID = @AccountingExportBatchGUID

			UNION

			SELECT
				s.ShipmentNumber as ShippingMenifest,
				@AccountingExportBatchGUID AS BatchGUID,
				CONVERT(NVarChar, eb.BatchEndDate, 101) + ' Prod_Inv' as BatchId,
				'OTH' as ShipmentMethod,
				--ebdctr.CenterNumber as CenterId,
				ebdctr.CenterNumber as ShippingCenterId,
				clthmctr.CenterNumber as BillingCenterId,	-- Billing Center is client's home center at time of transaction for "Ship From" transaction
				eb.BatchInvoiceDate as InvoiceDate,
				s.ShipDate AS ShipDate, -- Ship to Center From Corporate date
				cast(null as DATE) AS ReceiveDate,  -- not relevent for Priority
				mem.MembershipDescriptionShort as Membership,
				c.ClientIdentifier as ClientNumber,
				c.ClientFullNameAlt2Calc as ClientName,
				hs.HairSystemDescriptionShort as SystemType,
				hso.HairSystemOrderNumber as FactoryOrderNumber,
				CASE WHEN sd.PriorityTransferFee IS NULL
					THEN 0.00 ELSE ISNULL((sd.PriorityTransferFee * -1), 0.00) END AS Price,
				1 as Quantity,
				ISNULL(ebd.FreightAmount, 0.00) as Freight
			 FROM  dbo.datAccountingExportBatchDetail ebd
				INNER JOIN dbo.cfgCenter ebdctr on ebd.CenterID = ebdctr.CenterID
				INNER JOIN dbo.datAccountingExportBatch eb ON eb.AccountingExportBatchGUID = ebd.AccountingExportBatchGUID
				INNER JOIN dbo.datHairSystemOrderTransaction h ON ebd.HairSystemOrderTransactionGUID = h.HairSystemOrderTransactionGUID
							AND h.PreviousCenterId = ebd.CenterId  -- Credit detail records for "Ship From" Center
				INNER JOIN dbo.datHairSystemOrder hso ON h.HairSystemOrderGUID = hso.HairSystemOrderGUID
				INNER JOIN dbo.cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
				INNER JOIN dbo.datInventoryShipmentDetail sd ON h.InventoryShipmentDetailGUID = sd.InventoryShipmentDetailGUID
				INNER JOIN dbo.datInventoryShipment s ON sd.InventoryShipmentGUID = s.InventoryShipmentGUID
				INNER JOIN dbo.cfgCenter clthmctr on h.ClientHomeCenterID = clthmctr.CenterID	-- Client Home Center at time of transaction so correct center gets credit
				INNER JOIN dbo.datClient c ON h.ClientGUID = c.ClientGUID
				INNER JOIN dbo.datClientMembership cm ON h.ClientMembershipGUID = cm.ClientMembershipGUID
				INNER JOIN dbo.cfgMembership mem ON cm.MembershipID = mem.MembershipID
				INNER JOIN cfgCenter cntr ON cntr.CenterID = @CorpCenter  -- Corporate center
				INNER JOIN lkpTimeZone tz ON cntr.TimeZoneID = tz.TimeZoneID
			 WHERE ebd.AccountingExportBatchGUID = @AccountingExportBatchGUID

		) u

	) r
	WHERE RowNumber BETWEEN (@SkipCount+1) AND (@SkipCount + @PageSize)


	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION

	 DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

END CATCH

END
GO
