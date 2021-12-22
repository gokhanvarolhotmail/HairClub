/* CreateDate: 05/13/2009 05:29:44.633 , ModifyDate: 02/27/2017 09:49:34.860 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				selSurgeryClientMembershipAccumulatorsByDate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		5/1/09

LAST REVISION DATE: 	5/15/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns a client membership and it's surgery accumulators for a particular day
		(trying to encapsulate this logic so it can be populated into a temp table and joined to from
		other stored procs

		5/15/09 PRM - Issue #310, added the Recompile statement so the query performs well when changing
			what parameters are being passed in
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selClientMembershipAccumulatorsByDate '4/15/2009', 350, '878A2DDC-DC9C-4636-A907-171A25E5097D'
                  OR
selClientMembershipAccumulatorsByDate '4/15/2009', 350, NULL
                  OR
selClientMembershipAccumulatorsByDate '4/15/2009', NULL, '878A2DDC-DC9C-4636-A907-171A25E5097D'
                  OR
selClientMembershipAccumulatorsByDate '4/15/2009', NULL, NULL

***********************************************************************/
CREATE PROCEDURE [dbo].[selSurgeryClientMembershipAccumulatorsByDate]
	@AccumDate date
	,@CenterID int = NULL
	,@ClientMembershipGUID uniqueidentifier = NULL
AS
BEGIN


SET @AccumDate = DATEADD(D, 1, @AccumDate)


SELECT  TimeZoneID
,       [UTCOffset]
,       [UsesDayLightSavingsFlag]
,       [IsActiveFlag]
,       dbo.GetUTCFromLocal(@AccumDate, [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCAccumDate]
INTO    #UTCDateParms
FROM    dbo.lkpTimeZone
WHERE   [IsActiveFlag] = 1;


SELECT CenterID,
	ClientMembershipGUID,
	SUM(EstimatedGrafts) AS EstimatedGrafts,
	SUM(PlacedGrafts) AS PlacedGrafts,
	SUM(PricePerGraft) AS PricePerGraft,
	SUM((CASE WHEN ISNULL(PlacedGrafts,0) > 0 THEN PlacedGrafts ELSE EstimatedGrafts END) * PricePerGraft) AS EstimatedContractPrice,
	SUM(PlacedGrafts * PricePerGraft) AS PlacedContractPrice,
	SUM(CASE WHEN (PlacedGrafts > EstimatedGrafts) THEN PlacedGrafts - EstimatedGrafts ELSE 0 END) AS FreeGrafts,
	SUM(EstimatedOTMGrafts) AS EstimatedOTMGrafts,
	SUM(PlacedOTMGrafts) AS PlacedOTMGrafts,
	SUM(PricePerOTMGraft) AS PricePerOTMGraft,
	SUM(MembershipRevenue) AS MembershipRevenue
FROM (
	SELECT so.ClientHomeCenterID AS CenterID
		, cm.ClientMembershipGUID
		, SUM(CASE WHEN aa.AccumulatorID = 12 THEN aa.QuantityTotalChangeCalc ELSE 0 END) AS EstimatedGrafts
		, SUM(CASE WHEN aa.AccumulatorID = 12 THEN aa.QuantityUsedChangeCalc ELSE 0 END) AS PlacedGrafts
		, SUM(CASE WHEN aa.AccumulatorID = 30 THEN aa.MoneyChangeCalc ELSE 0 END) AS PricePerGraft
		, SUM(CASE WHEN aa.AccumulatorID = 27 THEN aa.QuantityTotalChangeCalc ELSE 0 END) AS EstimatedOTMGrafts
		, SUM(CASE WHEN aa.AccumulatorID = 27 THEN aa.QuantityUsedChangeCalc ELSE 0 END) AS PlacedOTMGrafts
		, SUM(CASE WHEN aa.AccumulatorID = 29 THEN aa.MoneyChangeCalc ELSE 0 END) AS PricePerOTMGraft
		, SUM(CASE WHEN aa.AccumulatorID = 20 THEN aa.MoneyChangeCalc ELSE 0 END) AS MembershipRevenue
	FROM datAccumulatorAdjustment aa
		  INNER JOIN datSalesOrderDetail sod ON aa.SalesOrderDetailGUID = sod.SalesOrderDetailGUID
		  INNER JOIN datSalesOrder so ON sod.SalesOrderGUID = so.SalesOrderGUID
		  INNER JOIN cfgCenter ctr ON so.ClientHomeCenterID = ctr.CenterID
		  INNER JOIN lkpTimeZone tz ON ctr.TimeZoneID = tz.TimeZoneID
		  INNER JOIN datClientMembership cm ON so.ClientMembershipGUID = cm.ClientMembershipGUID
		  INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
		  JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID

	WHERE	so.OrderDate < #UTCDateParms.UTCAccumDate
	--WHERE	dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) < @AccumDate
	--WHERE  DATEADD(Hour, CASE WHEN tz.[UsesDayLightSavingsFlag] = 0 THEN ( tz.[UTCOffset] )
	--					  WHEN DATEPART(WK, so.[OrderDate]) <= 10
	--								 OR DATEPART(WK, so.[OrderDate]) >= 45 THEN ( tz.[UTCOffset] )
	--					  ELSE ( ( tz.[UTCOffset] ) + 1 )
	--			 END, so.[OrderDate]) < @AccumDate

				 AND so.IsVoidedFlag = 0
		AND (@CenterID IS NULL OR so.ClientHomeCenterID = @CenterID)
		AND (@ClientMembershipGUID IS NULL OR so.ClientMembershipGUID = @ClientMembershipGUID)
	GROUP BY so.ClientHomeCenterID, cm.ClientMembershipGUID
	) subAccum
GROUP BY CenterID, ClientMembershipGUID
OPTION(RECOMPILE)

END
GO
