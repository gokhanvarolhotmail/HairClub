/* CreateDate: 10/04/2010 12:08:46.110 , ModifyDate: 12/29/2021 15:38:46.217 */
GO
CREATE TABLE [dbo].[lkpHairSystemHairMaterial](
	[HairSystemHairMaterialID] [int] NOT NULL,
	[HairSystemHairMaterialSortOrder] [int] NOT NULL,
	[HairSystemHairMaterialDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemHairMaterialDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsAvailableForOmbreFlag] [bit] NOT NULL,
	[IsCuticleIntactAvailableFlag] [bit] NOT NULL,
	[IsRootShadowingAvailableFlag] [bit] NOT NULL,
 CONSTRAINT [PK_lkpHairSystemHairMaterial] PRIMARY KEY CLUSTERED
(
	[HairSystemHairMaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemHairMaterial] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
