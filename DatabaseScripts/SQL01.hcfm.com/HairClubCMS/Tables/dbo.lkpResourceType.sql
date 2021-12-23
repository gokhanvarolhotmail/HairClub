/* CreateDate: 08/29/2008 09:43:41.043 , ModifyDate: 05/26/2020 10:49:17.457 */
GO
CREATE TABLE [dbo].[lkpResourceType](
	[ResourceTypeID] [int] NOT NULL,
	[ResourceTypeSortOrder] [int] NOT NULL,
	[ResourceTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ResourceTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpResourceType] PRIMARY KEY CLUSTERED
(
	[ResourceTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpResourceType] ADD  CONSTRAINT [DF_lkpResourceType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpResourceType]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpResourceType_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[lkpResourceType] CHECK CONSTRAINT [FK_lkpResourceType_cfgCenter]
GO
