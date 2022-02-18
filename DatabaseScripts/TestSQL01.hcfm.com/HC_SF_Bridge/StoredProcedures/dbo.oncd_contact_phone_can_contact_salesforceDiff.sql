/* CreateDate: 10/30/2017 14:04:38.000 , ModifyDate: 10/30/2017 14:04:38.000 */
GO
-- =============================================
-- Author:		Daniel Polania
-- Create date: 09/20/2017
-- Description:	THe purpose of this proc is ot gather all DNC numbers so that they can be loaded into sales force.
-- =============================================
CREATE PROCEDURE [dbo].[oncd_contact_phone_can_contact_salesforceDiff]
AS
BEGIN

    SET NOCOUNT ON;

    --Get all phones that have been added to DNC table
    SELECT CPDW.phone_dnc_wireless_id,
           CPDW.phonenumber,
           CPDW.dnc_flag,
           CPDW.dnc_flag_user_code,
           CPDW.dnc_date,
           CPDW.ebr_dnc_flag,
           CPDW.ebr_dnc_date,
           CPDW.wireless_flag,
           CPDW.wireless_date,
           CPDW.last_vendor_update,
           CPDW.creation_date,
           CPDW.created_by_user_code,
           CPDW.updated_date,
           CPDW.updated_by_user_code
    INTO #cstd_phone_dnc_wireless
    FROM SQL03.HCM.dbo.cstd_phone_dnc_wireless AS CPDW WITH (NOLOCK);


    --Get all phones that ar flagged as Valid or Active
    SELECT HSLP.cst_sfdc_phone_id,
           OC.contact_id,
           OCP.contact_phone_id,
           OCP.phone_type_code,
           OCP.country_code_prefix,
           OCP.area_code,
           OCP.phone_number,
           OCP.extension,
           OCP.description,
           OCP.active,
           OCP.sort_order,
           OCP.creation_date,
           OCP.primary_flag,
           OCP.cst_valid_flag,
           OCP.cst_last_dnc_date,
           OCP.cst_full_phone_number,
           CPDW.dnc_flag,
           CPDW.dnc_date,
           CPDW.ebr_dnc_flag,
           CPDW.ebr_dnc_date
    --INTO #ActiveValidPhones
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OC.contact_id
        INNER JOIN HCM.dbo.oncd_contact_phone AS OCP WITH (NOLOCK)
            ON OCP.contact_id = OC.contact_id
        LEFT JOIN #cstd_phone_dnc_wireless AS CPDW WITH (NOLOCK)
            ON OCP.cst_full_phone_number = CPDW.phonenumber
        LEFT JOIN dbo.HCM_SFDC_LeadPhone AS HSLP
            ON OCP.contact_phone_id = HSLP.contact_phone_id
    WHERE OC.contact_status_code NOT IN ( 'INVALID', 'TEST', 'CLIENT' )
          AND (
                  OCP.active = 'Y'
                  OR OCP.cst_valid_flag = 'Y'
              )
          AND ISNULL(OCP.cst_do_not_export, 'N') = 'N'
          AND HSLP.cst_sfdc_phone_id IS NULL;


    --Get all phones NOT labeled as do not call from lead record
    SELECT OC.contact_id,
           OC.cst_do_not_call,
           OCP.contact_phone_id,
           OCP.phone_type_code,
           OCP.country_code_prefix,
           OCP.area_code,
           OCP.phone_number,
           OCP.extension,
           OCP.description,
           OCP.active,
           OCP.sort_order,
           OCP.creation_date,
           OCP.primary_flag,
           OCP.cst_valid_flag,
           OCP.cst_last_dnc_date,
           OCP.cst_full_phone_number,
           CPDW.dnc_flag,
           CPDW.dnc_date,
           CPDW.ebr_dnc_flag,
           CPDW.ebr_dnc_date
    INTO #LeadCanCall
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_contact_phone AS OCP WITH (NOLOCK)
            ON OCP.contact_id = OC.contact_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OC.contact_id
        LEFT JOIN #cstd_phone_dnc_wireless AS CPDW WITH (NOLOCK)
            ON OCP.cst_full_phone_number = CPDW.phonenumber
        LEFT JOIN dbo.HCM_SFDC_LeadPhone AS HSLP
            ON OCP.contact_phone_id = HSLP.contact_phone_id
    WHERE OC.contact_status_code NOT IN ( 'INVALID', 'TEST', 'CLIENT' )
          AND OC.cst_do_not_call = 'N'
          AND ISNULL(OCP.cst_do_not_export, 'N') = 'N'
          AND HSLP.cst_sfdc_phone_id IS NULL;


    --Get all bad sequence numbers i.e: 9999999999
    SELECT OC.contact_id,
           OC.cst_do_not_call,
           OCP.contact_phone_id,
           OCP.phone_type_code,
           OCP.country_code_prefix,
           OCP.area_code,
           OCP.phone_number,
           OCP.extension,
           OCP.active,
           OCP.sort_order,
           OCP.creation_date,
           OCP.primary_flag,
           OCP.cst_valid_flag,
           OCP.cst_last_dnc_date,
           OCP.cst_full_phone_number,
           CPDW.dnc_flag,
           CPDW.dnc_date,
           CPDW.ebr_dnc_flag,
           CPDW.ebr_dnc_date
    INTO #BadPhones
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_contact_phone AS OCP WITH (NOLOCK)
            ON OCP.contact_id = OC.contact_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OC.contact_id
        LEFT JOIN #cstd_phone_dnc_wireless AS CPDW WITH (NOLOCK)
            ON OCP.cst_full_phone_number = CPDW.phonenumber
        LEFT JOIN dbo.HCM_SFDC_LeadPhone AS HSLP
            ON OCP.contact_phone_id = HSLP.contact_phone_id
    WHERE OC.contact_status_code NOT IN ( 'INVALID', 'TEST', 'CLIENT' )
          AND ISNULL(OCP.cst_do_not_export, 'N') = 'N'
          AND HSLP.cst_sfdc_phone_id IS NULL
          AND (
                  OCP.phone_number LIKE '%[0-0][0-0][0-0][0-0][0-0][0-0][0-0]%'
                  OR OCP.phone_number LIKE '%[1-1][1-1][1-1][1-1][1-1][1-1][1-1]%'
                  OR OCP.phone_number LIKE '%[2-2][2-2][2-2][2-2][2-2][2-2][2-2]%'
                  OR OCP.phone_number LIKE '%[3-3][3-3][3-3][3-3][3-3][3-3][3-3]%'
                  OR OCP.phone_number LIKE '%[4-4][4-4][4-4][4-4][4-4][4-4][4-4]%'
                  OR OCP.phone_number LIKE '%[5-5][5-5][5-5][5-5][5-5][5-5][5-5]%'
                  OR OCP.phone_number LIKE '%[5-5][5-5][5-5][0-0][0-0][0-0][0-0]%'
                  OR OCP.phone_number LIKE '%[6-6][6-6][6-6][6-6][6-6][6-6][6-6]%'
                  OR OCP.phone_number LIKE '%[7-7][7-7][7-7][7-7][7-7][7-7][7-7]%'
                  OR OCP.phone_number LIKE '%[8-8][8-8][8-8][8-8][8-8][8-8][8-8]%'
                  OR OCP.phone_number LIKE '%[9-9][9-9][9-9][9-9][9-9][9-9][9-9]%'
                  OR OCP.phone_number LIKE '%[9-9][9-9][9-9][ ][9-9][9-9][9-9][9-9]%'
                  OR OCP.phone_number LIKE '%[1-1][2-2][3-3][1-1][2-2][3-3][4-4]%'
                  OR OCP.phone_number LIKE '%[4-4][5-5][6-6][7-7][8-8][9-9][0-0]%'
                  OR OCP.phone_number LIKE '%[4-4][5-5][6-6][7-7][8-8][9-9][1-1]%'
                  OR OCP.phone_number LIKE '%[2-2][2-2][2-2][3-3][3-3][3-3][3-3]%'
                  OR OCP.phone_number LIKE '%XXXXXXX%'
                  OR OCP.phone_number LIKE '%*******%'
                  OR OCP.phone_number LIKE '%.......%'
                  OR OCP.cst_full_phone_number IS NULL
                  OR OCP.area_code LIKE '[0-0]%'
                  OR OCP.area_code LIKE '[1-1]%'
                  OR OCP.area_code LIKE '[2-2][0-0][0-0]%'
                  OR OCP.area_code LIKE '[ ]%'
              );


    --Get all numbers that are not flagged as DNC
    SELECT OC.contact_id,
           OC.cst_do_not_call,
           OCP.contact_phone_id,
           OCP.phone_type_code,
           OCP.country_code_prefix,
           OCP.area_code,
           OCP.phone_number,
           OCP.extension,
           OCP.active,
           OCP.sort_order,
           OCP.creation_date,
           OCP.primary_flag,
           OCP.cst_valid_flag,
           OCP.cst_last_dnc_date,
           OCP.cst_full_phone_number,
           CPDW.dnc_flag,
           CPDW.dnc_date,
           CPDW.ebr_dnc_flag,
           CPDW.ebr_dnc_date
    INTO #NonDnc
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_contact_phone AS OCP WITH (NOLOCK)
            ON OCP.contact_id = OC.contact_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OC.contact_id
        LEFT JOIN #cstd_phone_dnc_wireless AS CPDW WITH (NOLOCK)
            ON OCP.cst_full_phone_number = CPDW.phonenumber
        LEFT JOIN dbo.HCM_SFDC_LeadPhone AS HSLP
            ON OCP.contact_phone_id = HSLP.contact_phone_id
    WHERE OC.contact_status_code NOT IN ( 'INVALID', 'TEST', 'CLIENT' )
          AND (
                  CPDW.dnc_flag = 'N'
                  OR CPDW.dnc_flag IS NULL
              )
          AND HSLP.cst_sfdc_phone_id IS NULL
          AND ISNULL(OCP.cst_do_not_export, 'N') = 'N';


    --All None DNC numbers that are active or valid
    SELECT D.contact_id,
           CASE
               WHEN D.cst_do_not_call = 'Y' THEN
                   '1'
               ELSE
                   '0'
           END AS cst_do_not_call,
           D.contact_phone_id,
           CASE
               WHEN D.phone_type_code IS NULL THEN
                   ''
               WHEN D.phone_type_code = 'BACKLINE' THEN
                   'Back line'
               WHEN D.phone_type_code = 'BUSINESS' THEN
                   'Business'
               WHEN D.phone_type_code = 'CELL' THEN
                   'Cell'
               WHEN D.phone_type_code = 'CELL2' THEN
                   'Cell 2'
               WHEN D.phone_type_code = 'DIRPHONE' THEN
                   'Director phone'
               WHEN D.phone_type_code = 'FAX' THEN
                   'Fax'
               WHEN D.phone_type_code = 'HOME' THEN
                   'Home'
               WHEN D.phone_type_code = 'HOME2' THEN
                   'Home 2'
               WHEN D.phone_type_code = 'SKIP' THEN
                   'Skip'
               ELSE
                   D.phone_type_code
           END AS phone_type_code,
           ISNULL(LTRIM(D.country_code_prefix), '') AS country_code_prefix,
           D.area_code,
           STUFF(D.phone_number, 4, 0, '-') AS phone_number,
           ISNULL(D.extension, '') AS extension,
           CASE
               WHEN D.active = 'N' THEN
                   'Inactive'
               ELSE
                   'Active'
           END AS 'Status',
           D.sort_order,
           ISNULL(
                     CAST(YEAR(D.creation_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(D.creation_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(D.creation_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, D.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, D.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, D.creation_date) AS NVARCHAR(2)),
                     ''
                 ) AS creation_date,
           CASE
               WHEN D.primary_flag = 'N' THEN
                   '0'
               ELSE
                   '1'
           END AS primary_flag,
           CASE
               WHEN D.cst_valid_flag = 'N' THEN
                   '0'
               ELSE
                   '1'
           END AS cst_valid_flag,
           ISNULL(
                     CAST(YEAR(D.cst_last_dnc_date) AS NVARCHAR(4)) + '-'
                     + CAST(MONTH(D.cst_last_dnc_date) AS NVARCHAR(2)) + '-'
                     + CAST(DAY(D.cst_last_dnc_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, D.cst_last_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, D.cst_last_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, D.cst_last_dnc_date) AS NVARCHAR(2)),
                     ''
                 ) AS cst_last_dnc_date,
           '(' + STUFF(STUFF(D.cst_full_phone_number, 7, 0, '-'), 4, 0, ') ') AS cst_full_phone_number,
           CASE
               WHEN D.dnc_flag = 'Y' THEN
                   '1'
               ELSE
                   '0'
           END dnc_flag,
           CASE
               WHEN D.ebr_dnc_flag = 'Y' THEN
                   '1'
               WHEN D.ebr_dnc_flag = 'N'
                    OR D.ebr_dnc_flag IS NULL THEN
                   '0'
           END AS ebr_dnc_flag,
           ISNULL(
                     CAST(YEAR(D.ebr_dnc_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(D.ebr_dnc_date) AS NVARCHAR(2)) + '-'
                     + CAST(DAY(D.ebr_dnc_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, D.ebr_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, D.ebr_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, D.ebr_dnc_date) AS NVARCHAR(2)),
                     ''
                 ) AS ebr_dnc_date
    FROM #NonDnc AS D
    WHERE D.contact_phone_id NOT IN (
                                        SELECT B.contact_phone_id FROM #BadPhones AS B
                                    )
          AND D.phone_type_code != 'SKIP'
          AND D.cst_do_not_call = 'N'
    UNION
    SELECT LCC.contact_id,
           CASE
               WHEN LCC.cst_do_not_call = 'Y' THEN
                   '1'
               ELSE
                   '0'
           END AS cst_do_not_call,
           LCC.contact_phone_id,
           CASE
               WHEN LCC.phone_type_code IS NULL THEN
                   ''
               WHEN LCC.phone_type_code = 'BACKLINE' THEN
                   'Back line'
               WHEN LCC.phone_type_code = 'BUSINESS' THEN
                   'Business'
               WHEN LCC.phone_type_code = 'CELL' THEN
                   'Cell'
               WHEN LCC.phone_type_code = 'CELL2' THEN
                   'Cell 2'
               WHEN LCC.phone_type_code = 'DIRPHONE' THEN
                   'Director phone'
               WHEN LCC.phone_type_code = 'FAX' THEN
                   'Fax'
               WHEN LCC.phone_type_code = 'HOME' THEN
                   'Home'
               WHEN LCC.phone_type_code = 'HOME2' THEN
                   'Home 2'
               WHEN LCC.phone_type_code = 'SKIP' THEN
                   'Skip'
               ELSE
                   LCC.phone_type_code
           END AS phone_type_code,
           ISNULL(LTRIM(LCC.country_code_prefix), '') AS country_code_prefix,
           LCC.area_code,
           STUFF(LCC.phone_number, 4, 0, '-') AS phone_number,
           ISNULL(LCC.extension, '') AS extension,
           CASE
               WHEN LCC.active = 'N' THEN
                   'Inactive'
               ELSE
                   'Active'
           END AS 'Status',
           LCC.sort_order,
           ISNULL(
                     CAST(YEAR(LCC.creation_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(LCC.creation_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(LCC.creation_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, LCC.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, LCC.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, LCC.creation_date) AS NVARCHAR(2)),
                     ''
                 ) AS creation_date,
           CASE
               WHEN LCC.primary_flag = 'N' THEN
                   '0'
               ELSE
                   '1'
           END AS primary_flag,
           CASE
               WHEN LCC.cst_valid_flag = 'N' THEN
                   '0'
               ELSE
                   '1'
           END AS cst_valid_flag,
           ISNULL(
                     CAST(YEAR(LCC.cst_last_dnc_date) AS NVARCHAR(4)) + '-'
                     + CAST(MONTH(LCC.cst_last_dnc_date) AS NVARCHAR(2)) + '-'
                     + CAST(DAY(LCC.cst_last_dnc_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, LCC.cst_last_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, LCC.cst_last_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, LCC.cst_last_dnc_date) AS NVARCHAR(2)),
                     ''
                 ) AS cst_last_dnc_date,
           '(' + STUFF(STUFF(LCC.cst_full_phone_number, 7, 0, '-'), 4, 0, ') ') AS cst_full_phone_number,
           CASE
               WHEN LCC.dnc_flag = 'Y' THEN
                   '1'
               ELSE
                   '0'
           END dnc_flag,
           CASE
               WHEN LCC.ebr_dnc_flag = 'Y' THEN
                   '1'
               WHEN LCC.ebr_dnc_flag = 'N'
                    OR LCC.ebr_dnc_flag IS NULL THEN
                   '0'
           END AS ebr_dnc_flag,
           ISNULL(
                     CAST(YEAR(LCC.ebr_dnc_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(LCC.ebr_dnc_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(LCC.ebr_dnc_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, LCC.ebr_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, LCC.ebr_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, LCC.ebr_dnc_date) AS NVARCHAR(2)),
                     ''
                 ) AS ebr_dnc_date
    FROM #LeadCanCall AS LCC
    WHERE LCC.contact_phone_id NOT IN (
                                          SELECT B.contact_phone_id FROM #BadPhones AS B
                                      )
          AND LCC.phone_type_code != 'SKIP'
          AND (
                  LCC.dnc_flag = 'N'
                  OR LCC.dnc_flag IS NULL
              )
    ORDER BY contact_id;


    DROP TABLE #cstd_phone_dnc_wireless,
               #ActiveValidPhones,
               #LeadCanCall,
               #BadPhones,
               #NonDnc;
END;
GO
