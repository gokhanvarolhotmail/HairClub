/* CreateDate: 01/18/2005 09:34:08.060 , ModifyDate: 07/21/2014 01:22:50.337 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_user_phone](
	[user_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code_prefix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[extension] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_user_phone] PRIMARY KEY CLUSTERED
(
	[user_phone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_user_phone]  WITH NOCHECK ADD  CONSTRAINT [phone_type_user_phone_868] FOREIGN KEY([phone_type_code])
REFERENCES [dbo].[onca_phone_type] ([phone_type_code])
GO
ALTER TABLE [dbo].[onca_user_phone] CHECK CONSTRAINT [phone_type_user_phone_868]
GO
ALTER TABLE [dbo].[onca_user_phone]  WITH CHECK ADD  CONSTRAINT [user_user_phone_136] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_user_phone] CHECK CONSTRAINT [user_user_phone_136]
GO
