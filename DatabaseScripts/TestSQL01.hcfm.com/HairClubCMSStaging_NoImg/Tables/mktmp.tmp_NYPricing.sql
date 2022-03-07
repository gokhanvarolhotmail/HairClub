/* CreateDate: 01/28/2022 11:48:26.763 , ModifyDate: 02/07/2022 11:18:00.353 */
GO
CREATE TABLE [mktmp].[tmp_NYPricing](
	[MembershipDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryID] [float] NULL,
	[GenderID] [float] NULL,
	[Lookup] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NationalPriceMale] [float] NULL,
	[NationalPriceFemale] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MonthlyPriceMale] [float] NULL,
	[MonthlyPriceFemale] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
