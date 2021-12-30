/* CreateDate: 11/28/2017 16:33:12.890 , ModifyDate: 11/28/2017 16:33:12.890 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmLeadProcess
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

EXEC extSalesforceToHcmLeadProcess 1
***********************************************************************/
CREATE PROCEDURE [dbo].extSalesforceToHcmLeadProcess
(
	@BatchID INT
)
AS
BEGIN
BEGIN TRY

/********************************** Create temp table objects *************************************/
CREATE TABLE #Lead (
	RowID INT IDENTITY(1, 1)
,	SF_ID NVARCHAR(18)
)


/********************************** Get New Lead Records *************************************/
-- Create Audit Record
INSERT  INTO SFDC_HCM_AuditLog (
			BatchID
        ,	TableName
        ,	SalesforceID
		,	OnContactID
        ,	ActionTaken
		,	SortOrder
		)
        SELECT  l.BatchID
        ,       'SFDC_HCM_Lead'
        ,       l.cst_sfdc_lead_id
		,		l.contact_id
        ,       'Extracted Record'
		,		1
        FROM    SFDC_HCM_Lead l
				LEFT OUTER JOIN SFDC_HCM_AuditLog al
					ON al.BatchID = l.BatchID
						AND al.SalesforceID = l.cst_sfdc_lead_id
        WHERE   l.BatchID = @BatchID
				AND al.SalesforceID IS NULL


-- Exclude Client records.
UPDATE	SFDC_HCM_Lead
SET		IsExcludedFlag = 1
,		ExclusionMessage = 'Excluded from processing because this a client record.'
WHERE	BatchID = @BatchID
		AND LEFT(cst_sfdc_lead_id, 3) <> '00Q'
		AND ISNULL(IsProcessedFlag, 0) = 0


-- Exclude records with no Center ID.
UPDATE	SFDC_HCM_Lead
SET		IsExcludedFlag = 1
,		ExclusionMessage = 'Excluded from processing because the lead has no Center ID.'
WHERE	BatchID = @BatchID
		AND ISNULL(ISNULL(CenterNumber, CenterID), '0') = '0'
		AND ISNULL(IsProcessedFlag, 0) = 0


INSERT	INTO #Lead
		SELECT  l.cst_sfdc_lead_id AS 'SF_ID'
		FROM    SFDC_HCM_Lead l
		WHERE   BatchID = @BatchID
				AND ISNULL(l.IsProcessedFlag, 0) = 0
				AND ISNULL(l.IsExcludedFlag, 0) = 0


DECLARE	@TotalCount INT
,		@LoopCount INT
,		@SF_ID NVARCHAR(18)


SET @TotalCount = (SELECT COUNT(*) FROM #Lead l)
SET @LoopCount = 1


WHILE @LoopCount <= @TotalCount
BEGIN
	SET @SF_ID = (SELECT l.SF_ID FROM #Lead l WHERE l.RowID = @LoopCount)


	PRINT @SF_ID


	-- Upsert Lead Record
	EXEC extSalesforceToHcmLeadUpsert
		@SF_ID = @SF_ID,
		@BatchID = @BatchID


	-- Mark the record as processed
	UPDATE	SFDC_HCM_Lead
	SET		IsProcessedFlag = 1
	WHERE	BatchID = @BatchID
			AND cst_sfdc_lead_id = @SF_ID
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
		,	'SFDC_HCM_Lead'
		,	@SF_ID
		,	ERROR_PROCEDURE() + ':' + ERROR_MESSAGE()
        ,	GETDATE()
		)


UPDATE	SFDC_HCM_Lead
SET		IsExcludedFlag = 1
,		ExclusionMessage = ERROR_PROCEDURE() + ':' + ERROR_MESSAGE()
WHERE	cst_sfdc_lead_id = @SF_ID
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
