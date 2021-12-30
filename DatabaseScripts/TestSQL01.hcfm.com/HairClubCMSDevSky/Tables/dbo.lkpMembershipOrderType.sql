/* CreateDate: 10/28/2008 15:12:36.673 , ModifyDate: 12/29/2021 15:38:46.113 */
GO
CREATE TABLE [dbo].[lkpMembershipOrderType](
	[MembershipOrderTypeID] [int] NOT NULL,
	[MembershipOrderTypeSortOrder] [int] NOT NULL,
	[MembershipOrderTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipOrderTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpMembershipOrderType] PRIMARY KEY CLUSTERED
(
	[MembershipOrderTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpMembershipOrderType] ADD  CONSTRAINT [DF_lkpMembershipOrderType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
