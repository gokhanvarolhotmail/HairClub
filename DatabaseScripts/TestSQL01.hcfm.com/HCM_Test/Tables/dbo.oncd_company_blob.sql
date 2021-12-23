/* CreateDate: 01/18/2005 09:34:08.500 , ModifyDate: 06/21/2012 10:10:48.353 */
GO
CREATE TABLE [dbo].[oncd_company_blob](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[attachment_blob] [image] NULL,
 CONSTRAINT [pk_oncd_company_blob] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_blob]  WITH NOCHECK ADD  CONSTRAINT [company_atta_company_blob_95] FOREIGN KEY([attachment_id])
REFERENCES [dbo].[oncd_company_attachment] ([attachment_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_blob] CHECK CONSTRAINT [company_atta_company_blob_95]
GO
