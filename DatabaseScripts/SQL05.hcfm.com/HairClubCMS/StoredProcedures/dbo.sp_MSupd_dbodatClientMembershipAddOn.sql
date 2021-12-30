/* CreateDate: 05/05/2020 17:42:48.037 , ModifyDate: 05/05/2020 17:42:48.037 */
GO
create procedure [dbo].[sp_MSupd_dbodatClientMembershipAddOn]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 money = NULL,
		@c6 int = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(25) = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 binary(8) = NULL,
		@c13 int = NULL,
		@c14 money = NULL,
		@c15 money = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datClientMembershipAddOn] set
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientMembershipGUID] end,
		[AddOnID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AddOnID] end,
		[ClientMembershipAddOnStatusID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientMembershipAddOnStatusID] end,
		[Price] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Price] end,
		[Quantity] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Quantity] end,
		[MonthlyFee] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [MonthlyFee] end,
		[CreateDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [UpdateStamp] end,
		[Term] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Term] end,
		[ContractPrice] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ContractPrice] end,
		[ContractPaidAmount] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ContractPaidAmount] end
	where [ClientMembershipAddOnID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientMembershipAddOnID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientMembershipAddOn]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
