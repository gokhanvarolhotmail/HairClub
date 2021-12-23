/* CreateDate: 06/01/2005 13:05:18.590 , ModifyDate: 06/21/2012 10:05:17.933 */
GO
CREATE TABLE [dbo].[oncd_order_note](
	[order_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_order_note] PRIMARY KEY CLUSTERED
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_order_note]  WITH CHECK ADD  CONSTRAINT [order_order_note_174] FOREIGN KEY([order_id])
REFERENCES [dbo].[oncd_order] ([order_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_order_note] CHECK CONSTRAINT [order_order_note_174]
GO
ALTER TABLE [dbo].[oncd_order_note]  WITH CHECK ADD  CONSTRAINT [user_order_note_716] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_order_note] CHECK CONSTRAINT [user_order_note_716]
GO
ALTER TABLE [dbo].[oncd_order_note]  WITH CHECK ADD  CONSTRAINT [user_order_note_717] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_order_note] CHECK CONSTRAINT [user_order_note_717]
GO
