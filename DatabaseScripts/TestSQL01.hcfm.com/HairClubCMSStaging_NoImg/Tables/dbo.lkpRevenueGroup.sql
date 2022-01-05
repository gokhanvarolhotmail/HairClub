/* CreateDate: 08/27/2008 12:17:00.943 , ModifyDate: 01/04/2022 10:56:36.963 */
GO
CREATE TABLE [dbo].[lkpRevenueGroup](
	[RevenueGroupID] [int] NOT NULL,
	[RevenueGroupSortOrder] [int] NOT NULL,
	[RevenueGroupDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RevenueGroupDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpRevenueGroup] PRIMARY KEY CLUSTERED
(
	[RevenueGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpRevenueGroup] ADD  CONSTRAINT [DF_lkpRevenueGroup_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
