/* CreateDate: 09/22/2008 15:04:06.877 , ModifyDate: 01/25/2010 08:11:31.823 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_DeleteContactCompletion
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
EXEC spApp_TREConsultations_DeleteContactCompletion '4YS150DITC', 'C2VOGIIITC'
================================================================================================*/
CREATE PROCEDURE spApp_TREConsultations_DeleteContactCompletion
(
	@ContactID VARCHAR(50),
	@ActivityID VARCHAR(50)
)
AS
BEGIN TRANSACTION

	DELETE  FROM [HCM].[dbo].[cstd_contact_completion]
	WHERE   [contact_id] = @ContactID
			AND [activity_id] = @ActivityID

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
