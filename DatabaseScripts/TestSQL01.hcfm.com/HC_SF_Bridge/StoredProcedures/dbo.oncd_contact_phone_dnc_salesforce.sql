/* CreateDate: 09/20/2017 13:03:53.193 , ModifyDate: 10/30/2017 12:00:45.733 */
GO
-- =============================================
-- Author:		Daniel Polania
-- Create date: 09/20/2017
-- Description:	THe purpose of this proc is ot gather all DNC numbers so that they can be loaded into sales force.
-- =============================================
CREATE PROCEDURE [dbo].[oncd_contact_phone_dnc_salesforce]
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


    --Get all phones that ar flagged as invalid or Inactive
    SELECT OC.contact_id,
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
    INTO #InactiveInvalidPhones
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_contact_phone AS OCP WITH (NOLOCK)
            ON OCP.contact_id = OC.contact_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OC.contact_id
        LEFT JOIN #cstd_phone_dnc_wireless AS CPDW WITH (NOLOCK)
            ON OCP.cst_full_phone_number = CPDW.phonenumber
    WHERE OC.contact_status_code NOT IN ( 'INVALID', 'TEST', 'CLIENT' )
          AND (
                  OCP.active = 'N'
                  OR OCP.cst_valid_flag = 'N'
              )
          AND ISNULL(OCP.cst_do_not_export, 'N') = 'N';

    --Get all phones labeled as do not call from lead record
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
    INTO #leaddonotcall
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_contact_phone AS OCP WITH (NOLOCK)
            ON OCP.contact_id = OC.contact_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OC.contact_id
        LEFT JOIN #cstd_phone_dnc_wireless AS CPDW WITH (NOLOCK)
            ON OCP.cst_full_phone_number = CPDW.phonenumber
    WHERE OC.contact_status_code NOT IN ( 'INVALID', 'TEST', 'CLIENT' )
          AND OC.cst_do_not_call = 'Y'
          AND ISNULL(OCP.cst_do_not_export, 'N') = 'N';

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
    INTO #badphones
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_contact_phone AS OCP WITH (NOLOCK)
            ON OCP.contact_id = OC.contact_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OC.contact_id
        LEFT JOIN #cstd_phone_dnc_wireless AS CPDW WITH (NOLOCK)
            ON OCP.cst_full_phone_number = CPDW.phonenumber
    WHERE OC.contact_status_code NOT IN ( 'INVALID', 'TEST', 'CLIENT' )
          AND ISNULL(OCP.cst_do_not_export, 'N') = 'N'
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


    --Get all flagged DNC numbers
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
    INTO #dnc
    FROM HCM.dbo.oncd_contact AS OC WITH (NOLOCK)
        INNER JOIN HCM.dbo.oncd_contact_phone AS OCP WITH (NOLOCK)
            ON OCP.contact_id = OC.contact_id
        INNER JOIN dbo.HCM_SFDC_Lead AS HSL
            ON HSL.contact_id = OC.contact_id
        LEFT JOIN #cstd_phone_dnc_wireless AS CPDW WITH (NOLOCK)
            ON OCP.cst_full_phone_number = CPDW.phonenumber
    WHERE OC.contact_status_code NOT IN ( 'INVALID', 'TEST', 'CLIENT' )
          AND CPDW.dnc_flag = 'Y'
          AND ISNULL(OCP.cst_do_not_export, 'N') = 'N';


    --Get all DNC that are Inactive and Invalid
    SELECT *
    INTO #DncInvalidInactive
    FROM #dnc AS D
    WHERE D.phone_number IN (
                                SELECT IIP.phone_number FROM #InactiveInvalidPhones AS IIP
                            )
          AND (
                  D.active = 'N'
                  OR D.cst_valid_flag = 'N'
              );


    --All DNC flagged numbers that are invalid or inactive excluding bad phone numbers I.E 999-999-9999
    SELECT DII.contact_id,
           CASE
               WHEN DII.cst_do_not_call = 'Y' THEN
                   '1'
               ELSE
                   '0'
           END AS cst_do_not_call,
           DII.contact_phone_id,
           CASE
               WHEN DII.phone_type_code IS NULL THEN
                   ''
               WHEN DII.phone_type_code = 'BACKLINE' THEN
                   'Back line'
               WHEN DII.phone_type_code = 'BUSINESS' THEN
                   'Business'
               WHEN DII.phone_type_code = 'CELL' THEN
                   'Cell'
               WHEN DII.phone_type_code = 'CELL2' THEN
                   'Cell 2'
               WHEN DII.phone_type_code = 'DIRPHONE' THEN
                   'Director phone'
               WHEN DII.phone_type_code = 'FAX' THEN
                   'Fax'
               WHEN DII.phone_type_code = 'HOME' THEN
                   'Home'
               WHEN DII.phone_type_code = 'HOME2' THEN
                   'Home 2'
               WHEN DII.phone_type_code = 'SKIP' THEN
                   'Skip'
               ELSE
                   DII.phone_type_code
           END AS phone_type_code,
           ISNULL(LTRIM(DII.country_code_prefix), '') AS country_code_prefix,
           DII.area_code,
           STUFF(DII.phone_number, 4, 0, '-') AS phone_number,
           ISNULL(DII.extension, '') AS extension,
           CASE
               WHEN DII.active = 'N' THEN
                   'Inactive'
               ELSE
                   'Active'
           END AS 'Status',
           DII.sort_order,
           ISNULL(
                     CAST(YEAR(DII.creation_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(DII.creation_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(DII.creation_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, DII.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, DII.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, DII.creation_date) AS NVARCHAR(2)),
                     ''
                 ) AS creation_date,
           CASE
               WHEN DII.primary_flag = 'N' THEN
                   '0'
               ELSE
                   '1'
           END AS primary_flag,
           CASE
               WHEN DII.cst_valid_flag = 'N' THEN
                   '0'
               ELSE
                   '1'
           END AS cst_valid_flag,
           ISNULL(
                     CAST(YEAR(DII.cst_last_dnc_date) AS NVARCHAR(4)) + '-'
                     + CAST(MONTH(DII.cst_last_dnc_date) AS NVARCHAR(2)) + '-'
                     + CAST(DAY(DII.cst_last_dnc_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, DII.cst_last_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, DII.cst_last_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, DII.cst_last_dnc_date) AS NVARCHAR(2)),
                     ''
                 ) AS cst_last_dnc_date,
           '(' + STUFF(STUFF(DII.cst_full_phone_number, 7, 0, '-'), 4, 0, ') ') AS cst_full_phone_number,
           CASE
               WHEN DII.dnc_flag = 'Y' THEN
                   '1'
               ELSE
                   '0'
           END dnc_flag,
           CASE
               WHEN DII.ebr_dnc_flag = 'Y' THEN
                   '1'
               WHEN DII.ebr_dnc_flag = 'N'
                    OR DII.ebr_dnc_flag IS NULL THEN
                   '0'
           END AS ebr_dnc_flag,
           ISNULL(
                     CAST(YEAR(DII.ebr_dnc_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(DII.ebr_dnc_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(DII.ebr_dnc_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, DII.ebr_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, DII.ebr_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, DII.ebr_dnc_date) AS NVARCHAR(2)),
                     ''
                 ) AS ebr_dnc_date
    FROM #DncInvalidInactive AS DII
    WHERE DII.contact_phone_id NOT IN (
                                          SELECT B.contact_phone_id FROM #badphones AS B
                                      )
    UNION --All DNC numbers that are active or valid excluding bad numbers I.E 999-999-9999
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
    FROM #dnc AS D
    WHERE D.contact_phone_id NOT IN (
                                        SELECT B.contact_phone_id FROM #badphones AS B
                                    )
    UNION --All Leads checked as Do Not Call excluding bad numbers i.e 999-999-9999
    SELECT L.contact_id,
           CASE
               WHEN L.cst_do_not_call = 'Y' THEN
                   '1'
               ELSE
                   '0'
           END AS cst_do_not_call,
           L.contact_phone_id,
           CASE
               WHEN L.phone_type_code IS NULL THEN
                   ''
               WHEN L.phone_type_code = 'BACKLINE' THEN
                   'Back line'
               WHEN L.phone_type_code = 'BUSINESS' THEN
                   'Business'
               WHEN L.phone_type_code = 'CELL' THEN
                   'Cell'
               WHEN L.phone_type_code = 'CELL2' THEN
                   'Cell 2'
               WHEN L.phone_type_code = 'DIRPHONE' THEN
                   'Director phone'
               WHEN L.phone_type_code = 'FAX' THEN
                   'Fax'
               WHEN L.phone_type_code = 'HOME' THEN
                   'Home'
               WHEN L.phone_type_code = 'HOME2' THEN
                   'Home 2'
               WHEN L.phone_type_code = 'SKIP' THEN
                   'Skip'
               ELSE
                   L.phone_type_code
           END AS phone_type_code,
           ISNULL(LTRIM(L.country_code_prefix), '') AS country_code_prefix,
           L.area_code,
           STUFF(L.phone_number, 4, 0, '-') AS phone_number,
           ISNULL(L.extension, '') AS extension,
           CASE
               WHEN L.active = 'N' THEN
                   'Inactive'
               ELSE
                   'Active'
           END AS 'Status',
           L.sort_order,
           ISNULL(
                     CAST(YEAR(L.creation_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(L.creation_date) AS NVARCHAR(2))
                     + '-' + CAST(DAY(L.creation_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, L.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, L.creation_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, L.creation_date) AS NVARCHAR(2)),
                     ''
                 ) AS creation_date,
           CASE
               WHEN L.primary_flag = 'N' THEN
                   '0'
               ELSE
                   '1'
           END AS primary_flag,
           CASE
               WHEN L.cst_valid_flag = 'N' THEN
                   '0'
               ELSE
                   '1'
           END AS cst_valid_flag,
           ISNULL(
                     CAST(YEAR(L.cst_last_dnc_date) AS NVARCHAR(4)) + '-'
                     + CAST(MONTH(L.cst_last_dnc_date) AS NVARCHAR(2)) + '-'
                     + CAST(DAY(L.cst_last_dnc_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, L.cst_last_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, L.cst_last_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, L.cst_last_dnc_date) AS NVARCHAR(2)),
                     ''
                 ) AS cst_last_dnc_date,
           '(' + STUFF(STUFF(L.cst_full_phone_number, 7, 0, '-'), 4, 0, ') ') AS cst_full_phone_number,
           CASE
               WHEN L.dnc_flag = 'Y' THEN
                   '1'
               ELSE
                   '0'
           END dnc_flag,
           CASE
               WHEN L.ebr_dnc_flag = 'Y' THEN
                   '1'
               WHEN L.ebr_dnc_flag = 'N'
                    OR L.ebr_dnc_flag IS NULL THEN
                   '0'
           END AS ebr_dnc_flag,
           ISNULL(
                     CAST(YEAR(L.ebr_dnc_date) AS NVARCHAR(4)) + '-' + CAST(MONTH(L.ebr_dnc_date) AS NVARCHAR(2)) + '-'
                     + CAST(DAY(L.ebr_dnc_date) AS NVARCHAR(2)) + 'T'
                     + CAST(DATEPART(HOUR, L.ebr_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(MINUTE, L.ebr_dnc_date) AS NVARCHAR(2)) + ':'
                     + CAST(DATEPART(SECOND, L.ebr_dnc_date) AS NVARCHAR(2)),
                     ''
                 ) AS ebr_dnc_date
    FROM #leaddonotcall AS L
    WHERE L.contact_phone_id NOT IN (
                                        SELECT B.contact_phone_id FROM #badphones AS B
                                    )
    ORDER BY contact_id;

    DROP TABLE #cstd_phone_dnc_wireless,
               #InactiveInvalidPhones,
               #leaddonotcall,
               #badphones,
               #dnc,
               #DncInvalidInactive;
END;
GO
