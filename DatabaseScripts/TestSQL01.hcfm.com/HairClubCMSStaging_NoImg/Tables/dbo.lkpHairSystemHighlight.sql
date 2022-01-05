/* CreateDate: 10/04/2010 12:08:46.100 , ModifyDate: 01/04/2022 10:56:36.793 */
GO
CREATE TABLE [dbo].[lkpHairSystemHighlight](
	[HairSystemHighlightID] [int] NOT NULL,
	[HairSystemHighlightSortOrder] [int] NOT NULL,
	[HairSystemHighlightDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemHighlightDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemHighlight] PRIMARY KEY CLUSTERED
(
	[HairSystemHighlightID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemHighlight] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
