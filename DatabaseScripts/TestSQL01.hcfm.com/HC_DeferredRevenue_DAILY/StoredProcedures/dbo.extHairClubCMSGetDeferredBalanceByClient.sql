/* CreateDate: 04/22/2020 14:30:09.320 , ModifyDate: 04/22/2020 14:30:09.320 */
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSGetDeferredBalanceByClient
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_DeferredRevenue_DAILY
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/17/2020
DESCRIPTION:			Gets the Deferred Balance based on the specified Client Identifier
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

DECLARE @CurrentDeferredBalance MONEY


EXEC extHairClubCMSGetDeferredBalanceByClient @ClientIdentifier = 25036, @DeferredBalance = @CurrentDeferredBalance OUTPUT


SELECT @CurrentDeferredBalance AS 'CurrentDeferredBalance'
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSGetDeferredBalanceByClient]
(
	@ClientIdentifier INT
,	@DeferredBalance MONEY OUTPUT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CurrentDate DATETIME
,		@CurrentPeriod DATETIME
,		@LastProcessedPeriod DATETIME


SET @CurrentDate = GETDATE()
SET @CurrentPeriod = DATETIMEFROMPARTS(YEAR(@CurrentDate), MONTH(@CurrentDate), 1, 0, 0, 0, 0)
SET @LastProcessedPeriod = (SELECT MAX(drd.Period) FROM vwDeferredRevenueDetails drd WHERE drd.DeferredRevenueTypeID = 4)


--Check to see if the current perid is the same as the last processed period.  If yes, use the current period, otherwise use the last processed period
SELECT @CurrentPeriod = CASE WHEN @LastProcessedPeriod = @CurrentPeriod THEN @CurrentPeriod ELSE @LastProcessedPeriod END


SELECT	@DeferredBalance = ISNULL(SUM(drd.Deferred), 0)
FROM	vwDeferredRevenueDetails drd
WHERE	drd.DeferredRevenueTypeID = 4 --PCP Deferred
		AND drd.Period = @CurrentPeriod
		AND drd.ClientIdentifier = @ClientIdentifier

END
GO
