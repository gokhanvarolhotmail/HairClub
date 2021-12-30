/* CreateDate: 05/05/2020 17:42:44.377 , ModifyDate: 05/05/2020 17:43:02.823 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorRanking](
	[HairSystemVendorRankingID] [int] NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[Ranking1VendorID] [int] NULL,
	[Ranking2VendorID] [int] NULL,
	[Ranking3VendorID] [int] NULL,
	[Ranking4VendorID] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[Ranking5VendorID] [int] NULL,
	[Ranking6VendorID] [int] NULL,
 CONSTRAINT [PK_cfgHairSystemVendorRanking] PRIMARY KEY CLUSTERED
(
	[HairSystemVendorRankingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
