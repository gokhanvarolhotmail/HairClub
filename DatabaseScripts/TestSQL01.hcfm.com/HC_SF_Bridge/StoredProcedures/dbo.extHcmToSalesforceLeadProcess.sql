/* CreateDate: 11/28/2017 17:09:41.237 , ModifyDate: 11/13/2018 14:47:19.490 */
GO
/***********************************************************************
PROCEDURE:				extHcmToSalesforceLeadProcess
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_SF_Bridge
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/27/2017
DESCRIPTION:			11/27/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHcmToSalesforceLeadProcess 0
EXEC extHcmToSalesforceLeadProcess 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extHcmToSalesforceLeadProcess]
(
	@IsManual BIT
)
AS
BEGIN

DECLARE @CreationDate DATETIME
DECLARE @DueDate DATETIME
DECLARE @Yesterday DATETIME
DECLARE @StartTime TIME


DECLARE @DistinctLead AS TABLE (
	ID INT NOT NULL IDENTITY(1, 1)
,	ContactID NCHAR(10)
,	UNIQUE CLUSTERED ( ContactID )
)


DECLARE @Lead AS TABLE (
	ID INT NOT NULL IDENTITY(1, 1)
,	contact_id NVARCHAR(10)
,	center_id NVARCHAR(18)
,	cst_gender_code NVARCHAR(10)
,	first_name NVARCHAR(50)
,	middle_name NVARCHAR(50)
,	last_name NVARCHAR(50)
,	birthday DATETIME
,	cst_do_not_mail NVARCHAR(1)
,	cst_do_not_text NVARCHAR(1)
,	cst_do_not_call NVARCHAR(1)
,	cst_do_not_email NVARCHAR(1)
,	cst_hair_loss_experience_code NVARCHAR(10)
,	cst_language_code NVARCHAR(10)
,	salutation_code NVARCHAR(10)
,	cst_hair_loss_product NVARCHAR(50)
,	cst_hair_loss_spot_code NVARCHAR(10)
,	cst_hair_loss_family_code NVARCHAR(10)
,	suffix NVARCHAR(50)
,	Address NVARCHAR(255)
,	city NVARCHAR(60)
,	zip_code NVARCHAR(15)
,	country_code NVARCHAR(20)
,	state_code NVARCHAR(20)
,	phone_type_code NVARCHAR(10)
,	area_code NVARCHAR(10)
,	phone_number NVARCHAR(20)
,	email NVARCHAR(100)
,	contact_status_code NVARCHAR(10)
,	creation_date DATETIME
,	updated_date DATETIME
,	cst_contact_accomodation_code NVARCHAR(10)
,	cst_age INT
,	cst_age_range_code NVARCHAR(10)
,	cst_promotion_code NVARCHAR(10)
,	cst_hair_loss_code VARCHAR(10)
,	siebelid NVARCHAR(50)
,	sessionid NVARCHAR(100)
,	affiliateid NVARCHAR(50)
,	user_code NVARCHAR(255)
,	UNIQUE CLUSTERED ( contact_id )
)


SET @CreationDate = '10/30/2017'
SET @DueDate = CAST(GETDATE() AS DATE)
SET @Yesterday = DATEADD(dd, -1, @DueDate)
SET @StartTime = CAST(GETDATE() AS TIME)


/********************************** Get Old Lead Records with no Salesforce ID that are associated with new Activities *************************************/
INSERT	INTO @DistinctLead
		SELECT  DISTINCT
				oc.contact_id
		FROM    HCM.dbo.oncd_activity oa WITH ( NOLOCK )
				INNER JOIN HCM.dbo.oncd_activity_contact oac WITH ( NOLOCK )
					ON oac.activity_id = oa.activity_id
						AND oac.primary_flag = 'Y'
				INNER JOIN HCM.dbo.oncd_contact oc WITH ( NOLOCK )
					ON oc.contact_id = oac.contact_id
		WHERE	oa.action_code IN ( 'APPOINT', 'BEBACK', 'INHOUSE' )
				AND oa.creation_date BETWEEN '1/1/2015' AND '12/31/2017 23:59:59'
				AND oa.cst_sfdc_task_id IS NULL
				AND oc.contact_status_code IN ( 'LEAD', 'CLIENT' )
				AND oc.cst_sfdc_lead_id IS NULL


