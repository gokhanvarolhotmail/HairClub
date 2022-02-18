/* CreateDate: 01/08/2018 11:48:41.243 , ModifyDate: 01/18/2018 08:58:27.867 */
GO
/***********************************************************************
PROCEDURE:				extHcmToSalesforceTaskUpdate
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

EXEC extHcmToSalesforceTaskUpdate
***********************************************************************/
CREATE PROCEDURE [dbo].[extHcmToSalesforceTaskUpdate]
(
	@ActivityID NCHAR(10),
	@SalesforceID NVARCHAR(18)

)
AS
BEGIN

UPDATE	OnContact_oncd_activity_TABLE
SET		cst_sfdc_task_id = @SalesforceID
,		updated_date = GETDATE()
,		updated_by_user_code = 'TM4000'
,		cst_do_not_export = 'Y'
,		cst_import_note = 'Updated from Salesforce'
WHERE	activity_id = @ActivityID
		AND cst_sfdc_task_id IS NULL

END
GO
