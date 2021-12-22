/* CreateDate: 06/01/2005 13:04:49.763 , ModifyDate: 06/21/2012 10:00:56.683 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_import_history_error](
	[import_history_error_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[import_history_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[row_number] [int] NULL,
	[error_text] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_import_history_error] PRIMARY KEY CLUSTERED
(
	[import_history_error_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_import_history_error]  WITH CHECK ADD  CONSTRAINT [import_histo_import_histo_373] FOREIGN KEY([import_history_id])
REFERENCES [dbo].[onca_import_history] ([import_history_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_import_history_error] CHECK CONSTRAINT [import_histo_import_histo_373]
GO
