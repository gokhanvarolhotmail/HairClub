/* CreateDate: 10/31/2019 20:53:49.480 , ModifyDate: 11/01/2019 09:57:49.000 */
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
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
