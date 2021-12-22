/* CreateDate: 01/08/2021 15:21:53.320 , ModifyDate: 01/08/2021 15:21:53.320 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_bi_ent_ddsDimBroadcastDate]
		@c1 int = NULL,
		@c2 smalldatetime = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 varchar(50) = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [bi_ent_dds].[DimBroadcastDate] set
		[DateKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [DateKey] end,
		[Date] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Date] end,
		[Year] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Year] end,
		[Quarter] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Quarter] end,
		[Month] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Month] end,
		[MonthName] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [MonthName] end,
		[Week] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Week] end,
		[Day] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Day] end,
		[msrepl_tran_version] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [msrepl_tran_version] end
	where [DateKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DateKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_ent_dds].[DimBroadcastDate]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_ent_dds].[DimBroadcastDate] set
		[Date] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Date] end,
		[Year] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Year] end,
		[Quarter] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Quarter] end,
		[Month] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Month] end,
		[MonthName] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [MonthName] end,
		[Week] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Week] end,
		[Day] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Day] end,
		[msrepl_tran_version] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [msrepl_tran_version] end
	where [DateKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DateKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_ent_dds].[DimBroadcastDate]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
