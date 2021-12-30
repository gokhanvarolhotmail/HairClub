/* CreateDate: 12/11/2012 14:57:24.150 , ModifyDate: 12/11/2012 14:57:24.150 */
GO
CREATE VIEW [dbo].[vwDatAccumulatorAdjustment]
AS
SELECT     aa.AccumulatorAdjustmentGUID, m.MembershipDescription, cli.ClientFullNameAltCalc, aa.SalesOrderDetailGUID, aa.AppointmentGUID,
                      acc.AccumulatorDescription, lkpAAT.AccumulatorActionTypeDescription, aa.QuantityUsedOriginal, aa.QuantityUsedAdjustment,
                      aa.QuantityTotalOriginal, aa.QuantityTotalAdjustment, aa.MoneyOriginal, aa.MoneyAdjustment, aa.DateOriginal, aa.DateAdjustment, aa.CreateDate,
                      aa.CreateUser, aa.LastUpdate, aa.LastUpdateUser, aa.UpdateStamp
FROM         dbo.datAccumulatorAdjustment AS aa LEFT OUTER JOIN
                      dbo.datClientMembership AS cm ON cm.ClientMembershipGUID = aa.ClientMembershipGUID LEFT OUTER JOIN
                      dbo.cfgAccumulator AS acc ON acc.AccumulatorID = aa.AccumulatorID LEFT OUTER JOIN
                      dbo.lkpAccumulatorActionType AS lkpAAT ON lkpAAT.AccumulatorActionTypeID = aa.AccumulatorActionTypeID LEFT OUTER JOIN
                      dbo.cfgMembership AS m ON m.MembershipID = cm.MembershipID LEFT OUTER JOIN
                      dbo.datClient AS cli ON cli.ClientGUID = cm.ClientGUID
GO
