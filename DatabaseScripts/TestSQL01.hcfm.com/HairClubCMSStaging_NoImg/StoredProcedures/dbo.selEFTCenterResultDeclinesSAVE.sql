/* CreateDate: 05/14/2012 17:41:17.740 , ModifyDate: 02/27/2017 09:49:31.647 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

		PROCEDURE:				selEFTCenterResultDeclines

		DESTINATION SERVER:		SQL01

		DESTINATION DATABASE: 	HairClubCMS

		RELATED APPLICATION:  	CMS

		AUTHOR: 				Mike Maass

		IMPLEMENTOR: 			Mike Maass

		DATE IMPLEMENTED: 		02/07/2012

		LAST REVISION DATE: 	02/07/2012

		--------------------------------------------------------------------------------------------------------
		NOTES: 	Returns a list of EFTCenterResult records which have been declined and need to be reprocessed.

				02/07/2012 - AS: Created Stored Proc

		--------------------------------------------------------------------------------------------------------

		SAMPLE EXECUTION:

		selEFTCenterResultDeclines 204

		***********************************************************************/
		CREATE PROCEDURE [dbo].[selEFTCenterResultDeclinesSAVE]
			@centerId as int
		AS
		BEGIN
			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;

			DECLARE @CenterFeeBatchStatus_CompletedID int
			SELECT @CenterFeeBatchStatus_CompletedID = CenterFeeBatchStatusID FROM lkpCenterFeeBatchStatus WHERE CenterFeeBatchStatusDescriptionShort = 'COMPLETED'

			DECLARE @CenterDeclineBatchStatusID_Processing int
			SELECT @CenterDeclineBatchStatusID_Processing = CenterDeclineBatchStatusID From lkpCenterDeclineBatchStatus WHERE CenterDeclineBatchStatusDescriptionShort = 'PROCESSING'

			DECLARE @PAYMENT_RECEIVED INT
			SELECT @PAYMENT_RECEIVED = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD'

			Select DISTINCT c.ClientFullNameCalc
					,c.CenterID
					,cEFT.AccountExpiration
					,trans.PayCycleTransactionGUID
					,trans.ChargeAmount as ChargeAmount
					,trans.FeeAmount as FeeAmount
					,trans.TaxAmount as TaxAmount
					,trans.IsReprocessFlag
					,m.MembershipDescription
					,payCycle.FeePayCycleDescription as FeePayCycle
					,fee.RunDate
			from datPayCycleTransaction trans
				INNER JOIN datCenterFeeBatch fee on trans.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
				INNER JOIN lkpFeePayCycle payCycle ON fee.FeePayCycleID = payCycle.FeePayCycleID
				INNER JOIN datClient c ON trans.ClientGUID = c.ClientGUID
				INNER JOIN datClientEFT ceft on c.ClientGUID = ceft.ClientGUID
				INNER JOIN datClientMembership cm on ISNULL(c.CurrentBioMatrixClientMembershipGUID, ISNULL(c.CurrentSurgeryClientMembershipGUID,c.CurrentExtremeTherapyClientMembershipGUID)) = cm.ClientMembershipGUID
				INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
				LEFT OUTER JOIN lkpEFTAccountType at ON ceft.EFTAccountTypeID = at.EFTAccountTypeID
				LEFT OUTER JOIN datCenterDeclineBatch decline on trans.CenterFeeBatchGUID = decline.CenterFeeBatchGUID
									AND decline.CenterDeclineBatchStatusID <> @CenterDeclineBatchStatusID_Processing
				LEFT OUTER JOIN datSalesOrder so on trans.ClientGUID = so.ClientGUID
							AND fee.CenterID = so.CenterID
							AND so.OrderDate BETWEEN CONVERT(DATETIME, CONVERT(VARCHAR(10), fee.RunDate, 101) + ' 00:00:00') AND GETUTCDATE()
				LEFT OUTER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
							AND sod.SalesCodeID = @PAYMENT_RECEIVED
			WHERE trans.IsSuccessfulFlag = 0
				AND fee.CenterId = @centerId
				AND fee.CenterFeeBatchStatusId = @CenterFeeBatchStatus_CompletedID
				AND trans.CenterDeclineBatchGUID IS NULL
				AND decline.CenterDeclineBatchGUID IS NULL
				AND sod.SalesOrderDetailGUID IS NULL
				AND (at.EFTAccountTypeDescriptionShort = 'CreditCard'
							AND DATEADD(DAY, payCycle.FeePayCycleValue - 1, GETDATE()) <= ceft.AccountExpiration)
				AND GETUTCDATE() BETWEEN
					[dbo].[fn_BuildDateByParts] (DatePart(month, fee.RunDate), DatePart(day, fee.RunDate), DatePart(year, fee.RunDate))
					AND
					DATEADD(DAY, -1, DATEADD(MONTH, 1, [dbo].[fn_BuildDateByParts] (fee.FeeMonth, payCycle.FeePayCycleValue , fee.FeeYear) )) + ' 23:59:59'
			ORDER BY c.ClientFullNameCalc


		END
GO
