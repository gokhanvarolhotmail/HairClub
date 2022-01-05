/* CreateDate: 11/14/2016 07:44:38.870 , ModifyDate: 12/31/2021 00:01:20.910 */
GO
/***********************************************************************
PROCEDURE:                mtnIsClientARBalanceOlderThanNumberOfDays
DESTINATION SERVER:        SQL01
DESTINATION DATABASE:     HairClubCMS
RELATED APPLICATION:      CMS
AUTHOR:                 Sue Lemery
IMPLEMENTOR:             Sue Lemery
DATE IMPLEMENTED:         10/28/2016
LAST REVISION DATE:     10/28/2016
------------------------------------------------------------------------------------------------------------------------
NOTES:  Returns a boolean value indicating if the client's A/R Balance is older than the number of days being passed in
        * 10/28/2016    SAL - Created
        * 01/16/2017    MVT - Added check for IsVoidedFlag and IsClosedFlag (TFS #8416)
        * 22/12/2021    AOS - Added validation for ARBalanceChoice
------------------------------------------------------------------------------------------------------------------------
mtnIsClientARBalanceOlderThanNumberOfDays '8D549E9D-BB22-4D6C-A698-DB2EFD9AE4D9', 20
***********************************************************************/
CREATE PROCEDURE [dbo].[mtnIsClientARBalanceOlderThanNumberOfDays]
    @ClientGUID as uniqueidentifier,
    @NumberOfDays as int
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @IsClientARBalanceOlderThanNumberOfDays as bit
    DECLARE @PastDate as datetime
    DECLARE @ARBalance as MONEY
    DECLARE @ARBalanceChoice as MONEY
    DECLARE @ARBalanceRegular as MONEY
    DECLARE @SumOfSalesOrdersTenderedToARInPastNumbeOfDays as money
    SET @IsClientARBalanceOlderThanNumberOfDays = 0
    SET @ARBalance = (SELECT ARBalance from datClient WHERE ClientGUID = @ClientGUID)

   SET @ARBalanceChoice = (SELECT SUM(RemainingBalance) FROM datAccountReceivable
                             JOIN lkpAccountReceivableType ON lkpAccountReceivableType.AccountReceivableTypeID = datAccountReceivable.AccountReceivableTypeID
                             WHERE ClientGUID = @ClientGUID AND IsClosed = 0 AND AccountReceivableTypeDescriptionShort = 'ChoiceFina'
                             GROUP BY ClientGUID)

    IF (@ARBalance > 0)
    BEGIN
        SET @ARBalanceRegular = @ARBalance
        IF (@ARBalanceChoice IS NOT NULL)
           BEGIN
        SET @ARBalanceRegular = @ARBalance - @ARBalanceChoice
        END

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
        IF (@ARBalanceRegular > @SumOfSalesOrdersTenderedToARInPastNumbeOfDays)
        BEGIN
            SET @IsClientARBalanceOlderThanNumberOfDays = 1
        END
    END
    SELECT @IsClientARBalanceOlderThanNumberOfDays
END
GO
