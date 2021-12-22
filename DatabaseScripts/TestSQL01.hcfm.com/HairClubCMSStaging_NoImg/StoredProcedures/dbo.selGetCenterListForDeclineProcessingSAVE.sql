/* CreateDate: 05/14/2012 17:41:18.000 , ModifyDate: 02/27/2017 09:49:33.920 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

		--------------------------------------------------------------------------------------------------------

		SAMPLE EXECUTION:

		selGetCenterListForDeclineProcessing

		***********************************************************************/
		CREATE PROCEDURE [dbo].[selGetCenterListForDeclineProcessingSAVE]

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
				LEFT OUTER JOIN datCenterDeclineBatch decline on trans.CenterFeeBatchGUID = decline.CenterFeeBatchGUID
									AND decline.CenterDeclineBatchStatusID <> @CenterDeclineBatchStatusID_Processing
				LEFT OUTER JOIN datSalesOrder so on trans.ClientGUID = so.ClientGUID
							AND fee.CenterID = so.CenterID
							AND so.OrderDate BETWEEN CONVERT(DATETIME, CONVERT(VARCHAR(10), fee.RunDate, 101) + ' 00:00:00') AND GETUTCDATE()
				LEFT OUTER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
							AND sod.SalesCodeID = @PAYMENT_RECEIVED
			WHERE trans.IsReprocessFlag = 1
				AND fee.CenterFeeBatchStatusId = @CenterFeeBatchStatus_CompletedID
				AND decline.CenterDeclineBatchGUID IS NULL
				AND sod.SalesOrderDetailGUID IS NULL
				AND GETUTCDATE() BETWEEN
					[dbo].[fn_BuildDateByParts] (DatePart(month, fee.RunDate), DatePart(day, fee.RunDate), DatePart(year, fee.RunDate))
					AND
					DATEADD(DAY, -1, DATEADD(MONTH, 1, [dbo].[fn_BuildDateByParts] (fee.FeeMonth, payCycle.FeePayCycleValue , fee.FeeYear) )) + ' 23:59:59'


		END
GO
