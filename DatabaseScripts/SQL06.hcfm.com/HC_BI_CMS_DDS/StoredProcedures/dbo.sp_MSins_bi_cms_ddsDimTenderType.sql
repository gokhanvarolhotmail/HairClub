create procedure [sp_MSins_bi_cms_ddsDimTenderType]
    @c1 int,
    @c2 int,
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 int,
    @c6 tinyint,
    @c7 datetime,
    @c8 datetime,
    @c9 varchar(200),
    @c10 tinyint,
    @c11 int,
    @c12 int,
    @c13 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[DimTenderType] (
		[TenderTypeKey],
		[TenderTypeSSID],
		[TenderTypeDescription],
		[TenderTypeDescriptionShort],
		[MaxOccurrences],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version]
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
		default,
		@c13	)
end
