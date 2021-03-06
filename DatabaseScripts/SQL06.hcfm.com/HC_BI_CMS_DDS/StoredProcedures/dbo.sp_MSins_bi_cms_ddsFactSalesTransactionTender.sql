/* CreateDate: 03/17/2022 11:57:08.597 , ModifyDate: 03/17/2022 11:57:08.597 */
GO
create procedure [sp_MSins_bi_cms_ddsFactSalesTransactionTender]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 int,
    @c10 money,
    @c11 int,
    @c12 int,
    @c13 uniqueidentifier,
    @c14 tinyint,
    @c15 tinyint,
    @c16 int
as
begin
	insert into [bi_cms_dds].[FactSalesTransactionTender] (
		[OrderDateKey],
		[SalesOrderKey],
		[SalesOrderTenderKey],
		[SalesOrderTypeKey],
		[CenterKey],
		[ClientKey],
		[MembershipKey],
		[ClientMembershipKey],
		[TenderTypeKey],
		[TenderAmount],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version],
		[IsClosed],
		[IsVoided],
		[AccountID]
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
		@c14,
		@c15,
		@c16	)
end
GO
