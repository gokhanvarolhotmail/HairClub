/* CreateDate: 11/07/2006 10:14:05.273 , ModifyDate: 09/10/2019 22:58:34.990 */
/* ***HasTriggers*** TriggerCount: 6 */
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
	[cst_sessionid] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[cst_has_valid_cell_phone]  AS ([dbo].[psoHasValidCellPhone]([contact_id])),
	[cst_has_open_confirmation_call]  AS ([dbo].[psoHasOpenConfirmationCall]([contact_id])),
	[cst_siebel_id] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_previous_first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_previous_last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_contact_accomodation_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact] PRIMARY KEY CLUSTERED
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_contact_i3] ON [dbo].[oncd_contact]
(
	[cst_language_code] ASC,
	[do_not_solicit] ASC,
	[cst_do_not_call] ASC,
	[contact_id] ASC
)
INCLUDE([cst_age_range_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_contact_i4] ON [dbo].[oncd_contact]
(
	[contact_id] ASC
)
INCLUDE([first_name],[last_name],[first_name_search],[last_name_search],[contact_status_code],[do_not_solicit],[creation_date],[created_by_user_code],[cst_gender_code],[cst_do_not_call],[cst_language_code],[cst_promotion_code],[cst_age_range_code],[cst_hair_loss_code],[cst_dnc_date],[cst_do_not_email],[cst_do_not_mail],[surgery_consultation_flag],[cst_age],[cst_hair_loss_spot_code],[cst_hair_loss_experience_code],[cst_hair_loss_product],[cst_hair_loss_in_family_code],[cst_hair_loss_family_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_contact_i5] ON [dbo].[oncd_contact]
(
	[cst_siebel_id] ASC
)
INCLUDE([contact_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_contact_i6] ON [dbo].[oncd_contact]
(
	[contact_status_code] ASC,
	[do_not_solicit] ASC,
	[cst_do_not_call] ASC,
	[cst_language_code] ASC,
	[cst_age_range_code] ASC
)
INCLUDE([contact_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Oncd_contact_Creation_date] ON [dbo].[oncd_contact]
(
	[creation_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_oncd_contact_updated_date] ON [dbo].[oncd_contact]
(
	[updated_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_i2] ON [dbo].[oncd_contact]
(
	[first_name_search] ASC,
	[last_name_search] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_i3] ON [dbo].[oncd_contact]
(
	[last_name_search] ASC,
	[first_name_search] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_i4] ON [dbo].[oncd_contact]
(
	[first_name_soundex] ASC,
	[last_name_soundex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
CREATE TRIGGER [dbo].[pso_oncd_contact_after_delete]
   ON  [dbo].[oncd_contact]
   AFTER DELETE
AS
	DELETE FROM cstd_contact_flat
	WHERE cstd_contact_flat.contact_id IN (select contact_id from deleted)
GO
ALTER TABLE [dbo].[oncd_contact] ENABLE TRIGGER [pso_oncd_contact_after_delete]
GO
CREATE TRIGGER [dbo].[pso_oncd_contact_after_insert]
   ON  [dbo].[oncd_contact]
   AFTER INSERT
AS
	INSERT INTO cstd_contact_flat (
		contact_id,
		first_name,
		last_name,
		lead_creation_date,
		lead_created_by_display_name,
		age_range_description,
		hair_loss_alternative_description,
		language_description,
		promotion_description,
		gender_description,
		created_by_user_code,
		do_not_call,
		do_not_solicit,
		contact_status_code)
	SELECT
		inserted.contact_id,
		dbo.psoRemoveNonAlphaNumeric(inserted.first_name),
		dbo.psoRemoveNonAlphaNumeric(inserted.last_name),
		CONVERT(varchar(10), inserted.creation_date, 101),
		dbo.psoRemoveNonAlphaNumeric(onca_user.display_name),
		dbo.psoRemoveNonAlphaNumeric(csta_contact_age_range.description),
		dbo.psoRemoveNonAlphaNumeric(csta_contact_hair_loss.description),
		dbo.psoRemoveNonAlphaNumeric(csta_contact_language.description),
		dbo.psoRemoveNonAlphaNumeric(csta_promotion_code.description),
		CASE inserted.cst_gender_code
			WHEN 'MALE' THEN 'Male'
			WHEN 'FEMALE' THEN 'Female'
		END,
		inserted.created_by_user_code,
		inserted.cst_do_not_call,
		inserted.do_not_solicit,
		inserted.contact_status_code
	FROM inserted
	LEFT OUTER JOIN onca_user ON
		inserted.created_by_user_code = onca_user.user_code
	LEFT OUTER JOIN csta_contact_hair_loss ON
		inserted.cst_hair_loss_code = csta_contact_hair_loss.hair_loss_code
	LEFT OUTER JOIN csta_contact_age_range ON
		inserted.cst_age_range_code = csta_contact_age_range.age_range_code
	LEFT OUTER JOIN csta_contact_language ON
		inserted.cst_language_code = csta_contact_language.language_code
	LEFT OUTER JOIN csta_promotion_code ON
		inserted.cst_promotion_code = csta_promotion_code.promotion_code
GO
ALTER TABLE [dbo].[oncd_contact] ENABLE TRIGGER [pso_oncd_contact_after_insert]
GO
CREATE TRIGGER [dbo].[pso_oncd_contact_after_update]
   ON  [dbo].[oncd_contact]
   AFTER UPDATE
AS

	-- Do not need to update lead_creation_date and lead_created_by_display_name
	-- because these values should never change.
	UPDATE cstd_contact_flat SET
		first_name							= dbo.psoRemoveNonAlphaNumeric(inserted.first_name),
		last_name							= dbo.psoRemoveNonAlphaNumeric(inserted.last_name),
		age_range_description				= dbo.psoRemoveNonAlphaNumeric(csta_contact_age_range.description),
		hair_loss_alternative_description	= dbo.psoRemoveNonAlphaNumeric(csta_contact_hair_loss.description),
		language_description				= dbo.psoRemoveNonAlphaNumeric(csta_contact_language.description),
		promotion_description				= dbo.psoRemoveNonAlphaNumeric(csta_promotion_code.description),
		gender_description					= CASE inserted.cst_gender_code
											      WHEN 'MALE' THEN 'Male'
												  WHEN 'FEMALE' THEN 'Female'
											  END,
		do_not_call	=	inserted.cst_do_not_call,
		do_not_solicit	=	inserted.do_not_solicit,
		contact_status_code	= inserted.contact_status_code
	FROM inserted
	LEFT OUTER JOIN csta_contact_hair_loss ON
		inserted.cst_hair_loss_code = csta_contact_hair_loss.hair_loss_code
	LEFT OUTER JOIN csta_contact_age_range ON
		inserted.cst_age_range_code = csta_contact_age_range.age_range_code
	LEFT OUTER JOIN csta_contact_language ON
		inserted.cst_language_code = csta_contact_language.language_code
	LEFT OUTER JOIN csta_promotion_code ON
		inserted.cst_promotion_code = csta_promotion_code.promotion_code
	WHERE
		inserted.contact_id = cstd_contact_flat.contact_id
GO
ALTER TABLE [dbo].[oncd_contact] ENABLE TRIGGER [pso_oncd_contact_after_update]
GO
-- =============================================
-- Create date: 24 September 2012
-- Description:	Removes Unicode from input data.
-- =============================================
CREATE TRIGGER [dbo].[pso_oncd_contact_remove_unicode_insert]
   ON  [dbo].[oncd_contact]
   INSTEAD OF INSERT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO [dbo].[oncd_contact]
           ([contact_id]
           ,[greeting]
           ,[first_name]
           ,[middle_name]
           ,[last_name]
           ,[suffix]
           ,[first_name_search]
           ,[last_name_search]
           ,[first_name_soundex]
           ,[last_name_soundex]
           ,[salutation_code]
           ,[contact_status_code]
           ,[external_id]
           ,[contact_method_code]
           ,[do_not_solicit]
           ,[duplicate_check]
           ,[creation_date]
           ,[created_by_user_code]
           ,[updated_date]
           ,[updated_by_user_code]
           ,[status_updated_date]
           ,[status_updated_by_user_code]
           ,[cst_gender_code]
           ,[cst_call_time]
           ,[cst_complete_sale]
           ,[cst_research]
           ,[cst_dnc_flag]
           ,[cst_referring_store]
           ,[cst_referring_stylist]
           ,[cst_do_not_call]
           ,[cst_language_code]
           ,[cst_promotion_code]
           ,[cst_request_code]
           ,[cst_age_range_code]
           ,[cst_hair_loss_code]
           ,[cst_dnc_date]
           ,[cst_sessionid]
           ,[cst_affiliateid]
           ,[alt_center]
           ,[cst_loginid]
           ,[cst_do_not_email]
           ,[cst_do_not_mail]
           ,[cst_do_not_text]
           ,[surgery_consultation_flag]
           ,[cst_age]
           ,[cst_hair_loss_spot_code]
           ,[cst_hair_loss_experience_code]
           ,[cst_hair_loss_product]
           ,[cst_hair_loss_in_family_code]
           ,[cst_hair_loss_family_code])
		SELECT
			[contact_id]
           ,dbo.RemoveUnicode([greeting])
           ,dbo.RemoveUnicode([first_name])
           ,dbo.RemoveUnicode([middle_name])
           ,dbo.RemoveUnicode([last_name])
           ,dbo.RemoveUnicode([suffix])
           ,dbo.RemoveUnicode([first_name_search])
           ,dbo.RemoveUnicode([last_name_search])
           ,dbo.RemoveUnicode([first_name_soundex])
           ,dbo.RemoveUnicode([last_name_soundex])
           ,[salutation_code]
           ,[contact_status_code]
           ,dbo.RemoveUnicode([external_id])
           ,[contact_method_code]
           ,dbo.RemoveUnicode([do_not_solicit])
           ,dbo.RemoveUnicode([duplicate_check])
           ,[creation_date]
           ,[created_by_user_code]
           ,[updated_date]
           ,[updated_by_user_code]
           ,[status_updated_date]
           ,[status_updated_by_user_code]
           ,dbo.RemoveUnicode([cst_gender_code])
           ,dbo.RemoveUnicode([cst_call_time])
           ,[cst_complete_sale]
           ,dbo.RemoveUnicode([cst_research])
           ,dbo.RemoveUnicode([cst_dnc_flag])
           ,dbo.RemoveUnicode([cst_referring_store])
           ,dbo.RemoveUnicode([cst_referring_stylist])
           ,dbo.RemoveUnicode([cst_do_not_call])
           ,dbo.RemoveUnicode([cst_language_code])
           ,[cst_promotion_code]
           ,dbo.RemoveUnicode([cst_request_code])
           ,[cst_age_range_code]
           ,[cst_hair_loss_code]
           ,[cst_dnc_date]
           ,dbo.RemoveUnicode([cst_sessionid])
           ,dbo.RemoveUnicode([cst_affiliateid])
           ,dbo.RemoveUnicode([alt_center])
           ,dbo.RemoveUnicode([cst_loginid])
           ,dbo.RemoveUnicode([cst_do_not_email])
           ,dbo.RemoveUnicode([cst_do_not_mail])
           ,dbo.RemoveUnicode([cst_do_not_text])
           ,dbo.RemoveUnicode([surgery_consultation_flag])
           ,dbo.RemoveUnicode([cst_age])
           ,[cst_hair_loss_spot_code]
           ,[cst_hair_loss_experience_code]
           ,dbo.RemoveUnicode([cst_hair_loss_product])
           ,dbo.RemoveUnicode([cst_hair_loss_in_family_code])
           ,[cst_hair_loss_family_code]
           FROM inserted
END
GO
ALTER TABLE [dbo].[oncd_contact] DISABLE TRIGGER [pso_oncd_contact_remove_unicode_insert]
GO
-- =============================================
-- Create date: 24 September 2012
-- Description:	Removes Unicode from input data.
-- =============================================
CREATE TRIGGER [dbo].[pso_oncd_contact_remove_unicode_update]
   ON  [dbo].[oncd_contact]
   INSTEAD OF UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[oncd_contact]
	   SET [contact_id] = inserted.contact_id
		  ,[greeting] = dbo.RemoveUnicode(inserted.greeting)
		  ,[first_name] = dbo.RemoveUnicode(inserted.first_name)
		  ,[middle_name] = dbo.RemoveUnicode(inserted.middle_name)
		  ,[last_name] = dbo.RemoveUnicode(inserted.last_name)
		  ,[suffix] = dbo.RemoveUnicode(inserted.suffix)
		  ,[first_name_search] = dbo.RemoveUnicode(inserted.first_name_search)
		  ,[last_name_search] = dbo.RemoveUnicode(inserted.last_name_search)
		  ,[first_name_soundex] = dbo.RemoveUnicode(inserted.first_name_soundex)
		  ,[last_name_soundex] = dbo.RemoveUnicode(inserted.last_name_soundex)
		  ,[salutation_code] = inserted.salutation_code
		  ,[contact_status_code] = inserted.contact_status_code
		  ,[external_id] = dbo.RemoveUnicode(inserted.external_id)
		  ,[contact_method_code] = inserted.contact_method_code
		  ,[do_not_solicit] = dbo.RemoveUnicode(inserted.do_not_solicit)
		  ,[duplicate_check] = dbo.RemoveUnicode(inserted.duplicate_check)
		  ,[creation_date] = inserted.creation_date
		  ,[created_by_user_code] = inserted.created_by_user_code
		  ,[updated_date] = inserted.updated_date
		  ,[updated_by_user_code] = inserted.updated_by_user_code
		  ,[status_updated_date] = inserted.status_updated_date
		  ,[status_updated_by_user_code] = inserted.status_updated_by_user_code
		  ,[cst_gender_code] = dbo.RemoveUnicode(inserted.cst_gender_code)
		  ,[cst_call_time] = dbo.RemoveUnicode(inserted.cst_call_time)
		  ,[cst_complete_sale] = inserted.cst_complete_sale
		  ,[cst_research] = dbo.RemoveUnicode(inserted.cst_research)
		  ,[cst_dnc_flag] = dbo.RemoveUnicode(inserted.cst_dnc_flag)
		  ,[cst_referring_store] = dbo.RemoveUnicode(inserted.cst_referring_store)
		  ,[cst_referring_stylist] = dbo.RemoveUnicode(inserted.cst_referring_stylist)
		  ,[cst_do_not_call] = dbo.RemoveUnicode(inserted.cst_do_not_call)
		  ,[cst_language_code] = dbo.RemoveUnicode(inserted.cst_language_code)
		  ,[cst_promotion_code] = inserted.cst_promotion_code
		  ,[cst_request_code] = dbo.RemoveUnicode(inserted.cst_request_code)
		  ,[cst_age_range_code] = inserted.cst_age_range_code
		  ,[cst_hair_loss_code] = inserted.cst_hair_loss_code
		  ,[cst_dnc_date] = inserted.cst_dnc_date
		  ,[cst_sessionid] = dbo.RemoveUnicode(inserted.cst_sessionid)
		  ,[cst_affiliateid] = dbo.RemoveUnicode(inserted.cst_affiliateid)
		  ,[alt_center] = dbo.RemoveUnicode(inserted.alt_center)
		  ,[cst_loginid] = dbo.RemoveUnicode(inserted.cst_loginid)
		  ,[cst_do_not_email] = dbo.RemoveUnicode(inserted.cst_do_not_email)
		  ,[cst_do_not_mail] = dbo.RemoveUnicode(inserted.cst_do_not_mail)
		  ,[cst_do_not_text] = dbo.RemoveUnicode(inserted.cst_do_not_text)
		  ,[surgery_consultation_flag] = dbo.RemoveUnicode(inserted.surgery_consultation_flag)
		  ,[cst_age] = inserted.cst_age
		  ,[cst_hair_loss_spot_code] = inserted.cst_hair_loss_spot_code
		  ,[cst_hair_loss_experience_code] = inserted.cst_hair_loss_experience_code
		  ,[cst_hair_loss_product] = dbo.RemoveUnicode(inserted.cst_hair_loss_product)
		  ,[cst_hair_loss_in_family_code] = dbo.RemoveUnicode(inserted.cst_hair_loss_in_family_code)
		  ,[cst_hair_loss_family_code] = inserted.cst_hair_loss_family_code
	 FROM inserted
		WHERE inserted.contact_id = oncd_contact.contact_id


END
GO
ALTER TABLE [dbo].[oncd_contact] DISABLE TRIGGER [pso_oncd_contact_remove_unicode_update]
GO
-- =============================================
-- Author:		Oncontact PSO Fred Remers
-- Create date: 12/04/08
-- Description:	If a contact has a contact status = 'LEAD' and an Show No Sale Outbound Call has been logged
-- that is still open and the Contact Status changes to CLIENT, the Show No Sale Outbound Call should be closed.
-- Updated: 11/03/09 ONC MJW.  Update <all> unresulted activities, not just SHNOBUYCAL
-- Updated: 2016-01-26   MJW.  Set all phones to DNC if Contact cst_do_not_call was set
-- =============================================

CREATE TRIGGER [dbo].[pso_oncd_contact_update]
   ON  [dbo].[oncd_contact]
   AFTER UPDATE AS
BEGIN

IF ( (SELECT trigger_nestlevel() ) <= 1 )
	BEGIN
		IF Cursor_Status('local', 'contact_trigger_data') >= 0
		BEGIN
			CLOSE contact_trigger_data
			DEALLOCATE contact_trigger_data
		END
		IF Cursor_Status('global', 'contact_trigger_data') >= 0
		BEGIN
			CLOSE contact_trigger_data
			DEALLOCATE contact_trigger_data
		END

		DECLARE @contact_id nchar(10)
		DECLARE @new_contact_status_code nchar(10)
		DECLARE @old_contact_status_code nchar(10)
		DECLARE @old_cst_do_not_call nchar(1)
		DECLARE @new_cst_do_not_call nchar(1)
		DECLARE @updated_by_user_code nchar(20)

		IF (SELECT user_code FROM onca_user WHERE user_code = 'TRIGGER') IS NULL
			INSERT INTO onca_user (user_code, description, display_name, active) VALUES ('TRIGGER', 'Trigger', 'Trigger', 'N')

		DECLARE contact_trigger_data CURSOR FOR
			SELECT inserted.contact_id, inserted.contact_status_code, deleted.contact_status_code, inserted.cst_do_not_call, deleted.cst_do_not_call, inserted.updated_by_user_code
			FROM inserted
			LEFT OUTER JOIN deleted on inserted.contact_id = deleted.contact_id

		OPEN contact_trigger_data

		FETCH NEXT FROM contact_trigger_data INTO @contact_id, @new_contact_status_code, @old_contact_status_code, @new_cst_do_not_call, @old_cst_do_not_call, @updated_by_user_code

		WHILE (@@fetch_status = 0)
		BEGIN

			if(@new_contact_status_code = 'CLIENT' and @old_contact_status_code = 'LEAD')
			BEGIN
				update oncd_activity set
					result_code = 'CANCEL', updated_date = GETDATE(),
			 		updated_by_user_code = 'TRIGGER', completed_by_user_code = 'TRIGGER',
					completion_date = dbo.CombineDates(GETDATE(), null),
			  		completion_time = dbo.CombineDates(null, GETDATE())
				where activity_id =
					(select a.activity_id from oncd_activity a
			  		inner join oncd_activity_contact ac on ac.activity_id = a.activity_id
			    		and ac.contact_id = @contact_id
			  		where (a.result_code is null or a.result_code = ''))
			END

			IF (@new_cst_do_not_call = 'Y' AND ISNULL(@old_cst_do_not_call,'N') <> 'Y')
			BEGIN
				INSERT INTO cstd_phone_dnc_wireless (phone_dnc_wireless_id, phonenumber, creation_date, created_by_user_code)
				SELECT NEWID(), cst_full_phone_number, GETDATE(), @updated_by_user_code
					FROM oncd_contact_phone
					WHERE contact_id = @contact_id
						AND NOT EXISTS (SELECT 1 FROM cstd_phone_dnc_wireless dw1 WHERE phonenumber = cst_full_phone_number)
						AND area_code IS NOT NULL AND phone_number IS NOT NULL

				UPDATE dw SET
					dnc_flag = 'Y',
					dnc_date = GETDATE(),
					dnc_flag_user_code = @updated_by_user_code,
					updated_date = GETDATE(),
					updated_by_user_code = @updated_by_user_code
				FROM cstd_phone_dnc_wireless dw
				INNER JOIN oncd_contact_phone cp ON cp.cst_full_phone_number = dw.phonenumber AND cp.contact_id = @contact_id
				WHERE (dnc_flag <> 'Y' OR dnc_flag IS NULL) OR dnc_date < DATEADD(d, -12, GETDATE())
			END

			FETCH NEXT FROM contact_trigger_data INTO @contact_id, @new_contact_status_code, @old_contact_status_code, @new_cst_do_not_call, @old_cst_do_not_call, @updated_by_user_code
		END
		CLOSE contact_trigger_data
		DEALLOCATE contact_trigger_data
	END


END
GO
ALTER TABLE [dbo].[oncd_contact] ENABLE TRIGGER [pso_oncd_contact_update]
GO
