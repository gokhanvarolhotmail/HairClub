/* CreateDate: 04/14/2009 07:33:54.773 , ModifyDate: 02/18/2013 19:04:02.847 */
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
