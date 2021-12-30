/* CreateDate: 06/01/2005 13:05:19.637 , ModifyDate: 07/29/2014 03:58:56.717 */
GO
CREATE TABLE [dbo].[oncd_contact_note](
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_note] PRIMARY KEY CLUSTERED
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_note]  WITH CHECK ADD  CONSTRAINT [contact_contact_note_68] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_note] CHECK CONSTRAINT [contact_contact_note_68]
GO
ALTER TABLE [dbo].[oncd_contact_note]  WITH CHECK ADD  CONSTRAINT [user_contact_note_602] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_note] CHECK CONSTRAINT [user_contact_note_602]
GO
ALTER TABLE [dbo].[oncd_contact_note]  WITH CHECK ADD  CONSTRAINT [user_contact_note_603] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_note] CHECK CONSTRAINT [user_contact_note_603]
GO
