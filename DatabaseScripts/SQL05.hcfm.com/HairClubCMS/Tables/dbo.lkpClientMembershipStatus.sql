/* CreateDate: 05/05/2020 17:42:44.520 , ModifyDate: 05/05/2020 17:43:03.020 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
