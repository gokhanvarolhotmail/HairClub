/* CreateDate: 01/08/2021 15:21:54.010 , ModifyDate: 01/08/2021 15:21:54.010 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_ent_ddsDimRegion]
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
    @c13 uniqueidentifier,
    @c14 int
as
begin
	insert into [bi_ent_dds].[DimRegion] (
		[RegionKey],
		[RegionSSID],
		[RegionDescription],
		[RegionDescriptionShort],
		[RegionSortOrder],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version],
		[RegionNumber]
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
		@c13,
		@c14	)
end
GO
