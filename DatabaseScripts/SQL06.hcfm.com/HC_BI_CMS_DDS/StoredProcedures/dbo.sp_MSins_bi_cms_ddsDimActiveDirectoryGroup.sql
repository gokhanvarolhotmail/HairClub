/* CreateDate: 03/17/2022 11:57:04.530 , ModifyDate: 03/17/2022 11:57:04.530 */
GO
create procedure [sp_MSins_bi_cms_ddsDimActiveDirectoryGroup]
    @c1 int,
    @c2 nvarchar(50),
    @c3 tinyint,
    @c4 datetime,
    @c5 datetime,
    @c6 varchar(200),
    @c7 tinyint,
    @c8 int,
    @c9 int,
    @c10 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[DimActiveDirectoryGroup] (
		[ActiveDirectoryGroupKey],
		[ActiveDirectoryGroupSSID],
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
		default,
		@c10	)
end
GO
