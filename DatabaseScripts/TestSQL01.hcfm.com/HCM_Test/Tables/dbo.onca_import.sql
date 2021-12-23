/* CreateDate: 07/13/2005 16:58:18.020 , ModifyDate: 07/21/2014 01:22:30.937 */
GO
CREATE TABLE [dbo].[onca_import](
	[import_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[data_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[import_class_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[update_display] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[commit_after] [int] NULL,
	[stop_on_error] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[log_error] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[log_data] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_table_class_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[backup_source] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[backup_table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_import] PRIMARY KEY CLUSTERED
(
	[import_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_import]  WITH NOCHECK ADD  CONSTRAINT [class_import_374] FOREIGN KEY([import_class_id])
REFERENCES [dbo].[onct_class] ([class_id])
GO
ALTER TABLE [dbo].[onca_import] CHECK CONSTRAINT [class_import_374]
GO
ALTER TABLE [dbo].[onca_import]  WITH NOCHECK ADD  CONSTRAINT [class_import_392] FOREIGN KEY([source_table_class_id])
REFERENCES [dbo].[onct_class] ([class_id])
GO
ALTER TABLE [dbo].[onca_import] CHECK CONSTRAINT [class_import_392]
GO
ALTER TABLE [dbo].[onca_import]  WITH NOCHECK ADD  CONSTRAINT [data_import_372] FOREIGN KEY([data_code])
REFERENCES [dbo].[onca_data] ([data_code])
GO
ALTER TABLE [dbo].[onca_import] CHECK CONSTRAINT [data_import_372]
GO
ALTER TABLE [dbo].[onca_import]  WITH NOCHECK ADD  CONSTRAINT [user_import_836] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[onca_import] CHECK CONSTRAINT [user_import_836]
GO
