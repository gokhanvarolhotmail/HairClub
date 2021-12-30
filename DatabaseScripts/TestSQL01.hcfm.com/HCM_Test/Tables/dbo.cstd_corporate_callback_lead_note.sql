/* CreateDate: 06/18/2013 09:24:41.283 , ModifyDate: 07/21/2014 01:16:22.110 */
GO
CREATE TABLE [dbo].[cstd_corporate_callback_lead_note](
	[corporate_callback_lead_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_corporate_callback_lead_note] PRIMARY KEY CLUSTERED
(
	[corporate_callback_lead_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead_note]  WITH CHECK ADD  CONSTRAINT [FK_cstd_corporate_callback_lead_note_created_by_user] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead_note] CHECK CONSTRAINT [FK_cstd_corporate_callback_lead_note_created_by_user]
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead_note]  WITH CHECK ADD  CONSTRAINT [FK_cstd_corporate_callback_lead_note_cstd_corporate_callback_lead] FOREIGN KEY([corporate_callback_lead_id])
REFERENCES [dbo].[cstd_corporate_callback_lead] ([corporate_callback_lead_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead_note] CHECK CONSTRAINT [FK_cstd_corporate_callback_lead_note_cstd_corporate_callback_lead]
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead_note]  WITH CHECK ADD  CONSTRAINT [FK_cstd_corporate_callback_lead_note_updated_by_user] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead_note] CHECK CONSTRAINT [FK_cstd_corporate_callback_lead_note_updated_by_user]
GO
