/* CreateDate: 01/18/2005 09:34:11.827 , ModifyDate: 06/21/2012 10:00:52.217 */
GO
CREATE TABLE [dbo].[onca_phone_number](
	[phone_number_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[phone_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[phone_number] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_phone_number] PRIMARY KEY CLUSTERED
(
	[phone_number_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_phone_number]  WITH CHECK ADD  CONSTRAINT [phone_group_phone_number_255] FOREIGN KEY([phone_group_id])
REFERENCES [dbo].[onca_phone_group] ([phone_group_id])
GO
ALTER TABLE [dbo].[onca_phone_number] CHECK CONSTRAINT [phone_group_phone_number_255]
GO
