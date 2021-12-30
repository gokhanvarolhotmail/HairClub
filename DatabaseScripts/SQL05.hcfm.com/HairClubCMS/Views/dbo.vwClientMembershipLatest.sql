/* CreateDate: 12/11/2012 14:57:24.117 , ModifyDate: 12/11/2012 14:57:24.117 */
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
