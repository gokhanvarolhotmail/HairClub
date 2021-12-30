/* CreateDate: 05/05/2020 17:42:48.143 , ModifyDate: 05/05/2020 17:42:48.143 */
GO
create procedure [sp_MSupd_dbodatSalesOrderDetail]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 decimal(21,6) = NULL,
		@c7 money = NULL,
		@c8 money = NULL,
		@c9 money = NULL,
		@c10 decimal(6,5) = NULL,
		@c11 decimal(6,5) = NULL,
		@c12 bit = NULL,
		@c13 uniqueidentifier = NULL,
		@c14 int = NULL,
		@c15 money = NULL,
		@c16 uniqueidentifier = NULL,
		@c17 uniqueidentifier = NULL,
		@c18 uniqueidentifier = NULL,
		@c19 uniqueidentifier = NULL,
		@c20 uniqueidentifier = NULL,
		@c21 int = NULL,
		@c22 datetime = NULL,
		@c23 nvarchar(25) = NULL,
		@c24 datetime = NULL,
		@c25 nvarchar(25) = NULL,
		@c26 int = NULL,
		@c27 varchar(10) = NULL,
		@c28 varchar(10) = NULL,
		@c29 decimal(21,6) = NULL,
		@c30 int = NULL,
		@c31 int = NULL,
		@c32 uniqueidentifier = NULL,
		@c33 int = NULL,
		@c34 bit = NULL,
		@c35 int = NULL,
		@c36 int = NULL,
		@c37 nvarchar(200) = NULL,
		@c38 nvarchar(50) = NULL,
		@c39 nvarchar(20) = NULL,
		@c40 uniqueidentifier = NULL,
		@c41 datetime = NULL,
		@c42 bit = NULL,
		@c43 money = NULL,
		@c44 int = NULL,
		@c45 int = NULL,
		@c46 int = NULL,
		@c47 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(6)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datSalesOrderDetail] set
		[SalesOrderDetailGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [SalesOrderDetailGUID] end,
		[TransactionNumber_Temp] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TransactionNumber_Temp] end,
		[SalesOrderGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesOrderGUID] end,
		[SalesCodeID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SalesCodeID] end,
		[Quantity] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Quantity] end,
		[Price] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Price] end,
		[Discount] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Discount] end,
		[Tax1] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Tax1] end,
		[Tax2] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Tax2] end,
		[TaxRate1] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [TaxRate1] end,
		[TaxRate2] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [TaxRate2] end,
		[IsRefundedFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsRefundedFlag] end,
		[RefundedSalesOrderDetailGUID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [RefundedSalesOrderDetailGUID] end,
		[RefundedTotalQuantity] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [RefundedTotalQuantity] end,
		[RefundedTotalPrice] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [RefundedTotalPrice] end,
		[Employee1GUID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Employee1GUID] end,
		[Employee2GUID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Employee2GUID] end,
		[Employee3GUID] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Employee3GUID] end,
		[Employee4GUID] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Employee4GUID] end,
		[PreviousClientMembershipGUID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [PreviousClientMembershipGUID] end,
		[NewCenterID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [NewCenterID] end,
		[CreateDate] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [LastUpdateUser] end,
		[Center_Temp] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [Center_Temp] end,
		[performer_temp] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [performer_temp] end,
		[performer2_temp] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [performer2_temp] end,
		[Member1Price_temp] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [Member1Price_temp] end,
		[CancelReasonID] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [CancelReasonID] end,
		[EntrySortOrder] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [EntrySortOrder] end,
		[HairSystemOrderGUID] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [HairSystemOrderGUID] end,
		[DiscountTypeID] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [DiscountTypeID] end,
		[BenefitTrackingEnabledFlag] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [BenefitTrackingEnabledFlag] end,
		[MembershipPromotionID] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [MembershipPromotionID] end,
		[MembershipOrderReasonID] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [MembershipOrderReasonID] end,
		[MembershipNotes] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [MembershipNotes] end,
		[GenericSalesCodeDescription] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [GenericSalesCodeDescription] end,
		[SalesCodeSerialNumber] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [SalesCodeSerialNumber] end,
		[WriteOffSalesOrderDetailGUID] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [WriteOffSalesOrderDetailGUID] end,
		[NSFBouncedDate] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [NSFBouncedDate] end,
		[IsWrittenOffFlag] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [IsWrittenOffFlag] end,
		[InterCompanyPrice] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [InterCompanyPrice] end,
		[TaxType1ID] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [TaxType1ID] end,
		[TaxType2ID] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [TaxType2ID] end,
		[ClientMembershipAddOnID] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [ClientMembershipAddOnID] end,
		[NCCMembershipPromotionID] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [NCCMembershipPromotionID] end
	where [SalesOrderDetailGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesOrderDetailGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSalesOrderDetail]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datSalesOrderDetail] set
		[TransactionNumber_Temp] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TransactionNumber_Temp] end,
		[SalesOrderGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesOrderGUID] end,
		[SalesCodeID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SalesCodeID] end,
		[Quantity] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Quantity] end,
		[Price] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Price] end,
		[Discount] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Discount] end,
		[Tax1] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Tax1] end,
		[Tax2] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Tax2] end,
		[TaxRate1] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [TaxRate1] end,
		[TaxRate2] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [TaxRate2] end,
		[IsRefundedFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsRefundedFlag] end,
		[RefundedSalesOrderDetailGUID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [RefundedSalesOrderDetailGUID] end,
		[RefundedTotalQuantity] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [RefundedTotalQuantity] end,
		[RefundedTotalPrice] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [RefundedTotalPrice] end,
		[Employee1GUID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Employee1GUID] end,
		[Employee2GUID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Employee2GUID] end,
		[Employee3GUID] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Employee3GUID] end,
		[Employee4GUID] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Employee4GUID] end,
		[PreviousClientMembershipGUID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [PreviousClientMembershipGUID] end,
		[NewCenterID] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [NewCenterID] end,
		[CreateDate] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [LastUpdateUser] end,
		[Center_Temp] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [Center_Temp] end,
		[performer_temp] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [performer_temp] end,
		[performer2_temp] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [performer2_temp] end,
		[Member1Price_temp] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [Member1Price_temp] end,
		[CancelReasonID] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [CancelReasonID] end,
		[EntrySortOrder] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [EntrySortOrder] end,
		[HairSystemOrderGUID] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [HairSystemOrderGUID] end,
		[DiscountTypeID] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [DiscountTypeID] end,
		[BenefitTrackingEnabledFlag] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [BenefitTrackingEnabledFlag] end,
		[MembershipPromotionID] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [MembershipPromotionID] end,
		[MembershipOrderReasonID] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [MembershipOrderReasonID] end,
		[MembershipNotes] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [MembershipNotes] end,
		[GenericSalesCodeDescription] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [GenericSalesCodeDescription] end,
		[SalesCodeSerialNumber] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [SalesCodeSerialNumber] end,
		[WriteOffSalesOrderDetailGUID] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [WriteOffSalesOrderDetailGUID] end,
		[NSFBouncedDate] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [NSFBouncedDate] end,
		[IsWrittenOffFlag] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [IsWrittenOffFlag] end,
		[InterCompanyPrice] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [InterCompanyPrice] end,
		[TaxType1ID] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [TaxType1ID] end,
		[TaxType2ID] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [TaxType2ID] end,
		[ClientMembershipAddOnID] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [ClientMembershipAddOnID] end,
		[NCCMembershipPromotionID] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [NCCMembershipPromotionID] end
	where [SalesOrderDetailGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesOrderDetailGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datSalesOrderDetail]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
