create procedure [sp_MSupd_bi_mktg_ddsDimSource]
		@c1 int = NULL,
		@c2 nvarchar(30) = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(50) = NULL,
		@c5 nvarchar(50) = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 nvarchar(50) = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(50) = NULL,
		@c11 tinyint = NULL,
		@c12 datetime = NULL,
		@c13 datetime = NULL,
		@c14 varchar(200) = NULL,
		@c15 tinyint = NULL,
		@c16 int = NULL,
		@c17 int = NULL,
		@c18 nvarchar(80) = NULL,
		@c19 nvarchar(50) = NULL,
		@c20 nvarchar(50) = NULL,
		@c21 nvarchar(100) = NULL,
		@c22 nvarchar(50) = NULL,
		@c23 nvarchar(50) = NULL,
		@c24 nvarchar(100) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_mktg_dds].[DimSource] set
		[SourceSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SourceSSID] end,
		[SourceName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SourceName] end,
		[Media] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Media] end,
		[Level02Location] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Level02Location] end,
		[Level03Language] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Level03Language] end,
		[Level04Format] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Level04Format] end,
		[Level05Creative] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Level05Creative] end,
		[Number] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Number] end,
		[NumberType] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [NumberType] end,
		[RowIsCurrent] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [UpdateAuditKey] end,
		[CampaignName] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CampaignName] end,
		[Channel] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Channel] end,
		[Gender] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Gender] end,
		[PromoCode] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [PromoCode] end,
		[OwnerType] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [OwnerType] end,
		[Origin] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [Origin] end,
		[Content] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [Content] end
	where [SourceKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SourceKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimSource]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
