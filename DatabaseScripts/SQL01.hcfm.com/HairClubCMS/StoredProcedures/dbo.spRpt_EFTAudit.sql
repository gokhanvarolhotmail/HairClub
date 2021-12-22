/***********************************************************************
PROCEDURE:				spRpt_EFTAudit
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
RELATED REPORT:			EFT Audit
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/28/2014
------------------------------------------------------------------------
NOTES:

03/12/2014 - MT - This script is used to audit data prior to running Monthly Fees.
04/14/2014 - DL - Added AlertLevel column to indicate items that must be addressed prior to Fee Run.
04/24/2014 - ML - Added PCP Clients Missing an EFT Profile.
04/28/2014 - DL - Created stored procedure.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_EFTAudit
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_EFTAudit]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


CREATE TABLE #Audit (
    Issue NVARCHAR(255)
,	CenterID INT
,	ClientIdentifier INT
,	Client NVARCHAR(255)
,	PayCycle VARCHAR(MAX)
,	AlertLevel NVARCHAR(255)
,	AlertSortOrder INT
)


------------------------------------------------------------------
--
-- Determine which clients have an BIO PCP Membership without an EFT Profile
--
--
------------------------------------------------------------------
INSERT  INTO #Audit
		SELECT  'Clients w/ PCP Membership - No EFT Profile' AS 'Issue'
		,       c.CenterID
		,       c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,       [dbo].[fnGetClientPayCycle](c.ClientIdentifier) AS 'PayCycle'
		,       'Critical' AS 'AlertLevel'
		,       1 AS 'AlertSortOrder'
		FROM    datClient c
				INNER JOIN cfgConfigurationCenter cc
					ON c.CenterID = cc.CenterID
				LEFT OUTER JOIN datClientMembership cm_bio
					ON c.CurrentBioMatrixClientMembershipGUID = cm_bio.ClientMembershipGUID
				LEFT OUTER JOIN cfgMembership m_bio
					ON cm_bio.MembershipID = m_bio.MembershipID
				LEFT OUTER JOIN lkpRevenueGroup rg_bio
					ON m_bio.RevenueGroupID = rg_bio.RevenueGroupID
				LEFT OUTER JOIN datClientEFT eft_bio
					ON cm_bio.ClientMembershipGUID = eft_bio.ClientMembershipGUID
				LEFT OUTER JOIN datClientMembership cm_ext
					ON c.CurrentExtremeTherapyClientMembershipGUID = cm_ext.ClientMembershipGUID
				LEFT OUTER JOIN cfgMembership m_ext
					ON cm_ext.MembershipID = m_ext.MembershipID
				LEFT OUTER JOIN lkpRevenueGroup rg_ext
					ON m_ext.RevenueGroupID = rg_ext.RevenueGroupID
				LEFT OUTER JOIN datClientEFT eft_ext
					ON cm_ext.ClientMembershipGUID = eft_ext.ClientMembershipGUID
				LEFT OUTER JOIN datClientMembership cm_xtr
					ON c.CurrentXtrandsClientMembershipGUID = cm_xtr.ClientMembershipGUID
				LEFT OUTER JOIN cfgMembership m_xtr
					ON cm_xtr.MembershipID = m_xtr.MembershipID
				LEFT OUTER JOIN lkpRevenueGroup rg_xtr
					ON m_xtr.RevenueGroupID = rg_xtr.RevenueGroupID
				LEFT OUTER JOIN datClientEFT eft_xtr
					ON cm_xtr.ClientMembershipGUID = eft_xtr.ClientMembershipGUID
		WHERE   ( ( rg_bio.RevenueGroupDescriptionShort = 'PCP'
					AND cm_bio.ClientMembershipStatusID = 1
					AND m_bio.MembershipDescriptionShort <> 'NONPGM'
					AND eft_bio.ClientEFTGUID IS NULL )
				  OR ( rg_ext.RevenueGroupDescriptionShort = 'PCP'
					   AND cm_ext.ClientMembershipStatusID = 1
					   AND m_ext.MembershipDescriptionShort <> 'NONPGM'
					   AND eft_ext.ClientEFTGUID IS NULL )
				  OR ( rg_xtr.RevenueGroupDescriptionShort = 'PCP'
					   AND cm_xtr.ClientMembershipStatusID = 1
					   AND m_xtr.MembershipDescriptionShort <> 'NONPGM'
					   AND eft_xtr.ClientEFTGUID IS NULL ) )
				AND cc.HasFullAccess = 1


------------------------------------------------------------------
--
-- Determine which clients are on a Payment Plan without an EFT Profile
--
--
------------------------------------------------------------------
INSERT  INTO #Audit
		SELECT  'Clients on Payment Plan - No EFT Profile' AS 'Issue'
		,       c.CenterID
		,       c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,       [dbo].[fnGetClientPayCycle](c.ClientIdentifier) AS 'PayCycle'
		,       'Critical' AS 'AlertLevel'
		,       1 AS 'AlertSortOrder'
		FROM    datPaymentPlan pp
				INNER JOIN datClientMembership cm
					ON cm.ClientMembershipGUID = pp.ClientMembershipGUID
				INNER JOIN lkpClientMembershipStatus st
					ON st.ClientMembershipStatusID = cm.ClientMembershipStatusID
				INNER JOIN cfgMembership m
					ON m.MembershipID = cm.MembershipID
				INNER JOIN datClient c
					ON c.ClientGUID = cm.ClientGUID
				INNER JOIN lkpPaymentPlanStatus pst
					ON pst.PaymentPlanStatusID = pp.PaymentPlanStatusID
				LEFT JOIN datClientEFT eft
					ON eft.ClientMembershipGUID = pp.ClientMembershipGUID
		WHERE   st.ClientMembershipStatusDescriptionShort = 'A'
				AND pst.PaymentPlanStatusDescriptionShort = 'Active'
				AND pp.CancelDate IS NULL
				AND pp.SatisfactionDate IS NULL
				AND ( eft.ClientEFTGUID IS NULL )


------------------------------------------------------------------
--
-- Determine which clients have more than 1 profile within same
-- business segment
--
-- Active  (Needs to be looked at!)
--
------------------------------------------------------------------
INSERT	INTO #Audit
		SELECT  'Clients w/ Multiple EFT Profiles - Same Business Segment' AS 'Issue'
		,       c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,		[dbo].[fnGetClientPayCycle] (c.ClientIdentifier) AS 'PayCycle'
		,		'Critical' AS 'AlertLevel'
		,		2 AS 'AlertSortOrder'
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
		GROUP BY c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc
		,       mem.BusinessSegmentID
		,       bs.BusinessSegmentDescription
		HAVING  COUNT(*) > 1
		ORDER BY c.CenterID
		,		c.ClientIdentifier


------------------------------------------------------------------
--
-- Determine Whether a client has NULL for Account Type
--
-- Active (Needs to be looked at!)
--
------------------------------------------------------------------
INSERT	INTO #Audit
		SELECT  'Clients w/ NULL Account Type' AS 'Issue'
		,       c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,		[dbo].[fnGetClientPayCycle] (c.ClientIdentifier) AS 'PayCycle'
		,		'Critical' AS 'AlertLevel'
		,		3 AS 'AlertSortOrder'
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
				'Clients w/ Invalid Tokens' AS 'Issue'
		,       c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,		[dbo].[fnGetClientPayCycle] (c.ClientIdentifier) AS 'PayCycle'
		,		'Critical' AS 'AlertLevel'
		,		4 AS 'AlertSortOrder'
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
		WHERE   pt.Verbiage = 'Token referenced not found (for oneshot use)'
				AND eft.EFTAccountTypeID = 1
				AND pt.CreateDate > DATEADD(mm, -1, GETUTCDATE())
				AND eft.LastUpdate <= pt.CreateDate  -- eft has not been updated.
		--and pt2.CreateDate > pt.CreateDate
		--and so2.ClientMembershipGUID = so.ClientMembershipGUID
		--and pt2.Verbiage <> 'Token referenced not found (for oneshot use)'
		ORDER BY c.CenterID
		,		c.ClientIdentifier


------------------------------------------------------------------
--
-- Determine Whether a client has more than 1 EFT Profile for the same PayCycle
--
-- Active (Informational - Research)
--
------------------------------------------------------------------
INSERT	INTO #Audit
		SELECT  'Clients w/ Multiple EFT Profiles - Same Pay Cycle' AS 'Issue'
		,       c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,		pc.FeePayCycleDescription AS 'PayCycle'
		,		'Informational' AS 'AlertLevel'
		,		5 AS 'AlertSortOrder'
		FROM    datClient c
				INNER JOIN datClientEFT eft
					ON c.ClientGUID = eft.ClientGUID
				INNER JOIN lkpFeePayCycle pc
					ON eft.FeePayCycleID = pc.FeePayCycleID
		GROUP BY c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc
		,		pc.FeePayCycleDescription
		HAVING  COUNT(c.ClientGUID) > 1
		ORDER BY c.CenterID
		,		c.ClientIdentifier


------------------------------------------------------------------
--
-- Determine which clients have more than 1 profile
--
-- (Informational - Research)
--
------------------------------------------------------------------
INSERT	INTO #Audit
		SELECT  'Clients w/ Multiple EFT Profiles' AS 'Issue'
		,       c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc AS 'Client'
		,		[dbo].[fnGetClientPayCycle] (c.ClientIdentifier) AS 'PayCycle'
		,		'Informational' AS 'AlertLevel'
		,		6 AS 'AlertSortOrder'
		FROM    datClient c
				INNER JOIN datClientEFT eft
					ON eft.ClientGUID = c.ClientGUID
		GROUP BY c.CenterID
		,		c.ClientIdentifier
		,       c.ClientFullNameCalc
		HAVING  COUNT(*) > 1
		ORDER BY c.CenterID
		,		c.ClientIdentifier


-- Display Results
SELECT  A.Issue
,       A.CenterID
,       A.ClientIdentifier
,       A.Client
,		A.PayCycle
,       A.AlertLevel
,		A.AlertSortOrder
FROM    #Audit A
WHERE	A.CenterID <> 1001
ORDER BY AlertSortOrder
,       CenterID
,       ClientIdentifier

END
