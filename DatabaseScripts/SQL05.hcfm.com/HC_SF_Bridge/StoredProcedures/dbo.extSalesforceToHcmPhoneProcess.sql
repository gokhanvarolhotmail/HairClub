/* CreateDate: 11/28/2017 16:52:09.113 , ModifyDate: 11/28/2017 17:56:48.143 */
GO
/***********************************************************************
PROCEDURE:				extSalesforceToHcmPhoneProcess
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

EXEC extSalesforceToHcmPhoneProcess 1
***********************************************************************/
CREATE PROCEDURE [dbo].[extSalesforceToHcmPhoneProcess]
(
	@BatchID INT
)
AS
BEGIN
BEGIN TRY

/********************************** Create temp table objects *************************************/
CREATE TABLE #LeadPhone (
	RowID INT IDENTITY(1, 1)
,	SF_ID NVARCHAR(18)
)


/********************************** Get New Lead Phone Records *************************************/
-- Create Audit Record
INSERT  INTO SFDC_HCM_AuditLog (
			BatchID
        ,	TableName
        ,	SalesforceID
		,	OnContactID
        ,	ActionTaken
		,	SortOrder
		)
        SELECT  lp.BatchID
        ,       'SFDC_HCM_LeadPhone'
        ,       lp.cst_sfdc_phone_id
		,		lp.contact_phone_id
        ,       'Extracted Record'
		,		1
        FROM    SFDC_HCM_LeadPhone lp
				LEFT OUTER JOIN SFDC_HCM_AuditLog al
					ON al.BatchID = lp.BatchID
						AND al.SalesforceID = lp.cst_sfdc_phone_id
        WHERE   lp.BatchID = @BatchID
				AND al.SalesforceID IS NULL


---- Exclude Client records.
--UPDATE	SFDC_HCM_LeadPhone
--SET		IsExcludedFlag = 1
--,		ExclusionMessage = 'Excluded from processing because this phone number belongs to a client record.'
--WHERE	BatchID = @BatchID
--		AND LEFT(cst_sfdc_lead_id, 3) <> '00Q'
--		AND ISNULL(IsProcessedFlag, 0) = 0


-- Exclude Phone records for excluded Leads.
UPDATE	lp
SET		IsExcludedFlag = 1
,		ExclusionMessage = l.ExclusionMessage
FROM	SFDC_HCM_LeadPhone lp
		INNER JOIN SFDC_HCM_Lead l
			ON l.cst_sfdc_lead_id = lp.cst_sfdc_lead_id
				AND l.BatchID = lp.BatchID
WHERE	lp.BatchID = @BatchID
		AND ISNULL(l.IsExcludedFlag, 0) = 1
		AND ISNULL(lp.IsProcessedFlag, 0) = 0


-- Exclude records with an inproper area code.
UPDATE	SFDC_HCM_LeadPhone
SET		IsExcludedFlag = 1
,		ExclusionMessage = 'Excluded from processing because the area code for this phone number is greater than 3 characters.'
WHERE	BatchID = @BatchID
		AND LEN(AreaCode) > 3
		AND ISNULL(IsProcessedFlag, 0) = 0


INSERT	INTO #LeadPhone
		SELECT  lp.cst_sfdc_phone_id AS 'SF_ID'
		FROM    SFDC_HCM_LeadPhone lp
		WHERE   lp.BatchID = @BatchID
				AND ISNULL(lp.IsProcessedFlag, 0) = 0
				AND ISNULL(lp.IsExcludedFlag, 0) = 0


DECLARE	@TotalCount INT
,		@LoopCount INT
,		@SF_ID NVARCHAR(18)


SET @TotalCount = (SELECT COUNT(*) FROM #LeadPhone lp)
SET @LoopCount = 1


WHILE @LoopCount <= @TotalCount
BEGIN
	SET @SF_ID = (SELECT lp.SF_ID FROM #LeadPhone lp WHERE lp.RowID = @LoopCount)


	PRINT @SF_ID


	-- Upsert Lead Phone Record
	EXEC extSalesforceToHcmPhoneUpsert
		@SF_ID = @SF_ID,
		@BatchID = @BatchID


	-- Mark the record as processed
	UPDATE	SFDC_HCM_LeadPhone
	SET		IsProcessedFlag = 1
	WHERE	BatchID = @BatchID
			AND cst_sfdc_phone_id = @SF_ID
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
		,	'SFDC_HCM_LeadPhone'
		,	@SF_ID
		,	ERROR_PROCEDURE() + ':' + ERROR_MESSAGE()
        ,	GETDATE()
		)


UPDATE	SFDC_HCM_LeadPhone
SET		IsExcludedFlag = 1
,		ExclusionMessage = ERROR_PROCEDURE() + ':' + ERROR_MESSAGE()
WHERE	cst_sfdc_phone_id = @SF_ID
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
