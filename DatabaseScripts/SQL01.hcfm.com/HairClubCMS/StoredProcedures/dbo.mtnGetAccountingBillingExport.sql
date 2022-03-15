/* CreateDate: 12/31/2010 13:21:05.737 , ModifyDate: 05/04/2020 10:40:49.387 */
GO
/*
==============================================================================
PROCEDURE:				mtnGetAccountingBillingExport

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR:

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		10/12/2010

LAST REVISION DATE: 	03/16/2020

==============================================================================
DESCRIPTION:
==============================================================================
NOTES:
		* 10/12/2010 MVT - Created
		* 01/21/2010 MVT - Modified to allow for ability to re-generate by an
							existing Accounting Export Batch GUID. Changed to
							store user on Export Batch parent and detail records.
		* 01/22/2011 MLM - Added Paging To the Stored Procedure
		* 01/25/2011 MLM - Fixed Join Issue
		* 01/25/2011 MVT - Fixed Freight Amount so that it is calculated by
							Shippment instead of Center.
		* 01/26/2011 MVT - Fixed issue with the Receive Date to use Receive from
							Factory date instead of Receive at center date.
		* 03/09/2011 MVT - Updated to set price and freight charge of the repair/redo
							orders that were accepted for credit to 0.
		* 04/14/2011 MVT - Updated to use HairSystemOrderGUID instead of HairSystemOrderTransactionGUID
							to check if the billing has been generated for the order. Modified to only use
							one shipping transaction if more than one exist. Added logic to
							exclude orders for HCFK, MODEL, MODELEXT, EMPLOYEE, and EMPLOYEXT membership
		* 04/14/2011 MVT - Modified to exclude MODEL, MODEL EXT, EMPLOYEE, and EMPLOYEXT memberships
							for Corporate Billing only.
		* 04/18/2011 MVT - Modified to order by a Hair System Order to prevent duplicates/missing orders
							when paging.
		* 06/06/2011 MVT - Modified to charge contract price for Repair orders. Added negative credit amount
							for repair orders.
		* 02/24/2012 MVT - Changed CostCenterWholesale to CenterPrice
		* 06/13/2012 MVT - Modified to exclude Priority Hair Systems from the Billing File and to track CenterID
							on AccountingExportBatchDetail record.
		* 11/10/2015 SAL - Modified to exclude Xtrands Employee and Model memberships from being billed to Corporate Centers.
		* 09/17/2017 SAL - Updated to join union selects to datHairSystemOrderTransaction.CenterID to cfgCenter and
								Updated to return cfgCenter.CenterNumber As CenterID.
		* 04/25/2018 SAL - Modified to include AutoPriorityCorp transactions so that centers get charged for hair that is
								received from the factory at corporate, automatically put into PRIORITY status, and kept
								at Corporate.  Also, updated to join union selects to datAccountingExportBatchDetail.CenterID
								to cfgCenter so that the correct centernumber is returned (TFS #10625).
		* 06/18/2018 SAL - Modified to allow executing for Hans Wiemann Type/CenterType (TFS #10928).
		* 02/19/2019 JLM - Modified to add columns for add-on pricing. (TFS #11976)
		* 04/23/2019 JLM - Modified to have negative add-on pricing when credit. (TFS #12352)
		* 06/12/2019 JLM - Modified to omit negative credit line items when running for Franchise. (TFS #12623)
		* 03/16/2020 JLM - Update center add-on pricing to use cuticle intact hair and root shadowing add-on. (TFS 14025 & 14067)

==============================================================================
SAMPLE EXECUTION:
==============================================================================
*/

