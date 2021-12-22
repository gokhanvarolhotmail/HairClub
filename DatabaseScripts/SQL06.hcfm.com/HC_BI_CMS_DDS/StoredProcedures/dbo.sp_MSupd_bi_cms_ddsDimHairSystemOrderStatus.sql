create procedure [sp_MSupd_bi_cms_ddsDimHairSystemOrderStatus]
		@c1 int = NULL,
		@c2 nvarchar(50) = NULL,
		@c3 int = NULL,
		@c4 nvarchar(50) = NULL,
		@c5 nvarchar(10) = NULL,
		@c6 nchar(1) = NULL,
		@c7 nchar(1) = NULL,
		@c8 nchar(1) = NULL,
		@c9 nchar(1) = NULL,
		@c10 nchar(1) = NULL,
		@c11 nchar(1) = NULL,
		@c12 nchar(1) = NULL,
		@c13 nchar(1) = NULL,
		@c14 nchar(1) = NULL,
		@c15 nchar(1) = NULL,
		@c16 nchar(1) = NULL,
		@c17 nchar(1) = NULL,
		@c18 nchar(1) = NULL,
		@c19 tinyint = NULL,
		@c20 datetime = NULL,
		@c21 datetime = NULL,
		@c22 varchar(200) = NULL,
		@c23 tinyint = NULL,
		@c24 int = NULL,
		@c25 int = NULL,
		@c26 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimHairSystemOrderStatus] set
		[HairSystemOrderStatusSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemOrderStatusSSID] end,
		[HairSystemOrderStatusSortOrder] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemOrderStatusSortOrder] end,
		[HairSystemOrderStatusDescription] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemOrderStatusDescription] end,
		[HairSystemOrderStatusDescriptionShort] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HairSystemOrderStatusDescriptionShort] end,
		[CanApplyFlag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CanApplyFlag] end,
		[CanTransferFlag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CanTransferFlag] end,
		[CanEditFlag] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CanEditFlag] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsActiveFlag] end,
		[CanCancelFlag] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CanCancelFlag] end,
		[IsPreallocationFlag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [IsPreallocationFlag] end,
		[CanRedoFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CanRedoFlag] end,
		[CanRepairFlag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CanRepairFlag] end,
		[ShowInHistoryFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ShowInHistoryFlag] end,
		[CanAddToStockFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CanAddToStockFlag] end,
		[IncludeInMembershipCountFlag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IncludeInMembershipCountFlag] end,
		[CanRequestCreditFlag] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CanRequestCreditFlag] end,
		[Active] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Active] end,
		[RowIsCurrent] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [msrepl_tran_version] end
	where [HairSystemOrderStatusKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemOrderStatusKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimHairSystemOrderStatus]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
