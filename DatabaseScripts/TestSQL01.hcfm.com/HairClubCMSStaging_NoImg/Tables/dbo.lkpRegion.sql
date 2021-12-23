/* CreateDate: 08/27/2008 12:15:41.017 , ModifyDate: 12/03/2021 10:24:48.723 */
GO
CREATE TABLE [dbo].[lkpRegion](
	[RegionID] [int] NOT NULL,
	[RegionSortOrder] [int] NOT NULL,
	[RegionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RegionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[RegionNumber] [int] NULL,
	[RegionalVicePresidentGUID] [uniqueidentifier] NULL,
	[RegionLeadTime] [int] NULL,
 CONSTRAINT [PK_lkpRegion] PRIMARY KEY CLUSTERED
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpRegion] ADD  CONSTRAINT [DF_lkpRegion_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpRegion]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpRegion_datEmployee] FOREIGN KEY([RegionalVicePresidentGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[lkpRegion] CHECK CONSTRAINT [FK_lkpRegion_datEmployee]
GO
