/* CreateDate: 01/18/2005 09:34:12.310 , ModifyDate: 06/21/2012 10:00:47.210 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_report_group_report](
	[report_group_report_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[report_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[report_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_report_group_report] PRIMARY KEY CLUSTERED
(
	[report_group_report_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_report_group_report]  WITH CHECK ADD  CONSTRAINT [report_group_report_group_238] FOREIGN KEY([report_group_id])
REFERENCES [dbo].[onca_report_group] ([report_group_id])
GO
ALTER TABLE [dbo].[onca_report_group_report] CHECK CONSTRAINT [report_group_report_group_238]
GO
ALTER TABLE [dbo].[onca_report_group_report]  WITH CHECK ADD  CONSTRAINT [report_report_group_241] FOREIGN KEY([report_id])
REFERENCES [dbo].[onca_report] ([report_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_report_group_report] CHECK CONSTRAINT [report_report_group_241]
GO
