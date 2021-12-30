/* CreateDate: 11/17/2016 14:34:11.647 , ModifyDate: 06/10/2017 15:01:04.190 */
GO
/***********************************************************************
PROCEDURE:				spSvc_SilverpopLeadExportDump
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

EXEC spSvc_SilverpopLeadExportDump 580
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_SilverpopLeadExportDump]
(
	@ExportHeaderID INT
)
AS
BEGIN

TRUNCATE TABLE datLeadExport


/********************************** Set Dates *************************************/
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SELECT  @StartDate = EH.ExportStartDate
,		@EndDate = EH.ExportEndDate
FROM    datExportHeader EH
WHERE   EH.ExportHeaderID = @ExportHeaderID


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterType NVARCHAR(50)
,	RegionSSID INT
,	RegionName NVARCHAR(50)
,	CenterSSID INT
,	CenterName NVARCHAR(255)
,	CenterAddress1 NVARCHAR(50)
,   CenterAddress2 NVARCHAR(50)
,   City NVARCHAR(50)
,   State NVARCHAR(10)
,   ZipCode NVARCHAR(15)
,   Country NVARCHAR(10)
,	PhoneNumber NVARCHAR(15)
,	ManagingDirector NVARCHAR(102)
,	ManagingDirectorEmail NVARCHAR(50)
,	IsAutoConfirmEnabled INT
)

CREATE TABLE #UpdatedLeads ( contact_id NCHAR(10) )

CREATE TABLE #Leads (
	ExportHeaderID INT
,	contact_contact_id VARCHAR(255)
,	contact_first_name VARCHAR(255)
,	contact_last_name VARCHAR(255)
,	contact_address_address_id VARCHAR(255)
,	contact_address_address_line_1 VARCHAR(255)
,	contact_address_address_line_2 VARCHAR(255)
,	contact_address_city VARCHAR(255)
,	contact_address_state_code VARCHAR(255)
,	contact_address_zip_code VARCHAR(255)
,	contact_address_country_code VARCHAR(255)
,	contact_address_time_zone_code VARCHAR(255)
,	contact_address_valid_flag VARCHAR(255)
,	contact_phone_phone_id VARCHAR(255)
,	contact_phone_phone_number VARCHAR(255)
,	contact_phone_valid_flag VARCHAR(255)
,	contact_email_email_id VARCHAR(255)
,	contact_email_email VARCHAR(255)
,	contact_email_valid_flag VARCHAR(255)
,	contact_gender_code VARCHAR(255)
,	contact_age VARCHAR(255)
,	contact_age_range_code VARCHAR(255)
,	contact_age_range VARCHAR(255)
,	contact_dnc_date VARCHAR(255)
,	contact_hair_loss_code VARCHAR(255)
,	contact_hair_loss_experience_code VARCHAR(255)
,	contact_hair_loss_family_code VARCHAR(255)
,	contact_hair_loss_in_family_code VARCHAR(255)
,	contact_hair_loss_product VARCHAR(255)
,	contact_hair_loss_spot_code VARCHAR(255)
,	contact_language_code VARCHAR(255)
,	contact_promotion_code VARCHAR(255)
,	contact_source_source_code VARCHAR(255)
,	contact_source_source_media VARCHAR(255)
,	contact_source_source_format VARCHAR(255)
,	contact_contact_siebel_id VARCHAR(255)
,	contact_do_not_email VARCHAR(255)
,	contact_do_not_mail VARCHAR(255)
,	contact_do_not_call VARCHAR(255)
,	contact_do_not_solicit VARCHAR(255)
,	contact_do_not_text VARCHAR(255)
,	contact_creation_date VARCHAR(255)
,	contact_contact_status_code VARCHAR(255)
,	contact_marketing_score VARCHAR(255)
,	company_company_id VARCHAR(255)
,	company_center_number VARCHAR(255)
,	company_company_name VARCHAR(255)
,	company_address_line_1 VARCHAR(255)
,	company_address_line_2 VARCHAR(255)
,	company_city VARCHAR(255)
,	company_state_code VARCHAR(255)
,	company_zip_code VARCHAR(255)
,	company_country_code VARCHAR(255)
,	company_center_type VARCHAR(255)
,	company_center_region_number VARCHAR(255)
,	company_center_region_name VARCHAR(255)
,	company_center_phone_number VARCHAR(255)
,	company_center_managing_director VARCHAR(255)
,	company_center_managing_director_email VARCHAR(255)
,	appointment_activity_id VARCHAR(255)
,	can_confirm_appointment_by_text NCHAR(10)
,	appointment_activity_creation_date VARCHAR(255)
,	appointment_activity_action_code VARCHAR(255)
,	appointment_activity_result_code VARCHAR(255)
,	appointment_activity_source_code VARCHAR(255)
,	appointment_activity_due_date VARCHAR(255)
,	appointment_activity_start_time VARCHAR(255)
,	appointment_activity_completion_date VARCHAR(255)
,	appointment_activity_completion_time VARCHAR(255)
,	activity_demographic_birthday VARCHAR(255)
,	activity_demographic_disc_style VARCHAR(255)
,	activity_demographic_ethnicity_code VARCHAR(255)
,	activity_demographic_ethnicity VARCHAR(255)
,	activity_demographic_ludwig VARCHAR(255)
,	activity_demographic_maritalstatus_code VARCHAR(255)
,	activity_demographic_maritalstatus VARCHAR(255)
,	activity_demographic_no_sale_reason VARCHAR(255)
,	activity_demographic_norwood VARCHAR(255)
,	activity_demographic_occupation_code VARCHAR(255)
,	activity_demographic_occupation VARCHAR(255)
,	activity_demographic_price_quoted VARCHAR(255)
,	activity_demographic_solution_offered VARCHAR(255)
,	activity_demographic_performer VARCHAR(255)
,	activity_demographic_performer_name VARCHAR(255)
,	activity_demographic_performer_email VARCHAR(255)
,	contact_completion_sale_type_description VARCHAR(255)
,	brochure_activity_id VARCHAR(255)
,	brochure_activity_creation_date VARCHAR(255)
,	brochure_activity_action_code VARCHAR(255)
,	brochure_activity_result_code VARCHAR(255)
,	brochure_activity_source_code VARCHAR(255)
,	brochure_activity_due_date VARCHAR(255)
,	brochure_activity_start_time VARCHAR(255)
,	brochure_activity_completion_date VARCHAR(255)
,	brochure_activity_completion_time VARCHAR(255)
,	Mosaic_Household VARCHAR(50)
,	Mosaic_Household_Group VARCHAR(255)
,	Mosaic_Household_Type VARCHAR(255)
,	Mosaic_Zip VARCHAR(50)
,	Mosaic_Zip_Group VARCHAR(255)
,	Mosaic_Zip_Type VARCHAR(255)
,	Mosaic_Gender VARCHAR(50)
,	Mosaic_Combined_Age VARCHAR(50)
,	Mosaic_Education_Model VARCHAR(50)
,	Mosaic_Marital_Status VARCHAR(50)
,	Mosaic_Occupation_Group_V2 VARCHAR(50)
,	Mosaic_Latitude VARCHAR(50)
,	Mosaic_Longitude VARCHAR(50)
,	Mosaic_Match_Level_For_Geo_Data VARCHAR(50)
,	Mosaic_Est_Household_Income_V5 VARCHAR(50)
,	Mosaic_NCOA_Move_Update_Code VARCHAR(50)
,	Mosaic_Mail_Responder VARCHAR(50)
,	Mosaic_MOR_Bank_Upscale_Merchandise_Buyer VARCHAR(50)
,	Mosaic_MOR_Bank_Health_And_Fitness_Magazine VARCHAR(50)
,	Mosaic_Cape_Ethnic_Pop_White_Only VARCHAR(50)
,	Mosaic_Cape_Ethnic_Pop_Black_Only VARCHAR(50)
,	Mosaic_Cape_Ethnic_Pop_Asian_Only VARCHAR(50)
,	Mosaic_Cape_Ethnic_Pop_Hispanic VARCHAR(50)
,	Mosaic_Cape_Lang_HH_Spanish_Speaking VARCHAR(50)
,	Mosaic_Cape_INC_HH_Median_Family_Household_Income VARCHAR(50)
,	Mosaic_MatchStatus VARCHAR(50)
,	Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code VARCHAR(50)
,	Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code VARCHAR(50)
,	Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code VARCHAR(50)
,	CreateDate DATETIME
,	CreateUser NVARCHAR(50)
,	LastUpdate DATETIME
,	LastUpdateUser NVARCHAR(50),
)

