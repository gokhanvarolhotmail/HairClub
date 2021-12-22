create procedure [sp_MSupd_bi_mktg_ddsDimSalesType]
		@c1 int = NULL,
		@c2 nvarchar(10) = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 tinyint = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 varchar(200) = NULL,
		@c9 tinyint = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 money = NULL,
		@c13 money = NULL,
		@c14 money = NULL,
		@c15 money = NULL,
		@c16 nvarchar(10) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_mktg_dds].[DimSalesType] set
		[SalesTypeSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SalesTypeSSID] end,
		[SalesTypeDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesTypeDescription] end,
		[SalesTypeDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SalesTypeDescriptionShort] end,
		[RowIsCurrent] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [UpdateAuditKey] end,
		[LTVMale] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LTVMale] end,
		[LTVFemale] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LTVFemale] end,
		[LTVMaleYearly] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LTVMaleYearly] end,
		[LTVFemaleYearly] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LTVFemaleYearly] end,
		[BusinessSegment] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [BusinessSegment] end
	where [SalesTypeKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesTypeKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimSalesType]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
