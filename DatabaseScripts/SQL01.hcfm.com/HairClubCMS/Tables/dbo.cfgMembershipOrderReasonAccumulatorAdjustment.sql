CREATE TABLE [dbo].[cfgMembershipOrderReasonAccumulatorAdjustment](
	[MembershipOrderReasonAccumulatorAdjustmentID] [int] IDENTITY(1,1) NOT NULL,
	[MembershipOrderReasonID] [int] NOT NULL,
	[AccumulatorID] [int] NOT NULL,
	[QuantityAdjustment] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgMembershipOrderReasonAccumulatorAdjustment] PRIMARY KEY CLUSTERED
(
	[MembershipOrderReasonAccumulatorAdjustmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgMembershipOrderReasonAccumulatorAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipOrderReasonAccumulatorAdjustment_cfgAccumulator] FOREIGN KEY([AccumulatorID])
REFERENCES [dbo].[cfgAccumulator] ([AccumulatorID])
GO
ALTER TABLE [dbo].[cfgMembershipOrderReasonAccumulatorAdjustment] CHECK CONSTRAINT [FK_cfgMembershipOrderReasonAccumulatorAdjustment_cfgAccumulator]
GO
ALTER TABLE [dbo].[cfgMembershipOrderReasonAccumulatorAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipOrderReasonAccumulatorAdjustment_lkpMembershipOrderReason] FOREIGN KEY([MembershipOrderReasonID])
REFERENCES [dbo].[lkpMembershipOrderReason] ([MembershipOrderReasonID])
GO
ALTER TABLE [dbo].[cfgMembershipOrderReasonAccumulatorAdjustment] CHECK CONSTRAINT [FK_cfgMembershipOrderReasonAccumulatorAdjustment_lkpMembershipOrderReason]
