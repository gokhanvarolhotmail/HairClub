/* CreateDate: 09/03/2021 09:37:05.393 , ModifyDate: 09/03/2021 09:37:05.393 */
GO
create procedure [sp_MSins_bi_mktg_ddsDimActivityType]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 tinyint,
    @c6 datetime,
    @c7 datetime,
    @c8 varchar(200),
    @c9 tinyint,
    @c10 int,
    @c11 int
as
begin
	insert into [bi_mktg_dds].[DimActivityType] (
		[ActivityTypeKey],
		[ActivityTypeSSID],
		[ActivityTypeDescription],
		[ActivityTypeDescriptionShort],
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
GO
