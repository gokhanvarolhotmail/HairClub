/***********************************************************************
NAME:					fnGetCurrentMembershipDetailsByCenterID
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------
CHANGE HISTORY:
10/21/2013 - DL - Created function to return the current client membership details into a table
02/03/2015 - RH - Added code for Xtrands client membership
12/28/2018 - EP - Converted to an inline table valued function to improve performance.
------------------------------------------------------------------------
USAGE:
------------------------------------------------------------------------

SELECT * FROM dbo.fnGetCurrentMembershipDetailsByCenterID(285)
***********************************************************************/
CREATE FUNCTION [dbo].[fnGetCurrentMembershipDetailsByCenterID]
(
	@CenterID INT
)
RETURNS TABLE
--RETURNS @CurrentMembershipDetails TABLE
--(
--	CenterSSID INT
--,	CenterDescription VARCHAR(255)
--,	ClientSSID UNIQUEIDENTIFIER
--,	ClientKey INT
--,	ClientIdentifier INT
--,	CMSClientIdentifier INT
--,	ClientName VARCHAR(104)
--,	GenderSSID INT
--,	SiebelID VARCHAR(50)
--,	ClientMembershipKey INT
--,	ClientMembershipSSID UNIQUEIDENTIFIER
--,	MembershipKey INT
--,	MembershipSSID INT
--,	Membership VARCHAR(50)
--,	MembershipDescriptionShort VARCHAR(10)
--,	MembershipStatus VARCHAR(50)
--,	MembershipSortOrder INT
--,	ContractPrice MONEY
--,	ContractPaidAmount MONEY
--,	MonthlyFee MONEY
--,	MembershipBeginDate DATETIME
--,	MembershipEndDate DATETIME
--,	BusinessSegmentSSID INT
--,	RevenueGroupSSID INT
--,	ClientMembershipIdentifier VARCHAR(50)
--)
--AS
--BEGIN

--INSERT  INTO @CurrentMembershipDetails
RETURN
		SELECT  CTR.CenterSSID
		,		CTR.CenterDescriptionNumber AS 'CenterDescription'
		,		CLT.ClientSSID
		,		CLT.ClientKey
		,       CLT.ClientIdentifier
		,       CLT.ClientNumber_Temp AS 'CMSClientIdentifier'
		,       CLT.ClientFullName AS 'ClientName'
		,		CLT.GenderSSID
		,		ISNULL(CLT.BosleySiebelID, '') AS 'SiebelID'
		,       ISNULL(Active_Memberships.ClientMembershipKey, All_Memberships.ClientMembershipKey) AS 'ClientMembershipKey'
		,       ISNULL(Active_Memberships.ClientMembershipSSID, All_Memberships.ClientMembershipSSID) AS 'ClientMembershipSSID'
		,       ISNULL(Active_Memberships.MembershipKey, All_Memberships.MembershipKey) AS 'MembershipKey'
		,       ISNULL(Active_Memberships.MembershipSSID, All_Memberships.MembershipSSID) AS 'MembershipSSID'
		,       ISNULL(Active_Memberships.Membership, All_Memberships.Membership) AS 'Membership'
		,       ISNULL(Active_Memberships.MembershipDescriptionShort, All_Memberships.MembershipDescriptionShort) AS 'MembershipDescriptionShort'
		,       ISNULL(Active_Memberships.MembershipStatus, All_Memberships.MembershipStatus) AS 'MembershipStatus'
		,       ISNULL(Active_Memberships.MembershipSortOrder, All_Memberships.MembershipSortOrder) AS 'MembershipSortOrder'
		,       ISNULL(Active_Memberships.ContractPrice, All_Memberships.ContractPrice) AS 'ContractPrice'
		,       ISNULL(Active_Memberships.ContractPaidAmount, All_Memberships.ContractPaidAmount) AS 'ContractPaidAmount'
		,       ISNULL(Active_Memberships.MonthlyFee, All_Memberships.MonthlyFee) AS 'MonthlyFee'
		,       ISNULL(Active_Memberships.MembershipBeginDate, All_Memberships.MembershipBeginDate) AS 'MembershipBeginDate'
		,       ISNULL(Active_Memberships.MembershipEndDate, All_Memberships.MembershipEndDate) AS 'MembershipEndDate'
		,       ISNULL(Active_Memberships.BusinessSegmentSSID, All_Memberships.BusinessSegmentSSID) AS 'BusinessSegmentSSID'
		,       ISNULL(Active_Memberships.RevenueGroupSSID, All_Memberships.RevenueGroupSSID) AS 'RevenueGroupSSID'
		,       ISNULL(Active_Memberships.ClientMembershipIdentifier, All_Memberships.ClientMembershipIdentifier) AS 'ClientMembershipIdentifier'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterSSID = CLT.CenterSSID
				OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipKey
							  ,         DCM.ClientMembershipSSID
							  ,         DM.MembershipKey
							  ,         DM.MembershipSSID
							  ,         DM.MembershipDescription AS 'Membership'
							  ,			DM.MembershipDescriptionShort
							  ,         DCM.ClientMembershipStatusDescription AS 'MembershipStatus'
							  ,			DM.MembershipSortOrder
							  ,         DCM.ClientMembershipContractPrice AS 'ContractPrice'
							  ,			DCM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
							  ,         DCM.ClientMembershipMonthlyFee AS 'MonthlyFee'
							  ,         DCM.ClientMembershipBeginDate AS 'MembershipBeginDate'
							  ,         DCM.ClientMembershipEndDate AS 'MembershipEndDate'
							  ,			DM.BusinessSegmentSSID
							  ,			DM.RevenueGroupSSID
							  ,         DCM.ClientMembershipIdentifier
							  FROM      HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
											ON DM.MembershipKey = DCM.MembershipKey
							  WHERE     ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
										AND DCM.ClientMembershipStatusDescription = 'Active'
							  ORDER BY  DCM.ClientMembershipEndDate DESC
							) Active_Memberships
				OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipKey
							  ,         DCM.ClientMembershipSSID
							  ,         DM.MembershipKey
							  ,         DM.MembershipSSID
							  ,         DM.MembershipDescription AS 'Membership'
							  ,			DM.MembershipDescriptionShort
							  ,         DCM.ClientMembershipStatusDescription AS 'MembershipStatus'
							  ,			DM.MembershipSortOrder
							  ,         DCM.ClientMembershipContractPrice AS 'ContractPrice'
							  ,			DCM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount'
							  ,         DCM.ClientMembershipMonthlyFee AS 'MonthlyFee'
							  ,         DCM.ClientMembershipBeginDate AS 'MembershipBeginDate'
							  ,         DCM.ClientMembershipEndDate AS 'MembershipEndDate'
							  ,			DM.BusinessSegmentSSID
							  ,			DM.RevenueGroupSSID
							  ,         DCM.ClientMembershipIdentifier
							  FROM      HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
										INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
											ON DM.MembershipKey = DCM.MembershipKey
							  WHERE     ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
							  ORDER BY  DCM.ClientMembershipEndDate DESC
							) All_Memberships
		WHERE   CLT.CenterSSID = @CenterID

--RETURN

--END
