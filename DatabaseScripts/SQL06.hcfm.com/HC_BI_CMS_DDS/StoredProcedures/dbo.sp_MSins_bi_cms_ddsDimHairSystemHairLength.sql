/* CreateDate: 03/17/2022 11:57:05.643 , ModifyDate: 03/17/2022 11:57:05.643 */
GO
create procedure [sp_MSins_bi_cms_ddsDimHairSystemHairLength]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 int,
    @c6 int,
    @c7 nchar(1),
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
	insert into [bi_cms_dds].[DimHairSystemHairLength] (
		[HairSystemHairLengthKey],
		[HairSystemHairLengthSSID],
		[HairSystemHairLengthDescription],
		[HairSystemHairLengthDescriptionShort],
		[HairSystemHairLengthValue],
		[HairSystemHairLengthSortOrder],
		[Active],
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
