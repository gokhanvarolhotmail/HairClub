/* CreateDate: 06/16/2014 15:26:37.760 , ModifyDate: 07/30/2014 13:29:22.280 */
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSActivitySearch
DESTINATION SERVER:		SQL03
DESTINATION DATABASE:	HCM
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		06/05/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHairClubCMSActivitySearch 'GGKC97BD01', 'DS0M5SA791'
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSActivitySearch]
(
	@ContactID VARCHAR(10),
	@ActivityID VARCHAR(10)
)
AS
BEGIN

SELECT  info.contact_id
,       a.activity_id
,       CASE WHEN LEN(info.alt_center) > 0 THEN info.alt_center
             ELSE info.territory
        END AS 'center'
,       info.first_name
,       info.last_name
,       a.creation_date
,       MAX(a.due_date) AS 'due_date'
,       CONVERT(VARCHAR, a.start_time, 108) AS 'start_time'
,       ISNULL(a.action_code, '') AS 'action_code'
,       ISNULL(a.result_code, '') AS 'result_code'
FROM    lead_info info WITH ( NOLOCK )
        INNER JOIN oncd_activity_contact ac
            ON info.contact_id = ac.contact_id
               AND ac.primary_flag = 'Y'
        INNER JOIN oncd_activity a WITH ( NOLOCK )
            ON a.activity_id = ac.activity_id
WHERE   info.contact_id = @ContactID
		AND a.activity_id = @ActivityID
GROUP BY info.contact_id
,       a.activity_id
,       CASE WHEN LEN(info.alt_center) > 0 THEN info.alt_center
             ELSE info.territory
        END
,       info.first_name
,       info.last_name
,       a.creation_date
,       a.start_time
,       a.action_code
,       a.result_code
,       a.completion_date
ORDER BY MAX(a.due_date)

END
GO
