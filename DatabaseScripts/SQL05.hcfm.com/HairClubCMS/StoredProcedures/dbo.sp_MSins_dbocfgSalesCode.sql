/* CreateDate: 12/21/2020 07:17:20.600 , ModifyDate: 12/21/2020 07:17:20.600 */
GO
create procedure [sp_MSins_dbocfgSalesCode]     @c1 int,     @c2 int,     @c3 nvarchar(50),     @c4 nvarchar(15),     @c5 int,     @c6 int,     @c7 int,     @c8 nvarchar(25),     @c9 money,     @c10 int,     @c11 int,     @c12 bit,     @c13 bit,     @c14 bit,     @c15 bit,     @c16 bit,     @c17 bit,     @c18 bit,     @c19 bit,     @c20 bit,     @c21 bit,     @c22 datetime,     @c23 nvarchar(25),     @c24 datetime,     @c25 nvarchar(25),     @c26 bit,     @c27 bit,     @c28 bit,     @c29 bit,     @c30 bit,     @c31 int,     @c32 int,     @c33 bit,     @c34 int,     @c35 int,     @c36 int,     @c37 int,     @c38 nvarchar(50),     @c39 nvarchar(20),     @c40 bit,     @c41 bit,     @c42 money,     @c43 bit,     @c44 int,     @c45 nvarchar(100),     @c46 bit,     @c47 bit,     @c48 bit,     @c49 nvarchar(300),     @c50 int,     @c51 int,     @c52 int,     @c53 bit,     @c54 bit,     @c55 bit,     @c56 nvarchar(50),     @c57 int,     @c58 nvarchar(50),     @c59 bit as begin   	insert into [dbo].[cfgSalesCode] ( 		[SalesCodeID], 		[SalesCodeSortOrder], 		[SalesCodeDescription], 		[SalesCodeDescriptionShort], 		[SalesCodeTypeID], 		[SalesCodeDepartmentID], 		[VendorID], 		[Barcode], 		[PriceDefault], 		[GLNumber], 		[ServiceDuration], 		[CanScheduleFlag], 		[FactoryOrderFlag], 		[IsRefundableFlag], 		[InventoryFlag], 		[SurgeryCloseoutFlag], 		[TechnicalProfileFlag], 		[AdjustContractPaidAmountFlag], 		[IsPriceAdjustableFlag], 		[IsDiscountableFlag], 		[IsActiveFlag], 		[CreateDate], 		[CreateUser], 		[LastUpdate], 		[LastUpdateUser], 		[UpdateStamp], 		[IsARTenderRequiredFlag], 		[CanOrderFlag], 		[IsQuantityAdjustableFlag], 		[IsPhotoEnabledFlag], 		[IsEXTOnlyProductFlag], 		[HairSystemID], 		[SaleCount], 		[IsSalesCodeKitFlag], 		[BIOGeneralLedgerID], 		[EXTGeneralLedgerID], 		[SURGeneralLedgerID], 		[BrandID], 		[Product], 		[Size], 		[IsRefundablePayment], 		[IsNSFChargebackFee], 		[InterCompanyPrice], 		[IsQuantityRequired], 		[XTRGeneralLedgerID], 		[DescriptionResourceKey], 		[IsBosleySalesCode], 		[IsVisibleToConsultant], 		[IsSerialized], 		[SerialNumberRegEx], 		[QuantityPerPack], 		[PackUnitOfMeasureID], 		[InventorySalesCodeID], 		[IsVisibleToClient], 		[CanBeManagedByClient], 		[IsManagedByClientOnly], 		[ClientDescription], 		[MDPGeneralLedgerID], 		[PackSKU], 		[IsBackBarApproved] 	) values ( 		@c1, 		@c2, 		@c3, 		@c4, 		@c5, 		@c6, 		@c7, 		@c8, 		@c9, 		@c10, 		@c11, 		@c12, 		@c13, 		@c14, 		@c15, 		@c16, 		@c17, 		@c18, 		@c19, 		@c20, 		@c21, 		@c22, 		@c23, 		@c24, 		@c25, 		default, 		@c26, 		@c27, 		@c28, 		@c29, 		@c30, 		@c31, 		@c32, 		@c33, 		@c34, 		@c35, 		@c36, 		@c37, 		@c38, 		@c39, 		@c40, 		@c41, 		@c42, 		@c43, 		@c44, 		@c45, 		@c46, 		@c47, 		@c48, 		@c49, 		@c50, 		@c51, 		@c52, 		@c53, 		@c54, 		@c55, 		@c56, 		@c57, 		@c58, 		@c59	)  end    --
GO