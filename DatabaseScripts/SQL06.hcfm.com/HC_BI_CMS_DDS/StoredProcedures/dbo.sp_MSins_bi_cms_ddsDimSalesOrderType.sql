/* CreateDate: 10/03/2019 23:03:41.940 , ModifyDate: 10/03/2019 23:03:41.940 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_cms_ddsDimSalesOrderType]
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
    @c12 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[DimSalesOrderType] (
		[SalesOrderTypeKey],
		[SalesOrderTypeSSID],
		[SalesOrderTypeDescription],
		[SalesOrderTypeDescriptionShort],
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
