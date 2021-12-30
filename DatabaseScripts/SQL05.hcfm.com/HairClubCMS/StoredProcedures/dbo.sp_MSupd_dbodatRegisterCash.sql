/* CreateDate: 05/05/2020 17:42:51.907 , ModifyDate: 05/05/2020 17:42:51.907 */
GO
create procedure [sp_MSupd_dbodatRegisterCash]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datRegisterCash] set
		[RegisterCashGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [RegisterCashGUID] end,
		[RegisterTenderGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [RegisterTenderGUID] end,
		[HundredCount] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HundredCount] end,
		[FiftyCount] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [FiftyCount] end,
		[TwentyCount] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [TwentyCount] end,
		[TenCount] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [TenCount] end,
		[FiveCount] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [FiveCount] end,
		[OneCount] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [OneCount] end,
		[DollarCount] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [DollarCount] end,
		[HalfDollarCount] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [HalfDollarCount] end,
		[QuarterCount] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [QuarterCount] end,
		[DimeCount] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [DimeCount] end,
		[NickelCount] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [NickelCount] end,
		[PennyCount] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [PennyCount] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end
	where [RegisterCashGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[RegisterCashGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datRegisterCash]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datRegisterCash] set
		[RegisterTenderGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [RegisterTenderGUID] end,
		[HundredCount] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HundredCount] end,
		[FiftyCount] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [FiftyCount] end,
		[TwentyCount] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [TwentyCount] end,
		[TenCount] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [TenCount] end,
		[FiveCount] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [FiveCount] end,
		[OneCount] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [OneCount] end,
		[DollarCount] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [DollarCount] end,
		[HalfDollarCount] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [HalfDollarCount] end,
		[QuarterCount] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [QuarterCount] end,
		[DimeCount] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [DimeCount] end,
		[NickelCount] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [NickelCount] end,
		[PennyCount] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [PennyCount] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end
	where [RegisterCashGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[RegisterCashGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datRegisterCash]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
