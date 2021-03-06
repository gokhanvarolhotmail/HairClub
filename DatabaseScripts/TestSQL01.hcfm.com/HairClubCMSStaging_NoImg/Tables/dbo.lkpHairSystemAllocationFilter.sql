/* CreateDate: 10/04/2010 12:08:46.210 , ModifyDate: 03/04/2022 16:09:12.737 */
GO
CREATE TABLE [dbo].[lkpHairSystemAllocationFilter](
	[HairSystemAllocationFilterID] [int] NOT NULL,
	[HairSystemAllocationFilterSortOrder] [int] NOT NULL,
	[HairSystemAllocationFilterDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemAllocationFilterDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemAllocationFilter] PRIMARY KEY CLUSTERED
(
	[HairSystemAllocationFilterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemAllocationFilter] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
