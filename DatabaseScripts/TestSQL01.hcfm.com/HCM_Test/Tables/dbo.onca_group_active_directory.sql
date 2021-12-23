/* CreateDate: 01/25/2010 11:09:09.833 , ModifyDate: 06/21/2012 10:01:00.433 */
GO
CREATE TABLE [dbo].[onca_group_active_directory](
	[group_active_directory_id] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_sid] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_group_active_directory] PRIMARY KEY CLUSTERED
(
	[group_active_directory_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_active_directory]  WITH NOCHECK ADD  CONSTRAINT [group_group_active_1170] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_active_directory] CHECK CONSTRAINT [group_group_active_1170]
GO
