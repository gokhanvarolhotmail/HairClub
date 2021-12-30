/* CreateDate: 07/08/2016 09:49:07.030 , ModifyDate: 04/24/2017 10:50:37.720 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BulkLeadsExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HCM
RELATED APPLICATION:	Responsys Export
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/08/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BulkLeadsExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BulkLeadsExport]
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


/********************************** Set Dates  *************************************/
DECLARE	@StartDate DATETIME
,		@EndDate DATETIME


SET @StartDate = '7/1/2016'
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


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
,		ISNULL(LTRIM(RTRIM(OC.cst_siebel_id)), '') AS 'contact_contact_siebel_id'
,       ISNULL(LTRIM(RTRIM(OC.cst_do_not_email)), '') AS 'contact_do_not_email'
,       ISNULL(LTRIM(RTRIM(OC.cst_do_not_mail)), '') AS 'contact_do_not_mail'
,       ISNULL(LTRIM(RTRIM(OC.cst_do_not_call)), '') AS 'contact_do_not_call'
,       ISNULL(LTRIM(RTRIM(OC.do_not_solicit)), '') AS 'contact_do_not_solicit'
,		ISNULL(LTRIM(RTRIM(OC.cst_do_not_text)), '') AS 'contact_do_not_text'
,       ISNULL(CONVERT(VARCHAR(11), OC.creation_date, 101), '') AS 'contact_creation_date'
,		LTRIM(RTRIM(OC.contact_status_code)) AS 'contact_contact_status_code'
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
FROM    dbo.oncd_contact OC WITH ( NOLOCK )
        INNER JOIN dbo.oncd_contact_company OCC WITH ( NOLOCK )
            ON OCC.contact_id = OC.contact_id
				AND OCC.primary_flag = 'Y'
        INNER JOIN dbo.oncd_company COM WITH ( NOLOCK )
            ON COM.company_id = OCC.company_id
				AND COM.company_status_code = 'ACTIVE'
        INNER JOIN @Centers CTR
            ON COM.cst_center_number = CTR.CenterSSID
        INNER JOIN dbo.oncd_contact_address OCA WITH ( NOLOCK )
            ON OCA.contact_id = OC.contact_id
                AND OCA.primary_flag = 'Y'
        LEFT OUTER JOIN dbo.oncd_contact_source OCS WITH ( NOLOCK )
            ON OCS.contact_id = OC.contact_id
                AND OCS.primary_flag = 'Y'
        LEFT OUTER JOIN dbo.oncd_contact_email OCE WITH ( NOLOCK )
            ON OCE.contact_id = OC.contact_id
                AND OCE.primary_flag = 'Y'
        LEFT OUTER JOIN dbo.oncd_contact_phone OCP WITH ( NOLOCK )
            ON OCP.contact_id = OC.contact_id
                AND OCP.primary_flag = 'Y'
        LEFT OUTER JOIN dbo.csta_contact_age_range CCAR WITH ( NOLOCK )
            ON CCAR.age_range_code = OC.cst_age_range_code
WHERE   OC.contact_status_code = 'LEAD'
		AND (
				-- Contact has been created or updated
				OC.creation_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				OR OC.updated_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
			)
ORDER BY OC.contact_id

END
GO
