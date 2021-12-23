/* CreateDate: 03/03/2009 08:31:58.033 , ModifyDate: 07/01/2021 10:46:04.230 */
GO
CREATE TABLE [dbo].[datSalesOrder](
	[SalesOrderGUID] [uniqueidentifier] NOT NULL,
	[TenderTransactionNumber_Temp] [int] NULL,
	[TicketNumber_Temp] [int] NULL,
	[CenterID] [int] NULL,
	[ClientHomeCenterID] [int] NULL,
	[SalesOrderTypeID] [int] NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[OrderDate] [datetime] NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsTaxExemptFlag] [bit] NULL,
	[IsVoidedFlag] [bit] NULL,
	[IsClosedFlag] [bit] NULL,
	[RegisterCloseGUID] [uniqueidentifier] NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[FulfillmentNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsWrittenOffFlag] [bit] NULL,
	[IsRefundedFlag] [bit] NULL,
	[RefundedSalesOrderGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ParentSalesOrderGUID] [uniqueidentifier] NULL,
	[IsSurgeryReversalFlag] [bit] NULL,
	[IsGuaranteeFlag] [bit] NULL,
	[cashier_temp] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ctrOrderDate] [datetime] NULL,
	[CenterFeeBatchGUID] [uniqueidentifier] NULL,
	[CenterDeclineBatchGUID] [uniqueidentifier] NULL,
	[RegisterID] [int] NULL,
	[EndOfDayGUID] [uniqueidentifier] NULL,
	[IncomingRequestID] [int] NULL,
	[WriteOffSalesOrderGUID] [uniqueidentifier] NULL,
	[NSFSalesOrderGUID] [uniqueidentifier] NULL,
	[ChargeBackSalesOrderGUID] [uniqueidentifier] NULL,
	[ChargebackReasonID] [int] NULL,
	[InterCompanyTransactionID] [int] NULL,
	[WriteOffReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datSalesOrder] PRIMARY KEY CLUSTERED
