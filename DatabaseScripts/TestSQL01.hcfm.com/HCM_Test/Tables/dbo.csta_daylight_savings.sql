/* CreateDate: 08/30/2011 11:12:49.727 , ModifyDate: 06/21/2012 10:00:00.110 */
GO
CREATE TABLE [dbo].[csta_daylight_savings](
	[daylight_savings_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[year] [int] NOT NULL,
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
 CONSTRAINT [PK_csta_daylight_savings] PRIMARY KEY CLUSTERED
(
	[daylight_savings_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [csta_daylight_savings_i2] ON [dbo].[csta_daylight_savings]
(
	[year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
