/* CreateDate: 02/18/2013 06:49:02.557 , ModifyDate: 12/28/2021 09:20:54.473 */
GO
CREATE TABLE [dbo].[lkpMembershipOrderReasonType](
	[MembershipOrderReasonTypeID] [int] NOT NULL,
	[MembershipOrderReasonTypeSortOrder] [int] NOT NULL,
	[MembershipOrderReasonTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipOrderReasonTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpMembershipOrderReasonType] PRIMARY KEY CLUSTERED
(
	[MembershipOrderReasonTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