(
	[SalesOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_CenterDeclineBatchGUID] ON [dbo].[datSalesOrder]
(
	[CenterDeclineBatchGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_CenterFeeBatchGUID] ON [dbo].[datSalesOrder]
(
	[CenterFeeBatchGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_CenterIDSOTypeOrderDate] ON [dbo].[datSalesOrder]
(
	[CenterID] ASC,
	[SalesOrderTypeID] ASC,
	[OrderDate] ASC
)
INCLUDE([SalesOrderGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_ClientGUID] ON [dbo].[datSalesOrder]
(
	[ClientGUID] ASC
)
INCLUDE([SalesOrderGUID],[ClientMembershipGUID],[OrderDate],[IsVoidedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_ClientGUID_IsVoidedFlag] ON [dbo].[datSalesOrder]
(
	[ClientGUID] ASC,
	[IsVoidedFlag] ASC
)
INCLUDE([SalesOrderGUID],[OrderDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_ClientGUID_SalesOrderGUID_OrderDate] ON [dbo].[datSalesOrder]
(
	[ClientGUID] ASC,
	[SalesOrderGUID] ASC,
	[OrderDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_ClientMembershipGUID] ON [dbo].[datSalesOrder]
(
	[ClientMembershipGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_EndOfDayGUID] ON [dbo].[datSalesOrder]
(
	[EndOfDayGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_InvoiceNumber] ON [dbo].[datSalesOrder]
(
	[InvoiceNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_IsVoidedFlag_IsClosedFlag] ON [dbo].[datSalesOrder]
(
	[IsVoidedFlag] ASC,
	[IsClosedFlag] ASC
)
INCLUDE([CenterID],[SalesOrderTypeID],[ClientGUID],[InvoiceNumber],[EmployeeGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_LastUpdate] ON [dbo].[datSalesOrder]
(
	[LastUpdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_OrderDateINCLSOGUIDCenterID] ON [dbo].[datSalesOrder]
(
	[OrderDate] ASC
)
INCLUDE([SalesOrderGUID],[CenterID],[SalesOrderTypeID],[ClientGUID],[ClientMembershipGUID],[IsVoidedFlag],[IsClosedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_RegisterID] ON [dbo].[datSalesOrder]
(
	[RegisterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesorderDate_ctrOrderDateINCLCenterIDClientGUID] ON [dbo].[datSalesOrder]
(
	[ctrOrderDate] ASC
)
INCLUDE([SalesOrderGUID],[CenterID],[ClientGUID],[ClientMembershipGUID],[IsVoidedFlag],[IsRefundedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datSalesOrder_CenterID_INCLSSCOIEI] ON [dbo].[datSalesOrder]
(
	[CenterID] ASC
)
INCLUDE([SalesOrderGUID],[SalesOrderTypeID],[ClientGUID],[OrderDate],[IsVoidedFlag],[EmployeeGUID],[IsRefundedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datSalesOrder_ClientHomeCenterID] ON [dbo].[datSalesOrder]
(
	[ClientHomeCenterID] ASC,
	[IsVoidedFlag] ASC,
	[IsClosedFlag] ASC
)
INCLUDE([SalesOrderGUID],[SalesOrderTypeID],[ClientGUID],[ClientMembershipGUID],[OrderDate],[InvoiceNumber],[EmployeeGUID],[IsRefundedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datSalesOrder_RefundedSalesOrderGUID_INCLOI] ON [dbo].[datSalesOrder]
(
	[RefundedSalesOrderGUID] ASC
)
INCLUDE([OrderDate],[InvoiceNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSalesOrder] ADD  CONSTRAINT [DF_datSalesOrder_IsTaxExemptFlag]  DEFAULT ((0)) FOR [IsTaxExemptFlag]
GO
ALTER TABLE [dbo].[datSalesOrder] ADD  CONSTRAINT [DF_datSalesOrder_IsVoidedFlag]  DEFAULT ((0)) FOR [IsVoidedFlag]
GO
ALTER TABLE [dbo].[datSalesOrder] ADD  CONSTRAINT [DF_datSalesOrder_IsClosedFlag]  DEFAULT ((0)) FOR [IsClosedFlag]
GO
ALTER TABLE [dbo].[datSalesOrder] ADD  CONSTRAINT [DF_datSalesOrder_IsWrittenOffFlag]  DEFAULT ((0)) FOR [IsWrittenOffFlag]
GO
ALTER TABLE [dbo].[datSalesOrder] ADD  CONSTRAINT [DF_datSalesOrder_IsRefundedFlag]  DEFAULT ((0)) FOR [IsRefundedFlag]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_cfgCenter]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_cfgCenter1] FOREIGN KEY([ClientHomeCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_cfgCenter1]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_ChargebackSalesOrder] FOREIGN KEY([ChargeBackSalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_ChargebackSalesOrder]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_datAppointment]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_datCenterDeclineBatch] FOREIGN KEY([CenterDeclineBatchGUID])
REFERENCES [dbo].[datCenterDeclineBatch] ([CenterDeclineBatchGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_datCenterDeclineBatch]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_datCenterFeeBatch] FOREIGN KEY([CenterFeeBatchGUID])
REFERENCES [dbo].[datCenterFeeBatch] ([CenterFeeBatchGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_datCenterFeeBatch]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_datClient]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_datClientMembership]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_datEmployee]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_datFactoryOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datFactoryOrder] ([FactoryOrderGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_datFactoryOrder]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_datHairSystemOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_datInterCompanyTransaction] FOREIGN KEY([InterCompanyTransactionID])
REFERENCES [dbo].[datInterCompanyTransaction] ([InterCompanyTransactionId])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_datInterCompanyTransaction]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_datSalesOrder] FOREIGN KEY([RefundedSalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_datSalesOrder]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_EndOfDayGUID] FOREIGN KEY([EndOfDayGUID])
REFERENCES [dbo].[datEndOfDay] ([EndOfDayGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_EndOfDayGUID]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_IncomingRequestID] FOREIGN KEY([IncomingRequestID])
REFERENCES [dbo].[datIncomingRequestLog] ([IncomingRequestID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_IncomingRequestID]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_lkpChargebackReason] FOREIGN KEY([ChargebackReasonID])
REFERENCES [dbo].[lkpChargebackReason] ([ChargebackReasonID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_lkpChargebackReason]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_lkpSalesOrderType] FOREIGN KEY([SalesOrderTypeID])
REFERENCES [dbo].[lkpSalesOrderType] ([SalesOrderTypeID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_lkpSalesOrderType]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_NSFSalesOrder] FOREIGN KEY([NSFSalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_NSFSalesOrder]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_RegisterID] FOREIGN KEY([RegisterID])
REFERENCES [dbo].[cfgRegister] ([RegisterID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_RegisterID]
GO
ALTER TABLE [dbo].[datSalesOrder]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrder_WriteOffSalesOrder] FOREIGN KEY([WriteOffSalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datSalesOrder] CHECK CONSTRAINT [FK_datSalesOrder_WriteOffSalesOrder]
GO
