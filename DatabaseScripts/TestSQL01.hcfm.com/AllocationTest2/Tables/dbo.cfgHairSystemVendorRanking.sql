/* CreateDate: 10/31/2019 20:53:42.693 , ModifyDate: 11/01/2019 09:57:48.987 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorRanking](
	[HairSystemVendorRankingID] [int] IDENTITY(1,1) NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[Ranking1VendorID] [int] NULL,
	[Ranking2VendorID] [int] NULL,
	[Ranking3VendorID] [int] NULL,
	[Ranking4VendorID] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ranking5VendorID] [int] NULL,
	[Ranking6VendorID] [int] NULL
) ON [PRIMARY]
GO
