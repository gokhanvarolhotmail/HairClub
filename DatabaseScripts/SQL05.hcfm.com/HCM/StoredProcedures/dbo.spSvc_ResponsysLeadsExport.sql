/* CreateDate: 10/13/2014 14:05:48.080 , ModifyDate: 07/07/2016 16:10:23.597 */
GO
/***********************************************************************
PROCEDURE:				spSvc_ResponsysLeadsExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HCM
RELATED APPLICATION:	Responsys Export
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/13/2014
------------------------------------------------------------------------
NOTES:

10/17/2014 - DL - Added TRIM statements to VARCHAR columns
10/17/2014 - DL - Added REPLACE statement to address columns
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_ResponsysLeadsExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_ResponsysLeadsExport]
(
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Create temp table objects *************************************/
DECLARE @Centers TABLE (
	MainGroupID INT
,	MainGroup NVARCHAR(50)
,	CenterSSID INT
,	CenterDescription NVARCHAR(255)
,	CenterAddress1 NVARCHAR(50)
,	CenterAddress2 NVARCHAR(50)
,	CenterCity NVARCHAR(50)
,	CenterStateCode NVARCHAR(50)
,	CenterZipCode NVARCHAR(50)
,	CenterCountryCode NVARCHAR(50)
,	CenterType NVARCHAR(50)
,	CenterPhoneNumber NVARCHAR(50)
,	ManagingDirector NVARCHAR(102)
,	ManagingDirectorEmail NVARCHAR(50)
,	UNIQUE CLUSTERED (CenterSSID)
)

DECLARE @Contacts TABLE (
	contact_id VARCHAR(10)
)


