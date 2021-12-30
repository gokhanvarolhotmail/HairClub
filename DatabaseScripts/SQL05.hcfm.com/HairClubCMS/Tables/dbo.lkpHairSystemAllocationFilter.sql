/* CreateDate: 05/05/2020 17:42:50.767 , ModifyDate: 05/05/2020 17:43:11.210 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
