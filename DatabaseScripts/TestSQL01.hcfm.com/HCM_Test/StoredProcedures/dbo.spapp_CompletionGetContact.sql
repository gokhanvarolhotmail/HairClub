/* CreateDate: 09/04/2007 09:40:45.573 , ModifyDate: 05/14/2013 12:14:22.733 */
GO
/*==============================================================================

PROCEDURE:				spapp_CompletionGetContact

VERSION:				v1.0

DESTINATION SERVER:		HCSQL3\SQL2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	Completions

AUTHOR: 				Howard Abelow

IMPLEMENTOR: 			Howard Abelow

DATE IMPLEMENTED: 		 8/23/2007

LAST REVISION DATE: 	 8/23/2007

==============================================================================
DESCRIPTION:	Resets a completed appointment to be open
==============================================================================

==============================================================================
NOTES:
	05/07/2013 - MB - Added option for NULL result code
	05/13/2013 - KM - Added in Result Code in Cancel, Reschedule
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spapp_CompletionGetContact 'OXMOFMGITX'
==============================================================================*/



CREATE PROCEDURE [dbo].[spapp_CompletionGetContact]
		@contact_id varchar(10)

AS



	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SELECT
			info.contact_id
		,	a.activity_id
		,	CASE WHEN LEN(info.alt_center) > 0 THEN info.alt_center ELSE info.territory END  as center
	    ,	info.first_name
		,	info.last_name
		,	a.creation_date
		,	MAX(a.due_date) as due_date -- latest completion
		,	CONVERT(VARCHAR, a.start_time, 108) AS start_time
		,	a.action_code
		,	a.result_code
		,	a.completion_date

	FROM dbo.lead_info info  WITH(NOLOCK)
		INNER JOIN oncd_activity_contact ac
			ON info.contact_id = ac.contact_id
				AND ac.primary_flag = 'Y'
		INNER JOIN dbo.oncd_activity a  WITH(NOLOCK)
			ON a.activity_id = ac.activity_id
				--AND (LEN(a.completion_date) > 0 OR a.completion_date IS NOT NULL)

	WHERE info.contact_id = @contact_id
		--AND a.action_code = 'APPOINT'   not quite sure if there are other act_codes that can be completed
		AND (
					a.result_code LIKE '%SHOW%'
				OR info.[cst_complete_sale] = 1
				OR a.result_code IS NULL
				OR a.result_code in ('CANCEL','RESCHEDULE')
				)  -- this actually finds NOSHOW, SHOWSALE, SHOWNOSALE or a complete sale- basically all completions
		AND a.[action_code] IN ('APPOINT', 'INHOUSE', 'BEBACK')
	GROUP BY
			info.contact_id
		,	a.activity_id
		,	CASE WHEN LEN(info.alt_center) > 0 THEN info.alt_center ELSE info.territory END
	    ,	info.first_name
		,	info.last_name
		,	a.creation_date
		,	a.start_time
		,	a.action_code
		,	a.result_code
		,	a.completion_date
	ORDER BY MAX(a.due_date)

	END
GO
