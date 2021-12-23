/* CreateDate: 01/18/2005 09:34:11.950 , ModifyDate: 06/21/2012 10:00:47.167 */
GO
CREATE TABLE [dbo].[onca_report](
	[report_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[entity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[report_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[report_type] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[web_criteria_location] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_report] PRIMARY KEY CLUSTERED
(
	[report_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_report]  WITH CHECK ADD  CONSTRAINT [entity_report_1183] FOREIGN KEY([entity_id])
REFERENCES [dbo].[onct_entity] ([entity_id])
GO
ALTER TABLE [dbo].[onca_report] CHECK CONSTRAINT [entity_report_1183]
GO
ALTER TABLE [dbo].[onca_report]  WITH CHECK ADD  CONSTRAINT [object_report_289] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_report] CHECK CONSTRAINT [object_report_289]
GO
