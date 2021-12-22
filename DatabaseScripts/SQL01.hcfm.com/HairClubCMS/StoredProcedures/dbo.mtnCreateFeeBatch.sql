/***********************************************************************
PROCEDURE:				mtnCreateFeeBatch
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				HDu
IMPLEMENTOR: 			HDu
DATE IMPLEMENTED: 		02/16/2012
LAST REVISION DATE: 	02/16/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Creates Batches if they do not exist.
		Returns Created Batches and/or existing Batches
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC mtnCreateFeeBatch 2012,3,2, 203
EXEC mtnCreateFeeBatch 2012,3,2, 204
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnCreateFeeBatch]
@FeeYear INT
,@FeeMonth INT
,@FeePayCycleID INT
,@FeeCenterID INT

AS
BEGIN

	DECLARE @Results AS TABLE(FeeBatchGUID UNIQUEIDENTIFIER)

	-- If batch is currently processing return empty guid (don't process again)
	IF(0 <> (SELECT COUNT(*) AS C FROM datCenterFeeBatch b
				INNER JOIN lkpCenterFeeBatchStatus s on b.CenterFeeBatchStatusID = s.CenterFeeBatchStatusID
			WHERE b.FeeMonth = ISNULL(@FeeMonth,DATEPART(MONTH, GETDATE()))
			AND b.FeeYear = ISNULL(@FeeYear,DATEPART(YEAR, GETDATE()))
			AND (@FeeCenterID IS NULL OR b.CenterID = @FeeCenterID)
			AND (@FeePayCycleID IS NULL OR b.FeePayCycleID = @FeePayCycleID)
			AND s.CenterFeeBatchStatusDescriptionShort = 'APPROVED'
			)
		)
		INSERT INTO @Results (
				FeeBatchGUID)
			VALUES
				('00000000-0000-0000-0000-000000000000')

	--Only creates records if they don't exist
	ELSE IF(0 = (SELECT COUNT(*) AS C FROM datCenterFeeBatch b
				INNER JOIN lkpCenterFeeBatchStatus s on b.CenterFeeBatchStatusID = s.CenterFeeBatchStatusID
			WHERE b.FeeMonth = ISNULL(@FeeMonth,DATEPART(MONTH, GETDATE()))
			AND b.FeeYear = ISNULL(@FeeYear,DATEPART(YEAR, GETDATE()))
			AND (@FeeCenterID IS NULL OR CenterID = @FeeCenterID)
			AND (@FeePayCycleID IS NULL OR FeePayCycleID = @FeePayCycleID)
			AND s.CenterFeeBatchStatusDescriptionShort <> 'APPROVED'
			)
		)
	BEGIN

	BEGIN TRAN BATCHCREATION
/*
DROP TABLE #CENTERBATCH
DELETE FROM datCenterDeclineBatch
DELETE FROM datCenterFeeBatch
*/
		--CONSTANTS
		DECLARE @CONST_SalesOrderTypeID INT = (SELECT TOP 1 SalesOrderTypeID FROM dbo.lkpSalesOrderType WHERE SalesOrderTypeDescriptionShort = 'FO')
		DECLARE @CONST_CenterFeeBatchStatusId INT = (SELECT TOP 1 CenterFeeBatchStatusID FROM dbo.lkpCenterFeeBatchStatus WHERE CenterFeeBatchStatusDescriptionShort = 'APPROVED')
		DECLARE @CONST_TaxTypeID INT = (SELECT TOP 1 TaxTypeID  FROM lkpTaxType WHERE TaxTypeDescriptionShort = 'PCP')
		DECLARE @CONST_SalesCodeID INT = (SELECT TOP 1 SalesCodeID FROM dbo.cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD')
		DECLARE @CONST_TenderTypeID INT = (SELECT TOP 1 TenderTypeID FROM dbo.lkpTenderType WHERE TenderTypeDescriptionShort = 'AR')
		DECLARE @CREATECOUNT INT
--/*
		--Create Batches
		SELECT NEWID() AS CenterFeeBatchGUID
		,CenterID
		,FeePayCycleID AS FeePayCycleID
		,ISNULL(@FeeMonth, DATEPART(MONTH, GETDATE())) AS FeeMonth
		,ISNULL(@FeeYear, DATEPART(YEAR, GETDATE())) AS FeeYear
		,@CONST_CenterFeeBatchStatusId AS CenterFeeBatchStatusId
		,NULL AS ApprovedByEmployeeGUID
		,NULL AS RunDate
		,NULL AS RunByEmployeeGUID
		,GETDATE() AS CreateDate
		,'SA' AS CreateUser
		,GETDATE() AS LastUpdate
		,'SA' AS LastUpdateUser
		INTO #CENTERBATCH
		FROM dbo.lkpFeePayCycle, dbo.cfgCenter
		WHERE (@FeeCenterID IS NULL OR CenterID = @FeeCenterID)
		AND (@FeePayCycleID IS NULL OR FeePayCycleID = @FeePayCycleID)
		AND FeePayCycleValue != 0
		ORDER BY CenterID, FeePayCycleID

		-- INSERT
		INSERT INTO datCenterFeeBatch
              (CenterFeeBatchGUID,CenterID,FeePayCycleID,FeeMonth,FeeYear,CenterFeeBatchStatusId,CreateDate,CreateUser,LastUpdate,LastUpdateUser)
		SELECT CenterFeeBatchGUID,CenterID,FeePayCycleID,FeeMonth,FeeYear,CenterFeeBatchStatusId,CreateDate,CreateUser,LastUpdate,LastUpdateUser
		FROM #CENTERBATCH

		SELECT @CREATECOUNT = COUNT(*) FROM #CENTERBATCH
		PRINT 'CREATED ' + CAST(@CREATECOUNT AS NVARCHAR)
--*/

	COMMIT TRAN BATCHCREATION


	INSERT INTO @Results
		SELECT CenterFeeBatchGUID
		FROM datCenterFeeBatch b
			INNER JOIN lkpCenterFeeBatchStatus s ON b.CenterFeeBatchStatusId = s.CenterFeeBatchStatusId
		WHERE (@FeeYear IS NULL OR b.FeeYear = @FeeYear)
		AND (@FeeMonth IS NULL OR b.FeeMonth = @FeeMonth)
		AND (@FeeCenterID IS NULL OR b.CenterID = @FeeCenterID)
		AND (@FeePayCycleID IS NULL OR b.FeePayCycleID = @FeePayCycleID)
		AND s.CenterFeeBatchStatusDescriptionShort <> 'MANUAL'
	END

	SELECT DISTINCT FeeBatchGUID FROM @Results
END
