/* CreateDate: 06/01/2005 13:05:19.247 , ModifyDate: 06/21/2012 10:04:53.540 */
GO
CREATE TABLE [dbo].[oncd_recur_note](
	[recur_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_recur_note] PRIMARY KEY CLUSTERED
(
	[recur_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_recur_note]  WITH NOCHECK ADD  CONSTRAINT [recur_recur_note_211] FOREIGN KEY([recur_id])
REFERENCES [dbo].[oncd_recur] ([recur_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_recur_note] CHECK CONSTRAINT [recur_recur_note_211]
GO
ALTER TABLE [dbo].[oncd_recur_note]  WITH NOCHECK ADD  CONSTRAINT [user_recur_note_488] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_recur_note] CHECK CONSTRAINT [user_recur_note_488]
GO
ALTER TABLE [dbo].[oncd_recur_note]  WITH NOCHECK ADD  CONSTRAINT [user_recur_note_489] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_recur_note] CHECK CONSTRAINT [user_recur_note_489]
GO
