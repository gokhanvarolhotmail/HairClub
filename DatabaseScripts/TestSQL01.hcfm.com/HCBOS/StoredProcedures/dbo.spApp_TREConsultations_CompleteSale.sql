/* CreateDate: 09/22/2008 15:03:01.280 , ModifyDate: 01/25/2010 08:11:31.807 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_CompleteSale
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
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_CompleteSale
================================================================================================*/
CREATE PROCEDURE spApp_TREConsultations_CompleteSale
(
	@ActivityID VARCHAR(50),
	@ContactID VARCHAR(50),
	@CompletedBy VARCHAR(50)
)
AS
BEGIN TRANSACTION

	-- ONCD ACTIVITY.
	UPDATE  [HCM].[dbo].[oncd_activity]
	SET     [result_code] = 'SHOWSALE'
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

	-- ONCD CONTACT.
	UPDATE  [HCM].[dbo].[oncd_contact]
	SET     [cst_complete_sale] = 1
	WHERE   [contact_id] = @ContactID

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
