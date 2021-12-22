/* CreateDate: 08/27/2008 11:30:03.173 , ModifyDate: 12/07/2021 16:20:16.030 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpClientMembershipStatus](
	[ClientMembershipStatusID] [int] NOT NULL,
	[ClientMembershipStatusSortOrder] [int] NOT NULL,
	[ClientMembershipStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientMembershipStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveMembershipFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[CanSearchAndDisplayFlag] [bit] NOT NULL,
	[CanCheckInForConsultation] [bit] NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpClientMembershipStatus] PRIMARY KEY CLUSTERED
(
	[ClientMembershipStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpClientMembershipStatus] ADD  CONSTRAINT [DF_lkpClientMembershipStatus_IsActiveMembershipFlag]  DEFAULT ((1)) FOR [IsActiveMembershipFlag]
GO
ALTER TABLE [dbo].[lkpClientMembershipStatus] ADD  CONSTRAINT [DF_lkpClientMembershipStatus_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpClientMembershipStatus] ADD  DEFAULT ((0)) FOR [CanSearchAndDisplayFlag]
GO
ALTER TABLE [dbo].[lkpClientMembershipStatus] ADD  DEFAULT ((0)) FOR [CanCheckInForConsultation]
GO
