/* CreateDate: 11/08/2007 13:33:38.343 , ModifyDate: 05/01/2010 14:48:10.453 */
GO
/***********************************************************************

PROCEDURE:				spMNT_CleanUpAppointments

VERSION:				v1.0

DESTINATION SERVER:		HCSQL3\SQL2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	Oncontact

AUTHOR: 				Howared Abelow

IMPLEMENTOR: 			Brian Kellman

DATE IMPLEMENTED: 		11/08/2007

LAST REVISION DATE: 	----------

--------------------------------------------------------------------------------------------------------
NOTES: 	This procedure updates open appointments that have a record in the completions table.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC spMNT_CleanUpAppointments

***********************************************************************/


CREATE PROCEDURE spMNT_CleanUpAppointments
AS

	UPDATE [oncd_activity]
	SET [completed_by_user_code] = [cstd_contact_completion].[created_by_user_code]
	,	[completion_date] = CONVERT(datetime,CONVERT(varchar(11),[cstd_contact_completion].[date_saved]))
	,	[completion_time] = [cstd_contact_completion].[date_saved]
	,	[updated_by_user_code] = [cstd_contact_completion].[created_by_user_code]
	,	[updated_date] = CONVERT(datetime,CONVERT(varchar(11),[cstd_contact_completion].[date_saved]))
	,	[result_code] =
	CASE
			WHEN [cstd_contact_completion].[show_no_show_flag] = 'S' AND [cstd_contact_completion].[sale_no_sale_flag] = 'N' THEN 'SHOWNOSALE'
			WHEN [cstd_contact_completion].[show_no_show_flag] = 'S' AND [cstd_contact_completion].[sale_no_sale_flag] = 'S' THEN 'SHOWSALE'
			ELSE  'NOSHOW'
	END
	FROM [cstd_contact_completion]
	INNER JOIN [oncd_activity] ON [cstd_contact_completion].[activity_id] = [oncd_activity].[activity_id]
	WHERE [action_code] = 'APPOINT'
	AND ([result_code] IS NULL OR ltrim(rtrim([result_code])) = '')
	AND [due_date] < GETDATE()
GO
