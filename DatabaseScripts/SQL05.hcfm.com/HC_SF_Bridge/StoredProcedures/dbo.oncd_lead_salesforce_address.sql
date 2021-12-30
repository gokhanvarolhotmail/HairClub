/* CreateDate: 09/29/2017 15:55:05.917 , ModifyDate: 10/30/2017 11:55:49.773 */
GO
/*
==============================================================================
PROCEDURE:				oncd_contact_salesforce_leads

AUTHOR: 				Daniel Polania

IMPLEMENTOR: 			Daniel Polania

DATE IMPLEMENTED: 		08/24/2017


==============================================================================
DESCRIPTION:	Gathers all the address data for the Salesforce email object
==============================================================================
NOTES:
		* 08/24/2017 DP - Created proc

==============================================================================
SAMPLE EXECUTION:
EXEC dbo.oncd_lead_salesforce_address
==============================================================================
*/
CREATE PROCEDURE [dbo].[oncd_lead_salesforce_address]
AS
BEGIN

    SET NOCOUNT ON;
    SELECT OCA.contact_address_id,
           OC.contact_id AS Lead,
           ISNULL(RTRIM(OCA.address_line_1), '') + ' ' + ISNULL(RTRIM(OCA.address_line_2), '') + ' '
           + ISNULL(RTRIM(OCA.address_line_3), '') + ' ' + ISNULL(RTRIM(OCA.address_line_4), '') AS [Name],
           OC.cst_do_not_mail,
           ISNULL(RTRIM(OCA.address_line_1), '') AS address_line_1,
           ISNULL(RTRIM(OCA.address_line_2), '') AS address_line_2,
           ISNULL(RTRIM(OCA.address_line_3), '') AS address_line_3,
           ISNULL(RTRIM(OCA.address_line_4), '') AS address_line_4,
           ISNULL(RTRIM(OCA.city), '') AS city,
           CASE
               WHEN ISNULL(RTRIM(OCA.country_code), '') = 'US'
                    OR ISNULL(RTRIM(OCA.country_code), '') = '' THEN
                   'United States'
               WHEN ISNULL(RTRIM(OCA.country_code), '') = 'CA' THEN
                   'Canada'
           END AS country_code,
           ISNULL(RTRIM(OCA.zip_code), '') AS zip_code,
           CASE
               WHEN OCA.state_code IS NULL
                    OR OCA.state_code = '99' THEN
                   NULL
               WHEN OCA.state_code = 'NF' THEN
                   'NL'
               WHEN OCA.state_code = 'PQ' THEN
                   'QC'
               ELSE
                   RTRIM(OCA.state_code)
           END AS state_code,
           CASE
               WHEN OCA.primary_flag = 'Y' THEN
                   1
               ELSE
                   0
           END AS primary_flag,
           ISNULL(
                     ISNULL(
                               CAST(YEAR(OCA.creation_date) AS NVARCHAR(4)) + '-'
                               + CAST(MONTH(OCA.creation_date) AS NVARCHAR(2)) + '-'
                               + CAST(DAY(OCA.creation_date) AS NVARCHAR(2)) + 'T'
                               + CAST(DATEPART(HOUR, OCA.creation_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(MINUTE, OCA.creation_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(SECOND, OCA.creation_date) AS NVARCHAR(2)),
                               CAST(YEAR(OCA.updated_date) AS NVARCHAR(4)) + '-'
                               + CAST(MONTH(OCA.updated_date) AS NVARCHAR(2)) + '-'
                               + CAST(DAY(OCA.updated_date) AS NVARCHAR(2)) + 'T'
                               + CAST(DATEPART(HOUR, OCA.updated_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(MINUTE, OCA.updated_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(SECOND, OCA.updated_date) AS NVARCHAR(2))
                           ),
                     ''
                 ) AS creation_date,
           ISNULL(
                     ISNULL(
                               CAST(YEAR(OCA.updated_date) AS NVARCHAR(4)) + '-'
                               + CAST(MONTH(OCA.updated_date) AS NVARCHAR(2)) + '-'
                               + CAST(DAY(OCA.updated_date) AS NVARCHAR(2)) + 'T'
                               + CAST(DATEPART(HOUR, OCA.updated_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(MINUTE, OCA.updated_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(SECOND, OCA.updated_date) AS NVARCHAR(2)),
                               CAST(YEAR(OCA.creation_date) AS NVARCHAR(4)) + '-'
                               + CAST(MONTH(OCA.creation_date) AS NVARCHAR(2)) + '-'
                               + CAST(DAY(OCA.creation_date) AS NVARCHAR(2)) + 'T'
                               + CAST(DATEPART(HOUR, OCA.creation_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(MINUTE, OCA.creation_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(SECOND, OCA.creation_date) AS NVARCHAR(2))
                           ),
                     ''
                 ) AS updated_date,
           CASE
               WHEN OCA.cst_active = 'Y' THEN
                   'Active'
               ELSE
                   'Inactive'
           END AS [Status]
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_contact_address AS OCA WITH (NOLOCK)
            ON OCA.contact_id = OC.contact_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OC.contact_id
    WHERE OC.cst_do_not_mail = 'Y'
          AND OCA.address_line_1 IS NOT NULL
          AND OCA.address_line_1 NOT LIKE 'x%'
          AND OCA.address_line_1 NOT LIKE 'X%'
          AND OCA.address_line_1 NOT LIKE '-%'
          AND OCA.address_type_code != 'SKIP'
          AND ISNULL(OCA.cst_do_not_export, 'N') = 'N'
    UNION
    SELECT OCA.contact_address_id,
           OC.contact_id AS Lead,
           ISNULL(RTRIM(OCA.address_line_1), '') + ' ' + ISNULL(RTRIM(OCA.address_line_2), '') + ' '
           + ISNULL(RTRIM(OCA.address_line_3), '') + ' ' + ISNULL(RTRIM(OCA.address_line_4), '') AS [Name],
           OC.cst_do_not_mail,
           ISNULL(RTRIM(OCA.address_line_1), '') AS address_line_1,
           ISNULL(RTRIM(OCA.address_line_2), '') AS address_line_2,
           ISNULL(RTRIM(OCA.address_line_3), '') AS address_line_3,
           ISNULL(RTRIM(OCA.address_line_4), '') AS address_line_4,
           ISNULL(RTRIM(OCA.city), '') AS city,
           CASE
               WHEN ISNULL(RTRIM(OCA.country_code), '') = 'US'
                    OR ISNULL(RTRIM(OCA.country_code), '') = '' THEN
                   'United States'
               WHEN ISNULL(RTRIM(OCA.country_code), '') = 'CA' THEN
                   'Canada'
           END AS country_code,
           ISNULL(RTRIM(OCA.zip_code), '') AS zip_code,
           CASE
               WHEN OCA.state_code IS NULL
                    OR OCA.state_code = '99' THEN
                   NULL
               WHEN OCA.state_code = 'NF' THEN
                   'NL'
               WHEN OCA.state_code = 'PQ' THEN
                   'QC'
               ELSE
                   RTRIM(OCA.state_code)
           END AS state_code,
           CASE
               WHEN OCA.primary_flag = 'Y' THEN
                   1
               ELSE
                   0
           END AS primary_flag,
           ISNULL(
                     ISNULL(
                               CAST(YEAR(OCA.creation_date) AS NVARCHAR(4)) + '-'
                               + CAST(MONTH(OCA.creation_date) AS NVARCHAR(2)) + '-'
                               + CAST(DAY(OCA.creation_date) AS NVARCHAR(2)) + 'T'
                               + CAST(DATEPART(HOUR, OCA.creation_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(MINUTE, OCA.creation_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(SECOND, OCA.creation_date) AS NVARCHAR(2)),
                               CAST(YEAR(OCA.updated_date) AS NVARCHAR(4)) + '-'
                               + CAST(MONTH(OCA.updated_date) AS NVARCHAR(2)) + '-'
                               + CAST(DAY(OCA.updated_date) AS NVARCHAR(2)) + 'T'
                               + CAST(DATEPART(HOUR, OCA.updated_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(MINUTE, OCA.updated_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(SECOND, OCA.updated_date) AS NVARCHAR(2))
                           ),
                     ''
                 ) AS creation_date,
           ISNULL(
                     ISNULL(
                               CAST(YEAR(OCA.updated_date) AS NVARCHAR(4)) + '-'
                               + CAST(MONTH(OCA.updated_date) AS NVARCHAR(2)) + '-'
                               + CAST(DAY(OCA.updated_date) AS NVARCHAR(2)) + 'T'
                               + CAST(DATEPART(HOUR, OCA.updated_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(MINUTE, OCA.updated_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(SECOND, OCA.updated_date) AS NVARCHAR(2)),
                               CAST(YEAR(OCA.creation_date) AS NVARCHAR(4)) + '-'
                               + CAST(MONTH(OCA.creation_date) AS NVARCHAR(2)) + '-'
                               + CAST(DAY(OCA.creation_date) AS NVARCHAR(2)) + 'T'
                               + CAST(DATEPART(HOUR, OCA.creation_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(MINUTE, OCA.creation_date) AS NVARCHAR(2)) + ':'
                               + CAST(DATEPART(SECOND, OCA.creation_date) AS NVARCHAR(2))
                           ),
                     ''
                 ) AS updated_date,
           CASE
               WHEN OCA.cst_active = 'Y' THEN
                   'Active'
               ELSE
                   'Inactive'
           END AS [Status]
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_contact_address AS OCA WITH (NOLOCK)
            ON OCA.contact_id = OC.contact_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OC.contact_id
    WHERE OC.cst_do_not_mail = 'N'
          AND OCA.cst_active = 'Y'
          AND OCA.address_line_1 IS NOT NULL
          AND OCA.address_line_1 NOT LIKE 'x%'
          AND OCA.address_line_1 NOT LIKE 'X%'
          AND OCA.address_line_1 NOT LIKE '-%'
          AND OCA.address_type_code != 'SKIP'
          AND ISNULL(OCA.cst_do_not_export, 'N') = 'N'
    ORDER BY OC.contact_id;
END;
GO
