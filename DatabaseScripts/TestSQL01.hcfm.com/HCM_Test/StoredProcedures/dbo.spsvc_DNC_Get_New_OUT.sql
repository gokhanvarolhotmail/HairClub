/* CreateDate: 03/20/2009 14:12:38.620 , ModifyDate: 05/01/2010 14:48:09.897 */
GO
/***********************************************************************

PROCEDURE:		spsvc_DNC_Get_New_OUT

DESTINATION SERVER:	hcsql3\sql2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		OnContact PSO Fred Remers

IMPLEMENTOR: 		Fred Remers

DATE IMPLEMENTED:

LAST REVISION DATE:

------------------------------------------------------------------------
NOTES: 	Gets a query for insert into the DNC_OUT table with new records.
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_DNC_Get_New_OUT

***********************************************************************/


CREATE PROCEDURE [dbo].[spsvc_DNC_Get_New_OUT] AS

SELECT  cstd_dnc_staging.phone,
	(select MAX(oncd_activity.due_date) from oncd_activity
		inner join oncd_activity_contact on oncd_activity_contact.contact_id = cstd_dnc_staging.contact_id
		and oncd_activity_contact.activity_id = oncd_activity.activity_id
		where (oncd_activity.action_code = 'INCALL' or oncd_activity.result_code IN ('SHOWSALE', 'SHOWNOSALE'))) as LastContactDate
FROM cstd_dnc_staging
WHERE cstd_dnc_staging.phone NOT IN (SELECT phone FROM cstd_dnc_out)
GROUP BY cstd_dnc_staging.phone,cstd_dnc_staging.contact_id
ORDER BY cstd_dnc_staging.phone
GO
