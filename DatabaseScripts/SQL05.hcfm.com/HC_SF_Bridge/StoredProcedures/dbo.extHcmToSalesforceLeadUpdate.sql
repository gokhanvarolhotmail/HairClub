/* CreateDate: 11/30/2017 11:55:14.950 , ModifyDate: 01/18/2018 08:58:13.750 */
GO
/***********************************************************************
PROCEDURE:				extHcmToSalesforceLeadUpdate
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

EXEC extHcmToSalesforceLeadUpdate
***********************************************************************/
CREATE PROCEDURE [dbo].[extHcmToSalesforceLeadUpdate]
(
	@ContactID NCHAR(10),
	@SalesforceID NVARCHAR(18)

)
AS
BEGIN

UPDATE	OnContact_oncd_contact_TABLE
SET		cst_sfdc_lead_id = @SalesforceID
,		updated_date = GETDATE()
,		updated_by_user_code = 'TM4000'
,		cst_do_not_export = 'Y'
,		cst_import_note = 'Updated from Salesforce'
WHERE	contact_id = @ContactID
		AND cst_sfdc_lead_id IS NULL

END
GO
