/***********************************************************************

PROCEDURE:				selGetCenterListForDeclineProcessing

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		03/15/2012

LAST REVISION DATE: 	03/15/2012

--------------------------------------------------------------------------------------------------------
NOTES: 	Fetches a list of Centers for Decline Processing.

		03/15/12 - AS: Created Stored Proc
		06/04/12 - MMaass Fixed Logic to Exclude People who have made payments.
		07/24/12 - MMaass Added Code to only return Centers where the client EFT Profile has been updated in the last day.
		03/07/13 - MMaass Added check or GO-Live Centers.
		02/14/20 - Modified to include HW center
		04/09/20 - Modified to exclude HW center (TFS #14248)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selGetCenterListForDeclineProcessing

***********************************************************************/
CREATE PROCEDURE [dbo].[selGetCenterListForDeclineProcessing]

AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CenterDeclineBatchStatusID_Processing int
	SELECT @CenterDeclineBatchStatusID_Processing = CenterDeclineBatchStatusID From lkpCenterDeclineBatchStatus WHERE CenterDeclineBatchStatusDescriptionShort = 'PROCESSING'

	DECLARE @CenterFeeBatchStatus_CompletedID int
	SELECT @CenterFeeBatchStatus_CompletedID = CenterFeeBatchStatusID FROM lkpCenterFeeBatchStatus WHERE CenterFeeBatchStatusDescriptionShort = 'COMPLETED'

	DECLARE @PAYMENT_RECEIVED INT
	SELECT @PAYMENT_RECEIVED = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD'

	Select DISTINCT fee.CenterID
	from datPayCycleTransaction trans
		INNER JOIN datCenterFeeBatch fee on trans.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
		INNER JOIN lkpFeePayCycle payCycle ON fee.FeePayCycleID = payCycle.FeePayCycleID
		-- Add a check for last client eft profile update
		INNER JOIN cfgConfigurationCenter cc on fee.CenterID = cc.CenterID
		INNER JOIN lkpCenterBusinessType cbt on cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
		LEFT OUTER JOIN datCenterDeclineBatch decline on trans.CenterFeeBatchGUID = decline.CenterFeeBatchGUID
							AND decline.CenterDeclineBatchStatusID = @CenterDeclineBatchStatusID_Processing
	WHERE trans.IsReprocessFlag = 1
		AND fee.CenterFeeBatchStatusId = @CenterFeeBatchStatus_CompletedID
		--AND (cbt.CenterBusinessTypeDescriptionShort = 'cONEctCorp' OR cbt.CenterBusinessTypeDescriptionShort = 'HW')
		AND cbt.CenterBusinessTypeDescriptionShort = 'cONEctCorp'
		AND (cc.LastClientEFTUpdate > DATEADD(hour,-24,GETDATE()) OR cc.HasFullAccess = 1)  --Client EFT Profile Update Check.
		AND decline.CenterDeclineBatchGUID IS NULL
		AND GETUTCDATE() BETWEEN
			[dbo].[fn_BuildDateByParts] (DatePart(month, fee.RunDate), DatePart(day, fee.RunDate), DatePart(year, fee.RunDate))
			AND
			DATEADD(DAY, -1, DATEADD(MONTH, 1, [dbo].[fn_BuildDateByParts] (fee.FeeMonth, payCycle.FeePayCycleValue , fee.FeeYear) )) + ' 23:59:59'
		AND trans.ClientGUID NOT IN (
			(SELECT so.ClientGUID
				FROM datSalesOrder so
					INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
							AND sod.SalesCodeID = @PAYMENT_RECEIVED
				WHERE trans.ClientGUID = so.ClientGUID
							AND so.OrderDate BETWEEN CONVERT(DATETIME, CONVERT(VARCHAR(10), fee.RunDate, 101) + ' 00:00:00') AND GETUTCDATE()))
END
