/* CreateDate: 11/13/2017 15:01:22.767 , ModifyDate: 11/13/2017 15:01:22.767 */
GO
/*
==============================================================================
PROCEDURE:				oncd_contact_salesforce_leads

AUTHOR: 				Daniel Polania

IMPLEMENTOR: 			Daniel Polania

DATE IMPLEMENTED: 		10/13/2017


==============================================================================
DESCRIPTION:	Reads data from the Batch LeadTaks table to load Task to SFDC
==============================================================================
NOTES:
		* 11/13/2017 DP - Created proc

==============================================================================
SAMPLE EXECUTION:
EXEC [dbo].[HCM_SFDC_LeadsNew]
==============================================================================
*/
CREATE PROCEDURE [dbo].[HCM_SFDC_LeadTaskLoad]
AS
BEGIN

    SET NOCOUNT ON;

    SELECT HSBLT.activity_id,
           HSBLT.cst_sfdc_lead_id,
           HSBLT.Subject,
           HSBLT.action_code,
           HSBLT.cst_activity_type_code,
           HSBLT.result_code,
           HSBLT.creation_date,
           HSBLT.updated_date,
           HSBLT.due_date,
           HSBLT.company_id,
           HSBLT.completion_date,
           HSBLT.UserCode,
           HSBLT.sf_status,
           HSBLT.OwnerId,
           HSBLT.CreatedByL,
           HSBLT.AppointmentDate,
           HSBLT.ActivityDate,
           HSBLT.StartTime,
           HSBLT.disc_style,
           HSBLT.price_quoted,
           HSBLT.ludwig,
           HSBLT.Maritial_status,
           HSBLT.norwood,
           HSBLT.Occupation_status,
           HSBLT.solution_offered,
           HSBLT.no_sale_reason,
           HSBLT.performer,
           HSBLT.sale_type_code,
           HSBLT.sale_type_description,
           HSBLT.contact_id,
           HSBLT.lead,
           HSBLT.Processed,
           HSBLT.batch_date
    FROM dbo.HCM_SFDC_Batch_LeadTask AS HSBLT
    WHERE HSBLT.batch_processed = 0;

END;
GO
