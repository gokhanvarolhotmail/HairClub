create procedure [sp_MSins_bi_mktg_ddsDimPromotionCode]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nvarchar(50),
    @c4 nchar(1),
    @c5 tinyint,
    @c6 datetime,
    @c7 datetime,
    @c8 varchar(200),
    @c9 tinyint,
    @c10 int,
    @c11 int
as
begin
	insert into [bi_mktg_dds].[DimPromotionCode] (
		[PromotionCodeKey],
		[PromotionCodeSSID],
		[PromotionCodeDescription],
		[Active],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp]
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
		default	)
end
