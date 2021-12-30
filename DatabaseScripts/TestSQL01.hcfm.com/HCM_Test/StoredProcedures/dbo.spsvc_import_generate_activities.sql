/* CreateDate: 02/18/2008 11:18:15.343 , ModifyDate: 05/22/2012 11:29:06.963 */
GO
/***********************************************************************

PROCEDURE:	[spsvc_import_generate_activities]	VERSION  1.0

DESTINATION SERVER:	   HCSQL3\SQL2005

DESTINATION DATABASE: HCM

RELATED APPLICATION:  Oncontact data imports for pagelink, convergys etc

AUTHOR: OnContact

IMPLEMENTOR: ??

DATE IMPLEMENTED: 02/??/08

LAST REVISION DATE: 02/14/08

--------------------------------------------------------------------------------------------------------
NOTES:	   THIS STORED PROCEDURE WILL HANDLE THE LOGIC OF CREATING ACTIVIES
			APPROPRIATE TO THE LEADS result_code.  PROCEDURE IS CALLED FROM
			BOTH spsvc_import_lead_file AND spsvc_import_existinglead
--------------------------------------------------------------------------------------------------------
FR: 4/13/2009 Add phone 5 to passed in parms. If text messaging is turned on,
			  write record to text generation staging table

FR 9/23/2009 Updated insert statements to oncd_activity so '' is not inserted as result_code

FR: 10/9/2009  Set source_code to 'PL IMPORT' if source_code is null

Update date: 6 July 2011
Description: Pass in Source rather than looking up from Contact.

Update date: 22 November 2011
Description: Use the trigger for the Confirmation Call logic rather than duplicating it here.
			 General formatting/readability changes.
***********************************************************************/