CREATE CLUSTERED INDEX IDX_Centers_CenterID ON #Centers ( CenterSSID )

CREATE CLUSTERED INDEX IDX_UpdatedLeads_ContactID ON #UpdatedLeads ( contact_id )

CREATE CLUSTERED INDEX IDX_Leads_ContactID ON #Leads ( contact_contact_id )


/********************************** Get Center Data *************************************/
INSERT  INTO #Centers
        SELECT  DCT.CenterTypeDescriptionShort AS 'CenterType'
		,		ISNULL(DR.RegionSSID, 1) AS 'RegionSSID'
        ,       ISNULL(DR.RegionDescription, 'Corporate') AS 'RegionName'
        ,       DC.CenterSSID
        ,       DC.CenterDescription AS 'CenterName'
        ,       DC.CenterAddress1
        ,       DC.CenterAddress2
		,       DC.City
        ,       DC.StateProvinceDescriptionShort AS 'State'
        ,       DC.PostalCode AS 'ZipCode'
        ,       DC.CountryRegionDescriptionShort AS 'Country'
        ,       DC.CenterPhone1
        ,       ISNULL(CMD.ManagingDirector, '') AS 'ManagingDirector'
        ,       ISNULL(CMD.ManagingDirectorEmail, '') AS 'ManagingDirectorEmail'
		,		CCC.IsAutoConfirmEnabled
        FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                    ON DC.CenterTypeKey = DCT.CenterTypeKey
                LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                    ON DC.RegionSSID = DR.RegionKey
				LEFT OUTER JOIN HairClubCMS.dbo.cfgConfigurationCenter CCC
					ON CCC.CenterID = DC.CenterSSID
                OUTER APPLY ( SELECT TOP 1
                                        DE.CenterID AS 'CenterSSID'
                              ,         DE.FirstName + ' ' + DE.LastName AS 'ManagingDirector'
                              ,         DE.UserLogin + '@hcfm.com' AS 'ManagingDirectorEmail'
                              FROM      HairClubCMS.dbo.datEmployee DE
                                        INNER JOIN HairClubCMS.dbo.cfgEmployeePositionJoin CEPJ
                                            ON CEPJ.EmployeeGUID = DE.EmployeeGUID
                                        INNER JOIN HairClubCMS.dbo.lkpEmployeePosition LEP
                                            ON LEP.EmployeePositionID = CEPJ.EmployeePositionID
                              WHERE     LEP.EmployeePositionID = 6
                                        AND ISNULL(DE.CenterID, 100) <> 100
                                        AND DE.CenterID = DC.CenterSSID
                                        AND DE.FirstName NOT IN ( 'EC', 'Test' )
                                        AND DE.IsActiveFlag = 1
                              ORDER BY  DE.CenterID
                              ,         DE.EmployeePayrollID DESC
                            ) CMD
        WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[12]%'
                AND DC.Active = 'Y'


INSERT  INTO #Centers
		SELECT  DCT.CenterTypeDescriptionShort AS 'CenterType'
		,		DR.RegionSSID
		,       DR.RegionDescription AS 'RegionName'
		,       DC.CenterSSID
		,       DC.CenterDescription AS 'CenterName'
		,       DC.CenterAddress1
		,       DC.CenterAddress2
		,       DC.City
        ,       DC.StateProvinceDescriptionShort AS 'State'
		,       DC.PostalCode AS 'ZipCode'
		,       DC.CountryRegionDescriptionShort AS 'Country'
		,       DC.CenterPhone1
		,		ISNULL(CMD.ManagingDirector, '') AS 'ManagingDirector'
		,		ISNULL(CMD.ManagingDirectorEmail, '') AS 'ManagingDirectorEmail'
		,		CCC.IsAutoConfirmEnabled
		FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				INNER JOIN HairClubCMS.dbo.cfgConfigurationCenter CCC
					ON CCC.CenterID = DC.CenterSSID
                OUTER APPLY ( SELECT TOP 1
                                        DE.CenterID AS 'CenterSSID'
                              ,         DE.FirstName + ' ' + DE.LastName AS 'ManagingDirector'
                              ,         DE.UserLogin + '@hcfm.com' AS 'ManagingDirectorEmail'
                              FROM      HairClubCMS.dbo.datEmployee DE
                                        INNER JOIN HairClubCMS.dbo.cfgEmployeePositionJoin CEPJ
                                            ON CEPJ.EmployeeGUID = DE.EmployeeGUID
                                        INNER JOIN HairClubCMS.dbo.lkpEmployeePosition LEP
                                            ON LEP.EmployeePositionID = CEPJ.EmployeePositionID
                              WHERE     LEP.EmployeePositionID = 6
                                        AND ISNULL(DE.CenterID, 100) <> 100
                                        AND DE.CenterID = DC.CenterSSID
                                        AND DE.FirstName NOT IN ( 'EC', 'Test' )
                                        AND DE.IsActiveFlag = 1
                              ORDER BY  DE.CenterID
                              ,         DE.EmployeePayrollID DESC
                            ) CMD
		WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
				AND DC.Active = 'Y'


