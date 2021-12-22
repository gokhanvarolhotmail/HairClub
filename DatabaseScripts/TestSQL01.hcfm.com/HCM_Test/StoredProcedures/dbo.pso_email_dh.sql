/* CreateDate: 06/25/2012 10:27:04.780 , ModifyDate: 06/25/2012 10:40:05.670 */
GO
-- =============================================
-- Create date: 14 June 2012
-- Description:	Selects data from cstv_email_dh
-- =============================================
CREATE PROCEDURE [dbo].[pso_email_dh]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT
RTRIM(ISNULL(contact_contact_id,'')) AS [contact_contact_id],
CONVERT(nvarchar(8), contact_creation_date, 1) AS [contact_creation_date],
RTRIM(ISNULL(contact_first_name,'')) AS [contact_first_name],
RTRIM(ISNULL(contact_last_name,'')) AS [contact_last_name],
RTRIM(ISNULL(contact_gender_code,'')) AS [contact_gender_code],
CONVERT(nvarchar(8), activity_demographic_birthday, 1) AS [activity_demographic_birthday],
RTRIM(ISNULL(contact_source_source_code,'')) AS [contact_source_source_code],
RTRIM(ISNULL(contact_contact_status_code,'')) AS [contact_contact_status_code],
CONVERT(nvarchar(8), contact_dnc_date, 1) AS [contact_dnc_date],
RTRIM(ISNULL(contact_do_not_call,'')) AS [contact_do_not_call],
RTRIM(ISNULL(contact_do_not_email,'')) AS [contact_do_not_email],
RTRIM(ISNULL(contact_do_not_mail,'')) AS [contact_do_not_mail],
RTRIM(ISNULL(contact_language_code,'')) AS [contact_language_code],
RTRIM(ISNULL(contact_promotion_code,'')) AS [contact_promotion_code],
RTRIM(ISNULL(contact_do_not_solicit,'')) AS [contact_do_not_solicit],
RTRIM(ISNULL(contact_hair_loss_code,'')) AS [contact_hair_loss_code],
RTRIM(ISNULL(contact_hair_loss_experience_code,'')) AS [contact_hair_loss_experience_code],
RTRIM(ISNULL(contact_hair_loss_in_family_code,'')) AS [contact_hair_loss_in_family_code],
RTRIM(ISNULL(contact_hair_loss_family_code,'')) AS [contact_hair_loss_family_code],
RTRIM(ISNULL(contact_hair_loss_product,'')) AS [contact_hair_loss_product],
RTRIM(ISNULL(contact_hair_loss_spot_code,'')) AS [contact_hair_loss_spot_code],
RTRIM(ISNULL(contact_surgery_consultation_flag,'')) AS [contact_surgery_consultation_flag],
RTRIM(ISNULL(activity_demographic_no_sale_reason,'')) AS [activity_demographic_no_sale_reason],
RTRIM(ISNULL(activity_demographic_disc_style,'')) AS [activity_demographic_disc_style],
RTRIM(ISNULL(activity_demographic_price_quoted,'')) AS [activity_demographic_price_quoted],
RTRIM(ISNULL(contact_completion_sale_type_description,'')) AS [contact_completion_sale_type_description],
RTRIM(ISNULL(contact_age,'')) AS [contact_age],
RTRIM(ISNULL(contact_email_email,'')) AS [contact_email_email],
RTRIM(ISNULL(contact_age_range_code,'')) AS [contact_age_range_code],
RTRIM(ISNULL(contact_address_time_zone_code,'')) AS [contact_address_time_zone_code],
RTRIM(ISNULL(company_center_number,'')) AS [company_center_number],
RTRIM(ISNULL(company_company_name_1,'')) AS [company_company_name_1],
RTRIM(ISNULL(company_company_map_link,'')) AS [company_company_map_link],
RTRIM(ISNULL(company_address_address_line_1,'')) AS [company_address_address_line_1],
RTRIM(ISNULL(company_address_address_line_2,'')) AS [company_address_address_line_2],
RTRIM(ISNULL(company_address_city,'')) AS [company_address_city],
RTRIM(ISNULL(company_address_state_code,'')) AS [company_address_state_code],
RTRIM(ISNULL(company_address_zip_code,'')) AS [company_address_zip_code],
RTRIM(ISNULL(company_address_country_code,'')) AS [company_address_country_code],
RTRIM(ISNULL(appointment_activity_activity_id,'')) AS [appointment_activity_activity_id],
CONVERT(nvarchar(8), appointment_activity_creation_date, 1) AS [appointment_activity_creation_date],
CONVERT(nvarchar(8), appointment_activity_completion_date, 1) AS [appointment_activity_completion_date],
CONVERT(nvarchar(8), appointment_activity_due_date, 1) AS [appointment_activity_due_date],
REPLACE(REPLACE(LTRIM(RIGHT(RTRIM(CONVERT(nvarchar(30), appointment_activity_start_time, 100)),7)),'AM', ' AM'), 'PM', ' PM') AS [appointment_activity_start_time],
RTRIM(ISNULL(appointment_activity_result_code,'')) AS [appointment_activity_result_code],
RTRIM(ISNULL(appointment_activity_source_code,'')) AS [appointment_activity_source_code],
REPLACE(REPLACE(LTRIM(RIGHT(RTRIM(CONVERT(nvarchar(30), appointment_activity_completion_time, 100)),7)),'AM', ' AM'), 'PM', ' PM') AS [appointment_activity_completion_time],
RTRIM(ISNULL(brochure_activity_activity_id,'')) AS [brochure_activity_activity_id],
CONVERT(nvarchar(8), brochure_activity_creation_date, 1) AS [brochure_activity_creation_date],
CONVERT(nvarchar(8), brochure_activity_completion_date, 1) AS [brochure_activity_completion_date],
CONVERT(nvarchar(8), brochure_activity_due_date, 1) AS [brochure_activity_due_date],
REPLACE(REPLACE(LTRIM(RIGHT(RTRIM(CONVERT(nvarchar(30), brochure_activity_start_time, 100)),7)),'AM', ' AM'), 'PM', ' PM') AS [brochure_activity_start_time],
RTRIM(ISNULL(brochure_activity_result_code,'')) AS [brochure_activity_result_code],
RTRIM(ISNULL(brochure_activity_source_code,'')) AS [brochure_activity_source_code],
REPLACE(REPLACE(LTRIM(RIGHT(RTRIM(CONVERT(nvarchar(30), brochure_activity_completion_time, 100)),7)),'AM', ' AM'), 'PM', ' PM') AS [brochure_activity_completion_time],
RTRIM(ISNULL(activity_demographic_ludwig,'')) AS [activity_demographic_ludwig],
RTRIM(ISNULL(activity_demographic_norwood,'')) AS [activity_demographic_norwood],
RTRIM(ISNULL(activity_demographic_solution_offered,'')) AS [activity_demographic_solution_offered],
RTRIM(ISNULL(activity_demographic_ethnicity_code,'')) AS [activity_demographic_ethnicity_code],
RTRIM(ISNULL(activity_demographic_occupation_code,'')) AS [activity_demographic_occupation_code],
RTRIM(ISNULL(activity_demographic_maritalstatus_code,'')) AS [activity_demographic_maritalstatus_code]
FROM cstd_email_dh_flat WITH (NOLOCK)

END
GO
