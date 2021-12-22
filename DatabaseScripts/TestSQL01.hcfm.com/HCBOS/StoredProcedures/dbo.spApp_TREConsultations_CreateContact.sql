/* CreateDate: 09/22/2008 15:03:59.530 , ModifyDate: 01/25/2010 08:11:31.823 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_CreateContact
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			7/18/2008
-- Date Implemented:		7/18/2008
-- Date Last Modified:		7/18/2008
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	BOS
-- Related Application:		The Right Experience
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
--
-- 11/11/2009 - DL	--> Changed CountyCode being inserted into oncd_contact_address table to NULL
					--> as per OnContact's request to enforce referencial integrity.
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_CreateContact
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_CreateContact]
(
	@ContactID VARCHAR(50),
	@FirstName VARCHAR(50),
	@LastName VARCHAR(50),
	@CenterNumber INT,
	@Gender VARCHAR(50),
	@ContactCompanyID VARCHAR(50),
	@CompanyID VARCHAR(50),
	@ContactEmailID VARCHAR(50),
	@EmailAddress VARCHAR(100),
	@ContactPhoneID VARCHAR(50),
	@AreaCode VARCHAR(50),
	@PhoneNumber VARCHAR(50),
	@ContactAddressID VARCHAR(50),
	@AddressLine1 VARCHAR(100),
	@AddressLine2 VARCHAR(100),
	@City VARCHAR(50),
	@State VARCHAR(50),
	@Zip VARCHAR(50),
	@County VARCHAR(50),
	@Country VARCHAR(50),
	@ContactSourceID VARCHAR(50),
	@Source VARCHAR(50)
)
AS
BEGIN TRANSACTION

	-- ONCD CONTACT.
	INSERT  INTO [HCM].[dbo].[oncd_contact]
			(
			 [contact_id]
			,[greeting]
			,[first_name]
			,[last_name]
			,[first_name_search]
			,[last_name_search]
			,[do_not_solicit]
			,[cst_do_not_call]
			,[cst_language_code]
			,[cst_promotion_code]
			,[cst_age_range_code]
			,[cst_hair_loss_code]
			,[created_by_user_code]
			,[creation_date]
			,[updated_by_user_code]
			,[updated_date]
			,[contact_status_code]
			,[duplicate_check]
			,[status_updated_date]
			,[cst_gender_code]
			)
	VALUES  (
			 @ContactID
			,@FirstName
			,@FirstName
			,@LastName
			,UPPER(@FirstName)
			,UPPER(@LastName)
			,'N'
			,'N'
			,'ENGLISH'
			,'UNKNOWN'
			,'UNKNOWN'
			,'UNKNOWN'
			,@CenterNumber
			,GETDATE()
			,@CenterNumber
			,GETDATE()
			,'LEAD'
			,'Y'
			,GETDATE()
			,@Gender)

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

	-- ONCD CONTACT COMPANY.
	INSERT  INTO [HCM].[dbo].[oncd_contact_company]
			(
			 [contact_company_id]
			,[contact_id]
			,[company_id]
			,[primary_flag]
			,[sort_order]
			,[created_by_user_code]
			,[creation_date]
			,[updated_by_user_code]
			,[updated_date]
			)
	VALUES  (
			 @ContactCompanyID
			,@ContactID
			,@CompanyID
			,'Y'
			,0
			,@CenterNumber
			,GETDATE()
			,@CenterNumber
			,GETDATE())

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

	-- ONCD CONTACT EMAIL.
	INSERT  INTO [HCM].[dbo].[oncd_contact_email]
			(
			 [contact_email_id]
			,[contact_id]
			,[email]
			,[primary_flag]
			,[sort_order]
			,[created_by_user_code]
			,[creation_date]
			,[updated_by_user_code]
			,[updated_date]
			,[active]
			,[email_type_code]
			)
	VALUES  (
			 @ContactEmailID
			,@ContactID
			,@EmailAddress
			,'Y'
			,0
			,@CenterNumber
			,GETDATE()
			,@CenterNumber
			,GETDATE()
			,'Y'
			,'HOME')

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

	-- ONCD CONTACT PHONE.
	INSERT  INTO [HCM].[dbo].[oncd_contact_phone]
			(
			 [contact_phone_id]
			,[contact_id]
			,[area_code]
			,[phone_number]
			,[primary_flag]
			,[sort_order]
			,[created_by_user_code]
			,[creation_date]
			,[updated_by_user_code]
			,[updated_date]
			,[active]
			,[phone_type_code]
			)
	VALUES  (
			 @ContactPhoneID
			,@ContactID
			,@AreaCode
			,@PhoneNumber
			,'Y'
			,0
			,@CenterNumber
			,GETDATE()
			,@CenterNumber
			,GETDATE()
			,'Y'
			,'HOME')

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

	-- ONCD CONTACT ADDRESS.
	INSERT  INTO [HCM].[dbo].[oncd_contact_address]
			(
			 [contact_address_id]
			,[contact_id]
			,[address_line_1]
			,[address_line_2]
			,[city]
			,[state_code]
			,[zip_code]
			,[county_code]
			,[country_code]
			,[primary_flag]
			,[sort_order]
			,[created_by_user_code]
			,[creation_date]
			,[updated_by_user_code]
			,[updated_date]
			,[address_type_code]
			)
	VALUES  (
			 @ContactAddressID
			,@ContactID
			,@AddressLine1
			,@AddressLine2
			,@City
			,@State
			,@Zip
			,NULL
			,@Country
			,'Y'
			,0
			,@CenterNumber
			,GETDATE()
			,@CenterNumber
			,GETDATE()
			,'HOME')

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

	-- ONCD CONTACT SOURCE.
	INSERT  INTO [HCM].[dbo].[oncd_contact_source]
			(
			 [contact_source_id]
			,[contact_id]
			,[source_code]
			,[primary_flag]
			,[sort_order]
			,[created_by_user_code]
			,[creation_date]
			,[updated_by_user_code]
			,[updated_date]
			)
	VALUES  (
			 @ContactSourceID
			,@ContactID
			,@Source
			,'Y'
			,0
			,@CenterNumber
			,GETDATE()
			,@CenterNumber
			,GETDATE())

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
