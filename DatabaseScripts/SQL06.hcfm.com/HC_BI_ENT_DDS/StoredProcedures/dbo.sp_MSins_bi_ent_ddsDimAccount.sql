/* CreateDate: 01/08/2021 15:21:53.227 , ModifyDate: 01/08/2021 15:21:53.227 */
GO
create procedure [sp_MSins_bi_ent_ddsDimAccount]
    @c1 int,
    @c2 varchar(255),
    @c3 nvarchar(255),
    @c4 varchar(50),
    @c5 varchar(50),
    @c6 int,
    @c7 varchar(50),
    @c8 int,
    @c9 varchar(50),
    @c10 int,
    @c11 varchar(50),
    @c12 int,
    @c13 varchar(255),
    @c14 int,
    @c15 varchar(50),
    @c16 int,
    @c17 varchar(50),
    @c18 int,
    @c19 varchar(50),
    @c20 varchar(50),
    @c21 int
as
begin
	insert into [bi_ent_dds].[DimAccount] (
		[AccountID],
		[LedgerGroup],
		[AccountDescription],
		[EBIDA],
		[Level0],
		[Level0Sort],
		[Level1],
		[Level1Sort],
		[Level2],
		[Level2Sort],
		[Level3],
		[Level3Sort],
		[Level4],
		[Level4Sort],
		[Level5],
		[Level5Sort],
		[Level6],
		[Level6Sort],
		[RevenueOrExpenses],
		[ExpenseType],
		[CalculateGrossProfit]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21	)
end
GO
