/* CreateDate: 01/18/2005 09:34:09.013 , ModifyDate: 09/10/2019 22:46:08.437 */
/* ***HasTriggers*** TriggerCount: 5 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	[cst_valid_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_dnc_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_last_dnc_date] [datetime] NULL,
	[cst_phone_type_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_phone_type_updated_date] [datetime] NULL,
	[cst_full_phone_number]  AS (left(rtrim([area_code])+rtrim([phone_number]),(10))) PERSISTED,
	[cst_skip_trace_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_phone] PRIMARY KEY CLUSTERED
(
	[contact_phone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
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
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_phone_i3] ON [dbo].[oncd_contact_phone]
(
	[contact_id] ASC,
	[phone_type_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_phone_i4] ON [dbo].[oncd_contact_phone]
(
	[phone_number] ASC,
	[area_code] ASC,
	[country_code_prefix] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
CREATE NONCLUSTERED INDEX [oncd_contact_phone_i6] ON [dbo].[oncd_contact_phone]
(
	[cst_full_phone_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [oncd_contact_phone_i7] ON [dbo].[oncd_contact_phone]
(
	[creation_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [oncd_contact_phone_i8] ON [dbo].[oncd_contact_phone]
(
	[updated_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_phone] ADD  CONSTRAINT [DF_oncd_contact_phone_cst_valid_flag]  DEFAULT (N'Y') FOR [cst_valid_flag]
GO
ALTER TABLE [dbo].[oncd_contact_phone]  WITH CHECK ADD  CONSTRAINT [contact_contact_phon_72] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_phone] CHECK CONSTRAINT [contact_contact_phon_72]
GO
ALTER TABLE [dbo].[oncd_contact_phone]  WITH CHECK ADD  CONSTRAINT [contact_phone_vendor] FOREIGN KEY([cst_skip_trace_vendor_code])
REFERENCES [dbo].[csta_skip_trace_vendor] ([skip_trace_vendor_code])
GO
ALTER TABLE [dbo].[oncd_contact_phone] CHECK CONSTRAINT [contact_phone_vendor]
GO
ALTER TABLE [dbo].[oncd_contact_phone]  WITH CHECK ADD  CONSTRAINT [FK_oncd_contact_phone_csta_dnc] FOREIGN KEY([cst_dnc_code])
REFERENCES [dbo].[csta_dnc] ([dnc_code])
GO
ALTER TABLE [dbo].[oncd_contact_phone] CHECK CONSTRAINT [FK_oncd_contact_phone_csta_dnc]
GO
ALTER TABLE [dbo].[oncd_contact_phone]  WITH CHECK ADD  CONSTRAINT [FK_oncd_contact_phone_phone_type_updated_by_user] FOREIGN KEY([cst_phone_type_updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_phone] CHECK CONSTRAINT [FK_oncd_contact_phone_phone_type_updated_by_user]
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 24 September 2012
-- Description:	Removes Unicode
-- =============================================
CREATE TRIGGER [dbo].[pso_oncd_contact_phone_remove_unicode_insert]
   ON  [dbo].[oncd_contact_phone]
   INSTEAD OF INSERT
AS
BEGIN

INSERT INTO [dbo].[oncd_contact_phone]
           ([contact_phone_id]
           ,[contact_id]
           ,[phone_type_code]
           ,[country_code_prefix]
           ,[area_code]
           ,[phone_number]
           ,[extension]
           ,[description]
           ,[active]
           ,[sort_order]
           ,[creation_date]
           ,[created_by_user_code]
           ,[updated_date]
           ,[updated_by_user_code]
           ,[primary_flag])
           --,[cst_invalid_flag]
           --,[cst_vendor_code]
           --,[cst_service_tier])
     SELECT
           inserted.contact_phone_id
           ,inserted.contact_id
           ,inserted.phone_type_code
           ,dbo.RemoveUnicode(country_code_prefix)
           ,dbo.RemoveUnicode(area_code)
           ,dbo.RemoveUnicode(phone_number)
           ,dbo.RemoveUnicode(extension)
           ,dbo.RemoveUnicode(description)
           ,dbo.RemoveUnicode(active)
           ,inserted.sort_order
           ,inserted.creation_date
           ,inserted.created_by_user_code
           ,inserted.updated_date
           ,inserted.updated_by_user_code
           ,dbo.RemoveUnicode(primary_flag)
           --,<cst_invalid_flag, nchar(1),>
           --,<cst_vendor_code, nchar(10),>
           --,<cst_service_tier, int,>
	FROM inserted



END
GO
ALTER TABLE [dbo].[oncd_contact_phone] DISABLE TRIGGER [pso_oncd_contact_phone_remove_unicode_insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 24 September 2012
-- Description:	Removes Unicode
-- =============================================
CREATE TRIGGER [dbo].[pso_oncd_contact_phone_remove_unicode_update]
   ON  [dbo].[oncd_contact_phone]
   INSTEAD OF UPDATE
AS
BEGIN

UPDATE [dbo].[oncd_contact_phone]
   SET [contact_phone_id] = inserted.contact_phone_id
      ,[contact_id] = inserted.contact_id
      ,[phone_type_code] = inserted.phone_type_code
      ,[country_code_prefix] = dbo.RemoveUnicode(inserted.country_code_prefix)
      ,[area_code] = dbo.RemoveUnicode(inserted.area_code)
      ,[phone_number] = dbo.RemoveUnicode(inserted.phone_number)
      ,[extension] = dbo.RemoveUnicode(inserted.extension)
      ,[description] = dbo.RemoveUnicode(inserted.description)
      ,[active] = dbo.RemoveUnicode(inserted.active)
      ,[sort_order] = inserted.sort_order
      ,[creation_date] = inserted.creation_date
      ,[created_by_user_code] = inserted.created_by_user_code
      ,[updated_date] = inserted.updated_date
      ,[updated_by_user_code] = inserted.updated_by_user_code
      ,[primary_flag] = inserted.primary_flag
      --,[cst_invalid_flag] = <cst_invalid_flag, nchar(1),>
      --,[cst_vendor_code] = <cst_vendor_code, nchar(10),>
      --,[cst_service_tier] = <cst_service_tier, int,>
FROM inserted
WHERE inserted.contact_phone_id = oncd_contact_phone.contact_phone_id





END
GO
ALTER TABLE [dbo].[oncd_contact_phone] DISABLE TRIGGER [pso_oncd_contact_phone_remove_unicode_update]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[pso_PhoneTypeAudit]
   ON  [dbo].[oncd_contact_phone]
   AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE ContactPhone
	SET
		ContactPhone.cst_phone_type_updated_by_user_code = ContactPhone.updated_by_user_code,
		ContactPhone.cst_phone_type_updated_date = ContactPhone.updated_date
	FROM oncd_contact_phone AS ContactPhone
	INNER JOIN inserted ON ContactPhone.contact_phone_id = inserted.contact_phone_id
	LEFT JOIN deleted ON inserted.contact_phone_id = deleted.contact_phone_id
	WHERE
	inserted.phone_type_code <> deleted.phone_type_code OR
	(inserted.phone_type_code IS NULL AND deleted.phone_type_code IS NOT NULL) OR
	(inserted.phone_type_code IS NOT NULL AND deleted.phone_type_code IS NULL)

END
GO
ALTER TABLE [dbo].[oncd_contact_phone] ENABLE TRIGGER [pso_PhoneTypeAudit]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================
-- Create date: 22 March 2010
-- Description:	Ensures that there is not more than one primary phone per
--				contact.  This trigger does not ensure that a primary phone is
--				assigned to a contact; just that there is only a single phone
--				set as primary.
-- =============================================================================
CREATE TRIGGER [dbo].[pso_SinglePrimaryPhone]
   ON  [dbo].[oncd_contact_phone]
   AFTER INSERT,UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @contactPhoneId NCHAR(10)
	DECLARE @contactId NCHAR(10)

	-- The trigger should only run the first time and should not recurse.
    IF ((SELECT TRIGGER_NESTLEVEL()) = 1 )
	BEGIN

		-- Updated values are processed by triggers as a delete then insert.
		DECLARE contact_phone_cursor CURSOR
		FOR
			SELECT inserted.contact_phone_id, inserted.contact_id
			FROM inserted
			WHERE inserted.primary_flag = 'Y'

		OPEN contact_phone_cursor

		FETCH NEXT FROM contact_phone_cursor
		INTO @contactPhoneId, @contactId

		WHILE ( @@FETCH_STATUS = 0 )
		BEGIN

			UPDATE oncd_contact_phone
			SET primary_flag = 'N'
			WHERE
			contact_id = @contactId AND
			primary_flag = 'Y' AND
			contact_phone_id <> @contactPhoneId

			FETCH NEXT FROM contact_phone_cursor
			INTO @contactPhoneId, @contactId
		END

		CLOSE contact_phone_cursor
		DEALLOCATE contact_phone_cursor
	END
END
GO
ALTER TABLE [dbo].[oncd_contact_phone] ENABLE TRIGGER [pso_SinglePrimaryPhone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 5 August 2013
-- =============================================
CREATE TRIGGER [dbo].[pso_ValidatePhoneNumber]
   ON  [dbo].[oncd_contact_phone]
   AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ContactPhoneId NCHAR(10)
	DECLARE @AreaCode NCHAR(10)
	DECLARE @PhoneNumber NCHAR(20)
	DECLARE @ContactId nchar(10)

	IF ((SELECT TRIGGER_NESTLEVEL(OBJECT_ID('pso_ValidatePhoneNumber'))) = 1 )
	BEGIN
		--IF NOT EXISTS (SELECT 1 FROM inserted
		--	LEFT OUTER JOIN deleted ON deleted.contact_phone_id = inserted.contact_phone_id
		--	WHERE ISNULL(inserted.area_code,'') <> ISNULL(deleted.area_code,'') OR ISNULL(inserted.phone_number,'') <> ISNULL(deleted.phone_number,'') OR ISNULL(inserted.cst_valid_flag,'') <> ISNULL(deleted.cst_valid_flag,''))
		--	RETURN

		DECLARE contact_phone_cursor_set_valid_phone_number CURSOR FAST_FORWARD
		FOR
			SELECT contact_phone_id, area_code, phone_number, contact_id
			FROM inserted
			WHERE cst_valid_flag = 'Y'

		OPEN contact_phone_cursor_set_valid_phone_number

		FETCH NEXT FROM contact_phone_cursor_set_valid_phone_number
		INTO @ContactPhoneId, @AreaCode, @PhoneNumber, @ContactId

		WHILE ( @@FETCH_STATUS = 0 )
		BEGIN
			IF (dbo.psoIsValidPhoneNumber(@AreaCode, @PhoneNumber) = 'N')
			BEGIN
				UPDATE oncd_contact_phone
				SET cst_valid_flag = 'N'
				WHERE contact_phone_id = @ContactPhoneId
			END

			-- if any valid/active, make sure one is primary
			IF NOT EXISTS (SELECT 1 FROM oncd_contact_phone cp1 WHERE contact_id = @ContactId AND primary_flag = 'Y')
				AND EXISTS (SELECT 1 FROM oncd_contact_phone cp1 WHERE contact_id = @ContactId AND cst_valid_flag = 'Y' AND active = 'Y')
			BEGIN
				DECLARE @ContactPhoneIdToUpdate nchar(10)
				SET @ContactPhoneIdToUpdate = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone WHERE contact_id = @ContactId AND cst_valid_flag = 'Y' AND active = 'Y' ORDER BY sort_order ASC)
				IF @ContactPhoneIdToUpdate IS NOT NULL
					UPDATE oncd_contact_phone SET primary_flag = 'Y' WHERE contact_phone_id = @ContactPhoneIdToUpdate AND primary_flag <> 'Y'
			END

			FETCH NEXT FROM contact_phone_cursor_set_valid_phone_number
			INTO @ContactPhoneId, @AreaCode, @PhoneNumber, @ContactId
		END

		CLOSE contact_phone_cursor_set_valid_phone_number
		DEALLOCATE contact_phone_cursor_set_valid_phone_number
	END
END
GO
ALTER TABLE [dbo].[oncd_contact_phone] ENABLE TRIGGER [pso_ValidatePhoneNumber]
GO
