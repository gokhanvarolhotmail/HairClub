/* CreateDate: 01/25/2010 11:09:10.100 , ModifyDate: 06/21/2012 10:05:24.093 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_invoice_note](
	[invoice_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [pk_oncd_invoice_note] PRIMARY KEY CLUSTERED
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_invoice_note]  WITH CHECK ADD  CONSTRAINT [invoice_invoice_note_1118] FOREIGN KEY([invoice_id])
REFERENCES [dbo].[oncd_invoice] ([invoice_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_invoice_note] CHECK CONSTRAINT [invoice_invoice_note_1118]
GO
ALTER TABLE [dbo].[oncd_invoice_note]  WITH CHECK ADD  CONSTRAINT [user_invoice_note_1119] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice_note] CHECK CONSTRAINT [user_invoice_note_1119]
GO
ALTER TABLE [dbo].[oncd_invoice_note]  WITH CHECK ADD  CONSTRAINT [user_invoice_note_1120] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice_note] CHECK CONSTRAINT [user_invoice_note_1120]
GO
