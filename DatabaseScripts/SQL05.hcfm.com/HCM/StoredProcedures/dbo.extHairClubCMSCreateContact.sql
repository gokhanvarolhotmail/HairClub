/* CreateDate: 08/18/2015 10:54:28.210 , ModifyDate: 08/18/2015 10:54:28.210 */
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSCreateContact
DESTINATION SERVER:		SQL03
DESTINATION DATABASE:	HCM
AUTHOR:					Mike Tovbin
IMPLEMENTOR:			Mike Tovbin
DATE IMPLEMENTED:		08/07/2015
------------------------------------------------------------------------
NOTES:

	08/07/2015 - MT - Created
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHairClubCMSCreateContact
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSCreateContact]
(
      @ContactID varchar(25) output,
      @CenterID int,
      @FirstName varchar(50),
      @LastName varchar(50),
      @Gender varchar(50),
      @EmailAddress varchar(100),
      @HomePhoneAreaCode varchar(10),
      @HomePhoneNumber varchar(10),
	  @WorkPhoneAreaCode varchar(10),
      @WorkPhoneNumber varchar(10),
	  @MobilePhoneAreaCode varchar(10),
      @MobilePhoneNumber varchar(10),
      @AddressLine1 varchar(100),
      @AddressLine2 varchar(100),
      @City varchar(50),
      @State varchar(50),
      @Zip varchar(50),
      @Country varchar(50),
      @Source varchar(50),
	  @IsDoNotContact bit,
	  @LanguageCode varchar(50) = 'ENGLISH',
	  @PromoCode varchar(50) = 'UNKNOWN',
	  @StatusCode varchar(50) = 'LEAD'
)
AS
SET XACT_ABORT ON

