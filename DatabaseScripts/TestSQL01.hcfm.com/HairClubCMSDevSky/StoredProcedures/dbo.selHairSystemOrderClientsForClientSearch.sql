/* CreateDate: 05/06/2013 18:27:13.597 , ModifyDate: 09/17/2017 18:31:19.813 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				selHairSystemOrderClientsForClientSearch

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		04/25/13

LAST REVISION DATE: 	04/25/13

--------------------------------------------------------------------------------------------------------
NOTES:
	* 07/22/2013	MLM    Added Phone Number the Search
	* 04/27/2017    PRM    Updated to reference new datClientPhone table
	* 09/11/2017	MVT	   Updated to inlclude parameter for BusinessUnitBrandID. Modified proc to search clients within Center Brand. (TFS #9567)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC selHairSystemOrderClientsForClientSearch 201, 'M', 'M', NULL, '347', 0, 0, 0

***********************************************************************/

CREATE PROCEDURE [dbo].[selHairSystemOrderClientsForClientSearch]
	@CenterID INT,
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@ClientIdentifier INT,
	@PhoneNumber nvarchar(15),
	@BusinessUnitBrandID INT,
	@IncludeCancelledStatusMemberships BIT = 0,
	@CanOrderHairSystem BIT,
	@CanTransferHairSystem BIT

