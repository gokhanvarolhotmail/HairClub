/* CreateDate: 10/04/2010 12:08:46.010 , ModifyDate: 12/03/2021 10:24:48.557 */
GO
CREATE TABLE [dbo].[lkpHairSystemMatrixMaterial](
	[HairSystemMatrixMaterialID] [int] NOT NULL,
	[HairSystemMatrixMaterialSortOrder] [int] NOT NULL,
	[HairSystemMatrixMaterialDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemMatrixMaterialDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemMatrixMaterial] PRIMARY KEY CLUSTERED
(
	[HairSystemMatrixMaterialID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemMatrixMaterial] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
