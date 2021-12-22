/* CreateDate: 07/29/2013 11:53:20.363 , ModifyDate: 04/04/2016 08:27:01.937 */
GO
/*
=========================================================================================================
PROCEDURE:				mtnSalesCodeCopy

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		 7/24/2013

LAST REVISION DATE: 	 8/21/2014

=========================================================================================================
DESCRIPTION:	Copies a Sales Code To a New Sales Code
=========================================================================================================
NOTES:
		* 07/24/13 MLM - Created Stored Proc
		* 07/28/14 SAL - Added new parms for:
							NewSalesCodePrice
							IsRefundable
							IsDiscountable
							Product
							CopyCenterPrice
							CopyMembershipPrice
							User
		* 08/21/14 SAL - Added new parms for:
							InterCompanyPrice
							ServiceDuration
		* 03/22/16 SAL - Added new IsEligibleForInterCompanyTransaction field to copy of cfgAccumulatorJoin
=========================================================================================================
SAMPLE EXECUTION:
EXEC mtnSalesCodeCopy 'TMEMPMT', 'Test Membership Payment', 795.00, 795.00, 75, 1, 1, NULL, 0, 0, 'MEMPMT', 'TFS1234'
=========================================================================================================
*/
CREATE PROCEDURE [dbo].[mtnSalesCodeCopy]
		@NewSalesCodeDescriptionShort nvarchar(15)
		,@NewSalesCodeDescription nvarchar(50)
		,@NewSalesCodePrice money = NULL
		,@NewSalesCodeInterCompanyPrice money = NULL
		,@ServiceDuration int = NULL
		,@IsRefundable bit
		,@IsDiscountable bit
		,@Product nvarchar(50) = NULL
		,@CopyCenterPrice bit
		,@CopyMembershipPrice bit
		,@CopyFromSalesCodeDescriptionShort nvarchar(15)
		,@User nvarchar(25) = 'sa'
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @NewSalesCodeID int
		,@CopyFromSalesCodeID int


	IF NOT EXISTS(Select * from cfgSalesCode where SalesCodeDescriptionShort = @NewSalesCodeDescriptionShort)
		BEGIN

			--Get the SalesCodeID which is being Copied
			SELECT @CopyFromSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = @CopyFromSalesCodeDescriptionShort

			INSERT INTO dbo.cfgSalesCode(SalesCodeSortOrder
							,SalesCodeDescription
							,SalesCodeDescriptionShort
							,SalesCodeTypeID
							,SalesCodeDepartmentID
							,VendorID
							,Barcode
							,PriceDefault
							,GLNumber
							,ServiceDuration
							,CanScheduleFlag
							,FactoryOrderFlag
							,isRefundableFlag
							,InventoryFlag
							,SurgeryCloseoutFlag
							,TechnicalProfileFlag
							,AdjustContractPaidAmountFlag
							,IsPriceAdjustableFlag
							,IsDiscountableFlag
							,IsActiveFlag
							,CreateDate
							,CreateUser
							,LastUpdate
							,LastUpdateUser
							,IsARTenderRequiredFlag
							,CanOrderFlag
							,IsQuantityAdjustableFlag
							,IsPhotoEnabledFlag
							,IsEXTOnlyProductFlag
							,HairSystemID
							,SaleCount
							,IsSalesCodeKitFlag
							,BiOGeneralLedgerID
							,EXTGeneralLedgerID
							,SURGeneralLedgerID
							,BrandID
							,Product
							,Size
							,IsRefundablePayment
							,IsNSFChargebackFee
							,InterCompanyPrice)
			SELECT SalesCodeSortOrder
				,@NewSalesCodeDescription
				,@NewSalesCodeDescriptionShort
				,SalesCodeTypeID
				,SalesCodeDepartmentID
				,VendorID
				,Barcode
				,ISNULL(@NewSalesCodePrice, PriceDefault) as PriceDefault
				,GLNumber
				,ISNULL(@ServiceDuration, ServiceDuration) as ServiceDuration
				,CanScheduleFlag
				,FactoryOrderFlag
				,@IsRefundable
				,InventoryFlag
				,SurgeryCloseoutFlag
				,TechnicalProfileFlag
				,AdjustContractPaidAmountFlag
				,IsPriceAdjustableFlag
				,@IsDiscountable
				,IsActiveFlag
				,GETUTCDATE() as CreateDate
				,@User
				,GETUTCDATE() as LastUpdate
				,@User
				,IsARTenderRequiredFlag
				,CanOrderFlag
				,IsQuantityAdjustableFlag
				,IsPhotoEnabledFlag
				,IsEXTOnlyProductFlag
				,HairSystemID
				,SaleCount
				,IsSalesCodeKitFlag
				,BiOGeneralLedgerID
				,EXTGeneralLedgerID
				,SURGeneralLedgerID
				,BrandID
				,ISNULL(@Product,Product) as Product
				,Size
				,IsRefundablePayment
				,IsNSFChargebackFee
				,ISNULL(@NewSalesCodeInterCompanyPrice, InterCompanyPrice) as InterCompanyPrice
			FROM cfgSalesCode sc
			Where sc.SalesCodeID = @CopyFromSalesCodeID


			--Get the New SalesCodeID
			SELECT @NewSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = @NewSalesCodeDescriptionShort

			-- Create the cfgAccumulatorJoin Record(s)
			INSERT INTO cfgAccumulatorJoin( AccumulatorJoinSortOrder
				,AccumulatorJoinTypeID
				,SalesCodeID
				,AccumulatorID
				,AccumulatorDataTypeID
				,AccumulatorActionTypeID
				,AccumulatorAdjustmentTypeID
				,IsActiveFlag
				,CreateDate
				,CreateUser
				,LastUpdate
				,LastUpdateUser
				,HairSystemOrderProcessID
				,IsEligibleForInterCompanyTransaction)
			SELECT AccumulatorJoinSortOrder
					,AccumulatorJoinTypeID
					,@NewSalesCodeID as SalesCodeID
					,AccumulatorID
					,AccumulatorDataTypeID
					,AccumulatorActionTypeID
					,AccumulatorAdjustmentTypeId
					,IsActiveFlag
					,GETUTCDATE() as CreateDate
					,@User
					,GETUTCDATE() as LastUpdate
					,@User
					,HairSystemOrderProcessID
					,IsEligibleForInterCompanyTransaction
			FROM cfgAccumulatorJoin
			WHERE SalesCodeID = @CopyFromSalesCodeID


			-- Create cfgMembershipRule Record(s)
			INSERT INTO cfgMembershipRule(MembershipRuleSortOrder
				,MembershipRuleTypeID
				,CurrentMembershipID
				,NewMembershipID
				,SalesCodeID
				,Interval
				,UnitOfMeasureID
				,MembershipScreen1ID
				,MembershipScreen2ID
				,MembershipScreen3ID
				,IsActiveFlag
				,CreateUser
				,CreateDate
				,LastUpdateUser
				,LastUpdate
				,CurrentMembershipStatusID
				,NewMembershipStatusID
				,MembershipCancelRuleID
				,MembershipCancelSalesCodeID
				,AdditionalNewMembershipID
				,CenterBusinessTypeID
				,FromCancelledMembershipSalesCodeID)
			  SELECT MembershipRuleSortOrder
				,MembershipRuleTypeID
				,CurrentMembershipID
				,NewMembershipID
				,@NewSalesCodeID as SalesCodeID
				,Interval
				,UnitOfMeasureID
				,MembershipScreen1ID
				,MembershipScreen2ID
				,MembershipScreen3ID
				,IsActiveFlag
				,@User
				,GETUTCDATE() as CreateDate
				,@User
				,GETUTCDATE() as LastUpdate
				,CurrentMembershipStatusID
				,NewMembershipStatusID
				,MembershipCancelRuleID
				,MembershipCancelSalesCodeID
				,AdditionalNewMembershipID
				,CenterBusinessTypeID
				,FromCancelledMembershipSalesCodeID
			  FROM cfgMembershipRule
			  WHERE SalesCodeID = @CopyFromSalesCodeID

			  -- cfgMembershipRule : MembershipCancelSalesCodeID
			  INSERT INTO cfgMembershipRule(MembershipRuleSortOrder
				,MembershipRuleTypeID
				,CurrentMembershipID
				,NewMembershipID
				,SalesCodeID
				,Interval
				,UnitOfMeasureID
				,MembershipScreen1ID
				,MembershipScreen2ID
				,MembershipScreen3ID
				,IsActiveFlag
				,CreateUser
				,CreateDate
				,LastUpdateUser
				,LastUpdate
				,CurrentMembershipStatusID
				,NewMembershipStatusID
				,MembershipCancelRuleID
				,MembershipCancelSalesCodeID
				,AdditionalNewMembershipID
				,CenterBusinessTypeID
				,FromCancelledMembershipSalesCodeID)
			  SELECT MembershipRuleSortOrder
				,MembershipRuleTypeID
				,CurrentMembershipID
				,NewMembershipID
				,SalesCodeID
				,Interval
				,UnitOfMeasureID
				,MembershipScreen1ID
				,MembershipScreen2ID
				,MembershipScreen3ID
				,IsActiveFlag
				,@User
				,GETUTCDATE() as CreateDate
				,@User
				,GETUTCDATE() as LastUpdate
				,CurrentMembershipStatusID
				,NewMembershipStatusID
				,MembershipCancelRuleID
				,@NewSalesCodeID as MembershipCancelSalesCodeID
				,AdditionalNewMembershipID
				,CenterBusinessTypeID
				,FromCancelledMembershipSalesCodeID
			  FROM cfgMembershipRule
			  WHERE MembershipCancelSalesCodeID = @CopyFromSalesCodeID

			  -- cfgMembershipRule : FromCancelledMembershipSalesCodeID
			  INSERT INTO cfgMembershipRule(MembershipRuleSortOrder
				,MembershipRuleTypeID
				,CurrentMembershipID
				,NewMembershipID
				,SalesCodeID
				,Interval
				,UnitOfMeasureID
				,MembershipScreen1ID
				,MembershipScreen2ID
				,MembershipScreen3ID
				,IsActiveFlag
				,CreateUser
				,CreateDate
				,LastUpdateUser
				,LastUpdate
				,CurrentMembershipStatusID
				,NewMembershipStatusID
				,MembershipCancelRuleID
				,MembershipCancelSalesCodeID
				,AdditionalNewMembershipID
				,CenterBusinessTypeID
				,FromCancelledMembershipSalesCodeID)
			  SELECT MembershipRuleSortOrder
				,MembershipRuleTypeID
				,CurrentMembershipID
				,NewMembershipID
				,SalesCodeID
				,Interval
				,UnitOfMeasureID
				,MembershipScreen1ID
				,MembershipScreen2ID
				,MembershipScreen3ID
				,IsActiveFlag
				,@User
				,GETUTCDATE() as CreateDate
				,@User
				,GETUTCDATE() as LastUpdate
				,CurrentMembershipStatusID
				,NewMembershipStatusID
				,MembershipCancelRuleID
				,MembershipCancelSalesCodeID
				,AdditionalNewMembershipID
				,CenterBusinessTypeID
				,@NewSalesCodeID as FromCancelledMembershipSalesCodeID
			  FROM cfgMembershipRule
			  WHERE FromCancelledMembershipSalesCodeID = @CopyFromSalesCodeID

			  --cfgSalesCodeCenter
			  INSERT INTO cfgSalesCodeCenter( CenterID
					,SalesCodeID
					,PriceRetail
					,TaxRate1ID
					,TaxRate2ID
					,QuantityOnHand
					,QuantityOnOrdered
					,QuantityTotalSold
					,QuantityMaxLevel
					,QuantityMinLevel
					,IsActiveFlag
					,CreateDate
					,CreateUser
					,LastUpdate
					,LastUpdateUser)
			 SELECT CenterID
				,@NewSalesCodeID as SalesCodeID
				,IIF(@CopyCenterPrice=1, PriceRetail, NULL) as PriceRetail
				,TaxRate1ID
				,TaxRate2ID
				,QuantityOnHand
				,QuantityOnOrdered
				,QuantityTotalSold
				,QuantityMaxLevel
				,QuantityMinLevel
				,IsActiveFlag
				,GETUTCDATE() as CreateDAte
				,@User
				,GETUTCDATE() as LastUpdate
				,@User
			 FROM cfgSalesCodeCenter
			 Where SalesCodeID = @CopyFromSalesCodeID

			 -- cfgSalesCodeMembership
			 INSERT INTO cfgSalesCodeMembership(SalesCodeCenterID
				,MembershipID
				,Price
				,TaxRate1ID
				,TaxRate2ID
				,IsActiveFlag
				,CreateDate
				,CreateUser
				,LastUpdate
				,LastUpdateUser)
			SELECT sccNew.SalesCodeCenterID
				,scm.MembershipID
				,IIF(@CopyMembershipPrice=1, scm.Price, NULL) as Price
				,scm.TaxRate1ID
				,scm.TaxRate2ID
				,scm.IsActiveFlag
				,GETUTCDATE() as CreateDate
				,@User
				,GETUTCDATE() as LastUpdate
				,@User
			 FROM cfgSalesCodeCenter scc
				inner join cfgSalesCodeCenter sccNew on scc.CenterID = sccNew.CenterID
								AND sccNew.SalesCodeID = @NewSalesCodeID
				inner join cfgSalesCodeMembership scm on scm.SalesCodeCenterID = scc.SalesCodeCenterID
			 WHERE scc.SalesCodeID = @CopyFromSalesCodeID

		END
	ELSE
		BEGIN
			RAISERROR ('New Sales Code Description Short must be unique', 16, 1)
		END
END
GO
