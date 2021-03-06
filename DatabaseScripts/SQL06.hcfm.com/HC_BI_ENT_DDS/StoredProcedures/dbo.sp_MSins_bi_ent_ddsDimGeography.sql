/* CreateDate: 01/08/2021 15:21:53.803 , ModifyDate: 01/08/2021 15:21:53.803 */
GO
create procedure [sp_MSins_bi_ent_ddsDimGeography]
    @c1 int,
    @c2 nvarchar(15),
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 nvarchar(50),
    @c6 nvarchar(10),
    @c7 nvarchar(50),
    @c8 tinyint,
    @c9 datetime,
    @c10 datetime,
    @c11 varchar(200),
    @c12 tinyint,
    @c13 int,
    @c14 int,
    @c15 uniqueidentifier
as
begin
	insert into [bi_ent_dds].[DimGeography] (
		[GeographyKey],
		[PostalCode],
		[CountryRegionDescription],
		[CountryRegionDescriptionShort],
		[StateProvinceDescription],
		[StateProvinceDescriptionShort],
		[City],
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
		@c14,
		default,
		@c15	)
end
GO
