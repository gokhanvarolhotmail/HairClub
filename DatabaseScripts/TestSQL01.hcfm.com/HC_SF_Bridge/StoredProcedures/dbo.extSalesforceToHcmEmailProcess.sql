/* CreateDate: 11/28/2017 16:49:57.860 , ModifyDate: 11/28/2017 17:56:01.943 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmEmailProcess
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

EXEC extSalesforceToHcmEmailProcess 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmEmailProcess]
(
	@BatchID INT
)
AS
BEGIN
BEGIN TRY

/********************************** Create temp table objects *************************************/
CREATE TABLE #LeadEmail (
	RowID INT IDENTITY(1, 1)
,	SF_ID NVARCHAR(18)
)


/********************************** Get New Lead Email Records *************************************/
-- Create Audit Record
INSERT  INTO SFDC_HCM_AuditLog (
			BatchID
        ,	TableName
        ,	SalesforceID
		,	OnContactID
        ,	ActionTaken
		,	SortOrder
		)
        SELECT  le.BatchID
        ,       'SFDC_HCM_LeadEmail'
        ,       le.cst_sfdc_email_id
		,		le.contact_email_id
        ,       'Extracted Record'
		,		1
        FROM    SFDC_HCM_LeadEmail le
				LEFT OUTER JOIN SFDC_HCM_AuditLog al
					ON al.BatchID = le.BatchID
						AND al.SalesforceID = le.cst_sfdc_email_id
        WHERE   le.BatchID = @BatchID
				AND al.SalesforceID IS NULL


---- Exclude Client records.
--UPDATE	SFDC_HCM_LeadEmail
--SET		IsExcludedFlag = 1
--,		ExclusionMessage = 'Excluded from processing because this email address belongs to a client record.'
--WHERE	BatchID = @BatchID
--		AND LEFT(cst_sfdc_lead_id, 3) <> '00Q'
--		AND ISNULL(IsProcessedFlag, 0) = 0


-- Exclude Email records for excluded Leads.
UPDATE	le
SET		IsExcludedFlag = 1
,		ExclusionMessage = l.ExclusionMessage
FROM	SFDC_HCM_LeadEmail le
		INNER JOIN SFDC_HCM_Lead l
			ON l.cst_sfdc_lead_id = le.cst_sfdc_lead_id
				AND l.BatchID = le.BatchID
WHERE	le.BatchID = @BatchID
		AND ISNULL(l.IsExcludedFlag, 0) = 1
		AND ISNULL(le.IsProcessedFlag, 0) = 0


INSERT	INTO #LeadEmail
		SELECT  le.cst_sfdc_email_id
		FROM    SFDC_HCM_LeadEmail le
		WHERE   le.BatchID = @BatchID
				AND ISNULL(le.IsProcessedFlag, 0) = 0
				AND ISNULL(le.IsExcludedFlag, 0) = 0


DECLARE	@TotalCount INT
,		@LoopCount INT
,		@SF_ID NVARCHAR(18)


SET @TotalCount = (SELECT COUNT(*) FROM #LeadEmail le)
SET @LoopCount = 1


WHILE @LoopCount <= @TotalCount
BEGIN
	SET @SF_ID = (SELECT le.SF_ID FROM #LeadEmail le WHERE le.RowID = @LoopCount)


	PRINT @SF_ID


	-- Upsert Lead Email Record
	EXEC extSalesforceToHcmEmailUpsert
		@SF_ID = @SF_ID,
		@BatchID = @BatchID


	-- Mark the record as processed
	UPDATE	SFDC_HCM_LeadEmail
	SET		IsProcessedFlag = 1
	WHERE	BatchID = @BatchID
			AND cst_sfdc_email_id = @SF_ID
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
		,	'SFDC_HCM_LeadEmail'
		,	@SF_ID
		,	ERROR_PROCEDURE() + ':' + ERROR_MESSAGE()
        ,	GETDATE()
		)


UPDATE	SFDC_HCM_LeadEmail
SET		IsExcludedFlag = 1
,		ExclusionMessage = ERROR_PROCEDURE() + ':' + ERROR_MESSAGE()
WHERE	cst_sfdc_email_id = @SF_ID
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
