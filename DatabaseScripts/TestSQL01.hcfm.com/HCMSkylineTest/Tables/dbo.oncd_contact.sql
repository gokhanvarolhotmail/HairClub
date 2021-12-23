/* CreateDate: 11/08/2012 11:26:54.097 , ModifyDate: 07/11/2017 10:53:44.310 */
GO
CREATE TABLE [dbo].[oncd_contact](
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[greeting] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[middle_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[suffix] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name_search] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name_search] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name_soundex] [nchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name_soundex] [nchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[salutation_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[external_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_method_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[do_not_solicit] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[duplicate_check] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_updated_date] [datetime] NULL,
	[status_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_gender_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_call_time] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_complete_sale] [int] NULL,
	[cst_research] [nchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_dnc_flag] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_referring_store] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_referring_stylist] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_do_not_call] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_language_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_promotion_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_request_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_age_range_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_hair_loss_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_dnc_date] [datetime] NULL,
	[cst_sessionid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_affiliateid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[alt_center] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_loginid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_do_not_email] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_do_not_mail] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_do_not_text] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[surgery_consultation_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_age] [int] NULL,
	[cst_hair_loss_spot_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_hair_loss_experience_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_hair_loss_product] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_hair_loss_in_family_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_hair_loss_family_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_previous_first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_previous_last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_siebel_id] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_contact_accomodation_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact] PRIMARY KEY CLUSTERED
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_i7] ON [dbo].[oncd_contact]
(
	[last_name] ASC,
	[first_name] ASC
)
INCLUDE([contact_id],[contact_status_code],[cst_complete_sale],[cst_contact_accomodation_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_test1] ON [dbo].[oncd_contact]
(
	[contact_status_code] ASC
)
INCLUDE([contact_id],[first_name],[last_name],[creation_date],[created_by_user_code],[cst_gender_code],[cst_complete_sale],[cst_language_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact] ADD  CONSTRAINT [DF_oncd_contact_do_not_solicit]  DEFAULT ('N') FOR [do_not_solicit]
GO
ALTER TABLE [dbo].[oncd_contact] ADD  CONSTRAINT [DF__oncd_cont__cst_d__7D0E9093]  DEFAULT ('N') FOR [cst_do_not_call]
GO
ALTER TABLE [dbo].[oncd_contact] ADD  CONSTRAINT [DF_oncd_contact_cst_language_code]  DEFAULT ('ENGLISH') FOR [cst_language_code]
GO
ALTER TABLE [dbo].[oncd_contact] ADD  DEFAULT ('N') FOR [cst_do_not_email]
GO
ALTER TABLE [dbo].[oncd_contact] ADD  DEFAULT ('N') FOR [cst_do_not_mail]
GO
ALTER TABLE [dbo].[oncd_contact] ADD  CONSTRAINT [DEFALUT_DNTEXT_N]  DEFAULT ('N') FOR [cst_do_not_text]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [contact_meth_contact_563] FOREIGN KEY([contact_method_code])
REFERENCES [dbo].[onca_contact_method] ([contact_method_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [contact_meth_contact_563]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [contact_stat_contact_562] FOREIGN KEY([contact_status_code])
REFERENCES [dbo].[onca_contact_status] ([contact_status_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [contact_stat_contact_562]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [csta_contact_age_range_oncd_contact_734] FOREIGN KEY([cst_age_range_code])
REFERENCES [dbo].[csta_contact_age_range] ([age_range_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [csta_contact_age_range_oncd_contact_734]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [csta_contact_hair_loss_oncd_contact_733] FOREIGN KEY([cst_hair_loss_code])
REFERENCES [dbo].[csta_contact_hair_loss] ([hair_loss_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [csta_contact_hair_loss_oncd_contact_733]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [FK_oncd_contact_csta_contact_accomodation] FOREIGN KEY([cst_contact_accomodation_code])
REFERENCES [dbo].[csta_contact_accomodation] ([contact_accomodation_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [FK_oncd_contact_csta_contact_accomodation]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [FK_oncd_contact_csta_hair_loss_experience] FOREIGN KEY([cst_hair_loss_experience_code])
REFERENCES [dbo].[csta_hair_loss_experience] ([hair_loss_experience_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [FK_oncd_contact_csta_hair_loss_experience]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [FK_oncd_contact_csta_hair_loss_family] FOREIGN KEY([cst_hair_loss_family_code])
REFERENCES [dbo].[csta_hair_loss_family] ([hair_loss_family_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [FK_oncd_contact_csta_hair_loss_family]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [FK_oncd_contact_csta_hair_loss_spot] FOREIGN KEY([cst_hair_loss_spot_code])
REFERENCES [dbo].[csta_hair_loss_spot] ([hair_loss_spot_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [FK_oncd_contact_csta_hair_loss_spot]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [FK_oncd_contact_csta_promotion_code] FOREIGN KEY([cst_promotion_code])
REFERENCES [dbo].[csta_promotion_code] ([promotion_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [FK_oncd_contact_csta_promotion_code]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [salutation_contact_561] FOREIGN KEY([salutation_code])
REFERENCES [dbo].[onca_salutation] ([salutation_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [salutation_contact_561]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [user_contact_564] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [user_contact_564]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [user_contact_565] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [user_contact_565]
GO
ALTER TABLE [dbo].[oncd_contact]  WITH CHECK ADD  CONSTRAINT [user_contact_873] FOREIGN KEY([status_updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact] CHECK CONSTRAINT [user_contact_873]
GO
