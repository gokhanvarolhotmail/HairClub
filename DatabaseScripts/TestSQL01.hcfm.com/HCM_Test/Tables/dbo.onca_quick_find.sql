/* CreateDate: 02/01/2005 14:59:47.107 , ModifyDate: 06/21/2012 10:00:47.120 */
GO
CREATE TABLE [dbo].[onca_quick_find](
	[quick_find_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[toggle_object_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[query_object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_quick_find] PRIMARY KEY CLUSTERED
(
	[quick_find_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_quick_find]  WITH NOCHECK ADD  CONSTRAINT [object_quick_find_365] FOREIGN KEY([query_object_id])
REFERENCES [dbo].[onct_object] ([object_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_quick_find] CHECK CONSTRAINT [object_quick_find_365]
GO
