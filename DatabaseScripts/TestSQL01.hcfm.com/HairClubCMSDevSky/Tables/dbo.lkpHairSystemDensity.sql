/* CreateDate: 10/04/2010 12:08:46.033 , ModifyDate: 12/29/2021 15:38:46.167 */
GO
CREATE TABLE [dbo].[lkpHairSystemDensity](
	[HairSystemDensityID] [int] NOT NULL,
	[HairSystemDensitySortOrder] [int] NOT NULL,
	[HairSystemDensityDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemDensityDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemDensity] PRIMARY KEY CLUSTERED
(
	[HairSystemDensityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemDensity] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
