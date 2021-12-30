/* CreateDate: 06/24/2014 16:04:41.413 , ModifyDate: 01/30/2017 13:48:52.883 */
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSUpdateOnContact
DESTINATION SERVER:		SQL03
DESTINATION DATABASE:	HCM
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		05/09/2014
------------------------------------------------------------------------
NOTES:

06/24/2014 - DL - Added additional query to determine the Center associated with the activity.
07/22/2014 - MT - Modified to clear scale selection if Gender changes.
09/10/2014 - KL - Modified to save ethnicitycode on insert to cstd_activity_demographic table
11/16/2016 - SL - Added additional input parameters and added update and insert statements for ansillary tables
01/18/2017 - MT - Modified gender to be VARCHAR(10) instead of CHAR(1) in order to accept 'MALE' and 'FEMALE' (TFS #8433)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHairClubCMSUpdateOnContact
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSUpdateOnContact]
(
	@ContactID VARCHAR(50),
	@FirstName VARCHAR(50),
	@LastName VARCHAR(50),
	@Gender VARCHAR(10),
	@LanguageCode VARCHAR(50) = 'ENGLISH',

	@AddressID VARCHAR(50),
	@AddressLine1 VARCHAR(100),
	@AddressLine2 VARCHAR(100),
	@City VARCHAR(50),
	@State VARCHAR(50),
	@Zip VARCHAR(50),
	@Country VARCHAR(50),

	@PhoneID VARCHAR(50),
	@HomePhoneAreaCode VARCHAR(10),
	@HomePhoneNumber VARCHAR(10),

	@EmailID VARCHAR(50),
	@EmailAddress VARCHAR(100),

	@ActivityID VARCHAR(50),
	@EthnicityCode VARCHAR(10),
	@UpdatedBy VARCHAR(50)
)
AS
SET XACT_ABORT ON

