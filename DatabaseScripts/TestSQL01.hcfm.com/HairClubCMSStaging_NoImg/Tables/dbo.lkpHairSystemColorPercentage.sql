/* CreateDate: 10/04/2010 12:08:46.090 , ModifyDate: 12/03/2021 10:24:48.583 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpHairSystemColorPercentage](
	[HairSystemColorPercentageID] [int] NOT NULL,
	[HairSystemColorPercentageSortOrder] [int] NOT NULL,
	[HairSystemColorPercentageDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemColorPercentageDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemColorPercentageValue] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[HairSystemColorPercentageValueDecimal] [decimal](3, 0) NULL,
 CONSTRAINT [PK_lkpHairSystemColorPercentage] PRIMARY KEY CLUSTERED
(
	[HairSystemColorPercentageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemColorPercentage] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
