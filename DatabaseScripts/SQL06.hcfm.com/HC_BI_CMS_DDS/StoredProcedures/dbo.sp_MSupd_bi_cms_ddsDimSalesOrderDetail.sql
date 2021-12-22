/* CreateDate: 10/03/2019 23:03:41.817 , ModifyDate: 10/03/2019 23:03:41.817 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_bi_cms_ddsDimSalesOrderDetail]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 uniqueidentifier = NULL,
		@c6 datetime = NULL,
		@c7 int = NULL,
		@c8 nvarchar(50) = NULL,
		@c9 nvarchar(15) = NULL,
		@c10 bit = NULL,
		@c11 bit = NULL,
		@c12 int = NULL,
		@c13 money = NULL,
		@c14 money = NULL,
		@c15 money = NULL,
		@c16 money = NULL,
		@c17 money = NULL,
		@c18 money = NULL,
		@c19 bit = NULL,
		@c20 uniqueidentifier = NULL,
		@c21 int = NULL,
		@c22 money = NULL,
		@c23 uniqueidentifier = NULL,
		@c24 nvarchar(50) = NULL,
		@c25 nvarchar(50) = NULL,
		@c26 nvarchar(5) = NULL,
		@c27 uniqueidentifier = NULL,
		@c28 nvarchar(50) = NULL,
		@c29 nvarchar(50) = NULL,
		@c30 nvarchar(5) = NULL,
		@c31 uniqueidentifier = NULL,
		@c32 nvarchar(50) = NULL,
		@c33 nvarchar(50) = NULL,
		@c34 nvarchar(5) = NULL,
		@c35 uniqueidentifier = NULL,
		@c36 nvarchar(50) = NULL,
		@c37 nvarchar(50) = NULL,
		@c38 nvarchar(5) = NULL,
		@c39 uniqueidentifier = NULL,
		@c40 int = NULL,
		@c41 tinyint = NULL,
		@c42 datetime = NULL,
		@c43 datetime = NULL,
		@c44 varchar(200) = NULL,
		@c45 tinyint = NULL,
		@c46 int = NULL,
		@c47 int = NULL,
		@c48 binary(8) = NULL,
		@c49 uniqueidentifier = NULL,
		@c50 varchar(50) = NULL,
		@c51 varchar(50) = NULL,
		@c52 money = NULL,
		@c53 int = NULL,
		@c54 int = NULL,
		@c55 nvarchar(10) = NULL,
		@c56 uniqueidentifier = NULL,
		@c57 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(8)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimSalesOrderDetail] set
		[SalesOrderDetailSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SalesOrderDetailSSID] end,
		[TransactionNumber_Temp] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TransactionNumber_Temp] end,
		[SalesOrderKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SalesOrderKey] end,
		[SalesOrderSSID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SalesOrderSSID] end,
		[OrderDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [OrderDate] end,
		[SalesCodeSSID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [SalesCodeSSID] end,
		[SalesCodeDescription] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [SalesCodeDescription] end,
		[SalesCodeDescriptionShort] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [SalesCodeDescriptionShort] end,
		[IsVoidedFlag] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsVoidedFlag] end,
		[IsClosedFlag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [IsClosedFlag] end,
		[Quantity] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Quantity] end,
		[Price] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Price] end,
		[Discount] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Discount] end,
		[Tax1] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Tax1] end,
		[Tax2] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Tax2] end,
		[TaxRate1] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [TaxRate1] end,
		[TaxRate2] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [TaxRate2] end,
		[IsRefundedFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsRefundedFlag] end,
		[RefundedSalesOrderDetailSSID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [RefundedSalesOrderDetailSSID] end,
		[RefundedTotalQuantity] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [RefundedTotalQuantity] end,
		[RefundedTotalPrice] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [RefundedTotalPrice] end,
		[Employee1SSID] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [Employee1SSID] end,
		[Employee1FirstName] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [Employee1FirstName] end,
		[Employee1LastName] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [Employee1LastName] end,
		[Employee1Initials] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [Employee1Initials] end,
		[Employee2SSID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [Employee2SSID] end,
		[Employee2FirstName] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [Employee2FirstName] end,
		[Employee2LastName] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [Employee2LastName] end,
		[Employee2Initials] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [Employee2Initials] end,
		[Employee3SSID] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [Employee3SSID] end,
		[Employee3FirstName] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [Employee3FirstName] end,
		[Employee3LastName] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [Employee3LastName] end,
		[Employee3Initials] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [Employee3Initials] end,
		[Employee4SSID] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [Employee4SSID] end,
		[Employee4FirstName] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [Employee4FirstName] end,
		[Employee4LastName] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [Employee4LastName] end,
		[Employee4Initials] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [Employee4Initials] end,
		[PreviousClientMembershipSSID] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [PreviousClientMembershipSSID] end,
		[NewCenterSSID] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [NewCenterSSID] end,
		[RowIsCurrent] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [UpdateAuditKey] end,
		[RowTimeStamp] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [RowTimeStamp] end,
		[msrepl_tran_version] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [msrepl_tran_version] end,
		[Performer_temp] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [Performer_temp] end,
		[Performer2_temp] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [Performer2_temp] end,
		[Member1Price_Temp] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [Member1Price_Temp] end,
		[CancelReasonID] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [CancelReasonID] end,
		[MembershipOrderReasonID] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [MembershipOrderReasonID] end,
		[MembershipPromotion] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [MembershipPromotion] end,
		[HairSystemOrderSSID] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [HairSystemOrderSSID] end,
		[ClientMembershipAddOnID] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [ClientMembershipAddOnID] end
	where [SalesOrderDetailKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesOrderDetailKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimSalesOrderDetail]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
