/* CreateDate: 01/28/2022 11:48:26.763 , ModifyDate: 01/28/2022 11:48:26.763 */
GO
CREATE TABLE [dbo].[NYPricing](
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
