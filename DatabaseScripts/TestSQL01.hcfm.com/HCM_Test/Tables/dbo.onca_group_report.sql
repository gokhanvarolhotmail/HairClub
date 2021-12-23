/* CreateDate: 01/18/2005 09:34:10.327 , ModifyDate: 06/21/2012 10:01:00.540 */
GO
CREATE TABLE [dbo].[onca_group_report](
	[group_report_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[report_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_group_report] PRIMARY KEY CLUSTERED
(
	[group_report_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_report]  WITH CHECK ADD  CONSTRAINT [group_group_report_232] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_report] CHECK CONSTRAINT [group_group_report_232]
GO
ALTER TABLE [dbo].[onca_group_report]  WITH CHECK ADD  CONSTRAINT [report_group_group_report_237] FOREIGN KEY([report_group_id])
REFERENCES [dbo].[onca_report_group] ([report_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_report] CHECK CONSTRAINT [report_group_group_report_237]
GO
