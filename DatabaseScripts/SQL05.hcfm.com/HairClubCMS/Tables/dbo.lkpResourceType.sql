/* CreateDate: 05/05/2020 17:42:39.397 , ModifyDate: 05/05/2020 18:28:47.167 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
ALTER TABLE [dbo].[lkpResourceType]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpResourceType_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[lkpResourceType] CHECK CONSTRAINT [FK_lkpResourceType_cfgCenter]
GO
