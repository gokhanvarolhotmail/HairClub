/* CreateDate: 01/03/2018 16:31:30.383 , ModifyDate: 11/08/2018 11:05:02.137 */
GO
CREATE TABLE [dbo].[csta_contact_age_range](
	[age_range_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[minimum_age] [int] NULL,
	[maximum_age] [int] NULL,
 CONSTRAINT [pk_csta_contact_age_range] PRIMARY KEY NONCLUSTERED
(
	[age_range_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
