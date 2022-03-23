/* CreateDate: 03/17/2022 11:57:06.823 , ModifyDate: 03/17/2022 12:57:03.090 */
GO
CREATE TABLE [bi_cms_dds].[DimSalesOrderDetail](
	[SalesOrderDetailKey] [int] NOT NULL,
	[SalesOrderDetailSSID] [uniqueidentifier] NOT NULL,
	[TransactionNumber_Temp] [int] NOT NULL,
	[SalesOrderKey] [int] NOT NULL,
	[SalesOrderSSID] [uniqueidentifier] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[SalesCodeSSID] [int] NOT NULL,
	[SalesCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeDescriptionShort] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsVoidedFlag] [bit] NOT NULL,
	[IsClosedFlag] [bit] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[Discount] [money] NOT NULL,
	[Tax1] [money] NOT NULL,
	[Tax2] [money] NOT NULL,
	[TaxRate1] [money] NOT NULL,
	[TaxRate2] [money] NOT NULL,
	[ExtendedPriceCalc]  AS (isnull([Price],(0))*isnull([Quantity],(0))-isnull([Discount],(0))),
	[TotalTaxCalc]  AS (isnull([Tax1],(0))+isnull([Tax2],(0))),
	[PriceTaxCalc]  AS (((isnull([Price],(0))*isnull([Quantity],(0))-isnull([Discount],(0)))+isnull([Tax1],(0)))+isnull([Tax2],(0))),
	[IsRefundedFlag] [bit] NOT NULL,
	[RefundedSalesOrderDetailSSID] [uniqueidentifier] NOT NULL,
	[RefundedTotalQuantity] [int] NOT NULL,
	[RefundedTotalPrice] [money] NOT NULL,
	[Employee1SSID] [uniqueidentifier] NOT NULL,
	[Employee1FullName]  AS ((isnull([Employee1LastName],'')+', ')+isnull([Employee1FirstName],'')) PERSISTED NOT NULL,
	[Employee1FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee1LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee1Initials] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee2SSID] [uniqueidentifier] NOT NULL,
	[Employee2FullName]  AS ((isnull([Employee2LastName],'')+', ')+isnull([Employee2FirstName],'')) PERSISTED NOT NULL,
	[Employee2FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee2LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee2Initials] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee3SSID] [uniqueidentifier] NOT NULL,
	[Employee3FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee3LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee3Initials] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee4SSID] [uniqueidentifier] NOT NULL,
	[Employee4FullName]  AS ((isnull([Employee4LastName],'')+', ')+isnull([Employee4FirstName],'')) PERSISTED NOT NULL,
	[Employee4FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee4LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee4Initials] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PreviousClientMembershipSSID] [uniqueidentifier] NOT NULL,
	[NewCenterSSID] [int] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [binary](8) NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[Performer_temp] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Performer2_temp] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Member1Price_Temp] [money] NULL,
	[CancelReasonID] [int] NULL,
	[employee3fullname]  AS ((isnull([Employee3LastName],'')+', ')+isnull([Employee3FirstName],'')) PERSISTED NOT NULL,
	[MembershipOrderReasonID] [int] NULL,
	[MembershipPromotion] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemOrderSSID] [uniqueidentifier] NULL,
	[ClientMembershipAddOnID] [int] NULL
) ON [FG1]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_DimSalesOrderDetail] ON [bi_cms_dds].[DimSalesOrderDetail]
(
	[SalesOrderDetailKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrderDetail_RowIsCurrent_SalesOrderDetailSSID_SalesOrderDetailKey] ON [bi_cms_dds].[DimSalesOrderDetail]
(
	[SalesOrderDetailSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([SalesOrderDetailKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrderDetail_SalesOrderDetailKey] ON [bi_cms_dds].[DimSalesOrderDetail]
(
	[SalesOrderDetailKey] ASC
)
INCLUDE([SalesOrderDetailSSID],[SalesOrderKey],[SalesOrderSSID],[OrderDate],[SalesCodeDescription],[Quantity],[Price],[Discount],[Tax1],[Tax2],[TaxRate1],[TaxRate2],[ExtendedPriceCalc],[TotalTaxCalc],[PriceTaxCalc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
