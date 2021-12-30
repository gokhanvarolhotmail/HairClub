/* CreateDate: 05/05/2020 17:42:43.327 , ModifyDate: 05/05/2020 17:43:01.907 */
GO
CREATE TABLE [dbo].[cfgHairSystemHairMaterialJoin](
	[HairSystemHairMaterialJoin] [int] NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemHairMaterialID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgHairSystemHairMaterialJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemHairMaterialJoin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
