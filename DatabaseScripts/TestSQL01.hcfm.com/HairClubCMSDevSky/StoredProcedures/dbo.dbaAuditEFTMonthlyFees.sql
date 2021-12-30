/* CreateDate: 03/12/2014 19:05:57.363 , ModifyDate: 04/28/2014 09:08:25.120 */
GO
/***********************************************************************
PROCEDURE:				dbaAuditEFTMonthlyFees
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		03/12/2014
LAST REVISION DATE: 	03/12/2014
--------------------------------------------------------------------------------------------------------
NOTES:

03/12/2014 - MT - This script is used to audit data prior to running Monthly Fees.
04/14/2014 - DL - Added AlertLevel column to indicate items that must be addressed prior to Fee Run.
04/24/2014 - ML - Added PCP Clients Missing an EFT Profile.
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC dbaAuditEFTMonthlyFees
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaAuditEFTMonthlyFees]
AS
BEGIN

CREATE TABLE #Audit (
    Issue NVARCHAR(255)
,	PayCycle NVARCHAR(255)
,	CenterID INT
,	ClientIdentifier INT
,	Client NVARCHAR(255)
,	BusinessSegment NVARCHAR(255)
,	AccountType NVARCHAR(255)
,	ProfileCount INT
,	AlertLevel NVARCHAR(255)
,	AlertSortOrder INT
)


------------------------------------------------------------------
--
-- Determine which clients have more than 1 profile within same
-- business segment
--
-- Active  (Needs to be looked at!)
--
------------------------------------------------------------------
INSERT	INTO #Audit
		SELECT  'Multiple EFT Profiles - Same Business Segment' AS 'Issue'
		,       pc.FeePayCycleDescription AS 'PayCycle'
		,       c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,       bs.BusinessSegmentDescription AS 'BusinessSegment'
		,       eftAt.EFTAccountTypeDescription AS 'AccountType'
		,       COUNT(*) AS 'ProfileCount'
		,		'Critical' AS 'AlertLevel'
		,		1 AS 'AlertSortOrder'
		FROM    datClient c
				INNER JOIN datClientEFT eft
					ON eft.ClientGUID = c.ClientGUID
				INNER JOIN datClientMembership cm
					ON cm.ClientMembershipGUID = eft.ClientMembershipGUID
				INNER JOIN cfgMembership mem
					ON mem.MembershipID = cm.MembershipID
				INNER JOIN lkpBusinessSegment bs
					ON bs.BusinessSegmentID = mem.BusinessSegmentID
				INNER JOIN lkpFeePayCycle pc
					ON pc.FeePayCycleID = eft.FeePayCycleID
				LEFT JOIN lkpEFTAccountType eftAt
					ON eftAt.EFTAccountTypeID = eft.EFTAccountTypeID
		GROUP BY pc.FeePayCycleDescription
		,		c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc
		,       mem.BusinessSegmentID
		,       bs.BusinessSegmentDescription
		,       eftAt.EFTAccountTypeDescription
		HAVING  COUNT(*) > 1
		ORDER BY pc.FeePayCycleDescription
		,		c.CenterID
		,		c.ClientIdentifier


------------------------------------------------------------------
--
-- Determine Whether a client has NULL for Account Type
--
-- Active (Needs to be looked at!)
--
------------------------------------------------------------------
INSERT	INTO #Audit
		SELECT  'NULL Account Type' AS 'Issue'
		,       pc.FeePayCycleDescription AS 'PayCycle'
		,       c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,       '' AS 'BusinessSegment'
		,       '' AS 'AccountType'
		,       '' AS 'ProfileCount'
		,		'Critical' AS 'AlertLevel'
		,		2 AS 'AlertSortOrder'
		FROM    datClient c
				INNER JOIN datClientEFT eft
					ON c.ClientGUID = eft.ClientGUID
				INNER JOIN lkpFeePayCycle pc
					ON pc.FeePayCycleID = eft.FeePayCycleID
		WHERE   eft.EFTAccountTypeID IS NULL
		ORDER BY pc.FeePayCycleDescription
		,		c.CenterID
		,		c.ClientIdentifier


------------------------------------------------------------------
--
-- Clients that need their EFT Profile updated. Currently have
-- invalid token.
--
-- (Needs to be looked at!)
--
------------------------------------------------------------------
INSERT	INTO #Audit
		SELECT DISTINCT
				'Invalid Tokens' AS 'Issue'
		,       pc.FeePayCycleDescription AS 'PayCycle'
		,       c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,       '' AS 'BusinessSegment'
		,       eftAt.EFTAccountTypeDescription AS 'AccountType'
		,       '' AS 'ProfileCount'
		,		'Critical' AS 'AlertLevel'
		,		3 AS 'AlertSortOrder'
		FROM    datPayCycleTransaction pt
				INNER JOIN datSalesOrder so
					ON so.SalesOrderGUID = pt.SalesOrderGUID
				INNER JOIN datClient c
					ON c.ClientGUID = so.ClientGUID
				INNER JOIN datClientEFT eft
					ON eft.ClientMembershipGUID = so.ClientMembershipGUID
				INNER JOIN lkpFeePayCycle pc
					ON pc.FeePayCycleID = eft.FeePayCycleID
				LEFT JOIN lkpEFTAccountType eftAt
					ON eftAt.EFTAccountTypeID = eft.EFTAccountTypeID
		--LEFT JOIN datPayCycleTransaction pt2 ON pt.ClientGUID =  pt2.ClientGUID
		--LEFT JOIN datSalesOrder so2 ON so2.SalesOrderGUID = pt2.SalesOrderGUID
		WHERE   pt.Verbiage = 'Token referenced not found (for oneshot use)'
				AND eft.EFTAccountTypeID = 1
				AND pt.CreateDate > DATEADD(mm, -1, GETUTCDATE())
				AND eft.LastUpdate <= pt.CreateDate  -- eft has not been updated.
		--and pt2.CreateDate > pt.CreateDate
		--and so2.ClientMembershipGUID = so.ClientMembershipGUID
		--and pt2.Verbiage <> 'Token referenced not found (for oneshot use)'
		ORDER BY pc.FeePayCycleDescription
		,		c.CenterID
		,		c.ClientIdentifier


------------------------------------------------------------------
--
-- Determine Whether a client has more than 1 EFT Profile for the same PayCycle
--
-- Active (Informational - Research)
--
------------------------------------------------------------------
INSERT	INTO #Audit
		SELECT  'Multiple EFT Profiles - Same Pay Cycle' AS 'Issue'
		,       pc.FeePayCycleDescription AS 'PayCycle'
		,       c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,       '' AS 'BusinessSegment'
		,       '' AS 'AccountType'
		,       COUNT(c.ClientGUID) AS 'ProfileCount'
		,		'Informational' AS 'AlertLevel'
		,		4 AS 'AlertSortOrder'
		FROM    datClient c
				INNER JOIN datClientEFT eft
					ON c.ClientGUID = eft.ClientGUID
				INNER JOIN lkpFeePayCycle pc
					ON eft.FeePayCycleID = pc.FeePayCycleID
		GROUP BY pc.FeePayCycleDescription
		,       c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc
		HAVING  COUNT(c.ClientGUID) > 1
		ORDER BY pc.FeePayCycleDescription
		,		c.CenterID
		,		c.ClientIdentifier


------------------------------------------------------------------
--
-- Determine which clients have more than 1 profile
--
-- (Informational - Research)
--
------------------------------------------------------------------
INSERT	INTO #Audit
		SELECT  'Multiple EFT Profiles' AS 'Issue'
		,       '' AS 'PayCycle'
		,       c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,       '' AS 'BusinessSegment'
		,       '' AS 'AccountType'
		,       COUNT(*) AS ProfileCount
		,		'Informational' AS 'AlertLevel'
		,		5 AS 'AlertSortOrder'
		FROM    datClient c
				INNER JOIN datClientEFT eft
					ON eft.ClientGUID = c.ClientGUID
		GROUP BY c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc
		HAVING  COUNT(*) > 1
		ORDER BY c.CenterID
		,		c.ClientIdentifier


------------------------------------------------------------------
--
-- Determine which clients have an BIO PCP Membership without an EFT Profile
--
--
------------------------------------------------------------------
INSERT INTO #Audit
	Select 'PCP Membership - No EFT Profile' as 'Issue'
			,		'' as 'PayCycle'
			,		c.CenterID
			,		c.ClientIdentifier
			,		c.ClientFullNameCalc as 'Client'
			,       '' AS 'BusinessSegment'
			,       '' AS 'AccountType'
			,       0 AS ProfileCount
			,		'Informational' AS 'AlertLevel'
			,		6 AS 'AlertSortOrder'
	from datClient c
		inner join datClientMembership cm on c.CurrentBioMatrixClientMembershipGUID = cm.ClientMembershipGUID
		inner join cfgMembership m on cm.MembershipId = m.MembershipID
		inner join lkpRevenueGroup rg on m.REvenueGroupID = rg.RevenueGroupID
		LEFT OUTER JOIN datClientEFT eft on c.ClientGUID = eft.ClientGUID
		inner join cfgConfigurationCenter cc on c.CenterID = cc.CenterID
	Where rg.RevenueGroupDescriptionShort = 'PCP'
		AND cm.ClientMembershipStatusID = 1 --Active
		AND m.MembershipDescriptionShort <> 'NONPGM'
		AnD eft.ClientEFTGUID IS NULL
		AND cc.HasFullAccess = 1
UNION
	Select 'PCP Membership - No EFT Profile' as 'Issue'
			,		'' as 'PayCycle'
			,		c.CenterID
			,		c.ClientIdentifier
			,		c.ClientFullNameCalc as 'Client'
			,       '' AS 'BusinessSegment'
			,       '' AS 'AccountType'
			,       0 AS ProfileCount
			,		'Informational' AS 'AlertLevel'
			,		6 AS 'AlertSortOrder'
	from datClient c
		inner join datClientMembership cm on c.CurrentExtremeTherapyClientMembershipGUID = cm.ClientMembershipGUID
		inner join cfgMembership m on cm.MembershipId = m.MembershipID
		inner join lkpRevenueGroup rg on m.REvenueGroupID = rg.RevenueGroupID
		LEFT OUTER JOIN datClientEFT eft on c.ClientGUID = eft.ClientGUID
		inner join cfgConfigurationCenter cc on c.CenterID = cc.CenterID
	Where rg.RevenueGroupDescriptionShort = 'PCP'
		AND cm.ClientMembershipStatusID = 1 --Active
		AND m.MembershipDescriptionShort <> 'NONPGM'
		AnD eft.ClientEFTGUID IS NULL
		AND cc.HasFullAccess = 1
		AND cm.EndDate > GETUTCDATE()


SELECT  A.Issue
,       A.PayCycle
,       A.CenterID
,       A.ClientIdentifier
,       A.Client
,       A.BusinessSegment
,       A.AccountType
,       A.ProfileCount
,       A.AlertLevel
FROM    #Audit A
ORDER BY AlertSortOrder
,       CenterID
,       ClientIdentifier

END
GO
