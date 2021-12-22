/* CreateDate: 09/12/2007 09:21:41.560 , ModifyDate: 08/08/2017 11:39:46.997 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------
-- PROCEDURE:	[spsvc_import_lead_file]	VERSION  2.0
-- DESTINATION SERVER:	   HCSQL3\SQL2005
-- DESTINATION DATABASE: HCM
-- RELATED APPLICATION:  Oncontact data imports for pagelink, convergys etc
-- AUTHOR: OnContact
-- IMPLEMENTOR: ??
-- DATE IMPLEMENTED: 10/??/07
-- LAST REVISION DATE: 19 October 2015
--
-- FR: 5/21/2008	Added phone3, phone4, phone5
--
-- FR: 4/13/2009	pass phone5 to spsvc_import_generate_activities for text
-- 					message generation
--
-- Updated Date:	29 April 2010
-- Description:		Added trimming for last name search and zip code.  Adjusted
--					formatting to make text easier to follow.
--
-- Updated Date:	16 Novemeber 2010
-- Description:		Updated procedure to use new business logic as defined below.
--					1. If the first lookup does not find a matching contact record, perform
--                     a secondary lookup to the history table for that row.
--                      a. Row does not exist in history table.
--                          i. Insert new contact record.
--                          ii.Log row as insert in history table.
--                      b. Row exists in history table.
--                          i. Log row as skip in history table.
--                  2. If the first lookup finds a matching contact record, perform a
--                     secondary lookup to the history table for that row.
--                      a. Row does not exist in history table.
--                          i. Update existing contact record.
--                          ii.Log row as update in history table.
--                      b. Row exists in history table.
--                          i. Log row as skip in history table.
--
-- Updated Date:	19 October 2010
-- Description:		Modify sessionid to support 100 char
--
-- Updated Date:	2016-03-08	MJW - Workwise, LLC
-- Description:		Remove hard-coded language logic
--
-- Updated Date:	2017-06-23	MJW - Workwise, LLC
-- Description:		Add NOLOCKs and use pso_onc_create_primary_key
--------------------------------------------------------------------------------
-- NOTES:	THIS STORED PROCEDURE WILL HANDLE THE LOGIC OF SEARCHING THE
--			ONCONTACT SYSTEM FOR THE LEAD BEING IMPORTED.  DEPENDING
--			WHETHER THE LEAD ALREADY EXISTS OR NOT THE STORED PROCEDURE
--			WILL CALL ANOTHER STORED PROCEDURE TO EITHER ADD ALL NEW
--			CONTACT INFORMATION OR ONLY THE ACTIVITY REQUESTED BY THAT LEAD.
--------------------------------------------------------------------------------
--
-- SAMPLE EXEC:	EXEC spsvc_import_lead_file 'Pagelynx', '2007_10_17.txt'
--
--------------------------------------------------------------------------------

CREATE  PROCEDURE [dbo].[spsvc_import_lead_file](@company as varchar(50), @filename as varchar(50)) AS

-- LOCAL VARIABLE DECLARATION SECTION
DECLARE @fileid				INT
DECLARE @lineitemid 		INT
DECLARE @contact_id			VARCHAR(10)
DECLARE @act_key			VARCHAR(10)
DECLARE @territory			VARCHAR(10)
DECLARE @create_date_text	VARCHAR(50)
DECLARE @create_date		DATETIME
DECLARE @create_time		VARCHAR(20)
DECLARE @create_by 			VARCHAR(20)
DECLARE @fname 				VARCHAR(50)
DECLARE @lname 				VARCHAR(50)
DECLARE @street 			VARCHAR(60)
DECLARE @street2			VARCHAR(60)
DECLARE @city 				VARCHAR(60)
DECLARE @state 				VARCHAR(20)
DECLARE @zip 				VARCHAR(15)
DECLARE @email 				VARCHAR(100)
DECLARE @phone 				VARCHAR(20)
DECLARE @phone2 			VARCHAR(20)
DECLARE @appt_date_text		VARCHAR(50)
DECLARE @appt_date			DATETIME
DECLARE @appt_time			VARCHAR(20)
DECLARE @act_code 			VARCHAR(10)
DECLARE @result_code		VARCHAR(10)
DECLARE @source				VARCHAR(20)
DECLARE @promo				VARCHAR(20)
DECLARE @promotionCode		VARCHAR(20)
DECLARE @newphone			VARCHAR(20)
DECLARE @newphone2			VARCHAR(20)
DECLARE @gender				VARCHAR(10)
DECLARE @age				VARCHAR(10)
DECLARE @alternatives		VARCHAR(20)
DECLARE @language			VARCHAR(10)
DECLARE @session			VARCHAR(100)
DECLARE @affiliated			VARCHAR(50)
DECLARE @alt_center			VARCHAR(10)
DECLARE @loginid			VARCHAR(50)
DECLARE @phone3 			VARCHAR(20)
DECLARE @phone4				VARCHAR(20)
DECLARE @phone5				VARCHAR(20)
DECLARE @newphone3			VARCHAR(20)
DECLARE @newphone4			VARCHAR(20)
DECLARE @newphone5			VARCHAR(20)
DECLARE @action				NCHAR(1)
DECLARE @recordID			VARCHAR(10)
DECLARE @runID				NCHAR(10)
DECLARE @historyContactId	NCHAR(10)
DECLARE @brochureDownload	NCHAR(1)

SET NOCOUNT ON;

SET @runID = CONVERT(NCHAR(6), GETDATE(), 12) + REPLACE(CONVERT(NCHAR(5), GETDATE(), 108), ':', '')

INSERT INTO hcmtbl_file_import_file_header(company,[file_name],import_date)
VALUES (@company,@filename,getdate())

SELECT @fileid=@@Identity

SELECT @lineitemid = 0


-- OPEN CURSOR
IF @company = 'PageLynx'
BEGIN
	DECLARE alldata_curs CURSOR FOR
	SELECT territory, create_date, create_time, create_by, first_name, last_name, street, street2, city, state, zip, email, phone, phone2, appt_date, appt_time, act_code, result_code, source, promo, recordid,gender, cst_age_range, loss_alternatives, cst_language, cst_sessionid, cst_affiliateid, alt_center, cst_loginid, phone3, phone4, phone5, brochure_download
	FROM hcmtbl_leadstoimport_pagelynx
	ORDER BY last_name, phone
	FOR READ ONLY
END

ELSE IF @company = 'The Connection'
BEGIN
	DECLARE alldata_curs CURSOR FOR
	SELECT territory, create_date, create_time, create_by, first_name, last_name, street, street2, city, state, zip, email, phone, phone2, appt_date, appt_time, act_code, result_code, source, promo, recordid,gender, cst_age_range, loss_alternatives, cst_language, cst_sessionid, cst_affiliateid, alt_center, cst_loginid, phone3, phone4, phone5, 'N'
	FROM hcmtbl_leadstoimport_the_connection
	ORDER BY last_name, phone
	FOR READ ONLY
END

ELSE IF @company = 'Convergys'
BEGIN
	DECLARE alldata_curs CURSOR FOR
	SELECT territory, create_date, create_time, create_by, first_name, last_name, street, street2, city, state, zip, email, phone, phone2, appt_date, appt_time, act_code, result_code, source, promo, recordid,gender, cst_age_range, loss_alternatives, cst_language, cst_sessionid, cst_affiliateid, alt_center, cst_loginid, phone3, phone4, phone5, 'N'
	FROM hcmtbl_leadstoimport_the_connection
	ORDER BY last_name, phone
	FOR READ ONLY
END

OPEN alldata_curs

FETCH NEXT FROM alldata_curs INTO @territory, @create_date_text, @create_time, @create_by, @fname, @lname, @street, @street2, @city, @state, @zip, @email, @phone, @phone2, @appt_date_text, @appt_time, @act_code, @result_code, @source, @promo, @contact_id, @gender, @age, @alternatives, @language, @session, @affiliated, @alt_center, @loginid, @phone3, @phone4, @phone5, @brochureDownload


-- LOOP THROUGH THE CURSOR AND EVALUATE WHETHER THE CLIENT EXISTS IN THE
-- DATABASE OR NOT.
WHILE @@fetch_status = 0
BEGIN

	--MM/DD/YY
	INSERT INTO cstd_sql_job_log(name, message)
	VALUES ('Pagelinx Import', 'Converting sesion: ''' + @session + ''' created date: ''' + @create_date_text + '''')
	IF (LEN(RTRIM(@create_date_text)) = 0)
	--IF ISDATE(@create_date_text) < 1
	BEGIN
		SET @create_date = NULL
	END
	ELSE
	BEGIN
		BEGIN TRY
			SET @create_date = CAST(@create_date_text AS DATETIME) --CONVERT(DATETIME, @create_date_text, 110)
		END TRY
		BEGIN CATCH
			SET @create_date = GETDATE()
		END CATCH
	END


	INSERT INTO cstd_sql_job_log(name, message)
	VALUES ('Pagelinx Import', 'Converting sesion: ''' + @session + ''' appt date: ''' + @appt_date_text + '''')
	IF (LEN(RTRIM(@appt_date_text)) = 0)
	--IF ISDATE(@create_date_text) < 1
	BEGIN
		SET @appt_date = NULL
	END
	ELSE
	BEGIN
		SET @appt_date = CAST(@appt_date_text AS DATETIME)
	END

	SET @recordID = @contact_id
	SET @historyContactId = NULL

	-- CHECK TO SEE IF THE ZIP AND PHONE EXISTS
	IF ((LEN(@zip) >= 5 AND LEN(@phone) = 10 AND ISNUMERIC(@phone) = 1 AND SUBSTRING(@phone, 1,1) NOT IN ('+', '-')) OR LEN(@contact_id) = 10)
	BEGIN
		SELECT @lineitemid = @lineitemid + 1

		INSERT INTO hcmtbl_file_import_file_detail([file_id], [lineitem_id], first_name, last_name)
		VALUES (@fileid, @lineitemid, @fname, @lname)

		-- MOST TIMES THE PHONE NUMBER WILL COME WITH VARIOUS DELIMITERS
		-- ONCONTACT SYSTEM ONLY NEEDS THE 10 DIGIT NUMBER THIS SP WILL
		-- CLEAN UP ANY UNWANTED FORMATING IN THE PHONE NUMBER
		EXEC hcmfx_cleandelimiters @phone,  @newphone  OUTPUT
		EXEC hcmfx_cleandelimiters @phone2, @newphone2 OUTPUT
		EXEC hcmfx_cleandelimiters @phone3, @newphone3 OUTPUT
		EXEC hcmfx_cleandelimiters @phone4, @newphone4 OUTPUT
		EXEC hcmfx_cleandelimiters @phone5, @newphone5 OUTPUT

		SET @newphone  = CASE WHEN ISNUMERIC(@newphone) =0 THEN NULL ELSE @newphone  END
		SET @newphone2 = CASE WHEN ISNUMERIC(@newphone2)=0 THEN NULL ELSE @newphone2 END
		SET @newphone3 = CASE WHEN ISNUMERIC(@newphone3)=0 THEN NULL ELSE @newphone3 END
		SET @newphone4 = CASE WHEN ISNUMERIC(@newphone4)=0 THEN NULL ELSE @newphone4 END
		SET @newphone5 = CASE WHEN ISNUMERIC(@newphone5)=0 THEN NULL ELSE @newphone5 END

		-- CLEAN THE ACT_CODE AND RESULT_CODE
		IF (@result_code = 'A11')
		BEGIN
			SET @result_code = 'BROCHURE'
		END

		IF (@result_code IN ('A21','A31'))
		BEGIN
			SET @result_code = 'APPOINT'
		END

		SET @result_code = UPPER(@result_code)
		SET @act_code = UPPER(@act_code)

		-- SET UPPER CASE FOR IMPORT USER
		SET @create_by = UPPER(@create_by)

		-- CLEAN THE LANGUAGE FIELD
--		IF (UPPER(@language) NOT IN ('ENGLISH', 'SPANISH'))
		IF (UPPER(@language) NOT IN (SELECT language_code FROM csta_contact_language WHERE active = 'Y'))
		BEGIN
			SET @language = 'ENGLISH'
		END

		SET @historyContactId =
			(SELECT TOP 1 contact_id
			FROM hcmtbl_leadstoimport_pagelynx_history
			WHERE
			--processed_date >= DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) AND
			territory = @territory AND
			create_date = @create_date AND
			create_time = @create_time AND
			create_by = @create_by AND
			first_name = @fname AND
			last_name = @lname AND
			street = @street AND
			street2 = @street2 AND
			city = @city AND
			state = @state AND
			zip = @zip AND
			email = @email AND
			phone = @phone AND
			phone2 = @phone2 AND
			appt_date = @appt_date AND
			appt_time = @appt_time AND
			act_code = @act_code AND
			result_code = @result_code AND
			source = @source AND
			promo = @promo AND
			recordid = @recordID AND
			gender = @gender AND
			cst_age_range = @age AND
			loss_alternatives = @alternatives AND
			cst_language = @language AND
			cst_sessionid = @session AND
			cst_affiliateid = @affiliated AND
			alt_center = @alt_center AND
			cst_loginid = @loginid AND
			phone3 = @phone3 AND
			phone4 = @phone4 AND
			phone5 = @phone5 AND
			brochure_download = @brochureDownload)

		-- CHECK TO SEE IF THE CLIENT EXISTS IF HE DOES, ENTER ONLY THE
		-- ACTIVITY FOR THAT LEAD.  OTHERWISE, ENTER CONTACT INFO AND
		-- ACTIVITY.

		IF (@historyContactId IS NOT NULL)
		BEGIN
			SET @action = 'S'
			SET @contact_id = @historyContactId
		END
		ELSE
		BEGIN

			-- Look up the promotion based on the source if it was provided as MHSA
			IF (@promo = 'MHSA')
			BEGIN
				-- Look up the promotion code which is associated with the provided source code.
				SET @promotionCode = (SELECT cst_promotion_code FROM onca_source WHERE source_code = @source)
			END
			ELSE
			BEGIN
				SET @promotionCode = @promo
			END

			IF (RTRIM(LTRIM(ISNULL(@promotionCode,''))) = '')
			BEGIN
				SET @promotionCode = 'MHSA'
			END

			-- START THE TRANSACTION PROCESSING
			BEGIN TRANSACTION
			-- FIRST CHECK IF THE PASSED IN CONTACT_ID ALREADY EXISTS
			IF EXISTS(
					SELECT *
					FROM oncd_contact WITH (NOLOCK)
					WHERE oncd_contact.[contact_id] = @contact_id)
			BEGIN
				-- The source record has not been processed and should not be skipped.
				SET @action = 'U'
				EXEC spsvc_import_existinglead @fileid, @lineitemid, @contact_id, @territory, @create_date, @create_time, @create_by, @fname, @lname, @zip, @newphone, @newphone2, @email, @appt_date_text, @appt_time, @act_code, @result_code, @newphone3, @newphone4, @newphone5, @source, @brochureDownload, @alt_center
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION
				END
			END
			ELSE -- Contact Id was not provided for that row.
			BEGIN
				SET @contact_id = NULL
				SET @contact_id = (SELECT MIN(oncd_contact.contact_id)
							FROM oncd_contact WITH (NOLOCK)
							INNER JOIN oncd_contact_phone WITH (NOLOCK)
								ON oncd_contact.contact_id = oncd_contact_phone.contact_id
							INNER JOIN oncd_contact_address WITH (NOLOCK)
								ON oncd_contact.contact_id = oncd_contact_address.contact_id
							WHERE
								oncd_contact.first_name_search LIKE UPPER(LEFT(@fname,3)) + '%' AND
								oncd_contact.last_name_search = LTRIM(RTRIM(UPPER(@lname))) AND
								zip_code = LTRIM(RTRIM(@zip)) AND
								LTRIM(RTRIM(area_code)) + LTRIM(RTRIM(phone_number)) IN  (@newphone, @newphone2, @newphone3, @newphone4, @newphone5))

				IF ISNULL(@contact_id,' ') <> ' '
				BEGIN
					-- The contact exists and the row has not been processed.
					SET @action = 'U'
					EXEC spsvc_import_existinglead @fileid, @lineitemid, @contact_id, @territory, @create_date, @create_time, @create_by, @fname, @lname, @zip, @newphone, @newphone2, @email, @appt_date_text, @appt_time, @act_code, @result_code, @newphone3, @newphone4, @newphone5, @source, @brochureDownload, @alt_center
					IF @@ERROR <> 0
					BEGIN
						ROLLBACK TRANSACTION
					END
				END
				ELSE
				BEGIN
					SET @action = 'I'
					EXEC spsvc_import_newlead @fileid, @lineitemid, @contact_id OUTPUT, @territory, @create_date, @create_time, @create_by, @fname, @lname, @street, @street2, @city, @state, @zip, @email, @newphone, @newphone2, @source, @gender, @age, @alternatives, @promotionCode, @language, @session, @affiliated, @alt_center, @loginid, @newphone3, @newphone4, @newphone5, @brochureDownload
					IF @@ERROR <> 0
					BEGIN
						ROLLBACK TRANSACTION
					END

					EXEC spsvc_import_generate_activities 	@fileid, @lineitemid, @contact_id, @create_date, @create_time, @create_by, @appt_date_text, @appt_time, @act_code, @result_code, @newphone5, @source, @brochureDownload
					IF @@ERROR <> 0
					BEGIN
						ROLLBACK TRANSACTION
					END
				END

				DECLARE @CreationDate		DATETIME
				SET @CreationDate = CAST(CONVERT(varchar(10),@create_date,101) + ' ' + @create_time AS datetime)

				DECLARE @FiveDayBrochureActiveSettingValue	NCHAR(1)

				SET @FiveDayBrochureActiveSettingValue = LEFT((SELECT TOP 1 ISNULL(setting_value,'N') FROM onca_setting WHERE setting_name = '5_DAY_BROCHURE_ACTIVE'), 1)

				-- If an Appointment is scheduled 5 or more days in advance,
				-- the original Activity should be duplicated with a result of Brochure.
				IF (@FiveDayBrochureActiveSettingValue = 'Y' AND
					@result_code = 'APPOINT' AND
					dbo.CombineDates(@appt_date_text, CONVERT(datetime, '1/1/1900 ' + @appt_time)) >= DATEADD(DAY, 5, @CreationDate))
				BEGIN
					DECLARE @ActivityId			NCHAR(10)
					DECLARE @ActivityCompanyId	NCHAR(10)
					DECLARE @ActivityContactId	NCHAR(10)
					DECLARE @ActivityUserId		NCHAR(10)
					DECLARE @CompanyId			NCHAR(10)

					DECLARE @CurrentDate		DATETIME
					DECLARE @CurrentTime		DATETIME
					DECLARE @Description		NCHAR(50)
					DECLARE @TimeZoneCode		NCHAR(10)

					EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity','activity_id', @ActivityId OUTPUT, 'ITX'
					EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity_contact','activity_contact_id', @ActivityContactId OUTPUT,'ITX'
					EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity_user','activity_user_id', @ActivityUserId OUTPUT, 'ITX'
					EXEC dbo.pso_onc_create_primary_key 10,'oncd_activity_company','activity_company_id', @ActivityCompanyId OUTPUT, 'ITX'

					SET @CurrentDate = dbo.CombineDates(GETDATE(), NULL)
					SET @CurrentTime = dbo.CombineDates(NULL, GETDATE())
					SET @Description =  (SELECT TOP 1 description FROM onca_action WHERE action_code=@act_code)
					SET @TimeZoneCode = (SELECT TOP 1 time_zone_code FROM oncd_contact_address WHERE contact_id = @contact_id AND primary_flag = 'Y')

					-- FIND CENTER ASSIGNED TO THE CONTACT
					SET @CompanyId = (	SELECT [oncd_company].company_id
										FROM [oncd_company] WITH (NOLOCK)
										INNER JOIN [oncd_contact_company] WITH (NOLOCK)
											ON [oncd_company].[company_id] = [oncd_contact_company].[company_id]
										WHERE  [contact_id] = @contact_id
										AND [oncd_contact_company].[primary_flag] = 'Y')

					INSERT INTO oncd_activity (activity_id, due_date, start_time, action_code, description, creation_date, created_by_user_code, updated_date, updated_by_user_code, source_code, cst_activity_type_code, cst_time_zone_code, cst_brochure_download)
						VALUES (@ActivityId, @CurrentDate, @CurrentTime, @act_code, @Description, @CreationDate, @create_by, @CreationDate, @create_by, @source, 'INBOUND', @TimeZoneCode, @brochureDownload)

					INSERT INTO oncd_activity_contact (activity_contact_id, contact_id, activity_id, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
						VALUES (@ActivityContactId, @contact_id, @ActivityId, @CreationDate, 'Y', 1, @CreationDate, @create_by, @CreationDate, @create_by, 'Y')

					INSERT INTO oncd_activity_user (activity_user_id,activity_id, user_code, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
						VALUES(@ActivityUserId, @ActivityId, 'TM1500', @CreationDate, 'R', 1, @CreationDate, @create_by, @CreationDate, @create_by, 'Y')

					INSERT INTO oncd_activity_company (activity_company_id,activity_id, company_id, assignment_date, [attendance], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
						VALUES(@ActivityCompanyId, @ActivityId, @CompanyId, @CreationDate, 'N', 0, @CreationDate, @create_by, @CreationDate, @create_by, 'Y')

					UPDATE [oncd_activity]
					SET completion_date = @create_date,
						completion_time = @create_time,
						completed_by_user_code = @create_by,
						updated_date = @CreationDate,
						updated_by_user_code = @create_by,
						result_code = 'BROCHURE'
					WHERE [activity_id] = @ActivityId

				END
			END

			COMMIT TRANSACTION
		END

		IF @company = 'PageLynx'
		BEGIN
			INSERT INTO hcmtbl_leadstoimport_pagelynx_history
				(run_id, processed_date,action_type,contact_id,territory,create_date,create_time,create_by,first_name
				,last_name,street,street2,city,state,zip,email,phone,phone2,appt_date,appt_time,act_code
				,result_code,source,promo,recordid,gender,cst_age_range,loss_alternatives,cst_language
				,cst_sessionid,cst_affiliateid,alt_center,cst_loginid,phone3,phone4,phone5)
			VALUES
				(@runID, GETDATE(), @action, @contact_id, @territory, @create_date, @create_time, @create_by, @fname
				,@lname,@street,@street2,@city,@state,@zip,@email,@phone,@phone2,@appt_date_text,@appt_time,@act_code
				,@result_code,@source,@promo,@recordID,@gender,@age,@alternatives,@language
				,@session,@affiliated,@alt_center,@loginid,@phone3,@phone4,@phone5)
		END
	END -- FILTER OUT NO ZIP OR PHONE

	FETCH NEXT FROM alldata_curs INTO  @territory, @create_date_text, @create_time, @create_by, @fname, @lname, @street, @street2, @city, @state, @zip, @email, @phone, @phone2, @appt_date_text, @appt_time, @act_code, @result_code, @source, @promo, @contact_id,@gender, @age, @alternatives, @language, @session, @affiliated, @alt_center, @loginid, @phone3, @phone4, @phone5, @brochureDownload

END -- WHILE LOOP


-- CLOSE AND DESTROY CURSOR
CLOSE alldata_curs
DEALLOCATE alldata_curs
GO