/********************************** Get Lead Details *************************************/
INSERT	INTO @Lead
		SELECT  oc.contact_id
		,		ISNULL(shc.Id, '001f4000007l8CTAAY') AS 'center_id'
		,       RTRIM(oc.cst_gender_code) AS 'cst_gender_code'
		,       ISNULL(RTRIM(oc.first_name), oc.greeting) AS 'first_name'
		,       ISNULL(RTRIM(oc.middle_name), '') AS 'middle_name'
		,       ISNULL(RTRIM(oc.last_name), '') AS 'last_name'
		,		o_AD.birthday AS 'Birthday'
		,       ISNULL(RTRIM(oc.cst_do_not_mail), '') AS 'cst_do_not_mail'
		,       ISNULL(RTRIM(oc.cst_do_not_text), '') AS 'cst_do_not_text'
		,       ISNULL(RTRIM(oc.cst_do_not_call), '') AS 'cst_do_not_call'
		,       ISNULL(RTRIM(oc.cst_do_not_email), '') AS 'cst_do_not_email'
		,       RTRIM(oc.cst_hair_loss_experience_code) AS 'cst_hair_loss_experience_code'
		,       ISNULL(RTRIM(oc.cst_language_code), 'English') AS 'cst_language_code'
		,       ISNULL(RTRIM(oc.salutation_code), '') AS 'salutation_code'
		,       ISNULL(RTRIM(oc.cst_hair_loss_product), 'Refuse to answer') AS 'cst_hair_loss_product'
		,       RTRIM(oc.cst_hair_loss_spot_code) AS 'cst_hair_loss_spot_code'
		,       ISNULL(RTRIM(oc.cst_hair_loss_family_code), 'Other') AS 'cst_hair_loss_family_code'
		,       ISNULL(RTRIM(oc.suffix), '') AS 'suffix'
		,       ISNULL(RTRIM(oca.address_line_1), '') + ' ' + ISNULL(RTRIM(oca.address_line_2), '') + ' ' + ISNULL(RTRIM(oca.address_line_3), '') + ' ' + ISNULL(RTRIM(oca.address_line_4), '') AS 'Address'
		,       ISNULL(RTRIM(oca.city), '') AS 'city'
		,       ISNULL(RTRIM(oca.zip_code), '') AS 'zip_code'
		,       ISNULL(RTRIM(oca.country_code), '') AS 'country_code'
		,       ISNULL(RTRIM(oca.state_code), '') AS 'state_code'
		,       RTRIM(ocp.phone_type_code) AS 'phone_type_code'
		,       RTRIM(ocp.area_code) AS 'area_code'
		,       RTRIM(ocp.phone_number) AS 'phone_number'
		,       CASE WHEN PATINDEX('%[&'',":;!+=\/()<>]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', '')))) > 0 -- Invalid characters
						  OR PATINDEX('[@.-_]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', '')))) > 0 -- Valid but cannot be starting character
						  OR PATINDEX('%[@.-_]', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', '')))) > 0 -- Valid but cannot be ending character
						  OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', ''))) NOT LIKE '%@%.%' -- Must contain at least one @ and one .
						  OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', ''))) LIKE '%..%' -- Cannot have two periods in a row
						  OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', ''))) LIKE '%@%@%' -- Cannot have two @ anywhere
						  OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', ''))) LIKE '%.@%'
						  OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', ''))) LIKE '%@.%' -- Cannot have @ and . next to each other
						  OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', ''))) LIKE '%.cm'
						  OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', ''))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
						  OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', ''))) LIKE '%.or'
						  OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', ''))) LIKE '%.ne' -- Missing last letter
						  THEN ''
					 ELSE LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(oce.email, ''), ']', ''), '[', '')))
				END AS 'email'
		,       RTRIM(oc.contact_status_code) AS 'contact_status_code'
		,       oc.creation_date
		,       ISNULL(oc.updated_date, oc.creation_date) AS 'updated_date'
		,       RTRIM(oc.cst_contact_accomodation_code) AS 'cst_contact_accomodation_code'
		,       ISNULL(oc.cst_age, '') AS 'cst_age'
		,       RTRIM(oc.cst_age_range_code) AS 'cst_age_range_code'
		,       ISNULL(oc.cst_promotion_code, '') AS 'cst_promotion_code'
		,       RTRIM(oc.cst_hair_loss_code) AS 'cst_hair_loss_code'
		,       ISNULL(oc.cst_siebel_id, '') AS 'siebelid'
		,       ISNULL(oc.cst_sessionid, '') AS 'sessionid'
		,       ISNULL(oc.cst_affiliateid, '') AS 'affiliateid'
		,       CASE WHEN ou.full_name IS NOT NULL
					 THEN dbo.fn_capitalize(RTRIM(ou.full_name))
					 ELSE dbo.fn_capitalize(RTRIM(ou.first_name)) + ' ' + dbo.fn_capitalize(RTRIM(ou.last_name))
				END AS 'UserName'
		FROM    @DistinctLead dl
				INNER JOIN HCM.dbo.oncd_contact oc WITH ( NOLOCK )
					ON dl.ContactID = oc.contact_id
				LEFT JOIN HCM.dbo.oncd_contact_company occ WITH ( NOLOCK )
					ON occ.contact_id = oc.contact_id
						AND occ.primary_flag = 'Y'
				LEFT JOIN HCM.dbo.oncd_company co WITH ( NOLOCK )
					ON co.company_id = occ.company_id
				LEFT JOIN HC_SF_Bridge.dbo.SFDC_HCM_Center shc WITH ( NOLOCK )
					ON shc.CenterID__c = co.cst_center_number
				LEFT JOIN HCM.dbo.oncd_contact_email oce WITH ( NOLOCK )
					ON oce.contact_id = oc.contact_id
					   AND oce.primary_flag = 'Y'
				LEFT JOIN HCM.dbo.oncd_contact_address oca WITH ( NOLOCK )
					ON oca.contact_id = oc.contact_id
					   AND oca.primary_flag = 'Y'
				LEFT JOIN HCM.dbo.oncd_contact_phone ocp WITH ( NOLOCK )
					ON ocp.contact_id = oc.contact_id
					   AND ocp.primary_flag = 'Y'
				LEFT JOIN HCM.dbo.onca_user ou WITH ( NOLOCK )
					ON ou.user_code = oc.created_by_user_code
				OUTER APPLY ( SELECT TOP 1
										ad.birthday
							  FROM      HCM.dbo.oncd_activity_contact oac WITH ( NOLOCK )
										INNER JOIN HCM.dbo.cstd_activity_demographic ad
											WITH ( NOLOCK )
											ON ad.activity_id = oac.activity_id
							  WHERE     oac.contact_id = dl.ContactID
							  ORDER BY  ad.creation_date DESC
							) o_AD


