/* CreateDate: 11/28/2017 16:46:36.603 , ModifyDate: 11/28/2017 17:54:04.557 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmAddressProcess
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

EXEC extSalesforceToHcmAddressProcess
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmAddressProcess]
(
	@BatchID INT
)
AS
BEGIN
BEGIN TRY

/********************************** Create temp table objects *************************************/
CREATE TABLE #LeadAddress (
	RowID INT IDENTITY(1, 1)
,	SF_ID NVARCHAR(18)
)


/********************************** Get New Lead Address Records *************************************/
-- Create Audit Record
INSERT  INTO SFDC_HCM_AuditLog (
			BatchID
        ,	TableName
        ,	SalesforceID
		,	OnContactID
        ,	ActionTaken
		,	SortOrder
		)
        SELECT  la.BatchID
        ,       'SFDC_HCM_LeadAddress'
        ,       la.cst_sfdc_address_id
		,		la.contact_address_id
        ,       'Extracted Record'
		,		1
        FROM    SFDC_HCM_LeadAddress la
				LEFT OUTER JOIN SFDC_HCM_AuditLog al
					ON al.BatchID = la.BatchID
						AND al.SalesforceID = la.cst_sfdc_address_id
        WHERE   la.BatchID = @BatchID
				AND al.SalesforceID IS NULL


---- Exclude Client records.
--UPDATE	SFDC_HCM_LeadAddress
--SET		IsExcludedFlag = 1
--,		ExclusionMessage = 'Excluded from processing because this address belongs to a client record.'
--WHERE	BatchID = @BatchID
--		AND LEFT(cst_sfdc_lead_id, 3) <> '00Q'
--		AND ISNULL(IsProcessedFlag, 0) = 0


-- Exclude Address records for excluded Leads.
UPDATE	la
SET		IsExcludedFlag = 1
,		ExclusionMessage = l.ExclusionMessage
FROM	SFDC_HCM_LeadAddress la
		INNER JOIN SFDC_HCM_Lead l
			ON l.cst_sfdc_lead_id = la.cst_sfdc_lead_id
				AND l.BatchID = la.BatchID
WHERE	la.BatchID = @BatchID
		AND ISNULL(l.IsExcludedFlag, 0) = 1
		AND ISNULL(la.IsProcessedFlag, 0) = 0


INSERT	INTO #LeadAddress
		SELECT  la.cst_sfdc_address_id
		FROM    SFDC_HCM_LeadAddress la
		WHERE   la.BatchID = @BatchID
				AND ISNULL(la.IsProcessedFlag, 0) = 0
				AND ISNULL(la.IsExcludedFlag, 0) = 0


DECLARE	@TotalCount INT
,		@LoopCount INT
,		@SF_ID NVARCHAR(18)


SET @TotalCount = (SELECT COUNT(*) FROM #LeadAddress la)
SET @LoopCount = 1


WHILE @LoopCount <= @TotalCount
BEGIN
	SET @SF_ID = (SELECT la.SF_ID FROM #LeadAddress la WHERE la.RowID = @LoopCount)


	PRINT @SF_ID


	-- Upsert Lead Address Record
	EXEC extSalesforceToHcmAddressUpsert
		@SF_ID = @SF_ID,
		@BatchID = @BatchID


	-- Mark the record as processed
	UPDATE	SFDC_HCM_LeadAddress
	SET		IsProcessedFlag = 1
	WHERE	BatchID = @BatchID
			AND cst_sfdc_address_id = @SF_ID
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
		,	'SFDC_HCM_LeadAddress'
		,	@SF_ID
		,	ERROR_PROCEDURE() + ':' + ERROR_MESSAGE()
        ,	GETDATE()
		)


UPDATE	SFDC_HCM_LeadAddress
SET		IsExcludedFlag = 1
,		ExclusionMessage = ERROR_PROCEDURE() + ':' + ERROR_MESSAGE()
WHERE	cst_sfdc_address_id = @SF_ID
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
