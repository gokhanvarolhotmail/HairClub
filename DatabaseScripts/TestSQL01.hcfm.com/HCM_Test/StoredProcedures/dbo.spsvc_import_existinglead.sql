/* CreateDate: 09/12/2007 09:21:41.233 , ModifyDate: 08/08/2017 11:39:47.327 */
GO
CREATE PROCEDURE [dbo].[spsvc_import_existinglead]
(
@fileid				INT,
@lineitemid			INT,
@contact_id			VARCHAR(10),
@territory			VARCHAR(10),
@create_date		DATETIME,
@create_time		VARCHAR(20),
@create_by			VARCHAR(20),
@fname				VARCHAR(50),
@lname				VARCHAR(50),
@zip				VARCHAR(15),
@phone				VARCHAR(20),
@phone2				VARCHAR(20),
@email 				VARCHAR(100),
@appt_date			DATETIME,
@appt_time			VARCHAR(20),
@act_code			VARCHAR(10),
@result_code		VARCHAR(10),
@phone3				VARCHAR(20),
@phone4				VARCHAR(20),
@phone5				VARCHAR(20),
@sourceCode			VARCHAR(20),
@brochureDownload	NCHAR(1),
@alt_center			VARCHAR(10)
)
AS

--------------------------------------------------------------------------------
-- Created by:	Ben Singley
-- Date:		30 January 2002
-- Modified by:	Howard Abelow
-- Mod Date:	4/19/2006
-- Changes:		Added call to Stored Procedure: TM.dbo.cms_gen_act_key_sp
--				that gets the proper Act_key from gm_serial
-- Mod Date:	02/14/2008
-- Changes:		Upgraded for ONCV
--				also modified duplicate multiple activities import
--				to get both brochure and appointment if exists.
--				Modified to generate activities by calling spsvc_import_generate_activities
--
-- This is for Pagelinx/The Connection Imports - Rules updated
-- by Howard Abelow 9/19/2007
--
-- 1.	The inserts into the oncd_contact table will be different if
--		the result_code is BROCHURE OR APPOINT.
--		If BROCHURE, one record is inserted.
--		If APPOINT, 3 records are inserted.
--
-- 2.	The code also looks for duplicate entries resulting from,
--		for example, a user on pagelinx hitting the submit button
--		twice, and ignores the second entry.
--
-- 3.	If the first entry includes a brochure request
--		(BROCHURE), then successive entries for
--		brochure requests (BROCHURE) on the same day for the same
--		person are ignored.  The same is true for an appointment
--		request (APPOINT).  If both request are made on the
--		same day then they are both imported
--
-- 4.	added update locks to all insert statements to fix on
--		contact/dts execution concurrency problem when record is
--		being added by this stored procedure while a new incall
--		creates a record in oncontact (by selecting the same primary
--		key value being used by this stored procedure. implemented
--		for testing on 4/9/02.
--
-- Note:HAbelow - this is not necessary
--		anymore but the locks will remain as they will not cause any
--		issues.
--
-- 5.	Brian Kellman- I removed the updlock hints.  They were causing momenary pauses
--		in the application.
--
-- 6.	3/27/2009 FR - ONC
--		updated result_code comparison - fails if one is null
--
-- 7.	4/2/2009 FR - ONC
--		added phone logic - check if exists. If not, add it.
--		if this becomes too much overhead and imports take too long
--		we can move this logic under the 'MULTIPLE ACTIVITY' section
--		Also check if text messaging is on and write record to temp table
--		for text messaging processing.
--
-- 8.	9/23/2009 FR - ONC
--		updated insert statements to oncd_activity so '' is not inserted as result_code
--
-- 9.	FR: 10/9/2009  SET source_code to 'PL IMPORT' if source_code is null
--
-- 10.	29 April 2010: Adjusted formatting
--
-- 11.	26 April 2011: Source code is now set for existing records.
--
-- 12.	2015-04-13 MJW - Workwise
--		Set cst_valid_flag by default to "Y"
--
-- 13.	2015-05-12 MJW - Workwise
--		validation logic for address, phone, email
--
-- 14.	2015-07-10 MJW - Workwise
--		If alt_center is passed, make it the new primary center for contact
--
-- 15.	2017-06-23 MJW - Workwise
--		Use pso_onc_create_primary_key
--------------------------------------------------------------------------------

DECLARE @act_key				VARCHAR(10)
DECLARE @result_code1 			VARCHAR(10)
DECLARE @act_codeclnr			VARCHAR(10)
DECLARE @company_id				NVARCHAR(10)
DECLARE @creation_date			DATETIME
DECLARE @source_code			NVARCHAR(20)
DECLARE @description			NVARCHAR(50)
DECLARE @cst_time_zone_code		NVARCHAR(10)
DECLARE @phone_sort_order		INT
DECLARE @phone_type_code		NCHAR(10)
DECLARE @contact_phoneID		NCHAR(10)
DECLARE @primary_flag			NCHAR(1)
DECLARE @text_msg_on			CHAR(5)
DECLARE @activity_contact_id	VARCHAR(10)
DECLARE @activity_user_id		VARCHAR(10)
DECLARE @activity_company_id	VARCHAR(10)
DECLARE @valid_flag				NCHAR(1)
DECLARE @area_code				NVARCHAR(3)
DECLARE @alt_company_id			NVARCHAR(10)

SELECT @text_msg_on = (SELECT setting_value FROM onca_setting WHERE setting_name = 'TEXT_MESSAGE_ON')

SET @creation_date = CAST(CONVERT(VARCHAR(10),@create_date,101) + ' ' + @create_time AS DATETIME)
SET @primary_flag = 'N'

-- VALIDATE PHONE NUMBERS
SET @phone =  CASE WHEN ISNUMERIC(@phone) =0 THEN NULL ELSE @phone  END
SET @phone2 = CASE WHEN ISNUMERIC(@phone2)=0 THEN NULL ELSE @phone2 END
SET @phone3 = CASE WHEN ISNUMERIC(@phone3)=0 THEN NULL ELSE @phone3 END
SET @phone4 = CASE WHEN ISNUMERIC(@phone4)=0 THEN NULL ELSE @phone4 END
SET @phone5 = CASE WHEN ISNUMERIC(@phone5)=0 THEN NULL ELSE @phone5 END

SET @phone_sort_order = (SELECT MAX(sort_order) FROM oncd_contact_phone WHERE contact_id = @contact_id)
IF(ISNULL(@phone_sort_order,'') = '')
	SET @phone_sort_order = 0
ELSE
	SET @phone_sort_order = @phone_sort_order + 1

-- UPDATE PHONE RECORDS
IF (ISNULL(@phone,'') <> '')
BEGIN
	IF(SELECT COUNT(*) FROM oncd_contact_phone WHERE contact_id = @contact_id
		AND area_code = LEFT(@phone,3) AND phone_number = RIGHT(@phone,7)) = 0
	BEGIN
		IF @phone = ISNULL(@phone5,'')
			SET @phone_type_code = 'CELL'
		ELSE
			SET @phone_type_code = 'HOME'

		SET @valid_flag = 'Y'
		SET @area_code = RTRIM(LEFT(@phone,3))

		SET @valid_flag = dbo.psoIsValidPhone(@area_code, RIGHT(@phone,7))

		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @contact_phoneID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_phone  (contact_phone_id,contact_id, [phone_type_code], [country_code_prefix], area_code, phone_number, [active], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag)
		VALUES (@contact_phoneID, @contact_id, @phone_type_code, '1', LEFT(@phone,3), RIGHT(@phone,7), 'Y', @phone_sort_order, @creation_date, @create_by, @creation_date, @create_by, @primary_flag, @valid_flag)
		SET @primary_flag = 'N'
		SET @phone_sort_order = @phone_sort_order + 1
	END
END

IF(ISNULL(@phone2,'') <> '')
BEGIN
	IF(select count(*) from oncd_contact_phone where contact_id = @contact_id
		and area_code = LEFT(@phone2,3) and phone_number = RIGHT(@phone2,7)) = 0
	BEGIN
		IF @phone2 = ISNULL(@phone5,'')
			SET @phone_type_code = 'CELL'
		ELSE
			SET @phone_type_code = 'HOME'

		SET @area_code = RTRIM(LEFT(@phone2,3))
		SET @valid_flag = dbo.psoIsValidPhone(@area_code, RIGHT(@phone2,7))

		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @contact_phoneID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_phone  (contact_phone_id,contact_id, [phone_type_code], [country_code_prefix], area_code, phone_number, [active], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag)
		VALUES (@contact_phoneID, @contact_id, @phone_type_code, '1', LEFT(@phone2,3), RIGHT(@phone2,7), 'Y', @phone_sort_order, @creation_date, @create_by, @creation_date, @create_by, @primary_flag, @valid_flag)
		SET @primary_flag = 'N'
		SET @phone_sort_order = @phone_sort_order + 1
	END
END

IF (ISNULL(@phone3,'') <> '')
BEGIN
	IF(select count(*) from oncd_contact_phone where contact_id = @contact_id
		and area_code = LEFT(@phone3,3) and phone_number = RIGHT(@phone3,7)) = 0
	BEGIN
		IF @phone3 = ISNULL(@phone5,'')
			SET @phone_type_code = 'CELL'
		ELSE
			SET @phone_type_code = 'HOME'

		SET @area_code = RTRIM(LEFT(@phone3,3))

		SET @valid_flag = dbo.psoIsValidPhone(@area_code, RIGHT(@phone3,7))

		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @contact_phoneID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_phone  (contact_phone_id,contact_id, [phone_type_code], [country_code_prefix], area_code, phone_number, [active], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag)
		VALUES (@contact_phoneID, @contact_id, @phone_type_code, '1', LEFT(@phone3,3), RIGHT(@phone3,7), 'Y', @phone_sort_order, @creation_date, @create_by, @creation_date, @create_by, @primary_flag, @valid_flag)
		SET @primary_flag = 'N'
		SET @phone_sort_order = @phone_sort_order + 1
	END
END

IF (ISNULL(@phone4,'') <> '')
BEGIN
	IF(select count(*) from oncd_contact_phone where contact_id = @contact_id
		and area_code = LEFT(@phone4,3) and phone_number = RIGHT(@phone4,7)) = 0
	BEGIN
		IF @phone4 = ISNULL(@phone5,'')
			SET @phone_type_code = 'CELL'
		ELSE
			SET @phone_type_code = 'HOME'

		SET @area_code = RTRIM(LEFT(@phone4,3))

		SET @valid_flag = dbo.psoIsValidPhone(@area_code, RIGHT(@phone4,7))

		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @contact_phoneID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_phone  (contact_phone_id,contact_id, [phone_type_code], [country_code_prefix], area_code, phone_number, [active], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag)
		VALUES (@contact_phoneID, @contact_id, @phone_type_code, '1', LEFT(@phone4,3), RIGHT(@phone4,7), 'Y', @phone_sort_order, @creation_date, @create_by, @creation_date, @create_by, @primary_flag, @valid_flag)
		SET @primary_flag = 'N'
		SET @phone_sort_order = @phone_sort_order + 1
	END
END

IF (ISNULL(@phone5,'') != '' and ISNULL(@phone,'') != ISNULL(@phone5,'') and ISNULL(@phone2,'') != ISNULL(@phone5,'') and ISNULL(@phone3,'') != ISNULL(@phone5,'') and ISNULL(@phone4,'') != ISNULL(@phone5,''))
BEGIN
	IF(select count(*) from oncd_contact_phone where contact_id = @contact_id
		and area_code = LEFT(@phone5,3) and phone_number = RIGHT(@phone5,7)) = 0
	BEGIN
		SET @phone_type_code = 'CELL'

		SET @area_code = RTRIM(LEFT(@phone5,3))
		SET @valid_flag = dbo.psoIsValidPhone(@area_code, RIGHT(@phone5,7))

		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @contact_phoneID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_phone  (contact_phone_id,contact_id, [phone_type_code], [country_code_prefix], area_code, phone_number, [active], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag)
		VALUES (@contact_phoneID, @contact_id, @phone_type_code, '1', LEFT(@phone5,3), RIGHT(@phone5,7), 'Y', @phone_sort_order, @creation_date, @create_by, @creation_date, @create_by, @primary_flag, @valid_flag)
	END
END

--Add or update alt_center as primary
IF ISNUMERIC(@alt_center) = 1
BEGIN
	SET @alt_company_id = (SELECT TOP 1 company_id FROM [oncd_company] WHERE [cst_center_number] = @alt_center)

	IF @alt_company_id IS NOT NULL
	BEGIN
		UPDATE oncd_contact_company SET primary_flag = 'N' WHERE contact_id = @contact_id

		IF EXISTS (SELECT 1 FROM oncd_contact_company WHERE contact_id = @contact_id AND company_id = @alt_company_id)
		BEGIN
			UPDATE oncd_contact_company SET
				primary_flag = 'Y',
				updated_date = @creation_date,
				updated_by_user_code = @create_by
			WHERE contact_id = @contact_id AND company_id = @alt_company_id
		END
		ELSE
		BEGIN
			DECLARE @contact_companyID VARCHAR(10)

			EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_company','contact_company_id', @contact_companyID OUTPUT, 'ITX'
			INSERT INTO oncd_contact_company (contact_company_id,contact_id, company_id, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
				VALUES(@contact_companyID, @contact_id, @alt_company_id, 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')
		END
	END
END

-- FIND CENTER ASSIGNED TO THE CONTACT
SET @company_id = (	SELECT [oncd_company].company_id
					FROM [oncd_company] WITH (NOLOCK)
					INNER JOIN [oncd_contact_company] WITH (NOLOCK)
						ON [oncd_company].[company_id] = [oncd_contact_company].[company_id]
					WHERE  [contact_id] = @contact_id
					AND [oncd_contact_company].[primary_flag] = 'Y')

-- UPDATE THE EMAIL FOR THE CONTACTID FOR EXISTING LEAD
SET @valid_flag = N'Y'
SET @email = LTRIM(RTRIM(@email))

IF ISNULL(@email,'') <> ''
BEGIN
	SET @valid_flag = dbo.psoIsValidEmail(@email)

	IF @valid_flag = 'Y'
		UPDATE [oncd_contact_email]
		SET [email] = @email, cst_valid_flag = @valid_flag, primary_flag = @valid_flag
		WHERE [contact_id] = @contact_id
	ELSE
		UPDATE [oncd_contact_email]
		SET [email] = @email, cst_valid_flag = @valid_flag, primary_flag = @valid_flag
		WHERE [contact_id] = @contact_id

END

-- FIND ASSOCIATED CODES FOR VALUES IMPORTED FROM FILE AND ADDL LOOKUPS
SET @source_code = @sourceCode

IF (ISNULL(@source_code,'') = '')
	SET @source_code = 'PL IMPORT'

SET @description =  (SELECT TOP 1 [description] FROM dbo.[onca_action] WHERE [action_code]=@act_code)
SET @cst_time_zone_code = (SELECT TOP 1 [time_zone_code] FROM dbo.[oncd_contact_address] WITH (NOLOCK) WHERE [contact_id] = @contact_id AND [primary_flag] = 'Y')

-- UPDATE THE CONTACTID IN THE LOG TABLE FOR EXISTING LEAD
UPDATE hcmtbl_file_import_file_detail
SET 	contact_id=@contact_id
WHERE
	[file_id]=@fileid AND
	lineitem_id=@lineitemid

-- GET EXISTING ACTIVITY JUST ENTERED TODAY FOR THIS CONTACT IF EXISTS
 SELECT @result_code1 = result_code
 FROM   oncd_activity
		INNER JOIN oncd_activity_contact ON oncd_activity_contact.activity_id = oncd_activity.activity_id
 WHERE  oncd_activity.creation_date = @creation_date
		AND contact_id = @contact_id
		AND result_code IN ( 'BROCHURE', 'APPOINT' )

-- GET MOST RECENT APPOINTMENT ACTIVITY IN TABLE IF EXISTS
 SET @act_codeclnr =
	( SELECT TOP 1
				oncd_activity.activity_id
	  FROM      oncd_activity
				INNER JOIN oncd_activity_contact ON oncd_activity_contact.activity_id = oncd_activity.activity_id
	  WHERE     contact_id = @contact_id
				AND [oncd_activity].[action_code] = 'APPOINT'
	  ORDER BY [oncd_activity].[due_date] DESC, [oncd_activity].[start_time] DESC
	)


-- CHECK FOR EXISTING OPEN APPOINTMENT
-- IF MOST RECENT APPT IS CONFIRMED OR OTHERWISE OPEN, DON'T ADD THIS ONE
IF EXISTS (
				SELECT 1 FROM oncd_activity
				WHERE (result_code IS NULL OR RTRIM(result_code) IN ('RESCHEDULE','1STCONFIRM','3RDCONFIRM','VMCONFIRM')
				OR LEN(result_code)=0)
				AND activity_id=@act_codeclnr
				AND @result_code = 'APPOINT'
				)
BEGIN
	UPDATE hcmtbl_file_import_file_detail
	SET 	Notes='Activity not imported: Open Appointment Exists'
	WHERE
		[file_id]=@fileid AND
		[lineitem_id]=@lineitemid
	-- IF OPEN APPOINTMENT EXISTS, DO NOTHING
	RETURN
END

-- CHECK FOR DUPLICATE ACTIVITY ENTRIES ENTERED TODAY
IF EXISTS (SELECT 1 FROM oncd_activity INNER JOIN oncd_activity_contact ON oncd_activity_contact.activity_id = oncd_activity.activity_id
	WHERE CAST(CONVERT(VARCHAR(11), oncd_activity.creation_date) AS DateTime) = @create_date AND result_code IN ('BROCHURE', 'APPOINT') AND contact_id=@contact_id)
BEGIN
	-- IF DUPLICATE APPOINTMENT ACTIVITY ENTERED TODAY
	IF @result_code1 IN ('APPOINT') AND @result_code IN ('APPOINT')
	BEGIN
		UPDATE hcmtbl_file_import_file_detail
		SET 	Notes='Activity not imported: Duplicate Appointment Entry'
		WHERE
			[file_id]=@fileid AND
			[lineitem_id]=@lineitemid

		-- IF DUP APPOINTMENT DO NOTHING
		RETURN
	END

	-- IF DUPLICATE BROCHURE ACTIVITY ENTERED TODAY
	IF  @result_code1 IN ('BROCHURE') AND @result_code IN ('BROCHURE')
	BEGIN
		UPDATE hcmtbl_file_import_file_detail
		SET 	Notes='Activity not imported: Duplicate Brochure Entry'
		WHERE
			[file_id]=@fileid AND
			[lineitem_id]=@lineitemid

		-- IF DUP BROCHURE DO NOTHING
		RETURN
	END

	-- IF MULTIPLE ACTIVITY THAT IS DIFFERENT FOR SAME CONTACT ENTERED TODAY
	-- 3/27/2009 FR - ONC
	-- updated result_code comparison - fails if one is null
	-- IF @result_code1 <> @result_code
	IF ISNULL(@result_code1,'') <> ISNULL(@result_code,'')
	BEGIN
		-- NEW ASSIGNMENT OF ACT_KEY FROM OnContact sp
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity','activity_id', @act_key OUTPUT,'ITX'

		-- CREATE THE INCALL RECORD
		INSERT INTO oncd_activity
			(activity_id, due_date, start_time, action_code, description, creation_date, created_by_user_code, source_code, cst_activity_type_code, cst_time_zone_code, cst_brochure_download)
		VALUES
			(@act_key, @create_date, '1/1/1900 00:00:00', @act_code, @description, @creation_date, @create_by, @source_code, 'INBOUND', @cst_time_zone_code, @brochureDownload)

		-- CREATE THE ACTIVITY CONTACT RECORD FOR THE INCALL
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity_contact','activity_contact_id', @activity_contact_id OUTPUT,'ITX'
		INSERT INTO oncd_activity_contact
			(activity_contact_id, contact_id, activity_id, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
		VALUES
			(@activity_contact_id, @contact_id, @act_key, @creation_date, 'Y', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

		-- CREATE THE ACTIVITY USER RECORD  FOR THE INCALL
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity_user','activity_user_id', @activity_user_id OUTPUT, 'ITX'
			INSERT INTO oncd_activity_user (activity_user_id,activity_id, user_code, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
			VALUES(@activity_user_id, @act_key, @create_by, @creation_date, 'R', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

		-- UPDATE THE INCALL RECORD TO SET OFF THE TRIGGER IF BROCHURE
		UPDATE [oncd_activity] SET completion_date = @create_date, completion_time = @create_time,  completed_by_user_code = @create_by, updated_date = @creation_date, updated_by_user_code = @create_by , result_code = @result_code
		WHERE [activity_id] = @act_key

		-- IF INCALL IS APPOINTMENT THEN MUST CREATE THE OTHER 2 ACTIVITY RECORDS
		IF @result_code IN ('APPOINT')
		BEGIN
			-- NEW ASSIGNMENT OF ACT_KEY FROM OnContact sp
			EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity','activity_id', @act_key OUTPUT, 'ITX'

			SELECT @appt_date = convert(datetime, LEFT(@appt_date,11))
			SELECT @appt_time = convert(char(5), RIGHT(@appt_time,7),14)

			-- CREATE THE INBOUND APPOINTMENT RECORD WITH APPT DATE AND TIME
			INSERT INTO oncd_activity
				(activity_id, due_date, start_time, action_code, description, creation_date, created_by_user_code, updated_date, updated_by_user_code, source_code, cst_activity_type_code, cst_time_zone_code, cst_brochure_download)
			VALUES
				(@act_key, @appt_date, CONVERT(datetime, '1/1/1900 ' + @appt_time), 'APPOINT', 'Appointment', @creation_date, @create_by, @creation_date, @create_by, @source_code, 'INBOUND', @cst_time_zone_code, @brochureDownload)

			-- FR check if text messaging is on and if if is, check 5th phone number, if exists, write to table for txt msg processing
			IF (ISNULL(@text_msg_on,'') = 'True' AND ISNULL(@phone5,'') != '' AND ISNULL(@appt_time,'') != '')
			BEGIN
				INSERT INTO cstd_text_msg_temp (contact_id, appointment_activity_id, phone, created_by_user_code, creation_date, action) values (@contact_id, @act_key, @phone5, @create_by, getdate(), 'OPTIN')
			END

			-- CREATE THE ACTIVITY CONTACT RECORD FOR THE INBOUND APPOINTMENT
			EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity_contact','activity_contact_id', @activity_contact_id OUTPUT, 'ITX'
			INSERT INTO oncd_activity_contact (activity_contact_id, contact_id, activity_id, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
			VALUES (@activity_contact_id, @contact_id, @act_key, @creation_date, 'Y', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

			-- CREATE THE ACTIVITY USER RECORD FOR THE INBOUND APPOINTMENT
			EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity_user','activity_user_id', @activity_user_id OUTPUT, 'ITX'
			INSERT INTO oncd_activity_user (activity_user_id,activity_id, user_code, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
			VALUES(@activity_user_id, @act_key, @create_by, @creation_date, 'R', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')


			-- CREATE THE ACTIVITY COMPANY RECORD  FOR THE INBOUND APPOINTMENT
			EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity_company','activity_company_id', @activity_company_id OUTPUT, 'ITX'
			INSERT INTO oncd_activity_company (activity_company_id,activity_id, company_id, assignment_date, [attendance], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
			VALUES(@activity_company_id, @act_key, @company_id, @creation_date, 'N', 0, @creation_date, @create_by, @creation_date, @create_by, 'Y')

			-- SET CONFIRMATION DATE FOR DAY BEFORE APPOINTMENT
			EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity','activity_id', @act_key OUTPUT, 'ITX'
			SELECT @appt_date = convert(datetime, LEFT(DATEADD(d,-1,@appt_date),11))

			-- CREATE THE CONFIRMATION RECORD FOR DAY BEFORE APPOINTMENT
			INSERT INTO oncd_activity (activity_id, due_date, start_time, action_code, description, creation_date, created_by_user_code, updated_date, updated_by_user_code, source_code, cst_activity_type_code, cst_time_zone_code, cst_brochure_download)
			VALUES (@act_key, @appt_date, '1/1/1900 00:00:00', 'CONFIRM', 'Confirmation Call', @creation_date, @create_by, @creation_date, @create_by, @source_code, 'INBOUND', @cst_time_zone_code, @brochureDownload)

			-- CREATE THE ACTIVITY CONTACT RECORD FOR THE CONFIRMATION
			EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity_contact','activity_contact_id', @activity_contact_id OUTPUT, 'ITX'
			INSERT INTO oncd_activity_contact (activity_contact_id, contact_id, activity_id, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
			VALUES (@activity_contact_id, @contact_id, @act_key, @creation_date, 'Y', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

			-- CREATE THE ACTIVITY USER RECORD FOR THE CONFIRMATION
			EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity_user','activity_user_id', @activity_user_id OUTPUT, 'ITX'
			INSERT INTO oncd_activity_user (activity_user_id,activity_id, user_code, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
			VALUES(@activity_user_id, @act_key, @create_by, @creation_date, 'R', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

			-- UPDATE THE FILE DETAIL RECORD FOR THE NEW APPOINTMENT MULTIPLE ACTIVITY
			UPDATE hcmtbl_file_import_file_detail
			SET 	Is_new_appointment=1
			WHERE
				[file_id]=@fileid AND
				[lineitem_id]=@lineitemid
		END
		ELSE
		-- UPDATE THE FILE DETAIL RECORD FOR THE NEW BROCHURE MULTIPLE ACTIVITY
		BEGIN
			UPDATE hcmtbl_file_import_file_detail
			SET 	Is_new_brochure=1
			WHERE
				[file_id]=@fileid AND
				[lineitem_id]=@lineitemid
		END
	END
END

ELSE
BEGIN
	EXEC spsvc_import_generate_activities 	@fileid, @lineitemid, @contact_id, @create_date, @create_time, @create_by, @appt_date, @appt_time, @act_code, @result_code, @phone5, @source_code, @brochureDownload
END
GO
