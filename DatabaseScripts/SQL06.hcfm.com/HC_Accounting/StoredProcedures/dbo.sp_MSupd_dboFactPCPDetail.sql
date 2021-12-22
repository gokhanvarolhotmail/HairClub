/* CreateDate: 10/03/2019 22:32:12.483 , ModifyDate: 10/03/2019 22:32:12.483 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_dboFactPCPDetail]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 datetime = NULL,
		@c10 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[FactPCPDetail] set
		[CenterKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterKey] end,
		[ClientKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientKey] end,
		[GenderKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [GenderKey] end,
		[MembershipKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [MembershipKey] end,
		[DateKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DateKey] end,
		[PCP] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [PCP] end,
		[EXT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [EXT] end,
		[Timestamp] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Timestamp] end,
		[XTR] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [XTR] end
	where [ID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FactPCPDetail]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