/********************************** Return Lead Details *************************************/
SELECT  LTRIM(RTRIM(l.contact_id)) AS 'ContactID__c'
,		LTRIM(RTRIM(l.center_id)) AS 'Center__c'
,       LTRIM(RTRIM(l.first_name)) AS 'FirstName'
,       ISNULL(LTRIM(RTRIM(l.last_name)), 'X') AS 'LastName'
,       LTRIM(RTRIM(l.salutation_code)) AS 'Salutation'
,       CASE WHEN l.cst_gender_code IS NULL AND occ.company_id = 'HCZVZAY4T1' THEN 'Female'
				WHEN ( ( l.cst_gender_code IS NULL AND occ.company_id != 'HCZVZAY4T1' )
					OR ( l.cst_gender_code = 'UNKNOWN' AND occ.company_id != 'HCZVZAY4T1' )
					OR ( l.cst_gender_code IS NULL AND occ.company_id IS NULL )
					OR ( l.cst_gender_code = 'UNKNOWN' AND occ.company_id IS NULL ) )
				THEN 'Prefer not to say'
				WHEN l.cst_gender_code = 'MALE' THEN 'Male'
				WHEN l.cst_gender_code = 'FEMALE' THEN 'Female'
		END AS 'Gender__c'
,       CASE WHEN l.cst_language_code IN ( 'ENGLISH', 'OTHER' ) THEN 'English'
				WHEN l.cst_language_code = 'FRENCH' THEN 'French'
				WHEN l.cst_language_code = 'SPANISH' THEN 'Spanish'
		END AS 'Language__c'
