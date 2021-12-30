/* CreateDate: 05/05/2020 17:42:55.480 , ModifyDate: 05/05/2020 17:42:55.480 */
GO
create procedure [sp_MSupd_dbomtnTREBebackExport]
		@c1 int = NULL,
		@c2 nvarchar(50) = NULL,
		@c3 int = NULL,
		@c4 nvarchar(50) = NULL,
		@c5 nvarchar(50) = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 bit = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[mtnTREBebackExport] set
		[ContactID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ContactID] end,
		[CenterID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterID] end,
		[Performer] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Performer] end,
		[ResultCode] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ResultCode] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[ProcessedDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ProcessedDate] end,
		[IsProcessedFlag] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsProcessedFlag] end
	where [TREBebackExportID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[TREBebackExportID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[mtnTREBebackExport]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
