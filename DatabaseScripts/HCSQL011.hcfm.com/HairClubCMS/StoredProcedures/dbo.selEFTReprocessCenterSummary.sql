/* CreateDate: 06/25/2012 09:49:34.260 , ModifyDate: 02/27/2017 09:49:32.287 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[selEFTReprocessCenterSummary]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Maass, Skyline Technologies
IMPLEMENTOR: 			Mike Maass, Skyline Technologies
DATE IMPLEMENTED: 		06/21/2012
LAST REVISION DATE: 	06/21/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Return summary for processing screen, user to select Centers to process
		06/21/2012 - MMaass Created Stored Proc
		06/25/2012 - MMaass Fixed Issue with Record Selection and CC Expiration Date and Pay Cycle = 15th
		01/06/2015 - KPL: Added NACHAFileProfileID
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selEFTReprocessCenterSummary]
***********************************************************************/
CREATE PROCEDURE [dbo].[selEFTReprocessCenterSummary]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CenterFeeBatchStatusID_Reconciled int
	SELECT @CenterFeeBatchStatusID_Reconciled = CenterFeeBatchStatusID FROM lkpCenterFeeBatchStatus WHERE CenterFeeBatchStatusDescriptionShort = 'RECON'

	DECLARE @PAYMENT_RECEIVED INT
	SELECT @PAYMENT_RECEIVED = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD'

		;WITH CenterFee_CTE as
		(
			Select DISTINCT cc.NACHAFileProfileID
					,fee.CenterFeeBatchGUID
					,fee.RunDate
					,fee.CenterID
					,center.CenterDescriptionFullCalc
					,trans.ChargeAmount
					,fstatus.CenterFeeBatchStatusDescription
					,trans.ClientGUID
			from datPayCycleTransaction trans
				INNER JOIN datCenterFeeBatch fee on trans.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
				INNER JOIN lkpCenterFeeBatchStatus fStatus on fee.CenterFeeBatchStatusId = fStatus.CenterFeeBatchStatusID
				INNER JOIN lkpFeePayCycle payCycle ON fee.FeePayCycleID = payCycle.FeePayCycleID
				INNER JOIN datClient c ON trans.ClientGUID = c.ClientGUID
				INNER JOIN datClientEFT ceft on c.ClientGUID = ceft.ClientGUID
				INNER JOIN cfgCenter center on fee.CenterID = center.CenterID
				INNER JOIN cfgConfigurationCenter cc on fee.CenterId = cc.CenterID
				LEFT OUTER JOIN lkpEFTAccountType at ON ceft.EFTAccountTypeID = at.EFTAccountTypeID
			WHERE trans.IsReprocessFlag = 1
				AND fStatus.CenterFeeBatchStatusID  = @CenterFeeBatchStatusID_Reconciled
				AND trans.IsSuccessfulFlag = 0
				AND trans.CenterDeclineBatchGUID IS NULL
				AND (at.EFTAccountTypeDescriptionShort = 'CreditCard'
								AND CONVERT(DATE,CONVERT(NVARCHAR,GETDATE(),101)) <= ceft.AccountExpiration)
				AND GETUTCDATE() BETWEEN
						[dbo].[fn_BuildDateByParts] (DatePart(month, fee.RunDate), DatePart(day, fee.RunDate), DatePart(year, fee.RunDate))
						AND
						DATEADD(DAY, -1, DATEADD(MONTH, 1, [dbo].[fn_BuildDateByParts] (fee.FeeMonth, payCycle.FeePayCycleValue , fee.FeeYear) )) + ' 23:59:59'
				AND c.ClientGUID NOT IN (
					(SELECT so.ClientGUID
						FROM datSalesOrder so
							INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
									AND sod.SalesCodeID = @PAYMENT_RECEIVED
						WHERE c.ClientGUID = so.ClientGUID
									AND so.OrderDate BETWEEN CONVERT(DATETIME, CONVERT(VARCHAR(10), fee.RunDate, 101) + ' 00:00:00') AND GETUTCDATE()))
		)
		SELECT NACHAFileProfileID
			,CenterFeeBatchGUID
			,CenterID
			,CenterDescriptionFullCalc
			,CenterFeeBatchStatusDescription
			,RunDate
			,SUM(ChargeAmount) as ChargeAmount
			,COUNT(*) as ChargeCount
		FROM CenterFee_CTE
		GROUP BY NACHAFileProfileID,CenterFeeBatchGUID, CenterID, CenterDescriptionFullCalc, CenterFeeBatchStatusDescription, RunDate


END
GO
