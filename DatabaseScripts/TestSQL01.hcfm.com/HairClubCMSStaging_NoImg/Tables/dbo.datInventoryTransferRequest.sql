/* CreateDate: 10/04/2010 12:08:45.680 , ModifyDate: 03/04/2022 16:09:12.823 */
GO
CREATE TABLE [dbo].[datInventoryTransferRequest](
	[InventoryTransferRequestGUID] [uniqueidentifier] NOT NULL,
	[InventoryTransferRequestDate] [datetime] NOT NULL,
	[InventoryTransferRequestStatusID] [int] NOT NULL,
	[InventoryTransferRequestRejectReasonID] [int] NULL,
	[IsRejectedFlag] [bit] NOT NULL,
	[OriginalHairSystemOrderStatusID] [int] NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[FromCenterID] [int] NOT NULL,
	[ToCenterID] [int] NOT NULL,
	[FromClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[ToClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[InventoryTransferRequestNote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastStatusChangeDate] [datetime] NULL,
	[CompleteDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datInventoryTransferRequest] PRIMARY KEY CLUSTERED
(
	[InventoryTransferRequestGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datInventoryTransferRequest_FromCenterID] ON [dbo].[datInventoryTransferRequest]
(
	[FromCenterID] ASC
)
INCLUDE([InventoryTransferRequestStatusID],[FromClientMembershipGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datInventoryTransferRequest_InventoryTransferRequestStatusID_ToCenterID] ON [dbo].[datInventoryTransferRequest]
(
	[InventoryTransferRequestStatusID] ASC,
	[ToCenterID] ASC
)
INCLUDE([ToClientMembershipGUID],[FromClientMembershipGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datInventoryTransferRequest] ADD  DEFAULT ((0)) FOR [IsRejectedFlag]
GO
ALTER TABLE [dbo].[datInventoryTransferRequest]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransferRequest_cfgCenter_FromCenterID] FOREIGN KEY([FromCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datInventoryTransferRequest] CHECK CONSTRAINT [FK_datInventoryTransferRequest_cfgCenter_FromCenterID]
GO
ALTER TABLE [dbo].[datInventoryTransferRequest]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransferRequest_cfgCenter_ToCenterID] FOREIGN KEY([ToCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datInventoryTransferRequest] CHECK CONSTRAINT [FK_datInventoryTransferRequest_cfgCenter_ToCenterID]
GO
ALTER TABLE [dbo].[datInventoryTransferRequest]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransferRequest_datClientMembership_FromClientMembershipGUID] FOREIGN KEY([FromClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datInventoryTransferRequest] CHECK CONSTRAINT [FK_datInventoryTransferRequest_datClientMembership_FromClientMembershipGUID]
GO
ALTER TABLE [dbo].[datInventoryTransferRequest]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransferRequest_datClientMembership_ToClientMembershipGUID] FOREIGN KEY([ToClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datInventoryTransferRequest] CHECK CONSTRAINT [FK_datInventoryTransferRequest_datClientMembership_ToClientMembershipGUID]
GO
ALTER TABLE [dbo].[datInventoryTransferRequest]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransferRequest_datHairSystemOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datInventoryTransferRequest] CHECK CONSTRAINT [FK_datInventoryTransferRequest_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datInventoryTransferRequest]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransferRequest_lkpHairSystemOrderStatus] FOREIGN KEY([OriginalHairSystemOrderStatusID])
REFERENCES [dbo].[lkpHairSystemOrderStatus] ([HairSystemOrderStatusID])
GO
ALTER TABLE [dbo].[datInventoryTransferRequest] CHECK CONSTRAINT [FK_datInventoryTransferRequest_lkpHairSystemOrderStatus]
GO
ALTER TABLE [dbo].[datInventoryTransferRequest]  WITH NOCHECK ADD  CONSTRAINT [FK_datInventoryTransferRequest_lkpInventoryTransferRequestRejectReason] FOREIGN KEY([InventoryTransferRequestRejectReasonID])
REFERENCES [dbo].[lkpInventoryTransferRequestRejectReason] ([InventoryTransferRequestRejectReasonID])
GO
ALTER TABLE [dbo].[datInventoryTransferRequest] CHECK CONSTRAINT [FK_datInventoryTransferRequest_lkpInventoryTransferRequestRejectReason]
GO
ALTER TABLE [dbo].[datInventoryTransferRequest]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransferRequest_lkpInventoryTransferRequestStatus] FOREIGN KEY([InventoryTransferRequestStatusID])
REFERENCES [dbo].[lkpInventoryTransferRequestStatus] ([InventoryTransferRequestStatusID])
GO
ALTER TABLE [dbo].[datInventoryTransferRequest] CHECK CONSTRAINT [FK_datInventoryTransferRequest_lkpInventoryTransferRequestStatus]
GO
