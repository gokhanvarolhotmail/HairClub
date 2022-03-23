/* CreateDate: 03/23/2022 09:06:46.417 , ModifyDate: 03/23/2022 09:06:46.417 */
GO
CREATE TABLE [mktmp].[tmp_CorpPricing](
	[Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryID] [float] NULL,
	[GenderID] [float] NULL,
	[Lookup] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NationalPriceMale] [float] NULL,
	[NationalPriceFemale] [float] NULL,
	[MonthlyPriceMale] [float] NULL,
	[MonthlyPriceFemale] [float] NULL,
	[MembershipID] [int] NULL
) ON [PRIMARY]
GO
