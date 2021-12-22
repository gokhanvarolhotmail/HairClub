/* CreateDate: 04/14/2009 07:33:54.930 , ModifyDate: 02/18/2013 19:04:03.337 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
