/* CreateDate: 01/08/2021 15:21:53.387 , ModifyDate: 01/08/2021 15:21:53.387 */
GO
create procedure [sp_MSins_bi_ent_ddsDimBusinessUnit]
    @c1 int,
    @c2 int,
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 int,
    @c6 int,
    @c7 tinyint,
    @c8 datetime,
    @c9 datetime,
    @c10 varchar(200),
    @c11 tinyint,
    @c12 int,
    @c13 int,
    @c14 uniqueidentifier
as
begin
	insert into [bi_ent_dds].[DimBusinessUnit] (
		[BusinessUnitKey],
		[BusinessUnitSSID],
		[BusinessUnitDescription],
		[BusinessUnitDescriptionShort],
		[BusinessUnitBrandKey],
		[BusinessUnitBrandSSID],
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
		@c13,
		default,
		@c14	)
end
GO
