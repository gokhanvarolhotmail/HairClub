/* CreateDate: 04/24/2017 08:10:29.217 , ModifyDate: 12/29/2021 15:38:46.427 */
GO
CREATE TABLE [dbo].[lkpClientMembershipAddOnStatus](
	[ClientMembershipAddOnStatusID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientMembershipAddOnStatusSortOrder] [int] NOT NULL,
	[ClientMembershipAddOnStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientMembershipAddOnStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpClientMembershipAddOnStatusID] PRIMARY KEY CLUSTERED
(
	[ClientMembershipAddOnStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
