/* CreateDate: 01/18/2005 09:34:20.217 , ModifyDate: 06/21/2012 10:01:04.450 */
GO
CREATE TABLE [dbo].[onca_data](
	[data_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[data_format_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[class_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_data] PRIMARY KEY CLUSTERED
(
	[data_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_data]  WITH CHECK ADD  CONSTRAINT [class_data_393] FOREIGN KEY([class_id])
REFERENCES [dbo].[onct_class] ([class_id])
GO
ALTER TABLE [dbo].[onca_data] CHECK CONSTRAINT [class_data_393]
GO
ALTER TABLE [dbo].[onca_data]  WITH CHECK ADD  CONSTRAINT [data_format_data_327] FOREIGN KEY([data_format_code])
REFERENCES [dbo].[onca_data_format] ([data_format_code])
GO
ALTER TABLE [dbo].[onca_data] CHECK CONSTRAINT [data_format_data_327]
GO
