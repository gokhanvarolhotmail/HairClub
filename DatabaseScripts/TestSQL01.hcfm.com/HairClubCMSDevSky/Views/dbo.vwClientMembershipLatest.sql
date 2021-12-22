/* CreateDate: 03/12/2010 05:29:26.060 , ModifyDate: 02/18/2013 19:04:03.297 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwClientMembershipLatest]
AS
SELECT DISTINCT bs.BusinessSegmentID, cm.ClientGUID, cm.ClientMembershipGUID
FROM datClientMembership AS cm
	INNER JOIN cfgMembership AS m ON cm.MembershipID = m.MembershipID
	INNER JOIN lkpBusinessSegment AS bs ON m.BusinessSegmentID = bs.BusinessSegmentID
	INNER JOIN (
		SELECT bs.BusinessSegmentID, cm.ClientGUID, MAX(cm.BeginDate) AS BeginDate
		FROM datClientMembership AS cm
			INNER JOIN cfgMembership AS m ON cm.MembershipID = m.MembershipID
			INNER JOIN lkpBusinessSegment AS bs ON m.BusinessSegmentID = bs.BusinessSegmentID
		GROUP BY bs.BusinessSegmentID, cm.ClientGUID) AS subMaxCM ON cm.ClientGUID = subMaxCM.ClientGUID AND cm.BeginDate = subMaxCM.BeginDate AND bs.BusinessSegmentID = subMaxCM.BusinessSegmentID
GO
