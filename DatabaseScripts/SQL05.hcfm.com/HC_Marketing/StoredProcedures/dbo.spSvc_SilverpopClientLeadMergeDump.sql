/* CreateDate: 01/10/2017 09:48:12.470 , ModifyDate: 07/07/2017 15:07:42.013 */
GO
/***********************************************************************
PROCEDURE:				spSvc_SilverpopClientLeadMergeDump
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APPLICATION:	Silverpop Export
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/16/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_SilverpopClientLeadMergeDump 2874
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_SilverpopClientLeadMergeDump]
(
	@ExportHeaderID INT
)
AS
BEGIN


CREATE TABLE #ClientLeadJoin (
	LeadID NVARCHAR(255)
,	ClientIdentifier INT
)


INSERT	INTO #ClientLeadJoin
		SELECT	CE.LeadID
		,		MAX(CE.ClientIdentifier) AS 'ClientIdentifier'
		FROM    datClientExport CE
		GROUP BY CE.LeadID


-- Update lead records, that are already in the Merge table, with updated lead information
UPDATE	MD
SET		MD.ExportHeaderID = @ExportHeaderID
,		MD.RegionID = LE.company_center_region_number
,		MD.RegionName = LE.company_center_region_name
,       MD.CenterID = LE.company_center_number
,       MD.CenterName = LE.company_company_name
,       MD.CenterType = LE.company_center_type
,       MD.CenterAddress1 = LE.company_address_line_1
,       MD.CenterAddress2 = LE.company_address_line_2
,       MD.CenterCity = LE.company_city
,       MD.CenterStateCode = LE.company_state_code
,       MD.CenterZipCode = LE.company_zip_code
,       MD.CenterCountry = LE.company_country_code
,       MD.CenterPhoneNumber = LE.company_center_phone_number
,       MD.CenterManagingDirector = LE.company_center_managing_director
,       MD.CenterManagingDirectorEmail = LE.company_center_managing_director_email
,       MD.LeadID = LE.contact_contact_id
,       MD.FirstName = LE.contact_first_name
,       MD.LastName = LE.contact_last_name
,		MD.LeadAddressID = LE.contact_address_address_id
,       MD.Address1 = LE.contact_address_address_line_1
,       MD.Address2 = LE.contact_address_address_line_2
,       MD.City = LE.contact_address_city
,       MD.StateCode = LE.contact_address_state_code
,       MD.ZipCode = LE.contact_address_zip_code
,       MD.Country = LE.contact_address_country_code
,       MD.Timezone = LE.contact_address_time_zone_code
,       MD.EmailAddress = LE.contact_email_email
,       MD.Gender = LE.contact_gender_code
,       MD.Age = LE.contact_age
,       MD.AgeRange = ISNULL(LE.contact_age_range, '')
,       MD.[Language] = ISNULL(LE.contact_language_code, '')
,       MD.SiebelID = LE.contact_contact_siebel_id
,       MD.Phone1 = LE.contact_phone_phone_number
,       MD.DNCDate = CASE WHEN LE.contact_dnc_date IS NULL THEN '' ELSE CONVERT(VARCHAR(11), LE.contact_dnc_date, 101) END
,       MD.HairLossCode = REPLACE(ISNULL(LE.contact_hair_loss_code, ''), ',', '')
,       MD.HairLossExperienceCode = REPLACE(ISNULL(LE.contact_hair_loss_experience_code, ''), ',', '')
,       MD.HairLossFamilyCode = REPLACE(ISNULL(LE.contact_hair_loss_family_code, ''), ',', '')
,       MD.HairLossInFamilyCode = REPLACE(ISNULL(LE.contact_hair_loss_in_family_code, ''), ',', '')
,       MD.HairLossProduct = REPLACE(ISNULL(LE.contact_hair_loss_product, ''), ',', '')
,       MD.HairLossSpotCode = REPLACE(ISNULL(LE.contact_hair_loss_spot_code, ''), ',', '')
,       MD.PromotionCode = REPLACE(ISNULL(LE.contact_promotion_code, ''), ',', '')
,       MD.SourceCode = REPLACE(ISNULL(LE.contact_source_source_code, ''), ',', '')
,       MD.SourceMedia = REPLACE(ISNULL(LE.contact_source_source_media, ''), ',', '')
,       MD.SourceFormat = REPLACE(ISNULL(LE.contact_source_source_format, ''), ',', '')
,       MD.MarketingScore = REPLACE(ISNULL(LE.contact_marketing_score, ''), ',', '')
,       MD.DiscStyle = REPLACE(ISNULL(LE.activity_demographic_disc_style, ''), ',', '')
,       MD.Ethnicity = REPLACE(ISNULL(LE.activity_demographic_ethnicity, ''), ',', '')
,       MD.LudwigCode = REPLACE(ISNULL(LE.activity_demographic_ludwig, ''), ',', '')
,       MD.MaritalStatus = REPLACE(ISNULL(LE.activity_demographic_maritalstatus, ''), ',', '')
,       MD.NoSaleReason = REPLACE(ISNULL(LE.activity_demographic_no_sale_reason, ''), ',', '')
,       MD.NorwoodCode = REPLACE(ISNULL(LE.activity_demographic_norwood, ''), ',', '')
,       MD.Occupation = REPLACE(ISNULL(LE.activity_demographic_occupation, ''), ',', '')
,       MD.PriceQuoted = ISNULL(LE.activity_demographic_price_quoted, 0)
,       MD.SolutionOffered = REPLACE(ISNULL(LE.activity_demographic_solution_offered, ''), ',', '')
,       MD.Performer = REPLACE(ISNULL(LE.activity_demographic_performer, ''), ',', '')
,       MD.PerformerName = REPLACE(ISNULL(LE.activity_demographic_performer_name, ''), ',', '')
,       MD.PerformerEmail = REPLACE(ISNULL(LE.activity_demographic_performer_email, ''), ',', '')
,       MD.SaleType = REPLACE(ISNULL(LE.contact_completion_sale_type_description, ''), ',', '')
,       MD.CanConfirmConsultationByText = ISNULL(LE.can_confirm_appointment_by_text, '')
,       MD.ActivityCreationDate = CASE WHEN LE.appointment_activity_creation_date IS NULL THEN '' ELSE CONVERT(VARCHAR(11), LE.appointment_activity_creation_date, 101) END
,       MD.ActivityActionCode = ISNULL(LE.appointment_activity_action_code, '')
,       MD.ActivityResultCode = ISNULL(LE.appointment_activity_result_code, '')
,       MD.ActivitySourceCode = ISNULL(LE.appointment_activity_source_code, '')
,       MD.ActivityDueDate = CASE WHEN LE.appointment_activity_due_date IS NULL THEN '' ELSE CONVERT(VARCHAR(11), LE.appointment_activity_due_date, 101) END
,       MD.ActivityStartTime = CASE WHEN LE.appointment_activity_start_time IS NULL THEN '' ELSE LE.appointment_activity_start_time END
,       MD.ActivityCompletionDate = CASE WHEN LE.appointment_activity_completion_date IS NULL THEN '' ELSE LE.appointment_activity_completion_date END
,       MD.ActivityCompletionTime = CASE WHEN LE.appointment_activity_completion_time IS NULL THEN '' ELSE LE.appointment_activity_completion_time END
,       MD.BrochureCreationDate = CASE WHEN LE.brochure_activity_creation_date IS NULL THEN '' ELSE LE.brochure_activity_creation_date END
,       MD.BrochureActionCode = ISNULL(LE.brochure_activity_action_code, '')
,       MD.BrochureResultCode = ISNULL(LE.brochure_activity_result_code, '')
,       MD.BrochureSourceCode = ISNULL(LE.brochure_activity_source_code, '')
,       MD.BrochureDueDate = CASE WHEN LE.brochure_activity_due_date IS NULL THEN '' ELSE LE.brochure_activity_due_date END
,       MD.BrochureStartTime = CASE WHEN LE.brochure_activity_start_time IS NULL THEN '' ELSE LE.brochure_activity_start_time END
,       MD.BrochureCompletionDate = CASE WHEN LE.brochure_activity_completion_date IS NULL THEN '' ELSE LE.brochure_activity_completion_date END
,       MD.BrochureCompletionTime = CASE WHEN LE.brochure_activity_completion_time IS NULL THEN '' ELSE LE.brochure_activity_completion_time END
,       MD.Mosaic_Household = LE.Mosaic_Household
,       MD.Mosaic_Household_Group = LE.Mosaic_Household_Group
,       MD.Mosaic_Household_Type = LE.Mosaic_Household_Type
,       MD.Mosaic_Zip = LE.Mosaic_Zip
,       MD.Mosaic_Zip_Group = LE.Mosaic_Zip_Group
,       MD.Mosaic_Zip_Type = LE.Mosaic_Zip_Type
,       MD.Mosaic_Gender = LE.Mosaic_Gender
,       MD.Mosaic_Combined_Age = LE.Mosaic_Combined_Age
,       MD.Mosaic_Education_Model = LE.Mosaic_Education_Model
,       MD.Mosaic_Marital_Status = LE.Mosaic_Marital_Status
,       MD.Mosaic_Occupation_Group_V2 = LE.Mosaic_Occupation_Group_V2
,       MD.Mosaic_Latitude = LE.Mosaic_Latitude
,       MD.Mosaic_Longitude = LE.Mosaic_Longitude
,       MD.Mosaic_Match_Level_For_Geo_Data = LE.Mosaic_Match_Level_For_Geo_Data
,       MD.Mosaic_Est_Household_Income_V5 = LE.Mosaic_Est_Household_Income_V5
,       MD.Mosaic_NCOA_Move_Update_Code = LE.Mosaic_NCOA_Move_Update_Code
,       MD.Mosaic_Mail_Responder = LE.Mosaic_Mail_Responder
,       MD.Mosaic_MOR_Bank_Upscale_Merchandise_Buyer = LE.Mosaic_MOR_Bank_Upscale_Merchandise_Buyer
,       MD.Mosaic_MOR_Bank_Health_And_Fitness_Magazine = LE.Mosaic_MOR_Bank_Health_And_Fitness_Magazine
,       MD.Mosaic_Cape_Ethnic_Pop_White_Only = LE.Mosaic_Cape_Ethnic_Pop_White_Only
,       MD.Mosaic_Cape_Ethnic_Pop_Black_Only = LE.Mosaic_Cape_Ethnic_Pop_Black_Only
,       MD.Mosaic_Cape_Ethnic_Pop_Asian_Only = LE.Mosaic_Cape_Ethnic_Pop_Asian_Only
,       MD.Mosaic_Cape_Ethnic_Pop_Hispanic = LE.Mosaic_Cape_Ethnic_Pop_Hispanic
,       MD.Mosaic_Cape_Lang_HH_Spanish_Speaking = LE.Mosaic_Cape_Lang_HH_Spanish_Speaking
,       MD.Mosaic_Cape_INC_HH_Median_Family_Household_Income = LE.Mosaic_Cape_INC_HH_Median_Family_Household_Income
,       MD.Mosaic_MatchStatus = LE.Mosaic_MatchStatus
,       MD.Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code = LE.Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code
,       MD.Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code = LE.Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code
,       MD.Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code = LE.Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code
,       MD.DoNotText = CASE LE.contact_do_not_text WHEN 'Y' THEN 1 ELSE 0 END
,       MD.DoNotEmail = CASE LE.contact_do_not_email WHEN 'Y' THEN 1 ELSE 0 END
,       MD.DoNotMail = CASE LE.contact_do_not_mail WHEN 'Y' THEN 1 ELSE 0 END
,       MD.DoNotSolicit = CASE LE.contact_do_not_solicit WHEN 'Y' THEN 1 ELSE 0 END
,       MD.LeadLastUpdate = LE.LastUpdate
,		MD.LastUpdate = GETDATE()
FROM    datClientLeadMerge MD
		INNER JOIN datLeadExport LE
			ON LE.contact_contact_id = MD.LeadID
WHERE   LE.ExportHeaderID = @ExportHeaderID


-- Insert lead records, that are not already there, into the Merge table
INSERT	INTO datClientLeadMerge (
			ExportHeaderID
        ,	RegionID
        ,	RegionName
        ,	CenterID
        ,	CenterName
        ,	CenterType
        ,	CenterAddress1
        ,	CenterAddress2
        ,	CenterCity
        ,	CenterStateCode
        ,	CenterZipCode
        ,	CenterCountry
        ,	CenterPhoneNumber
        ,	CenterManagingDirector
        ,	CenterManagingDirectorEmail
        ,	ClientIdentifier
        ,	LeadID
        ,	FirstName
        ,	LastName
		,	LeadAddressID
        ,	Address1
        ,	Address2
        ,	City
        ,	StateCode
        ,	ZipCode
        ,	Country
        ,	Timezone
        ,	EmailAddress
        ,	Gender
        ,	Age
        ,	AgeRange
        ,	Language
        ,	SiebelID
        ,	Phone1
        ,	DNCDate
        ,	HairLossCode
        ,	HairLossExperienceCode
        ,	HairLossFamilyCode
        ,	HairLossInFamilyCode
        ,	HairLossProduct
        ,	HairLossSpotCode
        ,	PromotionCode
        ,	SourceCode
        ,	SourceMedia
        ,	SourceFormat
        ,	MarketingScore
        ,	DiscStyle
        ,	Ethnicity
        ,	LudwigCode
        ,	MaritalStatus
        ,	NoSaleReason
        ,	NorwoodCode
        ,	Occupation
        ,	PriceQuoted
        ,	SolutionOffered
        ,	Performer
        ,	PerformerName
        ,	PerformerEmail
        ,	SaleType
		,	CanConfirmConsultationByText
        ,	ActivityCreationDate
        ,	ActivityActionCode
        ,	ActivityResultCode
        ,	ActivitySourceCode
        ,	ActivityDueDate
        ,	ActivityStartTime
        ,	ActivityCompletionDate
        ,	ActivityCompletionTime
        ,	BrochureCreationDate
        ,	BrochureActionCode
        ,	BrochureResultCode
        ,	BrochureSourceCode
        ,	BrochureDueDate
        ,	BrochureStartTime
        ,	BrochureCompletionDate
        ,	BrochureCompletionTime
        ,	Mosaic_Household
        ,	Mosaic_Household_Group
        ,	Mosaic_Household_Type
        ,	Mosaic_Zip
        ,	Mosaic_Zip_Group
        ,	Mosaic_Zip_Type
        ,	Mosaic_Gender
        ,	Mosaic_Combined_Age
        ,	Mosaic_Education_Model
        ,	Mosaic_Marital_Status
        ,	Mosaic_Occupation_Group_V2
        ,	Mosaic_Latitude
        ,	Mosaic_Longitude
        ,	Mosaic_Match_Level_For_Geo_Data
        ,	Mosaic_Est_Household_Income_V5
        ,	Mosaic_NCOA_Move_Update_Code
        ,	Mosaic_Mail_Responder
        ,	Mosaic_MOR_Bank_Upscale_Merchandise_Buyer
        ,	Mosaic_MOR_Bank_Health_And_Fitness_Magazine
        ,	Mosaic_Cape_Ethnic_Pop_White_Only
        ,	Mosaic_Cape_Ethnic_Pop_Black_Only
        ,	Mosaic_Cape_Ethnic_Pop_Asian_Only
        ,	Mosaic_Cape_Ethnic_Pop_Hispanic
        ,	Mosaic_Cape_Lang_HH_Spanish_Speaking
        ,	Mosaic_Cape_INC_HH_Median_Family_Household_Income
        ,	Mosaic_MatchStatus
        ,	Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code
        ,	Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code
        ,	Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code
        ,	DoNotText
        ,	DoNotEmail
        ,	DoNotMail
        ,	DoNotSolicit
        ,	RecordStatus
        ,	LeadCreateDate
        ,	CreateUser
        ,	LeadLastUpdate
        ,	LastUpdateUser
		)
		SELECT	@ExportHeaderID
		,		LE.company_center_region_number AS 'RegionID'
		,       LE.company_center_region_name AS 'RegionName'
		,       LE.company_center_number AS 'CenterID'
		,       LE.company_company_name AS 'CenterName'
		,       LE.company_center_type AS 'CenterType'
		,       LE.company_address_line_1 AS 'CenterAddress1'
		,       LE.company_address_line_2 AS 'CenterAddress2'
		,       LE.company_city AS 'CenterCity'
		,       LE.company_state_code AS 'CenterStateCode'
		,       LE.company_zip_code AS 'CenterZipCode'
		,       LE.company_country_code AS 'CenterCountry'
		,       LE.company_center_phone_number AS 'CenterPhoneNumber'
		,       LE.company_center_managing_director AS 'CenterManagingDirector'
		,       LE.company_center_managing_director_email AS 'CenterManagingDirectorEmail'
		,       0 AS 'ClientIdentifier'
		,       LE.contact_contact_id AS 'LeadID'
		,       LE.contact_first_name AS 'FirstName'
		,       LE.contact_last_name AS 'LastName'
		,		LE.contact_address_address_id
		,       LE.contact_address_address_line_1 AS 'Address1'
		,       LE.contact_address_address_line_2 AS 'Address2'
		,       LE.contact_address_city AS 'City'
		,       LE.contact_address_state_code AS 'State'
		,       LE.contact_address_zip_code AS 'ZipCode'
		,       LE.contact_address_country_code AS 'Country'
		,       LE.contact_address_time_zone_code AS 'TimeZone'
		,       LE.contact_email_email AS 'EmailAddress'
		,       LE.contact_gender_code AS 'Gender'
		,       LE.contact_age AS 'Age'
		,       LE.contact_age_range AS 'AgeRange'
		,       LE.contact_language_code AS 'Language'
		,       LE.contact_contact_siebel_id AS 'SiebelID'
		,       LE.contact_phone_phone_number AS 'Phone1'
		,       CASE WHEN LE.contact_dnc_date IS NULL THEN '' ELSE CONVERT(VARCHAR(11), LE.contact_dnc_date, 101) END AS 'DNCDate'
		,       REPLACE(ISNULL(LE.contact_hair_loss_code, ''), ',', '') AS 'HairLossCode'
		,       REPLACE(ISNULL(LE.contact_hair_loss_experience_code, ''), ',', '') AS 'HairLossExperienceCode'
		,       REPLACE(ISNULL(LE.contact_hair_loss_family_code, ''), ',', '') AS 'HairLossFamilyCode'
		,       REPLACE(ISNULL(LE.contact_hair_loss_in_family_code, ''), ',', '') AS 'HairLossInFamilyCode'
		,       REPLACE(ISNULL(LE.contact_hair_loss_product, ''), ',', '') AS 'HairLossProduct'
		,       REPLACE(ISNULL(LE.contact_hair_loss_spot_code, ''), ',', '') AS 'HairLossSpotCode'
		,       REPLACE(ISNULL(LE.contact_promotion_code, ''), ',', '') AS 'PromotionCode'
		,       REPLACE(ISNULL(LE.contact_source_source_code, ''), ',', '') AS 'SourceCode'
		,       REPLACE(ISNULL(LE.contact_source_source_media, ''), ',', '') AS 'SourceMedia'
		,       REPLACE(ISNULL(LE.contact_source_source_format, ''), ',', '') AS 'SourceFormat'
		,       REPLACE(ISNULL(LE.contact_marketing_score, ''), ',', '') AS 'MarketingScore'
		,       REPLACE(ISNULL(LE.activity_demographic_disc_style, ''), ',', '') AS 'DiscStyle'
		,       REPLACE(ISNULL(LE.activity_demographic_ethnicity, ''), ',', '') AS 'Ethnicity'
		,       REPLACE(ISNULL(LE.activity_demographic_ludwig, ''), ',', '') AS 'LudwigCode'
		,       REPLACE(ISNULL(LE.activity_demographic_maritalstatus, ''), ',', '') AS 'MaritalStatus'
		,       REPLACE(ISNULL(LE.activity_demographic_no_sale_reason, ''), ',', '') AS 'NoSaleReason'
		,       REPLACE(ISNULL(LE.activity_demographic_norwood, ''), ',', '') AS 'NorwoodCode'
		,       REPLACE(ISNULL(LE.activity_demographic_occupation, ''), ',', '') AS 'Occupation'
		,       ISNULL(LE.activity_demographic_price_quoted, 0) AS 'PriceQuoted'
		,       REPLACE(ISNULL(LE.activity_demographic_solution_offered, ''), ',', '') AS 'SolutionOffered'
		,       REPLACE(ISNULL(LE.activity_demographic_performer, ''), ',', '') AS 'Performer'
		,       REPLACE(ISNULL(LE.activity_demographic_performer_name, ''), ',', '') AS 'PerformerName'
		,       REPLACE(ISNULL(LE.activity_demographic_performer_email, ''), ',', '') AS 'PerformerEmail'
		,       REPLACE(ISNULL(LE.contact_completion_sale_type_description, ''), ',', '') AS 'SaleType'
		,		ISNULL(LE.can_confirm_appointment_by_text, '') AS 'CanConfirmAppointmentByText'
		,       CASE WHEN LE.appointment_activity_creation_date IS NULL THEN '' ELSE CONVERT(VARCHAR(11), LE.appointment_activity_creation_date, 101) END AS 'ActivityCreationDate'
		,       ISNULL(LE.appointment_activity_action_code, '') AS 'ActivityActionCode'
		,       ISNULL(LE.appointment_activity_result_code, '') AS 'ActivityResultCode'
		,       ISNULL(LE.appointment_activity_source_code, '') AS 'ActivitySourceCode'
		,       CASE WHEN LE.appointment_activity_due_date IS NULL THEN '' ELSE CONVERT(VARCHAR(11), LE.appointment_activity_due_date, 101) END AS 'ActivityDueDate'
		,       CASE WHEN LE.appointment_activity_start_time IS NULL THEN '' ELSE LE.appointment_activity_start_time END AS 'ActivityStartTime'
		,       CASE WHEN LE.appointment_activity_completion_date IS NULL THEN '' ELSE LE.appointment_activity_completion_date END AS 'ActivityCompletionDate'
		,       CASE WHEN LE.appointment_activity_completion_time IS NULL THEN '' ELSE LE.appointment_activity_completion_time END AS 'ActivityCompletionTime'
		,       CASE WHEN LE.brochure_activity_creation_date IS NULL THEN '' ELSE LE.brochure_activity_creation_date END AS 'BrochureActivityCreationDate'
		,       ISNULL(LE.brochure_activity_action_code, '') AS 'BrochureActivityActionCode'
		,       ISNULL(LE.brochure_activity_result_code, '') AS 'BrochureActivityResultCode'
		,       ISNULL(LE.brochure_activity_source_code, '') AS 'BrochureActivitySourceCode'
		,       CASE WHEN LE.brochure_activity_due_date IS NULL THEN '' ELSE LE.brochure_activity_due_date END AS 'BrochureActivityDueDate'
		,       CASE WHEN LE.brochure_activity_start_time IS NULL THEN '' ELSE LE.brochure_activity_start_time END AS 'BrochureActivityStartTime'
		,       CASE WHEN LE.brochure_activity_completion_date IS NULL THEN '' ELSE LE.brochure_activity_completion_date END AS 'BrochureActivityCompletionDate'
		,       CASE WHEN LE.brochure_activity_completion_time IS NULL THEN '' ELSE LE.brochure_activity_completion_time END AS 'BrochureActivityCompletionTime'
		,       LE.Mosaic_Household
		,       LE.Mosaic_Household_Group
		,       LE.Mosaic_Household_Type
		,       LE.Mosaic_Zip
		,       LE.Mosaic_Zip_Group
		,       LE.Mosaic_Zip_Type
		,       LE.Mosaic_Gender
		,       LE.Mosaic_Combined_Age
		,       LE.Mosaic_Education_Model
		,       LE.Mosaic_Marital_Status
		,       LE.Mosaic_Occupation_Group_V2
		,       LE.Mosaic_Latitude
		,       LE.Mosaic_Longitude
		,       LE.Mosaic_Match_Level_For_Geo_Data
		,       LE.Mosaic_Est_Household_Income_V5
		,       LE.Mosaic_NCOA_Move_Update_Code
		,       LE.Mosaic_Mail_Responder
		,       LE.Mosaic_MOR_Bank_Upscale_Merchandise_Buyer
		,       LE.Mosaic_MOR_Bank_Health_And_Fitness_Magazine
		,       LE.Mosaic_Cape_Ethnic_Pop_White_Only
		,       LE.Mosaic_Cape_Ethnic_Pop_Black_Only
		,       LE.Mosaic_Cape_Ethnic_Pop_Asian_Only
		,       LE.Mosaic_Cape_Ethnic_Pop_Hispanic
		,       LE.Mosaic_Cape_Lang_HH_Spanish_Speaking
		,       LE.Mosaic_Cape_INC_HH_Median_Family_Household_Income
		,       LE.Mosaic_MatchStatus
		,       LE.Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code
		,       LE.Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code
		,       LE.Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code
		,       CASE LE.contact_do_not_text WHEN 'Y' THEN 1 ELSE 0 END AS 'DoNotText'
		,       CASE LE.contact_do_not_email WHEN 'Y' THEN 1 ELSE 0 END AS 'DoNotEmail'
		,       CASE LE.contact_do_not_mail WHEN 'Y' THEN 1 ELSE 0 END AS 'DoNotMail'
		,       CASE LE.contact_do_not_solicit WHEN 'Y' THEN 1 ELSE 0 END AS 'DoNotSolicit'
		,		LE.contact_contact_status_code AS 'RecordStatus'
		,		LE.CreateDate AS 'CreateDate'
		,		'MD-Export' AS 'CreateUser'
		,		LE.LastUpdate AS 'LastUpdate'
		,		'MD-Export' AS 'LastUpdateUser'
		FROM    datLeadExport LE
				LEFT JOIN datClientLeadMerge MD
					ON MD.LeadID = LE.contact_contact_id
		WHERE   LE.ExportHeaderID = @ExportHeaderID
				AND MD.ClientLeadMergeID IS NULL


-- Update lead records, that are already in the Merge table, with client information
UPDATE	MD
SET		MD.ExportHeaderID = @ExportHeaderID
,		MD.RegionID = x_CE.RegionSSID
,		MD.RegionName = x_CE.RegionName
,       MD.CenterID = x_CE.CenterSSID
,       MD.CenterName = x_CE.CenterName
,       MD.CenterType = x_CE.CenterType
,       MD.CenterAddress1 = x_CE.CenterAddress1
,       MD.CenterAddress2 = x_CE.CenterAddress2
,       MD.CenterCity = x_CE.CenterCity
,       MD.CenterStateCode = x_CE.CenterStateCode
,       MD.CenterZipCode = x_CE.CenterZipCode
,       MD.CenterCountry = x_CE.CenterCountry
,       MD.CenterPhoneNumber = x_CE.CenterPhoneNumber
,       MD.CenterManagingDirector = x_CE.CenterManagingDirector
,       MD.CenterManagingDirectorEmail = x_CE.CenterManagingDirectorEmail
,       MD.ClientIdentifier = x_CE.ClientIdentifier
,       MD.FirstName = x_CE.ClientFirstName
,       MD.LastName = x_CE.ClientLastName
,       MD.Address1 = x_CE.ClientAddress1
,       MD.Address2 = x_CE.ClientAddress2
,       MD.City = x_CE.ClientCity
,       MD.StateCode = x_CE.ClientStateCode
,       MD.ZipCode = x_CE.ClientZipCode
,       MD.Country = x_CE.ClientCountry
,       MD.Timezone = x_CE.ClientTimezone
,       MD.EmailAddress = x_CE.ClientEmailAddress
,       MD.Gender = x_CE.ClientGender
,       MD.DateOfBirth = CASE WHEN CONVERT(VARCHAR(11), x_CE.ClientDateOfBirth, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.ClientDateOfBirth, 101) END
,       MD.Age = CASE WHEN CONVERT(VARCHAR, x_CE.ClientAge) = '0' THEN '' ELSE CONVERT(VARCHAR, x_CE.ClientAge) END
,       MD.SiebelID = x_CE.SiebelID
,       MD.Phone1 = x_CE.Phone1
,       MD.Phone1Type = x_CE.Phone1Type
,       MD.Phone2 = x_CE.Phone2
,       MD.Phone2Type = x_CE.Phone2Type
,       MD.Phone3 = x_CE.Phone3
,       MD.Phone3Type = x_CE.Phone3Type
,       MD.Ethnicity = REPLACE(ISNULL(x_CE.ClientEthinicityDescription, ''), ',', '')
,       MD.MaritalStatus = REPLACE(ISNULL(x_CE.ClientMaritalStatusDescription, ''), ',', '')
,       MD.Occupation = REPLACE(ISNULL(x_CE.ClientOccupationDescription, ''), ',', '')
,       MD.InitialSaleDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.InitialSaleDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.InitialSaleDate, 101) END
,       MD.NBConsultant = x_CE.NBConsultant
,       MD.NBConsultantName = x_CE.NBConsultantName
,       MD.NBConsultantEmail = x_CE.NBConsultantEmail
,       MD.InitialApplicationDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.InitialApplicationDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.InitialApplicationDate, 101) END
,       MD.ConversionDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.ConversionDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.ConversionDate, 101) END
,       MD.MembershipAdvisor = x_CE.MembershipAdvisor
,       MD.MembershipAdvisorName = x_CE.MembershipAdvisorName
,       MD.MembershipAdvisorEmail = x_CE.MembershipAdvisorEmail
,       MD.FirstAppointmentDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.FirstAppointmentDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.FirstAppointmentDate, 101) END
,       MD.LastAppointmentDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.LastAppointmentDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.LastAppointmentDate, 101) END
,       MD.NextAppointmentGUID = x_CE.NextAppointmentGUID
,       MD.NextAppointmentCenterID = x_CE.NextAppointmentCenterID
,       MD.NextAppointmentDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.NextAppointmentDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.NextAppointmentDate, 101) END
,		MD.NextAppointmentTime = CASE WHEN ISNULL(CONVERT(VARCHAR(15), CAST(x_CE.NextAppointmentTime AS TIME), 100), '') = '' OR x_CE.NextAppointmentTime = '1900-01-01 00:00:00.000' THEN '' ELSE CONVERT(VARCHAR(15), CAST(x_CE.NextAppointmentTime AS TIME), 100) END
,		MD.StylistFirstName = CASE WHEN x_CE.StylistFirstName IS NULL THEN '' ELSE x_CE.StylistFirstName END
,		MD.StylistLastName = CASE WHEN x_CE.StylistLastName IS NULL THEN '' ELSE x_CE.StylistLastName END
,       MD.FirstEXTServiceDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.FirstEXTServiceDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.FirstEXTServiceDate, 101) END
,       MD.FirstXtrandServiceDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.FirstXtrandServiceDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.FirstXtrandServiceDate, 101) END
,       MD.BIO_Membership = x_CE.BIO_Membership
,       MD.BIO_BeginDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.BIO_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.BIO_BeginDate, 101) END
,       MD.BIO_EndDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.BIO_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.BIO_EndDate, 101) END
,       MD.BIO_MembershipStatus = x_CE.BIO_MembershipStatus
,       MD.BIO_MonthlyFee = x_CE.BIO_MonthlyFee
,       MD.BIO_ContractPrice = x_CE.BIO_ContractPrice
,       MD.BIO_CancelDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.BIO_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.BIO_CancelDate, 101) END
,       MD.BIO_CancelReasonDescription = x_CE.BIO_CancelReasonDescription
,       MD.EXT_Membership = x_CE.EXT_Membership
,       MD.EXT_BeginDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.EXT_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.EXT_BeginDate, 101) END
,       MD.EXT_EndDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.EXT_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.EXT_EndDate, 101) END
,       MD.EXT_MembershipStatus = x_CE.EXT_MembershipStatus
,       MD.EXT_MonthlyFee = x_CE.EXT_MonthlyFee
,       MD.EXT_ContractPrice = x_CE.EXT_ContractPrice
,       MD.EXT_CancelDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.EXT_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.EXT_CancelDate, 101) END
,       MD.EXT_CancelReasonDescription = x_CE.EXT_CancelReasonDescription
,       MD.XTR_Membership = x_CE.XTR_Membership
,       MD.XTR_BeginDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.XTR_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.XTR_BeginDate, 101) END
,       MD.XTR_EndDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.XTR_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.XTR_EndDate, 101) END
,       MD.XTR_MembershipStatus = x_CE.XTR_MembershipStatus
,       MD.XTR_MonthlyFee = x_CE.XTR_MonthlyFee
,       MD.XTR_ContractPrice = x_CE.XTR_ContractPrice
,       MD.XTR_CancelDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.XTR_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.XTR_CancelDate, 101) END
,       MD.XTR_CancelReasonDescription = x_CE.XTR_CancelReasonDescription
,       MD.SUR_Membership = x_CE.SUR_Membership
,       MD.SUR_BeginDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.SUR_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.SUR_BeginDate, 101) END
,       MD.SUR_EndDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.SUR_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.SUR_EndDate, 101) END
,       MD.SUR_MembershipStatus = x_CE.SUR_MembershipStatus
,       MD.SUR_MonthlyFee = x_CE.SUR_MonthlyFee
,       MD.SUR_ContractPrice = x_CE.SUR_ContractPrice
,       MD.SUR_CancelDate = CASE WHEN CONVERT(VARCHAR(11), x_CE.SUR_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), x_CE.SUR_CancelDate, 101) END
,       MD.SUR_CancelReasonDescription = x_CE.SUR_CancelReasonDescription
,       MD.Mosaic_Household = x_CE.Mosaic_Household
,       MD.Mosaic_Household_Group = x_CE.Mosaic_Household_Group
,       MD.Mosaic_Household_Type = x_CE.Mosaic_Household_Type
,       MD.Mosaic_Zip = x_CE.Mosaic_Zip
,       MD.Mosaic_Zip_Group = x_CE.Mosaic_Zip_Group
,       MD.Mosaic_Zip_Type = x_CE.Mosaic_Zip_Type
,       MD.Mosaic_Gender = x_CE.Mosaic_Gender
,       MD.Mosaic_Combined_Age = x_CE.Mosaic_Combined_Age
,       MD.Mosaic_Education_Model = x_CE.Mosaic_Education_Model
,       MD.Mosaic_Marital_Status = x_CE.Mosaic_Marital_Status
,       MD.Mosaic_Occupation_Group_V2 = x_CE.Mosaic_Occupation_Group_V2
,       MD.Mosaic_Latitude = x_CE.Mosaic_Latitude
,       MD.Mosaic_Longitude = x_CE.Mosaic_Longitude
,       MD.Mosaic_Match_Level_For_Geo_Data = x_CE.Mosaic_Match_Level_For_Geo_Data
,       MD.Mosaic_Est_Household_Income_V5 = x_CE.Mosaic_Est_Household_Income_V5
,       MD.Mosaic_NCOA_Move_Update_Code = x_CE.Mosaic_NCOA_Move_Update_Code
,       MD.Mosaic_Mail_Responder = x_CE.Mosaic_Mail_Responder
,       MD.Mosaic_MOR_Bank_Upscale_Merchandise_Buyer = x_CE.Mosaic_MOR_Bank_Upscale_Merchandise_Buyer
,       MD.Mosaic_MOR_Bank_Health_And_Fitness_Magazine = x_CE.Mosaic_MOR_Bank_Health_And_Fitness_Magazine
,       MD.Mosaic_Cape_Ethnic_Pop_White_Only = x_CE.Mosaic_Cape_Ethnic_Pop_White_Only
,       MD.Mosaic_Cape_Ethnic_Pop_Black_Only = x_CE.Mosaic_Cape_Ethnic_Pop_Black_Only
,       MD.Mosaic_Cape_Ethnic_Pop_Asian_Only = x_CE.Mosaic_Cape_Ethnic_Pop_Asian_Only
,       MD.Mosaic_Cape_Ethnic_Pop_Hispanic = x_CE.Mosaic_Cape_Ethnic_Pop_Hispanic
,       MD.Mosaic_Cape_Lang_HH_Spanish_Speaking = x_CE.Mosaic_Cape_Lang_HH_Spanish_Speaking
,       MD.Mosaic_Cape_INC_HH_Median_Family_Household_Income = x_CE.Mosaic_Cape_INC_HH_Median_Family_Household_Income
,       MD.Mosaic_MatchStatus = x_CE.Mosaic_MatchStatus
,       MD.Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code = x_CE.Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code
,       MD.Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code = x_CE.Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code
,       MD.Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code = x_CE.Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code
,       MD.IsAutoConfirmEmail = x_CE.IsAutoConfirmEmail
,       MD.CanConfirmAppointmentByPhone1Text = x_CE.CanConfirmAppointmentByPhone1Text
,       MD.CanContactForPromotionsByPhone1Text = x_CE.CanContactForPromotionsByPhone1Text
,       MD.CanConfirmAppointmentByPhone2Text = x_CE.CanConfirmAppointmentByPhone2Text
,       MD.CanContactForPromotionsByPhone2Text = x_CE.CanContactForPromotionsByPhone2Text
,       MD.CanConfirmAppointmentByPhone3Text = x_CE.CanConfirmAppointmentByPhone3Text
,       MD.CanContactForPromotionsByPhone3Text = x_CE.CanContactForPromotionsByPhone3Text
,       MD.DoNotContact = x_CE.DoNotContactFlag
,       MD.DoNotCall = x_CE.DoNotCallFlag
,       MD.ClientCreateDate = x_CE.CreateDate
,		MD.ClientLastUpdate = x_CE.LastUpdate
,		MD.RecordStatus = CASE WHEN x_CE.BIO_Membership = 'New Client (ShowNoSale)' THEN 'LEAD' ELSE 'CLIENT' END
,		MD.LastUpdate = GETDATE()
FROM    datClientLeadMerge MD
        CROSS APPLY ( SELECT    CE.*
                      FROM      datClientExport CE
                                INNER JOIN #ClientLeadJoin CLJ
                                    ON CLJ.ClientIdentifier = CE.ClientIdentifier
                      WHERE     CE.LeadID = MD.LeadID
                    ) x_CE
WHERE   x_CE.ExportHeaderID = @ExportHeaderID
		AND ISNULL(MD.ClientIdentifier, 0) = 0


-- Update clients records, that are already in the Merge table, with updated client information
UPDATE	MD
SET		MD.ExportHeaderID = @ExportHeaderID
,		MD.RegionID = CE.RegionSSID
,		MD.RegionName = CE.RegionName
,       MD.CenterID = CE.CenterSSID
,       MD.CenterName = CE.CenterName
,       MD.CenterType = CE.CenterType
,       MD.CenterAddress1 = CE.CenterAddress1
,       MD.CenterAddress2 = CE.CenterAddress2
,       MD.CenterCity = CE.CenterCity
,       MD.CenterStateCode = CE.CenterStateCode
,       MD.CenterZipCode = CE.CenterZipCode
,       MD.CenterCountry = CE.CenterCountry
,       MD.CenterPhoneNumber = CE.CenterPhoneNumber
,       MD.CenterManagingDirector = CE.CenterManagingDirector
,       MD.CenterManagingDirectorEmail = CE.CenterManagingDirectorEmail
,       MD.ClientIdentifier = CE.ClientIdentifier
,       MD.FirstName = CE.ClientFirstName
,       MD.LastName = CE.ClientLastName
,       MD.Address1 = CE.ClientAddress1
,       MD.Address2 = CE.ClientAddress2
,       MD.City = CE.ClientCity
,       MD.StateCode = CE.ClientStateCode
,       MD.ZipCode = CE.ClientZipCode
,       MD.Country = CE.ClientCountry
,       MD.Timezone = CE.ClientTimezone
,       MD.EmailAddress = CE.ClientEmailAddress
,       MD.Gender = CE.ClientGender
,       MD.DateOfBirth = CASE WHEN CONVERT(VARCHAR(11), CE.ClientDateOfBirth, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.ClientDateOfBirth, 101) END
,       MD.Age = CASE WHEN CONVERT(VARCHAR, CE.ClientAge) = '0' THEN '' ELSE CONVERT(VARCHAR, CE.ClientAge) END
,       MD.SiebelID = CE.SiebelID
,       MD.Phone1 = CE.Phone1
,       MD.Phone1Type = CE.Phone1Type
,       MD.Phone2 = CE.Phone2
,       MD.Phone2Type = CE.Phone2Type
,       MD.Phone3 = CE.Phone3
,       MD.Phone3Type = CE.Phone3Type
,       MD.Ethnicity = REPLACE(ISNULL(CE.ClientEthinicityDescription, ''), ',', '')
,       MD.MaritalStatus = REPLACE(ISNULL(CE.ClientMaritalStatusDescription, ''), ',', '')
,       MD.Occupation = REPLACE(ISNULL(CE.ClientOccupationDescription, ''), ',', '')
,       MD.InitialSaleDate = CASE WHEN CONVERT(VARCHAR(11), CE.InitialSaleDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.InitialSaleDate, 101) END
,       MD.NBConsultant = CE.NBConsultant
,       MD.NBConsultantName = CE.NBConsultantName
,       MD.NBConsultantEmail = CE.NBConsultantEmail
,       MD.InitialApplicationDate = CASE WHEN CONVERT(VARCHAR(11), CE.InitialApplicationDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.InitialApplicationDate, 101) END
,       MD.ConversionDate = CASE WHEN CONVERT(VARCHAR(11), CE.ConversionDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.ConversionDate, 101) END
,       MD.MembershipAdvisor = CE.MembershipAdvisor
,       MD.MembershipAdvisorName = CE.MembershipAdvisorName
,       MD.MembershipAdvisorEmail = CE.MembershipAdvisorEmail
,       MD.FirstAppointmentDate = CASE WHEN CONVERT(VARCHAR(11), CE.FirstAppointmentDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.FirstAppointmentDate, 101) END
,       MD.LastAppointmentDate = CASE WHEN CONVERT(VARCHAR(11), CE.LastAppointmentDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.LastAppointmentDate, 101) END
,       MD.NextAppointmentGUID = CE.NextAppointmentGUID
,       MD.NextAppointmentCenterID = CE.NextAppointmentCenterID
,       MD.NextAppointmentDate = CASE WHEN CONVERT(VARCHAR(11), CE.NextAppointmentDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.NextAppointmentDate, 101) END
,       MD.NextAppointmentTime = CASE WHEN ISNULL(CONVERT(VARCHAR(15), CAST(CE.NextAppointmentTime AS TIME), 100), '') = '' OR CE.NextAppointmentTime = '1900-01-01 00:00:00.000' THEN '' ELSE CONVERT(VARCHAR(15), CAST(CE.NextAppointmentTime AS TIME), 100) END
,		MD.StylistFirstName = CASE WHEN CE.StylistFirstName IS NULL THEN '' ELSE CE.StylistFirstName END
,		MD.StylistLastName = CASE WHEN CE.StylistLastName IS NULL THEN '' ELSE CE.StylistLastName END
,       MD.FirstEXTServiceDate = CASE WHEN CONVERT(VARCHAR(11), CE.FirstEXTServiceDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.FirstEXTServiceDate, 101) END
,       MD.FirstXtrandServiceDate = CASE WHEN CONVERT(VARCHAR(11), CE.FirstXtrandServiceDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.FirstXtrandServiceDate, 101) END
,       MD.BIO_Membership = CE.BIO_Membership
,       MD.BIO_BeginDate = CASE WHEN CONVERT(VARCHAR(11), CE.BIO_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.BIO_BeginDate, 101) END
,       MD.BIO_EndDate = CASE WHEN CONVERT(VARCHAR(11), CE.BIO_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.BIO_EndDate, 101) END
,       MD.BIO_MembershipStatus = CE.BIO_MembershipStatus
,       MD.BIO_MonthlyFee = CE.BIO_MonthlyFee
,       MD.BIO_ContractPrice = CE.BIO_ContractPrice
,       MD.BIO_CancelDate = CASE WHEN CONVERT(VARCHAR(11), CE.BIO_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.BIO_CancelDate, 101) END
,       MD.BIO_CancelReasonDescription = CE.BIO_CancelReasonDescription
,       MD.EXT_Membership = CE.EXT_Membership
,       MD.EXT_BeginDate = CASE WHEN CONVERT(VARCHAR(11), CE.EXT_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.EXT_BeginDate, 101) END
,       MD.EXT_EndDate = CASE WHEN CONVERT(VARCHAR(11), CE.EXT_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.EXT_EndDate, 101) END
,       MD.EXT_MembershipStatus = CE.EXT_MembershipStatus
,       MD.EXT_MonthlyFee = CE.EXT_MonthlyFee
,       MD.EXT_ContractPrice = CE.EXT_ContractPrice
,       MD.EXT_CancelDate = CASE WHEN CONVERT(VARCHAR(11), CE.EXT_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.EXT_CancelDate, 101) END
,       MD.EXT_CancelReasonDescription = CE.EXT_CancelReasonDescription
,       MD.XTR_Membership = CE.XTR_Membership
,       MD.XTR_BeginDate = CASE WHEN CONVERT(VARCHAR(11), CE.XTR_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.XTR_BeginDate, 101) END
,       MD.XTR_EndDate = CASE WHEN CONVERT(VARCHAR(11), CE.XTR_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.XTR_EndDate, 101) END
,       MD.XTR_MembershipStatus = CE.XTR_MembershipStatus
,       MD.XTR_MonthlyFee = CE.XTR_MonthlyFee
,       MD.XTR_ContractPrice = CE.XTR_ContractPrice
,       MD.XTR_CancelDate = CASE WHEN CONVERT(VARCHAR(11), CE.XTR_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.XTR_CancelDate, 101) END
,       MD.XTR_CancelReasonDescription = CE.XTR_CancelReasonDescription
,       MD.SUR_Membership = CE.SUR_Membership
,       MD.SUR_BeginDate = CASE WHEN CONVERT(VARCHAR(11), CE.SUR_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.SUR_BeginDate, 101) END
,       MD.SUR_EndDate = CASE WHEN CONVERT(VARCHAR(11), CE.SUR_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.SUR_EndDate, 101) END
,       MD.SUR_MembershipStatus = CE.SUR_MembershipStatus
,       MD.SUR_MonthlyFee = CE.SUR_MonthlyFee
,       MD.SUR_ContractPrice = CE.SUR_ContractPrice
,       MD.SUR_CancelDate = CASE WHEN CONVERT(VARCHAR(11), CE.SUR_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.SUR_CancelDate, 101) END
,       MD.SUR_CancelReasonDescription = CE.SUR_CancelReasonDescription
,       MD.Mosaic_Household = CE.Mosaic_Household
,       MD.Mosaic_Household_Group = CE.Mosaic_Household_Group
,       MD.Mosaic_Household_Type = CE.Mosaic_Household_Type
,       MD.Mosaic_Zip = CE.Mosaic_Zip
,       MD.Mosaic_Zip_Group = CE.Mosaic_Zip_Group
,       MD.Mosaic_Zip_Type = CE.Mosaic_Zip_Type
,       MD.Mosaic_Gender = CE.Mosaic_Gender
,       MD.Mosaic_Combined_Age = CE.Mosaic_Combined_Age
,       MD.Mosaic_Education_Model = CE.Mosaic_Education_Model
,       MD.Mosaic_Marital_Status = CE.Mosaic_Marital_Status
,       MD.Mosaic_Occupation_Group_V2 = CE.Mosaic_Occupation_Group_V2
,       MD.Mosaic_Latitude = CE.Mosaic_Latitude
,       MD.Mosaic_Longitude = CE.Mosaic_Longitude
,       MD.Mosaic_Match_Level_For_Geo_Data = CE.Mosaic_Match_Level_For_Geo_Data
,       MD.Mosaic_Est_Household_Income_V5 = CE.Mosaic_Est_Household_Income_V5
,       MD.Mosaic_NCOA_Move_Update_Code = CE.Mosaic_NCOA_Move_Update_Code
,       MD.Mosaic_Mail_Responder = CE.Mosaic_Mail_Responder
,       MD.Mosaic_MOR_Bank_Upscale_Merchandise_Buyer = CE.Mosaic_MOR_Bank_Upscale_Merchandise_Buyer
,       MD.Mosaic_MOR_Bank_Health_And_Fitness_Magazine = CE.Mosaic_MOR_Bank_Health_And_Fitness_Magazine
,       MD.Mosaic_Cape_Ethnic_Pop_White_Only = CE.Mosaic_Cape_Ethnic_Pop_White_Only
,       MD.Mosaic_Cape_Ethnic_Pop_Black_Only = CE.Mosaic_Cape_Ethnic_Pop_Black_Only
,       MD.Mosaic_Cape_Ethnic_Pop_Asian_Only = CE.Mosaic_Cape_Ethnic_Pop_Asian_Only
,       MD.Mosaic_Cape_Ethnic_Pop_Hispanic = CE.Mosaic_Cape_Ethnic_Pop_Hispanic
,       MD.Mosaic_Cape_Lang_HH_Spanish_Speaking = CE.Mosaic_Cape_Lang_HH_Spanish_Speaking
,       MD.Mosaic_Cape_INC_HH_Median_Family_Household_Income = CE.Mosaic_Cape_INC_HH_Median_Family_Household_Income
,       MD.Mosaic_MatchStatus = CE.Mosaic_MatchStatus
,       MD.Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code = CE.Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code
,       MD.Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code = CE.Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code
,       MD.Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code = CE.Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code
,       MD.IsAutoConfirmEmail = CE.IsAutoConfirmEmail
,       MD.CanConfirmAppointmentByPhone1Text = CE.CanConfirmAppointmentByPhone1Text
,       MD.CanContactForPromotionsByPhone1Text = CE.CanContactForPromotionsByPhone1Text
,       MD.CanConfirmAppointmentByPhone2Text = CE.CanConfirmAppointmentByPhone2Text
,       MD.CanContactForPromotionsByPhone2Text = CE.CanContactForPromotionsByPhone2Text
,       MD.CanConfirmAppointmentByPhone3Text = CE.CanConfirmAppointmentByPhone3Text
,       MD.CanContactForPromotionsByPhone3Text = CE.CanContactForPromotionsByPhone3Text
,       MD.DoNotContact = CE.DoNotContactFlag
,       MD.DoNotCall = CE.DoNotCallFlag
,       MD.ClientLastUpdate = CE.LastUpdate
,		MD.RecordStatus = CASE WHEN CE.BIO_Membership = 'New Client (ShowNoSale)' THEN 'LEAD' ELSE 'CLIENT' END
,		MD.LastUpdate = GETDATE()
FROM    datClientLeadMerge MD
		INNER JOIN datClientExport CE
			ON CE.ClientIdentifier = MD.ClientIdentifier
WHERE	CE.ExportHeaderID = @ExportHeaderID


-- Insert client records, that are not already there, into the Merge table
INSERT	INTO datClientLeadMerge (
			ExportHeaderID
        ,	RegionID
        ,	RegionName
        ,	CenterID
        ,	CenterName
        ,	CenterType
        ,	CenterAddress1
        ,	CenterAddress2
        ,	CenterCity
        ,	CenterStateCode
        ,	CenterZipCode
        ,	CenterCountry
        ,	CenterPhoneNumber
        ,	CenterManagingDirector
        ,	CenterManagingDirectorEmail
        ,	ClientIdentifier
        ,	LeadID
        ,	FirstName
        ,	LastName
        ,	Address1
        ,	Address2
        ,	City
        ,	StateCode
        ,	ZipCode
        ,	Country
        ,	Timezone
        ,	EmailAddress
        ,	Gender
        ,	DateOfBirth
        ,	Age
        ,	SiebelID
        ,	Phone1
        ,	Phone1Type
        ,	Phone2
        ,	Phone2Type
        ,	Phone3
        ,	Phone3Type
        ,	Ethnicity
        ,	MaritalStatus
        ,	Occupation
        ,	InitialSaleDate
        ,	NBConsultant
        ,	NBConsultantName
        ,	NBConsultantEmail
        ,	InitialApplicationDate
        ,	ConversionDate
        ,	MembershipAdvisor
        ,	MembershipAdvisorName
        ,	MembershipAdvisorEmail
        ,	FirstAppointmentDate
        ,	LastAppointmentDate
        ,	NextAppointmentGUID
		,   NextAppointmentCenterID
		,	NextAppointmentDate
		,	NextAppointmentTime
		,	StylistFirstName
		,	StylistLastName
        ,	FirstEXTServiceDate
        ,	FirstXtrandServiceDate
        ,	BIO_Membership
        ,	BIO_BeginDate
        ,	BIO_EndDate
        ,	BIO_MembershipStatus
        ,	BIO_MonthlyFee
        ,	BIO_ContractPrice
        ,	BIO_CancelDate
        ,	BIO_CancelReasonDescription
        ,	EXT_Membership
        ,	EXT_BeginDate
        ,	EXT_EndDate
        ,	EXT_MembershipStatus
        ,	EXT_MonthlyFee
        ,	EXT_ContractPrice
        ,	EXT_CancelDate
        ,	EXT_CancelReasonDescription
        ,	XTR_Membership
        ,	XTR_BeginDate
        ,	XTR_EndDate
        ,	XTR_MembershipStatus
        ,	XTR_MonthlyFee
        ,	XTR_ContractPrice
        ,	XTR_CancelDate
        ,	XTR_CancelReasonDescription
        ,	SUR_Membership
        ,	SUR_BeginDate
        ,	SUR_EndDate
        ,	SUR_MembershipStatus
        ,	SUR_MonthlyFee
        ,	SUR_ContractPrice
        ,	SUR_CancelDate
        ,	SUR_CancelReasonDescription
        ,	Mosaic_Household
        ,	Mosaic_Household_Group
        ,	Mosaic_Household_Type
        ,	Mosaic_Zip
        ,	Mosaic_Zip_Group
        ,	Mosaic_Zip_Type
        ,	Mosaic_Gender
        ,	Mosaic_Combined_Age
        ,	Mosaic_Education_Model
        ,	Mosaic_Marital_Status
        ,	Mosaic_Occupation_Group_V2
        ,	Mosaic_Latitude
        ,	Mosaic_Longitude
        ,	Mosaic_Match_Level_For_Geo_Data
        ,	Mosaic_Est_Household_Income_V5
        ,	Mosaic_NCOA_Move_Update_Code
        ,	Mosaic_Mail_Responder
        ,	Mosaic_MOR_Bank_Upscale_Merchandise_Buyer
        ,	Mosaic_MOR_Bank_Health_And_Fitness_Magazine
        ,	Mosaic_Cape_Ethnic_Pop_White_Only
        ,	Mosaic_Cape_Ethnic_Pop_Black_Only
        ,	Mosaic_Cape_Ethnic_Pop_Asian_Only
        ,	Mosaic_Cape_Ethnic_Pop_Hispanic
        ,	Mosaic_Cape_Lang_HH_Spanish_Speaking
        ,	Mosaic_Cape_INC_HH_Median_Family_Household_Income
        ,	Mosaic_MatchStatus
        ,	Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code
        ,	Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code
        ,	Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code
        ,	IsAutoConfirmEmail
        ,	CanConfirmAppointmentByPhone1Text
        ,	CanContactForPromotionsByPhone1Text
        ,	CanConfirmAppointmentByPhone2Text
        ,	CanContactForPromotionsByPhone2Text
		,	CanConfirmAppointmentByPhone3Text
        ,	CanContactForPromotionsByPhone3Text
        ,	DoNotContact
        ,	DoNotCall
        ,	DoNotText
        ,	DoNotEmail
        ,	DoNotMail
        ,	DoNotSolicit
        ,	RecordStatus
        ,	ClientCreateDate
        ,	CreateUser
        ,	ClientLastUpdate
        ,	LastUpdateUser
		)
		SELECT	@ExportHeaderID
		,		CE.RegionSSID AS 'RegionID'
		,       CE.RegionName
		,       CE.CenterSSID AS 'CenterID'
		,       CE.CenterName
		,       CE.CenterType
		,       CE.CenterAddress1
		,       CE.CenterAddress2
		,       CE.CenterCity
		,       CE.CenterStateCode
		,       CE.CenterZipCode
		,       CE.CenterCountry
		,       CE.CenterPhoneNumber
		,       CE.CenterManagingDirector
		,       CE.CenterManagingDirectorEmail
		,       CONVERT(VARCHAR, CE.ClientIdentifier) AS 'ClientIdentifier'
		,       CE.LeadID
		,       CE.ClientFirstName AS 'FirstName'
		,       CE.ClientLastName AS 'LastName'
		,       CE.ClientAddress1 AS 'Address1'
		,       CE.ClientAddress2 AS 'Address2'
		,       CE.ClientCity AS 'City'
		,       CE.ClientStateCode AS 'State'
		,       CE.ClientZipCode AS 'ZipCode'
		,       CE.ClientCountry AS 'Country'
		,       CE.ClientTimezone AS 'TimeZone'
		,       CE.ClientEmailAddress AS 'EmailAddress'
		,       CE.ClientGender AS 'Gender'
		,       CASE WHEN CONVERT(VARCHAR(11), CE.ClientDateOfBirth, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.ClientDateOfBirth, 101) END AS 'DateOfBirth'
		,       CASE WHEN CONVERT(VARCHAR, CE.ClientAge) = '0' THEN '' ELSE CONVERT(VARCHAR, CE.ClientAge) END AS 'Age'
		,       CE.SiebelID
		,       CE.Phone1
		,       CE.Phone1Type
		,       CE.Phone2
		,       CE.Phone2Type
		,       CE.Phone3
		,       CE.Phone3Type
		,       REPLACE(ISNULL(CE.ClientEthinicityDescription, ''), ',', '') AS 'Ethnicity'
		,       REPLACE(ISNULL(CE.ClientMaritalStatusDescription, ''), ',', '') AS 'MaritalStatus'
		,       REPLACE(ISNULL(CE.ClientOccupationDescription, ''), ',', '') AS 'Occupation'
		,		CASE WHEN CONVERT(VARCHAR(11), CE.InitialSaleDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.InitialSaleDate, 101) END AS 'InitialSaleDate'
		,       CE.NBConsultant
		,       CE.NBConsultantName
		,       CE.NBConsultantEmail
		,		CASE WHEN CONVERT(VARCHAR(11), CE.InitialApplicationDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.InitialApplicationDate, 101) END AS 'InitialApplicationDate'
		,		CASE WHEN CONVERT(VARCHAR(11), CE.ConversionDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.ConversionDate, 101) END AS 'ConversionDate'
		,       CE.MembershipAdvisor
		,       CE.MembershipAdvisorName
		,       CE.MembershipAdvisorEmail
		,		CASE WHEN CONVERT(VARCHAR(11), CE.FirstAppointmentDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.FirstAppointmentDate, 101) END AS 'FirstAppointmentDate'
		,		CASE WHEN CONVERT(VARCHAR(11), CE.LastAppointmentDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.LastAppointmentDate, 101) END AS 'LastAppointmentDate'
		,       CE.NextAppointmentGUID
		,       CE.NextAppointmentCenterID
		,       CASE WHEN CONVERT(VARCHAR(11), CE.NextAppointmentDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.NextAppointmentDate, 101) END AS 'NextAppointmentDate'
		,		CASE WHEN ISNULL(CONVERT(VARCHAR(15), CAST(CE.NextAppointmentTime AS TIME), 100), '') = '' OR CE.NextAppointmentTime = '1900-01-01 00:00:00.000' THEN '' ELSE CONVERT(VARCHAR(15), CAST(CE.NextAppointmentTime AS TIME), 100) END
		,		CASE WHEN CE.StylistFirstName IS NULL THEN '' ELSE CE.StylistFirstName END AS 'StylistFirstName'
		,		CASE WHEN CE.StylistLastName IS NULL THEN '' ELSE CE.StylistLastName END AS 'StylistLastName'
		,		CASE WHEN CONVERT(VARCHAR(11), CE.FirstEXTServiceDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.FirstEXTServiceDate, 101) END AS 'FirstEXTServiceDate'
		,		CASE WHEN CONVERT(VARCHAR(11), CE.FirstXtrandServiceDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.FirstXtrandServiceDate, 101) END AS 'FirstXtrandServiceDate'
		,       CE.BIO_Membership
		,		CASE WHEN CONVERT(VARCHAR(11), CE.BIO_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.BIO_BeginDate, 101) END AS 'BIO_BeginDate'
		,		CASE WHEN CONVERT(VARCHAR(11), CE.BIO_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.BIO_EndDate, 101) END AS 'BIO_EndDate'
		,       CE.BIO_MembershipStatus
		,       CE.BIO_MonthlyFee
		,       CE.BIO_ContractPrice
		,		CASE WHEN CONVERT(VARCHAR(11), CE.BIO_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.BIO_CancelDate, 101) END AS 'BIO_CancelDate'
		,       CE.BIO_CancelReasonDescription
		,       CE.EXT_Membership
		,		CASE WHEN CONVERT(VARCHAR(11), CE.EXT_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.EXT_BeginDate, 101) END AS 'EXT_BeginDate'
		,		CASE WHEN CONVERT(VARCHAR(11), CE.EXT_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.EXT_EndDate, 101) END AS 'EXT_EndDate'
		,       CE.EXT_MembershipStatus
		,       CE.EXT_MonthlyFee
		,       CE.EXT_ContractPrice
		,		CASE WHEN CONVERT(VARCHAR(11), CE.EXT_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.EXT_CancelDate, 101) END AS 'EXT_CancelDate'
		,       CE.EXT_CancelReasonDescription
		,       CE.XTR_Membership
		,		CASE WHEN CONVERT(VARCHAR(11), CE.XTR_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.XTR_BeginDate, 101) END AS 'XTR_BeginDate'
		,		CASE WHEN CONVERT(VARCHAR(11), CE.XTR_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.XTR_EndDate, 101) END AS 'XTR_EndDate'
		,       CE.XTR_MembershipStatus
		,       CE.XTR_MonthlyFee
		,       CE.XTR_ContractPrice
		,		CASE WHEN CONVERT(VARCHAR(11), CE.XTR_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.XTR_CancelDate, 101) END AS 'XTR_CancelDate'
		,       CE.XTR_CancelReasonDescription
		,       CE.SUR_Membership
		,		CASE WHEN CONVERT(VARCHAR(11), CE.SUR_BeginDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.SUR_BeginDate, 101) END AS 'SUR_BeginDate'
		,		CASE WHEN CONVERT(VARCHAR(11), CE.SUR_EndDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.SUR_EndDate, 101) END AS 'SUR_EndDate'
		,       CE.SUR_MembershipStatus
		,       CE.SUR_MonthlyFee
		,       CE.SUR_ContractPrice
		,		CASE WHEN CONVERT(VARCHAR(11), CE.SUR_CancelDate, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CE.SUR_CancelDate, 101) END AS 'SUR_CancelDate'
		,       CE.SUR_CancelReasonDescription
		,       CE.Mosaic_Household
		,       CE.Mosaic_Household_Group
		,       CE.Mosaic_Household_Type
		,       CE.Mosaic_Zip
		,       CE.Mosaic_Zip_Group
		,       CE.Mosaic_Zip_Type
		,       CE.Mosaic_Gender
		,       CE.Mosaic_Combined_Age
		,       CE.Mosaic_Education_Model
		,       CE.Mosaic_Marital_Status
		,       CE.Mosaic_Occupation_Group_V2
		,       CE.Mosaic_Latitude
		,       CE.Mosaic_Longitude
		,       CE.Mosaic_Match_Level_For_Geo_Data
		,       CE.Mosaic_Est_Household_Income_V5
		,       CE.Mosaic_NCOA_Move_Update_Code
		,       CE.Mosaic_Mail_Responder
		,       CE.Mosaic_MOR_Bank_Upscale_Merchandise_Buyer
		,       CE.Mosaic_MOR_Bank_Health_And_Fitness_Magazine
		,       CE.Mosaic_Cape_Ethnic_Pop_White_Only
		,       CE.Mosaic_Cape_Ethnic_Pop_Black_Only
		,       CE.Mosaic_Cape_Ethnic_Pop_Asian_Only
		,       CE.Mosaic_Cape_Ethnic_Pop_Hispanic
		,       CE.Mosaic_Cape_Lang_HH_Spanish_Speaking
		,       CE.Mosaic_Cape_INC_HH_Median_Family_Household_Income
		,       CE.Mosaic_MatchStatus
		,       CE.Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code
		,       CE.Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code
		,       CE.Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code
		,       CE.IsAutoConfirmEmail
		,       CE.CanConfirmAppointmentByPhone1Text
		,       CE.CanContactForPromotionsByPhone1Text
		,       CE.CanConfirmAppointmentByPhone2Text
		,       CE.CanContactForPromotionsByPhone2Text
		,       CE.CanConfirmAppointmentByPhone3Text
		,       CE.CanContactForPromotionsByPhone3Text
		,       CE.DoNotContactFlag AS 'DoNotContact'
		,       CE.DoNotCallFlag AS 'DoNotCall'
		,       0 AS 'DoNotText'
		,       0 AS 'DoNotEmail'
		,       0 AS 'DoNotMail'
		,       0 AS 'DoNotSolicit'
		,		CASE WHEN CE.BIO_Membership = 'New Client (ShowNoSale)' THEN 'LEAD' ELSE 'CLIENT' END AS 'RecordStatus'
		,		CE.CreateDate AS 'CreateDate'
		,		'MD-Export' AS 'CreateUser'
		,		CE.LastUpdate AS 'LastUpdate'
		,		'MD-Export' AS 'LastUpdateUser'
		FROM    datClientExport CE
				LEFT JOIN datClientLeadMerge MD
					ON MD.ClientIdentifier = CE.ClientIdentifier
		WHERE   CE.ExportHeaderID = @ExportHeaderID
				AND MD.ClientLeadMergeID IS NULL

END
GO
