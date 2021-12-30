/* CreateDate: 05/05/2020 17:42:47.927 , ModifyDate: 05/05/2020 17:42:47.927 */
GO
create procedure [sp_MSupd_dbodatAccountReceivable]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 money = NULL,
		@c6 bit = NULL,
		@c7 int = NULL,
		@c8 money = NULL,
		@c9 datetime = NULL,
		@c10 nvarchar(25) = NULL,
		@c11 datetime = NULL,
		@c12 nvarchar(25) = NULL,
		@c13 uniqueidentifier = NULL,
		@c14 uniqueidentifier = NULL,
		@c15 uniqueidentifier = NULL,
		@c16 uniqueidentifier = NULL,
		@c17 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datAccountReceivable] set
		[ClientGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientGUID] end,
		[SalesOrderGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesOrderGUID] end,
		[CenterFeeBatchGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterFeeBatchGUID] end,
		[Amount] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Amount] end,
		[IsClosed] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [IsClosed] end,
		[AccountReceivableTypeID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [AccountReceivableTypeID] end,
		[RemainingBalance] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [RemainingBalance] end,
		[CreateDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdateUser] end,
		[CenterDeclineBatchGUID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CenterDeclineBatchGUID] end,
		[RefundedSalesOrderGuid] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [RefundedSalesOrderGuid] end,
		[WriteOffSalesOrderGUID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [WriteOffSalesOrderGUID] end,
		[NSFSalesOrderGUID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [NSFSalesOrderGUID] end,
		[ChargeBackSalesOrderGUID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ChargeBackSalesOrderGUID] end
	where [AccountReceivableID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccountReceivableID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datAccountReceivable]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
