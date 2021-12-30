/* CreateDate: 04/20/2018 15:27:13.337 , ModifyDate: 09/16/2020 13:38:59.880 */
GO
/***********************************************************************
PROCEDURE:				extDeletionTrackerFlagDataAsProcessed
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_BI_SFDC
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/20/2018
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extDeletionTrackerFlagDataAsProcessed 'B7FA846C-9137-42C9-9D52-1BF6D54DBB84'
***********************************************************************/
CREATE PROCEDURE [dbo].[extDeletionTrackerFlagDataAsProcessed]
(
	@SessionID NVARCHAR(100)
)
AS
BEGIN

SET NOCOUNT ON;


SELECT  dt.Id AS 'RecordID'
,       0 AS 'ToBeProcessed__c'
,       GETUTCDATE() AS 'LastProcessedDate__c'
FROM    HCDeletionTracker__c dt
WHERE   dt.SessionID = @SessionID
		AND ISNULL(dt.ToBeProcessed__c, 0) = 0
		AND ISNULL(dt.IsProcessed, 0) = 1

END
GO
