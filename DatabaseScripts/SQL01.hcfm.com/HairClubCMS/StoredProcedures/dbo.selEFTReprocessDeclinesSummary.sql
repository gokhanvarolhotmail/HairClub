/***********************************************************************
PROCEDURE:				[selEFTReprocessDeclinesSummary]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Maass
IMPLEMENTOR: 			Mike Maass
DATE IMPLEMENTED: 		06/18/2012
LAST REVISION DATE: 	06/18/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Return summary for processing screen, user to select Centers to process
		06/18/2012 - MMaass Created Stored Proc
		06/25/2012 - MMaass Fixed Issue with Record Selection and CC Expiration Date and Pay Cycle = 15th
		10/15/2012 - MMaass Added PCP Write Sales Code
		02/06/2014 - MMaass Added EmployeeGUID parameter
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selEFTReprocessDeclinesSummary] NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[selEFTReprocessDeclinesSummary]
	@EmployeeGUID char(36) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		-- Build MyCenter table based on EmployeeGUID
	DECLARE @MyCenter TABLE ( CenterID int not null )
	IF ISNULL(RTRIM(LTRIM(@EmployeeGUID)),'') = ''
		BEGIN
			INSERT INTO @MyCenter(CenterID)
				SELECT DISTINCT CenterID
				FROM cfgCenter c
					inner join lkpCenterType ct on c.CenterTypeID = ct.CenterTypeID
				WHERE ct.CenterTypeDescriptionShort = 'C' AND c.IsCorporateHeadquartersFlag = 0
		END
	ELSE
		BEGIN
			INSERT INTO @MyCenter(CenterID) SELECT DISTINCT CenterID From datEmployeeCenter where EmployeeGuID = @EmployeeGUID
		END

		DECLARE @CenterDeclineBatchStatusID_Reconciled int
	SELECT @CenterDeclineBatchStatusID_Reconciled = CenterDeclineBatchStatusID FROM lkpCenterDeclineBatchStatus WHERE CenterDeclineBatchStatusDescriptionShort = 'RECON'

	DECLARE @PAYMENT_RECEIVED INT
	SELECT @PAYMENT_RECEIVED = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PMTRCVD'

	DECLARE @PCP_WRITEOFF INT
	SELECT @PCP_WRITEOFF = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'PCPREVWO'


		;WITH decline_CTE as
		(
			Select DISTINCT decline.CenterDeclineBatchGUID
					,decline.RunDate
					,fee.CenterID
					,center.CenterDescriptionFullCalc
					,trans.ChargeAmount
					,dstatus.CenterDeclineBatchStatusDescription
					,trans.ClientGUID
			from datPayCycleTransaction trans
				INNER JOIN datCenterFeeBatch fee on trans.CenterFeeBatchGUID = fee.CenterFeeBatchGUID
				INNER JOIN datCenterDeclineBatch decline on fee.CenterFeeBatchGUID = decline.CenterFeeBatchGUID
				INNER JOIN lkpCenterDeclineBatchStatus dStatus on decline.CenterDeclineBatchStatusID = dstatus.CenterDeclineBatchStatusID
				INNER JOIN lkpFeePayCycle payCycle ON fee.FeePayCycleID = payCycle.FeePayCycleID
				INNER JOIN datClient c ON trans.ClientGUID = c.ClientGUID
				INNER JOIN datClientEFT ceft on c.ClientGUID = ceft.ClientGUID
				INNER JOIN cfgCenter center on fee.CenterID = center.CenterID
				INNER JOIN @MyCenter mc on center.CenterID = mc.CenterID
				LEFT OUTER JOIN lkpEFTAccountType at ON ceft.EFTAccountTypeID = at.EFTAccountTypeID
			WHERE trans.IsReprocessFlag = 1
				AND dstatus.CenterDeclineBatchStatusID = @CenterDeclineBatchStatusID_Reconciled
				AND trans.IsSuccessfulFlag = 0
				AND trans.CenterDeclineBatchGUID IS NULL
				AND payCycle.FeePayCycleDescriptionShort <> 'MANUAL'
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
									AND ( sod.SalesCodeID = @PAYMENT_RECEIVED OR sod.SalesCodeID = @PCP_WRITEOFF)
						WHERE c.ClientGUID = so.ClientGUID
									AND so.OrderDate BETWEEN CONVERT(DATETIME, CONVERT(VARCHAR(10), fee.RunDate, 101) + ' 00:00:00') AND GETUTCDATE()))
		)
		SELECT CenterDeclineBatchGUID
			,CenterID
			,CenterDescriptionFullCalc
			,CenterDeclineBatchStatusDescription
			,RunDate
			,SUM(ChargeAmount) as ChargeAmount
			,COUNT(*) as ChargeCount
		FROM decline_CTE
		GROUP BY CenterDeclineBatchGUID, CenterID, CenterDescriptionFullCalc, CenterDeclineBatchStatusDescription, RunDate


END
