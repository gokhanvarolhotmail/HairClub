/* CreateDate: 10/04/2010 12:08:46.080 , ModifyDate: 03/04/2022 16:09:12.610 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemStyle] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemStyle]  WITH CHECK ADD  CONSTRAINT [FK_lkpHairSystemStyle_lkpHairSystemStyleGroup] FOREIGN KEY([HairSystemStyleGroupID])
REFERENCES [dbo].[lkpHairSystemStyleGroup] ([HairSystemStyleGroupID])
GO
ALTER TABLE [dbo].[lkpHairSystemStyle] CHECK CONSTRAINT [FK_lkpHairSystemStyle_lkpHairSystemStyleGroup]
GO
