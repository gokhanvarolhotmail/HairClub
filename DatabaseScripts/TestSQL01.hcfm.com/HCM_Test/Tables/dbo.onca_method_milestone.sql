/* CreateDate: 01/18/2005 09:34:14.843 , ModifyDate: 06/21/2012 10:00:52.040 */
GO
CREATE TABLE [dbo].[onca_method_milestone](
	[method_milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[method_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[day_offset] [int] NULL,
	[sort_order] [int] NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_method_milestone] PRIMARY KEY CLUSTERED
(
	[method_milestone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_method_milestone]  WITH NOCHECK ADD  CONSTRAINT [method_method_miles_267] FOREIGN KEY([method_id])
REFERENCES [dbo].[onca_method] ([method_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_method_milestone] CHECK CONSTRAINT [method_method_miles_267]
GO
ALTER TABLE [dbo].[onca_method_milestone]  WITH NOCHECK ADD  CONSTRAINT [milestone_method_miles_268] FOREIGN KEY([milestone_id])
REFERENCES [dbo].[onca_milestone] ([milestone_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_method_milestone] CHECK CONSTRAINT [milestone_method_miles_268]
GO
