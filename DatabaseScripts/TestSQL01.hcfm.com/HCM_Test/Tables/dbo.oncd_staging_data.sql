/* CreateDate: 01/18/2005 09:34:14.140 , ModifyDate: 06/21/2012 10:04:53.627 */
GO
CREATE TABLE [dbo].[oncd_staging_data](
	[set_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[key_char] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[key_int] [int] NULL,
	[creation_date] [datetime] NULL,
	[sort_order] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [i1oncd_staging_data] ON [dbo].[oncd_staging_data]
(
	[set_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
