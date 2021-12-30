/* CreateDate: 05/05/2020 17:42:53.973 , ModifyDate: 05/05/2020 17:43:16.023 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
