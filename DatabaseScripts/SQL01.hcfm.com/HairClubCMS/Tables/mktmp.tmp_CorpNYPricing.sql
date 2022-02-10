/* CreateDate: 01/31/2022 17:10:44.577 , ModifyDate: 02/07/2022 11:19:03.443 */
GO
CREATE TABLE [mktmp].[tmp_CorpNYPricing](
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
