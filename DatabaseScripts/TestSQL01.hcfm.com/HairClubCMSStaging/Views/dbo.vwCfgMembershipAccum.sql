/* CreateDate: 04/14/2009 07:33:54.850 , ModifyDate: 02/18/2013 19:04:03.060 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwCfgMembershipAccum]
AS
SELECT     ma.MembershipAccumulatorID, ma.MembershipAccumulatorSortOrder, m.MembershipDescription, a.AccumulatorDescription, ma.InitialQuantity,
                      ma.IsActiveFlag, ma.CreateDate, ma.CreateUser, ma.LastUpdate, ma.LastUpdateUser, ma.UpdateStamp
FROM         dbo.cfgMembershipAccum AS ma LEFT OUTER JOIN
                      dbo.cfgMembership AS m ON m.MembershipID = ma.MembershipID LEFT OUTER JOIN
                      dbo.cfgAccumulator AS a ON a.AccumulatorID = ma.AccumulatorID
GO
