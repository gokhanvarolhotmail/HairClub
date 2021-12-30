/* CreateDate: 09/22/2008 15:04:53.017 , ModifyDate: 01/25/2010 08:11:31.823 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetCompletionDate
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
EXEC spApp_TREConsultations_GetCompletionDate 'SZXC21JFI1'
================================================================================================*/
CREATE PROCEDURE spApp_TREConsultations_GetCompletionDate
(
	@ActivityID VARCHAR(50)
)
AS
  BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    SET NOCOUNT ON ;

    SELECT  ISNULL(CONVERT(VARCHAR(10), [completion_date], 101), '') AS 'completion_date'
    FROM    [HCM].[dbo].[oncd_activity]
    WHERE   [activity_id] = @ActivityID
  END
GO
