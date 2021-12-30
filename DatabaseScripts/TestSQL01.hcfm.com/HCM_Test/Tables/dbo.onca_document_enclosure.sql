/* CreateDate: 01/18/2005 09:34:09.967 , ModifyDate: 06/21/2012 10:01:04.807 */
GO
CREATE TABLE [dbo].[onca_document_enclosure](
	[document_enclosure_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[document_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[enclosure_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[default_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[quantity] [int] NULL,
 CONSTRAINT [pk_onca_document_enclosure] PRIMARY KEY CLUSTERED
(
	[document_enclosure_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_document_enclosure]  WITH CHECK ADD  CONSTRAINT [document_document_enc_244] FOREIGN KEY([document_id])
REFERENCES [dbo].[onca_document] ([document_id])
GO
ALTER TABLE [dbo].[onca_document_enclosure] CHECK CONSTRAINT [document_document_enc_244]
GO
ALTER TABLE [dbo].[onca_document_enclosure]  WITH CHECK ADD  CONSTRAINT [enclosure_document_enc_830] FOREIGN KEY([enclosure_code])
REFERENCES [dbo].[onca_enclosure] ([enclosure_code])
GO
ALTER TABLE [dbo].[onca_document_enclosure] CHECK CONSTRAINT [enclosure_document_enc_830]
GO
