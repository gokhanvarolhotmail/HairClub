/* CreateDate: 12/11/2012 14:57:23.943 , ModifyDate: 12/11/2012 14:57:23.943 */
GO
CREATE VIEW [dbo].[vwCfgMembershipAccum]
AS
SELECT     ma.MembershipAccumulatorID, ma.MembershipAccumulatorSortOrder, m.MembershipDescription, a.AccumulatorDescription, ma.InitialQuantity,
                      ma.IsActiveFlag, ma.CreateDate, ma.CreateUser, ma.LastUpdate, ma.LastUpdateUser, ma.UpdateStamp
FROM         dbo.cfgMembershipAccum AS ma LEFT OUTER JOIN
                      dbo.cfgMembership AS m ON m.MembershipID = ma.MembershipID LEFT OUTER JOIN
                      dbo.cfgAccumulator AS a ON a.AccumulatorID = ma.AccumulatorID
GO