BEGIN TRANSACTION

	DECLARE @p_CenterID nchar(10) = CAST(@CenterID AS nchar(20))

    DECLARE @ContactCompanyID varchar(25)
    DECLARE @ContactPhoneID varchar(25)
    DECLARE @ContactSourceID varchar(25)
    DECLARE @ContactAddressID varchar(25)
    DECLARE @ContactEmailID varchar(25)

    --DECLARE @County varchar(50)
    DECLARE @CompanyID varchar(50)
	DECLARE @DoNotContact varchar(1) = 'N'

	IF @IsDoNotContact = 1
		SET @DoNotContact = 'Y'

	IF @LanguageCode IS NULL
		SET @LanguageCode = 'ENGLISH'

	IF @PromoCode IS NULL
		SET @PromoCode = 'UNKNOWN'

	IF @StatusCode IS NULL
		SET @StatusCode = 'LEAD'

	IF @ContactID IS NULL OR LTRIM(RTRIM(@ContactID)) = ''
		 EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_contact', 'contact_id', @ContactID OUTPUT, 'ONC'

    EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_contact_company', 'contact_company_id', @ContactCompanyID OUTPUT, 'ONC'
    EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_contact_phone', 'contact_phone_id', @ContactPhoneID OUTPUT, 'ONC'
    EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_contact_address', 'contact_address_id', @ContactAddressID OUTPUT, 'ONC'
    EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_contact_source', 'contact_source_id', @ContactSourceID OUTPUT, 'ONC'

    --SELECT TOP 1 @County = ISNULL(country_code, '')
    --FROM cfgPostalCode
    --WHERE zip_code = @Zip

    SELECT TOP 1 @CompanyID = ISNULL(company_id, '')
    FROM oncd_company
    WHERE cst_center_number = CONVERT(Nchar(10), @CenterID)


    -- ONCD CONTACT.
	INSERT INTO oncd_contact ( contact_id, greeting, first_name, last_name, first_name_search, last_name_search, do_not_solicit, cst_do_not_call, cst_do_not_email, cst_do_not_mail,
					cst_language_code, cst_promotion_code, cst_age_range_code, cst_hair_loss_code, created_by_user_code, creation_date, updated_by_user_code, updated_date, contact_status_code, duplicate_check, status_updated_date, cst_gender_code, status_updated_by_user_code)
		VALUES (@ContactID, @FirstName, @FirstName, @LastName, UPPER(@FirstName), UPPER(@LastName), @DoNotContact, @DoNotContact, @DoNotContact, @DoNotContact,
					@LanguageCode, @PromoCode, 'UNKNOWN', 'UNKNOWN', @p_CenterID, GETDATE(), @p_CenterID, GETDATE(), @StatusCode, 'Y', GETDATE(), @Gender, @p_CenterID)

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION
        RETURN
    END

    -- ONCD CONTACT COMPANY.
    INSERT  intO oncd_contact_company (contact_company_id, contact_id, company_id, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date)
        VALUES (@ContactCompanyID, @ContactID, @CompanyID, 'Y', 0, @p_CenterID, GETDATE(), @p_CenterID, GETDATE())

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION
        RETURN
    END

    -- ONCD CONTACT EMAIL.
	IF @EmailAddress IS NOT NULL AND LTRIM(RTRIM(@EmailAddress)) <> ''
	BEGIN

		EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_contact_email', 'contact_email_id', @ContactEmailID OUTPUT, 'ONC'
		INSERT  intO oncd_contact_email (contact_email_id, contact_id, email, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date, active, email_type_code)
			VALUES (@ContactEmailID, @ContactID, @EmailAddress, 'Y', 0, @p_CenterID, GETDATE(), @p_CenterID, GETDATE(), 'Y', 'HOME')

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END
	END

    -- ONCD CONTACT PHONE.
	IF @HomePhoneNumber IS NOT NULL AND LTRIM(RTRIM(@HomePhoneNumber)) <> ''
	BEGIN
		INSERT  intO oncd_contact_phone (contact_phone_id, contact_id, area_code, phone_number, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date, active, phone_type_code)
			VALUES (@ContactPhoneID, @ContactID, @HomePhoneAreaCode, @HomePhoneNumber, 'Y', 0, @p_CenterID, GETDATE(), @p_CenterID, GETDATE(), 'Y', 'HOME')

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END
	END


	-- ONCD CONTACT WORK PHONE.
	IF @WorkPhoneNumber IS NOT NULL AND LTRIM(RTRIM(@WorkPhoneNumber)) <> ''
	BEGIN

		EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_contact_phone', 'contact_phone_id', @ContactPhoneID OUTPUT, 'ONC'
		INSERT  intO oncd_contact_phone (contact_phone_id, contact_id, area_code, phone_number, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date, active, phone_type_code)
			VALUES (@ContactPhoneID, @ContactID, @WorkPhoneAreaCode, @WorkPhoneNumber, 'N', 0, @p_CenterID, GETDATE(), @p_CenterID, GETDATE(), 'Y', 'BUSINESS')

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END
	END

	-- ONCD CONTACT MOBILE PHONE.
	IF @MobilePhoneNumber IS NOT NULL AND LTRIM(RTRIM(@MobilePhoneNumber)) <> ''
	BEGIN

		EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_contact_phone', 'contact_phone_id', @ContactPhoneID OUTPUT, 'ONC'
		INSERT  intO oncd_contact_phone (contact_phone_id, contact_id, area_code, phone_number, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date, active, phone_type_code)
			VALUES (@ContactPhoneID, @ContactID, @MobilePhoneAreaCode, @MobilePhoneNumber, 'N', 0, @p_CenterID, GETDATE(), @p_CenterID, GETDATE(), 'Y', 'CELL')

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END
	END

    -- ONCD CONTACT ADDRESS.
    INSERT  intO oncd_contact_address (contact_address_id, contact_id, address_line_1, address_line_2, city, state_code, zip_code, county_code, country_code, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date, address_type_code)
        VALUES (@ContactAddressID, @ContactID, @AddressLine1, @AddressLine2, @City, @State, @Zip, NULL, @Country, 'Y', 0, @p_CenterID, GETDATE(), @p_CenterID, GETDATE(), 'HOME')

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION
        RETURN
    END


    -- ONCD CONTACT SOURCE.
    INSERT  intO oncd_contact_source (contact_source_id, contact_id, source_code, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date)
        VALUES (@ContactSourceID, @ContactID, @Source, 'Y', 0, @p_CenterID, GETDATE(), @p_CenterID, GETDATE())

    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRANSACTION
        RETURN
    END

COMMIT TRANSACTION
GO
