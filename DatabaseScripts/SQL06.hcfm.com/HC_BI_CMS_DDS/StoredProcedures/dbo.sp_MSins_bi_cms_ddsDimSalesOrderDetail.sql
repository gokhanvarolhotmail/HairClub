/* CreateDate: 10/03/2019 23:03:41.797 , ModifyDate: 10/03/2019 23:03:41.797 */
GO
create procedure [dbo].[sp_MSins_bi_cms_ddsDimSalesOrderDetail]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 int,
    @c5 uniqueidentifier,
    @c6 datetime,
    @c7 int,
    @c8 nvarchar(50),
    @c9 nvarchar(15),
    @c10 bit,
    @c11 bit,
    @c12 int,
    @c13 money,
    @c14 money,
    @c15 money,
    @c16 money,
    @c17 money,
    @c18 money,
    @c19 bit,
    @c20 uniqueidentifier,
    @c21 int,
    @c22 money,
    @c23 uniqueidentifier,
    @c24 nvarchar(50),
    @c25 nvarchar(50),
    @c26 nvarchar(5),
    @c27 uniqueidentifier,
    @c28 nvarchar(50),
    @c29 nvarchar(50),
    @c30 nvarchar(5),
    @c31 uniqueidentifier,
    @c32 nvarchar(50),
    @c33 nvarchar(50),
    @c34 nvarchar(5),
    @c35 uniqueidentifier,
    @c36 nvarchar(50),
    @c37 nvarchar(50),
    @c38 nvarchar(5),
    @c39 uniqueidentifier,
    @c40 int,
    @c41 tinyint,
    @c42 datetime,
    @c43 datetime,
    @c44 varchar(200),
    @c45 tinyint,
    @c46 int,
    @c47 int,
    @c48 binary(8),
    @c49 uniqueidentifier,
    @c50 varchar(50),
    @c51 varchar(50),
    @c52 money,
    @c53 int,
    @c54 int,
    @c55 nvarchar(10),
    @c56 uniqueidentifier,
    @c57 int
as
begin
	insert into [bi_cms_dds].[DimSalesOrderDetail] (
		[SalesOrderDetailKey],
		[SalesOrderDetailSSID],
		[TransactionNumber_Temp],
		[SalesOrderKey],
		[SalesOrderSSID],
		[OrderDate],
		[SalesCodeSSID],
		[SalesCodeDescription],
		[SalesCodeDescriptionShort],
		[IsVoidedFlag],
		[IsClosedFlag],
		[Quantity],
		[Price],
		[Discount],
		[Tax1],
		[Tax2],
		[TaxRate1],
		[TaxRate2],
		[IsRefundedFlag],
		[RefundedSalesOrderDetailSSID],
		[RefundedTotalQuantity],
		[RefundedTotalPrice],
		[Employee1SSID],
		[Employee1FirstName],
		[Employee1LastName],
		[Employee1Initials],
		[Employee2SSID],
		[Employee2FirstName],
		[Employee2LastName],
		[Employee2Initials],
		[Employee3SSID],
		[Employee3FirstName],
		[Employee3LastName],
		[Employee3Initials],
		[Employee4SSID],
		[Employee4FirstName],
		[Employee4LastName],
		[Employee4Initials],
		[PreviousClientMembershipSSID],
		[NewCenterSSID],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version],
		[Performer_temp],
		[Performer2_temp],
		[Member1Price_Temp],
		[CancelReasonID],
		[MembershipOrderReasonID],
		[MembershipPromotion],
		[HairSystemOrderSSID],
		[ClientMembershipAddOnID]
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
		@c31,
		@c32,
		@c33,
		@c34,
		@c35,
		@c36,
		@c37,
		@c38,
		@c39,
		@c40,
		@c41,
		@c42,
		@c43,
		@c44,
		@c45,
		@c46,
		@c47,
		@c48,
		@c49,
		@c50,
		@c51,
		@c52,
		@c53,
		@c54,
		@c55,
		@c56,
		@c57	)
end
GO
