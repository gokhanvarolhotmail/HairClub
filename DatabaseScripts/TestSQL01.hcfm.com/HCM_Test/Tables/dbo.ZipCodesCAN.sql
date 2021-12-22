/* CreateDate: 06/07/2010 10:16:29.333 , ModifyDate: 06/07/2010 10:16:29.410 */
GO
CREATE TABLE [dbo].[ZipCodesCAN](
	[postalcode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[state] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[province] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cityname] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[citytype] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[countycode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[timezone] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
