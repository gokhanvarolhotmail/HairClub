/* CreateDate: 10/03/2019 23:03:40.483 , ModifyDate: 10/03/2019 23:03:40.483 */
GO
create procedure [sp_MSins_bi_cms_ddsDimHairSystemCapSize]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nvarchar(10),
    @c4 int,
    @c5 tinyint,
    @c6 datetime,
    @c7 datetime,
    @c8 varchar(200),
    @c9 tinyint,
    @c10 int,
    @c11 int,
    @c12 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[DimHairSystemCapSize] (
		[HairSystemCapSizeKey],
		[HairSystemCapSizeDescription],
		[HairSystemCapSizeDescriptionShort],
		[HairSystemCapSizeDescriptionSortOrder],
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
		default,
		@c12	)
end
GO
