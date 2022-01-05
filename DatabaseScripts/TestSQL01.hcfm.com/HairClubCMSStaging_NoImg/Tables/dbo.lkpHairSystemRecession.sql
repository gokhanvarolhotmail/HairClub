/* CreateDate: 10/04/2010 12:08:46.123 , ModifyDate: 01/04/2022 10:56:36.803 */
GO
CREATE TABLE [dbo].[lkpHairSystemRecession](
	[HairSystemRecessionID] [int] NOT NULL,
	[HairSystemRecessionSortOrder] [int] NOT NULL,
	[HairSystemRecessionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemRecessionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsAllowedForMEATemplate] [bit] NOT NULL,
 CONSTRAINT [PK_lkpHairSystemRecession] PRIMARY KEY CLUSTERED
(
	[HairSystemRecessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemRecession] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
