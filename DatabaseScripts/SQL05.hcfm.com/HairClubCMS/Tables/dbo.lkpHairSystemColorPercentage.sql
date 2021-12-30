/* CreateDate: 05/05/2020 17:42:46.007 , ModifyDate: 05/05/2020 17:43:05.000 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
