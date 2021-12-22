/* CreateDate: 03/06/2009 13:55:53.830 , ModifyDate: 12/07/2021 16:20:16.073 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrderDetail_SalesCodeID_SalesOrderGUID_SalesOrderDetailGUID] ON [dbo].[datSalesOrderDetail]
(
	[SalesCodeID] ASC,
	[SalesOrderGUID] ASC,
	[SalesOrderDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrderDetail_SalesOrderGUID_EntrySortOrder] ON [dbo].[datSalesOrderDetail]
(
	[SalesOrderGUID] ASC,
	[EntrySortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datSalesOrdeDetail_SalesOrderGUID] ON [dbo].[datSalesOrderDetail]
(
	[SalesOrderGUID] ASC
)
INCLUDE([TransactionNumber_Temp],[SalesCodeID],[Quantity],[Price],[Discount],[Tax1],[Tax2],[Employee1GUID],[ExtendedPriceCalc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSalesOrderDetail] ADD  CONSTRAINT [DF_datSalesOrderDetail_Price]  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[datSalesOrderDetail] ADD  CONSTRAINT [DF_datSalesOrderDetail_Discount]  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [dbo].[datSalesOrderDetail] ADD  CONSTRAINT [DF_datSalesOrderDetail_Tax1]  DEFAULT ((0)) FOR [Tax1]
GO
ALTER TABLE [dbo].[datSalesOrderDetail] ADD  CONSTRAINT [DF_datSalesOrderDetail_Tax2]  DEFAULT ((0)) FOR [Tax2]
GO
ALTER TABLE [dbo].[datSalesOrderDetail] ADD  CONSTRAINT [DF_datSalesOrderDetail_TaxRate1]  DEFAULT ((0)) FOR [TaxRate1]
GO
ALTER TABLE [dbo].[datSalesOrderDetail] ADD  CONSTRAINT [DF_datSalesOrderDetail_TaxRate2]  DEFAULT ((0)) FOR [TaxRate2]
GO
ALTER TABLE [dbo].[datSalesOrderDetail] ADD  CONSTRAINT [DF_datSalesOrderDetail_IsRefundedFlag]  DEFAULT ((0)) FOR [IsRefundedFlag]
GO
ALTER TABLE [dbo].[datSalesOrderDetail] ADD  CONSTRAINT [DF_datSalesOrderDetail_RefundedTotalPrice]  DEFAULT ((0)) FOR [RefundedTotalPrice]
GO
ALTER TABLE [dbo].[datSalesOrderDetail] ADD  DEFAULT ((1)) FOR [EntrySortOrder]
GO
ALTER TABLE [dbo].[datSalesOrderDetail] ADD  CONSTRAINT [DF_datSalesOrderDetail_BenefitTrackingEnabledFlag]  DEFAULT ((1)) FOR [BenefitTrackingEnabledFlag]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_cfgCenter] FOREIGN KEY([NewCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_cfgCenter]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_cfgMembershipPromotion] FOREIGN KEY([MembershipPromotionID])
REFERENCES [dbo].[cfgMembershipPromotion] ([MembershipPromotionID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_cfgMembershipPromotion]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_cfgMembershipPromotion_NCC] FOREIGN KEY([NCCMembershipPromotionID])
REFERENCES [dbo].[cfgMembershipPromotion] ([MembershipPromotionID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_cfgMembershipPromotion_NCC]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_cfgSalesCode] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_cfgSalesCode]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_datClientMembership] FOREIGN KEY([PreviousClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_datClientMembership]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_datClientMembershipAddOn] FOREIGN KEY([ClientMembershipAddOnID])
REFERENCES [dbo].[datClientMembershipAddOn] ([ClientMembershipAddOnID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_datClientMembershipAddOn]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_datEmployee] FOREIGN KEY([Employee1GUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_datEmployee]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_datEmployee1] FOREIGN KEY([Employee2GUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_datEmployee1]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_datEmployee2] FOREIGN KEY([Employee3GUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_datEmployee2]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_datEmployee3] FOREIGN KEY([Employee4GUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_datEmployee3]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_datHairSystemOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_datSalesOrder] FOREIGN KEY([SalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_datSalesOrder]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_datSalesOrderDetail] FOREIGN KEY([RefundedSalesOrderDetailGUID])
REFERENCES [dbo].[datSalesOrderDetail] ([SalesOrderDetailGUID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_datSalesOrderDetail]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_datSalesOrderDetail2] FOREIGN KEY([WriteOffSalesOrderDetailGUID])
REFERENCES [dbo].[datSalesOrderDetail] ([SalesOrderDetailGUID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_datSalesOrderDetail2]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_lkpDiscountType] FOREIGN KEY([DiscountTypeID])
REFERENCES [dbo].[lkpDiscountType] ([DiscountTypeID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_lkpDiscountType]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_lkpMembershipOrderReason] FOREIGN KEY([MembershipOrderReasonID])
REFERENCES [dbo].[lkpMembershipOrderReason] ([MembershipOrderReasonID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_lkpMembershipOrderReason]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_lkpTaxType1] FOREIGN KEY([TaxType1ID])
REFERENCES [dbo].[lkpTaxType] ([TaxTypeID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_lkpTaxType1]
GO
ALTER TABLE [dbo].[datSalesOrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderDetail_lkpTaxType2] FOREIGN KEY([TaxType2ID])
REFERENCES [dbo].[lkpTaxType] ([TaxTypeID])
GO
ALTER TABLE [dbo].[datSalesOrderDetail] CHECK CONSTRAINT [FK_datSalesOrderDetail_lkpTaxType2]
GO
