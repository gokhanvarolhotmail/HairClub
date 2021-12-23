/* CreateDate: 06/18/2013 09:24:41.240 , ModifyDate: 08/11/2014 00:56:18.140 */
GO
CREATE TABLE [dbo].[cstd_admin_lead_note](
	[admin_lead_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_admin_lead_note] PRIMARY KEY CLUSTERED
(
	[admin_lead_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_admin_lead_note]  WITH NOCHECK ADD  CONSTRAINT [FK_cstd_admin_lead_note_created_by_user] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_admin_lead_note] CHECK CONSTRAINT [FK_cstd_admin_lead_note_created_by_user]
GO
ALTER TABLE [dbo].[cstd_admin_lead_note]  WITH NOCHECK ADD  CONSTRAINT [FK_cstd_admin_lead_note_cstd_admin_lead] FOREIGN KEY([admin_lead_id])
REFERENCES [dbo].[cstd_admin_lead] ([admin_lead_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_admin_lead_note] CHECK CONSTRAINT [FK_cstd_admin_lead_note_cstd_admin_lead]
GO
ALTER TABLE [dbo].[cstd_admin_lead_note]  WITH NOCHECK ADD  CONSTRAINT [FK_cstd_admin_lead_note_updated_by_user] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_admin_lead_note] CHECK CONSTRAINT [FK_cstd_admin_lead_note_updated_by_user]
GO
