/***********************************************************************

PROCEDURE:				mtnIsClientARBalanceOlderThanNumberOfDays

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		10/28/2016

LAST REVISION DATE: 	10/28/2016

------------------------------------------------------------------------------------------------------------------------
NOTES:  Returns a boolean value indicating if the client's A/R Balance is older than the number of days being passed in

		* 10/28/2016	SAL - Created
		* 01/16/2017	MVT - Added check for IsVoidedFlag and IsClosedFlag (TFS #8416)
------------------------------------------------------------------------------------------------------------------------

mtnIsClientARBalanceOlderThanNumberOfDays '4F4A5D2E-A053-4C16-B48C-F560F4AE25B9', 20

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnIsClientARBalanceOlderThanNumberOfDays]
	@ClientGUID as uniqueidentifier,
	@NumberOfDays as int
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @IsClientARBalanceOlderThanNumberOfDays as bit
	DECLARE @PastDate as datetime
	DECLARE @ARBalance as money
	DECLARE @SumOfSalesOrdersTenderedToARInPastNumbeOfDays as money

	SET @IsClientARBalanceOlderThanNumberOfDays = 0
	SET @ARBalance = (SELECT ARBalance from datClient WHERE ClientGUID = @ClientGUID)

	IF (@ARBalance > 0)
	BEGIN
		--Make sure number of days is a negative number
		IF EXISTS(SELECT * WHERE @NumberOfDays > 0)
		BEGIN
			SELECT @NumberOfDays = @NumberOfDays * -1
		END

		--Get past date for number of days
		SET @PastDate = DATEADD(DAY, @NumberOfDays, GETUTCDATE())

		--Get the sum of sales orders tendered to AR within the past number of days
		SET @SumOfSalesOrdersTenderedToARInPastNumbeOfDays = (SELECT COALESCE(SUM(sot.Amount), 0)
																FROM datSalesOrder so
																	inner join datSalesOrderTender sot on so.SalesOrderGUID = sot.SalesOrderGUID
																	inner join lkpTenderType tt on sot.TenderTypeID = tt.TenderTypeID
																WHERE so.ClientGUID = @ClientGUID
																	and so.OrderDate > @PastDate
																	and tt.TenderTypeDescriptionShort = 'AR'
																	and so.IsClosedFlag = 1
																	and so.IsVoidedFlag = 0)

		--If the client's A/R Balance is greater than the total amount of sales orders tendered to AR within the past X number of days then it is older than the X number of days
		IF (@ARBalance > @SumOfSalesOrdersTenderedToARInPastNumbeOfDays)
		BEGIN
			SET @IsClientARBalanceOlderThanNumberOfDays = 1
		END
	END

	SELECT @IsClientARBalanceOlderThanNumberOfDays
END