/********************************** Get Leads who were created or updated during time period *************************************/
INSERT	INTO #UpdatedLeads

		-- Leads who have been created or updated within Time Period
		SELECT	DISTINCT
				OC.contact_id
		FROM    HCM.dbo.oncd_contact OC WITH ( NOLOCK )
				INNER JOIN HCM.dbo.oncd_contact_company OCC WITH ( NOLOCK )
					ON OCC.contact_id = OC.contact_id
						AND OCC.primary_flag = 'Y'
				INNER JOIN HCM.dbo.oncd_company COM WITH ( NOLOCK )
					ON COM.company_id = OCC.company_id
						AND COM.company_status_code = 'ACTIVE'
				INNER JOIN HCM.dbo.oncd_contact_source OCS WITH ( NOLOCK )
					ON OCS.contact_id = OC.contact_id
						AND OCS.primary_flag = 'Y'
				LEFT OUTER JOIN HCM.dbo.oncd_contact_address OCA WITH ( NOLOCK )
					ON OCA.contact_id = OC.contact_id
						AND OCA.primary_flag = 'Y'
				LEFT OUTER JOIN HCM.dbo.oncd_contact_email OCE WITH ( NOLOCK )
					ON OCE.contact_id = OC.contact_id
						AND OCE.primary_flag = 'Y'
				LEFT OUTER JOIN HCM.dbo.oncd_contact_phone OCP WITH ( NOLOCK )
					ON OCP.contact_id = OC.contact_id
						AND OCP.primary_flag = 'Y'
		WHERE   (
					-- Contact has been created or updated
					OC.updated_date BETWEEN @StartDate AND @EndDate

					-- Contact Company has been created or updated
					OR OCC.updated_date BETWEEN @StartDate AND @EndDate

					-- Contact Source has been created or updated
					OR OCS.updated_date BETWEEN @StartDate AND @EndDate

					---- Contact Address has been created or updated
					OR OCA.updated_date BETWEEN @StartDate AND @EndDate

					-- Contact Email has been created or updated
					OR OCE.updated_date BETWEEN @StartDate AND @EndDate
				)

		UNION

		-- Leads who have had an activity created or updated within Time Period
		SELECT	DISTINCT
				OC.contact_id
		FROM    HCM.dbo.oncd_activity OA WITH ( NOLOCK )
				INNER JOIN HCM.dbo.oncd_activity_contact OAC WITH ( NOLOCK )
					ON OAC.activity_id = OA.activity_id
				INNER JOIN HCM.dbo.oncd_contact OC WITH ( NOLOCK )
					ON OC.contact_id = OAC.contact_id
				LEFT OUTER JOIN HCM.dbo.oncd_contact_company CC WITH ( NOLOCK ) -- Lead Center Join
					ON CC.contact_id = OC.contact_id
						AND CC.primary_flag = 'Y'
				LEFT OUTER JOIN HCM.dbo.oncd_company LC WITH ( NOLOCK ) -- Lead Center
					ON LC.company_id = CC.company_id
				LEFT OUTER JOIN HCM.dbo.oncd_activity_company AC WITH ( NOLOCK )  -- Activity Center Join
					ON AC.activity_id = OA.activity_id
						AND AC.primary_flag = 'Y'
				LEFT OUTER JOIN HCM.dbo.oncd_company C WITH ( NOLOCK ) -- Activity Center
					ON C.company_id = AC.company_id
		WHERE   ( OA.action_code IN ( 'APPOINT', 'BEBACK', 'INHOUSE' )
					OR OA.result_code = 'BROCHURE' )
				--AND OA.due_date >= '5/4/2017'
				AND ( OA.due_date BETWEEN @StartDate AND @EndDate
						OR OA.creation_date BETWEEN @StartDate AND @EndDate
						OR OA.updated_date BETWEEN @StartDate AND @EndDate
						OR OA.completion_date BETWEEN @StartDate AND @EndDate )

		UNION

		-- Leads who have had a Mosaic record created or updated within Time Period
		SELECT  DISTINCT
				LA.contact_id
		FROM    HC_DataAppend.dbo.Lead_Append LA WITH ( NOLOCK )
		WHERE   LA.LastUpdate BETWEEN @StartDate AND @EndDate


