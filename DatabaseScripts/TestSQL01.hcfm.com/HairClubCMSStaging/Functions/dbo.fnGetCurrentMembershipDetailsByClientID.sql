/* CreateDate: 04/30/2015 17:00:35.010 , ModifyDate: 05/06/2015 11:55:51.280 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
NAME:					fnGetCurrentMembershipDetailsByClientID
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------

04/30/2015 - DL - Created function to return the current client membership details into a table
------------------------------------------------------------------------
USAGE:
------------------------------------------------------------------------

SELECT * FROM dbo.fnGetCurrentMembershipDetailsByClientID(352799)
***********************************************************************/
CREATE FUNCTION [dbo].[fnGetCurrentMembershipDetailsByClientID]
(
	@ClientID INT
)
RETURNS @CurrentMembershipDetails TABLE
(
	CenterID INT
,	CenterDescription VARCHAR(255)
,	ClientIdentifier INT
,	CMSClientIdentifier INT
,	ClientName VARCHAR(104)
,	GenderID INT
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	ClientMembershipIdentifier VARCHAR(50)
,	MembershipID INT
,	Membership VARCHAR(50)
,	MembershipDescriptionShort VARCHAR(10)
,	MembershipStatus VARCHAR(50)
,	MembershipSortOrder INT
,	ContractPrice MONEY
,	MonthlyFee MONEY
,	MembershipBeginDate DATETIME
,	MembershipEndDate DATETIME
,	BusinessSegmentID INT
,	RevenueGroupID INT
)
AS
BEGIN

INSERT  INTO @CurrentMembershipDetails
		SELECT  CTR.CenterID
		,		CTR.CenterDescriptionFullCalc AS 'CenterDescription'
		,       CLT.ClientIdentifier
		,       CLT.ClientNumber_Temp AS 'CMSClientIdentifier'
		,       CLT.ClientFullNameAlt2Calc AS 'ClientName'
		,		CLT.GenderID
		,       ISNULL(Active_Memberships.ClientMembershipGUID, All_Memberships.ClientMembershipGUID) AS 'ClientMembershipGUID'
		,       ISNULL(Active_Memberships.ClientMembershipIdentifier, All_Memberships.ClientMembershipIdentifier) AS 'ClientMembershipIdentifier'
		,       ISNULL(Active_Memberships.MembershipID, All_Memberships.MembershipID) AS 'MembershipID'
		,       ISNULL(Active_Memberships.Membership, All_Memberships.Membership) AS 'Membership'
		,       ISNULL(Active_Memberships.MembershipDescriptionShort, All_Memberships.MembershipDescriptionShort) AS 'MembershipDescriptionShort'
		,       ISNULL(Active_Memberships.MembershipStatus, All_Memberships.MembershipStatus) AS 'MembershipStatus'
		,       ISNULL(Active_Memberships.MembershipSortOrder, All_Memberships.MembershipSortOrder) AS 'MembershipSortOrder'
		,       ISNULL(Active_Memberships.ContractPrice, All_Memberships.ContractPrice) AS 'ContractPrice'
		,       ISNULL(Active_Memberships.MonthlyFee, All_Memberships.MonthlyFee) AS 'MonthlyFee'
		,       ISNULL(Active_Memberships.MembershipBeginDate, All_Memberships.MembershipBeginDate) AS 'MembershipBeginDate'
		,       ISNULL(Active_Memberships.MembershipEndDate, All_Memberships.MembershipEndDate) AS 'MembershipEndDate'
		,       ISNULL(Active_Memberships.BusinessSegmentID, All_Memberships.BusinessSegmentID) AS 'BusinessSegmentID'
		,       ISNULL(Active_Memberships.RevenueGroupID, All_Memberships.RevenueGroupID) AS 'RevenueGroupID'
		FROM    datClient CLT
				INNER JOIN cfgCenter CTR
					ON CTR.CenterID = CLT.CenterID
				OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipGUID
							  ,         DM.MembershipID
							  ,         DM.MembershipDescription AS 'Membership'
							  ,			DM.MembershipDescriptionShort
							  ,         DCMS.ClientMembershipStatusDescription AS 'MembershipStatus'
							  ,			DM.MembershipSortOrder
							  ,         DCM.ContractPrice AS 'ContractPrice'
							  ,         DCM.MonthlyFee AS 'MonthlyFee'
							  ,         DCM.BeginDate AS 'MembershipBeginDate'
							  ,         DCM.EndDate AS 'MembershipEndDate'
							  ,			DM.BusinessSegmentID
							  ,			DM.RevenueGroupID
							  ,         DCM.ClientMembershipIdentifier
							  FROM      datClientMembership DCM
										INNER JOIN cfgMembership DM
											ON DM.MembershipID = DCM.MembershipID
										INNER JOIN lkpClientMembershipStatus DCMS
											ON DCMS.ClientMembershipStatusID = DCM.ClientMembershipStatusID
							  WHERE     ( DCM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
										  OR DCM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
										  OR DCM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
										  OR DCM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID )
										AND DCMS.ClientMembershipStatusDescription = 'Active'
							  ORDER BY  DCM.EndDate DESC
							) Active_Memberships
				OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipGUID
							  ,         DM.MembershipID
							  ,         DM.MembershipDescription AS 'Membership'
							  ,			DM.MembershipDescriptionShort
							  ,         DCMS.ClientMembershipStatusDescription AS 'MembershipStatus'
							  ,			DM.MembershipSortOrder
							  ,         DCM.ContractPrice AS 'ContractPrice'
							  ,         DCM.MonthlyFee AS 'MonthlyFee'
							  ,         DCM.BeginDate AS 'MembershipBeginDate'
							  ,         DCM.EndDate AS 'MembershipEndDate'
							  ,			DM.BusinessSegmentID
							  ,			DM.RevenueGroupID
							  ,         DCM.ClientMembershipIdentifier
							  FROM      datClientMembership DCM
										INNER JOIN cfgMembership DM
											ON DM.MembershipID = DCM.MembershipID
										INNER JOIN lkpClientMembershipStatus DCMS
											ON DCMS.ClientMembershipStatusID = DCM.ClientMembershipStatusID
							  WHERE     ( DCM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
										  OR DCM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
										  OR DCM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
										  OR DCM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID )
							  ORDER BY  DCM.EndDate DESC
							) All_Memberships
		WHERE	CLT.ClientIdentifier = @ClientID

RETURN

END
GO
