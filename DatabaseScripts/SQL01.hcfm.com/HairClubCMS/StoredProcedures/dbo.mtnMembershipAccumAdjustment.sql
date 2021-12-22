/***********************************************************************

PROCEDURE:				mtnMembershipAccumAdjustment

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE:
						3/25/2014 - MVT: Modified to always track BioSys Accumulator (even if benefit tracking is not enabled)
						9/27/2013 - MLM: Fixed Issue with WriteOff Order Type
						9/12/2013- MLM: Added WriteOff Order Type
						02/12/2013 - JGE: Add AccumTransaction record creation on A/R Tender being found on salesorder.
						02/11/2013 - JGE: Remove promo logic from money accum section. Change - to + on client record A/R Balance update in money accum section.
						01/14/2013 - JGE: Add ability to skip accum update if all benefits are used.
						12/10/12 -	JGE: Add logic to determine if clientmembership status is canceled, expired, inactive.
										 If any of these conditions are true, do not process quantity accumulators.
						9/04/12 -	JGE: Removed Override promotion. The dollar amount change is reflected on the sales order for
										 an override. Dollar/percent promos are seperate from sales order.
						7/27/12 -	MVT: Modified to handle Membership Promotions.  This proc will need to be modified if
										a new Accumulator is added to handle promo's or if a new type of promo is offered (ie. Grafts promo)
						7/16/12 -	MVT: Modified to handle Initial Quantity Adjustment Type for Total Quantity Accumulators
						8/06/09 -	PRM: Issue 495 - Refund was double adjusting adjusting :) the contract balance
										because of a fix for issue #203 which adjusted the contract balance when refunding payments
										after the surgery, this didn't work for post surgery revenue because that sales code already
										adjusted the contract balance
						7/03/09 -	PRM: Issue 420 - don't reset the contract price when mem payment was refunding during surgery closeout
						6/29/09 -	PRM: Issue 420 - don't reset the date during a refund
						6/16/09 -	PRM: Switch the sign on the AR calculations for Accounting Department
						6/01/09 -	PRM: AR Balance Accum wasn't being updated when tendering to AR, added logic to update this accum
						4/27/09	-	Andrew Schwalbe: Add audit field data (CreateDate, CreateUser, LastUpdate, LastUpdateUser)
									to insert and update statements
						6/04/14 -   MLM: Added IsVoidedFlag check, Accumulators should not be run for orders which have been voided.
						07/11/2014 - SAL:  Allow quantity accumulators to be processed if the clientmembership status is expired.
						05/20/2015 - SAL:  Implement processing accumulators for the FinanceAR tender type - duplicate what we do for the AR tender type
						06/17/2015 - MVT:  Modified the AR updates to exclude Voided Orders (added IsVoidedFlag = 0 check)
						07/08/2015 - SAL:  Added 'SalesOrderType = ICO' check, Accumulators should not be run for Inter Company orders.
						08/19/2015 - SAL:  Modified to select datAppointment.EndDateTimeCalc for DateField1/@DateField1 and changed @DateVal from date to datetime.
										   We were selecting datAppointment.AppointmentDate, but this is just a Date datatype, not a DateTime datatype.
										   So, when the date was getting saved to cfgClientMembershipAccum.AccumDate, it was being saved with a 00:00:00.000 time.
										   Then when it was being brought back out to the UI and converted to local time, if the timezone adjustment dictated adding
										   negative hours, it would make the date the day before! (TFS #5488)
						09/21/2015 - MVT:  Modified to account for the Additional HCSL on the Membership Promotion
						01/09/2016 - SAL:  Modified to account for Write Off of Membership Revenue being reflected in Paid to Date
											 - moved MONEY accumulator adjustment logic outside of IF (@Event <> @EVENT_WRITEOFFORDER) statement
						08/01/2017 - PRM: Added new replacement statuses for Cancel CM Status (up, down, convert, renew)
						05/17/2018 - JGE: Add check for active addon on clientmembershipaccum.
						09/24/2018 - JCL: Add check for 'SALEORDTAX' specifically for LaserPrePay SalesCode (TFS 11369)
                        03/11/2019 - JLM: Update 'Money' accumulator logic to check for ClientMembershipAddOnID. (TFS 12022)
						04/08/2019 - MVT: Updated initial Select for Sales Orders to filter Client Membership Accums by Client Membership Add-On ID if specified
											on the Sales Order Detail ++ Updated Money 'Replace' update to fileter Accums by Client Membership Add-On ID if
											specified on the Sales Order Detail ++ Modified to select ClientMembershipAccumGUID into the cursor and use it for
											insert/updates throughout the proc. (TFS #12240)
						04/10/2019 - MVT: Updated logic as follows:  If ClientMembershipAddOnID is specified on the Sales Order Detail Record, then match the
											Client Membership Accum by that ID.  If ClientMembershipAddOnID is not defined on the Sales Order Detail record,
											check if a Client Membership Accum match exists with a NULL Client Membership Add-On ID, if yes, then update that
											accum, if not, find "First" client Membership accum match with Client Membership Add-On ID defined (should only
											be 1 since we don't allow same benefits to be tracked on by Add-On and Membership). (TFS 12267/12284)
						05/08/2019 - MVT: Updated insert of Accumulator Adjustment records for AR To no longer join to SO Detail.  This is resolve issue where
											multiple Accumulator Adjutment records being created when there is more than 1 Sales Order Detail line.  AR is only
											applicable to Tender (TFS 12432)
                        08/13/2019 - JLM: Update proc to process quantity used accumulators first. Then based on which accumulators where processed, the appropriate
                                          date/last used accumulators can be processed. This is needed for add-ons of existing membership benefits. (TFS 12809)
--------------------------------------------------------------------------------------------------------
NOTES: 	Updates the Member's accumulators.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnMembershipAccumAdjustment 'SALES ORDER', 'E8D1CF62-BCBE-43F5-A733-A9178119F3E1'

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnMembershipAccumAdjustment]
	  @Event nvarchar(25),
	  @RecordGUID uniqueidentifier = NULL
AS
BEGIN
	SET NOCOUNT ON

	-- wrap the entire stored procedure in a transaction
	BEGIN TRANSACTION

	--------------------------------------------------------------------
	-- SECTION 1: Declare constant values used within this stored proc,
	--               also declare any other variables that will be used
	--               within the stored proc
	--------------------------------------------------------------------

	-- Constant declarations
	DECLARE @TENDERTYPE_AR nvarchar(10)
	SET @TENDERTYPE_AR = 'AR'

	DECLARE @TENDERTYPE_FinanceAR nvarchar(10)
	SET @TENDERTYPE_FinanceAR = 'FinanceAR'

	DECLARE @ACCUM_AR nvarchar(10)
	SET @ACCUM_AR = 'ARBal'

	DECLARE @EVENT_SALESORDER nvarchar(25)
	DECLARE @EVENT_REFUNDORDER nvarchar(25)
	DECLARE @EVENT_SCHEDULERORDER nvarchar(25)
	DECLARE @EVENT_SURGERYCLOSEOUT nvarchar(25)
	DECLARE @EVENT_WRITEOFFORDER nvarchar(25)
	SET @EVENT_SALESORDER = 'SALES ORDER'
	SET @EVENT_REFUNDORDER = 'REFUND ORDER'
	SET @EVENT_SCHEDULERORDER = 'SCHEDULER'
	SET @EVENT_SURGERYCLOSEOUT = 'SURGERY ORDER'
	SET @EVENT_WRITEOFFORDER = 'WRITEOFF ORDER'

	DECLARE @PercentPromoType nvarchar(10)
	DECLARE @DollarPromoType nvarchar(10)
	DECLARE @OverridePromoType nvarchar(10)
	SET @PercentPromoType = 'Percent'
	SET @DollarPromoType = 'Dollar'
	SET @OverridePromoType = 'Override'

	DECLARE @BioSysAccumulator nvarchar(10)
	DECLARE @ServAccumulator nvarchar(10)
	DECLARE @SolAccumulator nvarchar(10)
	DECLARE @ProdkitAccumulator nvarchar(10)
	DECLARE @ContBalAccumulator nvarchar(10)
	DECLARE @HCSLAccumulator nvarchar(10)
	SET @BioSysAccumulator = 'BioSys'
	SET @ServAccumulator = 'SERV'
	SET @SolAccumulator = 'SOL'
	SET @ProdkitAccumulator = 'PRODKIT'
	SET @ContBalAccumulator = 'ContBal'
	SET @HCSLAccumulator = 'HCSL'

	DECLARE @MEMORDERTYPE_ACCUMADJUSTID int
	SET @MEMORDERTYPE_ACCUMADJUSTID = 1

	DECLARE @ACCUMDATATYPE_QUANTITYUSED nvarchar(10)
	DECLARE @ACCUMDATATYPE_QUANTITYTOTAL nvarchar(10)
	DECLARE @ACCUMDATATYPE_MONEY nvarchar(10)
	DECLARE @ACCUMDATATYPE_DATE nvarchar(10)
	SET @ACCUMDATATYPE_QUANTITYUSED = 'QTYUSED'
	SET @ACCUMDATATYPE_QUANTITYTOTAL = 'QTYTOTAL'
	SET @ACCUMDATATYPE_MONEY = 'MONEY'
	SET @ACCUMDATATYPE_DATE = 'DATE'

	DECLARE @ACCUMADJTYPE_SALEORDDATE nvarchar(10)
	DECLARE @ACCUMADJTYPE_SALEORDERQTYUSED nvarchar(10)
	DECLARE @ACCUMADJTYPE_SALEORDERQTYTOTAL nvarchar(10)
	DECLARE @ACCUMADJTYPE_SALEORDERPRICE nvarchar(10)
	DECLARE @ACCUMADJTYPE_SALEORDERPRICEEXT nvarchar(10)
	DECLARE @ACCUMADJTYPE_APPTDATE nvarchar(10)
	DECLARE @ACCUMADJTYPE_CURRDATE nvarchar(10)
	DECLARE @ACCUMADJTYPE_INITQTY nvarchar(10)
	DECLARE @ACCUMADJTYPE_SALEORDERPRICETAX nvarchar(10)




	SET @ACCUMADJTYPE_SALEORDERPRICETAX = 'SALEORDTAX'
	SET @ACCUMADJTYPE_SALEORDDATE = 'SALEORDDTE'
	SET @ACCUMADJTYPE_SALEORDERQTYUSED = 'SALEORDQTY'
	SET @ACCUMADJTYPE_SALEORDERQTYTOTAL = 'SALEORDTOT'
	SET @ACCUMADJTYPE_SALEORDERPRICE = 'SALEORDPRC'
	SET @ACCUMADJTYPE_SALEORDERPRICEEXT = 'SALEORDEXT'
	SET @ACCUMADJTYPE_APPTDATE = 'APPTDTE'
	SET @ACCUMADJTYPE_CURRDATE = 'CURRDTE'
	SET @ACCUMADJTYPE_INITQTY = 'INITQTY'

	DECLARE @ACCUMACTTYPE_ADD nvarchar(10)
	DECLARE @ACCUMACTTYPE_REMOVE nvarchar(10)
	DECLARE @ACCUMACTTYPE_REPLACE nvarchar(10)
	SET @ACCUMACTTYPE_ADD = 'ADD'
	SET @ACCUMACTTYPE_REMOVE = 'REMOVE'
	SET @ACCUMACTTYPE_REPLACE = 'REPLACE'

	DECLARE @CLIENTMEMBERSHIPSTATUS_SURGERYPERFORMED nvarchar(10)
	SET @CLIENTMEMBERSHIPSTATUS_SURGERYPERFORMED = 'SP'

	DECLARE @CLIENT_MEM_STATUS_INACTIVE nvarchar(10) = 'I'
	DECLARE @CLIENT_MEM_STATUS_CANCEL nvarchar(10) = 'C'
	DECLARE @CLIENT_MEM_STATUS_EXPIRE nvarchar(10) = 'E'

	DECLARE @CLIENT_MEM_STATUS_CONVERT nvarchar(10) = 'CNV'
	DECLARE @CLIENT_MEM_STATUS_UPGRADE nvarchar(10) = 'UP'
	DECLARE @CLIENT_MEM_STATUS_DOWNGRADE nvarchar(10) = 'DWN'
	DECLARE @CLIENT_MEM_STATUS_RENEW nvarchar(10) = 'REN'


	DECLARE @SALES_ORDER_TYPE_INTERCOMPANY nvarchar(10)
	SET @SALES_ORDER_TYPE_INTERCOMPANY = 'ICO'

	-- Variable declarations for cursor
	DECLARE @Accumulator_Cursor CURSOR
	DECLARE @AppointmentDetailGUID uniqueidentifier
	DECLARE @SalesOrderDetailGUID uniqueidentifier
	DECLARE @ClientMembershipGUID uniqueidentifier
	DECLARE @ClientMembershipAccumGUID uniqueidentifier
    DECLARE @SalesCodeID int
	DECLARE @ClientMembershipAddOnID int
	DECLARE @ClientGUID uniqueidentifier
	DECLARE @AccumulatorID int
	DECLARE @AccumDataType nvarchar(10)
	DECLARE @AccumActionID int
	DECLARE @AccumActionTypeAdd  int
	DECLARE @AccumAction nvarchar(10)
	DECLARE @AccumAdj nvarchar(10)
	DECLARE @DateField1 datetime
	DECLARE @QtyField1 int
	DECLARE @PriceField1 decimal(21,6)


	DECLARE @PriceTaxField1 decimal(21,6)

	DECLARE @PriceExtField1 decimal(21,6)
	DECLARE @AdjAR bit
	DECLARE @AdjPrice bit
	DECLARE @AdjPaid bit
	DECLARE @BenefitsTracked bit
	DECLARE @PromoType nvarchar(10)
	DECLARE @PromoAmount decimal(21,2)
	DECLARE @PromoSystems int
	DECLARE @PromoServices int
	DECLARE @PromoSolutions int
	DECLARE @PromoProductKits int
	DECLARE @PromoHCSL int

	DECLARE @AccumulatorDescriptionShort nvarchar(10)

	-- Variable declartions for other values
	DECLARE @QuantityVal int
	DECLARE @MoneyVal decimal(21,6)
	DECLARE @DateVal datetime

	DECLARE @CMSUser nvarchar(25)
	SET @CMSUser = 'cmsAccumAdj'

	-- Client Membership status bits
	DECLARE @IsQuantityTracked bit
	SET @IsQuantityTracked = 1


    -- Temp Table to track related Accumulators
    DECLARE @UpdatedQuantityUsedAccumulators TABLE
    (
        SalesCodeID INT,
        ClientMembershipAccumulatorGUID UNIQUEIDENTIFIER,
        ClientMembershipAddOnID INT NULL
    )

    --------------------------------------------------------------------
	-- SECTION 2: Get the list of Quantity Used accumulators that need to be updated along with
	--     the required input data, then if any records exist, create
	--     the header MembershipOrder record
	--------------------------------------------------------------------

	IF EXISTS (Select *
	FROM datSalesOrder so
		INNER JOIN datClientMembership cm ON so.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
	WHERE so.SalesOrderGUID = @RecordGUID and (cms.ClientMembershipStatusDescriptionShort IN (@CLIENT_MEM_STATUS_INACTIVE, @CLIENT_MEM_STATUS_CANCEL, @CLIENT_MEM_STATUS_CONVERT, @CLIENT_MEM_STATUS_UPGRADE, @CLIENT_MEM_STATUS_DOWNGRADE, @CLIENT_MEM_STATUS_RENEW)))

	SET @IsQuantityTracked = 0

	-- Sales Order Process
	IF (@Event = @EVENT_SALESORDER OR @Event = @EVENT_REFUNDORDER OR @Event = @EVENT_SURGERYCLOSEOUT OR @Event = @EVENT_WRITEOFFORDER)
	  BEGIN
		SET @Accumulator_Cursor = CURSOR FAST_FORWARD FOR
		SELECT so.ClientMembershipGUID,
			so.ClientGUID,
			sod.SalesOrderDetailGUID,
			NULL AS AppointmentGUID,
			a.AccumulatorID,
			UPPER(adt.AccumulatorDataTypeDescriptionShort) AS AccumDataType,
			aat1.AccumulatorActionTypeID AS AccumActionID,
			UPPER(aat1.AccumulatorActionTypeDescriptionShort) AS AccumAction,
			UPPER(aat2.AccumulatorAdjustmentTypeDescriptionShort) AS AccumAdj,
			so.OrderDate AS DateField1,
			sod.Quantity AS QtyField1,
			sod.Price AS PriceField1,
			sod.ExtendedPriceCalc AS PriceExtField1,
			sod.BenefitTrackingEnabledFlag as BenefitsTracked,
			a.AdjustARBalanceFlag AS AdjAR,
			a.AdjustContractPriceFlag AS AdjPrice,
			a.AdjustContractPaidFlag AS AdjPaid,
			a.AccumulatorDescriptionShort AS AccumulatorDescriptionShort,
			pt.MembershipPromotionTypeDescriptionShort AS PromoType,
			ISNULL(mp.Amount,0) AS PromoAmount,
			ISNULL(mp.AdditionalSystems,0) AS PromoSystems,
			ISNULL(mp.AdditionalServices,0) AS PromoServices,
			ISNULL(mp.AdditionalSolutions,0) AS PromoSolutions,
			ISNULL(mp.AdditionalProductKits,0) AS PromoProductKits,
			ISNULL(mp.AdditionalHCSL,0) AS PromoHCSL,
			sod.PriceTaxCalc AS PriceTaxField1,
			x_cma.ClientMembershipAddOnID,
			x_cma.ClientMembershipAccumGUID,
            sod.SalesCodeID
		FROM datSalesOrder so
			INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
			INNER JOIN cfgAccumulatorJoin aj ON sod.SalesCodeID = aj.SalesCodeID
			INNER JOIN cfgAccumulator a ON aj.AccumulatorID = a.AccumulatorID
            INNER JOIN lkpAccumulatorDataType adt ON aj.AccumulatorDataTypeID = adt.AccumulatorDataTypeID

			CROSS APPLY (
				SELECT TOP(1) cma.*
				FROM datClientMembershipAccum cma
					LEFT JOIN datClientMembershipAddOn cmao on cmao.ClientMembershipAddOnID = cma.ClientMembershipAddOnID
					LEFT JOIN lkpClientMembershipAddOnStatus ast ON ast.ClientMembershipAddOnStatusID = cmao.ClientMembershipAddOnStatusID
				WHERE cma.ClientMembershipGUID = so.ClientMembershipGUID
					AND cma.AccumulatorID = a.AccumulatorID
					AND (cmao.ClientMembershipAddOnID IS NULL OR ast.ClientMembershipAddOnStatusDescriptionShort = 'Active')  -- Only deal with benefits for Active Add-On's
					AND ((sod.ClientMembershipAddOnID IS NOT NULL AND sod.ClientMembershipAddOnID = cma.ClientMembershipAddOnID)
						OR (sod.ClientMembershipAddOnID IS NULL))
                    AND adt.AccumulatorDataTypeDescriptionShort = @ACCUMDATATYPE_QUANTITYUSED
                    AND cma.AccumQuantityRemainingCalc > 0
				ORDER BY cma.ClientMembershipAddOnID

			) x_cma


			INNER JOIN lkpAccumulatorActionType aat1 ON aj.AccumulatorActionTypeID = aat1.AccumulatorActionTypeID
			INNER JOIN lkpAccumulatorAdjustmentType aat2 ON aj.AccumulatorAdjustmentTypeID = aat2.AccumulatorAdjustmentTypeID
			INNER JOIN lkpSalesOrderType sotype ON so.SalesOrderTypeID = sotype.SalesOrderTypeID
			LEFT JOIN cfgMembershipPromotion mp ON mp.MembershipPromotionID = sod.MembershipPromotionID
			LEFT JOIN lkpMembershipPromotionType pt ON pt.MembershipPromotionTypeID = mp.MembershipPromotionTypeID
		WHERE so.SalesOrderGUID = @RecordGUID
			AND a.SalesOrderProcessFlag = 1
			AND so.IsVoidedFlag = 0
			AND sotype.SalesOrderTypeDescriptionShort <> @SALES_ORDER_TYPE_INTERCOMPANY


		--UPDATE AR Balance based on AR Tender, Write-Offs need to be Added
		UPDATE datClient
		SET ARBalance = ROUND(ARBalance + Amount, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
		FROM datSalesOrder so
				INNER JOIN datSalesOrderTender sot ON so.SalesOrderGUID = sot.SalesOrderGUID
				INNER JOIN lkpTenderType tt ON sot.TenderTypeID = tt.TenderTypeID
				INNER JOIN datClient c ON so.ClientGUID = c.ClientGUID
				INNER JOIN lkpSalesOrderType sotype ON so.SalesOrderTypeID = sotype.SalesOrderTypeID
		WHERE so.SalesOrderGUID = @RecordGUID
				AND so.IsVoidedFlag = 0
				AND tt.TenderTypeDescriptionShort = @TENDERTYPE_AR
				AND sotype.SalesOrderTypeDescriptionShort <> @SALES_ORDER_TYPE_INTERCOMPANY

		UPDATE datClient
		SET ARBalance = ROUND(ARBalance + Amount, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
		FROM datSalesOrder so
				INNER JOIN datSalesOrderTender sot ON so.SalesOrderGUID = sot.SalesOrderGUID
				INNER JOIN lkpTenderType tt ON sot.TenderTypeID = tt.TenderTypeID
				INNER JOIN datClient c ON so.ClientGUID = c.ClientGUID
				INNER JOIN lkpSalesOrderType sotype ON so.SalesOrderTypeID = sotype.SalesOrderTypeID
		WHERE so.SalesOrderGUID = @RecordGUID
				AND so.IsVoidedFlag = 0
				AND tt.TenderTypeDescriptionShort = @TENDERTYPE_FinanceAR
				AND sotype.SalesOrderTypeDescriptionShort <> @SALES_ORDER_TYPE_INTERCOMPANY

		-- Create adjustment record for accum update.
		set @AccumActionTypeAdd = (Select AccumulatorActionTypeID from lkpAccumulatorActionType where AccumulatorActionTypeDescriptionShort = @ACCUMACTTYPE_ADD)
		INSERT INTO datAccumulatorAdjustment(AccumulatorAdjustmentGUID, ClientMembershipGUID, SalesOrderDetailGUID, AppointmentGUID, AccumulatorID, AccumulatorActionTypeID, QuantityUsedOriginal, QuantityUsedAdjustment, QuantityTotalOriginal, QuantityTotalAdjustment, MoneyOriginal, MoneyAdjustment, DateOriginal, DateAdjustment, CreateDate, CreateUser, LastUpdate, LastUpdateUser, SalesOrderTenderGuid)
		SELECT NewID(), so.clientmembershipguid, NULL, so.AppointmentGUID, a.AccumulatorID, @AccumActionTypeAdd,
			NULL, NULL, NULL, NULL, AccumMoney, Amount, NULL, NULL, GETUTCDATE(), @CMSUser, GETUTCDATE(), @CMSUser, sot.salesordertenderguid
		FROM datSalesOrder so
				--INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
				INNER JOIN datSalesOrderTender sot ON so.SalesOrderGUID = sot.SalesOrderGUID
				INNER JOIN lkpTenderType tt ON sot.TenderTypeID = tt.TenderTypeID
				INNER JOIN datClientMembershipAccum cma ON so.ClientMembershipGUID = cma.ClientMembershipGUID
				INNER JOIN cfgAccumulator a ON cma.AccumulatorID = a.AccumulatorID
				INNER JOIN lkpSalesOrderType sotype ON so.SalesOrderTypeID = sotype.SalesOrderTypeID
		WHERE so.SalesOrderGUID = @RecordGUID
				AND so.IsVoidedFlag = 0
				AND (tt.TenderTypeDescriptionShort = @TENDERTYPE_AR or tt.TenderTypeDescriptionShort = @TENDERTYPE_FinanceAR)
				AND a.AccumulatorDescriptionShort = @ACCUM_AR
				AND sotype.SalesOrderTypeDescriptionShort <> @SALES_ORDER_TYPE_INTERCOMPANY


		UPDATE datClientMembershipAccum
		SET AccumMoney = ROUND(AccumMoney + Amount, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
		FROM datSalesOrder so
				INNER JOIN datSalesOrderTender sot ON so.SalesOrderGUID = sot.SalesOrderGUID
				INNER JOIN lkpTenderType tt ON sot.TenderTypeID = tt.TenderTypeID
				INNER JOIN datClientMembershipAccum cma ON so.ClientMembershipGUID = cma.ClientMembershipGUID
				INNER JOIN cfgAccumulator a ON cma.AccumulatorID = a.AccumulatorID
				INNER JOIN lkpSalesOrderType sotype ON so.SalesOrderTypeID = sotype.SalesOrderTypeID
		WHERE so.SalesOrderGUID = @RecordGUID
				AND so.IsVoidedFlag = 0
				AND tt.TenderTypeDescriptionShort = @TENDERTYPE_AR
				AND a.AccumulatorDescriptionShort = @ACCUM_AR
				AND sotype.SalesOrderTypeDescriptionShort <> @SALES_ORDER_TYPE_INTERCOMPANY

		UPDATE datClientMembershipAccum
		SET AccumMoney = ROUND(AccumMoney + Amount, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
		FROM datSalesOrder so
				INNER JOIN datSalesOrderTender sot ON so.SalesOrderGUID = sot.SalesOrderGUID
				INNER JOIN lkpTenderType tt ON sot.TenderTypeID = tt.TenderTypeID
				INNER JOIN datClientMembershipAccum cma ON so.ClientMembershipGUID = cma.ClientMembershipGUID
				INNER JOIN cfgAccumulator a ON cma.AccumulatorID = a.AccumulatorID
				INNER JOIN lkpSalesOrderType sotype ON so.SalesOrderTypeID = sotype.SalesOrderTypeID
		WHERE so.SalesOrderGUID = @RecordGUID
				AND so.IsVoidedFlag = 0
				AND tt.TenderTypeDescriptionShort = @TENDERTYPE_FinanceAR
				AND a.AccumulatorDescriptionShort = @ACCUM_AR
				AND sotype.SalesOrderTypeDescriptionShort <> @SALES_ORDER_TYPE_INTERCOMPANY

		OPEN @Accumulator_Cursor
		FETCH NEXT FROM @Accumulator_Cursor
		INTO @ClientMembershipGUID, @ClientGUID, @SalesOrderDetailGUID, @AppointmentDetailGUID, @AccumulatorID, @AccumDataType, @AccumActionID, @AccumAction, @AccumAdj, @DateField1, @QtyField1, @PriceField1, @PriceExtField1, @BenefitsTracked, @AdjAR, @AdjPrice, @AdjPaid, @AccumulatorDescriptionShort, @PromoType, @PromoAmount, @PromoSystems, @PromoServices, @PromoSolutions, @PromoProductKits, @PromoHCSL, @PriceTaxField1, @ClientMembershipAddOnID, @ClientMembershipAccumGUID, @SalesCodeID

		--------------------------------------------------------------------
		-- SECTION 3: Loop through all Quantity Used accumulators and adjust as needed
		--     and create a AccumulatorAdjustment record for each accumulator
		--     that's been updated. Save identifying accumulator information into temp
		--     table for use when updating remaining accumulators
		--------------------------------------------------------------------
		WHILE @@FETCH_STATUS = 0
		  BEGIN
			IF (@Event <> @EVENT_WRITEOFFORDER)
				BEGIN
					--------------------------------
					-- Adjust USED QUANTITY accumulators
					--------------------------------
					IF (@AccumDataType = @ACCUMDATATYPE_QUANTITYUSED)
					  BEGIN

						If (@IsQuantityTracked = 1 and (@BenefitsTracked = 1 OR @AccumulatorDescriptionShort = @BioSysAccumulator))  -- Hair Systems Accumulator should always be tracked.
							BEGIN
		  						-- determine where the input data is coming from
								IF (@AccumAdj = @ACCUMADJTYPE_SALEORDERQTYUSED)
									SET @QuantityVal = @QtyField1
								ELSE
									SET @QuantityVal = 0


								-- Insert AccumulatorAdjustment record to track the change
								INSERT INTO datAccumulatorAdjustment(AccumulatorAdjustmentGUID, ClientMembershipGUID, SalesOrderDetailGUID, AppointmentGUID, AccumulatorID, AccumulatorActionTypeID,
										QuantityUsedOriginal, QuantityUsedAdjustment, QuantityTotalOriginal, QuantityTotalAdjustment, MoneyOriginal, MoneyAdjustment, DateOriginal, DateAdjustment,
										CreateDate, CreateUser, LastUpdate, LastUpdateUser, ClientMembershipAddOnID)
								SELECT NewID(), @ClientMembershipGUID, @SalesOrderDetailGUID, @AppointmentDetailGUID, @AccumulatorID, @AccumActionID,
									UsedAccumQuantity, @QuantityVal, NULL, NULL, NULL, NULL, NULL, NULL, GETUTCDATE(), @CMSUser, GETUTCDATE(), @CMSUser, @ClientMembershipAddOnID
								FROM datClientMembershipAccum cma
									 --LEFT JOIN datClientMembershipAddOn cmao on cmao.ClientMembershipAddOnID = cma.ClientMembershipAddOnID
								WHERE cma.ClientMembershipAccumGUID = @ClientMembershipAccumGUID
								--WHERE cma.ClientMembershipGUID = @ClientMembershipGUID
								--	AND AccumulatorID = @AccumulatorID
								--	AND ((@ClientMembershipAddOnID IS NULL AND cma.ClientMembershipAddOnID IS NULL) OR (@ClientMembershipAddOnID = cma.ClientMembershipAddOnID))

								-- add or remove the accumulator in question
								IF (@AccumAction = @ACCUMACTTYPE_ADD OR @AccumAction = @ACCUMACTTYPE_REMOVE)
								  BEGIN
									-- flip the sign if we are removing accumulators
									IF (@AccumAction = @ACCUMACTTYPE_REMOVE)
										SET @QuantityVal = @QuantityVal * -1

									-- update Accumulator value
									UPDATE cma
									SET cma.UsedAccumQuantity = ISNULL(UsedAccumQuantity, 0) + @QuantityVal, cma.LastUpdate = GETUTCDATE(), cma.LastUpdateUser = @CMSUser
									FROM datClientMembershipAccum cma
									--LEFT JOIN datClientMembershipAddOn cmao on cmao.ClientMembershipAddOnID = cma.ClientMembershipAddOnID
									WHERE cma.ClientMembershipAccumGUID = @ClientMembershipAccumGUID
									--WHERE cma.ClientMembershipGUID = @ClientMembershipGUID
									--	AND AccumulatorID = @AccumulatorID
									--	AND (cmao.ClientMembershipAddOnID is null or cmao.ClientMembershipAddOnStatusID = 1)
								  END

								-- replace the accumulator in question
								ELSE IF (@AccumAction = @ACCUMACTTYPE_REPLACE)
								  BEGIN
									-- replace Accumulator value
									UPDATE cma
									SET cma.UsedAccumQuantity = @QuantityVal, cma.LastUpdate = GETUTCDATE(), cma.LastUpdateUser = @CMSUser
									FROM datClientMembershipAccum cma
									--LEFT JOIN datClientMembershipAddOn cmao on cmao.ClientMembershipAddOnID = cma.ClientMembershipAddOnID
									WHERE cma.ClientMembershipAccumGUID = @ClientMembershipAccumGUID
									--WHERE cma.ClientMembershipGUID = @ClientMembershipGUID
									--	AND AccumulatorID = @AccumulatorID
									--	AND (cmao.ClientMembershipAddOnID is null or cmao.ClientMembershipAddOnStatusID = 1)
								  END

								INSERT INTO @UpdatedQuantityUsedAccumulators (SalesCodeID, ClientMembershipAccumulatorGUID, ClientMembershipAddOnID)
									VALUES (@SalesCodeID, @ClientMembershipAccumGUID, @ClientMembershipAddOnID)
							END
					  END
				END


			FETCH NEXT FROM @Accumulator_Cursor
			INTO @ClientMembershipGUID, @ClientGUID, @SalesOrderDetailGUID, @AppointmentDetailGUID, @AccumulatorID, @AccumDataType, @AccumActionID, @AccumAction, @AccumAdj, @DateField1, @QtyField1, @PriceField1, @PriceExtField1, @BenefitsTracked, @AdjAR, @AdjPrice, @AdjPaid, @AccumulatorDescriptionShort, @PromoType, @PromoAmount, @PromoSystems, @PromoServices, @PromoSolutions, @PromoProductKits, @PromoHCSL, @PriceTaxField1, @ClientMembershipAddOnID, @ClientMembershipAccumGUID, @SalesCodeID
		  END

		-- close & remove the reference to the cursor object
 		CLOSE @Accumulator_Cursor
		DEALLOCATE @Accumulator_Cursor

	END



    --------------------------------------------------------------------
	-- SECTION 4: Get the list of Remaining (Non-Quantity Used) accumulators that need to be updated along with
	--     the required input data
	--------------------------------------------------------------------

	IF (@Event = @EVENT_SALESORDER OR @Event = @EVENT_REFUNDORDER OR @Event = @EVENT_SURGERYCLOSEOUT OR @Event = @EVENT_WRITEOFFORDER)
	  BEGIN
		SET @Accumulator_Cursor = CURSOR FAST_FORWARD FOR
		SELECT so.ClientMembershipGUID,
			so.ClientGUID,
			sod.SalesOrderDetailGUID,
			NULL AS AppointmentGUID,
			a.AccumulatorID,
			UPPER(adt.AccumulatorDataTypeDescriptionShort) AS AccumDataType,
			aat1.AccumulatorActionTypeID AS AccumActionID,
			UPPER(aat1.AccumulatorActionTypeDescriptionShort) AS AccumAction,
			UPPER(aat2.AccumulatorAdjustmentTypeDescriptionShort) AS AccumAdj,
			so.OrderDate AS DateField1,
			sod.Quantity AS QtyField1,
			sod.Price AS PriceField1,
			sod.ExtendedPriceCalc AS PriceExtField1,
			sod.BenefitTrackingEnabledFlag as BenefitsTracked,
			a.AdjustARBalanceFlag AS AdjAR,
			a.AdjustContractPriceFlag AS AdjPrice,
			a.AdjustContractPaidFlag AS AdjPaid,
			a.AccumulatorDescriptionShort AS AccumulatorDescriptionShort,
			pt.MembershipPromotionTypeDescriptionShort AS PromoType,
			ISNULL(mp.Amount,0) AS PromoAmount,
			ISNULL(mp.AdditionalSystems,0) AS PromoSystems,
			ISNULL(mp.AdditionalServices,0) AS PromoServices,
			ISNULL(mp.AdditionalSolutions,0) AS PromoSolutions,
			ISNULL(mp.AdditionalProductKits,0) AS PromoProductKits,
			ISNULL(mp.AdditionalHCSL,0) AS PromoHCSL,
			sod.PriceTaxCalc AS PriceTaxField1,
			x_cma.ClientMembershipAddOnID,
			x_cma.ClientMembershipAccumGUID,
            sod.SalesCodeID
		FROM datSalesOrder so
			INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
			INNER JOIN cfgAccumulatorJoin aj ON sod.SalesCodeID = aj.SalesCodeID
			INNER JOIN cfgAccumulator a ON aj.AccumulatorID = a.AccumulatorID
            INNER JOIN lkpAccumulatorDataType adt ON aj.AccumulatorDataTypeID = adt.AccumulatorDataTypeID

			CROSS APPLY (
				SELECT TOP(1) cma.*
				FROM datClientMembershipAccum cma
                LEFT JOIN @UpdatedQuantityUsedAccumulators uqua ON sod.SalesCodeID = uqua.SalesCodeID
					LEFT JOIN datClientMembershipAddOn cmao on cmao.ClientMembershipAddOnID = cma.ClientMembershipAddOnID
					LEFT JOIN lkpClientMembershipAddOnStatus ast ON ast.ClientMembershipAddOnStatusID = cmao.ClientMembershipAddOnStatusID
					LEFT JOIN datClientMembershipAccum qtyUsedCma ON uqua.ClientMembershipAccumulatorGUID = qtyUsedCma.ClientMembershipAccumGUID
				WHERE cma.ClientMembershipGUID = so.ClientMembershipGUID

					AND ((qtyUsedCma.ClientMembershipAccumGUID IS NULL) OR((qtyUsedCma.ClientMembershipAddOnID IS NOT NULL AND (cma.ClientMembershipAddOnID = uqua.ClientMembershipAddOnID)) OR (qtyUsedCma.ClientMembershipAddOnID IS NULL AND uqua.ClientMembershipAddOnID IS NULL)))

					AND cma.AccumulatorID = a.AccumulatorID
					AND (cmao.ClientMembershipAddOnID IS NULL OR ast.ClientMembershipAddOnStatusDescriptionShort = 'Active')  -- Only deal with benefits for Active Add-On's
					AND ((sod.ClientMembershipAddOnID IS NOT NULL AND sod.ClientMembershipAddOnID = cma.ClientMembershipAddOnID)
						OR (sod.ClientMembershipAddOnID IS NULL))
                    AND adt.AccumulatorDataTypeDescriptionShort <> @ACCUMDATATYPE_QUANTITYUSED
				ORDER BY cma.ClientMembershipAddOnID

			) x_cma


			INNER JOIN lkpAccumulatorActionType aat1 ON aj.AccumulatorActionTypeID = aat1.AccumulatorActionTypeID
			INNER JOIN lkpAccumulatorAdjustmentType aat2 ON aj.AccumulatorAdjustmentTypeID = aat2.AccumulatorAdjustmentTypeID
			INNER JOIN lkpSalesOrderType sotype ON so.SalesOrderTypeID = sotype.SalesOrderTypeID
			LEFT JOIN cfgMembershipPromotion mp ON mp.MembershipPromotionID = sod.MembershipPromotionID
			LEFT JOIN lkpMembershipPromotionType pt ON pt.MembershipPromotionTypeID = mp.MembershipPromotionTypeID
		WHERE so.SalesOrderGUID = @RecordGUID
			AND a.SalesOrderProcessFlag = 1
			AND so.IsVoidedFlag = 0
			AND sotype.SalesOrderTypeDescriptionShort <> @SALES_ORDER_TYPE_INTERCOMPANY


	  END

	  ELSE IF (@Event = @EVENT_SCHEDULERORDER)
	  BEGIN
		SET @Accumulator_Cursor = CURSOR FAST_FORWARD FOR
		SELECT apt.ClientMembershipGUID,
			apt.ClientGUID,
			NULL AS SalesOrderDetailGUID,
			apt.AppointmentGUID,
			a.AccumulatorID,
			UPPER(adt.AccumulatorDataTypeDescriptionShort) AS AccumDataType,
			aat1.AccumulatorActionTypeID AS AccumActionID,
			UPPER(aat1.AccumulatorActionTypeDescriptionShort) AS AccumAction,
			UPPER(aat2.AccumulatorAdjustmentTypeDescriptionShort) AS AccumAdj,
			apt.EndDateTimeCalc AS DateField1,
			0 AS QtyField1,
			0 AS PriceField1,
			0 AS PriceExtField1,
			0 AS BenefitsTracked,
			0 AS AdjAR,
			0 AS AdjPrice,
			0 AS AdjPaid,
			a.AccumulatorDescriptionShort AS AccumulatorDescriptionShort,
			NULL AS PromoType,
			0 AS PromoAmount,
			0 AS PromoSystems,
			0 AS PromoServices,
			0 AS PromoSolutions,
			0 AS PromoProductKits,
			0 AS PromoHCSL,
			0 AS PriceTaxField1,
			cma.ClientMembershipAddOnID,
			cma.ClientMembershipAccumGUID,
            NULL AS SalesCodeID
		FROM datAppointment apt
			INNER JOIN datClientMembershipAccum cma ON apt.ClientMembershipGUID = cma.ClientMembershipGUID
			INNER JOIN cfgAccumulator a ON cma.AccumulatorID = a.AccumulatorID
			INNER JOIN lkpAccumulatorDataType adt ON 3 = adt.AccumulatorDataTypeID
			INNER JOIN lkpAccumulatorActionType aat1 ON a.SchedulerActionTypeID = aat1.AccumulatorActionTypeID
			INNER JOIN lkpAccumulatorAdjustmentType aat2 ON a.SchedulerAdjustmentTypeID = aat2.AccumulatorAdjustmentTypeID
		WHERE apt.AppointmentGUID = @RecordGUID
			AND a.SchedulerProcessFlag = 1

	END

    OPEN @Accumulator_Cursor
	FETCH NEXT FROM @Accumulator_Cursor
	INTO @ClientMembershipGUID, @ClientGUID, @SalesOrderDetailGUID, @AppointmentDetailGUID, @AccumulatorID, @AccumDataType, @AccumActionID, @AccumAction, @AccumAdj, @DateField1, @QtyField1, @PriceField1, @PriceExtField1, @BenefitsTracked, @AdjAR, @AdjPrice, @AdjPaid, @AccumulatorDescriptionShort, @PromoType, @PromoAmount, @PromoSystems, @PromoServices, @PromoSolutions, @PromoProductKits, @PromoHCSL, @PriceTaxField1, @ClientMembershipAddOnID, @ClientMembershipAccumGUID, @SalesCodeID

--------------------------------------------------------------------
	-- SECTION 5: Loop through all remaining (non-quantity used) accumulators and adjust as needed
	--     and create a AccumulatorAdjustment record for each accumulator
	--     that's been updated. Save identifying accumulator information into temp
    --     table for use when updating remaining accumulators
	--------------------------------------------------------------------

    	WHILE @@FETCH_STATUS = 0
	  BEGIN

		--------------------------------
		-- Adjust MONEY accumulators
		--------------------------------
		IF (@AccumDataType = @ACCUMDATATYPE_MONEY)
			BEGIN
		  	-- determine where the input data is coming from
			IF (@AccumAdj = @ACCUMADJTYPE_SALEORDERPRICE)
				SET @MoneyVal = @PriceField1
			ELSE IF (@AccumAdj = @ACCUMADJTYPE_SALEORDERPRICEEXT)
				SET @MoneyVal = @PriceExtField1
			ELSE IF (@AccumAdj = @ACCUMADJTYPE_SALEORDERPRICETAX)
			    SET @MoneyVal = @PriceTaxField1
			ELSE
				SET @MoneyVal = 0

			-- Insert AccumulatorAdjustment record to track the change
			INSERT INTO datAccumulatorAdjustment(AccumulatorAdjustmentGUID, ClientMembershipGUID, SalesOrderDetailGUID, AppointmentGUID, AccumulatorID, AccumulatorActionTypeID, QuantityUsedOriginal, QuantityUsedAdjustment, QuantityTotalOriginal, QuantityTotalAdjustment, MoneyOriginal, MoneyAdjustment, DateOriginal, DateAdjustment, CreateDate, CreateUser, LastUpdate, LastUpdateUser, ClientMembershipAddOnID)
			SELECT NewID(), @ClientMembershipGUID, @SalesOrderDetailGUID, @AppointmentDetailGUID, @AccumulatorID, @AccumActionID,
				NULL, NULL, NULL, NULL, AccumMoney, @MoneyVal, NULL, NULL, GETUTCDATE(), @CMSUser, GETUTCDATE(), @CMSUser, @ClientMembershipAddOnID
			FROM datClientMembershipAccum a
			WHERE a.ClientMembershipAccumGUID = @ClientMembershipAccumGUID
			--WHERE ClientMembershipGUID = @ClientMembershipGUID
			--	AND AccumulatorID = @AccumulatorID
			--	AND ClientMembershipAddOnID = @ClientMembershipAddOnID

			-- add or remove the accumulator in question
			IF (@AccumAction = @ACCUMACTTYPE_ADD OR @AccumAction = @ACCUMACTTYPE_REMOVE)
				BEGIN
				-- flip the sign if we are removing accumulators
				IF (@AccumAction = @ACCUMACTTYPE_REMOVE)
					SET @MoneyVal = @MoneyVal * -1

				-- update Accumulator value
				UPDATE datClientMembershipAccum
				SET AccumMoney = ISNULL(AccumMoney, 0) + @MoneyVal, LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
				WHERE ClientMembershipAccumGUID = @ClientMembershipAccumGUID
				--WHERE ClientMembershipGUID = @ClientMembershipGUID
				--	AND AccumulatorID = @AccumulatorID
				--	AND ClientMembershipAddOnID = @ClientMembershipAddOnID

				--Adjust Client/ClientMembership records if needed
				IF (@Event = @EVENT_WRITEOFFORDER)
					BEGIN
					IF (@AdjPaid = 1)
						BEGIN
							IF @ClientMembershipAddOnID IS NOT NULL
								UPDATE datClientMembershipAddOn
								SET ContractPaidAmount = ROUND(ISNULL(ContractPaidAmount, 0) + @MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
								WHERE ClientMembershipAddOnID = @ClientMembershipAddOnID
							ELSE
								UPDATE datClientMembership
								SET ContractPaidAmount = ROUND(ISNULL(ContractPaidAmount, 0) + @MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
								WHERE ClientMembershipGUID = @ClientMembershipGUID
						END
					END
				IF (@Event = @EVENT_SALESORDER OR @Event = @EVENT_REFUNDORDER OR @Event = @EVENT_SURGERYCLOSEOUT)
					BEGIN
					IF (@AdjAR = 1)
						BEGIN
						UPDATE datClient
						SET ARBalance = ROUND(ISNULL(ARBalance, 0) + @MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
						WHERE ClientGUID = @ClientGUID
						END
					IF (@AdjPrice = 1)
						BEGIN
							IF @ClientMembershipAddOnID IS NOT NULL
								UPDATE datClientMembershipAddOn
								SET ContractPrice = ROUND(ISNULL(ContractPrice, 0) + @MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
								WHERE ClientMembershipAddOnID = @ClientMembershipAddOnID
							ELSE
								UPDATE datClientMembership
								SET ContractPrice = ROUND(ISNULL(ContractPrice, 0) + @MoneyVal, 2) ,LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
								WHERE ClientMembershipGUID = @ClientMembershipGUID
						END
					IF (@AdjPaid = 1)
						BEGIN
							IF @ClientMembershipAddOnID IS NOT NULL
								UPDATE datClientMembershipAddOn
								SET ContractPaidAmount = ROUND(ISNULL(ContractPaidAmount, 0) + @MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
								WHERE ClientMembershipAddOnID = @ClientMembershipAddOnID
							ELSE
								UPDATE datClientMembership
								SET ContractPaidAmount = ROUND(ISNULL(ContractPaidAmount, 0) + @MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
								WHERE ClientMembershipGUID = @ClientMembershipGUID

						--ISSUE #203 PRM 03/26/2009:
						--When refunding a payment amount and the ClientMembership is either inactive or
						--    in a specific status, adjust the contract by that price as well so they stay in synch
						IF @Event = @EVENT_REFUNDORDER
							BEGIN
							IF EXISTS(SELECT 1
										FROM datSalesOrder so
											INNER JOIN datClientMembership cm ON so.ClientMembershipGUID = cm.ClientMembershipGUID
											INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
										WHERE
											so.SalesOrderGUID = @RecordGUID AND
											so.AppointmentGUID IS NULL AND --not part of a surgery performed closeout
											(
												cms.ClientMembershipStatusDescriptionShort IN (@CLIENTMEMBERSHIPSTATUS_SURGERYPERFORMED)
												OR cm.IsActiveFlag = 0
											)
											--Issue #495, only adjust the contract price if it wouldn't naturally be adjusted based on the sales code (i.e. mem pmts made before surgery don't adjust contract, but mem rev after surgery already does so no need to double up on it)
											AND NOT so.SalesOrderGUID IN (
												SELECT SalesOrderGUID
												FROM datAccumulatorAdjustment subaa
													INNER JOIN cfgAccumulator suba ON subaa.AccumulatorID = suba.AccumulatorID
												WHERE subaa.SalesOrderDetailGUID = @SalesOrderDetailGUID
													AND suba.AdjustContractPriceFlag = 1
											)

							)
								BEGIN
								UPDATE datClientMembership
								SET ContractPrice = ROUND(ISNULL(ContractPrice, 0) + @MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
								WHERE ClientMembershipGUID = @ClientMembershipGUID
								END
							END
						END
				END
			END

			-- replace the accumulator in question
			ELSE IF (@AccumAction = @ACCUMACTTYPE_REPLACE)
				BEGIN
				-- replace Accumulator value
				UPDATE datClientMembershipAccum
				SET AccumMoney = @MoneyVal, LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
				WHERE ClientMembershipAccumGUID = @ClientMembershipAccumGUID
				--WHERE ClientMembershipGUID = @ClientMembershipGUID
				--	AND AccumulatorID = @AccumulatorID
				--	AND ((@ClientMembershipAddOnID IS NULL AND ClientMembershipAddOnID IS NULL) OR (@ClientMembershipAddOnID = ClientMembershipAddOnID))

				--Adjust Client/ClientMembership records if needed
				IF (@Event = @EVENT_SALESORDER OR @Event = @EVENT_REFUNDORDER OR @Event = @EVENT_SURGERYCLOSEOUT)
					BEGIN
					IF (@AdjAR = 1)
						BEGIN
						UPDATE datClient
						SET ARBalance = ROUND(@MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
						WHERE ClientGUID = @ClientGUID
						END
					IF (@AdjPrice = 1)
						BEGIN
							IF @ClientMembershipAddOnID IS NOT NULL
								UPDATE datClientMembershipAddOn
								SET ContractPrice = Round(@MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
								WHERE ClientMembershipAddOnID = @ClientMembershipAddOnID
							ELSE
								UPDATE datClientMembership
								SET ContractPrice = ROUND(@MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
								WHERE ClientMembershipGUID = @ClientMembershipGUID
						END
					IF (@AdjPaid = 1)
						BEGIN
							IF @ClientMembershipAddOnID IS NOT NULL
								UPDATE datClientMembershipAddOn
								SET ContractPrice = Round(@MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
								WHERE ClientMembershipAddOnID = @ClientMembershipAddOnID
							ELSE
								UPDATE datClientMembership
								SET ContractPaidAmount = ROUND(@MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
								WHERE ClientMembershipGUID = @ClientMembershipGUID
						END
					END
				END
			END

		IF (@Event <> @EVENT_WRITEOFFORDER)
			BEGIN
				--------------------------------
				-- Adjust TOTAL QUANTITY accumulators
				--------------------------------
				IF (@AccumDataType = @ACCUMDATATYPE_QUANTITYTOTAL)
				  BEGIN
					If (@IsQuantityTracked = 1)
						BEGIN
		  					-- determine where the input data is coming from
							IF (@AccumAdj = @ACCUMADJTYPE_SALEORDERQTYTOTAL)
								SET @QuantityVal = @QtyField1
							ELSE IF (@AccumAdj = @ACCUMADJTYPE_INITQTY)
							BEGIN
								-- Determine Initial Quantity from the cfgMembershipAccum table.
								SET @QuantityVal = (SELECT ISNULL(ma.InitialQuantity,0) FROM dbo.datClientMembership cm
															INNER JOIN dbo.cfgMembershipAccum ma ON cm.MembershipID = ma.MembershipID AND ma.AccumulatorID = @AccumulatorID
														WHERE cm.ClientMembershipGUID = @ClientMembershipGUID)

								-- Apply Promotion if Exists.  If no promo was applied, values are 0.
								SET @QuantityVal = @QuantityVal + (SELECT CASE
																		WHEN @AccumulatorDescriptionShort = @BioSysAccumulator THEN @PromoSystems
																		WHEN @AccumulatorDescriptionShort = @ServAccumulator THEN @PromoServices
																		WHEN @AccumulatorDescriptionShort = @SolAccumulator THEN @PromoSolutions
																		WHEN @AccumulatorDescriptionShort = @ProdkitAccumulator THEN @PromoProductKits
																		WHEN @AccumulatorDescriptionShort = @HCSLAccumulator THEN + @PromoHCSL
																		ELSE 0 END)
							END
							ELSE
								SET @QuantityVal = 0


							---- If the accumulator adjustment type is 'Initial Quantity' and a promotion
							---- is applied to the sales order detail, adjust the quantity.
							--IF (@AccumAdj = @ACCUMADJTYPE_INITQTY) AND (@MembershipPromotionID IS NOT NULL)
							--BEGIN
							--	SELECT
							--		@PromoQty = CASE
							--						WHEN @AccumulatorDescriptionShort = 'BioSys' THEN mp.AdditionalSystems
							--						WHEN @AccumulatorDescriptionShort = 'SERV' THEN mp.AdditionalServices
							--						WHEN @AccumulatorDescriptionShort = 'SOL' THEN mp.AdditionalSolutions
							--						WHEN @AccumulatorDescriptionShort = 'PRODKIT' THEN mp.AdditionalProductKits
							--						ELSE 0 END
							--	FROM dbo.cfgMembershipPromotion mp
							--	WHERE mp.MembershipPromotionID = @MembershipPromotionID
							--END

							--SET @QuantityVal = @QuantityVal + @PromoQty


							-- Insert AccumulatorAdjustment record to track the change
							INSERT INTO datAccumulatorAdjustment(AccumulatorAdjustmentGUID, ClientMembershipGUID, SalesOrderDetailGUID, AppointmentGUID, AccumulatorID,
								AccumulatorActionTypeID, QuantityUsedOriginal, QuantityUsedAdjustment, QuantityTotalOriginal, QuantityTotalAdjustment, MoneyOriginal,
								MoneyAdjustment, DateOriginal, DateAdjustment, CreateDate, CreateUser, LastUpdate, LastUpdateUser, ClientMembershipAddOnID)
							SELECT NewID(), @ClientMembershipGUID, @SalesOrderDetailGUID, @AppointmentDetailGUID, @AccumulatorID, @AccumActionID,
								NULL, NULL, TotalAccumQuantity, @QuantityVal, NULL, NULL, NULL, NULL, GETUTCDATE(), @CMSUser, GETUTCDATE(), @CMSUser, @ClientMembershipAddOnID
							FROM datClientMembershipAccum cma
							--LEFT JOIN datClientMembershipAddOn cmao on cmao.ClientMembershipAddOnID = cma.ClientMembershipAddOnID
							WHERE cma.ClientMembershipAccumGUID = @ClientMembershipAccumGUID
							--WHERE cma.ClientMembershipGUID = @ClientMembershipGUID
							--	AND AccumulatorID = @AccumulatorID
							--	AND (cmao.ClientMembershipAddOnID is null or cmao.ClientMembershipAddOnStatusID = 1)

							-- add or remove the accumulator in question
							IF (@AccumAction = @ACCUMACTTYPE_ADD OR @AccumAction = @ACCUMACTTYPE_REMOVE)
							  BEGIN
								-- flip the sign if we are removing accumulators
								IF (@AccumAction = @ACCUMACTTYPE_REMOVE)
									SET @QuantityVal = @QuantityVal * -1

								-- update Accumulator value
								UPDATE cma
								SET cma.TotalAccumQuantity = ISNULL(TotalAccumQuantity, 0) + @QuantityVal, cma.LastUpdate = GETUTCDATE(), cma.LastUpdateUser = @CMSUser
								FROM datClientMembershipAccum cma
								--LEFT JOIN datClientMembershipAddOn cmao on cmao.ClientMembershipAddOnID = cma.ClientMembershipAddOnID
								WHERE cma.ClientMembershipAccumGUID = @ClientMembershipAccumGUID
								--WHERE cma.ClientMembershipGUID = @ClientMembershipGUID
								--	AND AccumulatorID = @AccumulatorID
								--	AND (cmao.ClientMembershipAddOnID is null or cmao.ClientMembershipAddOnStatusID = 1)
							  END

							-- replace the accumulator in question
							ELSE IF (@AccumAction = @ACCUMACTTYPE_REPLACE)
							  BEGIN
								-- replace Accumulator value
								UPDATE cma
								SET cma.TotalAccumQuantity = @QuantityVal, cma.LastUpdate = GETUTCDATE(), cma.LastUpdateUser = @CMSUser
								FROM datClientMembershipAccum cma
								--LEFT JOIN datClientMembershipAddOn cmao on cmao.ClientMembershipAddOnID = cma.ClientMembershipAddOnID
								WHERE cma.ClientMembershipAccumGUID = @ClientMembershipAccumGUID
								--WHERE cma.ClientMembershipGUID = @ClientMembershipGUID
								--	AND AccumulatorID = @AccumulatorID
								--	AND (cmao.ClientMembershipAddOnID is null or cmao.ClientMembershipAddOnStatusID = 1)
							  END
						END
					END

				----------------------------------
				---- Adjust MONEY accumulators
				----------------------------------
				--ELSE IF (@AccumDataType = @ACCUMDATATYPE_MONEY)
				--  BEGIN
		  --			-- determine where the input data is coming from
				--	IF (@AccumAdj = @ACCUMADJTYPE_SALEORDERPRICE)
				--		SET @MoneyVal = @PriceField1
				--	ELSE IF (@AccumAdj = @ACCUMADJTYPE_SALEORDERPRICEEXT)
				--		SET @MoneyVal = @PriceExtField1
				--	ELSE
				--		SET @MoneyVal = 0

				--	--
				--	-- Logic to handle Membership Promotions
				--	--
				--	--IF (@PromoType IS NOT NULL) AND (@AccumulatorDescriptionShort = @ContBalAccumulator)
				--	--		AND ((@AccumAdj = @ACCUMADJTYPE_SALEORDERPRICE) OR (@AccumAdj = @ACCUMADJTYPE_SALEORDERPRICEEXT))
				--	--BEGIN
				--	--	IF @PromoType = @PercentPromoType AND @PromoAmount > 0
				--	--		SET @MoneyVal = @MoneyVal - (@MoneyVal * (@PromoAmount / 100))
				--	--	ELSE IF @PromoType = @DollarPromoType
				--	--		SET @MoneyVal = @MoneyVal - @PromoAmount
				--	--	--ELSE IF @PromoType = @OverridePromoType
				--	--	--	SET @MoneyVal = @PromoAmount
				--	--END

				--	-- Insert AccumulatorAdjustment record to track the change
				--	INSERT INTO datAccumulatorAdjustment(AccumulatorAdjustmentGUID, ClientMembershipGUID, SalesOrderDetailGUID, AppointmentGUID, AccumulatorID, AccumulatorActionTypeID, QuantityUsedOriginal, QuantityUsedAdjustment, QuantityTotalOriginal, QuantityTotalAdjustment, MoneyOriginal, MoneyAdjustment, DateOriginal, DateAdjustment, CreateDate, CreateUser, LastUpdate, LastUpdateUser)
				--	SELECT NewID(), @ClientMembershipGUID, @SalesOrderDetailGUID, @AppointmentDetailGUID, @AccumulatorID, @AccumActionID,
				--		NULL, NULL, NULL, NULL, AccumMoney, @MoneyVal, NULL, NULL, GETUTCDATE(), @CMSUser, GETUTCDATE(), @CMSUser
				--	FROM datClientMembershipAccum a
				--	WHERE ClientMembershipGUID = @ClientMembershipGUID
				--		AND AccumulatorID = @AccumulatorID

				--	-- add or remove the accumulator in question
				--	IF (@AccumAction = @ACCUMACTTYPE_ADD OR @AccumAction = @ACCUMACTTYPE_REMOVE)
				--	  BEGIN
				--		-- flip the sign if we are removing accumulators
				--		IF (@AccumAction = @ACCUMACTTYPE_REMOVE)
				--			SET @MoneyVal = @MoneyVal * -1

				--		-- update Accumulator value
				--		UPDATE datClientMembershipAccum
				--		SET AccumMoney = ISNULL(AccumMoney, 0) + @MoneyVal, LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
				--		WHERE ClientMembershipGUID = @ClientMembershipGUID
				--			AND AccumulatorID = @AccumulatorID

				--		--Adjust Client/ClientMembership records if needed
				--		IF (@Event = @EVENT_SALESORDER OR @Event = @EVENT_REFUNDORDER OR @Event = @EVENT_SURGERYCLOSEOUT)
				--		  BEGIN
				--			IF (@AdjAR = 1)
				--			  BEGIN
				--				UPDATE datClient
				--				SET ARBalance = ROUND(ISNULL(ARBalance, 0) + @MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
				--				WHERE ClientGUID = @ClientGUID
				--			  END
				--			IF (@AdjPrice = 1)
				--			  BEGIN
				--				UPDATE datClientMembership
				--				SET ContractPrice = ROUND(ISNULL(ContractPrice, 0) + @MoneyVal, 2) ,LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
				--				WHERE ClientMembershipGUID = @ClientMembershipGUID
				--			  END
				--			IF (@AdjPaid = 1)
				--			  BEGIN
				--				UPDATE datClientMembership
				--				SET ContractPaidAmount = ROUND(ISNULL(ContractPaidAmount, 0) + @MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
				--				WHERE ClientMembershipGUID = @ClientMembershipGUID


				--			--ISSUE #203 PRM 03/26/2009:
				--			--When refunding a payment amount and the ClientMembership is either inactive or
				--			--    in a specific status, adjust the contract by that price as well so they stay in synch
				--			IF @Event = @EVENT_REFUNDORDER
				--				BEGIN
				--				IF EXISTS(SELECT 1
				--							FROM datSalesOrder so
				--								INNER JOIN datClientMembership cm ON so.ClientMembershipGUID = cm.ClientMembershipGUID
				--								INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
				--							WHERE
				--								so.SalesOrderGUID = @RecordGUID AND
				--								so.AppointmentGUID IS NULL AND --not part of a surgery performed closeout
				--								(
				--									cms.ClientMembershipStatusDescriptionShort IN (@CLIENTMEMBERSHIPSTATUS_SURGERYPERFORMED)
				--									OR cm.IsActiveFlag = 0
				--								)
				--								--Issue #495, only adjust the contract price if it wouldn't naturally be adjusted based on the sales code (i.e. mem pmts made before surgery don't adjust contract, but mem rev after surgery already does so no need to double up on it)
				--								AND NOT so.SalesOrderGUID IN (
				--									SELECT SalesOrderGUID
				--									FROM datAccumulatorAdjustment subaa
				--										INNER JOIN cfgAccumulator suba ON subaa.AccumulatorID = suba.AccumulatorID
				--									WHERE subaa.SalesOrderDetailGUID = @SalesOrderDetailGUID
				--										AND suba.AdjustContractPriceFlag = 1
				--								)

				--				)
				--					BEGIN
				--					UPDATE datClientMembership
				--					SET ContractPrice = ROUND(ISNULL(ContractPrice, 0) + @MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
				--					WHERE ClientMembershipGUID = @ClientMembershipGUID
				--					END
				--				END
				--			END
				--		END
				--	END

				--	-- replace the accumulator in question
				--	ELSE IF (@AccumAction = @ACCUMACTTYPE_REPLACE)
				--	  BEGIN
				--		-- replace Accumulator value
				--		UPDATE datClientMembershipAccum
				--		SET AccumMoney = @MoneyVal, LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
				--		WHERE ClientMembershipGUID = @ClientMembershipGUID
				--			AND AccumulatorID = @AccumulatorID

				--		--Adjust Client/ClientMembership records if needed
				--		IF (@Event = @EVENT_SALESORDER OR @Event = @EVENT_REFUNDORDER OR @Event = @EVENT_SURGERYCLOSEOUT)
				--		  BEGIN
				--			IF (@AdjAR = 1)
				--			  BEGIN
				--				UPDATE datClient
				--				SET ARBalance = ROUND(@MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
				--				WHERE ClientGUID = @ClientGUID
				--			  END
				--			IF (@AdjPrice = 1)
				--			  BEGIN
				--				UPDATE datClientMembership
				--				SET ContractPrice = ROUND(@MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
				--				WHERE ClientMembershipGUID = @ClientMembershipGUID
				--			  END
				--			IF (@AdjPaid = 1)
				--			  BEGIN
				--				UPDATE datClientMembership
				--				SET ContractPaidAmount = ROUND(@MoneyVal, 2), LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
				--				WHERE ClientMembershipGUID = @ClientMembershipGUID
				--			  END
				--		  END

				--	  END
				--  END

				--------------------------------
				-- Adjust DATE accumulators
				--------------------------------
				ELSE IF (@AccumDataType = @ACCUMDATATYPE_DATE AND @Event <> @EVENT_REFUNDORDER AND @Event <> @EVENT_WRITEOFFORDER) --don't reset the date if this is a refund
				  BEGIN
		  			-- determine where the input data is coming from
					SET @DateVal = @DateField1


					-- Insert AccumulatorAdjustment record to track the change
					INSERT INTO datAccumulatorAdjustment(AccumulatorAdjustmentGUID, ClientMembershipGUID, SalesOrderDetailGUID, AppointmentGUID, AccumulatorID,
						AccumulatorActionTypeID, QuantityUsedOriginal, QuantityUsedAdjustment, QuantityTotalOriginal, QuantityTotalAdjustment, MoneyOriginal,
						MoneyAdjustment, DateOriginal, DateAdjustment, CreateDate, CreateUser, LastUpdate, LastUpdateUser, ClientMembershipAddOnID)
					SELECT NewID(), @ClientMembershipGUID, @SalesOrderDetailGUID, @AppointmentDetailGUID, @AccumulatorID, @AccumActionID,
						NULL, NULL, NULL, NULL, NULL, NULL, AccumDate, @DateVal, GETUTCDATE(), @CMSUser, GETUTCDATE(), @CMSUser, @ClientMembershipAddOnID
					FROM datClientMembershipAccum a
					WHERE a.ClientMembershipAccumGUID = @ClientMembershipAccumGUID
					--WHERE ClientMembershipGUID = @ClientMembershipGUID
					--	AND AccumulatorID = @AccumulatorID

					-- add or remove the accumulator in question
					IF (@AccumAction = @ACCUMACTTYPE_ADD OR @AccumAction = @ACCUMACTTYPE_REMOVE)
					  BEGIN
						--FUNCTION NOT IMPLEMENTED
						PRINT 'Process Skipped'
					  END

					-- replace the accumulator in question
					ELSE IF (@AccumAction = @ACCUMACTTYPE_REPLACE)
					  BEGIN
						-- replace Accumulator value
						UPDATE datClientMembershipAccum
						SET AccumDate = @DateVal, LastUpdate = GETUTCDATE(), LastUpdateUser = @CMSUser
						WHERE ClientMembershipAccumGUID = @ClientMembershipAccumGUID
						--WHERE ClientMembershipGUID = @ClientMembershipGUID
						--	AND AccumulatorID = @AccumulatorID
					  END
				  END
			END

		FETCH NEXT FROM @Accumulator_Cursor
		INTO @ClientMembershipGUID, @ClientGUID, @SalesOrderDetailGUID, @AppointmentDetailGUID, @AccumulatorID, @AccumDataType, @AccumActionID, @AccumAction, @AccumAdj, @DateField1, @QtyField1, @PriceField1, @PriceExtField1, @BenefitsTracked, @AdjAR, @AdjPrice, @AdjPaid, @AccumulatorDescriptionShort, @PromoType, @PromoAmount, @PromoSystems, @PromoServices, @PromoSolutions, @PromoProductKits, @PromoHCSL, @PriceTaxField1, @ClientMembershipAddOnID, @ClientMembershipAccumGUID, @SalesCodeID
	  END

	-- close & remove the reference to the cursor object
 	CLOSE @Accumulator_Cursor
	DEALLOCATE @Accumulator_Cursor

 	-- complete the transaction and save
	COMMIT TRANSACTION

END
