/* CreateDate: 07/13/2005 16:58:17.893 , ModifyDate: 06/21/2012 10:01:04.553 */
GO
CREATE TABLE [dbo].[onca_data_column](
	[data_column_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[data_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[column_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[update_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_data_column] PRIMARY KEY CLUSTERED
(
	[data_column_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onca_data_column_i2] ON [dbo].[onca_data_column]
(
	[data_code] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_data_column]  WITH NOCHECK ADD  CONSTRAINT [data_data_column_326] FOREIGN KEY([data_code])
REFERENCES [dbo].[onca_data] ([data_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_data_column] CHECK CONSTRAINT [data_data_column_326]
GO
