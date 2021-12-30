/* CreateDate: 09/29/2017 11:00:19.513 , ModifyDate: 10/30/2017 12:07:20.397 */
GO
/*
==============================================================================
PROCEDURE:				oncd_contact_salesforce_leads

AUTHOR: 				Daniel Polania

IMPLEMENTOR: 			Daniel Polania

DATE IMPLEMENTED: 		08/24/2017


==============================================================================
DESCRIPTION:	Gathers all the email data for the Salesforce email object
==============================================================================
NOTES:
		* 08/24/2017 DP - Created proc

==============================================================================
SAMPLE EXECUTION:
EXEC dbo.oncd_lead_salesforce_email
==============================================================================
*/
CREATE PROCEDURE [dbo].[oncd_lead_salesforce_email]
AS
BEGIN

    SET NOCOUNT ON;
    SELECT OCE.contact_email_id,
           C.contact_id AS Lead,
           CASE
               WHEN C.cst_do_not_email = 'Y' THEN
                   1
               ELSE
                   0
           END AS cst_do_not_email,
           CASE
               WHEN OCE.primary_flag = 'Y' THEN
                   1
               ELSE
                   0
           END AS primary_flag,
           CASE
               WHEN OCE.active = 'Y' THEN
                   'Active'
               ELSE
                   'Inactive'
           END AS [Status],
           CASE
               WHEN PATINDEX(
                                '%[&'',":;!+=\/()<>]%',
                                LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', '')))
                            ) > 0 -- Invalid characters
                    OR PATINDEX('[@.-_]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', '')))) > 0 -- Valid but cannot be starting character
                    OR PATINDEX('%[@.-_]', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', '')))) > 0 -- Valid but cannot be ending character
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) NOT LIKE '%@%.%' -- Must contain at least one @ and one .
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%..%' -- Cannot have two periods in a row
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%@%@%' -- Cannot have two @ anywhere
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%.@%'
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%@.%' -- Cannot have @ and . next to each other
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%.cm'
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%.or'
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%.ne' -- Missing last letter
           THEN
                   ''
               ELSE
                   LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', '')))
           END AS [Name],
           ISNULL(
                     CAST(YEAR(OCE.creation_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(OCE.creation_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(OCE.creation_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, OCE.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, OCE.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, OCE.creation_date) AS NVARCHAR(2)),
                     CAST(YEAR(OCE.updated_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(OCE.updated_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(OCE.updated_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, OCE.updated_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, OCE.updated_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, OCE.updated_date) AS NVARCHAR(2))
                 ) AS creation_date,
           ISNULL(
                     CAST(YEAR(OCE.updated_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(OCE.updated_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(OCE.updated_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, OCE.updated_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, OCE.updated_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, OCE.updated_date) AS NVARCHAR(2)),
                     CAST(YEAR(OCE.creation_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(OCE.creation_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(OCE.creation_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, OCE.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, OCE.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, OCE.creation_date) AS NVARCHAR(2))
                 ) AS updated_date
    FROM HCM.dbo.oncd_contact AS C
        INNER JOIN HCM.dbo.oncd_contact_email AS OCE
            ON OCE.contact_id = C.contact_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OCE.contact_id
    WHERE C.cst_do_not_email = 'Y'
          AND OCE.email <> ''
          AND ISNULL(OCE.cst_do_not_export, 'N') = 'N'
    UNION
    SELECT OCE.contact_email_id,
           C.contact_id AS Lead,
           CASE
               WHEN C.cst_do_not_email = 'Y' THEN
                   1
               ELSE
                   0
           END AS cst_do_not_email,
           CASE
               WHEN OCE.primary_flag = 'Y' THEN
                   1
               ELSE
                   0
           END AS primary_flag,
           CASE
               WHEN OCE.active = 'Y' THEN
                   'Active'
               ELSE
                   'Inactive'
           END AS [Status],
           CASE
               WHEN PATINDEX(
                                '%[&'',":;!+=\/()<>]%',
                                LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', '')))
                            ) > 0 -- Invalid characters
                    OR PATINDEX('[@.-_]%', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', '')))) > 0 -- Valid but cannot be starting character
                    OR PATINDEX('%[@.-_]', LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', '')))) > 0 -- Valid but cannot be ending character
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) NOT LIKE '%@%.%' -- Must contain at least one @ and one .
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%..%' -- Cannot have two periods in a row
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%@%@%' -- Cannot have two @ anywhere
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%.@%'
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%@.%' -- Cannot have @ and . next to each other
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%.cm'
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%.or'
                    OR LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', ''))) LIKE '%.ne' -- Missing last letter
           THEN
                   ''
               ELSE
                   LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(OCE.email, ''), ']', ''), '[', '')))
           END AS [Name],
           ISNULL(
                     CAST(YEAR(OCE.creation_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(OCE.creation_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(OCE.creation_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, OCE.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, OCE.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, OCE.creation_date) AS NVARCHAR(2)),
                     CAST(YEAR(OCE.updated_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(OCE.updated_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(OCE.updated_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, OCE.updated_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, OCE.updated_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, OCE.updated_date) AS NVARCHAR(2))
                 ) AS creation_date,
           ISNULL(
                     CAST(YEAR(OCE.updated_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(OCE.updated_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(OCE.updated_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, OCE.updated_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, OCE.updated_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, OCE.updated_date) AS NVARCHAR(2)),
                     CAST(YEAR(OCE.creation_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(OCE.creation_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(OCE.creation_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, OCE.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, OCE.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, OCE.creation_date) AS NVARCHAR(2))
                 ) AS updated_date
    FROM HCM.dbo.oncd_contact AS C
        INNER JOIN HCM.dbo.oncd_contact_email AS OCE
            ON OCE.contact_id = C.contact_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OCE.contact_id
    WHERE C.cst_do_not_email = 'N'
          AND OCE.email <> ''
          AND OCE.active = 'Y'
          AND ISNULL(OCE.cst_do_not_export, 'N') = 'N'
    ORDER BY C.contact_id;

END;
GO
