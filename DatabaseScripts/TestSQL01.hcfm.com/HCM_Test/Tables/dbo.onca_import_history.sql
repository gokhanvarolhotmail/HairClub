/* CreateDate: 06/01/2005 13:04:49.747 , ModifyDate: 06/21/2012 10:00:56.683 */
GO
CREATE TABLE [dbo].[onca_import_history](
	[import_history_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[import_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[run_number] [int] NOT NULL,
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NULL,
	[process_status] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_import_history] PRIMARY KEY CLUSTERED
(
	[import_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onca_import_history_i2] ON [dbo].[onca_import_history]
(
	[run_number] ASC,
	[import_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_import_history]  WITH NOCHECK ADD  CONSTRAINT [import_import_histo_368] FOREIGN KEY([import_code])
REFERENCES [dbo].[onca_import] ([import_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_import_history] CHECK CONSTRAINT [import_import_histo_368]
GO
