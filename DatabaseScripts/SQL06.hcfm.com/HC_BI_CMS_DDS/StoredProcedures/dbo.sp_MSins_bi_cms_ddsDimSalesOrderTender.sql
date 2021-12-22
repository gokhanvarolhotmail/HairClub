/* CreateDate: 10/03/2019 23:03:41.877 , ModifyDate: 10/03/2019 23:03:41.877 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_cms_ddsDimSalesOrderTender]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 uniqueidentifier,
    @c5 datetime,
    @c6 int,
    @c7 nvarchar(50),
    @c8 nvarchar(10),
    @c9 bit,
    @c10 bit,
    @c11 money,
    @c12 int,
    @c13 nvarchar(4),
    @c14 nvarchar(100),
    @c15 int,
    @c16 nvarchar(50),
    @c17 nvarchar(10),
    @c18 int,
    @c19 nvarchar(50),
    @c20 nvarchar(10),
    @c21 int,
    @c22 nvarchar(50),
    @c23 nvarchar(10),
    @c24 tinyint,
    @c25 datetime,
    @c26 datetime,
    @c27 varchar(200),
    @c28 tinyint,
    @c29 int,
    @c30 int,
    @c31 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[DimSalesOrderTender] (
		[SalesOrderTenderKey],
		[SalesOrderTenderSSID],
		[SalesOrderKey],
		[SalesOrderSSID],
		[OrderDate],
		[TenderTypeSSID],
		[TenderTypeDescription],
		[TenderTypeDescriptionShort],
		[IsVoidedFlag],
		[IsClosedFlag],
		[Amount],
		[CheckNumber],
		[CreditCardLast4Digits],
		[ApprovalCode],
		[CreditCardTypeSSID],
		[CreditCardTypeDescription],
		[CreditCardTypeDescriptionShort],
		[FinanceCompanySSID],
		[FinanceCompanyDescription],
		[FinanceCompanyDescriptionShort],
		[InterCompanyReasonSSID],
		[InterCompanyReasonDescription],
		[InterCompanyReasonDescriptionShort],
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
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21,
		@c22,
		@c23,
		@c24,
		@c25,
		@c26,
		@c27,
		@c28,
		@c29,
		@c30,
		default,
		@c31	)
end
GO
