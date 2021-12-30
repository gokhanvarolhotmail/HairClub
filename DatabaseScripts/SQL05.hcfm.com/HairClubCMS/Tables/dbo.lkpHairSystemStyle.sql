/* CreateDate: 05/05/2020 17:42:43.947 , ModifyDate: 05/05/2020 18:41:06.130 */
GO
CREATE TABLE [dbo].[lkpHairSystemStyle](
	[HairSystemStyleID] [int] NOT NULL,
	[HairSystemStyleSortOrder] [int] NOT NULL,
	[HairSystemStyleDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemStyleDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[HairSystemStyleGroupID] [int] NOT NULL,
 CONSTRAINT [PK_lkpHairSystemStyle] PRIMARY KEY CLUSTERED
(
	[HairSystemStyleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
