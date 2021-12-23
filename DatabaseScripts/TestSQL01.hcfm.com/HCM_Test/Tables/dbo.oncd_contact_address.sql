/* CreateDate: 01/18/2005 09:34:08.810 , ModifyDate: 09/10/2019 22:50:00.873 */
/* ***HasTriggers*** TriggerCount: 6 */
GO
CREATE TABLE [dbo].[oncd_contact_address](
	[contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_3] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_4] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[county_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_valid_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_skip_trace_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_address] PRIMARY KEY CLUSTERED
(
	[contact_address_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_contact_address_i3] ON [dbo].[oncd_contact_address]
(
	[contact_id] ASC,
	[primary_flag] ASC
)
INCLUDE([address_line_1],[city],[state_code],[zip_code],[cst_valid_flag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_oncd_contact_address_updated_date] ON [dbo].[oncd_contact_address]
(
	[updated_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_address_i2] ON [dbo].[oncd_contact_address]
(
	[contact_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_address_test1] ON [dbo].[oncd_contact_address]
(
	[primary_flag] ASC,
	[contact_id] ASC
)
INCLUDE([address_line_1],[address_line_2],[city],[state_code],[zip_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_address_test2] ON [dbo].[oncd_contact_address]
(
	[state_code] ASC,
	[primary_flag] ASC,
	[city] ASC,
	[zip_code] ASC
)
INCLUDE([contact_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_address] ADD  CONSTRAINT [DF_oncd_contact_address_cst_valid_flag]  DEFAULT (N'Y') FOR [cst_valid_flag]
GO
ALTER TABLE [dbo].[oncd_contact_address] ADD  CONSTRAINT [DF_oncd_contact_address_cst_active]  DEFAULT (N'Y') FOR [cst_active]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [address_type_contact_addr_566] FOREIGN KEY([address_type_code])
REFERENCES [dbo].[onca_address_type] ([address_type_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [address_type_contact_addr_566]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [company_addr_contact_addr_798] FOREIGN KEY([company_address_id])
REFERENCES [dbo].[oncd_company_address] ([company_address_id])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [company_addr_contact_addr_798]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [contact_addr_vendor] FOREIGN KEY([cst_skip_trace_vendor_code])
REFERENCES [dbo].[csta_skip_trace_vendor] ([skip_trace_vendor_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [contact_addr_vendor]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [contact_contact_addr_64] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [contact_contact_addr_64]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [country_contact_addr_567] FOREIGN KEY([country_code])
REFERENCES [dbo].[onca_country] ([country_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [country_contact_addr_567]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [county_contact_addr_568] FOREIGN KEY([county_code])
REFERENCES [dbo].[onca_county] ([county_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [county_contact_addr_568]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [state_contact_addr_572] FOREIGN KEY([state_code])
REFERENCES [dbo].[onca_state] ([state_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [state_contact_addr_572]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [time_zone_contact_addr_573] FOREIGN KEY([time_zone_code])
REFERENCES [dbo].[onca_time_zone] ([time_zone_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [time_zone_contact_addr_573]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [user_contact_addr_570] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [user_contact_addr_570]
GO
ALTER TABLE [dbo].[oncd_contact_address]  WITH NOCHECK ADD  CONSTRAINT [user_contact_addr_571] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_address] CHECK CONSTRAINT [user_contact_addr_571]
GO
CREATE TRIGGER [dbo].[pso_oncd_contact_address_after_delete]
   ON  [dbo].[oncd_contact_address]
   AFTER DELETE
AS
	UPDATE cstd_contact_flat SET
		city = dbo.psoRemoveNonAlphaNumeric(ca1.city),
		state_description = onca_state.description,
		zip_code = ca1.zip_code,
		time_zone_code = ca1.time_zone_code,
		contact_address_id = ca1.contact_address_id
	FROM oncd_contact
	INNER JOIN deleted on oncd_contact.contact_id = deleted.contact_id
	LEFT OUTER JOIN oncd_contact_address ca1 ON
		oncd_contact.contact_id = ca1.contact_id AND
		ca1.city IS NOT NULL AND
		ca1.city <> ''
	LEFT OUTER JOIN oncd_contact_address ca2 ON
		oncd_contact.contact_id = ca2.contact_id AND
		ca2.city IS NOT NULL AND
		ca2.city <> '' AND
		(ca1.primary_flag < ca2.primary_flag OR (ca1.primary_flag = ca2.primary_flag AND ca1.sort_order > ca2.sort_order) OR (ca1.primary_flag = ca2.primary_flag AND ca1.sort_order = ca2.sort_order AND ca1.contact_address_id > ca2.contact_address_id))
	LEFT OUTER JOIN onca_state ON
		ca1.state_code = onca_state.state_code
	WHERE cstd_contact_flat.contact_id = oncd_contact.contact_id
		AND ca2.contact_address_id IS NULL
GO
ALTER TABLE [dbo].[oncd_contact_address] ENABLE TRIGGER [pso_oncd_contact_address_after_delete]
GO
CREATE TRIGGER [dbo].[pso_oncd_contact_address_after_insert_update]
   ON  [dbo].[oncd_contact_address]
   AFTER INSERT, UPDATE
AS
	UPDATE cstd_contact_flat SET
		city = dbo.psoRemoveNonAlphaNumeric(ca1.city),
		state_description = onca_state.description,
		zip_code = ca1.zip_code,
		time_zone_code = ca1.time_zone_code,
		contact_address_id = ca1.contact_address_id
	FROM oncd_contact
	INNER JOIN inserted on oncd_contact.contact_id = inserted.contact_id
	LEFT OUTER JOIN oncd_contact_address ca1 ON
		oncd_contact.contact_id = ca1.contact_id AND
		ca1.city IS NOT NULL AND
		ca1.city <> ''
	LEFT OUTER JOIN oncd_contact_address ca2 ON
		oncd_contact.contact_id = ca2.contact_id AND
		ca2.city IS NOT NULL AND
		ca2.city <> '' AND
		(ca1.primary_flag < ca2.primary_flag OR (ca1.primary_flag = ca2.primary_flag AND ca1.sort_order > ca2.sort_order) OR (ca1.primary_flag = ca2.primary_flag AND ca1.sort_order = ca2.sort_order AND ca1.contact_address_id > ca2.contact_address_id))
	LEFT OUTER JOIN onca_state ON
		ca1.state_code = onca_state.state_code
	WHERE cstd_contact_flat.contact_id = oncd_contact.contact_id
		AND ca2.contact_address_id IS NULL
GO
ALTER TABLE [dbo].[oncd_contact_address] ENABLE TRIGGER [pso_oncd_contact_address_after_insert_update]
GO
-- =============================================
-- Create date: 24 September 2012
-- Description:	Removes Unicode
-- =============================================
CREATE TRIGGER [dbo].[pso_oncd_contact_address_remove_unicode_insert]
   ON  [dbo].[oncd_contact_address]
   INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO [dbo].[oncd_contact_address]
			   ([contact_address_id]
			   ,[contact_id]
			   ,[address_type_code]
			   ,[address_line_1]
			   ,[address_line_2]
			   ,[address_line_3]
			   ,[address_line_4]
			   ,[address_line_1_soundex]
			   ,[address_line_2_soundex]
			   ,[city]
			   ,[city_soundex]
			   ,[state_code]
			   ,[zip_code]
			   ,[county_code]
			   ,[country_code]
			   ,[time_zone_code]
			   ,[sort_order]
			   ,[creation_date]
			   ,[created_by_user_code]
			   ,[updated_date]
			   ,[updated_by_user_code]
			   ,[primary_flag]
			   ,[company_address_id])
			   --,[cst_invalid_flag]
			   --,[cst_vendor_code]
			   --,[cst_service_tier])
		 SELECT
				[contact_address_id]
			   ,[contact_id]
			   ,[address_type_code]
			   ,dbo.RemoveUnicode([address_line_1])
			   ,dbo.RemoveUnicode([address_line_2])
			   ,dbo.RemoveUnicode([address_line_3])
			   ,dbo.RemoveUnicode([address_line_4])
			   ,dbo.RemoveUnicode([address_line_1_soundex])
			   ,dbo.RemoveUnicode([address_line_2_soundex])
			   ,dbo.RemoveUnicode([city])
			   ,dbo.RemoveUnicode([city_soundex])
			   ,[state_code]
			   ,dbo.RemoveUnicode([zip_code])
			   ,[county_code]
			   ,[country_code]
			   ,[time_zone_code]
			   ,[sort_order]
			   ,[creation_date]
			   ,[created_by_user_code]
			   ,[updated_date]
			   ,[updated_by_user_code]
			   ,dbo.RemoveUnicode([primary_flag])
			   ,[company_address_id]
			   --,dbo.RemoveUnicode([cst_invalid_flag])
			   --,dbo.RemoveUnicode([cst_vendor_code])
			   --,dbo.RemoveUnicode([cst_service_tier])
			   FROM inserted

END
GO
ALTER TABLE [dbo].[oncd_contact_address] DISABLE TRIGGER [pso_oncd_contact_address_remove_unicode_insert]
GO
CREATE TRIGGER [dbo].[pso_oncd_contact_address_remove_unicode_update]
   ON  [dbo].[oncd_contact_address]
   INSTEAD OF UPDATE
AS
BEGIN
	UPDATE [dbo].[oncd_contact_address]
	   SET [contact_address_id] = inserted.contact_address_id
		  ,[contact_id] = inserted.contact_id
		  ,[address_type_code] = inserted.address_type_code
		  ,[address_line_1] = dbo.RemoveUnicode(inserted.address_line_1)
		  ,[address_line_2] = dbo.RemoveUnicode(inserted.address_line_2)
		  ,[address_line_3] = dbo.RemoveUnicode(inserted.address_line_3)
		  ,[address_line_4] = dbo.RemoveUnicode(inserted.address_line_4)
		  ,[address_line_1_soundex] = dbo.RemoveUnicode(inserted.address_line_1_soundex)
		  ,[address_line_2_soundex] = dbo.RemoveUnicode(inserted.address_line_2_soundex)
		  ,[city] = dbo.RemoveUnicode(inserted.city)
		  ,[city_soundex] = dbo.RemoveUnicode(inserted.city_soundex)
		  ,[state_code] = inserted.state_code
		  ,[zip_code] = dbo.RemoveUnicode(inserted.zip_code)
		  ,[county_code] = inserted.county_code
		  ,[country_code] = inserted.country_code
		  ,[time_zone_code] = inserted.time_zone_code
		  ,[sort_order] = inserted.sort_order
		  ,[creation_date] = inserted.creation_date
		  ,[created_by_user_code] = inserted.created_by_user_code
		  ,[updated_date] = inserted.updated_date
		  ,[updated_by_user_code] = inserted.updated_by_user_code
		  ,[primary_flag] = dbo.RemoveUnicode(inserted.primary_flag)
		  ,[company_address_id] = inserted.company_address_id
		  --,[cst_invalid_flag] = <cst_invalid_flag, nchar(1),>
		  --,[cst_vendor_code] = <cst_vendor_code, nchar(10),>
		  --,[cst_service_tier] = <cst_service_tier, int,>
	FROM inserted
	WHERE inserted.contact_address_id = oncd_contact_address.contact_address_id

END
GO
ALTER TABLE [dbo].[oncd_contact_address] DISABLE TRIGGER [pso_oncd_contact_address_remove_unicode_update]
GO
-- =============================================================================
-- Create date: 22 March 2010
-- Description:	Ensures that there is not more than one primary address per
--				contact.  This trigger does not ensure that a primary address is
--				assigned to a contact; just that there is only a single address
--				set as primary.
-- =============================================================================
CREATE TRIGGER [dbo].[pso_SinglePrimaryAddress]
   ON  [dbo].[oncd_contact_address]
   AFTER INSERT,UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @contactAddressId NCHAR(10)
	DECLARE @contactId NCHAR(10)

	-- The trigger should only run the first time and should not recurse.
    IF ((SELECT TRIGGER_NESTLEVEL()) = 1 )
	BEGIN

		-- Updated values are processed by triggers as a delete then insert.
		DECLARE contact_address_cursor CURSOR
		FOR
			SELECT inserted.contact_address_id, inserted.contact_id
			FROM inserted
			WHERE inserted.primary_flag = 'Y'

		OPEN contact_address_cursor

		FETCH NEXT FROM contact_address_cursor
		INTO @contactAddressId, @contactId

		WHILE ( @@FETCH_STATUS = 0 )
		BEGIN

			UPDATE oncd_contact_address
			SET primary_flag = 'N'
			WHERE
			contact_id = @contactId AND
			primary_flag = 'Y' AND
			contact_address_id <> @contactAddressId

			FETCH NEXT FROM contact_address_cursor
			INTO @contactAddressId, @contactId
		END

		CLOSE contact_address_cursor
		DEALLOCATE contact_address_cursor
	END
END
GO
ALTER TABLE [dbo].[oncd_contact_address] ENABLE TRIGGER [pso_SinglePrimaryAddress]
GO
-- =============================================
-- Author:		Fred Remers
-- Create date: 6/19/2007
-- Description:	Update time zone on activity record based on contact's primary address
-- =============================================
CREATE TRIGGER [dbo].[pso_UpdateActivityTimeZone]
   ON  [dbo].[oncd_contact_address]
   AFTER UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @contact_id nchar(10)
	DECLARE @old_zip_code nchar(15)
	DECLARE @new_zip_code nchar(15)
	DECLARE @old_primary nchar(1)
	DECLARE @new_primary nchar(1)
	DECLARE @tz_code nchar(10)
	DECLARE @county_code nchar(10)

	DECLARE cursor_new CURSOR FOR SELECT contact_id, zip_code, primary_flag FROM inserted
	DECLARE cursor_old CURSOR FOR SELECT zip_code, primary_flag FROM deleted

	OPEN cursor_new
	OPEN cursor_old

	FETCH NEXT FROM cursor_new INTO @contact_id, @new_zip_code, @new_primary
	FETCH NEXT FROM cursor_old INTO @old_zip_code, @old_primary
	WHILE ( @@fetch_status = 0)
	BEGIN
		--Check if either old or new value is primary. If not, there's nothing that needs to be done
		IF (ISNULL(@new_primary,' ') = 'Y' OR ISNULL(@old_primary,' ') = 'Y')
		BEGIN
			--Check if both are primary. If so, verify zip code
			IF (ISNULL(@new_primary,' ') = 'Y' AND ISNULL(@old_primary,' ') = 'Y')
			BEGIN
				--Only process if primary zip code changed
				IF ISNULL(@new_zip_code,' ') <> ISNULL(@old_zip_code,' ')
				BEGIN
					--print 'here'
					SET @tz_code = (select TOP 1 onca_county.time_zone_code from onca_county
						inner join onca_zip on onca_zip.county_code = onca_county.county_code
						and onca_zip.zip_code = @new_zip_code)

					IF(ISNULL(@tz_code,' ') <> ' ')
					UPDATE oncd_activity set cst_time_zone_code = @tz_code
						WHERE oncd_activity.activity_id in
						(select oncd_activity_contact.activity_id from oncd_activity_contact
							inner join oncd_activity on oncd_activity.activity_id = oncd_activity_contact.activity_id
							and (oncd_activity.result_code IS NULL or oncd_activity.result_code = '')
							where oncd_activity_contact.contact_id = @contact_id)
				END
			END
			--Check if only updated value is primary. If so, no need to verify zip code
			ELSE IF (ISNULL(@new_primary,' ') = 'Y')
			BEGIN
				--print 'new primary'
				SET @tz_code = (select top 1 onca_county.time_zone_code from onca_county
					inner join onca_zip on onca_zip.county_code = onca_county.county_code
					and onca_zip.zip_code = @new_zip_code)

					IF(ISNULL(@tz_code,' ') <> ' ')
					UPDATE oncd_activity set cst_time_zone_code = @tz_code
						WHERE oncd_activity.activity_id in
						(select oncd_activity_contact.activity_id from oncd_activity_contact
							inner join oncd_activity on oncd_activity.activity_id = oncd_activity_contact.activity_id
							and (oncd_activity.result_code IS NULL or oncd_activity.result_code = '')
							where oncd_activity_contact.contact_id = @contact_id)

			END
			--Check if only old value is primary - don't really care I guess...
			--ELSE IF (ISNULL(@old_primary,' ') = 'Y')
			--BEGIN
				--print 'primary changed'
			--END
		END
	FETCH NEXT FROM cursor_new INTO @contact_id, @new_zip_code, @new_primary
	FETCH NEXT FROM cursor_old INTO @old_zip_code, @old_primary
	END

	CLOSE cursor_new
	CLOSE cursor_old
	DEALLOCATE cursor_new
	DEALLOCATE cursor_old
END
GO
ALTER TABLE [dbo].[oncd_contact_address] DISABLE TRIGGER [pso_UpdateActivityTimeZone]
GO