,       ISNULL(l.cst_age, '') AS 'Age__c'
,       LTRIM(RTRIM(ar.description)) AS 'AgeRange__c'
,       CAST(l.birthday AS DATE) AS 'Birthday__c'
,       CASE WHEN l.cst_hair_loss_experience_code IS NULL OR l.cst_hair_loss_experience_code = 'REFUSE' THEN 'Refuse to answer'
				WHEN l.cst_hair_loss_experience_code = '1YEAR2YEAR' THEN '1 Year to 2 Years'
				WHEN l.cst_hair_loss_experience_code = '2YEAR5YEAR' THEN '2 Years to 5 Years'
				WHEN l.cst_hair_loss_experience_code = 'LESS6MONTH' THEN 'Less than 6 Months'
				WHEN l.cst_hair_loss_experience_code = 'MORE5YEARS' THEN 'More than 5 Years'
				WHEN l.cst_hair_loss_experience_code = 'SIX12MONTH' THEN '6 to 12 Months'
		END AS 'HairLossExperience__c'
,       LTRIM(RTRIM(l.cst_hair_loss_product)) AS 'HairLossProductOther__c'
,       CASE WHEN RTRIM(l.cst_hair_loss_spot_code) IS NULL OR RTRIM(l.cst_hair_loss_spot_code) = 'REFUSE' THEN 'Refuse to answer'
				WHEN RTRIM(l.cst_hair_loss_spot_code) = 'FRONT' THEN 'Receding front hairline'
				WHEN RTRIM(l.cst_hair_loss_spot_code) = 'SCALP' THEN 'Can see scalp'
				WHEN RTRIM(l.cst_hair_loss_spot_code) = 'SPOTTY' THEN 'Spotty areas'
				WHEN RTRIM(l.cst_hair_loss_spot_code) = 'THINNING' THEN 'Thinning all over'
				WHEN RTRIM(l.cst_hair_loss_spot_code) = 'TOPCROWN' THEN 'Top/crown of head'
		END AS 'HairLossSpot__c'
,       CASE WHEN RTRIM(l.cst_hair_loss_family_code) = 'GRANDPARNT' THEN 'Grandparent'
				WHEN RTRIM(l.cst_hair_loss_family_code) = 'PARENT' THEN 'Parent'
				WHEN RTRIM(l.cst_hair_loss_family_code) = 'SIBLING' THEN 'Sibling'
				ELSE RTRIM(l.cst_hair_loss_family_code)
		END AS 'HairLossFamily__c'
,       ISNULL(LTRIM(RTRIM(l.cst_hair_loss_code)), '') AS 'HairLossProductUsed__c'
,       LTRIM(RTRIM(cpc.promotion_code)) AS 'Promo_Code_Legacy__c'
,       ISNULL(os.source_code, '') AS 'Source_Code_Legacy__c'
,       ISNULL(os.source_code, '') AS 'SourceTest__c'
,       LTRIM(RTRIM(l.siebelid)) AS 'SiebelID__c'
,       LTRIM(RTRIM(l.sessionid)) AS 'OnCSessionID__c'
,       LTRIM(RTRIM(l.affiliateid)) AS 'OnCAffiliateID__c'
,       LTRIM(RTRIM(l.suffix)) AS 'Suffix'
,       CASE WHEN l.cst_contact_accomodation_code = 'HEARTRANS' THEN 'Hearing Impaired Interpreter Requested'
				WHEN l.cst_contact_accomodation_code = 'HEARING' THEN 'Hearing Impaired'
				WHEN l.cst_contact_accomodation_code = 'MALECSLT' THEN 'Male Consultant Requested'
				WHEN l.cst_contact_accomodation_code = 'FEMALECSLT' THEN 'Female Consultant Requested'
				WHEN l.cst_contact_accomodation_code = 'TRANSERV' THEN 'Translation Service Requested'
				ELSE ISNULL(l.cst_contact_accomodation_code, '')
		END AS 'Accommodation__c'
,       LTRIM(RTRIM(l.Address)) AS 'Street'
,       REPLACE(REPLACE(l.city, ',', ''), '.', '') AS 'City'
,       LTRIM(RTRIM(l.zip_code)) AS 'PostalCode'
,       CASE WHEN l.state_code IS NULL
					OR l.state_code = '99' THEN NULL
				WHEN l.state_code = 'NF' THEN 'NL'
				WHEN l.state_code = 'PQ' THEN 'QC'
				ELSE LTRIM(RTRIM(l.state_code))
		END AS 'StateCode'
