/* CreateDate: 01/24/2020 10:31:51.780 , ModifyDate: 01/30/2020 15:44:00.233 */
GO
/***********************************************************************
PROCEDURE:				spSvc_UpdateClientMilestoneRecordsBySession
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		1/24/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_UpdateClientMilestoneRecordsBySession ''
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_UpdateClientMilestoneRecordsBySession]
(
	@SessionID NVARCHAR(100)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


UPDATE	datClientMilestoneLog
SET		ClientMilestoneStatusID = 2
,		LastUpdate = GETDATE()
WHERE	SessionGUID = @SessionID
		AND Id IS NOT NULL


END
GO
