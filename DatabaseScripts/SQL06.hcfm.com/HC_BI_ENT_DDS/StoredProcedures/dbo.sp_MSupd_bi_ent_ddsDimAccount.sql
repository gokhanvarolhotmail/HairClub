create procedure [sp_MSupd_bi_ent_ddsDimAccount]
		@c1 int = NULL,
		@c2 varchar(255) = NULL,
		@c3 nvarchar(255) = NULL,
		@c4 varchar(50) = NULL,
		@c5 varchar(50) = NULL,
		@c6 int = NULL,
		@c7 varchar(50) = NULL,
		@c8 int = NULL,
		@c9 varchar(50) = NULL,
		@c10 int = NULL,
		@c11 varchar(50) = NULL,
		@c12 int = NULL,
		@c13 varchar(255) = NULL,
		@c14 int = NULL,
		@c15 varchar(50) = NULL,
		@c16 int = NULL,
		@c17 varchar(50) = NULL,
		@c18 int = NULL,
		@c19 varchar(50) = NULL,
		@c20 varchar(50) = NULL,
		@c21 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [bi_ent_dds].[DimAccount] set
		[AccountID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [AccountID] end,
		[LedgerGroup] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [LedgerGroup] end,
		[AccountDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AccountDescription] end,
		[EBIDA] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EBIDA] end,
		[Level0] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Level0] end,
		[Level0Sort] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Level0Sort] end,
		[Level1] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Level1] end,
		[Level1Sort] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Level1Sort] end,
		[Level2] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Level2] end,
		[Level2Sort] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Level2Sort] end,
		[Level3] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Level3] end,
		[Level3Sort] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Level3Sort] end,
		[Level4] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Level4] end,
		[Level4Sort] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Level4Sort] end,
		[Level5] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Level5] end,
		[Level5Sort] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Level5Sort] end,
		[Level6] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Level6] end,
		[Level6Sort] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Level6Sort] end,
		[RevenueOrExpenses] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [RevenueOrExpenses] end,
		[ExpenseType] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [ExpenseType] end,
		[CalculateGrossProfit] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [CalculateGrossProfit] end
	where [AccountID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccountID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_ent_dds].[DimAccount]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_ent_dds].[DimAccount] set
		[LedgerGroup] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [LedgerGroup] end,
		[AccountDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AccountDescription] end,
		[EBIDA] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EBIDA] end,
		[Level0] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Level0] end,
		[Level0Sort] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Level0Sort] end,
		[Level1] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Level1] end,
		[Level1Sort] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Level1Sort] end,
		[Level2] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Level2] end,
		[Level2Sort] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Level2Sort] end,
		[Level3] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Level3] end,
		[Level3Sort] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Level3Sort] end,
		[Level4] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Level4] end,
		[Level4Sort] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Level4Sort] end,
		[Level5] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Level5] end,
		[Level5Sort] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Level5Sort] end,
		[Level6] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Level6] end,
		[Level6Sort] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Level6Sort] end,
		[RevenueOrExpenses] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [RevenueOrExpenses] end,
		[ExpenseType] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [ExpenseType] end,
		[CalculateGrossProfit] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [CalculateGrossProfit] end
	where [AccountID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccountID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_ent_dds].[DimAccount]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
