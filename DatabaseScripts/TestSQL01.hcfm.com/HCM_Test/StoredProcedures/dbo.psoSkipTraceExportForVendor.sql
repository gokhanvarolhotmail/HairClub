/* CreateDate: 12/04/2015 15:34:10.340 , ModifyDate: 12/04/2015 15:34:10.340 */
GO
-- =============================================
-- Author:		Workwise, LLC	- MJW
-- Create date: 2015-10-12
-- Description:	Generate skip trace export for specific vendor
-- =============================================
CREATE PROCEDURE [dbo].[psoSkipTraceExportForVendor]
	-- Add the parameters for the stored procedure here
	@vendor_code	nvarchar(20),
	@count			int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @vendor_code = RTRIM(@vendor_code)
	IF @count IS NULL
		SET @count = 2 * (POWER(1024,3) - 1) + 1

PRINT @vendor_code + ' started at                   ' + CONVERT(nchar(23),GETDATE(),121)

	DECLARE @cmdstring varchar(1023)

	DECLARE @skip_trace_export_id uniqueidentifier
	DECLARE @skip_send_date NCHAR(8)

	SET @skip_send_date = REPLACE(CONVERT(nchar(10),GETDATE(),121),'-','')

	--Establish export header
	SET @skip_trace_export_id = NEWID()

	INSERT INTO cstd_skip_trace_export (skip_trace_export_id, export_date, vendor_code, [system_user])
		VALUES (@skip_trace_export_id, GETDATE(), @vendor_code, SYSTEM_USER)


	TRUNCATE TABLE cstd_skip_trace_export_staging
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[cstd_skip_trace_export_staging]') AND name = N'skiptracevendor_i1')
		DROP INDEX [skiptracevendor_i1] ON [dbo].[cstd_skip_trace_export_staging] WITH ( ONLINE = OFF )


	--Contacts to send
	INSERT INTO cstd_skip_trace_export_staging (contact_id, VendorCode, skip_send_date, skip_trace_export_id)
	SELECT DISTINCT TOP (@count) contact_id, next_vendor_code, @skip_send_date, @skip_trace_export_id
	FROM
	cstd_skip_trace_export_candidates
	WHERE next_vendor_code = @vendor_code
	ORDER BY next_vendor_code, contact_id


PRINT @vendor_code + ' select completed at ' + CONVERT(nchar(23),GETDATE(),121)
	--index for UPDATES
	CREATE CLUSTERED INDEX skiptracevendor_i1 ON cstd_skip_trace_export_staging(contact_id)

PRINT @vendor_code + ' indexed at                   ' + CONVERT(nchar(23),GETDATE(),121)
	--UPDATE Contact info
	UPDATE s SET
		first_name = RTRIM(c.first_name),
		middle_name = RTRIM(c.middle_name),
		last_name = RTRIM(c.last_name)
	FROM cstd_skip_trace_export_staging s
	LEFT OUTER JOIN oncd_contact c WITH (NOLOCK) ON c.contact_id = s.contact_id

