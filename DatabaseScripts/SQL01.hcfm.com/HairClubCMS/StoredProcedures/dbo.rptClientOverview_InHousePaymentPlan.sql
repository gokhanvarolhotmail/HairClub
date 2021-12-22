/*===============================================================================================
 Procedure Name:				rptClientOverview_InHousePaymentPlan
 Procedure Description:			This is a section in the Client Overview and Membership Summary reports -
									for those clients with an InHouse Payment Plan
 Created By:					Rachelen Hut
 Date Created:					09/14/2016
 Destination Server.Database:   SQL01.HairclubCMS
 Related Application:			Membership Summary and Client Overview
================================================================================================
 NOTES:
================================================================================================
 CHANGE HISTORY:
================================================================================================
 SAMPLE EXECUTION:

 EXEC [rptClientOverview_InHousePaymentPlan]'6BFBE9DA-9B3D-4B17-BFB8-7ED815FE9FB1'

===============================================================================================*/

CREATE PROCEDURE [dbo].[rptClientOverview_InHousePaymentPlan]
	@ClientGUID NVARCHAR(50)
AS
BEGIN


/******************* Find the dates for the next pay cycle ****************************************************************************/
DECLARE @FirstDayOfMonth DATETIME
DECLARE @FirstDayOfNextMonth DATETIME

DECLARE @FifteenthOfMonth DATETIME
DECLARE @FifteenthOfNextMonth DATETIME

SELECT @FirstDayOfMonth = CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)
SELECT @FirstDayOfNextMonth = DATEADD(MM,1,@FirstDayOfMonth)

PRINT @FirstDayOfMonth
PRINT @FirstDayOfNextMonth

SELECT @FifteenthOfMonth = CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/15/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)
SELECT @FifteenthOfNextMonth = DATEADD(MM,1,@FifteenthOfMonth)

PRINT @FifteenthOfMonth
PRINT @FifteenthOfNextMonth

/******************* The main select statement *****************************************************************************************/

IF(SELECT TOP 1 ClientMembershipGUID FROM dbo.datClientMembership WHERE HasInHousePaymentPlan = 1 AND ClientGUID = @ClientGUID) IS NOT NULL
BEGIN

SELECT PayP.PaymentPlanID
	,	PayP.ClientGUID
	,	PayP.ClientMembershipGUID
	,	PayP.PaymentPlanStatusID
	,	CLT.FirstName
	,	CLT.LastName
	,	CLT.ClientIdentifier
	,	PayP.StartDate
	,	PayP.RemainingBalance
	,	PayP.DownpaymentAmount
	,	PayP.ContractAmount
	,	PayP.RemainingNumberOfPayments
	,	EFT.ClientEFTGUID
	,	EFT.FeePayCycleID
	,	CASE WHEN EFT.FeePayCycleID = 1 THEN '1st of Month'
			ELSE  '15th of Month' END AS 'NextPayment'
	,	CASE WHEN EFT.FeePayCycleID = 1 THEN @FirstDayOfNextMonth
			WHEN (EFT.FeePayCycleID = 2 AND GETUTCDATE() < @FifteenthOfMonth) THEN @FifteenthOfMonth
			ELSE  @FifteenthOfNextMonth END AS 'NextPaymentDate'
FROM datPaymentPlan PayP
	INNER JOIN dbo.datClientEFT EFT
		ON PayP.ClientMembershipGUID = EFT.ClientMembershipGUID
	INNER JOIN datClient CLT
		ON EFT.ClientGUID = CLT.ClientGUID
WHERE EFT.ClientGUID = @ClientGUID
	AND PaymentPlanStatusID = 1 --Active

END


END
