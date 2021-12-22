/* CreateDate: 09/12/2007 09:21:41.170 , ModifyDate: 08/08/2017 11:39:47.360 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------
-- PROCEDURE:	spsvc_import_newlead	VERSION  2.0
-- DESTINATION SERVER:	   HCSQL3\SQL2005
-- DESTINATION DATABASE: HCM
-- RELATED APPLICATION:  Oncontact data imports for pagelink, convergys etc
-- AUTHOR: OnContact
-- IMPLEMENTOR: Brian Kellman
-- DATE IMPLEMENTED: 10/01/07
-- LAST REVISION DATE: 23 June 2017
--------------------------------------------------------------------------------
-- NOTES:			This procedure loads the Lead Reporting table
--
-- BK: 10/30/2007	Added S.adi_flag	,S.contact_status_code ,S.updated_date
--					,S.updated_by_user_code ,S.cst_sessionid ,S.cst_affiliateid
--
-- BK: 11/15/2007	Added creation_date
--
-- BK: 11/26/2007	Removed UPDLock hints from the inserts
--
-- FR: 5/21/2008	Added phone3, phone4, phone5
--
-- FR: 3/26/2009	Added @phone_type_code logic and 5th phone # logic for text
--					messaging
--
-- FR: 10/9/2009	Set source to 'PL IMPORT' if source is null
--
-- NK: 01/08/2010	Set the promotion code lookup to be based on the incoming code
--					not description.
--
-- MW: 04/13/2015	Default cst_valid_flag to 'Y' for new records
--
--
-- MW: 05/12/2015	Validation for address, phone, email
--
-- MW: 10/19/2015	modify sessionid to support 100 char
--
-- MW: 06/23/2017	Utilize pso_onc_create_primary_key
--
--------------------------------------------------------------------------------
--
-- SAMPLE EXEC: EXEC spsvc_import_newlead @fileid, @lineitemid, @contact_id, @territory, @create_date, @create_time, @create_by, @fname, @lname, @street, @street2, @city, @state, @zip, @email, @newphone, @newphone2, @source,@gender, @age, @alternatives, @promo, @language, @session, @affiliated, @alt_center, @loginid
--
--------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[spsvc_import_newlead]
(
	@fileid				INT,
	@lineitemid			INT,
	@contact_id			VARCHAR(10) OUTPUT,
	@territory			VARCHAR(10),
	@create_date		DATETIME,
	@create_time		VARCHAR(20),
	@create_by			VARCHAR(20),
	@fname				VARCHAR(50),
	@lname				VARCHAR(50),
	@street				VARCHAR(60),
	@street2			VARCHAR(60),
	@city				VARCHAR(60),
	@state				VARCHAR(20),
	@zip				VARCHAR(15),
	@email				VARCHAR(100),
	@phone				VARCHAR(20),
	@phone2				VARCHAR(20),
	@source				VARCHAR(20),
	@gender				VARCHAR(10),
	@age				VARCHAR(10),
	@alternatives		VARCHAR(20),
	@promo				VARCHAR(20),
	@language			VARCHAR(10),
	@session			VARCHAR(100),
	@affiliate			VARCHAR(50),
	@alt_center			VARCHAR(10),
	@loginid			VARCHAR(50),
	@phone3				VARCHAR(20),
	@phone4				VARCHAR(20),
	@phone5				VARCHAR(20),
	@brochureDownload NCHAR(1)
) AS
--------------------------------------------------------------------------------
-- THIS STORED PROCEDURE WILL HANDLE THE LOGIC AND ERRORS OF
-- ADDING A NEW LEAD INTO THE SYSTEM.  THE TABLES AFFECTED ARE
-- AS FOLLOWS IN CHRONOLOGICAL ORDER.
--
-- STEP 1: oncd_contact  			BASIC LEAD CREATION INFORMATION
-- STEP 2: oncd_contact_phone 		LEAD PHONE INFORMATION
-- STEP 3: oncd_contact_address  	LEAD ADDRESS INFORMATION
-- STEP 4: oncd_contact_email	 	LEAD EMAIL ADDRESS INFORMATION
-- STEP 5: oncd_contact_source		LEAD SOURCE INFORMATION
-- STEP 6: oncd_contact_company		LEAD CENTER INFORMATION
-- STEP 7: oncd_contact_user 		LEAD FIRST USER INFORMATION
--------------------------------------------------------------------------------

-- LOCAL VARIABLE DECLARATION SECTION
DECLARE @act_key				INT
DECLARE @contact_phoneID		NVARCHAR(10)
DECLARE @contact_addressID		NVARCHAR(10)
DECLARE @contact_emailID		NVARCHAR(10)
DECLARE @contact_sourceID		NVARCHAR(10)
DECLARE @contact_companyID		NVARCHAR(10)
DECLARE @contact_user_id		NVARCHAR(10)
DECLARE @company_id				NVARCHAR(10)
DECLARE @alt_company_id			NVARCHAR(10)
DECLARE @creation_date			DATETIME
DECLARE @cst_age_range_code		VARCHAR(10)
DECLARE @cst_hair_loss_code		VARCHAR(10)
DECLARE @cst_promotion_code		VARCHAR(10)
DECLARE @contact_status_code	VARCHAR(10)
DECLARE @county_code			NVARCHAR(10)
DECLARE @country_code			NVARCHAR(20)
DECLARE @time_zone_code			NVARCHAR(10)
DECLARE @job_function_code		NVARCHAR(10)
DECLARE @phone_sort_order		INT
DECLARE @phone_type_code		NCHAR(10)
DECLARE @primary_flag			NCHAR(1)
DECLARE @valid_flag				NCHAR(1)
DECLARE @area_code				nvarchar(3)

SET @phone_sort_order = 0
SET @primary_flag = 'Y'
SET @creation_date = CAST(CONVERT(varchar(10),@create_date,101) + ' ' + @create_time AS datetime)

-- FIND CENTER ASSIGNED TO THE LEADS ZIP CODE
IF ISNUMERIC(@territory) = 0
BEGIN
	SET @company_id = (SELECT TOP 1 company_id FROM cstd_company_zip_code WHERE @zip BETWEEN zip_from AND zip_to ORDER BY type_code DESC)
END
ELSE
BEGIN
	SET @company_id = (SELECT TOP 1 company_id FROM [oncd_company] WHERE [cst_center_number] = @territory)
END

-- CREATE PRIMARY FOR ALT_CENTER IF EXISTS
IF ISNUMERIC(@alt_center) = 1
BEGIN
	SET @alt_company_id = (SELECT TOP 1 company_id FROM [oncd_company] WHERE [cst_center_number] = @alt_center)
END

-- FIND ASSOCIATED CODES FOR VALUES IMPORTED FROM FILE AND ADDL LOOKUPS
SET @cst_age_range_code =  (SELECT TOP 1 age_range_code FROM dbo.csta_contact_age_range WHERE description = @age)
SET @cst_hair_loss_code =  (SELECT TOP 1 hair_loss_code FROM dbo.csta_contact_hair_loss WHERE description = @alternatives)

-- 01/08/2010
-- SET THE PROMOTION CODE LOOKUP TO BE BASED ON THE INCOMING CODE NOT DESCRIPTION
-- SET @cst_promotion_code =  (SELECT TOP 1 promotion_code FROM dbo.csta_promotion_code WHERE description = @promo)
SET @cst_promotion_code =	(SELECT TOP 1 promotion_code FROM dbo.csta_promotion_code WHERE promotion_code = @promo)
SET @county_code		=	(SELECT TOP 1 [county_code] FROM dbo.[onca_zip] WHERE [zip_code] = @zip)
SET @country_code		=	(SELECT TOP 1 [country_code] FROM dbo.[onca_zip] WHERE [zip_code] = @zip)
SET @time_zone_code		=	(SELECT TOP 1 [time_zone_code] FROM dbo.[onca_county] WHERE [county_code] = @county_code )
SET @job_function_code	=	(SELECT TOP 1 [job_function_code] FROM dbo.[onca_user] WHERE [user_code] = @create_by )

-- SET THE CONTACT_STATUS_CODE - MAY USE A LOOKUP TABLE IN FUTURE
SET @contact_status_code = 'LEAD'
IF (@lname LIKE 'TEST%' AND @fname LIKE 'TEST%')
BEGIN
	SET @contact_status_code = 'TEST'
END

-- SET THE CST_GENDER_CODE - CHECK FOR NULL OR BAD
IF (@gender IS NULL OR @gender NOT IN ('male','female'))
BEGIN
	SET @gender = 'UNKNOWN'
END

-- ASSIGN CONTACT_ID FOR NEW LEAD
EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact','contact_id', @contact_id OUTPUT, 'ITX'

BEGIN TRANSACTION

	-- CREATE CONTACT ENTRY
	INSERT INTO oncd_contact (contact_id, [greeting], last_name, first_name, first_name_search, last_name_search, [first_name_soundex], [last_name_soundex], contact_status_code, [duplicate_check], creation_date, created_by_user_code, updated_date, updated_by_user_code, [status_updated_date], [status_updated_by_user_code], cst_gender_code, cst_age_range_code, cst_hair_loss_code, cst_promotion_code, cst_language_code, cst_sessionid, cst_affiliateid, alt_center, cst_loginid)
	VALUES (@contact_id, @fname, @lname, @fname, UPPER(@fname), UPPER(@lname), '', '', @contact_status_code, 'Y', @creation_date, @create_by, @creation_date, @create_by, @creation_date, @create_by, UPPER(@gender), @cst_age_range_code, @cst_hair_loss_code, UPPER(@cst_promotion_code), UPPER(@language), @session, @affiliate, @alt_center, @loginid)

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	--CREATE Phone_1
	IF (ISNULL(@phone,'') <> '')
	BEGIN
		IF @phone = ISNULL(@phone5,'')
			SET @phone_type_code = 'CELL'
		ELSE
			SET @phone_type_code = 'HOME'

		SET @area_code = RTRIM(LEFT(@phone,3))
		SET @valid_flag = dbo.psoIsValidPhone(@area_code, RIGHT(@phone,7))

		SET @phone_sort_order = @phone_sort_order + 1
		IF @valid_flag = 'N'
			SET @primary_flag = 'N'
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @contact_phoneID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_phone  (contact_phone_id,contact_id, [phone_type_code], [country_code_prefix], area_code, phone_number, [active], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag)
		VALUES (@contact_phoneID, @contact_id, @phone_type_code, '1', LEFT(@phone,3), RIGHT(@phone,7), 'Y', @phone_sort_order, @creation_date, @create_by, @creation_date, @create_by, @primary_flag, @valid_flag)
		IF @valid_flag = 'N'
			SET @primary_flag = 'Y'
		ELSE
			SET @primary_flag = 'N'
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END


	-- CREATE Phone_2
	IF (ISNULL(@phone2,'') <> '')
	BEGIN
		IF @phone2 = ISNULL(@phone5,'')
			SET @phone_type_code = 'CELL'
		ELSE
			SET @phone_type_code = 'HOME'

		SET @area_code = RTRIM(LEFT(@phone2,3))
		SET @valid_flag = dbo.psoIsValidPhone(@area_code, RIGHT(@phone2,7))

		IF @valid_flag = 'N'
			SET @primary_flag = 'N'
		SET @phone_sort_order = @phone_sort_order + 1
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @contact_phoneID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_phone (contact_phone_id,contact_id, [phone_type_code], [country_code_prefix], area_code, phone_number, [active], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag)
		VALUES (@contact_phoneID, @contact_id, @phone_type_code, '1', LEFT(@phone2,3), RIGHT(@phone2,7), 'Y', @phone_sort_order, @creation_date, @create_by, @creation_date, @create_by, @primary_flag, @valid_flag)
		IF @valid_flag = 'N'
			SET @primary_flag = 'Y'
		ELSE
			SET @primary_flag = 'N'
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	--CREATE Phone_3
	IF (ISNULL(@phone3,'') <> '')
	BEGIN
		IF @phone3 = ISNULL(@phone5,'')
			SET @phone_type_code = 'CELL'
		ELSE
			SET @phone_type_code = 'HOME'

		SET @area_code = RTRIM(LEFT(@phone3,3))
		SET @valid_flag = dbo.psoIsValidPhone(@area_code, RIGHT(@phone3,7))

		IF @valid_flag = 'N'
			SET @primary_flag = 'N'
		SET @phone_sort_order = @phone_sort_order + 1
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @contact_phoneID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_phone (contact_phone_id,contact_id, [phone_type_code], [country_code_prefix], area_code, phone_number, [active], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag)
		VALUES (@contact_phoneID, @contact_id, @phone_type_code, '1', LEFT(@phone3,3), RIGHT(@phone3,7), 'Y', @phone_sort_order , @creation_date, @create_by, @creation_date, @create_by, @primary_flag, @valid_flag)
		IF @valid_flag = 'N'
			SET @primary_flag = 'Y'
		ELSE
			SET @primary_flag = 'N'
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	-- CREATE Phone_4
	IF (ISNULL(@phone4,'') <> '')
	BEGIN
		IF @phone4 = ISNULL(@phone5,'')
			SET @phone_type_code = 'CELL'
		ELSE
			SET @phone_type_code = 'HOME'

		SET @area_code = RTRIM(LEFT(@phone4,3))
		SET @valid_flag = dbo.psoIsValidPhone(@area_code, RIGHT(@phone4,7))

		IF @valid_flag = 'N'
			SET @primary_flag = 'N'
		SET @phone_sort_order = @phone_sort_order + 1
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @contact_phoneID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_phone (contact_phone_id,contact_id, [phone_type_code], [country_code_prefix], area_code, phone_number, [active], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag)
		VALUES (@contact_phoneID, @contact_id, @phone_type_code, '1', LEFT(@phone4,3), RIGHT(@phone4,7), 'Y', @phone_sort_order, @creation_date, @create_by, @creation_date, @create_by, @primary_flag, @valid_flag)
		IF @valid_flag = 'N'
			SET @primary_flag = 'Y'
		ELSE
			SET @primary_flag = 'N'
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	-- CREATE Phone_5
	IF (ISNULL(@phone5,'') != '' and ISNULL(@phone,'') != ISNULL(@phone5,'') and ISNULL(@phone2,'') != ISNULL(@phone5,'') and ISNULL(@phone3,'') != ISNULL(@phone5,'') and ISNULL(@phone4,'') != ISNULL(@phone5,''))
	BEGIN

		SET @area_code = RTRIM(LEFT(@phone5,3))
		SET @valid_flag = dbo.psoIsValidPhone(@area_code, RIGHT(@phone5,7))

		IF @valid_flag = 'N'
			SET @primary_flag = 'N'
		SET @phone_sort_order = @phone_sort_order + 1
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_phone','contact_phone_id', @contact_phoneID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_phone (contact_phone_id,contact_id, [phone_type_code], [country_code_prefix], area_code, phone_number, [active], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag)
		VALUES (@contact_phoneID, @contact_id, 'CELL', '1', LEFT(@phone5,3), RIGHT(@phone5,7), 'Y', @phone_sort_order , @creation_date, @create_by, @creation_date, @create_by, @primary_flag, @valid_flag)
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	-- CREATE CONTACT ADDRESS
	IF @street IS NOT NULL AND @city IS NOT NULL
	BEGIN
		IF ISNULL(@state,'') = '' OR ISNULL(@zip,'') = ''
			SET @valid_flag = 'N'
		ELSE
			SET @valid_flag = 'Y'

		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_address','contact_address_id', @contact_addressID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_address (contact_address_id,contact_id, [address_type_code], address_line_1, address_line_2, [address_line_1_soundex], [address_line_2_soundex], city, [city_soundex], state_code, zip_code, county_code, country_code, time_zone_code, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag, cst_active)
		VALUES (@contact_addressID, @contact_id, 'HOME', @street, @street2, '', '', @city, '', @state, @zip, @county_code, @country_code, @time_zone_code, 1, @creation_date, @create_by, @creation_date, @create_by, @valid_flag, @valid_flag, 'Y')
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	-- CREATE CONTACT EMAIL
	IF @email IS NOT NULL
	BEGIN
		SET @valid_flag = dbo.psoIsValidEmail(@email)
		SET @primary_flag = N'Y'

		IF @valid_flag = 'N'
			SET @primary_flag = 'N'
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_email','contact_email_id', @contact_emailID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_email (contact_email_id,contact_id, email_type_code, email, [active], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag, cst_valid_flag)
		VALUES (@contact_emailID,@contact_id, 'HOME', @email, 'Y', 1, @creation_date, @create_by, @creation_date, @create_by, @primary_flag, @valid_flag)
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	-- CREATE CONTACT SOURCE
	IF (ISNULL(@source,'') = '')
	   	SET @source = 'PL IMPORT'

	IF @source IS NOT NULL
	BEGIN
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_source','contact_source_id', @contact_sourceID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_source (contact_source_id,contact_id, source_code, sort_order, assignment_date, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
		VALUES(@contact_sourceID, @contact_id, UPPER(@source), 1, @creation_date, @creation_date, @create_by, @creation_date, @create_by, 'Y')
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	-- CREATE CONTACT COMPANY ENTRY - IF ALT_CENTER THEN MAKE PRIMARY AND TERRITORY SECONDARY
	IF (@alt_company_id IS NOT NULL AND @company_id IS NOT NULL)
	BEGIN
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_company','contact_company_id', @contact_companyID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_company (contact_company_id,contact_id, company_id, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
		VALUES(@contact_companyID, @contact_id, @alt_company_id, 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')

		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_company','contact_company_id', @contact_companyID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_company (contact_company_id,contact_id, company_id, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
		VALUES(@contact_companyID, @contact_id, @company_id, 1, @creation_date, @create_by, @creation_date, @create_by, 'N')
	END
	ELSE IF (@company_id IS NOT NULL AND @alt_company_id IS NULL)
	BEGIN
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_company','contact_company_id', @contact_companyID OUTPUT, 'ITX'
		INSERT INTO oncd_contact_company (contact_company_id,contact_id, company_id, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
		VALUES(@contact_companyID, @contact_id, @company_id, 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	-- SET FIRST CONTACT REP TO IMPORT USER
	IF @create_by IS NOT NULL
	BEGIN
		EXEC dbo.pso_onc_create_primary_key 10,'oncd_contact_user','contact_user_id', @contact_user_id OUTPUT, 'ITX'
		INSERT INTO oncd_contact_user (contact_user_id,contact_id, user_code, [job_function_code], sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
		VALUES(@contact_user_id, @contact_id, @create_by, @job_function_code, 1, @creation_date, @create_by, @creation_date, @create_by, 'Y')
	END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	UPDATE hcmtbl_file_import_file_detail
	SET 	contact_id=@contact_id
		,	is_new_lead=1
	WHERE
		[file_id]=@fileid AND
		lineitem_id=@lineitemid

COMMIT TRANSACTION
GO
