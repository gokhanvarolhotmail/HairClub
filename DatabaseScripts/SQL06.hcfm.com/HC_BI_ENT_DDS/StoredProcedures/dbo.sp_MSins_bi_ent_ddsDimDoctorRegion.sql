create procedure [sp_MSins_bi_ent_ddsDimDoctorRegion]
    @c1 int,
    @c2 int,
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 tinyint,
    @c6 datetime,
    @c7 datetime,
    @c8 varchar(200),
    @c9 tinyint,
    @c10 int,
    @c11 int,
    @c12 uniqueidentifier,
    @c13 nchar(1)
as
begin
	insert into [bi_ent_dds].[DimDoctorRegion] (
		[DoctorRegionKey],
		[DoctorRegionSSID],
		[DoctorRegionDescription],
		[DoctorRegionDescriptionShort],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version],
		[Active]
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
		@c13	)
end
