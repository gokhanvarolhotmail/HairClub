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
------------------------------------------------------------------------
USAGE:
------------------------------------------------------------------------

SELECT * FROM dbo.fnGetCurrentMembershipDetailsByCenterID(289)
***********************************************************************/
CREATE FUNCTION [dbo].[fnGetCurrentMembershipDetailsByCenterID]
(
	@CenterID INT
)
RETURNS @CurrentMembershipDetails TABLE
(
	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	ClientGUID UNIQUEIDENTIFIER
,	ClientIdentifier INT
,	CMSClientIdentifier INT
,	ClientName VARCHAR(104)
,	GenderID INT
,	SiebelID VARCHAR(50)
,	ClientMembershipGUID UNIQUEIDENTIFIER
,	MembershipSSID INT
,	MembershipDescription VARCHAR(50)
,	MembershipDescriptionShort VARCHAR(10)
,	MembershipStatus VARCHAR(50)
,	MembershipSortOrder INT
,	ContractPrice MONEY
,	ContractPaidAmount MONEY
,	MonthlyFee MONEY
,	MembershipBeginDate DATETIME
,	MembershipEndDate DATETIME
,	BusinessSegmentID INT
,	RevenueGroupID INT
,	ClientMembershipIdentifier VARCHAR(50)
)
AS
BEGIN

INSERT  INTO @CurrentMembershipDetails
		SELECT  CTR.CenterID
		,		CTR.CenterDescriptionFullCalc AS 'CenterDescription'
		,		CLT.ClientGUID
		,       CLT.ClientIdentifier
		,       CLT.ClientNumber_Temp AS 'CMSClientIdentifier'
		,       CLT.ClientFullNameCalc AS 'ClientName'
		,		CLT.GenderID
		,		ISNULL(CLT.SiebelID, '') AS 'SiebelID'
		,       ISNULL(Active_Memberships.ClientMembershipGUID, All_Memberships.ClientMembershipGUID) AS 'ClientMembershipSSID'
		,       ISNULL(Active_Memberships.MembershipID, All_Memberships.MembershipID) AS 'MembershipID'
		,       ISNULL(Active_Memberships.MembershipDescription, All_Memberships.MembershipDescription) AS 'MembershipDescription'
		,       ISNULL(Active_Memberships.MembershipDescriptionShort, All_Memberships.MembershipDescriptionShort) AS 'MembershipDescriptionShort'
		,       ISNULL(Active_Memberships.MembershipStatus, All_Memberships.MembershipStatus) AS 'MembershipStatus'
		,       ISNULL(Active_Memberships.MembershipSortOrder, All_Memberships.MembershipSortOrder) AS 'MembershipSortOrder'
		,       ISNULL(Active_Memberships.ContractPrice, All_Memberships.ContractPrice) AS 'ContractPrice'
		,       ISNULL(Active_Memberships.ContractPaidAmount, All_Memberships.ContractPaidAmount) AS 'ContractPaidAmount'
		,       ISNULL(Active_Memberships.MonthlyFee, All_Memberships.MonthlyFee) AS 'MonthlyFee'
		,       ISNULL(Active_Memberships.MembershipBeginDate, All_Memberships.MembershipBeginDate) AS 'MembershipBeginDate'
		,       ISNULL(Active_Memberships.MembershipEndDate, All_Memberships.MembershipEndDate) AS 'MembershipEndDate'
		,       ISNULL(Active_Memberships.BusinessSegmentID, All_Memberships.BusinessSegmentID) AS 'BusinessSegmentID'
		,       ISNULL(Active_Memberships.RevenueGroupID, All_Memberships.RevenueGroupID) AS 'RevenueGroupID'
		,       ISNULL(Active_Memberships.ClientMembershipIdentifier, All_Memberships.ClientMembershipIdentifier) AS 'ClientMembershipIdentifier'
		FROM    datClient CLT
				INNER JOIN cfgCenter CTR
					ON CTR.CenterID = CLT.CenterID
				OUTER APPLY ( SELECT TOP 1
										CM.ClientMembershipGUID
							  ,         M.MembershipID
							  ,         M.MembershipDescription AS 'MembershipDescription'
							  ,			M.MembershipDescriptionShort
							  ,         STAT.ClientMembershipStatusDescription AS 'MembershipStatus'
							  ,			M.MembershipSortOrder
							  ,         CM.ContractPrice AS 'ContractPrice'
							  ,			CM.ContractPaidAmount AS 'ContractPaidAmount'
							  ,         CM.MonthlyFee AS 'MonthlyFee'
							  ,         CM.BeginDate AS 'MembershipBeginDate'
							  ,         CM.EndDate AS 'MembershipEndDate'
							  ,			M.BusinessSegmentID
							  ,			M.RevenueGroupID
							  ,         CM.ClientMembershipIdentifier
							  FROM      datClientMembership CM
										INNER JOIN cfgMembership M
											ON M.MembershipID= CM.MembershipID
										INNER JOIN dbo.lkpClientMembershipStatus STAT
											ON CM.ClientMembershipStatusID = STAT.ClientMembershipStatusID
							  WHERE     ( CM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
										  OR CM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
										  OR CM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
										  OR CM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID )
										AND STAT.ClientMembershipStatusDescription = 'Active'
							  ORDER BY  CM.EndDate DESC
							) Active_Memberships
				OUTER APPLY ( SELECT TOP 1
										CM.ClientMembershipGUID
							  ,         M.MembershipID
							  ,         M.MembershipDescription AS 'MembershipDescription'
							  ,			M.MembershipDescriptionShort
							  ,         STAT.ClientMembershipStatusDescription AS 'MembershipStatus'
							  ,			M.MembershipSortOrder
							  ,         CM.ContractPrice AS 'ContractPrice'
							  ,			CM.ContractPaidAmount AS 'ContractPaidAmount'
							  ,         CM.MonthlyFee AS 'MonthlyFee'
							  ,         CM.BeginDate AS 'MembershipBeginDate'
							  ,         CM.EndDate AS 'MembershipEndDate'
							  ,			M.BusinessSegmentID
							  ,			M.RevenueGroupID
							  ,         CM.ClientMembershipIdentifier
							  FROM      datClientMembership CM
										INNER JOIN cfgMembership M
											ON M.MembershipID = CM.MembershipID
										INNER JOIN dbo.lkpClientMembershipStatus STAT
											ON CM.ClientMembershipStatusID = STAT.ClientMembershipStatusID
							  WHERE     ( CM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
										  OR CM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
										  OR CM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
										  OR CM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID )
							  ORDER BY  CM.EndDate DESC
							) All_Memberships
		WHERE   CLT.CenterID = @CenterID

RETURN

END
