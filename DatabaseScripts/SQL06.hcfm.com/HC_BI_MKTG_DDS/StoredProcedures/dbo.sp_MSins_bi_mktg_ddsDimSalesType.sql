/* CreateDate: 09/03/2021 09:37:06.290 , ModifyDate: 09/03/2021 09:37:06.290 */
GO
create procedure [sp_MSins_bi_mktg_ddsDimSalesType]
    @c1 int,
    @c2 nvarchar(10),
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 tinyint,
    @c6 datetime,
    @c7 datetime,
    @c8 varchar(200),
    @c9 tinyint,
    @c10 int,
    @c11 int,
    @c12 money,
    @c13 money,
    @c14 money,
    @c15 money,
    @c16 nvarchar(10)
as
begin
	insert into [bi_mktg_dds].[DimSalesType] (
		[SalesTypeKey],
		[SalesTypeSSID],
		[SalesTypeDescription],
		[SalesTypeDescriptionShort],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[LTVMale],
		[LTVFemale],
		[LTVMaleYearly],
		[LTVFemaleYearly],
		[BusinessSegment]
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
		default,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16	)
end
GO