,       CASE WHEN l.state_code IN ( 'AA', 'AE', 'AK', 'AL', 'AP', 'AR', 'AS', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'FM', 'GA', 'GU', 'HI', 'IA', 'ID', 'IL',
									'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'MH', 'MI', 'MN', 'MO', 'MP', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NJ', 'NM', 'NV',
									'NY', 'OH', 'OK', 'OR', 'PA', 'PR', 'PW', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VI', 'VT', 'WA', 'WI', 'WV', 'WY' ) THEN 'US'
				WHEN l.state_code IN ( 'AB', 'BC', 'NB', 'NF', 'NL', 'NS', 'NT', 'NU', 'ON', 'PE', 'QC', 'SK', 'YT' ) THEN 'CA'
				WHEN l.state_code IN ( 'PQ', 'MB' ) AND ( l.country_code = ' ' OR l.country_code = 'US' ) THEN 'CA'
				WHEN l.state_code = 'ME' AND ( l.country_code = ' ' OR l.country_code = 'CA' ) THEN 'US'
				ELSE LTRIM(RTRIM(l.country_code))
		END AS 'CountryCode'
,       ISNULL('(' + RTRIM(l.area_code) + ')' + ' ' + RTRIM(STUFF(l.phone_number, 4, 0, '-')), '') AS 'Phone'
,       LTRIM(RTRIM(l.email)) AS 'Email'
,       LTRIM(RTRIM(l.contact_status_code)) AS 'ContactStatus__c'
,       CASE WHEN ISNULL(RTRIM(l.cst_do_not_mail), '') = 'N' THEN 0
				WHEN ISNULL(LTRIM(RTRIM(l.cst_do_not_mail)), '') = 'Y' THEN 1
				ELSE 0
		END AS 'DoNotMail__c'
,       CASE WHEN ISNULL(LTRIM(RTRIM(l.cst_do_not_text)), '') = 'N' THEN 0
				WHEN ISNULL(LTRIM(RTRIM(l.cst_do_not_text)), '') = 'Y' THEN 1
				ELSE 0
		END AS 'DoNotText__c'
,       CASE WHEN ISNULL(LTRIM(RTRIM(l.cst_do_not_call)), '') = 'N' THEN 0
				WHEN ISNULL(LTRIM(RTRIM(l.cst_do_not_call)), '') = 'Y' THEN 1
				ELSE 0
		END AS 'DoNotCall'
,       CASE WHEN ISNULL(LTRIM(RTRIM(l.cst_do_not_email)), '') = 'N' THEN 0
				WHEN ISNULL(LTRIM(RTRIM(l.cst_do_not_email)), '') = 'Y' THEN 1
				ELSE 0
		END AS 'DoNotEmail__c'
,		l.user_code AS 'OnCtCreatedByUser__c'
,		HairClubCMS.dbo.GetUTCFromLocal(l.creation_date, -5, 1) AS 'ReportCreateDate__c'
,		HairClubCMS.dbo.GetUTCFromLocal(l.creation_date, -5, 1) AS 'OnCtCreatedDate__c'
,		HairClubCMS.dbo.GetUTCFromLocal(l.updated_date, -5, 1) AS 'OnCtLastModifyDate__c'
FROM    @Lead l
		LEFT JOIN HCM.dbo.csta_contact_age_range ar WITH ( NOLOCK )
			ON ar.age_range_code = l.cst_age_range_code
		LEFT JOIN HCM.dbo.oncd_contact_source ocs WITH ( NOLOCK )
			ON ocs.contact_id = l.contact_id
				AND ocs.primary_flag = 'Y'
		LEFT JOIN HCM.dbo.onca_source os WITH ( NOLOCK )
			ON os.source_code = ocs.source_code
		LEFT JOIN HCM.dbo.csta_promotion_code cpc WITH ( NOLOCK )
			ON cpc.promotion_code = l.cst_promotion_code
		LEFT JOIN HCM.dbo.oncd_contact_company occ WITH ( NOLOCK )
			ON occ.contact_id = l.contact_id
				AND occ.primary_flag = 'Y'
		LEFT JOIN HCM.dbo.onca_zip oz WITH ( NOLOCK )
			ON oz.zip_code = l.zip_code
				AND oz.city = l.city
WHERE   ISNULL(LTRIM(RTRIM(l.Address)), '') <> ''
		OR ISNULL(LTRIM(RTRIM(l.email)), '') <> ''
		OR ISNULL(LTRIM(RTRIM(l.phone_number)), '') <> ''
ORDER BY l.creation_date

END
GO