BEGIN TRANSACTION

	DECLARE @ContactPhoneID varchar(25)
    DECLARE @ContactAddressID varchar(25)
    DECLARE @ContactEmailID varchar(25)

	DECLARE @p_Gender NCHAR(10) = CASE @Gender WHEN 'M' THEN 'MALE' WHEN 'F' THEN 'FEMALE' END
	DECLARE @prev_FirstName NCHAR(20) = (SELECT OC.first_name FROM oncd_contact OC WHERE OC.contact_id = @ContactID)
	DECLARE @prev_LastName NCHAR(20) = (SELECT OC.last_name FROM oncd_contact OC WHERE OC.contact_id = @ContactID)

	DECLARE @currentGender as NCHAR(10)
	DECLARE @ludwig as NCHAR(50)
	DECLARE @norwood as NCHAR(50)

	SELECT @currentGender = cst_gender_code
	FROM oncd_contact
	WHERE contact_id = @ContactID

	SELECT    @norwood = norwood,
			  @ludwig = ludwig
	FROM      cstd_activity_demographic
	WHERE     activity_id = @ActivityID

	IF (@currentGender IS NULL AND @p_Gender <> 'MALE') OR
		(@currentGender IS NOT NULL AND @currentGender <> @p_Gender)
	BEGIN
		SET @ludwig = null
		SET @norwood = null
	END

	-- ONCD CONTACT.
	UPDATE  oncd_contact
	SET     greeting = @FirstName,
			cst_previous_first_name = @prev_FirstName,
			cst_previous_last_name = @prev_LastName,
			first_name = @FirstName,
			last_name = @LastName,
			first_name_search = UPPER(@FirstName),
			last_name_search = UPPER(@LastName),
			cst_language_code = @LanguageCode,
			cst_gender_code = @p_Gender,
			updated_date = GETDATE(),
			cst_updated_by_user_code = @UpdatedBy
	WHERE   contact_id = @ContactID

	IF @@ERROR <> 0
	BEGIN
			ROLLBACK TRANSACTION
			RETURN
	END

	-- ONCD CONTACT ADDRESS.
	IF @AddressID IS NOT NULL AND LTRIM(RTRIM(@AddressID)) <> ''
		--UPDATE
		BEGIN
			UPDATE	oncd_contact_address
			SET		address_line_1 = @AddressLine1,
					address_line_2 = @AddressLine2,
					city = @City,
					state_code = @State,
					zip_code = @Zip,
					country_code = @Country,
					updated_by_user_code = @UpdatedBy,
					updated_date = GETDATE()
			WHERE	contact_address_id = @AddressID
		END

	ELSE IF @AddressLine1 IS NOT NULL AND LTRIM(RTRIM(@AddressLine1)) <> '' OR
		    @AddressLine2 IS NOT NULL AND LTRIM(RTRIM(@AddressLine2)) <> '' OR
		    @City IS NOT NULL AND LTRIM(RTRIM(@City)) <> '' OR
		    @State IS NOT NULL AND LTRIM(RTRIM(@State)) <> '' OR
		    @Zip IS NOT NULL AND LTRIM(RTRIM(@Zip)) <> '' OR
		    @Country IS NOT NULL AND LTRIM(RTRIM(@Country)) <> ''

		--INSERT
		BEGIN
			EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_contact_address', 'contact_address_id', @ContactAddressID OUTPUT, 'ONC'

			INSERT  intO oncd_contact_address (contact_address_id, contact_id, address_line_1, address_line_2, city, state_code, zip_code, county_code, country_code, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date, address_type_code)
				VALUES (@ContactAddressID, @ContactID, @AddressLine1, @AddressLine2, @City, @State, @Zip, NULL, @Country, 'Y', 0, @UpdatedBy, GETDATE(), @UpdatedBy, GETDATE(), 'HOME')
		END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

    -- ONCD CONTACT PHONE.
	IF @PhoneID IS NOT NULL AND LTRIM(RTRIM(@PhoneID)) <> ''
		--UPDATE
		BEGIN
			UPDATE	oncd_contact_phone
			SET		area_code = @HomePhoneAreaCode,
					phone_number = @HomePhoneNumber,
					updated_by_user_code = @UpdatedBy,
					updated_date = GETDATE()
			WHERE	contact_phone_id = @PhoneID
		END

	ELSE IF @HomePhoneNumber IS NOT NULL AND LTRIM(RTRIM(@HomePhoneNumber)) <> ''
		--INSERT
		BEGIN
			EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_contact_phone', 'contact_phone_id', @ContactPhoneID OUTPUT, 'ONC'

			INSERT  intO oncd_contact_phone (contact_phone_id, contact_id, area_code, phone_number, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date, active, phone_type_code)
				VALUES (@ContactPhoneID, @ContactID, @HomePhoneAreaCode, @HomePhoneNumber, 'Y', 0, @UpdatedBy, GETDATE(), @UpdatedBy, GETDATE(), 'Y', 'HOME')
		END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

    -- ONCD CONTACT EMAIL.
	IF @EmailID IS NOT NULL AND LTRIM(RTRIM(@EmailID)) <> ''
		--UPDATE
		BEGIN
			UPDATE	oncd_contact_email
			SET		email = @EmailAddress,
					updated_by_user_code = @UpdatedBy,
					updated_date = GETDATE()
			WHERE	contact_email_id = @EmailID
		END

	ELSE
		--INSERT
		BEGIN
			EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_contact_email', 'contact_email_id', @ContactEmailID OUTPUT, 'ONC'

			INSERT INTO oncd_contact_email (contact_email_id, contact_id, email, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date, active, email_type_code)
				VALUES (@ContactEmailID, @ContactID, @EmailAddress, 'Y', 0, @UpdatedBy, GETDATE(), @UpdatedBy, GETDATE(), 'Y', 'HOME')
		END

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END

	-- Activity Demographics
	IF ISNULL(@ActivityID, '') <> ''
	   BEGIN
			IF @EthnicityCode IS NOT NULL
			BEGIN
				-- IF Activity Demographic Record Exists then update existing activity demographic record
				IF EXISTS ( SELECT    activity_id
							FROM      cstd_activity_demographic
							WHERE     activity_id = @ActivityID )
					BEGIN
						UPDATE   cstd_activity_demographic
						SET      ethnicity_code = @EthnicityCode,
								 ludwig = @ludwig,
								 norwood = @norwood
						WHERE    activity_id = @ActivityID

						IF @@ERROR <> 0
							BEGIN
								ROLLBACK TRANSACTION
								RETURN @@ERROR
							END
					END

				-- IF Activity Demographic Record Does Not Exist then create new activity demographic record
				ELSE
					BEGIN
						DECLARE @ActivityDemographicID VARCHAR(25)

						EXEC onc_create_primary_key 10, 'cstd_activity_demographic', 'activity_demographic_id', @ActivityDemographicID OUTPUT, 'ONC'


						DECLARE @p_CenterID NCHAR(20)

						SET @p_CenterID = (SELECT OA.created_by_user_code FROM oncd_activity OA WHERE OA.activity_id = @ActivityID)


						INSERT  INTO cstd_activity_demographic
								(
									activity_demographic_id
								,	activity_id
								,	gender
								,	birthday
								,	occupation_code
								,	ethnicity_code
								,	maritalstatus_code
								,	norwood
								,	ludwig
								,	age
								,	creation_date
								,	created_by_user_code
								,	updated_date
								,	updated_by_user_code
								,	performer
								,	price_quoted
								,	solution_offered
								,	no_sale_reason
								,	disc_style
								)
						VALUES   (
									@ActivityDemographicID
								,	@ActivityID
								,	'?'
								,	'2003-01-01'
								,	'0'
								,	@EthnicityCode
								,	'0'
								,	@ludwig
								,	@ludwig
								,	0
								,	GETDATE()
								,	@p_CenterID
								,	GETDATE()
								,	@p_CenterID
								,	NULL
								,	0.00
								,	NULL
								,	NULL
								,	NULL )

						IF @@ERROR <> 0
							BEGIN
								ROLLBACK TRANSACTION
								RETURN @@ERROR
							END
					END
			END
	   END

COMMIT TRANSACTION
GO
