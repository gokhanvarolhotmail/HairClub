/* CreateDate: 01/31/2022 08:45:18.860 , ModifyDate: 02/07/2022 11:06:48.820 */
GO
CREATE TABLE [mktmp].[tmpCorpPricing](
	[Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryID] [float] NULL,
	[GenderID] [float] NULL,
	[Lookup] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NationalPriceMale] [float] NULL,
	[NationalPriceFemale] [float] NULL,
	[MonthlyPriceMale] [float] NULL,
	[MonthlyPriceFemale] [float] NULL
) ON [PRIMARY]
GO