AS
BEGIN
	SET NOCOUNT ON;


	SET @FirstName = IIF(LEN(@FirstName) > 0, LTRIM(RTRIM(@FirstName)) + '%',NULL)
	SET @LastName = IIF(LEN(@LastName) > 0, LTRIM(RTRIM(@LastName)) + '%',NULL)
	SET @PhoneNumber = IIF(LEN(@PhoneNumber) > 0, '%' + LTRIM(RTRIM(@PhoneNumber)) + '%',NULL)

	IF ( @IncludeCancelledStatusMemberships = 1 )
		BEGIN
			;WITH CLIENT_CTE AS
			(

						SELECT c.ClientGUID as ClientGUID
							,c.ClientFullNameCalc as ClientFullName
							,bioCM.ClientMembershipGUID as ClientMembershipGUID
							,c.CenterID as CenterID
							,cent.CenterDescriptionFullCalc as CenterDescription
							,cbt.CenterBusinessTypeDescriptionShort
							,c.Address1 as ClientAddress
							,c.City + IIF(s.[StateID] IS NULL, '', ', ' + RTRIM(s.[StateDescriptionShort])) + ' ' + c.[PostalCode] as ClientCityState
							,(SELECT TOP 1 PhoneNumber FROM datClientPhone WHERE ClientGUID = c.ClientGUID ORDER BY ClientPhoneSortOrder) as ClientPrimaryPhone
							,IIF(ISNULL(bioCMStatus.CanSearchAndDisplayFlag,0) = 1,c.CurrentBioMatrixClientMembershipGUID,NULL) as CurrentBioMatrixClientMembershipGUID
							,IIF(ISNULL(bioCMStatus.CanSearchAndDisplayFlag,0) = 1,bioM.MembershipDescription,NULL) as CurrentBioMatrixMembershipDescription
							,IIF(ISNULL(bioCMStatus.CanSearchAndDisplayFlag,0) = 1,bioCMStatus.ClientMembershipStatusDescription,NULL) as CurrentBioMatrixMembershipStatusDescription
							,CAST(NULL as uniqueidentifier) as CurrentExtremeTherapyClientMembershipGUID
							,CAST(NULL as char(36)) as CurrentExtremeTherapyMembershipDescription
							,CAST(NULL as char(36)) as CurrentExtremeTherapyMembershipStatusDescription
							,CAST(NULL as uniqueidentifier) as CurrentSurgeryClientMembershipGUID
							,CAST(NULL as char(36)) as CurrentSurgeryClientMembershipDescription
							,CAST(NULL as char(36)) as CurrentSurgeryClientMembershipStatusDescription
							,c.CreateDate as CreateDate
							,c.CreateUser as CreateUser
							,c.LastUpdate as LastUpdate
							,c.LastUpdateUser as LastUpdateUser
						FROM dbo.datClient c
							INNER JOIN dbo.cfgCenter cent on c.CenterID = cent.CenterID
							INNER JOIN cfgConfigurationCenter config on cent.CenterID = config.CenterID
							INNER JOIN lkpCenterBusinessType cbt on config.CenterBusinessTypeId = cbt.CenterBusinessTypeID
							LEFT OUTER JOIN dbo.lkpState s on c.[StateID] = s.[StateID]
							INNER JOIN dbo.datClientMembership bioCM on c.CurrentBioMatrixClientMembershipGUID = bioCM.ClientMembershipGUID
							INNER JOIN dbo.cfgMembership bioM on bioCM.MembershipID = bioM.MembershipID
							INNER JOIN dbo.cfgConfigurationMembership confMem on bioM.MembershipID = confMem.MembershipID
							LEFT OUTER JOIN dbo.LkpClientMembershipStatus bioCMStatus on bioCM.ClientMembershipStatusID = bioCMStatus.ClientMembershipStatusID
						WHERE (@CenterID IS NULL OR c.CenterID = @CenterID)
							AND cent.BusinessUnitBrandID = @BusinessUnitBrandID
							AND (@ClientIdentifier IS NULL OR c.ClientIdentifier = @ClientIdentifier)
							AND (@FirstName IS NULL OR c.FirstName like @FirstName)
							AND (@LastName IS NULL OR c.LastName like @LastName)
							AND (@PhoneNumber IS NULL OR c.ClientGUID IN (SELECT ClientGUID FROM datClientPhone WHERE PhoneNumber LIKE @PhoneNumber))
							AND (ISNULL(bioCMStatus.CanSearchAndDisplayFlag,0) = 1)
							AND ((ISNULL(@CanOrderHairSystem,0) = confMem.CanOrderHairSystemFlag) OR (ISNULL(@CanTransferHairSystem,0) = confMem.CanTransferHairSystemFlag))

			)
			SELECT cc.ClientGUID
				,cc.ClientFullName
				,cc.ClientAddress
				,cc.ClientCityState
				,cc.ClientPrimaryPhone
				,cc.CenterId
				,cc.CenterDescription
				,cc.CenterBusinessTypeDescriptionShort
				,cc.ClientMembershipGUID
				,m.MembershipID
				,m.MembershipDescription
				,cms.ClientMembershipStatusDescription as MembershipStatusDescription
				,cc.CurrentBioMatrixClientMembershipGUID
				,cc.CurrentExtremeTherapyClientMembershipGUID
				,cc.CurrentSurgeryClientMembershipGUID
				,cc.CurrentBioMatrixMembershipDescription
				,cc.CurrentBioMatrixMembershipStatusDescription
				,cc.CurrentExtremeTherapyMembershipDescription
				,cc.CurrentExtremeTherapyMembershipStatusDescription
				,cc.CurrentSurgeryClientMembershipDescription
				,cc.CurrentSurgeryClientMembershipStatusDescription
				,cc.CreateDate
				,cc.CreateUser
				,cc.LastUpdate
				,cc.LastUpdateUser
			FROM CLIENT_CTE cc
				INNER JOIN datClientMembership cm on cc.ClientMembershipGUID = cm.ClientMembershipGUID
				INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
				INNER JOIN lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
		END
		ELSE
		BEGIN
			;WITH CLIENT_CTE AS
			(

						SELECT c.ClientGUID as ClientGUID
							,c.ClientFullNameCalc as ClientFullName
							,bioCM.ClientMembershipGUID as ClientMembershipGUID
							,c.CenterID as CenterID
							,cent.CenterDescriptionFullCalc as CenterDescription
							,cbt.CenterBusinessTypeDescriptionShort
							,c.Address1 as ClientAddress
							,c.City + IIF(s.[StateID] IS NULL, '', ', ' + RTRIM(s.[StateDescriptionShort])) + ' ' + c.[PostalCode] as ClientCityState
							,(SELECT TOP 1 PhoneNumber FROM datClientPhone WHERE ClientGUID = c.ClientGUID ORDER BY ClientPhoneSortOrder) as ClientPrimaryPhone
							,IIF(ISNULL(bioCMStatus.IsActiveMembershipFlag,0) = 1,c.CurrentBioMatrixClientMembershipGUID,NULL) as CurrentBioMatrixClientMembershipGUID
							,IIF(ISNULL(bioCMStatus.IsActiveMembershipFlag,0) = 1,bioM.MembershipDescription,NULL) as CurrentBioMatrixMembershipDescription
							,IIF(ISNULL(bioCMStatus.IsActiveMembershipFlag,0) = 1,bioCMStatus.ClientMembershipStatusDescription,NULL) as CurrentBioMatrixMembershipStatusDescription
							,CAST(NULL as uniqueidentifier) as CurrentExtremeTherapyClientMembershipGUID
							,CAST(NULL as char(36)) as CurrentExtremeTherapyMembershipDescription
							,CAST(NULL as char(36)) as CurrentExtremeTherapyMembershipStatusDescription
							,CAST(NULL as uniqueidentifier) as CurrentSurgeryClientMembershipGUID
							,CAST(NULL as char(36)) as CurrentSurgeryClientMembershipDescription
							,CAST(NULL as char(36)) as CurrentSurgeryClientMembershipStatusDescription
							,c.CreateDate as CreateDate
							,c.CreateUser as CreateUser
							,c.LastUpdate as LastUpdate
							,c.LastUpdateUser as LastUpdateUser
						FROM dbo.datClient c
							INNER JOIN dbo.cfgCenter cent on c.CenterID = cent.CenterID
							INNER JOIN cfgConfigurationCenter config on cent.CenterID = config.CenterID
							INNER JOIN lkpCenterBusinessType cbt on config.CenterBusinessTypeId = cbt.CenterBusinessTypeID
							LEFT OUTER JOIN dbo.lkpState s on c.[StateID] = s.[StateID]
							INNER JOIN dbo.datClientMembership bioCM on c.CurrentBioMatrixClientMembershipGUID = bioCM.ClientMembershipGUID
							INNER JOIN dbo.cfgMembership bioM on bioCM.MembershipID = bioM.MembershipID
							INNER JOIN dbo.cfgConfigurationMembership confMem on bioM.MembershipID = confMem.MembershipID
							LEFT OUTER JOIN dbo.LkpClientMembershipStatus bioCMStatus on bioCM.ClientMembershipStatusID = bioCMStatus.ClientMembershipStatusID
						WHERE (@CenterID IS NULL OR c.CenterID = @CenterID)
							AND cent.BusinessUnitBrandID = @BusinessUnitBrandID
							AND (@ClientIdentifier IS NULL OR c.ClientIdentifier = @ClientIdentifier)
							AND (@FirstName IS NULL OR c.FirstName like @FirstName)
							AND (@LastName IS NULL OR c.LastName like @LastName)
							AND (@PhoneNumber IS NULL OR c.ClientGUID IN (SELECT ClientGUID FROM datClientPhone WHERE PhoneNumber LIKE @PhoneNumber))
							AND (ISNULL(bioCMStatus.IsActiveMembershipFlag,0) = 1)
							AND ((ISNULL(@CanOrderHairSystem,0) = confMem.CanOrderHairSystemFlag) OR (ISNULL(@CanTransferHairSystem,0) = confMem.CanTransferHairSystemFlag))

			)
			SELECT cc.ClientGUID
				,cc.ClientFullName
				,cc.ClientAddress
				,cc.ClientCityState
				,cc.ClientPrimaryPhone
				,cc.CenterId
				,cc.CenterDescription
				,cc.ClientMembershipGUID
				,cc.CenterBusinessTypeDescriptionShort
				,m.MembershipID
				,m.MembershipDescription
				,cms.ClientMembershipStatusDescription as MembershipStatusDescription
				,cc.CurrentBioMatrixClientMembershipGUID
				,cc.CurrentExtremeTherapyClientMembershipGUID
				,cc.CurrentSurgeryClientMembershipGUID
				,cc.CurrentBioMatrixMembershipDescription
				,cc.CurrentBioMatrixMembershipStatusDescription
				,cc.CurrentExtremeTherapyMembershipDescription
				,cc.CurrentExtremeTherapyMembershipStatusDescription
				,cc.CurrentSurgeryClientMembershipDescription
				,cc.CurrentSurgeryClientMembershipStatusDescription
				,cc.CreateDate
				,cc.CreateUser
				,cc.LastUpdate
				,cc.LastUpdateUser
			FROM CLIENT_CTE cc
				INNER JOIN datClientMembership cm on cc.ClientMembershipGUID = cm.ClientMembershipGUID
				INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
				INNER JOIN lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
		END

END
GO
