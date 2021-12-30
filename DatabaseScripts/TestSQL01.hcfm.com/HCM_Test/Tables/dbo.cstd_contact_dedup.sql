/* CreateDate: 05/25/2010 11:10:00.340 , ModifyDate: 05/25/2010 11:10:00.340 */
GO
CREATE TABLE [dbo].[cstd_contact_dedup](
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[first_name_search] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name_search] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[phone] [nchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zipcode] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
