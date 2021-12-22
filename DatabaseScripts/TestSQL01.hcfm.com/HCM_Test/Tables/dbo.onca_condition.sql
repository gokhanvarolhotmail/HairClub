/* CreateDate: 01/18/2005 09:34:16.780 , ModifyDate: 06/18/2013 09:25:03.100 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_condition](
	[condition_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[class_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_condition] PRIMARY KEY CLUSTERED
(
	[condition_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_condition]  WITH CHECK ADD  CONSTRAINT [class_condition_291] FOREIGN KEY([class_id])
REFERENCES [dbo].[onct_class] ([class_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_condition] CHECK CONSTRAINT [class_condition_291]
GO
