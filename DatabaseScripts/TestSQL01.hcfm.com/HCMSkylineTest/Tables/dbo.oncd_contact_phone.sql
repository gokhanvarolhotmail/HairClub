/* CreateDate: 11/08/2012 13:40:33.250 , ModifyDate: 07/11/2017 10:53:35.510 */
GO
CREATE TABLE [dbo].[oncd_contact_phone](
	[contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code_prefix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[extension] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_lkast_dnc_date] [datetime] NULL,
	[cst_phone_type_update_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_phone_type_update_date] [datetime] NULL,
 CONSTRAINT [pk_oncd_contact_phone] PRIMARY KEY CLUSTERED
(
	[contact_phone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_phone_i2] ON [dbo].[oncd_contact_phone]
(
	[contact_id] ASC,
	[primary_flag] ASC
)
INCLUDE([area_code],[phone_number]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_phone]  WITH CHECK ADD  CONSTRAINT [contact_contact_phon_72] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_phone] CHECK CONSTRAINT [contact_contact_phon_72]
GO
ALTER TABLE [dbo].[oncd_contact_phone]  WITH CHECK ADD  CONSTRAINT [phone_type_contact_phon_609] FOREIGN KEY([phone_type_code])
REFERENCES [dbo].[onca_phone_type] ([phone_type_code])
GO
ALTER TABLE [dbo].[oncd_contact_phone] CHECK CONSTRAINT [phone_type_contact_phon_609]
GO
ALTER TABLE [dbo].[oncd_contact_phone]  WITH CHECK ADD  CONSTRAINT [user_contact_phon_607] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_phone] CHECK CONSTRAINT [user_contact_phon_607]
GO
ALTER TABLE [dbo].[oncd_contact_phone]  WITH CHECK ADD  CONSTRAINT [user_contact_phon_608] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_phone] CHECK CONSTRAINT [user_contact_phon_608]
GO
