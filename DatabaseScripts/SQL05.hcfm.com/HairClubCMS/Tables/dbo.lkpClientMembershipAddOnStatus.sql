/* CreateDate: 05/05/2020 17:42:44.470 , ModifyDate: 05/05/2020 17:43:03.013 */
GO
CREATE TABLE [dbo].[lkpClientMembershipAddOnStatus](
	[ClientMembershipAddOnStatusID] [int] NOT NULL,
	[ClientMembershipAddOnStatusSortOrder] [int] NOT NULL,
	[ClientMembershipAddOnStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientMembershipAddOnStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [binary](8) NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_lkpClientMembershipAddOnStatusID] ON [dbo].[lkpClientMembershipAddOnStatus]
(
	[ClientMembershipAddOnStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
