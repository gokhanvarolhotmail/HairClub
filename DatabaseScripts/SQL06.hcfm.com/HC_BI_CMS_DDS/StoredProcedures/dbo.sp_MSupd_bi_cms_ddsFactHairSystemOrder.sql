/* CreateDate: 10/03/2019 23:03:42.310 , ModifyDate: 10/03/2019 23:03:42.310 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_bi_cms_ddsFactHairSystemOrder]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 datetime = NULL,
		@c6 int = NULL,
		@c7 datetime = NULL,
		@c8 int = NULL,
		@c9 datetime = NULL,
		@c10 int = NULL,
		@c11 datetime = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 int = NULL,
		@c15 datetime = NULL,
		@c16 int = NULL,
		@c17 int = NULL,
		@c18 int = NULL,
		@c19 uniqueidentifier = NULL,
		@c20 uniqueidentifier = NULL,
		@c21 int = NULL,
		@c22 int = NULL,
		@c23 int = NULL,
		@c24 int = NULL,
		@c25 int = NULL,
		@c26 int = NULL,
		@c27 int = NULL,
		@c28 int = NULL,
		@c29 int = NULL,
		@c30 int = NULL,
		@c31 int = NULL,
		@c32 int = NULL,
		@c33 decimal(10,4) = NULL,
		@c34 decimal(10,4) = NULL,
		@c35 decimal(21,6) = NULL,
		@c36 int = NULL,
		@c37 nvarchar(50) = NULL,
		@c38 int = NULL,
		@c39 decimal(21,6) = NULL,
		@c40 decimal(21,6) = NULL,
		@c41 decimal(21,6) = NULL,
		@c42 int = NULL,
		@c43 varchar(50) = NULL,
		@c44 int = NULL,
		@c45 varchar(50) = NULL,
		@c46 bit = NULL,
		@c47 int = NULL,
		@c48 int = NULL,
		@c49 int = NULL,
		@c50 int = NULL,
		@c51 int = NULL,
		@c52 int = NULL,
		@c53 int = NULL,
		@c54 uniqueidentifier = NULL,
		@c55 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(7)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[FactHairSystemOrder] set
		[HairSystemOrderSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemOrderSSID] end,
		[HairSystemOrderNumber] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemOrderNumber] end,
		[HairSystemOrderDateKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemOrderDateKey] end,
		[HairSystemOrderDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HairSystemOrderDate] end,
		[HairSystemDueDateKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [HairSystemDueDateKey] end,
		[HairSystemDueDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [HairSystemDueDate] end,
		[HairSystemAllocationDateKey] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [HairSystemAllocationDateKey] end,
		[HairSystemAlocationDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [HairSystemAlocationDate] end,
		[HairSystemReceivedDateKey] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [HairSystemReceivedDateKey] end,
		[HairSystemReceivedDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [HairSystemReceivedDate] end,
		[HairSystemShippedDateKey] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [HairSystemShippedDateKey] end,
		[HairSystemShippedDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [HairSystemShippedDate] end,
		[HairSystemAppliedDateKey] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [HairSystemAppliedDateKey] end,
		[HairSystemAppliedDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [HairSystemAppliedDate] end,
		[CenterKey] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CenterKey] end,
		[ClientKey] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ClientKey] end,
		[ClientMembershipKey] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [ClientMembershipKey] end,
		[OrigClientSSID] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [OrigClientSSID] end,
		[OrigClientMembershipSSID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [OrigClientMembershipSSID] end,
		[HairSystemHairLengthKey] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [HairSystemHairLengthKey] end,
		[HairSystemTypeKey] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [HairSystemTypeKey] end,
		[HairSystemTextureKey] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [HairSystemTextureKey] end,
		[HairSystemMatrixColorKey] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [HairSystemMatrixColorKey] end,
		[HairSystemDensityKey] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [HairSystemDensityKey] end,
		[HairSystemFrontalDensityKey] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [HairSystemFrontalDensityKey] end,
		[HairSystemStyleKey] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [HairSystemStyleKey] end,
		[HairSystemDesignTemplateKey] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [HairSystemDesignTemplateKey] end,
		[HairSystemRecessionKey] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [HairSystemRecessionKey] end,
		[HairSystemTopHairColorKey] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [HairSystemTopHairColorKey] end,
		[MeasurementsByEmployeeKey] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [MeasurementsByEmployeeKey] end,
		[CapSizeKey] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [CapSizeKey] end,
		[TemplateWidth] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [TemplateWidth] end,
		[TemplateHeight] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [TemplateHeight] end,
		[TemplateArea] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [TemplateArea] end,
		[HairSystemVendorContractKey] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [HairSystemVendorContractKey] end,
		[FactorySSID] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [FactorySSID] end,
		[HairSystemOrderStatusKey] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [HairSystemOrderStatusKey] end,
		[CostContract] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [CostContract] end,
		[CostActual] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [CostActual] end,
		[PriceContract] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [PriceContract] end,
		[HairSystemRepairReasonSSID] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [HairSystemRepairReasonSSID] end,
		[HairSystemRepairReasonDescription] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [HairSystemRepairReasonDescription] end,
		[HairSystemRedoReasonSSID] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [HairSystemRedoReasonSSID] end,
		[HairSystemRedoReasonDescription] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [HairSystemRedoReasonDescription] end,
		[IsOnHoldForReviewFlag] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [IsOnHoldForReviewFlag] end,
		[IsSampleOrderFlag] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [IsSampleOrderFlag] end,
		[IsRepairOrderFlag] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [IsRepairOrderFlag] end,
		[IsRedoOrderFlag] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [IsRedoOrderFlag] end,
		[IsRushOrderFlag] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [IsRushOrderFlag] end,
		[IsStockInventoryFlag] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [IsStockInventoryFlag] end,
		[InsertAuditKey] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [msrepl_tran_version] end,
		[ClientHomeCenterKey] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [ClientHomeCenterKey] end
	where [HairSystemOrderKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemOrderKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[FactHairSystemOrder]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
