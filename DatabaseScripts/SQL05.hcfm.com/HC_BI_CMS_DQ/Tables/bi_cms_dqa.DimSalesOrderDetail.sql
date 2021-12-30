/* CreateDate: 05/03/2010 12:19:13.223 , ModifyDate: 08/07/2017 10:14:10.490 */
GO
CREATE TABLE [bi_cms_dqa].[DimSalesOrderDetail](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[SalesOrderDetailKey] [int] NULL,
	[SalesOrderDetailSSID] [uniqueidentifier] NULL,
	[TransactionNumber_Temp] [int] NULL,
	[SalesOrderKey] [int] NULL,
	[SalesOrderSSID] [uniqueidentifier] NULL,
	[OrderDate] [datetime] NULL,
	[SalesCodeSSID] [int] NULL,
	[SalesCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDescriptionShort] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsVoidedFlag] [bit] NULL,
	[IsClosedFlag] [bit] NULL,
	[Quantity] [int] NULL,
	[Price] [decimal](21, 6) NULL,
	[Discount] [money] NULL,
	[Tax1] [money] NULL,
	[Tax2] [money] NULL,
	[TaxRate1] [decimal](6, 5) NULL,
	[TaxRate2] [decimal](6, 5) NULL,
	[IsRefundedFlag] [bit] NULL,
	[RefundedSalesOrderDetailSSID] [uniqueidentifier] NULL,
	[RefundedTotalQuantity] [int] NULL,
	[RefundedTotalPrice] [money] NULL,
	[Employee1SSID] [uniqueidentifier] NULL,
	[Employee1FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee1LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee1Initials] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee2SSID] [uniqueidentifier] NULL,
	[Employee2FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee2LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee2Initials] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee3SSID] [uniqueidentifier] NULL,
	[Employee3FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee3LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee3Initials] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee4SSID] [uniqueidentifier] NULL,
	[Employee4FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee4LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee4Initials] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PreviousClientMembershipSSID] [uniqueidentifier] NULL,
	[NewCenterSSID] [int] NULL,
	[ExtendedPriceCalc]  AS (isnull([Price],(0))*isnull([Quantity],(0))-isnull([Discount],(0))),
	[TotalTaxCalc]  AS (isnull([Tax1],(0))+isnull([Tax2],(0))),
	[PriceTaxCalc]  AS (((isnull([Price],(0))*isnull([Quantity],(0))-isnull([Discount],(0)))+isnull([Tax1],(0)))+isnull([Tax2],(0))),
	[ModifiedDate] [datetime] NULL,
	[IsNew] [tinyint] NULL,
	[IsType1] [tinyint] NULL,
	[IsType2] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsInferredMember] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[Performer_temp] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Performer2_temp] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Member1Price_Temp] [money] NULL,
	[CancelReasonID] [int] NULL,
	[MembershipOrderReasonID] [int] NULL,
	[MembershipPromotion] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemOrderSSID] [uniqueidentifier] NULL,
	[ClientMembershipAddOnID] [int] NULL,
 CONSTRAINT [PK_DimSalesOrderDetail] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_Price]  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_Discount]  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_Tax1]  DEFAULT ((0)) FOR [Tax1]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_Tax2]  DEFAULT ((0)) FOR [Tax2]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_TaxRate1]  DEFAULT ((0)) FOR [TaxRate1]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_TaxRate2]  DEFAULT ((0)) FOR [TaxRate2]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsRefundedFlag]  DEFAULT ((0)) FOR [IsRefundedFlag]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_RefundedTotalPrice]  DEFAULT ((0)) FOR [RefundedTotalPrice]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrderDetail] ADD  CONSTRAINT [DF_DimSalesOrderDetail_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
