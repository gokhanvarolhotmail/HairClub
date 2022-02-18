/* CreateDate: 11/28/2017 16:34:21.670 , ModifyDate: 11/28/2017 17:54:54.160 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmTaskProcess
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_SF_Bridge
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/27/2017
DESCRIPTION:			10/27/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extSalesforceToHcmTaskProcess 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmTaskProcess]
(
	@BatchID INT
)
AS
BEGIN
BEGIN TRY

/********************************** Create temp table objects *************************************/
CREATE TABLE #Task (
	RowID INT IDENTITY(1, 1)
,	SF_ID NVARCHAR(18)
)


/********************************** Get New Lead Task Records *************************************/
-- Create Audit Record
INSERT  INTO SFDC_HCM_AuditLog (
			BatchID
        ,	TableName
        ,	SalesforceID
		,	OnContactID
        ,	ActionTaken
		,	SortOrder
		)
        SELECT  lt.BatchID
        ,       'SFDC_HCM_LeadTask'
        ,       lt.cst_sfdc_task_id
		,		lt.activity_id
        ,       'Extracted Record'
		,		1
        FROM    SFDC_HCM_LeadTask lt
				LEFT OUTER JOIN SFDC_HCM_AuditLog al
					ON al.BatchID = lt.BatchID
						AND al.SalesforceID = lt.cst_sfdc_task_id
        WHERE   lt.BatchID = @BatchID
				AND al.SalesforceID IS NULL


-- Exclude Task records for excluded Leads.
UPDATE	lt
SET		IsExcludedFlag = 1
,		ExclusionMessage = l.ExclusionMessage
FROM	SFDC_HCM_LeadTask lt
		INNER JOIN SFDC_HCM_Lead l
			ON l.cst_sfdc_lead_id = lt.cst_sfdc_lead_id
				AND l.BatchID = lt.BatchID
WHERE	lt.BatchID = @BatchID
		AND ISNULL(l.IsExcludedFlag, 0) = 1
		AND ISNULL(lt.IsProcessedFlag, 0) = 0


INSERT	INTO #Task
		SELECT  lt.cst_sfdc_task_id AS 'SF_ID'
		FROM    SFDC_HCM_LeadTask lt
		WHERE   lt.BatchID = @BatchID
				AND ISNULL(lt.IsProcessedFlag, 0) = 0
				AND ISNULL(lt.IsExcludedFlag, 0) = 0
		ORDER BY lt.cst_sfdc_task_id


DECLARE @TotalCount INT
,		@LoopCount INT
,		@SF_ID NVARCHAR(18)


SET @TotalCount = (SELECT COUNT(*) FROM #Task t)
SET @LoopCount = 1


WHILE @LoopCount <= @TotalCount
BEGIN
	SET @SF_ID = (SELECT t.SF_ID FROM #Task t WHERE t.RowID = @LoopCount)


	PRINT @SF_ID


	-- Upsert Task
	EXEC extSalesforceToHcmTaskUpsert
		@SF_ID = @SF_ID,
		@BatchID = @BatchID


	-- Mark the record as processed
	UPDATE	SFDC_HCM_LeadTask
	SET		IsProcessedFlag = 1
	WHERE	BatchID = @BatchID
			AND cst_sfdc_task_id = @SF_ID
			AND ISNULL(IsProcessedFlag, 0) = 0


	-- Clear variables.
	SET @SF_ID = NULL


	SET @LoopCount = @LoopCount + 1
END
END TRY
BEGIN CATCH

-- Write Error Message to the Error Log Table
INSERT  INTO SFDC_HCM_ErrorLog (
			BatchID
        ,	TableName
        ,	SalesforceID
        ,	ErrorMessage
        ,	ErrorDate
		)
VALUES  (
			@BatchID
		,	'SFDC_HCM_LeadTask'
		,	@SF_ID
		,	ERROR_PROCEDURE() + ':' + ERROR_MESSAGE()
        ,	GETDATE()
		)


UPDATE	SFDC_HCM_LeadTask
SET		IsExcludedFlag = 1
,		ExclusionMessage = ERROR_PROCEDURE() + ':' + ERROR_MESSAGE()
WHERE	cst_sfdc_task_id = @SF_ID
		AND BatchID = @BatchID


DECLARE @ErrorMessage NVARCHAR(4000);
DECLARE @ErrorSeverity INT;
DECLARE @ErrorState INT;


SELECT  @ErrorMessage = ERROR_MESSAGE()
,       @ErrorSeverity = ERROR_SEVERITY()
,       @ErrorState = ERROR_STATE();


RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

END CATCH

END
GO
