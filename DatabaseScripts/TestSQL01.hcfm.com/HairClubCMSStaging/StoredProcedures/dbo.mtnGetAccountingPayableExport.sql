/* CreateDate: 12/31/2010 13:21:05.777 , ModifyDate: 02/27/2017 09:49:19.573 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				mtnGetAccountingPayableExport

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		10/12/2010

LAST REVISION DATE: 	10/12/2010

==============================================================================
DESCRIPTION:
==============================================================================
NOTES:
		* 10/12/2010 MVT - Created
		* 12/11/2010 MVT - Debit - change to use clienthomecenterid
		* 01/14/2010 MVT - Updated to use GL Id's from the cfgConfigurationApplication table
							for credit and variance rows.  Modified to include variance rows
							if variance is greater than 0.
		* 01/21/2010 MVT - Modified to allow for ability to re-generate by an
							existing Accounting Export Batch GUID. Changed to
							store user on Export Batch parent and detail records.
		* 01/22/2011 MLM - Added Paging to the Stored Procedure
		* 04/14/2011 MVT - Modified so that the TOTAL column displays the 'PAY' value
							for all rows of the invoice. Modified so that correct GP
							description for the vendors is used.  Modified Invoice number
							to display in all caps.  Modified Batch id to display
							shorter date.
		* 04/15/2011 MVT - Modifed to make Batch Id all caps.
		* 04/18/2011 MVT - Modified to order by a Hair System Order to prevent duplicates/missing orders
							when paging.
		* 06/30/2011 MVT - Modified to accomodate for the shipments from factory that were re-opened during
							the receive process.  This caused another RCVCorp transaction to be generated when
							the received shipment was closed (completed) the second time.  Modified to only use
							the top most RCVCorp transaction with a status change.
		* 07/07/2011 MVT - Modified to also check for RCVCorp transactions with a status change from Order to Cent
		* 04/02/2012 HDu - Updated SP to include Transactions that had previous status of FAC-Ship before they were recieved at the factory to the export file data.

==============================================================================
SAMPLE EXECUTION:
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnGetAccountingPayableExport]
	@ShipmentIds nvarchar(MAX),
	@ExportFileName nvarchar(200),
	@BatchGUID uniqueidentifier,
	@User nvarchar(25),
	@SkipCount int,
	@PageSize int
AS
BEGIN
	SET NOCOUNT ON

	/**********************************************/
	-- CONSTANTS
	/**********************************************/
	DECLARE @ReceivingBatchTypeConst as nvarchar(15) = 'HSCorpRec'
	DECLARE @HairSystemOrderProcessDescription as nvarchar(15) = 'RCVCORP'
	DECLARE @CorpCenter as integer = 100
	DECLARE @DebitDistType as nvarchar(15) = 'PURCH'
	DECLARE @CreditDistType as nvarchar(15) = 'PAY'
	DECLARE @VarianceDistType as nvarchar(15) = 'PURCH'


	DECLARE @TodayDate as nvarchar(10)
	SET @TodayDate = (SELECT LEFT(convert(varchar, getdate(), 100), CHARINDEX(' ', convert(varchar, getdate(), 100),5)-1))

	/**********************************************/
	-- Create a table to store shipments that need
	-- to be exported.
	/**********************************************/
	DECLARE @ExportShipments TABLE	(
		Id uniqueidentifier
	)
	DECLARE @pos int = 0
	DECLARE @currentShipment char(50)

	SET @ShipmentIds = @ShipmentIds + ','

	WHILE CHARINDEX(',',@ShipmentIds) > 0
	BEGIN
		SELECT @pos=CHARINDEX(',',@ShipmentIds)
		SELECT @currentShipment = RTRIM(SUBSTRING(@ShipmentIds,0,@pos))

		INSERT INTO @ExportShipments (Id) VALUES (@currentShipment)
		SELECT @ShipmentIds=SUBSTRING(@ShipmentIds,@pos+1, LEN(@ShipmentIds)-1)
	END

	/**********************************************/
	-- Create an AccountingExportBatch record
	/**********************************************/
	DECLARE @AccountingExportBatchGUID as uniqueidentifier
	DECLARE @AccountingExportBatchTypeID as int
	DECLARE @AccountingBatchNumber as int

	IF @BatchGUID is null
		SET @AccountingExportBatchGUID = newid()
	ELSE
		SET @AccountingExportBatchGUID = @BatchGUID

	/**********************************************/
	-- Get Credit and Variance GL Quickbooks Description
	/**********************************************/
	DECLARE @CreditGLAccount nvarchar(50), @VarianceGLAccount nvarchar(50)

	SET @CreditGLAccount = (Select Top 1 g.QuickBooksDescription From cfgConfigurationApplication c
												Inner Join lkpGeneralLedger g
													On c.AccountingExportReceiveAPCreditGLNumber = g.GeneralLedgerID)
	SET @VarianceGLAccount = (Select Top 1 g.QuickBooksDescription From cfgConfigurationApplication c
												Inner Join lkpGeneralLedger g
													On c.AccountingExportReceiveAPVarianceGLNumber = g.GeneralLedgerID)


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

		DECLARE @HairSystemStatusID_Order int, @HairSystemStatusID_RCVCorp int, @HairSystemStatusID_CENT int, @HairSystemStatusID_FACShip int

		SET @HairSystemStatusID_Order = (SELECT HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'ORDER')
		SET @HairSystemStatusID_RCVCorp = (SELECT HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'HQ-Recv')
		SET @HairSystemStatusID_CENT = (SELECT HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'CENT')
		SET @HairSystemStatusID_FACShip = (SELECT HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'FAC-Ship')
		-------------------------------------------
		-- SET Batch Type ID
		-------------------------------------------
		SET @AccountingExportBatchTypeID = (SELECT l.AccountingExportBatchTypeID FROM dbo.lkpAccountingExportBatchType l WHERE  l.AccountingExportBatchTypeDescriptionShort = @ReceivingBatchTypeConst)

		INSERT INTO dbo.datAccountingExportBatch (AccountingExportBatchGUID, AccountingExportBatchTypeID, AccountingExportBatchNumber, BatchRunDate, BatchBeginDate, BatchEndDate, BatchInvoiceDate, ExportFileName, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
			(@AccountingExportBatchGUID, @AccountingExportBatchTypeID, @AccountingBatchNumber, GETUTCDATE(), NULL, NULL, NULL, @ExportFileName, GETUTCDATE(), @User, GETUTCDATE(), @User)


		INSERT INTO	dbo.datAccountingExportBatchDetail (AccountingExportBatchDetailGUID, AccountingExportBatchGUID, HairSystemOrderGUID, HairSystemOrderTransactionGUID, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
		SELECT NEWID(),
			@AccountingExportBatchGUID,
			h.HairSystemOrderGUID,
			h.HairSystemOrderTransactionGUID,
			GETUTCDATE(), @User, GETUTCDATE(), @User
		FROM dbo.datHairSystemOrderTransaction h
			INNER JOIN dbo.datInventoryShipmentDetail shd ON h.InventoryShipmentDetailGUID = shd.InventoryShipmentDetailGUID
			INNER JOIN @ExportShipments es ON shd.InventoryShipmentGUID = es.Id
			INNER JOIN dbo.lkpHairSystemOrderProcess hsop ON h.HairSystemOrderProcessID = hsop.HairSystemOrderProcessID
		WHERE	h.HairSystemOrderTransactionGUID NOT IN (
					SELECT abd.HairSystemOrderTransactionGUID
					FROM datAccountingExportBatchDetail abd
						INNER JOIN datAccountingExportBatch ab ON abd.AccountingExportBatchGUID = ab.AccountingExportBatchGUID
					WHERE ab.AccountingExportBatchTypeID = @AccountingExportBatchTypeID
				)
				AND hsop.HairSystemOrderProcessDescriptionShort = @HairSystemOrderProcessDescription
				AND h.HairSystemOrderTransactionGUID IN (
					SELECT TOP(1) t.HairSystemOrderTransactionGUID
					FROM datHairSystemOrderTransaction t
						INNER JOIN dbo.lkpHairSystemOrderProcess p ON t.HairSystemOrderProcessID = p.HairSystemOrderProcessID
					WHERE t.HairSystemOrderGUID = h.HairSystemOrderGUID
						AND p.HairSystemOrderProcessDescriptionShort = @HairSystemOrderProcessDescription
						AND (t.PreviousHairSystemOrderStatusID = @HairSystemStatusID_Order OR t.PreviousHairSystemOrderStatusID = @HairSystemStatusID_FACShip)
						AND (t.NewHairSystemOrderStatusID = @HairSystemStatusID_RCVCorp OR t.NewHairSystemOrderStatusID = @HairSystemStatusID_CENT)
						AND t.InventoryShipmentDetailGUID = shd.InventoryShipmentDetailGUID
					order by t.CreateDate desc
					)

	END -- Done generating account detail


	-------------------------------------------
	-- Create table to store results
	-------------------------------------------
	DECLARE @ExportResults TABLE (
		ExportResultsID uniqueidentifier,
		BatchId nvarchar(20),
		InvoiceNumber nvarchar(50),
		ReceiveDate datetime,
		Account nvarchar(50),
		DistType nvarchar(15),
		Amount decimal(9, 2),
		TotalAmount decimal(9,2),
		Vendor nvarchar(200),
		VendorDescription nvarchar(200)
	)

	-------------------------------------------
	-- Select for Export
	-------------------------------------------
	-- Insert Debit results
	INSERT INTO @ExportResults
	SELECT NEWID(),
		UPPER('FACT INV ' + @TodayDate) as BatchId,
		UPPER(sh.InvoiceNumber) as InvoiceNumber,
		sh.ReceiveDate as ReceiveDate,
		gl.QuickBooksDescription as Account,
		@DebitDistType as DistType,
		SUM(h.CostActual) as Amount,
		sh.InvoiceTotal as TotalAmount,
		v.GPVendorID as Vendor,
		v.GPVendorDescription as VendorDescription
	 FROM  dbo.datAccountingExportBatchDetail ebd
		INNER JOIN dbo.datHairSystemOrderTransaction h ON ebd.HairSystemOrderTransactionGUID = h.HairSystemOrderTransactionGUID
		INNER JOIN dbo.datHairSystemOrder hso ON h.HairSystemOrderGUID = hso.HairSystemOrderGUID
		INNER JOIN 	dbo.cfgConfigurationCenter configCntr ON configCntr.CenterID = hso.ClientHomeCenterID
		INNER JOIN dbo.lkpGeneralLedger gl ON configCntr.AccountingExportReceiveAPDebitGLNumber = gl.GeneralLedgerID
		INNER JOIN dbo.datInventoryShipmentDetail shd ON h.InventoryShipmentDetailGUID = shd.InventoryShipmentDetailGUID
		INNER JOIN dbo.datInventoryShipment sh ON shd.InventoryShipmentGUID = sh.InventoryShipmentGUID
		INNER JOIN dbo.cfgVendor v ON sh.ShipFromVendorID = v.VendorID
	WHERE	ebd.AccountingExportBatchGUID = @AccountingExportBatchGUID
	GROUP BY sh.InvoiceNumber, sh.InvoiceTotal, sh.ReceiveDate, gl.QuickBooksDescription, v.GPVendorID, v.GPVendorDescription
	ORDER BY sh.ReceiveDate


	-- Only update if not re-generating existing batch
	IF @BatchGUID is null
	BEGIN
		-------------------------------------------
		-- Update invoice and freight totals on the
		-- header record.
		-------------------------------------------
		UPDATE dbo.datAccountingExportBatch SET
			InvoiceAmount = (SELECT ISNULL(SUM(er.Amount), 0) FROM @ExportResults er),
			FreightAmount = 0
		WHERE AccountingExportBatchGUID = @AccountingExportBatchGUID
	END


	-- Insert Credit results
	INSERT INTO @ExportResults
	SELECT NEWID(),
		UPPER('FACT INV ' + @TodayDate) as BatchId,
		UPPER(sh.InvoiceNumber) as InvoiceNumber,
		sh.ReceiveDate as ReceiveDate,
		@CreditGLAccount as Account,
		@CreditDistType as DistType,
		(sh.InvoiceTotal * -1) as Amount,
		sh.InvoiceTotal as TotalAmount,
		v.GPVendorID as Vendor,
		v.GPVendorDescription as VendorDescription
	 FROM  dbo.datAccountingExportBatchDetail ebd
		INNER JOIN dbo.datHairSystemOrderTransaction h ON ebd.HairSystemOrderTransactionGUID = h.HairSystemOrderTransactionGUID
		INNER JOIN dbo.datInventoryShipmentDetail shd ON h.InventoryShipmentDetailGUID = shd.InventoryShipmentDetailGUID
		INNER JOIN dbo.datInventoryShipment sh ON shd.InventoryShipmentGUID = sh.InventoryShipmentGUID
		INNER JOIN dbo.cfgVendor v ON sh.ShipFromVendorID = v.VendorID
	WHERE	ebd.AccountingExportBatchGUID = @AccountingExportBatchGUID
	GROUP BY sh.InvoiceNumber, sh.ReceiveDate, sh.InvoiceTotal, v.GPVendorID, v.GPVendorDescription
	ORDER BY sh.ReceiveDate


	-- Insert Variance results
	INSERT INTO @ExportResults
	SELECT NEWID(),
		UPPER('FACT INV ' + @TodayDate) as BatchId,
		UPPER(sh.InvoiceNumber) as InvoiceNumber,
		sh.ReceiveDate as ReceiveDate,
		@VarianceGLAccount as Account,
		@VarianceDistType as DistType,
		sh.InvoiceVarianceTotal as Amount,
		sh.InvoiceTotal as TotalAmount,
		v.GPVendorID as Vendor,
		v.GPVendorDescription as VendorDescription
	 FROM  dbo.datAccountingExportBatchDetail ebd
		INNER JOIN dbo.datHairSystemOrderTransaction h ON ebd.HairSystemOrderTransactionGUID = h.HairSystemOrderTransactionGUID
		INNER JOIN dbo.datInventoryShipmentDetail shd ON h.InventoryShipmentDetailGUID = shd.InventoryShipmentDetailGUID
		INNER JOIN dbo.datInventoryShipment sh ON shd.InventoryShipmentGUID = sh.InventoryShipmentGUID
		INNER JOIN dbo.cfgVendor v ON sh.ShipFromVendorID = v.VendorID
	WHERE	ebd.AccountingExportBatchGUID = @AccountingExportBatchGUID
		AND sh.InvoiceVarianceTotal <> 0
	GROUP BY sh.InvoiceNumber, sh.ReceiveDate, sh.InvoiceVarianceTotal, sh.InvoiceTotal, v.GPVendorID, v.GPVendorDescription
	ORDER BY sh.ReceiveDate


	-- SELECT all results
	SELECT r.BatchId,
		@AccountingExportBatchGUID as BatchGUID,
		r.InvoiceNumber,
		r.ReceiveDate,
		r.Account,
		r.DistType,
		r.Amount,
		r.TotalAmount,
		r.Vendor,
		r.VendorDescription
	FROM
	(
		SELECT Row_Number() OVER(Order By e.ReceiveDate, e.InvoiceNumber, e.Account, e.Amount) as RowNumber,
			e.BatchId,
			e.InvoiceNumber,
			e.ReceiveDate,
			e.Account,
			e.DistType,
			e.Amount,
			e.TotalAmount,
			e.Vendor,
			e.VendorDescription
		FROM @ExportResults	e
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
