/* CreateDate: 12/11/2012 14:57:23.773 , ModifyDate: 12/11/2012 14:57:23.773 */
GO
CREATE VIEW [dbo].[vwCfgAccumulatorJoin]
AS
SELECT     TOP (100) PERCENT aj.AccumulatorJoinID, aj.AccumulatorJoinSortOrder, ajt.AccumulatorJoinTypeDescription, sc.SalesCodeDescription,
                      a.AccumulatorDescription, aj.IsActiveFlag, aj.CreateDate, aj.CreateUser, aj.LastUpdate, aj.LastUpdateUser, aj.UpdateStamp
FROM         dbo.cfgAccumulatorJoin AS aj LEFT OUTER JOIN
                      dbo.lkpAccumulatorJoinType AS ajt ON aj.AccumulatorJoinTypeID = ajt.AccumulatorJoinTypeID LEFT OUTER JOIN
                      dbo.cfgSalesCode AS sc ON aj.SalesCodeID = sc.SalesCodeID LEFT OUTER JOIN
                      dbo.cfgAccumulator AS a ON a.AccumulatorID = aj.AccumulatorID
ORDER BY aj.AccumulatorJoinSortOrder
GO