/********************************** Get updated Lead Details *************************************/
INSERT	INTO #Leads
		SELECT  @ExportHeaderID AS 'ExportHeaderID'
		,		LTRIM(RTRIM(OC.contact_id)) AS 'contact_contact_id'
		,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(OC.first_name, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'contact_first_name'
		,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(OC.last_name, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'contact_last_name'
		,		ISNULL(LTRIM(RTRIM(REPLACE(OCA.contact_address_id, ',', ''))), '') AS 'contact_address_address_id'
		,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(OCA.address_line_1, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'contact_address_address_line_1'
		,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(OCA.address_line_2, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'contact_address_address_line_2'
		,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(OCA.city, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'contact_address_city'
		,		ISNULL(LTRIM(RTRIM(OCA.state_code)), '') AS 'contact_address_state_code'
		,		ISNULL(LTRIM(RTRIM(OCA.zip_code)), '') AS 'contact_address_zip_code'
		,		ISNULL(LTRIM(RTRIM(OCA.country_code)), '') AS 'contact_address_country_code'
		,		ISNULL(LTRIM(RTRIM(OCA.time_zone_code)), '') AS 'contact_address_time_zone_code'
		,		ISNULL(LTRIM(RTRIM(REPLACE(OCA.cst_valid_flag, ',', ''))), '') AS 'contact_address_valid_flag'
		,		ISNULL(LTRIM(RTRIM(REPLACE(OCP.contact_phone_id, ',', ''))), '') AS 'contact_phone_phone_id'
		,		CASE WHEN LEN(ISNULL(LTRIM(RTRIM(OCP.area_code)), '') + ISNULL(LTRIM(RTRIM(OCP.phone_number)), '')) <> 10 THEN '' ELSE ISNULL(LTRIM(RTRIM(OCP.area_code)), '') + ISNULL(LTRIM(RTRIM(OCP.phone_number)), '') END AS 'contact_phone_phone_number'
		,		ISNULL(LTRIM(RTRIM(REPLACE(OCP.cst_valid_flag, ',', ''))), '') AS 'contact_phone_valid_flag'
		,		ISNULL(LTRIM(RTRIM(REPLACE(OCE.contact_email_id, ',', ''))), '') AS 'contact_email_email_id'
		,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(OCE.email, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'contact_email_email'
		,		ISNULL(LTRIM(RTRIM(REPLACE(OCE.cst_valid_flag, ',', ''))), '') AS 'contact_email_valid_flag'
		,       ISNULL(LTRIM(RTRIM(OC.cst_gender_code)), '') AS 'contact_gender_code'
		,       ISNULL(LTRIM(RTRIM(OC.cst_age)), '') AS 'contact_age'
		,       ISNULL(LTRIM(RTRIM(OC.cst_age_range_code)), '') AS 'contact_age_range_code'
		,       ISNULL(LTRIM(RTRIM(CCAR.description)), '') AS 'contact_age_range'
		,       ISNULL(CONVERT(VARCHAR(11), OC.cst_dnc_date, 101), '') AS 'contact_dnc_date'
		,       ISNULL(LTRIM(RTRIM(OC.cst_hair_loss_code)), '') AS 'contact_hair_loss_code'
		,       ISNULL(LTRIM(RTRIM(OC.cst_hair_loss_experience_code)), '') AS 'contact_hair_loss_experience_code'
		,       ISNULL(LTRIM(RTRIM(OC.cst_hair_loss_family_code)), '') AS 'contact_hair_loss_family_code'
		,       ISNULL(LTRIM(RTRIM(OC.cst_hair_loss_in_family_code)), '') AS 'contact_hair_loss_in_family_code'
		,       ISNULL(LTRIM(RTRIM(OC.cst_hair_loss_product)), '') AS 'contact_hair_loss_product'
		,       ISNULL(LTRIM(RTRIM(OC.cst_hair_loss_spot_code)), '') AS 'contact_hair_loss_spot_code'
		,       ISNULL(LTRIM(RTRIM(OC.cst_language_code)), '') AS 'contact_language_code'
		,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(OC.cst_promotion_code, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'contact_promotion_code'
		,		ISNULL(LTRIM(RTRIM(OCS.source_code)), '') AS 'contact_source_source_code'
		,		MSMT.Media AS 'contact_source_source_media'
		,		MSL.Level04Format AS 'contact_source_source_format'
		,		ISNULL(LTRIM(RTRIM(OC.cst_siebel_id)), '') AS 'contact_contact_siebel_id'
		,       ISNULL(LTRIM(RTRIM(OC.cst_do_not_email)), '') AS 'contact_do_not_email'
		,       ISNULL(LTRIM(RTRIM(OC.cst_do_not_mail)), '') AS 'contact_do_not_mail'
		,       ISNULL(LTRIM(RTRIM(OC.cst_do_not_call)), '') AS 'contact_do_not_call'
		,       ISNULL(LTRIM(RTRIM(OC.do_not_solicit)), '') AS 'contact_do_not_solicit'
		,		ISNULL(LTRIM(RTRIM(OC.cst_do_not_text)), '') AS 'contact_do_not_text'
		,       ISNULL(CONVERT(VARCHAR(11), OC.creation_date, 101), '') AS 'contact_creation_date'
		,		LTRIM(RTRIM(OC.contact_status_code)) AS 'contact_contact_status_code'
		,		ISNULL(CMS.marketing_score, 0) AS 'contact_marketing_score'
		,		COM.company_id AS 'company_company_id'
		,       C.CenterSSID AS 'company_center_number'
		,       C.CenterName AS 'company_company_name'
		,       ISNULL(LTRIM(RTRIM(REPLACE(C.CenterAddress1, ',', ''))), '') AS 'company_address_line_1'
		,       ISNULL(LTRIM(RTRIM(REPLACE(C.CenterAddress2, ',', ''))), '') AS 'company_address_line_2'
		,       C.City AS 'company_city'
		,       C.[State] AS 'company_state_code'
		,       C.ZipCode AS 'company_zip_code'
		,       C.Country AS 'company_country_code'
		,       C.CenterType AS 'company_center_type'
		,		C.RegionSSID AS 'company_center_region_number'
		,		C.RegionName AS 'company_center_region_name'
		,       C.PhoneNumber AS 'company_center_phone_number'
		,       LTRIM(RTRIM(REPLACE(C.ManagingDirector, ',', ''))) AS 'company_center_managing_director'
		,       LTRIM(RTRIM(REPLACE(C.ManagingDirectorEmail, ',', ''))) AS 'company_center_managing_director_email'
		,		ISNULL(A.activity_id, '') AS 'appointment_activity_id'
		,		ISNULL(A.can_confirm_appointment_by_text, 'No') AS 'can_confirm_appointment_by_text'
		,		ISNULL(CONVERT(VARCHAR(11), A.creation_date, 101), '') AS 'appointment_activity_creation_date'
		,		ISNULL(LTRIM(RTRIM(A.action_code)), '') AS 'appointment_activity_action_code'
		,		ISNULL(LTRIM(RTRIM(A.result_code)), '') AS 'appointment_activity_result_code'
		,       ISNULL(LTRIM(RTRIM(A.source_code)), '') AS 'appointment_activity_source_code'
		,		ISNULL(CONVERT(VARCHAR(11), A.due_date, 101), '') AS 'appointment_activity_due_date'
		,       ISNULL(CONVERT(VARCHAR(15),CAST(A.start_time AS TIME), 100), '') AS 'appointment_activity_start_time'
		,		ISNULL(CONVERT(VARCHAR(11), A.completion_date, 101), '') AS 'appointment_activity_completion_date'
		,       ISNULL(CONVERT(VARCHAR(15),CAST(A.completion_time AS TIME), 100), '') AS 'appointment_activity_completion_time'
		,		ISNULL(CONVERT(VARCHAR(11), A.birthday, 101), '') AS 'activity_demographic_birthday'
		,		ISNULL(LTRIM(RTRIM(A.disc_style)), '') AS 'activity_demographic_disc_style'
		,		ISNULL(LTRIM(RTRIM(A.ethnicity_code)), '') AS 'activity_demographic_ethnicity_code'
		,       ISNULL(LTRIM(RTRIM(A.ethnicity_description)), '') AS 'activity_demographic_ethnicity'
		,		ISNULL(LTRIM(RTRIM(A.ludwig)), '') AS 'activity_demographic_ludwig'
		,		ISNULL(LTRIM(RTRIM(A.maritalstatus_code)), '') AS 'activity_demographic_maritalstatus_code'
		,       ISNULL(LTRIM(RTRIM(A.maritalstatus_description)), '') AS 'activity_demographic_maritalstatus'
		,		ISNULL(LTRIM(RTRIM(A.no_sale_reason)), '') AS 'activity_demographic_no_sale_reason'
		,		ISNULL(LTRIM(RTRIM(A.norwood)), '') AS 'activity_demographic_norwood'
		,		ISNULL(LTRIM(RTRIM(A.occupation_code)), '') AS 'activity_demographic_occupation_code'
		,       ISNULL(LTRIM(RTRIM(A.occupation_description)), '') AS 'activity_demographic_occupation'
		,		ISNULL(A.price_quoted, 0) AS 'activity_demographic_price_quoted'
		,		ISNULL(LTRIM(RTRIM(A.solution_offered)), '') AS 'activity_demographic_solution_offered'
		,		ISNULL(A.performer_initials, '') AS 'activity_demographic_performer'
		,		ISNULL(A.performer_name, '') AS 'activity_demographic_performer_name'
		,		ISNULL(A.performer_email, '') AS 'activity_demographic_performer_email'
		,		ISNULL(LTRIM(RTRIM(A.sale_type_description)), '') AS 'contact_completion_sale_type_description'
		,		ISNULL(B.activity_id, '') AS 'brochure_activity_id'
		,		ISNULL(CONVERT(VARCHAR(11), B.creation_date, 101), '') AS 'brochure_activity_creation_date'
		,		ISNULL(LTRIM(RTRIM(B.action_code)), '') AS 'brochure_activity_action_code'
		,		ISNULL(LTRIM(RTRIM(B.result_code)), '') AS 'brochure_activity_result_code'
		,       ISNULL(LTRIM(RTRIM(B.source_code)), '') AS 'brochure_activity_source_code'
		,		ISNULL(CONVERT(VARCHAR(11), B.due_date, 101), '') AS 'brochure_activity_due_date'
		,       ISNULL(CONVERT(VARCHAR(15),CAST(B.start_time AS TIME), 100), '') AS 'brochure_activity_start_time'
		,		ISNULL(CONVERT(VARCHAR(11), B.completion_date, 101), '') AS 'brochure_activity_completion_date'
		,       ISNULL(CONVERT(VARCHAR(15),CAST(B.completion_time AS TIME), 100), '') AS 'brochure_activity_completion_time'
		,		ISNULL(REPLACE(LA.[MOSAIC HOUSEHOLD], '""', ''), '') AS 'Mosaic_Household'
		,		ISNULL(MG_H.MosaicGroupID + ' - ' + MG_H.MosaicGroupDescription, '') AS 'Mosaic_Household_Group'
		,		ISNULL(MT_H.MosaicTypeID + ' - ' + MT_H.MosaicTypeDescription, '') AS 'Mosaic_Household_Type'
		,		ISNULL(REPLACE(LA.ZIP_4, '""', ''), '') AS 'Mosaic_Zip'
		,		ISNULL(MG_Z.MosaicGroupID + ' - ' + MG_Z.MosaicGroupDescription, '') AS 'Mosaic_Zip_Group'
		,		ISNULL(MT_Z.MosaicTypeID + ' - ' + MT_Z.MosaicTypeDescription, '') AS 'Mosaic_Zip_Type'
		,		ISNULL(REPLACE(LA.GENDER, '""', ''), '') AS 'Mosaic_Gender'
		,		ISNULL(REPLACE(LA.[COMBINED AGE], '""', ''), '') AS 'Mosaic_Combined_Age'
		,		ISNULL(REPLACE(LA.[EDUCATION MODEL], '""', ''), '') AS 'Mosaic_Education_Model'
		,		ISNULL(REPLACE(LA.[MARITAL STATUS], '""', ''), '') AS 'Mosaic_Marital_Status'
		,		ISNULL(REPLACE(LA.[OCCUPATION GROUP V2], '""', ''), '') AS 'Mosaic_Occupation_Group_V2'
		,		ISNULL(REPLACE(LA.LATITUDE, '""', ''), '') AS 'Mosaic_Latitude'
		,		ISNULL(REPLACE(LA.LONGITUDE, '""', ''), '') AS 'Mosaic_Longitude'
		,		ISNULL(REPLACE(LA.[MATCH LEVEL FOR GEO DATA], '""', ''), '') AS 'Mosaic_Match_Level_For_Geo_Data'
		,		ISNULL(REPLACE(LA.[EST HOUSEHOLD INCOME V5], '""', ''), '') AS 'Mosaic_Est_Household_Income_V5'
		,		ISNULL(REPLACE(LA.[NCOA MOVE UPDATE CODE], '""', ''), '') AS 'Mosaic_NCOA_Move_Update_Code'
		,		ISNULL(REPLACE(LA.[MAIL RESPONDER], '""', ''), '') AS 'Mosaic_Mail_Responder'
		,		ISNULL(REPLACE(LA.[MOR BANK_ UPSCALE MERCHANDISE BUYER], '""', ''), '') AS 'Mosaic_MOR_Bank_Upscale_Merchandise_Buyer'
		,		ISNULL(REPLACE(LA.[MOR BANK_ HEALTH AND FITNESS MAGAZINE], '""', ''), '') AS 'Mosaic_MOR_Bank_Health_And_Fitness_Magazine'
		,		ISNULL(REPLACE(LA.[CAPE_ ETHNIC_ POP_ _ WHITE ONLY], '""', ''), '') AS 'Mosaic_Cape_Ethnic_Pop_White_Only'
		,		ISNULL(REPLACE(LA.[CAPE_ ETHNIC_ POP_ _ BLACK ONLY], '""', ''), '') AS 'Mosaic_Cape_Ethnic_Pop_Black_Only'
		,		ISNULL(REPLACE(LA.[CAPE_ ETHNIC_ POP_ _ ASIAN ONLY], '""', ''), '') AS 'Mosaic_Cape_Ethnic_Pop_Asian_Only'
		,		ISNULL(REPLACE(LA.[CAPE_ ETHNIC_ POP_ _ HISPANIC], '""', ''), '') AS 'Mosaic_Cape_Ethnic_Pop_Hispanic'
		,		ISNULL(REPLACE(LA.[CAPE_ LANG_ HH_ _ SPANISH SPEAKING], '""', ''), '') AS 'Mosaic_Cape_Lang_HH_Spanish_Speaking'
		,		ISNULL(REPLACE(LA.[CAPE_ INC_ HH_ MEDIAN FAMILY HOUSEHOLD INCOME], '""', ''), '') AS 'Mosaic_Cape_INC_HH_Median_Family_Household_Income'
		,		ISNULL(REPLACE(LA.MatchStatus, '""', ''), '') AS 'Mosaic_MatchStatus'
		,		ISNULL(REPLACE(LA.CE_Selected_Individual_Vendor_Ethnicity_Code, '""', ''), '') AS 'Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code'
		,		ISNULL(REPLACE(LA.CE_Selected_Individual_Vendor_Ethnic_Group_Code, '""', ''), '') AS 'Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code'
		,		ISNULL(REPLACE(LA.CE_Selected_Individual_Vendor_Spoken_Language_Code, '""', ''), '') AS 'Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code'
		,		OC.creation_date AS 'CreateDate'
		,		'LD-Export' AS 'CreateUser'
		,		OC.updated_date AS 'LastUpdate'
		,		'LD-Export' AS 'LastUpdateUser'
		FROM    #UpdatedLeads UL
				INNER JOIN HCM.dbo.oncd_contact OC WITH ( NOLOCK )
					ON OC.contact_id = UL.contact_id
				INNER JOIN HCM.dbo.oncd_contact_company OCC WITH ( NOLOCK )
					ON OCC.contact_id = OC.contact_id
						AND OCC.primary_flag = 'Y'
				INNER JOIN HCM.dbo.oncd_company COM WITH ( NOLOCK )
					ON COM.company_id = OCC.company_id
						AND COM.company_status_code = 'ACTIVE'
				INNER JOIN #Centers C
					ON C.CenterSSID = COM.cst_center_number
				LEFT OUTER JOIN HCM.dbo.oncd_contact_source OCS WITH ( NOLOCK )
					ON OCS.contact_id = OC.contact_id
						AND OCS.primary_flag = 'Y'
				LEFT OUTER JOIN BOSMarketing.dbo.MediaSourceSources MSS
					ON MSS.SourceCode = OCS.source_code
				LEFT OUTER JOIN BOSMarketing.dbo.MediaSourceMediaTypes MSMT
					ON MSMT.MediaID = MSS.MediaID
				LEFT OUTER JOIN BOSMarketing.dbo.MediaSourceLevel04 MSL
					ON MSL.Level04ID = MSS.Level04ID
				LEFT OUTER JOIN HCM.dbo.oncd_contact_address OCA WITH ( NOLOCK )
					ON OCA.contact_id = OC.contact_id
						AND OCA.primary_flag = 'Y'
				LEFT OUTER JOIN HCM.dbo.oncd_contact_email OCE WITH ( NOLOCK )
					ON OCE.contact_id = OC.contact_id
						AND OCE.primary_flag = 'Y'
				LEFT OUTER JOIN HCM.dbo.oncd_contact_phone OCP WITH ( NOLOCK )
					ON OCP.contact_id = OC.contact_id
						AND OCP.primary_flag = 'Y'
				LEFT OUTER JOIN HCM.dbo.csta_contact_age_range CCAR WITH ( NOLOCK )
					ON CCAR.age_range_code = OC.cst_age_range_code
				LEFT OUTER JOIN HCM.dbo.cstd_contact_marketing_score CMS WITH ( NOLOCK )
					ON CMS.contact_id = OC.contact_id
				LEFT OUTER JOIN HC_DataAppend.dbo.Lead_Append LA WITH ( NOLOCK )
					ON LA.contact_id = OC.contact_id
				LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicType MT_H WITH ( NOLOCK )
					ON MT_H.MosaicTypeID = LA.[MOSAIC HOUSEHOLD]
				LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicGroup MG_H WITH ( NOLOCK )
					ON MG_H.MosaicGroupID = MT_H.MosaicGroupID
				LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicType MT_Z WITH ( NOLOCK )
					ON MT_Z.MosaicTypeID = LA.[MOSAIC ZIP4]
				LEFT OUTER JOIN HC_DataAppend.dbo.lkpMosaicGroup MG_Z WITH ( NOLOCK )
					ON MG_Z.MosaicGroupID = MT_Z.MosaicGroupID
				OUTER APPLY ( SELECT TOP 1
										OA_A.activity_id
							  ,         OAC_A.contact_id
							  ,			CASE WHEN MT.[action] = 'OPTIN' AND ( MT.[status] IS NULL OR LTRIM(RTRIM(ISNULL(MT.[status], ''))) = '' ) THEN 'Yes' ELSE 'No' END AS 'can_confirm_appointment_by_text'
							  ,         OA_A.creation_date
							  ,         OA_A.action_code
							  ,         OA_A.result_code
							  ,         OA_A.source_code
							  ,         OA_A.due_date
							  ,         OA_A.start_time
							  ,         OA_A.completion_date
							  ,         OA_A.completion_time
							  ,         CAD.birthday
							  ,         CAD.disc_style
							  ,         CAD.ethnicity_code
							  ,         CCE.description AS 'ethnicity_description'
							  ,         CAD.ludwig
							  ,         CAD.maritalstatus_code
							  ,         CCM.description AS 'maritalstatus_description'
							  ,         CAD.no_sale_reason
							  ,         CAD.norwood
							  ,         CAD.occupation_code
							  ,         CCO.description AS 'occupation_description'
							  ,         CAD.price_quoted
							  ,         CAD.solution_offered
							  ,         CAD.performer
							  ,         CASE WHEN DE.UserLogin IS NULL THEN ''
											 ELSE DE.EmployeeInitials
										END AS 'performer_initials'
							  ,         CASE WHEN DE.UserLogin IS NULL THEN ''
											 ELSE DE.EmployeeFirstName + ' ' + DE.EmployeeLastName
										END AS 'performer_name'
							  ,         CASE WHEN DE.UserLogin IS NULL THEN ''
											 ELSE DE.UserLogin + '@hcfm.com'
										END AS 'performer_email'
							  ,         CCC.sale_type_description
							  FROM      HCM.dbo.oncd_activity OA_A WITH ( NOLOCK )
										INNER JOIN HCM.dbo.oncd_activity_contact OAC_A WITH ( NOLOCK )
											ON OAC_A.activity_id = OA_A.activity_id
										LEFT OUTER JOIN HCM.dbo.cstd_text_msg_temp MT WITH ( NOLOCK ) -- Text Message Reminder Opt-In
											ON MT.appointment_activity_id = OA_A.activity_id
												AND MT.contact_id = OAC_A.contact_id
										LEFT OUTER JOIN HCM.dbo.cstd_activity_demographic CAD WITH ( NOLOCK )
											ON CAD.activity_id = OA_A.activity_id
										LEFT OUTER JOIN HCM.dbo.cstd_contact_completion CCC WITH ( NOLOCK )
											ON CCC.activity_id = OA_A.activity_id
										LEFT OUTER JOIN HCM.dbo.csta_contact_ethnicity CCE WITH ( NOLOCK )
											ON CCE.ethnicity_code = CAD.ethnicity_code
										LEFT OUTER JOIN HCM.dbo.csta_contact_maritalstatus CCM WITH ( NOLOCK )
											ON CCM.maritalstatus_code = CAD.maritalstatus_code
										LEFT OUTER JOIN HCM.dbo.csta_contact_occupation CCO WITH ( NOLOCK )
											ON CCO.occupation_code = CAD.occupation_code
										LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE WITH ( NOLOCK )
											ON DE.EmployeeFullName = LTRIM(RTRIM(CAD.performer))
							  WHERE     OA_A.action_code IN ( 'APPOINT', 'BEBACK', 'INHOUSE' )
										AND ISNULL(OA_A.result_code, '') NOT IN ( 'CTREXCPTN' )
										AND OAC_A.contact_id = OC.contact_id
							  ORDER BY  CAST(OA_A.due_date AS DATE) DESC
							  ,		CONVERT(DATETIME, OA_A.start_time, 114) DESC
							) A
				OUTER APPLY ( SELECT TOP 1
										OA_B.activity_id
							  ,         OAC_B.contact_id
							  ,         OA_B.creation_date
							  ,         OA_B.action_code
							  ,         OA_B.result_code
							  ,         OA_B.source_code
							  ,         OA_B.due_date
							  ,         OA_B.start_time
							  ,         OA_B.completion_date
							  ,         OA_B.completion_time
							  FROM      HCM.dbo.oncd_activity OA_B WITH ( NOLOCK )
										INNER JOIN HCM.dbo.oncd_activity_contact OAC_B WITH ( NOLOCK )
											ON OAC_B.activity_id = OA_B.activity_id
							  WHERE     OA_B.action_code IN ( 'BROCHCALL' )
										AND ISNULL(OA_B.result_code, '') NOT IN ( 'CTREXCPTN' )
										AND OAC_B.contact_id = OC.contact_id
							  ORDER BY  CAST(OA_B.due_date AS DATE) DESC
							  ,		CONVERT(DATETIME, OA_B.start_time, 114) DESC
							) B


/********************************** Insert Lead Details *************************************/
INSERT  INTO datLeadExport (
			ExportHeaderID
        ,	contact_contact_id
        ,	contact_first_name
        ,	contact_last_name
        ,	contact_address_address_id
        ,	contact_address_address_line_1
        ,	contact_address_address_line_2
        ,	contact_address_city
        ,	contact_address_state_code
        ,	contact_address_zip_code
        ,	contact_address_country_code
        ,	contact_address_time_zone_code
        ,	contact_address_valid_flag
        ,	contact_phone_phone_id
        ,	contact_phone_phone_number
        ,	contact_phone_valid_flag
        ,	contact_email_email_id
        ,	contact_email_email
        ,	contact_email_valid_flag
        ,	contact_gender_code
        ,	contact_age
        ,	contact_age_range_code
        ,	contact_age_range
        ,	contact_dnc_date
        ,	contact_hair_loss_code
        ,	contact_hair_loss_experience_code
        ,	contact_hair_loss_family_code
        ,	contact_hair_loss_in_family_code
        ,	contact_hair_loss_product
        ,	contact_hair_loss_spot_code
        ,	contact_language_code
        ,	contact_promotion_code
        ,	contact_source_source_code
        ,	contact_source_source_media
        ,	contact_source_source_format
        ,	contact_contact_siebel_id
        ,	contact_do_not_email
        ,	contact_do_not_mail
        ,	contact_do_not_call
        ,	contact_do_not_solicit
        ,	contact_do_not_text
        ,	contact_creation_date
        ,	contact_contact_status_code
        ,	contact_marketing_score
        ,	company_company_id
        ,	company_center_number
        ,	company_company_name
        ,	company_address_line_1
        ,	company_address_line_2
        ,	company_city
        ,	company_state_code
        ,	company_zip_code
        ,	company_country_code
        ,	company_center_type
        ,	company_center_region_number
        ,	company_center_region_name
        ,	company_center_phone_number
        ,	company_center_managing_director
        ,	company_center_managing_director_email
		,	appointment_activity_id
		,	can_confirm_appointment_by_text
        ,	appointment_activity_creation_date
        ,	appointment_activity_action_code
        ,	appointment_activity_result_code
        ,	appointment_activity_source_code
        ,	appointment_activity_due_date
        ,	appointment_activity_start_time
        ,	appointment_activity_completion_date
        ,	appointment_activity_completion_time
        ,	activity_demographic_birthday
        ,	activity_demographic_disc_style
        ,	activity_demographic_ethnicity_code
        ,	activity_demographic_ethnicity
        ,	activity_demographic_ludwig
        ,	activity_demographic_maritalstatus_code
        ,	activity_demographic_maritalstatus
        ,	activity_demographic_no_sale_reason
        ,	activity_demographic_norwood
        ,	activity_demographic_occupation_code
        ,	activity_demographic_occupation
        ,	activity_demographic_price_quoted
        ,	activity_demographic_solution_offered
        ,	activity_demographic_performer
        ,	activity_demographic_performer_name
        ,	activity_demographic_performer_email
        ,	contact_completion_sale_type_description
		,	brochure_activity_id
        ,	brochure_activity_creation_date
        ,	brochure_activity_action_code
        ,	brochure_activity_result_code
        ,	brochure_activity_source_code
        ,	brochure_activity_due_date
        ,	brochure_activity_start_time
        ,	brochure_activity_completion_date
        ,	brochure_activity_completion_time
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
        ,	CreateDate
        ,	CreateUser
        ,	LastUpdate
        ,	LastUpdateUser
		)
        SELECT  L.ExportHeaderID
        ,       L.contact_contact_id
        ,       L.contact_first_name
        ,       L.contact_last_name
        ,       L.contact_address_address_id
        ,       L.contact_address_address_line_1
        ,       L.contact_address_address_line_2
        ,       L.contact_address_city
        ,       L.contact_address_state_code
        ,       L.contact_address_zip_code
        ,       L.contact_address_country_code
        ,       L.contact_address_time_zone_code
        ,       L.contact_address_valid_flag
        ,       L.contact_phone_phone_id
        ,       L.contact_phone_phone_number
        ,       L.contact_phone_valid_flag
        ,       L.contact_email_email_id
        ,       L.contact_email_email
        ,       L.contact_email_valid_flag
        ,       L.contact_gender_code
        ,       L.contact_age
        ,       L.contact_age_range_code
        ,       L.contact_age_range
        ,       L.contact_dnc_date
        ,       L.contact_hair_loss_code
        ,       L.contact_hair_loss_experience_code
        ,       L.contact_hair_loss_family_code
        ,       L.contact_hair_loss_in_family_code
        ,       L.contact_hair_loss_product
        ,       L.contact_hair_loss_spot_code
        ,       L.contact_language_code
        ,       L.contact_promotion_code
        ,       L.contact_source_source_code
        ,       L.contact_source_source_media
        ,       L.contact_source_source_format
        ,       L.contact_contact_siebel_id
        ,       L.contact_do_not_email
        ,       L.contact_do_not_mail
        ,       L.contact_do_not_call
        ,       L.contact_do_not_solicit
        ,       L.contact_do_not_text
        ,       L.contact_creation_date
        ,       L.contact_contact_status_code
        ,       L.contact_marketing_score
        ,       L.company_company_id
        ,       L.company_center_number
        ,       L.company_company_name
        ,       L.company_address_line_1
        ,       L.company_address_line_2
        ,       L.company_city
        ,       L.company_state_code
        ,       L.company_zip_code
        ,       L.company_country_code
        ,       L.company_center_type
        ,       L.company_center_region_number
        ,       L.company_center_region_name
        ,       L.company_center_phone_number
        ,       L.company_center_managing_director
        ,       L.company_center_managing_director_email
		,		L.appointment_activity_id
		,		L.can_confirm_appointment_by_text
        ,       L.appointment_activity_creation_date
        ,       L.appointment_activity_action_code
        ,       L.appointment_activity_result_code
        ,       L.appointment_activity_source_code
        ,       L.appointment_activity_due_date
        ,       L.appointment_activity_start_time
        ,       L.appointment_activity_completion_date
        ,       L.appointment_activity_completion_time
        ,       L.activity_demographic_birthday
        ,       L.activity_demographic_disc_style
        ,       L.activity_demographic_ethnicity_code
        ,       L.activity_demographic_ethnicity
        ,       L.activity_demographic_ludwig
        ,       L.activity_demographic_maritalstatus_code
        ,       L.activity_demographic_maritalstatus
        ,       L.activity_demographic_no_sale_reason
        ,       L.activity_demographic_norwood
        ,       L.activity_demographic_occupation_code
        ,       L.activity_demographic_occupation
        ,       L.activity_demographic_price_quoted
        ,       L.activity_demographic_solution_offered
        ,       L.activity_demographic_performer
        ,       L.activity_demographic_performer_name
        ,       L.activity_demographic_performer_email
        ,       L.contact_completion_sale_type_description
		,		L.brochure_activity_id
        ,       L.brochure_activity_creation_date
        ,       L.brochure_activity_action_code
        ,       L.brochure_activity_result_code
        ,       L.brochure_activity_source_code
        ,       L.brochure_activity_due_date
        ,       L.brochure_activity_start_time
        ,       L.brochure_activity_completion_date
        ,       L.brochure_activity_completion_time
        ,       L.Mosaic_Household
        ,       L.Mosaic_Household_Group
        ,       L.Mosaic_Household_Type
        ,       L.Mosaic_Zip
        ,       L.Mosaic_Zip_Group
        ,       L.Mosaic_Zip_Type
        ,       L.Mosaic_Gender
        ,       L.Mosaic_Combined_Age
        ,       L.Mosaic_Education_Model
        ,       L.Mosaic_Marital_Status
        ,       L.Mosaic_Occupation_Group_V2
        ,       L.Mosaic_Latitude
        ,       L.Mosaic_Longitude
        ,       L.Mosaic_Match_Level_For_Geo_Data
        ,       L.Mosaic_Est_Household_Income_V5
        ,       L.Mosaic_NCOA_Move_Update_Code
        ,       L.Mosaic_Mail_Responder
        ,       L.Mosaic_MOR_Bank_Upscale_Merchandise_Buyer
        ,       L.Mosaic_MOR_Bank_Health_And_Fitness_Magazine
        ,       L.Mosaic_Cape_Ethnic_Pop_White_Only
        ,       L.Mosaic_Cape_Ethnic_Pop_Black_Only
        ,       L.Mosaic_Cape_Ethnic_Pop_Asian_Only
        ,       L.Mosaic_Cape_Ethnic_Pop_Hispanic
        ,       L.Mosaic_Cape_Lang_HH_Spanish_Speaking
        ,       L.Mosaic_Cape_INC_HH_Median_Family_Household_Income
        ,       L.Mosaic_MatchStatus
        ,       L.Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code
        ,       L.Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code
        ,       L.Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code
        ,       ISNULL(L.CreateDate, GETDATE())
        ,       L.CreateUser
        ,       ISNULL(L.LastUpdate, GETDATE())
        ,       L.LastUpdateUser
        FROM    #Leads L

END
GO
