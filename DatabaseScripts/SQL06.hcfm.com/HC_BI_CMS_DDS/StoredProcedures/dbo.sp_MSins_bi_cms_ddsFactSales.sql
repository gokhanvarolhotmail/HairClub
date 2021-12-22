/* CreateDate: 10/03/2019 23:03:42.363 , ModifyDate: 10/03/2019 23:03:42.363 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_cms_ddsFactSales]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 int,
    @c10 int,
    @c11 int,
    @c12 int,
    @c13 money,
    @c14 money,
    @c15 money,
    @c16 money,
    @c17 money,
    @c18 int,
    @c19 int,
    @c20 uniqueidentifier,
    @c21 tinyint,
    @c22 tinyint
as
begin
	insert into [bi_cms_dds].[FactSales] (
		[OrderDateKey],
		[SalesOrderKey],
		[SalesOrderTypeKey],
		[CenterKey],
		[ClientHomeCenterKey],
		[ClientKey],
		[MembershipKey],
		[ClientMembershipKey],
		[EmployeeKey],
		[IsRefunded],
		[IsTaxExempt],
		[IsWrittenOff],
		[TotalDiscount],
		[TotalTax],
		[TotalExtendedPrice],
		[TotalExtendedPricePlusTax],
		[TotalTender],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version],
		[IsClosed],
		[IsVoided]
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
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		default,
		@c20,
		@c21,
		@c22	)
end
GO