/********************************** Set Dates If Parameters are NULL *************************************/
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(dd, -7, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, 0, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
   END


/********************************** Get list of centers *************************************/
INSERT  INTO @Centers
		SELECT  DR.RegionSSID
		,		DR.RegionDescription
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		REPLACE(DC.CenterAddress1, ',', '')
		,		REPLACE(DC.CenterAddress2, ',', '')
		,		DC.City
		,		DC.StateProvinceDescriptionShort
		,		DC.PostalCode
		,		DC.CountryRegionDescriptionShort
		,		DCT.CenterTypeDescriptionShort
		,		DC.CenterPhone1
		,		ISNULL(CMD.ManagingDirector, '') AS 'ManagingDirector'
		,		ISNULL(CMD.ManagingDirectorEmail, '') AS 'ManagingDirectorEmail'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionKey
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
		WHERE   DCT.CenterTypeDescriptionShort = 'C'
				AND DC.Active = 'Y'
		ORDER BY DR.RegionDescription
		,       DC.CenterSSID


INSERT  INTO @Centers
		SELECT  DR.RegionSSID
		,		DR.RegionDescription
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		REPLACE(DC.CenterAddress1, ',', '')
		,		REPLACE(DC.CenterAddress2, ',', '')
		,		DC.City
		,		DC.StateProvinceDescriptionShort
		,		DC.PostalCode
		,		DC.CountryRegionDescriptionShort
		,		DCT.CenterTypeDescriptionShort
		,		DC.CenterPhone1
		,		ISNULL(CMD.ManagingDirector, '') AS 'ManagingDirector'
		,		ISNULL(CMD.ManagingDirectorEmail, '') AS 'ManagingDirectorEmail'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
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
		WHERE   DCT.CenterTypeDescriptionShort IN ( 'F', 'JV' )
				AND DC.Active = 'Y'
		ORDER BY DR.RegionDescription
		,       DC.CenterSSID


/********************************** Get list of Leads *************************************/
INSERT	INTO @Contacts
		-- Leads who have been created or updated within Time Period
		SELECT	DISTINCT
				OC.contact_id
		FROM    dbo.oncd_contact OC WITH ( NOLOCK )
				INNER JOIN dbo.oncd_contact_company OCC WITH ( NOLOCK )
					ON OCC.contact_id = OC.contact_id
						AND OCC.primary_flag = 'Y'
				INNER JOIN dbo.oncd_contact_source OCS WITH ( NOLOCK )
					ON OCS.contact_id = OC.contact_id
						AND OCS.primary_flag = 'Y'
				LEFT OUTER JOIN dbo.oncd_contact_address OCA WITH ( NOLOCK )
					ON OCA.contact_id = OC.contact_id
						AND OCA.primary_flag = 'Y'
				LEFT OUTER JOIN dbo.oncd_contact_email OCE WITH ( NOLOCK )
					ON OCE.contact_id = OC.contact_id
						AND OCE.primary_flag = 'Y'
				LEFT OUTER JOIN dbo.oncd_contact_phone OCP WITH ( NOLOCK )
					ON OCP.contact_id = OC.contact_id
						AND OCP.primary_flag = 'Y'
		WHERE   OC.contact_status_code = 'LEAD'
				AND (
						-- Contact has been created or updated
						OC.creation_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
						OR OC.updated_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'

						-- Contact Company has been created or updated
						OR OCC.creation_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
						OR OCC.updated_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'

						-- Contact Source has been created or updated
						OR OCS.creation_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
						OR OCS.updated_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'

						---- Contact Address has been created or updated
						OR OCA.creation_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
						OR OCA.updated_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'

						-- Contact Email has been created or updated
						OR OCE.creation_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
						OR OCE.updated_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'

						-- Contact Phone Number has been created or updated
						--OR OCP.creation_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
						--OR OCP.updated_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
					)

		UNION

		-- Leads who have had an activity created or updated within Time Period
		SELECT  DISTINCT
				OAC.contact_id
		FROM    dbo.oncd_activity OA WITH (NOLOCK)
				INNER JOIN dbo.oncd_activity_contact OAC WITH ( NOLOCK )
					ON OAC.activity_id = OA.activity_id
		WHERE   OA.action_code IN ( 'BROCHCALL', 'APPOINT', 'BEBACK', 'INHOUSE' )
				AND ( OA.creation_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
						OR OA.updated_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
						OR OA.due_date BETWEEN @StartDate AND @EndDate
						OR OA.completion_date BETWEEN @StartDate AND @EndDate )
				AND OAC.contact_id <> 'WUGO7OD6W1'


/********************************** Get Export Data *************************************/
SELECT  LTRIM(RTRIM(OC.contact_id)) AS 'contact_contact_id'
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
,       CTR.CenterSSID AS 'company_center_number'
,       CTR.CenterDescription AS 'company_company_name'
,       ISNULL(LTRIM(RTRIM(REPLACE(CTR.CenterAddress1, ',', ''))), '') AS 'company_address_line_1'
,       ISNULL(LTRIM(RTRIM(REPLACE(CTR.CenterAddress2, ',', ''))), '') AS 'company_address_line_2'
,       CTR.CenterCity AS 'company_city'
,       CTR.CenterStateCode AS 'company_state_code'
,       CTR.CenterZipCode AS 'company_zip_code'
,       CTR.CenterCountryCode AS 'company_country_code'
,       CTR.CenterType AS 'company_center_type'
,		CTR.MainGroupID AS 'company_center_region_number'
,		CTR.MainGroup AS 'company_center_region_name'
,       CTR.CenterPhoneNumber AS 'company_center_phone_number'
,       LTRIM(RTRIM(REPLACE(CTR.ManagingDirector, ',', ''))) AS 'company_center_managing_director'
,       LTRIM(RTRIM(REPLACE(CTR.ManagingDirectorEmail, ',', ''))) AS 'company_center_managing_director_email'
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
,		ISNULL(CONVERT(VARCHAR(11), B.creation_date, 101), '') AS 'brochure_activity_creation_date'
,		ISNULL(LTRIM(RTRIM(B.action_code)), '') AS 'brochure_activity_action_code'
,		ISNULL(LTRIM(RTRIM(B.result_code)), '') AS 'brochure_activity_result_code'
,       ISNULL(LTRIM(RTRIM(B.source_code)), '') AS 'brochure_activity_source_code'
,		ISNULL(CONVERT(VARCHAR(11), B.due_date, 101), '') AS 'brochure_activity_due_date'
,       ISNULL(CONVERT(VARCHAR(15),CAST(B.start_time AS TIME), 100), '') AS 'brochure_activity_start_time'
,		ISNULL(CONVERT(VARCHAR(11), B.completion_date, 101), '') AS 'brochure_activity_completion_date'
,       ISNULL(CONVERT(VARCHAR(15),CAST(B.completion_time AS TIME), 100), '') AS 'brochure_activity_completion_time'
FROM    dbo.oncd_contact OC WITH ( NOLOCK )
        INNER JOIN @Contacts CON
            ON CON.contact_id = OC.contact_id
        INNER JOIN dbo.oncd_contact_company OCC WITH ( NOLOCK )
            ON OCC.contact_id = OC.contact_id
				AND OCC.primary_flag = 'Y'
        INNER JOIN dbo.oncd_company COM WITH ( NOLOCK )
            ON COM.company_id = OCC.company_id
				AND COM.company_status_code = 'ACTIVE'
        INNER JOIN @Centers CTR
            ON COM.cst_center_number = CTR.CenterSSID
        LEFT OUTER JOIN dbo.oncd_contact_source OCS WITH ( NOLOCK )
            ON OCS.contact_id = OC.contact_id
                AND OCS.primary_flag = 'Y'
        LEFT OUTER JOIN BOSMarketing.dbo.MediaSourceSources MSS
            ON MSS.SourceCode = OCS.source_code
        LEFT OUTER JOIN BOSMarketing.dbo.MediaSourceMediaTypes MSMT
            ON MSMT.MediaID = MSS.MediaID
        LEFT OUTER JOIN BOSMarketing.dbo.MediaSourceLevel04 MSL
            ON MSL.Level04ID = MSS.Level04ID
        LEFT OUTER JOIN dbo.oncd_contact_address OCA WITH ( NOLOCK )
            ON OCA.contact_id = OC.contact_id
                AND OCA.primary_flag = 'Y'
        LEFT OUTER JOIN dbo.oncd_contact_email OCE WITH ( NOLOCK )
            ON OCE.contact_id = OC.contact_id
                AND OCE.primary_flag = 'Y'
        LEFT OUTER JOIN dbo.oncd_contact_phone OCP WITH ( NOLOCK )
            ON OCP.contact_id = OC.contact_id
                AND OCP.primary_flag = 'Y'
        LEFT OUTER JOIN dbo.csta_contact_age_range CCAR WITH ( NOLOCK )
            ON CCAR.age_range_code = OC.cst_age_range_code
        LEFT OUTER JOIN dbo.cstd_contact_marketing_score CMS WITH ( NOLOCK )
            ON CMS.contact_id = OC.contact_id
        OUTER APPLY ( SELECT TOP 1
                                OA.activity_id
                      ,         OAC.contact_id
                      ,         OA.creation_date
                      ,         OA.action_code
                      ,         OA.result_code
                      ,         OA.source_code
                      ,         OA.due_date
                      ,         OA.start_time
                      ,         OA.completion_date
                      ,         OA.completion_time
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
                      FROM      dbo.oncd_activity OA WITH ( NOLOCK )
                                INNER JOIN dbo.oncd_activity_contact OAC WITH ( NOLOCK )
                                    ON OAC.activity_id = OA.activity_id
                                LEFT OUTER JOIN dbo.cstd_activity_demographic CAD WITH ( NOLOCK )
                                    ON CAD.activity_id = OA.activity_id
                                LEFT OUTER JOIN dbo.cstd_contact_completion CCC WITH ( NOLOCK )
                                    ON CCC.activity_id = OA.activity_id
                                LEFT OUTER JOIN dbo.csta_contact_ethnicity CCE WITH ( NOLOCK )
                                    ON CCE.ethnicity_code = CAD.ethnicity_code
                                LEFT OUTER JOIN dbo.csta_contact_maritalstatus CCM WITH ( NOLOCK )
                                    ON CCM.maritalstatus_code = CAD.maritalstatus_code
                                LEFT OUTER JOIN dbo.csta_contact_occupation CCO WITH ( NOLOCK )
                                    ON CCO.occupation_code = CAD.occupation_code
                                LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
                                    ON DE.EmployeeFullName = LTRIM(RTRIM(CAD.performer))
                      WHERE     OA.action_code IN ( 'APPOINT', 'BEBACK', 'INHOUSE' )
                                AND OAC.contact_id = OC.contact_id
                      ORDER BY  CONVERT(DATETIME, OA.due_date, 108) + CONVERT(DATETIME, OA.start_time, 114) DESC
                    ) A
        OUTER APPLY ( SELECT TOP 1
                                OA.activity_id
                      ,         OAC.contact_id
                      ,         OA.creation_date
                      ,         OA.action_code
                      ,         OA.result_code
                      ,         OA.source_code
                      ,         OA.due_date
                      ,         OA.start_time
                      ,         OA.completion_date
                      ,         OA.completion_time
                      FROM      dbo.oncd_activity OA WITH ( NOLOCK )
                                INNER JOIN dbo.oncd_activity_contact OAC WITH ( NOLOCK )
                                    ON OAC.activity_id = OA.activity_id
                      WHERE     OA.action_code IN ( 'BROCHCALL' )
                                AND OAC.contact_id = OC.contact_id
                      ORDER BY  CONVERT(DATETIME, OA.due_date, 108) + CONVERT(DATETIME, OA.start_time, 114) DESC
                    ) B
ORDER BY OC.contact_id

END
GO
