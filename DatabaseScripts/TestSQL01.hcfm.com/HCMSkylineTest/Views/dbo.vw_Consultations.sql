/* CreateDate: 11/08/2012 13:49:28.920 , ModifyDate: 11/08/2012 13:49:28.920 */
GO
CREATE VIEW [dbo].[vw_Consultations]
AS
SELECT  [oncd_contact].[contact_id]
,       [oncd_activity].[activity_id]
,       (SELECT TOP 1
                cst_center_number
         FROM   [oncd_company]
                INNER JOIN [oncd_contact_company]
                  ON [oncd_company].[company_id] = [oncd_contact_company].[company_id]
                     AND [oncd_contact_company].[contact_id] = [oncd_contact].[contact_id]
         WHERE  [oncd_contact_company].[primary_flag] <> 'Y'
         ORDER BY [oncd_contact_company].[sort_order]) AS 'AltCenter'
,       [oncd_activity].[due_date]
,		[oncd_activity].[start_time]
,       CONVERT(VARCHAR(10), [oncd_activity].[due_date], 101) + ' ' + [oncd_activity].[start_time] AS 'Appt'
,		CONVERT(VARCHAR(10), [oncd_activity].[completion_date], 101) AS 'CompletionDate'
,       (SELECT TOP 1
                cst_center_number
         FROM   [oncd_company]
                INNER JOIN [oncd_contact_company]
                  ON [oncd_company].[company_id] = [oncd_contact_company].[company_id]
                     AND [oncd_contact_company].[contact_id] = [oncd_contact].[contact_id]
         WHERE  [oncd_contact_company].[primary_flag] = 'Y') AS 'Center'
,       LTRIM(RTRIM([oncd_activity].[action_code])) AS 'action_code'
,       LTRIM(RTRIM([oncd_activity].[result_code])) AS 'result_code'
,       LTRIM(RTRIM([oncd_contact].[last_name])) AS 'last_name'
,		LTRIM(RTRIM([oncd_contact].[first_name])) AS 'first_name'
,       '(' + LTRIM(RTRIM([oncd_contact_phone].[area_code])) + ') ' + LEFT(LTRIM([oncd_contact_phone].[phone_number]), 3) + '-' + RIGHT(RTRIM([oncd_contact_phone].[phone_number]), 4) AS 'Phone'
,       LTRIM(RTRIM([oncd_contact].[cst_language_code])) As 'Language'
--,       LTRIM(RTRIM([csta_promotion_code].[description])) As 'Promo'
--,       LTRIM(RTRIM([oncd_contact_source].[source_code])) AS 'Source'
--,		CASE WHEN [oncd_activity].[result_code] = 'NOSHOW' THEN [cstd_contact_completion].[status_line] ELSE REPLACE([cstd_contact_completion].[status_line], ',', ',<br/>') END AS 'Status'
--,		LTRIM(RTRIM([cstd_contact_completion].[sale_type_code])) AS 'Type'
,       LTRIM(RTRIM([oncd_contact].[cst_complete_sale])) AS 'cst_complete_sale'
FROM    [oncd_contact]
        INNER JOIN [oncd_activity_contact]
          ON [oncd_contact].[contact_id] = [oncd_activity_contact].[contact_id]
        INNER JOIN [oncd_activity]
          ON [oncd_activity_contact].[activity_id] = [oncd_activity].[activity_id]
		INNER JOIN [oncd_contact_phone]
			ON [oncd_contact_phone].[contact_id] = [oncd_contact].[contact_id]
                AND [oncd_contact_phone].[primary_flag] = 'Y'
--		INNER JOIN [csta_promotion_code]
--			ON [csta_promotion_code].[promotion_code] = [oncd_contact].[cst_promotion_code]
--		INNER JOIN [oncd_contact_source]
--			ON [oncd_contact_source].[contact_id] = [oncd_contact].[contact_id]
--				AND [oncd_contact_source].[primary_flag] = 'Y'
--		INNER JOIN [HCM].[dbo].[cstd_contact_completion]
--			ON [oncd_activity].[activity_id] = [cstd_contact_completion].[activity_id]
--				AND [cstd_contact_completion].[contact_id] = [oncd_contact].[contact_id]
WHERE   ([oncd_activity].[due_date] > '1/1/2003')
        AND ([oncd_activity].[action_code] <> 'INACTIVE')
        AND ([oncd_activity].[due_date] IS NOT NULL)
GO