CREATE PROCEDURE [dbo].[mtnGetAccountingBillingExport]
	@BeginDate datetime,
	@EndDate datetime,
	@Type nvarchar(25),
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
	DECLARE @CorpBatchTypeConst as nvarchar(15)  = 'HSCorpBill'
	DECLARE @FranchiseBatchTypeConst as nvarchar(15) = 'HSFranBill'
	DECLARE @HansWiemannBatchTypeConst as nvarchar(15) = 'HSHwBill'
	DECLARE @HairSystemOrderProcessDescription as nvarchar(15) = 'SHIPFCORP'
	DECLARE @HairSystemOrderProcessDescription_AutoPriorityCorp as nvarchar(15) = 'AUTOPRCORP'
	DECLARE @CorpCenter as integer = 100
	DECLARE @CorpCenterType as char = 'C'
	DECLARE @FranchiseCenterType as char = 'F'
	DECLARE @JointCenterType as nvarchar(2) = 'JV'
	DECLARE @HansWiemannCenterType as nvarchar(2) = 'HW'
	DECLARE @CorpType as nvarchar(20) = 'Corporate'
	DECLARE @FranchiseType as nvarchar(20) = 'Franchise'
	DECLARE @HansWiemannType as nvarchar(20) = 'HansWiemann'
	DECLARE @ReceiveFromFactoryShipmentType as nvarchar(20) = 'HSVen2Corp'
	DECLARE @HairClubForKidsMembershipShortDesc as nvarchar(10) = 'HCFK'
	DECLARE @EmployeeMembershipShortDesc as nvarchar(10) = 'EMPLOYEE'
	DECLARE @EmployeeExtMembershipShortDesc as nvarchar(10) = 'EMPLOYEXT'
	DECLARE @EmployeeXtrandsMembershipShortDesc as nvarchar(10) = 'EMPLOYXTR'
	DECLARE @ModelMembershipShortDesc as nvarchar(10) = 'MODEL'
	DECLARE @ModelExtMembershipShortDesc as nvarchar(10) = 'MODELEXT'
	DECLARE @ModelXtrandsMembershipShortDesc as nvarchar(10) = 'MODELXTR'

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
	-- SET Receive From Factory Shipment ID
	-------------------------------------------
	SET @ReceiveFromFactoryShipmentTypeID = (SELECT st.InventoryShipmentTypeID FROM lkpInventoryShipmentType st
													WHERE st.InventoryShipmentTypeDescriptionShort = @ReceiveFromFactoryShipmentType)


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
		-- SET Batch Type ID and Center Type
		-------------------------------------------
		IF @Type = @CorpType
			SET @AccountingExportBatchTypeID = (SELECT l.AccountingExportBatchTypeID FROM dbo.lkpAccountingExportBatchType l WHERE  l.AccountingExportBatchTypeDescriptionShort = @CorpBatchTypeConst)
		ELSE IF @Type = @FranchiseType
			SET @AccountingExportBatchTypeID = (SELECT l.AccountingExportBatchTypeID FROM dbo.lkpAccountingExportBatchType l WHERE  l.AccountingExportBatchTypeDescriptionShort = @FranchiseBatchTypeConst)
		ELSE IF @Type = @HansWiemannType
			SET @AccountingExportBatchTypeID = (SELECT l.AccountingExportBatchTypeID FROM dbo.lkpAccountingExportBatchType l WHERE  l.AccountingExportBatchTypeDescriptionShort = @HansWiemannBatchTypeConst)
		ELSE
			SET @AccountingExportBatchTypeID = (SELECT l.AccountingExportBatchTypeID FROM dbo.lkpAccountingExportBatchType l WHERE  l.AccountingExportBatchTypeDescriptionShort = @CorpBatchTypeConst)

		--IF @Type = @CorpType
		--	SET @AccountingExportBatchTypeID = (SELECT l.AccountingExportBatchTypeID FROM dbo.lkpAccountingExportBatchType l WHERE  l.AccountingExportBatchTypeDescriptionShort = @CorpBatchTypeConst)
		--ELSE
		--	SET @AccountingExportBatchTypeID = (SELECT l.AccountingExportBatchTypeID FROM dbo.lkpAccountingExportBatchType l WHERE  l.AccountingExportBatchTypeDescriptionShort = @FranchiseBatchTypeConst)

		INSERT INTO dbo.datAccountingExportBatch (AccountingExportBatchGUID, AccountingExportBatchTypeID, AccountingExportBatchNumber, BatchRunDate, BatchBeginDate, BatchEndDate, BatchInvoiceDate, ExportFileName, CreateDate, CreateUser, LastUpdate, LastUpdateUser) VALUES
			(@AccountingExportBatchGUID, @AccountingExportBatchTypeID, @AccountingBatchNumber, GETUTCDATE(), @BeginDate, @EndDate, @InvoiceDate, @ExportFileName, GETUTCDATE(), @User, GETUTCDATE(), @User)

		-------------------------------------------
		-- Select Distinct transactions by Hair System Order
		-------------------------------------------
		--	Ship From Corp Transactions
		DECLARE @Transactions TABLE	(
				TransactionGUID uniqueidentifier,
				PRIMARY KEY ( TransactionGUID )
		)

		INSERT INTO @Transactions(TransactionGUID)
		SELECT MAX(convert(nvarchar(40),h.HairSystemOrderTransactionGUID))
		FROM datHairSystemOrderTransaction h
			INNER JOIN datHairSystemOrder hso ON hso.HairSystemOrderGUID = h.HairSystemOrderGUID
			INNER JOIN cfgCenter cntr ON cntr.CenterID = @CorpCenter  -- Corporate center
			INNER JOIN lkpTimeZone tz ON cntr.TimeZoneID = tz.TimeZoneID
			INNER JOIN cfgCenter htcntr ON htcntr.CenterID = h.CenterID
			INNER JOIN lkpCenterType ct ON htcntr.CenterTypeID = ct.CenterTypeID
			INNER JOIN dbo.lkpHairSystemOrderProcess hsop ON h.HairSystemOrderProcessID = hsop.HairSystemOrderProcessID
			---
			INNER JOIN datInventoryShipmentDetail isd ON h.InventoryShipmentDetailGUID = isd.InventoryShipmentDetailGUID
			---
			JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID
			---
			LEFT OUTER JOIN datClientMembership cm ON h.ClientMembershipGUID = cm.ClientMembershipGUID
			LEFT OUTER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
		WHERE  h.HairSystemOrderGUID NOT IN
							(SELECT abd.HairSystemOrderGUID FROM datAccountingExportBatchDetail abd
										INNER JOIN datAccountingExportBatch ab
										ON abd.AccountingExportBatchGUID = ab.AccountingExportBatchGUID
										WHERE ab.AccountingExportBatchTypeID = @AccountingExportBatchTypeID)
				AND h.HairSystemOrderTransactionDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
				AND hsop.HairSystemOrderProcessDescriptionShort = @HairSystemOrderProcessDescription
				AND (
						(@Type = @CorpType AND ct.CenterTypeDescriptionShort = @CorpCenterType)
						OR (@Type = @HansWiemannType AND ct.CenterTypeDescriptionShort = @HansWiemannCenterType)
						OR (@Type = @FranchiseType
								AND (ct.CenterTypeDescriptionShort = @FranchiseCenterType
										OR ct.CenterTypeDescriptionShort = @JointCenterType))
					)
				AND m.MembershipDescriptionShort <> @HairClubForKidsMembershipShortDesc
				AND (@Type = @FranchiseType OR @Type = @HansWiemannType OR
						(
							@Type = @CorpType
							AND m.MembershipDescriptionShort <> @EmployeeMembershipShortDesc
							AND m.MembershipDescriptionShort <> @EmployeeExtMembershipShortDesc
							AND m.MembershipDescriptionShort <> @EmployeeXtrandsMembershipShortDesc
							AND m.MembershipDescriptionShort <> @ModelMembershipShortDesc
							AND m.MembershipDescriptionShort <> @ModelExtMembershipShortDesc
							AND m.MembershipDescriptionShort <> @ModelXtrandsMembershipShortDesc
						)
					)
				AND isd.PriorityHairSystemCenterContractPricingID IS NULL -- NOT a Priority System at the time of Shipment
		GROUP BY h.HairSystemOrderGUID

		--	Auto Priority At Corp Transactions
		DECLARE @Transactions_AutoPriorityCorp TABLE	(
				TransactionGUID uniqueidentifier,
				PRIMARY KEY ( TransactionGUID )
		)

		INSERT INTO @Transactions_AutoPriorityCorp(TransactionGUID)
		SELECT MAX(convert(nvarchar(40),h.HairSystemOrderTransactionGUID))
		FROM datHairSystemOrderTransaction h
			INNER JOIN datHairSystemOrder hso ON hso.HairSystemOrderGUID = h.HairSystemOrderGUID
			INNER JOIN cfgCenter cntr ON cntr.CenterID = @CorpCenter  -- Corporate center
			INNER JOIN lkpTimeZone tz ON cntr.TimeZoneID = tz.TimeZoneID
			INNER JOIN cfgCenter htcntr ON htcntr.CenterID = h.CenterID
			INNER JOIN lkpCenterType ct ON htcntr.CenterTypeID = ct.CenterTypeID
			INNER JOIN dbo.lkpHairSystemOrderProcess hsop ON h.HairSystemOrderProcessID = hsop.HairSystemOrderProcessID
			---
			JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID
			---
			LEFT OUTER JOIN datClientMembership cm ON h.ClientMembershipGUID = cm.ClientMembershipGUID
			LEFT OUTER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
		WHERE  h.HairSystemOrderGUID NOT IN
							(SELECT abd.HairSystemOrderGUID FROM datAccountingExportBatchDetail abd
										INNER JOIN datAccountingExportBatch ab
										ON abd.AccountingExportBatchGUID = ab.AccountingExportBatchGUID
										WHERE ab.AccountingExportBatchTypeID = @AccountingExportBatchTypeID)
				AND h.HairSystemOrderTransactionDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
				AND hsop.HairSystemOrderProcessDescriptionShort = @HairSystemOrderProcessDescription_AutoPriorityCorp
				AND (
						(@Type = @CorpType AND ct.CenterTypeDescriptionShort = @CorpCenterType)
						OR (@Type = @HansWiemannType AND ct.CenterTypeDescriptionShort = @HansWiemannCenterType)
						OR (@Type = @FranchiseType
								AND (ct.CenterTypeDescriptionShort = @FranchiseCenterType
										OR ct.CenterTypeDescriptionShort = @JointCenterType))
					)
				AND m.MembershipDescriptionShort <> @HairClubForKidsMembershipShortDesc
				AND (@Type = @FranchiseType OR @Type = @HansWiemannType OR
						(
							@Type = @CorpType
							AND m.MembershipDescriptionShort <> @EmployeeMembershipShortDesc
							AND m.MembershipDescriptionShort <> @EmployeeExtMembershipShortDesc
							AND m.MembershipDescriptionShort <> @EmployeeXtrandsMembershipShortDesc
							AND m.MembershipDescriptionShort <> @ModelMembershipShortDesc
							AND m.MembershipDescriptionShort <> @ModelExtMembershipShortDesc
							AND m.MembershipDescriptionShort <> @ModelXtrandsMembershipShortDesc
						)
					)
		GROUP BY h.HairSystemOrderGUID

		-------------------------------------------
		-- Populate Account Export Batch Detail
		-------------------------------------------
		--Ship From Corp Transactions (bill CenterID)
		INSERT INTO	dbo.datAccountingExportBatchDetail (AccountingExportBatchDetailGUID, AccountingExportBatchGUID, HairSystemOrderGUID, HairSystemOrderTransactionGUID, CreateDate, CreateUser, LastUpdate, LastUpdateUser, InventoryShipmentGUID, CenterID )
		SELECT NEWID(), @AccountingExportBatchGUID, h.HairSystemOrderGUID, h.HairSystemOrderTransactionGUID, GETUTCDATE(), @User, GETUTCDATE(), @User, isd.InventoryShipmentGUID, h.CenterID
		FROM dbo.datHairSystemOrderTransaction h
			INNER JOIN dbo.datInventoryShipmentDetail isd ON h.InventoryShipmentDetailGUID = isd.InventoryShipmentDetailGUID
		WHERE h.HairSystemOrderTransactionGUID IN
						(SELECT TransactionGUID FROM @Transactions)

		--Auto Priority At Corp Transactions (bill ClientHomeCenterID)
		INSERT INTO	dbo.datAccountingExportBatchDetail (AccountingExportBatchDetailGUID, AccountingExportBatchGUID, HairSystemOrderGUID, HairSystemOrderTransactionGUID, CreateDate, CreateUser, LastUpdate, LastUpdateUser, InventoryShipmentGUID, CenterID )
		SELECT NEWID(), @AccountingExportBatchGUID, h.HairSystemOrderGUID, h.HairSystemOrderTransactionGUID, GETUTCDATE(), @User, GETUTCDATE(), @User, NULL, h.ClientHomeCenterID
		FROM dbo.datHairSystemOrderTransaction h
		WHERE h.HairSystemOrderTransactionGUID IN
						(SELECT TransactionGUID FROM @Transactions_AutoPriorityCorp)

		-------------------------------------------
		-- Create temp table to store Center Freight charge
		-------------------------------------------
		DECLARE @CenterFreight TABLE  (
		InventoryShipmentGUID uniqueidentifier NULL,
		CenterId int NOT NULL,
		FreightCharge decimal(9,2) NULL )


		-------------------------------------------
		-- Determine Freight charge for each center
		-------------------------------------------
		INSERT INTO @CenterFreight (InventoryShipmentGUID, CenterId, FreightCharge)
		SELECT ebd.InventoryShipmentGUID, h.CenterID, (cntr.AccountingExportFreightPerItemRate * Count(*)) +  cntr.AccountingExportFreightBaseRate
		FROM dbo.datAccountingExportBatchDetail ebd
			INNER JOIN dbo.datHairSystemOrderTransaction h ON ebd.HairSystemOrderTransactionGUID = h.HairSystemOrderTransactionGUID
			INNER JOIN dbo.cfgConfigurationCenter cntr ON cntr.CenterID = h.CenterID
			INNER JOIN dbo.datHairSystemOrder hso ON h.HairSystemOrderGUID = hso.HairSystemOrderGUID
			LEFT OUTER JOIN dbo.datHairSystemOrder origHso ON hso.OriginalHairSystemOrderGUID = origHso.HairSystemOrderGUID
		WHERE ebd.AccountingExportBatchGUID = @AccountingExportBatchGUID
			--AND (ISNULL(hso.IsRepairOrderFlag, 0) = 0 OR hso.RequestForCreditAcceptedDate is null)  -- exclude repair orders that were accepted for credit
			--AND	(ISNULL(hso.IsRedoOrderFlag, 0) = 0 OR  origHso.RequestForCreditAcceptedDate is null)  -- exclude redo orders if original order was accepted for credit
		GROUP BY ebd.InventoryShipmentGUID, h.CenterID, cntr.AccountingExportFreightPerItemRate, cntr.AccountingExportFreightBaseRate


		-------------------------------------------
		-- Update invoice and Invoice Amount and Total Freight Amount on the
		-- header record.
		-------------------------------------------
		UPDATE dbo.datAccountingExportBatch SET
			InvoiceAmount = (SELECT ISNULL(SUM(ht.CenterPrice), 0)
								FROM dbo.datAccountingExportBatchDetail abd
									INNER JOIN dbo.datHairSystemOrderTransaction ht ON abd.HairSystemOrderTransactionGUID = ht.HairSystemOrderTransactionGUID
									INNER JOIN dbo.datHairSystemOrder hso ON ht.HairSystemOrderGUID = hso.HairSystemOrderGUID
									LEFT OUTER JOIN dbo.datHairSystemOrder origHso ON hso.OriginalHairSystemOrderGUID = origHso.HairSystemOrderGUID
								WHERE abd.AccountingExportBatchGUID = @AccountingExportBatchGUID
									--AND (ISNULL(hso.IsRepairOrderFlag, 0) = 0 OR hso.RequestForCreditAcceptedDate is null)  -- exclude repair orders that were accepted for credit
									--AND	(ISNULL(hso.IsRedoOrderFlag, 0) = 0 OR  origHso.RequestForCreditAcceptedDate is null)  -- exclude redo orders if original order was accepted for credit
								),
			FreightAmount = (SELECT ISNULL(SUM(cf.FreightCharge), 0)
								FROM @CenterFreight cf)
		WHERE AccountingExportBatchGUID = @AccountingExportBatchGUID


		-------------------------------------------
		-- Update invoice and Freight Amount on the
		-- detail record.
		-------------------------------------------
		UPDATE dbo.datAccountingExportBatchDetail
		 SET
			FreightAmount = (SELECT ISNULL(cf.FreightCharge, 0) FROM @CenterFreight cf WHERE cf.InventoryShipmentGUID = datAccountingExportBatchDetail.InventoryShipmentGUID)
		WHERE AccountingExportBatchGUID = @AccountingExportBatchGUID

	END


	-------------------------------------------
	-- Select for Export
	-------------------------------------------
	SELECT r.ShippingMenifest,
		r.BatchGUID,
		r.BatchId,
		r.ShipmentMethod,
		r.CenterId,
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
		r.Freight,
		r.AddOnSignature,
		r.AddOnExtendedLace,
		r.AddOnOmbre,
		r.AddOnLongHair,
		r.TotalPrice,
		r.AddOnCuticleIntactHair,
		r.AddOnRootShadowing
	FROM
	(
		SELECT Row_Number() OVER(Order by u.FactoryOrderNumber, u.Price desc) as RowNumber,
			u.ShippingMenifest,
			u.BatchGUID,
			u.BatchId,
			u.ShipmentMethod,
			u.CenterId,
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
			u.Freight,
			u.AddOnSignature,
			u.AddOnExtendedLace,
			u.AddOnOmbre,
			u.AddOnLongHair,
			u.Price + u.AddOnSignature + u.AddOnExtendedLace + u.AddOnOmbre + u.AddOnCuticleIntactHair + u.AddOnRootShadowing as TotalPrice,
			u.AddOnCuticleIntactHair,
			u.AddOnRootShadowing
		FROM
		(
			SELECT
				CASE WHEN s.ShipDate IS NULL THEN 0
					ELSE s.ShipmentNumber END as ShippingMenifest,
				@AccountingExportBatchGUID AS BatchGUID,
				CONVERT(NVarChar, eb.BatchEndDate, 101) + ' Prod_Inv' as BatchId,
				CASE WHEN s.ShipDate IS NULL THEN NULL
					ELSE 'OTH' END as ShipmentMethod,
				ebdctr.CenterNumber as CenterId,
				eb.BatchInvoiceDate as InvoiceDate,
				s.ShipDate AS ShipDate, -- Ship to Center From Corporate date
				(SELECT sff.ReceiveDate
					FROM dbo.datInventoryShipmentDetail sdff  -- Assumed that the HSO is sent to the factory once and received from factory once
						INNER JOIN dbo.datInventoryShipment sff
							ON sdff.InventoryShipmentGUID = sff.InventoryShipmentGUID    -- join to get received from factory date
					WHERE sdff.HairSystemOrderGUID = h.HairSystemOrderGUID
							AND sff.InventoryShipmentTypeID = @ReceiveFromFactoryShipmentTypeID) as ReceiveDate, -- Receive from Factory date
				mem.MembershipDescriptionShort as Membership,
				c.ClientIdentifier as ClientNumber,
				c.ClientFullNameAlt2Calc as ClientName,
				hs.HairSystemDescriptionShort as SystemType,
				hso.HairSystemOrderNumber as FactoryOrderNumber,
				CASE WHEN ISNULL(hso.IsRepairOrderFlag, 0) = 1  -- If Repair, use repair contract price to bill the center.  If not found, default to $64.
					THEN ISNULL(p.HairSystemPrice, 64.0) ELSE p.HairSystemPrice END as Price,
				1 as Quantity,
				CASE WHEN ebd.FreightAmount IS NULL THEN 0
					ELSE ebd.FreightAmount END as Freight,
				CASE WHEN hso.IsSignatureHairlineAddOn = 1 THEN p.AddOnSignatureHairlinePrice
					 ELSE 0 END as AddOnSignature,
				CASE WHEN hso.IsExtendedLaceAddOn = 1 THEN p.AddOnExtendedLacePrice
					 ELSE 0 END as AddOnExtendedLace,
				CASE WHEN hso.IsOmbreAddOn = 1 THEN p.AddOnOmbrePrice
					 ELSE 0 END as AddOnOmbre,
				CASE WHEN hso.IsLongHairAddOn = 1 THEN 'Yes'
					 ELSE 'No' END as AddOnLongHair,
				CASE WHEN hso.IsCuticleIntactHairAddOn = 1 THEN p.AddOnCuticleIntactHairPrice
					 ELSE 0 END AS AddOnCuticleIntactHair,
				CASE WHEN hso.IsRootShadowingAddOn = 1 THEN p.AddOnRootShadowingPrice
					 ELSE 0 END AS AddOnRootShadowing
			 FROM  dbo.datAccountingExportBatchDetail ebd
				INNER JOIN dbo.datAccountingExportBatch eb ON eb.AccountingExportBatchGUID = ebd.AccountingExportBatchGUID
				INNER JOIN dbo.datHairSystemOrderTransaction h ON ebd.HairSystemOrderTransactionGUID = h.HairSystemOrderTransactionGUID
				INNER JOIN dbo.cfgCenter ebdctr on ebd.CenterID = ebdctr.CenterID
				INNER JOIN dbo.datHairSystemOrder hso ON h.HairSystemOrderGUID = hso.HairSystemOrderGUID
				INNER JOIN dbo.cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
				LEFT OUTER JOIN dbo.datInventoryShipmentDetail sd ON h.InventoryShipmentDetailGUID = sd.InventoryShipmentDetailGUID --AutoPriority Orders on not on a shipment
				LEFT OUTER JOIN dbo.datInventoryShipment s ON sd.InventoryShipmentGUID = s.InventoryShipmentGUID
				INNER JOIN dbo.datClient c ON h.ClientGUID = c.ClientGUID
				INNER JOIN dbo.datClientMembership cm ON h.ClientMembershipGUID = cm.ClientMembershipGUID
				INNER JOIN dbo.cfgMembership mem ON cm.MembershipID = mem.MembershipID
				INNER JOIN cfgCenter cntr ON cntr.CenterID = @CorpCenter  -- Corporate center
				INNER JOIN lkpTimeZone tz ON cntr.TimeZoneID = tz.TimeZoneID
				LEFT OUTER JOIN dbo.cfgHairSystemCenterContractPricing p on p.HairSystemCenterContractPricingID = hso.HairSystemCenterContractPricingID

			WHERE ebd.AccountingExportBatchGUID = @AccountingExportBatchGUID

			UNION

			-- Select Credit Records for Repair orders that have been approved for Credit.
			SELECT
				CASE WHEN s.ShipDate IS NULL THEN 0
					ELSE s.ShipmentNumber END as ShippingMenifest,
				@AccountingExportBatchGUID AS BatchGUID,
				CONVERT(NVarChar, eb.BatchEndDate, 101) + ' Prod_Inv' as BatchId,
				CASE WHEN s.ShipDate IS NULL THEN NULL
					ELSE 'OTH' END as ShipmentMethod,
				ebdctr.CenterNumber as CenterId,
				eb.BatchInvoiceDate as InvoiceDate,
				s.ShipDate AS ShipDate, -- Ship to Center From Corporate date
				(SELECT sff.ReceiveDate
					FROM dbo.datInventoryShipmentDetail sdff  -- Assumed that the HSO is sent to the factory once and received from factory once
						INNER JOIN dbo.datInventoryShipment sff
							ON sdff.InventoryShipmentGUID = sff.InventoryShipmentGUID    -- join to get received from factory date
					WHERE sdff.HairSystemOrderGUID = h.HairSystemOrderGUID
							AND sff.InventoryShipmentTypeID = @ReceiveFromFactoryShipmentTypeID) as ReceiveDate, -- Receive from Factory date
				mem.MembershipDescriptionShort as Membership,
				c.ClientIdentifier as ClientNumber,
				c.ClientFullNameAlt2Calc as ClientName,
				hs.HairSystemDescriptionShort as SystemType,
				hso.HairSystemOrderNumber as FactoryOrderNumber,
				-1 * ISNULL(p.HairSystemPrice, 64.0) as Price, -- Credit
				1 as Quantity,
				0.0 as Freight, --no freight charge since it's credit
				CASE WHEN hso.IsSignatureHairlineAddOn = 1 THEN -1 * p.AddOnSignatureHairlinePrice
					 ELSE 0 END as AddOnSignature,
				CASE WHEN hso.IsExtendedLaceAddOn = 1 THEN -1 * p.AddOnExtendedLacePrice
					 ELSE 0 END as AddOnExtendedLace,
				CASE WHEN hso.IsOmbreAddOn = 1 THEN -1 * p.AddOnOmbrePrice
					 ELSE 0 END as AddOnOmbre,
				CASE WHEN hso.IsLongHairAddOn = 1 THEN 'Yes'
					 ELSE 'No' END as AddOnLongHair,
				CASE WHEN hso.IsCuticleIntactHairAddOn = 1 THEN p.AddOnCuticleIntactHairPrice
					 ELSE 0 END AS AddOnCuticleIntactHair,
				CASE WHEN hso.IsRootShadowingAddOn = 1 THEN p.AddOnRootShadowingPrice
					 ELSE 0 END AS AddOnRootShadowing
			 FROM  dbo.datAccountingExportBatchDetail ebd
				INNER JOIN dbo.datAccountingExportBatch eb ON eb.AccountingExportBatchGUID = ebd.AccountingExportBatchGUID
				INNER JOIN dbo.lkpAccountingExportBatchType ebt on eb.AccountingExportBatchTypeID = ebt.AccountingExportBatchTypeID
				INNER JOIN dbo.datHairSystemOrderTransaction h ON ebd.HairSystemOrderTransactionGUID = h.HairSystemOrderTransactionGUID
				INNER JOIN dbo.cfgCenter ebdctr on ebd.CenterID = ebdctr.CenterID
				INNER JOIN dbo.datHairSystemOrder hso ON h.HairSystemOrderGUID = hso.HairSystemOrderGUID
				INNER JOIN dbo.cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
				LEFT JOIN dbo.datInventoryShipmentDetail sd ON h.InventoryShipmentDetailGUID = sd.InventoryShipmentDetailGUID --AutoPriority Orders on not on a shipment
				LEFT JOIN dbo.datInventoryShipment s ON sd.InventoryShipmentGUID = s.InventoryShipmentGUID
				INNER JOIN dbo.datClient c ON h.ClientGUID = c.ClientGUID
				INNER JOIN dbo.datClientMembership cm ON h.ClientMembershipGUID = cm.ClientMembershipGUID
				INNER JOIN dbo.cfgMembership mem ON cm.MembershipID = mem.MembershipID
				INNER JOIN cfgCenter cntr ON cntr.CenterID = @CorpCenter  -- Corporate center
				INNER JOIN lkpTimeZone tz ON cntr.TimeZoneID = tz.TimeZoneID
				LEFT OUTER JOIN cfgHairSystemCenterContractPricing p on p.HairSystemCenterContractPricingID = hso.HairSystemCenterContractPricingID

			WHERE ebd.AccountingExportBatchGUID = @AccountingExportBatchGUID
			and ebt.AccountingExportBatchTypeDescriptionShort <> @FranchiseBatchTypeConst
		) u

	) r
	WHERE RowNumber BETWEEN (@SkipCount+1) AND (@SkipCount + @PageSize)




			-- 	SELECT
			-- 	CASE WHEN s.ShipDate IS NULL THEN 0
			-- 		ELSE s.ShipmentNumber END as ShippingMenifest,
			-- 	NEWID() AS BatchGUID,
			-- 	CONVERT(NVarChar, eb.BatchEndDate, 101) + ' Prod_Inv' as BatchId,
			-- 	CASE WHEN s.ShipDate IS NULL THEN NULL
			-- 		ELSE 'OTH' END as ShipmentMethod,
			-- 	ebdctr.CenterNumber as CenterId,
			-- 	eb.BatchInvoiceDate as InvoiceDate,
			-- 	s.ShipDate AS ShipDate, -- Ship to Center From Corporate date
			-- 	(SELECT sff.ReceiveDate
			-- 		FROM dbo.datInventoryShipmentDetail sdff  -- Assumed that the HSO is sent to the factory once and received from factory once
			-- 			INNER JOIN dbo.datInventoryShipment sff
			-- 				ON sdff.InventoryShipmentGUID = sff.InventoryShipmentGUID    -- join to get received from factory date
			-- 		WHERE sdff.HairSystemOrderGUID = h.HairSystemOrderGUID
			-- 				AND sff.InventoryShipmentTypeID = 0) as ReceiveDate, -- Receive from Factory date
			-- 	mem.MembershipDescriptionShort as Membership,
			-- 	c.ClientIdentifier as ClientNumber,
			-- 	c.ClientFullNameAlt2Calc as ClientName,
			-- 	hs.HairSystemDescriptionShort as SystemType,
			-- 	hso.HairSystemOrderNumber as FactoryOrderNumber,
			-- 	CASE WHEN ISNULL(hso.IsRepairOrderFlag, 0) = 1  -- If Repair, use repair contract price to bill the center.  If not found, default to $64.
			-- 		THEN ISNULL(p.HairSystemPrice, 64.0) ELSE p.HairSystemPrice END as Price,
			-- 	1 as Quantity,
			-- 	CASE WHEN ebd.FreightAmount IS NULL THEN 0
			-- 		ELSE ebd.FreightAmount END as Freight,
			-- 	CASE WHEN hso.IsSignatureHairlineAddOn = 1 THEN p.AddOnSignatureHairlinePrice
			-- 		 ELSE 0 END as AddOnSignature,
			-- 	CASE WHEN hso.IsExtendedLaceAddOn = 1 THEN p.AddOnExtendedLacePrice
			-- 		 ELSE 0 END as AddOnExtendedLace,
			-- 	CASE WHEN hso.IsOmbreAddOn = 1 THEN p.AddOnOmbrePrice
			-- 		 ELSE 0 END as AddOnOmbre,
			-- 	CASE WHEN hso.IsLongHairAddOn = 1 THEN 'Yes'
			-- 		 ELSE 'No' END as AddOnLongHair,
			-- 	CASE WHEN hso.IsCuticleIntactHairAddOn = 1 THEN p.AddOnCuticleIntactHairPrice
			-- 		 ELSE 0 END AS AddOnCuticleIntactHair,
			-- 	CASE WHEN hso.IsRootShadowingAddOn = 1 THEN p.AddOnRootShadowingPrice
			-- 		 ELSE 0 END AS AddOnRootShadowing,
			-- 	CAST(NULL AS MOINEY) AS TotalPrice
			--  FROM  dbo.datAccountingExportBatchDetail ebd
			-- 	INNER JOIN dbo.datAccountingExportBatch eb ON eb.AccountingExportBatchGUID = ebd.AccountingExportBatchGUID
			-- 	INNER JOIN dbo.datHairSystemOrderTransaction h ON ebd.HairSystemOrderTransactionGUID = h.HairSystemOrderTransactionGUID
			-- 	INNER JOIN dbo.cfgCenter ebdctr on ebd.CenterID = ebdctr.CenterID
			-- 	INNER JOIN dbo.datHairSystemOrder hso ON h.HairSystemOrderGUID = hso.HairSystemOrderGUID
			-- 	INNER JOIN dbo.cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
			-- 	LEFT OUTER JOIN dbo.datInventoryShipmentDetail sd ON h.InventoryShipmentDetailGUID = sd.InventoryShipmentDetailGUID --AutoPriority Orders on not on a shipment
			-- 	LEFT OUTER JOIN dbo.datInventoryShipment s ON sd.InventoryShipmentGUID = s.InventoryShipmentGUID
			-- 	INNER JOIN dbo.datClient c ON h.ClientGUID = c.ClientGUID
			-- 	INNER JOIN dbo.datClientMembership cm ON h.ClientMembershipGUID = cm.ClientMembershipGUID
			-- 	INNER JOIN dbo.cfgMembership mem ON cm.MembershipID = mem.MembershipID
			-- 	INNER JOIN cfgCenter cntr ON cntr.CenterID = 0 -- Corporate center
			-- 	INNER JOIN lkpTimeZone tz ON cntr.TimeZoneID = tz.TimeZoneID
			-- 	LEFT OUTER JOIN dbo.cfgHairSystemCenterContractPricing p on p.HairSystemCenterContractPricingID = hso.HairSystemCenterContractPricingID

			-- WHERE ebd.AccountingExportBatchGUID = NEWID()


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
