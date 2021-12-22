/* CreateDate: 09/22/2008 15:03:10.080 , ModifyDate: 01/25/2010 08:11:31.807 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_CompleteShow
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			7/14/2008
-- Date Implemented:		7/14/2008
-- Date Last Modified:		7/14/2008
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	HCM
-- Related Application:		The Right Experience
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
--
-- 09/28/2009 - DL	--> Moved oncd_contact update into this procedure as the SHNOBUYCAL Trigger
--					--> was being bypassed because the contact was being updated AFTER the activity.
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_CompleteShow
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_CompleteShow]
(
	@ActivityID VARCHAR(50),
	@ContactID VARCHAR(50),
	@SurgeryConsultation CHAR(1),
	@CompletedBy VARCHAR(50)
)
AS
BEGIN TRANSACTION

	UPDATE  [HCM].[dbo].[oncd_contact]
	SET     [surgery_consultation_flag] = @SurgeryConsultation
	WHERE   [contact_id] = @ContactID

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

	UPDATE  [HCM].[dbo].[oncd_activity]
	SET     [result_code] = 'SHOWNOSALE'
	,       [completion_date] = CAST(CONVERT(VARCHAR(11), GETDATE(), 101) AS DATETIME)
	,		[completion_time] = (GETDATE() - CAST(ROUND(CAST(GETDATE() AS FLOAT), 0, 1) AS DATETIME))
	,       [completed_by_user_code] = @CompletedBy
	,       [updated_date] = GETDATE()
	,       [updated_by_user_code] = @CompletedBy
	WHERE   [activity_id] = @ActivityID

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