PRINT @vendor_code + ' contact info completed at    ' + CONVERT(nchar(23),GETDATE(),121)

	--Loop by Contact
	DECLARE @contact_id nchar(10)
	DECLARE @skip_trace_export_detail_id_contact uniqueidentifier
	DECLARE @c_counter int
	SET @c_counter = 0

	DECLARE contact CURSOR FAST_FORWARD FOR
	SELECT contact_id FROM cstd_skip_trace_export_staging ORDER BY contact_id
	OPEN contact

	FETCH contact INTO @contact_id
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @c_counter = @c_counter + 1

		DECLARE @counter int
		SET @skip_trace_export_detail_id_contact = NEWID()
		UPDATE cstd_skip_trace_export_staging SET skip_request_id = @c_counter WHERE contact_id = @contact_id
		INSERT INTO cstd_skip_trace_export_detail
			(skip_trace_export_detail_id, skip_trace_export_id, entity_id, entity_table_name, row_sequence, slot_number)
			VALUES
			(@skip_trace_export_detail_id_contact, @skip_trace_export_id, @contact_id, 'oncd_contact', @c_counter, NULL)

		--Addresses
		DECLARE @contact_address_id nchar(10)
		DECLARE @address_line_1		nvarchar(60)
		DECLARE @address_line_2		nvarchar(60)
		DECLARE @address_line_3		nvarchar(60)
		DECLARE @city				nvarchar(60)
		DECLARE @state_code			nvarchar(20)
		DECLARE @zip_code			nvarchar(15)
		DECLARE @country_code		nvarchar(20)
		DECLARE @cst_valid_flag		nchar(1)
		DECLARE @skip_address		nchar(1)

		SET @skip_address = 'Y'
		SET @counter = 0

		DECLARE c_addresses CURSOR FAST_FORWARD FOR
			SELECT TOP 10
				contact_address_id,
				RTRIM(address_line_1), RTRIM(address_line_2), RTRIM(address_line_3), RTRIM(city), RTRIM(state_code), RTRIM(zip_code), RTRIM(country_code), ISNULL(cst_valid_flag,'N') AS cst_valid_flag
			FROM oncd_contact_address WITH (NOLOCK) WHERE contact_id = @contact_id

			ORDER BY cst_valid_flag DESC, primary_flag DESC, updated_date DESC
		OPEN c_addresses

		FETCH c_addresses INTO @contact_address_id, @address_line_1, @address_line_2, @address_line_3, @city, @state_code, @zip_code, @country_code, @cst_valid_flag
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @cst_valid_flag = 'Y'
				SET @skip_address = 'N'

			SET @counter = @counter + 1

			IF @counter = 1
				UPDATE cstd_skip_trace_export_staging SET
				E1_contact_address_id	= @contact_address_id,
				E1_address_line_1		= @address_line_1,
				E1_address_line_2		= @address_line_2,
				E1_address_line_3		= @address_line_3,
				E1_city					= @city,
				E1_state_code			= @state_code,
				E1_zip_code				= @zip_code,
				E1_country_code			= @country_code
				WHERE contact_id = @contact_id
			ELSE IF @counter = 2
				UPDATE cstd_skip_trace_export_staging SET
				E2_contact_address_id	= @contact_address_id,
				E2_address_line_1		= @address_line_1,
				E2_address_line_2		= @address_line_2,
				E2_address_line_3		= @address_line_3,
				E2_city					= @city,
				E2_state_code			= @state_code,
				E2_zip_code				= @zip_code,
				E2_country_code			= @country_code
				WHERE contact_id = @contact_id
			ELSE IF @counter = 3
				UPDATE cstd_skip_trace_export_staging SET
				E3_contact_address_id	= @contact_address_id,
				E3_address_line_1		= @address_line_1,
				E3_address_line_2		= @address_line_2,
				E3_address_line_3		= @address_line_3,
				E3_city					= @city,
				E3_state_code			= @state_code,
				E3_zip_code				= @zip_code,
				E3_country_code			= @country_code
				WHERE contact_id = @contact_id
			ELSE IF @counter = 4
				UPDATE cstd_skip_trace_export_staging SET
				E4_contact_address_id	= @contact_address_id,
				E4_address_line_1		= @address_line_1,
				E4_address_line_2		= @address_line_2,
				E4_address_line_3		= @address_line_3,
				E4_city					= @city,
				E4_state_code			= @state_code,
				E4_zip_code				= @zip_code,
				E4_country_code			= @country_code
				WHERE contact_id = @contact_id
			ELSE IF @counter = 5
				UPDATE cstd_skip_trace_export_staging SET
				E5_contact_address_id	= @contact_address_id,
				E5_address_line_1		= @address_line_1,
				E5_address_line_2		= @address_line_2,
				E5_address_line_3		= @address_line_3,
				E5_city					= @city,
				E5_state_code			= @state_code,
				E5_zip_code				= @zip_code,
				E5_country_code			= @country_code
				WHERE contact_id = @contact_id
			ELSE IF @counter = 6
				UPDATE cstd_skip_trace_export_staging SET
				E6_contact_address_id	= @contact_address_id,
				E6_address_line_1		= @address_line_1,
				E6_address_line_2		= @address_line_2,
				E6_address_line_3		= @address_line_3,
				E6_city					= @city,
				E6_state_code			= @state_code,
				E6_zip_code				= @zip_code,
				E6_country_code			= @country_code
				WHERE contact_id = @contact_id
			ELSE IF @counter = 7
				UPDATE cstd_skip_trace_export_staging SET
				E7_contact_address_id	= @contact_address_id,
				E7_address_line_1		= @address_line_1,
				E7_address_line_2		= @address_line_2,
				E7_address_line_3		= @address_line_3,
				E7_city					= @city,
				E7_state_code			= @state_code,
				E7_zip_code				= @zip_code,
				E7_country_code			= @country_code
				WHERE contact_id = @contact_id
			ELSE IF @counter = 8
				UPDATE cstd_skip_trace_export_staging SET
				E8_contact_address_id	= @contact_address_id,
				E8_address_line_1		= @address_line_1,
				E8_address_line_2		= @address_line_2,
				E8_address_line_3		= @address_line_3,
				E8_city					= @city,
				E8_state_code			= @state_code,
				E8_zip_code				= @zip_code,
				E8_country_code			= @country_code
				WHERE contact_id = @contact_id
			ELSE IF @counter = 9
				UPDATE cstd_skip_trace_export_staging SET
				E9_contact_address_id	= @contact_address_id,
				E9_address_line_1		= @address_line_1,
				E9_address_line_2		= @address_line_2,
				E9_address_line_3		= @address_line_3,
				E9_city					= @city,
				E9_state_code			= @state_code,
				E9_zip_code				= @zip_code,
				E9_country_code			= @country_code
				WHERE contact_id = @contact_id
			ELSE IF @counter = 10
				UPDATE cstd_skip_trace_export_staging SET
				E10_contact_address_id	= @contact_address_id,
				E10_address_line_1		= @address_line_1,
				E10_address_line_2		= @address_line_2,
				E10_address_line_3		= @address_line_3,
				E10_city					= @city,
				E10_state_code			= @state_code,
				E10_zip_code				= @zip_code,
				E10_country_code			= @country_code
				WHERE contact_id = @contact_id

			INSERT INTO cstd_skip_trace_export_detail
			(skip_trace_export_detail_id, skip_trace_export_id, entity_id, entity_table_name, row_sequence, slot_number)
			VALUES
			(NEWID(), @skip_trace_export_id, @contact_address_id, 'oncd_contact_address', @c_counter, @counter)

			FETCH c_addresses INTO @contact_address_id, @address_line_1, @address_line_2, @address_line_3, @city, @state_code, @zip_code, @country_code, @cst_valid_flag
		END

		CLOSE c_addresses
		DEALLOCATE c_addresses

		UPDATE cstd_skip_trace_export_staging SET skip_address = @skip_address WHERE contact_id = @contact_id
		--Addresses END

		--Phones
		DECLARE @contact_phone_id	nchar(10)
		DECLARE @country_code_prefix nvarchar(10)
		DECLARE @area_code			nvarchar(10)
		DECLARE @phone_number		nvarchar(20)
		DECLARE @extension			nvarchar(10)
		DECLARE @skip_phone			nchar(1)

		SET @skip_phone = 'Y'
		SET @counter = 0

		DECLARE c_phones CURSOR FAST_FORWARD FOR
			SELECT TOP 10
				contact_phone_id,
				RTRIM(country_code_prefix), RTRIM(area_code), RTRIM(phone_number), RTRIM(extension), ISNULL(cst_valid_flag,'N') AS cst_valid_flag
			FROM oncd_contact_phone WITH (NOLOCK) WHERE contact_id = @contact_id
			ORDER BY cst_valid_flag DESC, primary_flag DESC, updated_date DESC
		OPEN c_phones

		FETCH c_phones INTO @contact_phone_id, @country_code_prefix, @area_code, @phone_number, @extension, @cst_valid_flag
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @cst_valid_flag = 'Y'
				SET @skip_phone = 'N'

			SET @counter = @counter + 1

			IF @counter = 1
				UPDATE cstd_skip_trace_export_staging SET
				E1_contact_phone_id		= @contact_phone_id,
				E1_country_code_prefix	= @country_code_prefix,
				E1_area_code			= @area_code,
				E1_phone_number			= @phone_number,
				E1_extension			= @extension
				WHERE contact_id = @contact_id
			ELSE IF @counter = 2
				UPDATE cstd_skip_trace_export_staging SET
				E2_contact_phone_id		= @contact_phone_id,
				E2_country_code_prefix	= @country_code_prefix,
				E2_area_code			= @area_code,
				E2_phone_number			= @phone_number,
				E2_extension			= @extension
				WHERE contact_id = @contact_id
			ELSE IF @counter = 3
				UPDATE cstd_skip_trace_export_staging SET
				E3_contact_phone_id		= @contact_phone_id,
				E3_country_code_prefix	= @country_code_prefix,
				E3_area_code			= @area_code,
				E3_phone_number			= @phone_number,
				E3_extension			= @extension
				WHERE contact_id = @contact_id
			ELSE IF @counter = 4
				UPDATE cstd_skip_trace_export_staging SET
				E4_contact_phone_id		= @contact_phone_id,
				E4_country_code_prefix	= @country_code_prefix,
				E4_area_code			= @area_code,
				E4_phone_number			= @phone_number,
				E4_extension			= @extension
				WHERE contact_id = @contact_id
			ELSE IF @counter = 5
				UPDATE cstd_skip_trace_export_staging SET
				E5_contact_phone_id		= @contact_phone_id,
				E5_country_code_prefix	= @country_code_prefix,
				E5_area_code			= @area_code,
				E5_phone_number			= @phone_number,
				E5_extension			= @extension
				WHERE contact_id = @contact_id
			ELSE IF @counter = 6
				UPDATE cstd_skip_trace_export_staging SET
				E6_contact_phone_id		= @contact_phone_id,
				E6_country_code_prefix	= @country_code_prefix,
				E6_area_code			= @area_code,
				E6_phone_number			= @phone_number,
				E6_extension			= @extension
				WHERE contact_id = @contact_id
			ELSE IF @counter = 7
				UPDATE cstd_skip_trace_export_staging SET
				E7_contact_phone_id		= @contact_phone_id,
				E7_country_code_prefix	= @country_code_prefix,
				E7_area_code			= @area_code,
				E7_phone_number			= @phone_number,
				E7_extension			= @extension
				WHERE contact_id = @contact_id
			ELSE IF @counter = 8
				UPDATE cstd_skip_trace_export_staging SET
				E8_contact_phone_id		= @contact_phone_id,
				E8_country_code_prefix	= @country_code_prefix,
				E8_area_code			= @area_code,
				E8_phone_number			= @phone_number,
				E8_extension			= @extension
				WHERE contact_id = @contact_id
			ELSE IF @counter = 9
				UPDATE cstd_skip_trace_export_staging SET
				E9_contact_phone_id		= @contact_phone_id,
				E9_country_code_prefix	= @country_code_prefix,
				E9_area_code			= @area_code,
				E9_phone_number			= @phone_number,
				E9_extension			= @extension
				WHERE contact_id = @contact_id
			ELSE IF @counter = 10
				UPDATE cstd_skip_trace_export_staging SET
				E10_contact_phone_id		= @contact_phone_id,
				E10_country_code_prefix	= @country_code_prefix,
				E10_area_code			= @area_code,
				E10_phone_number			= @phone_number,
				E10_extension			= @extension
				WHERE contact_id = @contact_id

			INSERT INTO cstd_skip_trace_export_detail
			(skip_trace_export_detail_id, skip_trace_export_id, entity_id, entity_table_name, row_sequence, slot_number)
			VALUES
			(NEWID(), @skip_trace_export_id, @contact_phone_id, 'oncd_contact_phone', @c_counter, @counter)

			FETCH c_phones INTO @contact_phone_id, @country_code_prefix, @area_code, @phone_number, @extension, @cst_valid_flag
		END

		CLOSE c_phones
		DEALLOCATE c_phones

		UPDATE cstd_skip_trace_export_staging SET skip_phone = @skip_phone WHERE contact_id = @contact_id
		--Phones END

		--Emails
		DECLARE @contact_email_id	nchar(10)
		DECLARE @email				nvarchar(100)
		DECLARE @skip_email			nchar(1)

		SET @skip_email = 'Y'
		SET @counter = 0

		DECLARE c_emails CURSOR FAST_FORWARD FOR
			SELECT TOP 10
				contact_email_id,
				RTRIM(email), ISNULL(cst_valid_flag,'N') AS cst_valid_flag
			FROM oncd_contact_email WITH (NOLOCK) WHERE contact_id = @contact_id
			ORDER BY cst_valid_flag DESC, primary_flag DESC, updated_date DESC
		OPEN c_emails

		FETCH c_emails INTO @contact_email_id, @email, @cst_valid_flag
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @cst_valid_flag = 'Y'
				SET @skip_email = 'N'

			SET @counter = @counter + 1

			IF @counter = 1
				UPDATE cstd_skip_trace_export_staging SET
				E1_contact_email_id		= @contact_email_id,
				E1_email				= @email
				WHERE contact_id = @contact_id
			ELSE IF @counter = 2
				UPDATE cstd_skip_trace_export_staging SET
				E2_contact_email_id		= @contact_email_id,
				E2_email				= @email
				WHERE contact_id = @contact_id
			ELSE IF @counter = 3
				UPDATE cstd_skip_trace_export_staging SET
				E3_contact_email_id		= @contact_email_id,
				E3_email				= @email
				WHERE contact_id = @contact_id
			ELSE IF @counter = 4
				UPDATE cstd_skip_trace_export_staging SET
				E4_contact_email_id		= @contact_email_id,
				E4_email				= @email
				WHERE contact_id = @contact_id
			ELSE IF @counter = 5
				UPDATE cstd_skip_trace_export_staging SET
				E5_contact_email_id		= @contact_email_id,
				E5_email				= @email
				WHERE contact_id = @contact_id
			ELSE IF @counter = 6
				UPDATE cstd_skip_trace_export_staging SET
				E6_contact_email_id		= @contact_email_id,
				E6_email				= @email
				WHERE contact_id = @contact_id
			ELSE IF @counter = 7
				UPDATE cstd_skip_trace_export_staging SET
				E7_contact_email_id		= @contact_email_id,
				E7_email				= @email
				WHERE contact_id = @contact_id
			ELSE IF @counter = 8
				UPDATE cstd_skip_trace_export_staging SET
				E8_contact_email_id		= @contact_email_id,
				E8_email				= @email
				WHERE contact_id = @contact_id
			ELSE IF @counter = 9
				UPDATE cstd_skip_trace_export_staging SET
				E9_contact_email_id		= @contact_email_id,
				E9_email				= @email
				WHERE contact_id = @contact_id
			ELSE IF @counter = 10
				UPDATE cstd_skip_trace_export_staging SET
				E10_contact_email_id		= @contact_email_id,
				E10_email				= @email
				WHERE contact_id = @contact_id

			INSERT INTO cstd_skip_trace_export_detail
			(skip_trace_export_detail_id, skip_trace_export_id, entity_id, entity_table_name, row_sequence, slot_number)
			VALUES
			(NEWID(), @skip_trace_export_id, @contact_email_id, 'oncd_contact_email', @c_counter, @counter)

			FETCH c_emails INTO @contact_email_id, @email, @cst_valid_flag
		END

		CLOSE c_emails
		DEALLOCATE c_emails

		UPDATE cstd_skip_trace_export_staging SET skip_email = @skip_email WHERE contact_id = @contact_id
		--Emails END

		UPDATE cstd_skip_trace_export_detail SET
			process_email_flag = @skip_email,
			process_address_flag = @skip_address,
			process_phone_flag = @skip_phone
		WHERE skip_trace_export_detail_id = @skip_trace_export_detail_id_contact

		EXEC psoSkipTraceExportSetSkipTraceEventsForContact @contact_id, @skip_address, @skip_phone, @skip_email, @vendor_code

		FETCH contact INTO @contact_id
	END

	CLOSE contact
	DEALLOCATE contact

PRINT @vendor_code + ' contact rows completed at    ' + CONVERT(nchar(20),GETDATE(),121)

	--Output to file
	DECLARE @skip_trace_export_file_name nvarchar(100)
	SET @skip_trace_export_file_name = CONVERT(varchar, @vendor_code) + '_' + RTRIM(REPLACE(REPLACE(REPLACE(CONVERT(nchar(10),GETDATE(),121),'-',''),' ',''),':','')) + '.txt'
	SET @cmdstring = 'BCP "SELECT * FROM cstd_skip_trace_export_staging" queryout "\\wwsql2014\mssql\' + @skip_trace_export_file_name + '" -c -T -t "|"'
--	EXEC xp_cmdshell @cmdstring

--SELECT * FROM cstd_skip_trace_export_staging

	UPDATE cstd_skip_trace_export SET export_file_name = @skip_trace_export_file_name WHERE skip_trace_export_id = @skip_trace_export_id

PRINT @vendor_code + ' completed at                 ' + CONVERT(nchar(20),GETDATE(),121)

END
GO
