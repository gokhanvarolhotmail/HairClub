/* CreateDate: 12/11/2012 14:57:18.653 , ModifyDate: 12/11/2012 14:57:18.653 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactCreateContact

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dominic Leiba

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 7/29/2008

LAST REVISION DATE: 	 5/7/2010

==============================================================================
DESCRIPTION:	Interface with OnContact database
==============================================================================
NOTES:
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_CreateContact

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactCreateContact
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactCreateContact]
(
      @ContactID varchar(25),
      @CenterID int,
      @FirstName varchar(50),
      @LastName varchar(50),
      @Gender varchar(50),
      @EmailAddress varchar(100),
      @AreaCode varchar(50),
      @PhoneNumber varchar(50),
      @AddressLine1 varchar(100),
      @AddressLine2 varchar(100),
      @City varchar(50),
      @State varchar(50),
      @Zip varchar(50),
      @Country varchar(50),
      @Source varchar(50)
)
AS
      SET NOCOUNT ON

BEGIN TRANSACTION

      DECLARE @ContactCompanyID varchar(25)
      DECLARE @ContactPhoneID varchar(25)
      DECLARE @ContactSourceID varchar(25)
      DECLARE @ContactAddressID varchar(25)
      DECLARE @ContactEmailID varchar(25)

      DECLARE @County varchar(50)
      DECLARE @CompanyID varchar(50)

      EXEC extOnContactCreatePrimaryKey 10, 'oncd_contact_company', 'contact_company_id', @ContactCompanyID OUTPUT, 'ONC'
      EXEC extOnContactCreatePrimaryKey 10, 'oncd_contact_email', 'contact_email_id', @ContactEmailID OUTPUT, 'ONC'
      EXEC extOnContactCreatePrimaryKey 10, 'oncd_contact_phone', 'contact_phone_id', @ContactPhoneID OUTPUT, 'ONC'
      EXEC extOnContactCreatePrimaryKey 10, 'oncd_contact_address', 'contact_address_id', @ContactAddressID OUTPUT, 'ONC'
      EXEC extOnContactCreatePrimaryKey 10, 'oncd_contact_source', 'contact_source_id', @ContactSourceID OUTPUT, 'ONC'

      SELECT TOP 1 @County = ISNULL(country_code, '')
      FROM cfgPostalCode
      WHERE zip_code = @Zip

      SELECT TOP 1 @CompanyID = ISNULL(company_id, '')
      FROM HCMSkylineTest..oncd_company
      WHERE cst_center_number = CONVERT(Nchar(10), @CenterID)


      -- ONCD CONTACT.
	INSERT INTO HCMSkylineTest..oncd_contact ( contact_id, greeting, first_name, last_name, first_name_search, last_name_search, do_not_solicit, cst_do_not_call, cst_do_not_email, cst_do_not_mail, cst_language_code, cst_promotion_code, cst_age_range_code, cst_hair_loss_code, created_by_user_code, creation_date, updated_by_user_code, updated_date, contact_status_code, duplicate_check, status_updated_date, cst_gender_code, status_updated_by_user_code)
		VALUES (@ContactID, @FirstName, @FirstName, @LastName, UPPER(@FirstName), UPPER(@LastName), 'N', 'N', 'N', 'N', 'ENGLISH', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', @CenterID, GETDATE(), @CenterID, GETDATE(), 'LEAD', 'Y', GETDATE(), @Gender, @CenterID)

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
       END

      -- ONCD CONTACT COMPANY.
      INSERT  intO HCMSkylineTest..oncd_contact_company (contact_company_id, contact_id, company_id, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date)
            VALUES (@ContactCompanyID, @ContactID, @CompanyID, 'Y', 0, @CenterID, GETDATE(), @CenterID, GETDATE())

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END

      -- ONCD CONTACT EMAIL.
      INSERT  intO HCMSkylineTest..oncd_contact_email (contact_email_id, contact_id, email, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date, active, email_type_code)
            VALUES (@ContactEmailID, @ContactID, @EmailAddress, 'Y', 0, @CenterID, GETDATE(), @CenterID, GETDATE(), 'Y', 'HOME')

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END

      -- ONCD CONTACT PHONE.
      INSERT  intO HCMSkylineTest..oncd_contact_phone (contact_phone_id, contact_id, area_code, phone_number, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date, active, phone_type_code)
            VALUES (@ContactPhoneID, @ContactID, @AreaCode, @PhoneNumber, 'Y', 0, @CenterID, GETDATE(), @CenterID, GETDATE(), 'Y', 'HOME')

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END

      -- ONCD CONTACT ADDRESS.
      INSERT  intO HCMSkylineTest..oncd_contact_address (contact_address_id, contact_id, address_line_1, address_line_2, city, state_code, zip_code, county_code, country_code, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date, address_type_code)
            VALUES (@ContactAddressID, @ContactID, @AddressLine1, @AddressLine2, @City, @State, @Zip, NULL, @Country, 'Y', 0, @CenterID, GETDATE(), @CenterID, GETDATE(), 'HOME')

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END

      -- ONCD CONTACT SOURCE.
      INSERT  intO HCMSkylineTest..oncd_contact_source (contact_source_id, contact_id, source_code, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date)
            VALUES (@ContactSourceID, @ContactID, @Source, 'Y', 0, @CenterID, GETDATE(), @CenterID, GETDATE())

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END

COMMIT TRANSACTION

--SELECT CONVERT(varchar(25), @ContactID) AS ContactID

--SELECT contact_id, greeting, first_name, last_name, first_name_search, last_name_search, do_not_solicit, cst_do_not_call, cst_language_code, cst_promotion_code, cst_age_range_code, cst_hair_loss_code, created_by_user_code, creation_date, updated_by_user_code, updated_date, contact_status_code, duplicate_check, status_updated_date, cst_gender_code, status_updated_by_user_code
--FROM HCMSkylineTest..oncd_contact
--WHERE contact_id = @ContactID
GO
