/* CreateDate: 01/18/2005 09:34:16.187 , ModifyDate: 06/21/2012 10:05:29.213 */
GO
CREATE TABLE [dbo].[oncd_defect_attachment](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[defect_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[file_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[storage_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_oncd_defect_attachment] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_attachment_i2] ON [dbo].[oncd_defect_attachment]
(
	[defect_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_defect_attachment]  WITH NOCHECK ADD  CONSTRAINT [defect_defect_attac_221] FOREIGN KEY([defect_id])
REFERENCES [dbo].[oncd_defect] ([defect_id])
GO
ALTER TABLE [dbo].[oncd_defect_attachment] CHECK CONSTRAINT [defect_defect_attac_221]
GO
ALTER TABLE [dbo].[oncd_defect_attachment]  WITH NOCHECK ADD  CONSTRAINT [user_defect_attac_642] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_attachment] CHECK CONSTRAINT [user_defect_attac_642]
GO
ALTER TABLE [dbo].[oncd_defect_attachment]  WITH NOCHECK ADD  CONSTRAINT [user_defect_attac_643] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_attachment] CHECK CONSTRAINT [user_defect_attac_643]
GO
