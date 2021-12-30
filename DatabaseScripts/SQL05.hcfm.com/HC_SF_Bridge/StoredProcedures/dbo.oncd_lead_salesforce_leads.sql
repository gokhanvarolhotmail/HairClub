/* CreateDate: 09/26/2017 11:56:26.110 , ModifyDate: 10/26/2017 15:50:20.123 */
GO
/*
==============================================================================
PROCEDURE:				oncd_contact_salesforce_leads

AUTHOR: 				Daniel Polania

IMPLEMENTOR: 			Daniel Polania

DATE IMPLEMENTED: 		08/24/2017


==============================================================================
DESCRIPTION:	Gathers all the data for the Salesforce lead object
==============================================================================
NOTES:
		* 08/24/2017 DP - Created proc

==============================================================================
SAMPLE EXECUTION:
EXEC dbo.oncd_contact_salesforce_leads
==============================================================================
*/
CREATE PROCEDURE [dbo].[oncd_lead_salesforce_leads]
AS
BEGIN

    SET NOCOUNT ON;

    CREATE TABLE #temp
    (
        contact_id NVARCHAR(10),
        cst_gender_code NVARCHAR(10),
        first_name NVARCHAR(50),
        middle_name NVARCHAR(50),
        last_name NVARCHAR(50),
        cst_do_not_mail NVARCHAR(1),
        cst_do_not_text NVARCHAR(1),
        cst_do_not_call NVARCHAR(1),
        cst_do_not_email NVARCHAR(1),
        do_not_contact NVARCHAR(1),
        cst_has_open_confirmation_call NVARCHAR(1),
        cst_hair_loss_experience_code NVARCHAR(10),
        cst_language_code NVARCHAR(10),
        salutation_code NVARCHAR(10),
        cst_hair_loss_product NVARCHAR(50),
        cst_hair_loss_spot_code NVARCHAR(10),
        cst_hair_loss_family_code NVARCHAR(10),
        suffix NVARCHAR(50),
        Address NVARCHAR(255),
        city NVARCHAR(60),
        zip_code NVARCHAR(15),
        country_code NVARCHAR(20),
        state_code NVARCHAR(20),
        phone_type_code NVARCHAR(10),
        area_code NVARCHAR(10),
        phone_number NVARCHAR(20),
        email NVARCHAR(100),
        contact_status_code NVARCHAR(10),
        creation_date DATETIME,
        updated_date DATETIME,
        cst_contact_accomodation_code NVARCHAR(10),
        cst_age INT,
        cst_age_range_code NVARCHAR(10),
        cst_promotion_code NVARCHAR(10),
        cst_hair_loss_code VARCHAR(10)
    );
    CREATE INDEX pk_temp ON #temp (contact_id);

    DECLARE @date DATETIME = '20070101';

    --All contacts that have an activity since 2007
    SELECT DISTINCT
        C.contact_id
    INTO #ContactAvtivity
    FROM HCM.dbo.oncd_contact AS C WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
            ON OAC.contact_id = C.contact_id
    WHERE OAC.creation_date >= @date;

    --Prep all leads that are not Invalid, Test, Client or Dup and for Salesforce Object
    INSERT INTO #temp
    SELECT C.contact_id,
           RTRIM(C.cst_gender_code) AS cst_gender_code,
           ISNULL(RTRIM(C.first_name), C.greeting) AS first_name,
           ISNULL(RTRIM(C.middle_name), '') AS middle_name,
           ISNULL(RTRIM(C.last_name), '') AS last_name,
           ISNULL(RTRIM(C.cst_do_not_mail), '') AS cst_do_not_mail,
           ISNULL(RTRIM(C.cst_do_not_text), '') AS cst_do_not_text,
           ISNULL(RTRIM(C.cst_do_not_call), '') AS cst_do_not_call,
           ISNULL(RTRIM(C.cst_do_not_email), '') AS cst_do_not_email,
           ISNULL(RTRIM(C.do_not_solicit), '') AS do_not_contact,
           ISNULL(RTRIM(C.cst_has_open_confirmation_call), '') AS cst_has_open_confirmation_call,
           RTRIM(C.cst_hair_loss_experience_code) AS cst_hair_loss_experience_code,
           ISNULL(RTRIM(C.cst_language_code), 'English') AS cst_language_code,
           ISNULL(RTRIM(C.salutation_code), '') AS salutation_code,
           ISNULL(RTRIM(C.cst_hair_loss_product), 'Refuse to answer') AS cst_hair_loss_product,
           RTRIM(C.cst_hair_loss_spot_code) AS cst_hair_loss_spot_code,
           ISNULL(RTRIM(C.cst_hair_loss_family_code), 'Other') AS cst_hair_loss_family_code,
           ISNULL(RTRIM(C.suffix), '') AS suffix,
           ISNULL(RTRIM(OCA.address_line_1), '') + ' ' + ISNULL(RTRIM(OCA.address_line_2), '') + ' '
           + ISNULL(RTRIM(OCA.address_line_3), '') + ' ' + ISNULL(RTRIM(OCA.address_line_4), '') AS Address,
           ISNULL(RTRIM(OCA.city), '') AS city,
           ISNULL(RTRIM(OCA.zip_code), '') AS zip_code,
           ISNULL(RTRIM(OCA.country_code), '') AS country_code,
           ISNULL(RTRIM(OCA.state_code), '') AS state_code,
           RTRIM(OCP.phone_type_code) AS phone_type_code,
           RTRIM(OCP.area_code) AS area_code,
           RTRIM(OCP.phone_number) AS phone_number,
           RTRIM(ISNULL(OCE.email, '')) AS email,
           RTRIM(C.contact_status_code) AS contact_status_code,
           C.creation_date,
           ISNULL(C.updated_date, C.creation_date) AS updated_date,
           RTRIM(C.cst_contact_accomodation_code) AS cst_contact_accomodation_code,
           ISNULL(C.cst_age, '') AS cst_age,
           RTRIM(C.cst_age_range_code) AS cst_age_range_code,
           ISNULL(C.cst_promotion_code, '') AS cst_promotion_code,
           RTRIM(C.cst_hair_loss_code) AS cst_hair_loss_code
    FROM HCM.dbo.oncd_contact AS C WITH (NOLOCK)
        LEFT JOIN HCM.dbo.oncd_contact_email AS OCE WITH (NOLOCK)
            ON OCE.contact_id = C.contact_id
               AND OCE.primary_flag = 'Y'
        LEFT JOIN HCM.dbo.oncd_contact_address AS OCA WITH (NOLOCK)
            ON OCA.contact_id = C.contact_id
               AND OCA.primary_flag = 'Y'
        LEFT JOIN HCM.dbo.oncd_contact_phone AS OCP WITH (NOLOCK)
            ON OCP.contact_id = C.contact_id
               AND OCP.primary_flag = 'Y'
        INNER JOIN #ContactAvtivity AS CA
            ON CA.contact_id = C.contact_id
    WHERE contact_status_code NOT IN ( 'INVALID', 'TEST', 'CLIENT' )
          AND C.first_name != 'DUP';


    --Grab All Birthday infromation from the demographic table
    CREATE TABLE #Birthday
    (
        contact_id NCHAR(10) NOT NULL,
        birthday DATETIME NULL,
        updated_date DATETIME NOT NULL,
        Rank_updated_date INT
    );
    CREATE CLUSTERED INDEX idx_clt_bithday ON #Birthday (contact_id);


    INSERT INTO #Birthday
    SELECT OAC.contact_id,
           CAD.birthday,
           CAD.updated_date,
           ROW_NUMBER() OVER (PARTITION BY OAC.contact_id ORDER BY CAD.updated_date DESC) AS Rank_updated_date
    FROM HCM.dbo.oncd_activity_contact AS OAC WITH (NOLOCK)
        INNER JOIN HCM.dbo.cstd_activity_demographic AS CAD WITH (NOLOCK)
            ON CAD.activity_id = OAC.activity_id;


    --Get all contact ids that have are a client
    SELECT DC.ContactID
    INTO #ClientContactID
    FROM HairClubCMS.dbo.datClient AS DC WITH (NOLOCK)
    WHERE DC.ContactID IS NOT NULL;

    --Remove any lead that is a client

    DELETE T
    FROM #temp AS T
        INNER JOIN #ClientContactID AS CCI
            ON T.contact_id = CCI.ContactID;


    --Get additional data points needed for Salesforce lead object including center, age and zip code information and format for salesforce ingestion

    SELECT T.contact_id,
           CASE
               WHEN T.cst_gender_code IS NULL
                    AND OCC.company_id = 'HCZVZAY4T1' THEN
                   'Female'
               WHEN
               (
                   (
                       T.cst_gender_code IS NULL
                       AND OCC.company_id != 'HCZVZAY4T1'
                   )
                   OR (
                          T.cst_gender_code = 'UNKNOWN'
                          AND OCC.company_id != 'HCZVZAY4T1'
                      )
                   OR (
                          T.cst_gender_code IS NULL
                          AND OCC.company_id IS NULL
                      )
                   OR (
                          T.cst_gender_code = 'UNKNOWN'
                          AND OCC.company_id IS NULL
                      )
               ) THEN
                   'Prefer not to say'
               WHEN T.cst_gender_code = 'MALE' THEN
                   'Male'
               WHEN T.cst_gender_code = 'FEMALE' THEN
                   'Female'
           END AS cst_gender_code,
           T.first_name,
           T.middle_name,
           T.last_name,
           CASE
               WHEN ISNULL(RTRIM(cst_do_not_mail), '') = 'N' THEN
                   0
               WHEN ISNULL(RTRIM(cst_do_not_mail), '') = 'Y' THEN
                   1
               ELSE
                   0
           END AS cst_do_not_mail,
           CASE
               WHEN ISNULL(RTRIM(cst_do_not_text), '') = 'N' THEN
                   0
               WHEN ISNULL(RTRIM(cst_do_not_text), '') = 'Y' THEN
                   1
               ELSE
                   0
           END AS cst_do_not_text,
           CASE
               WHEN ISNULL(RTRIM(cst_do_not_call), '') = 'N' THEN
                   0
               WHEN ISNULL(RTRIM(cst_do_not_call), '') = 'Y' THEN
                   1
               ELSE
                   0
           END AS cst_do_not_call,
           CASE
               WHEN ISNULL(RTRIM(cst_do_not_email), '') = 'N' THEN
                   0
               WHEN ISNULL(RTRIM(cst_do_not_email), '') = 'Y' THEN
                   1
               ELSE
                   0
           END AS cst_do_not_email,
           CASE
               WHEN ISNULL(RTRIM(T.do_not_contact), '') = 'N' THEN
                   0
               WHEN ISNULL(RTRIM(T.do_not_contact), '') = 'Y' THEN
                   1
               ELSE
                   0
           END AS do_not_contact,
           CASE
               WHEN ISNULL(RTRIM(cst_has_open_confirmation_call), '') = 'N' THEN
                   0
               WHEN ISNULL(RTRIM(cst_has_open_confirmation_call), '') = 'Y' THEN
                   1
               ELSE
                   0
           END AS cst_has_open_confirmation_call,
           CASE
               WHEN T.cst_hair_loss_experience_code IS NULL
                    OR T.cst_hair_loss_experience_code = 'REFUSE' THEN
                   'Refuse to answer'
               WHEN T.cst_hair_loss_experience_code = '1YEAR2YEAR' THEN
                   '1 Year to 2 Years'
               WHEN T.cst_hair_loss_experience_code = '2YEAR5YEAR' THEN
                   '2 Years to 5 Years'
               WHEN T.cst_hair_loss_experience_code = 'LESS6MONTH' THEN
                   'Less than 6 Months'
               WHEN T.cst_hair_loss_experience_code = 'MORE5YEARS' THEN
                   'More than 5 Years'
               WHEN T.cst_hair_loss_experience_code = 'SIX12MONTH' THEN
                   '6 to 12 Months'
           END AS cst_hair_loss_experience_code,
           CASE
               WHEN T.cst_language_code IN ( 'ENGLISH', 'OTHER' ) THEN
                   'English'
               WHEN T.cst_language_code = 'FRENCH' THEN
                   'French'
               WHEN T.cst_language_code = 'SPANISH' THEN
                   'Spanish'
           END AS cst_language_code,
           T.salutation_code,
           T.cst_hair_loss_product,
           CASE
               WHEN RTRIM(T.cst_hair_loss_spot_code) IS NULL
                    OR RTRIM(T.cst_hair_loss_spot_code) = 'REFUSE' THEN
                   'Refuse to answer'
               WHEN RTRIM(T.cst_hair_loss_spot_code) = 'FRONT' THEN
                   'Receding front hairline'
               WHEN RTRIM(T.cst_hair_loss_spot_code) = 'SCALP' THEN
                   'Can see scalp'
               WHEN RTRIM(T.cst_hair_loss_spot_code) = 'SPOTTY' THEN
                   'Spotty areas'
               WHEN RTRIM(T.cst_hair_loss_spot_code) = 'THINNING' THEN
                   'Thinning all over'
               WHEN RTRIM(T.cst_hair_loss_spot_code) = 'TOPCROWN' THEN
                   'Top/crown of head'
           END AS cst_hair_loss_spot_code,
           CASE
               WHEN RTRIM(T.cst_hair_loss_family_code) = 'GRANDPARNT' THEN
                   'Grandparent'
               WHEN RTRIM(T.cst_hair_loss_family_code) = 'PARENT' THEN
                   'Parent'
               WHEN RTRIM(T.cst_hair_loss_family_code) = 'SIBLING' THEN
                   'Sibling'
               ELSE
                   RTRIM(T.cst_hair_loss_family_code)
           END AS cst_hair_loss_family_code,
           T.suffix,
           T.Address,
           REPLACE(REPLACE(T.city, ',', ''), '.', '') AS city,
           T.zip_code,
           CASE
               WHEN T.state_code IS NULL
                    OR T.state_code = '99' THEN
                   NULL
               WHEN T.state_code = 'NF' THEN
                   'NL'
               WHEN T.state_code = 'PQ' THEN
                   'QC'
               ELSE
                   RTRIM(T.state_code)
           END AS state_code,
           CASE
               WHEN T.state_code IN ( 'AA', 'AE', 'AK', 'AL', 'AP', 'AR', 'AS', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE',
                                      'FL', 'FM', 'GA', 'GU', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA',
                                      'MD', 'MH', 'MI', 'MN', 'MO', 'MP', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ',
                                      'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'PR', 'PW', 'RI', 'SC', 'SD',
                                      'TN', 'TX', 'UT', 'VA', 'VI', 'VT', 'WA', 'WI', 'WV', 'WY'
                                    ) THEN
                   'US'
               WHEN T.state_code IN ( 'AB', 'BC', 'NB', 'NF', 'NL', 'NS', 'NT', 'NU', 'ON', 'PE', 'QC', 'SK', 'YT' ) THEN
                   'CA'
               WHEN T.state_code IN ( 'PQ', 'MB' )
                    AND (
                            T.country_code = ' '
                            OR T.country_code = 'US'
                        ) THEN
                   'CA'
               WHEN T.state_code = 'ME'
                    AND (
                            T.country_code = ' '
                            OR T.country_code = 'CA'
                        ) THEN
                   'US'
               ELSE
                   T.country_code
           END AS country_code,
           ISNULL(   CASE
                         WHEN RTRIM(T.phone_type_code) IN ( 'CELL', 'CELL2' ) THEN
                             '(' + RTRIM(T.area_code) + ')' + ' ' + RTRIM(STUFF(phone_number, 4, 0, '-'))
                     END,
                     ''
                 ) AS MobilePhone,
           ISNULL(
                     CASE
                         WHEN RTRIM(T.phone_type_code) IN ( 'HOME', 'HOME2', 'BUSINESS', 'BUSINESSFA', 'DIRPHONE',
                                                            'FAX', 'BACKLINE'
                                                          ) THEN
                             '(' + RTRIM(T.area_code) + ')' + ' ' + RTRIM(STUFF(phone_number, 4, 0, '-'))
                         ELSE
                             ''
                     END,
                     ''
                 ) AS Phone,
           T.email,
           T.contact_status_code,
           CASE
               WHEN T.cst_contact_accomodation_code = 'HEARTRANS' THEN
                   'Hearing Impaired Interpreter Requested'
               WHEN T.cst_contact_accomodation_code = 'HEARING' THEN
                   'Hearing Impaired'
               WHEN T.cst_contact_accomodation_code = 'MALECSLT' THEN
                   'Male Consultant Requested'
               WHEN T.cst_contact_accomodation_code = 'FEMALECSLT' THEN
                   'Female Consultant Requested'
               WHEN T.cst_contact_accomodation_code = 'TRANSERV' THEN
                   'Translation Service Requested'
               ELSE
                   ISNULL(T.cst_contact_accomodation_code, '')
           END AS cst_contact_accomodation_code,
           ISNULL(T.cst_age, '') AS cst_age,
           CCAR.description AS Age_Range,
           ISNULL(B.birthday, '') AS birthday,
           T.cst_promotion_code,
           ISNULL(OS.source_code, '') AS source_code,
           OCC.company_id,
           ISNULL(T.cst_hair_loss_code, '') AS cst_hair_loss_code,
           OZ.zip_id AS zip_id,
           ISNULL(
                     CAST(YEAR(T.creation_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(T.creation_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(T.creation_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, T.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, T.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, T.creation_date) AS NVARCHAR(2)),
                     ''
                 ) AS OnCon_creation_date,
           ISNULL(
                     CAST(YEAR(T.updated_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(T.updated_date) AS NVARCHAR(2)) + '-'
                     + CAST(DAY(T.updated_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, T.updated_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, T.updated_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, T.updated_date) AS NVARCHAR(2)),
                     ''
                 ) AS OnCon_Updated_date
    FROM #temp AS T
        LEFT JOIN HCM.dbo.csta_contact_age_range AS CCAR WITH (NOLOCK)
            ON T.cst_age_range_code = CCAR.age_range_code
        LEFT JOIN #Birthday AS B WITH (NOLOCK)
            ON B.contact_id = T.contact_id
               AND B.Rank_updated_date = 1
        LEFT JOIN HCM.dbo.oncd_contact_source AS OCS WITH (NOLOCK)
            ON OCS.contact_id = T.contact_id
               AND OCS.primary_flag = 'Y'
        LEFT JOIN HCM.dbo.onca_source AS OS
            ON OS.source_code = OCS.source_code
        LEFT JOIN HCM.dbo.oncd_contact_company AS OCC WITH (NOLOCK)
            ON OCC.contact_id = T.contact_id
               AND OCC.primary_flag = 'Y'
        LEFT JOIN HCM.dbo.onca_zip AS OZ WITH (NOLOCK)
            ON OZ.zip_code = T.zip_code
               AND OZ.city = T.city
    WHERE T.phone_number IS NOT NULL
          OR T.email IS NOT NULL
    ORDER BY OZ.zip_id,
             OCC.company_id;


    DROP TABLE #temp,
               #Birthday,
               #ContactAvtivity,
               #ClientContactID;
END;
GO
