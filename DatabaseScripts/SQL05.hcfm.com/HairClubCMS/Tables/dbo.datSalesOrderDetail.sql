/* CreateDate: 05/05/2020 17:42:48.120 , ModifyDate: 02/03/2021 15:20:52.883 */
GO
CREATE TABLE [dbo].[datSalesOrderDetail](
	[SalesOrderDetailGUID] [uniqueidentifier] NOT NULL,
	[TransactionNumber_Temp] [int] NULL,
	[SalesOrderGUID] [uniqueidentifier] NOT NULL,
	[SalesCodeID] [int] NOT NULL,
	[Quantity] [int] NULL,
	[Price] [decimal](21, 6) NULL,
	[Discount] [money] NULL,
	[Tax1] [money] NULL,
	[Tax2] [money] NULL,
	[TaxRate1] [decimal](6, 5) NULL,
	[TaxRate2] [decimal](6, 5) NULL,
	[IsRefundedFlag] [bit] NULL,
	[RefundedSalesOrderDetailGUID] [uniqueidentifier] NULL,
	[RefundedTotalQuantity] [int] NULL,
	[RefundedTotalPrice] [money] NULL,
	[Employee1GUID] [uniqueidentifier] NULL,
	[Employee2GUID] [uniqueidentifier] NULL,
	[Employee3GUID] [uniqueidentifier] NULL,
	[Employee4GUID] [uniqueidentifier] NULL,
	[PreviousClientMembershipGUID] [uniqueidentifier] NULL,
	[NewCenterID] [int] NULL,
	[ExtendedPriceCalc]  AS (isnull([Price],(0))*isnull([Quantity],(0))-isnull([Discount],(0))),
	[TotalTaxCalc]  AS (isnull([Tax1],(0))+isnull([Tax2],(0))),
	[PriceTaxCalc]  AS (((isnull([Price],(0))*isnull([Quantity],(0))-isnull([Discount],(0)))+isnull([Tax1],(0)))+isnull([Tax2],(0))),
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[Center_Temp] [int] NULL,
	[performer_temp] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[performer2_temp] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Member1Price_temp] [decimal](21, 6) NULL,
	[CancelReasonID] [int] NULL,
	[EntrySortOrder] [int] NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[DiscountTypeID] [int] NULL,
	[BenefitTrackingEnabledFlag] [bit] NOT NULL,
	[MembershipPromotionID] [int] NULL,
	[MembershipOrderReasonID] [int] NULL,
	[MembershipNotes] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenericSalesCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeSerialNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WriteOffSalesOrderDetailGUID] [uniqueidentifier] NULL,
	[NSFBouncedDate] [datetime] NULL,
	[IsWrittenOffFlag] [bit] NULL,
	[InterCompanyPrice] [money] NULL,
	[TaxType1ID] [int] NULL,
	[TaxType2ID] [int] NULL,
	[ClientMembershipAddOnID] [int] NULL,
	[NCCMembershipPromotionID] [int] NULL,
 CONSTRAINT [PK_datSalesOrderDetail] PRIMARY KEY CLUSTERED
(
	[SalesOrderDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrderDetail_SalesCodeID_INCL] ON [dbo].[datSalesOrderDetail]
(
	[SalesCodeID] ASC
)
INCLUDE([SalesOrderDetailGUID],[SalesOrderGUID],[ExtendedPriceCalc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrderDetail_SalesOrderDetailGuild_INCLUDE] ON [dbo].[datSalesOrderDetail]
(
	[SalesOrderDetailGUID] ASC
)
INCLUDE([Quantity],[Price],[Discount],[Tax1],[Tax2],[Employee2GUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [RP_datSalesOrdeDetail_SalesOrderGUID] ON [dbo].[datSalesOrderDetail]
(
	[SalesOrderGUID] ASC
)
INCLUDE([TransactionNumber_Temp],[SalesCodeID],[Quantity],[Price],[Discount],[Tax1],[Tax2],[Employee1GUID],[ExtendedPriceCalc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_datSalesOrderDetail2] FOREIGN KEY([WriteOffSalesOrderDetailGUID])
REFERENCES [dbo].[datSalesOrderDetail] ([SalesOrderDetailGUID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_datSalesOrderDetail2]
GO
