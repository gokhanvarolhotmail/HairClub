/* CreateDate: 09/03/2021 09:37:05.757 , ModifyDate: 09/03/2021 09:37:05.757 */
GO
create procedure [sp_MSupd_bi_mktg_ddsDimContactEmail]
		@c1 int = NULL,
		@c2 nvarchar(10) = NULL,
		@c3 nvarchar(10) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 nvarchar(100) = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 nchar(1) = NULL,
		@c8 tinyint = NULL,
		@c9 datetime = NULL,
		@c10 datetime = NULL,
		@c11 varchar(200) = NULL,
		@c12 tinyint = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@c15 nvarchar(18) = NULL,
		@c16 nvarchar(18) = NULL,
		@c17 varbinary(128) = NULL,
		@c18 nvarchar(18) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_mktg_dds].[DimContactEmail] set
		[ContactEmailSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ContactEmailSSID] end,
		[ContactSSID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ContactSSID] end,
		[EmailTypeCode] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EmailTypeCode] end,
		[Email] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Email] end,
		[Description] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Description] end,
		[PrimaryFlag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [PrimaryFlag] end,
		[RowIsCurrent] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [UpdateAuditKey] end,
		[SFDC_LeadID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [SFDC_LeadID] end,
		[SFDC_LeadEmailID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [SFDC_LeadEmailID] end,
		[ContactEmailHashed] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ContactEmailHashed] end,
		[SFDC_PersonAccountID] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [SFDC_PersonAccountID] end
	where [ContactEmailKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ContactEmailKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimContactEmail]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
