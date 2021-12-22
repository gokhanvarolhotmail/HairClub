/* CreateDate: 10/30/2008 09:07:17.583 , ModifyDate: 05/26/2020 10:49:42.047 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgMembershipAccum](
	[MembershipAccumulatorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MembershipAccumulatorSortOrder] [int] NULL,
	[MembershipID] [int] NULL,
	[AccumulatorID] [int] NULL,
	[InitialQuantity] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgMembershipAccum] PRIMARY KEY CLUSTERED
(
	[MembershipAccumulatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgMembershipAccum] ADD  CONSTRAINT [DF_cfgMembershipAccum_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgMembershipAccum]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipAccum_cfgAccumulator] FOREIGN KEY([AccumulatorID])
REFERENCES [dbo].[cfgAccumulator] ([AccumulatorID])
GO
ALTER TABLE [dbo].[cfgMembershipAccum] CHECK CONSTRAINT [FK_cfgMembershipAccum_cfgAccumulator]
GO
ALTER TABLE [dbo].[cfgMembershipAccum]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipAccum_cfgMembership] FOREIGN KEY([MembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [dbo].[cfgMembershipAccum] CHECK CONSTRAINT [FK_cfgMembershipAccum_cfgMembership]
GO
