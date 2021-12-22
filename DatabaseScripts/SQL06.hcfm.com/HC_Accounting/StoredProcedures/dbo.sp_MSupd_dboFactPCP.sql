/* CreateDate: 10/03/2019 22:32:12.420 , ModifyDate: 10/03/2019 22:32:12.420 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_dboFactPCP]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 datetime = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[FactPCP] set
		[CenterID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [CenterID] end,
		[GenderID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [GenderID] end,
		[MembershipID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [MembershipID] end,
		[DateKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [DateKey] end,
		[PCP] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [PCP] end,
		[EXTREME] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [EXTREME] end,
		[Timestamp] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Timestamp] end,
		[CorporateAdjustmentID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CorporateAdjustmentID] end,
		[CenterKey] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CenterKey] end,
		[GenderKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [GenderKey] end,
		[XTR] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [XTR] end
	where [ID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FactPCP]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
