/* CreateDate: 11/13/2017 15:01:13.637 , ModifyDate: 11/13/2017 15:01:13.637 */
GO
/*
==============================================================================
PROCEDURE:				oncd_contact_salesforce_leads

AUTHOR: 				Daniel Polania

IMPLEMENTOR: 			Daniel Polania

DATE IMPLEMENTED: 		10/13/2017


==============================================================================
DESCRIPTION:	Reads data from the Batch Lead table to load Leads to SFDC
==============================================================================
NOTES:
		* 11/13/2017 DP - Created proc

==============================================================================
SAMPLE EXECUTION:
EXEC [dbo].[HCM_SFDC_LeadsNew]
==============================================================================
*/
CREATE PROCEDURE [dbo].[HCM_SFDC_LeadLoad]
AS
BEGIN

    SET NOCOUNT ON;

    SELECT HSBL.contact_id,
           HSBL.cst_gender_code,
           HSBL.first_name,
           HSBL.middle_name,
           HSBL.last_name,
           HSBL.cst_do_not_mail,
           HSBL.cst_do_not_text,
           HSBL.cst_do_not_call,
           HSBL.cst_do_not_email,
           HSBL.cst_hair_loss_experience_code,
           HSBL.cst_language_code,
           HSBL.salutation_code,
           HSBL.cst_hair_loss_product,
           HSBL.cst_hair_loss_spot_code,
           HSBL.cst_hair_loss_family_code,
           HSBL.suffix,
           HSBL.Address,
           HSBL.city,
           HSBL.zip_code,
           HSBL.state_code,
           HSBL.country_code,
           HSBL.Phone,
           HSBL.email,
           HSBL.contact_status_code,
           HSBL.cst_contact_accomodation_code,
           HSBL.cst_age,
           HSBL.Age_Range,
           HSBL.birthday,
           HSBL.cst_promotion_code,
           HSBL.source_code,
           HSBL.company_id,
           HSBL.cst_hair_loss_code,
           HSBL.zip_id,
           HSBL.OnCon_creation_date,
           HSBL.OnCon_Updated_date,
           HSBL.siebelid,
           HSBL.sessionid,
           HSBL.affiliateid,
           HSBL.processed,
		   HSBL.batch_date
    FROM dbo.HCM_SFDC_Batch_Lead AS HSBL
    WHERE HSBL.batch_processed = 0;

END;
GO
