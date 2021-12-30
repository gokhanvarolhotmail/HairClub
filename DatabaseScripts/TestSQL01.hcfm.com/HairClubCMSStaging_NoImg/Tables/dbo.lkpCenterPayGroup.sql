/* CreateDate: 08/27/2008 11:29:36.960 , ModifyDate: 12/28/2021 09:20:54.533 */
GO
CREATE TABLE [dbo].[lkpCenterPayGroup](
	[CenterPayGroupID] [int] NOT NULL,
	[CenterPayGroupSortOrder] [int] NOT NULL,
	[CenterPayGroupDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterPayGroupDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpCenterPayGroup] PRIMARY KEY CLUSTERED
(
	[CenterPayGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpCenterPayGroup] ADD  CONSTRAINT [DF_lkpCenterPayGroup_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
