/* CreateDate: 12/11/2012 14:57:23.743 , ModifyDate: 12/11/2012 14:57:23.743 */
GO
CREATE VIEW [dbo].[vwCfgAccumulator]
AS
SELECT     TOP (100) PERCENT a.AccumulatorID, a.AccumulatorSortOrder, a.AccumulatorDescription, a.AccumulatorDescriptionShort,
                      adt.AccumulatorDataTypeDescription, a.SalesOrderProcessFlag, aacttSales.AccumulatorActionTypeDescription AS SalesOrderActionType,
                      aajdSales.AccumulatorAdjustmentTypeDescription AS SalesOrderAdjustmentType, a.SchedulerProcessFlag,
                      aacttSched.AccumulatorActionTypeDescription AS ScheduleOrderActionType,
                      aajdSched.AccumulatorAdjustmentTypeDescription AS ScheduleOrderAdjustmentType, a.AdjustARBalanceFlag, a.AdjustContractPriceFlag,
                      a.AdjustContractPaidFlag, a.IsActiveFlag, a.CreateDate, a.CreateUser, a.LastUpdate, a.LastUpdateUser, a.UpdateStamp
FROM         dbo.cfgAccumulator AS a LEFT OUTER JOIN
                              cfgAccumulatorJoin b ON a.AccumulatorID = b.AccumulatorID LEFT JOIN
                      dbo.lkpAccumulatorDataType AS adt ON a.AccumulatorDataTypeID = adt.AccumulatorDataTypeID LEFT OUTER JOIN
                      dbo.lkpAccumulatorActionType AS aacttSales ON b.AccumulatorActionTypeID = aacttSales.AccumulatorActionTypeID LEFT OUTER JOIN
                      dbo.lkpAccumulatorAdjustmentType AS aajdSales ON b.AccumulatorActionTypeID = aajdSales.AccumulatorAdjustmentTypeID LEFT OUTER JOIN
                      dbo.lkpAccumulatorActionType AS aacttSched ON a.SchedulerActionTypeID = aacttSched.AccumulatorActionTypeID LEFT OUTER JOIN
                      dbo.lkpAccumulatorAdjustmentType AS aajdSched ON a.SchedulerAdjustmentTypeID = aajdSched.AccumulatorAdjustmentTypeID
ORDER BY a.AccumulatorSortOrder
GO
