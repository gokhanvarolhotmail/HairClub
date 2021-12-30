/* CreateDate: 05/05/2020 17:42:42.873 , ModifyDate: 05/05/2020 17:43:01.863 */
GO
CREATE TABLE [dbo].[cfgHairSystemDesignTemplateJoin](
	[HairSystemDesignTemplateJoinID] [int] NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemDesignTemplateID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemDesignTemplateJoin] PRIMARY KEY CLUSTERED
(
	[HairSystemDesignTemplateJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