CREATE PROCEDURE [dbo].[spsvc_import_generate_activities]
	@fileid									INT,
	@lineitemid								INT,
	@contact_id								VARCHAR(10),
	@create_date							DATETIME,
	@create_time							VARCHAR(20),
	@create_by								VARCHAR(20),
	@appt_date								DATETIME,
	@appt_time								VARCHAR(20),
	@act_code								VARCHAR(10),
	@result_code							VARCHAR(10),
	@phone5									VARCHAR(11),
	@source_code							VARCHAR(20),
	@brochureDownload						NCHAR(1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @act_key						VARCHAR(10)
	DECLARE @company_id						VARCHAR(10)
	DECLARE @description					NVARCHAR(50)
	DECLARE @creation_date					DATETIME
	DECLARE @cst_time_zone_code				NVARCHAR(10)
	DECLARE @activity_contact_id			VARCHAR(10)
	DECLARE @activity_user_id				VARCHAR(10)
	DECLARE @activity_company_id			VARCHAR(10)
	DECLARE @text_msg_on					CHAR(5)
	DECLARE @IncallActivityId				NCHAR(10)

	SELECT @text_msg_on						= (	SELECT
													setting_value
												FROM onca_setting
												WHERE
													setting_name = 'TEXT_MESSAGE_ON')

	IF (ISNULL(@source_code,'') = '')
	BEGIN
		SET @source_code					= (	SELECT TOP 1
													source_code
												FROM oncd_contact_source
												WHERE
													contact_id = @contact_id AND
													primary_flag = 'Y')
	END

	IF (ISNULL(@source_code,'') = '')
	BEGIN
		SET @source_code					= 'PL IMPORT'
	END

	SET @description						= (	SELECT TOP 1
													description
												FROM onca_action
												WHERE
													action_code = @act_code)

	SET @creation_date						= CAST(CONVERT(VARCHAR(10),@create_date,101) + ' ' + @create_time AS DATETIME)

	SET @cst_time_zone_code					= (	SELECT TOP 1
													time_zone_code
												FROM oncd_contact_address
												WHERE
													contact_id = @contact_id AND
													primary_flag = 'Y')

	-- FIND CENTER ASSIGNED TO THE CONTACT
	SET @company_id							= (	SELECT
													oncd_company.company_id
												FROM oncd_company
												INNER JOIN oncd_contact_company
													ON oncd_company.company_id = oncd_contact_company.company_id
												WHERE
													contact_id = @contact_id AND
													oncd_contact_company.primary_flag = 'Y')

	BEGIN
		-- IF BROCHURE ACTIVITY ENTERED TODAY OR WE DONT KNOW
		IF (@result_code='BROCHURE' OR ISNULL(@result_code,'') = '')
		BEGIN
			EXEC dbo.onc_create_primary_key 10, 'oncd_activity', 'activity_id', @act_key OUTPUT, 'ITX'

			-- CREATE BROCHURE ACTIVITY RECORD
			INSERT INTO oncd_activity
				(activity_id, due_date, start_time, action_code, description, creation_date, created_by_user_code, source_code, cst_activity_type_code, cst_time_zone_code, cst_brochure_download)
			VALUES
				(@act_key, @create_date, '1/1/1900 00:00:00', @act_code, @description, @creation_date, @create_by, @source_code, 'INBOUND', @cst_time_zone_code, @brochureDownload)

			-- CREATE ACTIVITY CONTACT FOR BROCHURE ACTIVITY
			EXEC dbo.onc_create_primary_key 10, 'oncd_activity_contact', 'activity_contact_id', @activity_contact_id OUTPUT, 'ITX'
			INSERT INTO oncd_activity_contact
				(activity_contact_id, contact_id, activity_id, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
			VALUES
				(@activity_contact_id, @contact_id, @act_key, @creation_date, 'Y', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

			-- CREATE ACTIVITY USER FOR BROCHURE ACTIVITY
			EXEC dbo.onc_create_primary_key 10, 'oncd_activity_user', 'activity_user_id', @activity_user_id OUTPUT, 'ITX'
				INSERT INTO oncd_activity_user (activity_user_id,activity_id, user_code, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
				VALUES(@activity_user_id, @act_key, @create_by, @creation_date, 'R', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

			-- UPDATE THE INCALL RECORD TO SET OFF THE TRIGGER IF BROCHURE
			UPDATE [oncd_activity] SET completion_date = @create_date, completion_time = @create_time,  completed_by_user_code = @create_by, updated_date = @creation_date, updated_by_user_code = @create_by , result_code = @result_code
			WHERE [activity_id] = @act_key

			-- UPDATE THE FILE DETAIL RECORD FOR THE NEW BROCHURE ACTIVITY
			UPDATE hcmtbl_file_import_file_detail
			SET
				is_new_brochure = 1
			WHERE
				file_id = @fileid AND
				lineitem_id = @lineitemid
		END

		ELSE
		-- APPOINTMENT ACTIVITY NOT BROCHURE
		BEGIN
			EXEC dbo.onc_create_primary_key 10,'oncd_activity', 'activity_id', @act_key OUTPUT, 'ITX'

			SET @IncallActivityId = @act_key

			-- CREATE THE INCALL RECORD
			INSERT INTO oncd_activity
				(activity_id, due_date, start_time, action_code, description, creation_date, created_by_user_code, completion_date, completion_time, completed_by_user_code, updated_date, updated_by_user_code, source_code, cst_activity_type_code, cst_time_zone_code, cst_brochure_download)
			VALUES
				(@act_key, @create_date, '1/1/1900 00:00:00', @act_code, @description, @creation_date, @create_by, @create_date, @create_time, @create_by, @creation_date, @create_by, @source_code, 'INBOUND', @cst_time_zone_code, @brochureDownload)

			-- CREATE THE ACTIVITY CONTACT RECORD FOR THE INCALL
			EXEC dbo.onc_create_primary_key 10,'oncd_activity_contact','activity_contact_id', @activity_contact_id OUTPUT, 'ITX'

			INSERT INTO oncd_activity_contact
				(activity_contact_id, contact_id, activity_id, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
			VALUES
				(@activity_contact_id, @contact_id, @act_key, @creation_date, 'Y', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

			-- CREATE THE ACTIVITY USER RECORD FOR THE INCALL
			EXEC dbo.onc_create_primary_key 10,'oncd_activity_user','activity_user_id', @activity_user_id OUTPUT, 'ITX'

			INSERT INTO oncd_activity_user
				(activity_user_id,activity_id, user_code, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
			VALUES
				(@activity_user_id, @act_key, @create_by, @creation_date, 'R', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

			EXEC dbo.onc_create_primary_key 10, 'oncd_activity', 'activity_id', @act_key OUTPUT, 'ITX'

			SELECT @appt_date = convert(datetime, LEFT(@appt_date,11))
			SELECT @appt_time = convert(char(5), RIGHT(@appt_time,7),14)

			-- CREATE THE INBOUND APPOINTMENT RECORD WITH APPT DATE AND TIME
			INSERT INTO oncd_activity
				(activity_id, due_date, start_time, action_code, description, creation_date, created_by_user_code, updated_date, updated_by_user_code, source_code, cst_activity_type_code, cst_time_zone_code, cst_brochure_download)
			VALUES
				(@act_key, @appt_date, CONVERT(datetime, '1/1/1900 ' + @appt_time), 'APPOINT', 'Appointment', @creation_date, @create_by, @creation_date, @create_by, @source_code, 'INBOUND', @cst_time_zone_code, @brochureDownload)

			-- CREATE THE ACTIVITY CONTACT RECORD FOR THE INBOUND APPOINTMENT
			EXEC dbo.onc_create_primary_key 10,'oncd_activity_contact','activity_contact_id', @activity_contact_id OUTPUT, 'ITX'

			INSERT INTO oncd_activity_contact
				(activity_contact_id, contact_id, activity_id, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
			VALUES
				(@activity_contact_id, @contact_id, @act_key, @creation_date, 'Y', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

			-- CREATE THE ACTIVITY USER RECORD FOR THE INBOUND APPOINTMENT
			EXEC dbo.onc_create_primary_key 10,'oncd_activity_user','activity_user_id', @activity_user_id OUTPUT, 'ITX'

			INSERT INTO oncd_activity_user
				(activity_user_id,activity_id, user_code, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
			VALUES
				(@activity_user_id, @act_key, @create_by, @creation_date, 'R', 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

			-- CREATE THE ACTIVITY COMPANY RECORD  FOR THE INBOUND APPOINTMENT
			IF ISNULL(@company_id,'') <> ''
			BEGIN
				EXEC dbo.onc_create_primary_key 10,'oncd_activity_company','activity_company_id', @activity_company_id OUTPUT, 'ITX'

				INSERT INTO oncd_activity_company
					(activity_company_id,activity_id, company_id, assignment_date, [attendance], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
				VALUES
					(@activity_company_id, @act_key, @company_id, @creation_date, 'N', 0, @creation_date, @create_by, @creation_date, @create_by, 'Y')
			END

			-- Update the inbound call activity to cause the trigger to fire and create the confirmation call.
			UPDATE oncd_activity
			SET
				result_code = @result_code
			WHERE
				activity_id = @IncallActivityId

			-- UPDATE THE FILE DETAIL RECORD FOR THE NEW APPOINTMENT ACTIVITY
			UPDATE hcmtbl_file_import_file_detail
			SET
				Is_new_appointment = 1
			WHERE
				[file_id] = @fileid AND
				[lineitem_id] = @lineitemid

		END

		-- IF TEXT MESSAGING IS ON, INSERT INTO TEXT MESSAGE STAGING TABLE
		IF (ISNULL(@text_msg_on,'') = 'True' AND ISNULL(@phone5,'') != '')
		BEGIN
			INSERT INTO cstd_text_msg_temp
				(contact_id, appointment_activity_id, phone, created_by_user_code, creation_date, action)
			VALUES
				(@contact_id, @act_key, @phone5, @create_by, GETDATE(), 'OPTIN')
		END

	END

END
GO
