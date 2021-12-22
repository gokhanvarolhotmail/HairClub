/***********************************************************************

PROCEDURE:				selClientsForClientSearch

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		04/25/13

LAST REVISION DATE: 	04/25/13

--------------------------------------------------------------------------------------------------------
NOTES:
		* 05/13/2013	MVT	  Modified to include Active Show No Sale clients for surgery.
		* 07/22/2013	MLM   Added Phone Number the Search
		* 01/23/2014	MVT   Modified to take JV centers into account when determining surgery center.
		* 07/25/2014	SAL   Modified to include Phone2 and Phone3 in Phone Number Search
		* 01/13/2014	MVT   Added Xtrands to Client Search
		* 04/27/2017    PRM   Updated to reference new datClientPhone table
		* 09/11/2017	MVT	  Updated to inlclude parameter for BusinessUnitBrandID. Modified proc to search clients within Center Brand. (TFS #9566)
		* 09/11/2018	SAL	  Updated to inlclude parameter for Email. (TFS #11312)
		* 05/20/2019	JLM	  Added MDP to client search (TFS #12378)
		* 13/05/2020    AAM   Client search when IsHWIntegrationEnabled

--------------------------------------------------------------------------------------------------------
select * from lkpBusinessUnitBrand
SAMPLE EXECUTION:

EXEC selClientsForClientSearch null, 'alexandra', 'acevedo', NULL,'',2,0, 0,NULL;

SET STATISTICS IO ON;
EXEC #selClientsForClientSearchTest 745, N'v', N'sau', NULL,NULL, 1, 1;
SET STATISTICS IO OFF;

***********************************************************************/

CREATE PROCEDURE [dbo].[selClientsForClientSearch]
	@CenterID INT,
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@ClientIdentifier INT,
	@PhoneNumber nvarchar(15),
	@BusinessUnitBrandID INT,
	@IncludeCancelledStatusMemberships BIT = 0,
	@IncludeSurgeryClients BIT = 0,
	@EmailAddress nvarchar(100)

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ClientMembershipStatus_SurgeryPerformed nvarchar(10)
			,@ClientMembershipStatus_Canceled nvarchar(10)
			,@ClientMembershipStatus_Active nvarchar(10)
			,@MembershipShowNoSale nvarchar(10)

	SET @ClientMembershipStatus_SurgeryPerformed = 'SP'
	SET @ClientMembershipStatus_Canceled = 'C'
	SET @ClientMembershipStatus_Active = 'A'
	SET @MembershipShowNoSale = 'SHOWNOSALE'

	DECLARE @ConectCorpCenterBusinessType nvarchar(10) = 'cONEctCorp'
	DECLARE @ConectJVCenterBusinessType nvarchar(10) = 'cONEctJV'

	DECLARE @BusinessUnitBrandDescriptionShortHW nvarchar(2) = 'HW'

	DECLARE @SurgeryCenterID INT = NULL
	DECLARE @CenterBusinessType nvarchar(10)

	SELECT	@CenterBusinessType = bt.CenterBusinessTypeDescriptionShort
					FROM cfgCenter c
						INNER JOIN cfgConfigurationCenter config ON c.CenterId = config.CenterId
						INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeId = config.CenterBusinessTypeId
					WHERE c.CenterId = @CenterId

	IF @IncludeSurgeryClients = 1 AND @CenterBusinessType = @ConectCorpCenterBusinessType
		SET @SurgeryCenterID =  @CENTERID + 100
	ELSE IF @IncludeSurgeryClients = 1 AND @CenterBusinessType = @ConectJVCenterBusinessType
		SET @SurgeryCenterID =  @CENTERID - 200


	SET @FirstName = IIF(LEN(@FirstName) > 0, LTRIM(RTRIM(@FirstName)) + '%',NULL)
	SET @LastName = IIF(LEN(@LastName) > 0, LTRIM(RTRIM(@LastName)) + '%',NULL)
	SET @PhoneNumber = IIF(LEN(@PhoneNumber) > 0, '%' + LTRIM(RTRIM(@PhoneNumber)) + '%',NULL)
	SET @EmailAddress = IIF(LEN(@EmailAddress) > 0, LTRIM(RTRIM(@EmailAddress)) + '%',NULL)

	IF ( @IncludeCancelledStatusMemberships = 1 )
		BEGIN
			;WITH CLIENT_CTE AS
			(

						SELECT DISTINCT c.ClientGUID as ClientGUID
							,c.ClientFullNameCalc as ClientFullName
							,CASE WHEN bioCM.ClientMembershipGUID IS NOT NULL AND ISNULL(bioCMStatus.IsActiveMembershipFlag,0) = 1 THEN bioCM.ClientMembershipGUID
								  WHEN extCM.ClientMembershipGUID IS NOT NULL AND ISNULL(extCMStatus.IsActiveMembershipFlag,0) = 1 THEN extCM.ClientMembershipGUID
								  WHEN surCM.ClientMembershipGUID IS NOT NULL AND ISNULL(surCMStatus.IsActiveMembershipFlag,0) = 1 THEN surCM.ClientMembershipGUID
								  WHEN xtrCM.ClientMembershipGUID IS NOT NULL AND ISNULL(xtrCMStatus.IsActiveMembershipFlag,0) = 1 THEN xtrCM.ClientMembershipGUID
								  WHEN mdpCM.ClientMembershipGUID IS NOT NULL AND ISNULL(mdpCMStatus.IsActiveMembershipFlag,0) = 1 THEN mdpCM.ClientMembershipGUID
								  ELSE COALESCE(bioCM.ClientMembershipGUID, extCM.ClientMembershipGUID ,surCM.ClientMembershipGUID,xtrCM.ClientMembershipGUID,mdpCM.ClientMembershipGUID)
							 END as ClientMembershipGUID
							,c.CenterID as CenterID
							,cent.CenterDescriptionFullCalc as CenterDescription
							,cbt.CenterBusinessTypeDescriptionShort
							,c.Address1 as ClientAddress
							,c.City + IIF(s.[StateID] IS NULL, '', ', ' + RTRIM(s.[StateDescriptionShort])) + ' ' + c.[PostalCode] as ClientCityState
							,(SELECT TOP 1 PhoneNumber FROM datClientPhone WHERE ClientGUID = c.ClientGUID ORDER BY ClientPhoneSortOrder) as ClientPrimaryPhone
							,IIF(ISNULL(bioCMStatus.CanSearchAndDisplayFlag,0) = 1,c.CurrentBioMatrixClientMembershipGUID,NULL) as CurrentBioMatrixClientMembershipGUID
							,IIF(ISNULL(bioCMStatus.CanSearchAndDisplayFlag,0) = 1,bioM.MembershipDescription,NULL) as CurrentBioMatrixMembershipDescription
							,IIF(ISNULL(bioCMStatus.CanSearchAndDisplayFlag,0) = 1,bioCMStatus.ClientMembershipStatusDescription,NULL) as CurrentBioMatrixMembershipStatusDescription
							,IIF(ISNULL(extCMStatus.CanSearchAndDisplayFlag,0) = 1,c.CurrentExtremeTherapyClientMembershipGUID,NULL) as CurrentExtremeTherapyClientMembershipGUID
							,IIF(ISNULL(extCMStatus.CanSearchAndDisplayFlag,0) = 1,extM.MembershipDescription,NULL) as CurrentExtremeTherapyMembershipDescription
							,IIF(ISNULL(extCMStatus.CanSearchAndDisplayFlag,0) = 1,extCMStatus.ClientMembershipStatusDescription,NULL) as CurrentExtremeTherapyMembershipStatusDescription
							,IIF(ISNULL(surCMStatus.CanSearchAndDisplayFlag,0) = 1,c.CurrentSurgeryClientMembershipGUID,NULL) as CurrentSurgeryClientMembershipGUID
							,IIF(ISNULL(surCMStatus.CanSearchAndDisplayFlag,0) = 1,surM.MembershipDescription,NULL) as CurrentSurgeryClientMembershipDescription
							,IIF(ISNULL(surCMStatus.CanSearchAndDisplayFlag,0) = 1,surCMStatus.ClientMembershipStatusDescription,NULL) as CurrentSurgeryClientMembershipStatusDescription
							,IIF(ISNULL(xtrCMStatus.CanSearchAndDisplayFlag,0) = 1,c.CurrentXtrandsClientMembershipGUID,NULL) as CurrentXtrandsClientMembershipGUID
							,IIF(ISNULL(xtrCMStatus.CanSearchAndDisplayFlag,0) = 1,xtrM.MembershipDescription,NULL) as CurrentXtrandsClientMembershipDescription
							,IIF(ISNULL(xtrCMStatus.CanSearchAndDisplayFlag,0) = 1,xtrCMStatus.ClientMembershipStatusDescription,NULL) as CurrentXtrandsClientMembershipStatusDescription
							,IIF(ISNULL(mdpCMStatus.CanSearchAndDisplayFlag,0) = 1,c.CurrentMDPClientMembershipGUID,NULL) as CurrentMDPClientMembershipGUID
							,IIF(ISNULL(mdpCMStatus.CanSearchAndDisplayFlag,0) = 1,mdpM.MembershipDescription,NULL) as CurrentMDPClientMembershipDescription
							,IIF(ISNULL(mdpCMStatus.CanSearchAndDisplayFlag,0) = 1,mdpCMStatus.ClientMembershipStatusDescription,NULL) as CurrentMDPClientMembershipStatusDescription
							,c.CreateDate as CreateDate
							,c.CreateUser as CreateUser
							,c.LastUpdate as LastUpdate
							,c.LastUpdateUser as LastUpdateUser
						FROM dbo.datClient c
							INNER JOIN dbo.cfgCenter cent on c.CenterID = cent.CenterID
							INNER JOIN cfgConfigurationCenter config on cent.CenterID = config.CenterID
							INNER JOIN lkpCenterBusinessType cbt on config.CenterBusinessTypeId = cbt.CenterBusinessTypeID
							LEFT JOIN dbo.lkpState s on c.[StateID] = s.[StateID]
							LEFT JOIN dbo.datClientMembership bioCM on c.CurrentBioMatrixClientMembershipGUID = bioCM.ClientMembershipGUID
							LEFT JOIN dbo.datClientPhone cp ON c.ClientGUID = cp.ClientGUID
							LEFT JOIN dbo.cfgMembership bioM on bioCM.MembershipID = bioM.MembershipID
							LEFT JOIN dbo.LkpClientMembershipStatus bioCMStatus on bioCM.ClientMembershipStatusID = bioCMStatus.ClientMembershipStatusID
							LEFT JOIN dbo.datClientMembership extCM on c.CurrentExtremeTherapyClientMembershipGUID = extCM.ClientMembershipGUID
							LEFT JOIN dbo.cfgMembership extM on extCM.MembershipID = extM.MembershipID
							LEFT JOIN dbo.LkpClientMembershipStatus extCMStatus on extCM.ClientMembershipStatusID = extCMStatus.ClientMembershipStatusID
							LEFT JOIN dbo.datClientMembership surCM on c.CurrentSurgeryClientMembershipGUID = surCM.ClientMembershipGUID
							LEFT JOIN dbo.cfgMembership surM on surCM.MembershipID = surM.MembershipID
							LEFT JOIN dbo.LkpClientMembershipStatus surCMStatus on surCM.ClientMembershipStatusID = surCMStatus.ClientMembershipStatusID
							LEFT JOIN dbo.datClientMembership xtrCM on c.CurrentXtrandsClientMembershipGUID = xtrCM.ClientMembershipGUID
							LEFT JOIN dbo.cfgMembership xtrM on xtrCM.MembershipID = xtrM.MembershipID
							LEFT JOIN dbo.LkpClientMembershipStatus xtrCMStatus on xtrCM.ClientMembershipStatusID = xtrCMStatus.ClientMembershipStatusID
							LEFT JOIN dbo.datClientMembership mdpCM on c.CurrentMDPClientMembershipGUID = mdpCM.ClientMembershipGUID
							LEFT JOIN dbo.cfgMembership mdpM on mdpCM.MembershipID = mdpM.MembershipID
							LEFT JOIN dbo.lkpClientMembershipStatus mdpCMStatus on mdpCM.ClientMembershipStatusID = mdpCMStatus.ClientMembershipStatusID
						WHERE ((@CenterID IS NULL OR c.CenterID = @CenterID)
									OR (c.CenterID = @SurgeryCenterID AND (surCMStatus.ClientMembershipStatusDescriptionShort = @ClientMembershipStatus_SurgeryPerformed
																		OR surCMStatus.ClientMembershipStatusDescriptionShort = @ClientMembershipStatus_Canceled
																		OR (surM.MembershipDescriptionShort = @MembershipShowNoSale
																				AND surCMStatus.ClientMembershipStatusDescriptionShort = @ClientMembershipStatus_Active))))
							AND ((cbt.CenterBusinessTypeDescriptionShort  <> @BusinessUnitBrandDescriptionShortHW  and (cent.BusinessUnitBrandID = @BusinessUnitBrandID or config.IsHWIntegrationEnabled = 1)) or (cbt.CenterBusinessTypeDescriptionShort = @BusinessUnitBrandDescriptionShortHW  and (cent.BusinessUnitBrandID = @BusinessUnitBrandID)))
							--AND cent.BusinessUnitBrandID = @BusinessUnitBrandID
							AND (@ClientIdentifier IS NULL OR c.ClientIdentifier = @ClientIdentifier)
							AND (@FirstName IS NULL OR c.FirstName like @FirstName)
							AND (@LastName IS NULL OR c.LastName like @LastName)
							--AND (@PhoneNumber IS NULL OR c.ClientGUID IN (SELECT ClientGUID FROM datClientPhone WHERE PhoneNumber LIKE @PhoneNumber))
							AND (@PhoneNumber IS NULL OR cp.PhoneNumber LIKE @PhoneNumber)
							AND (@EmailAddress IS NULL OR c.EmailAddress like @EmailAddress)
							AND (ISNULL(bioCMStatus.CanSearchAndDisplayFlag,0) = 1 OR ISNULL(extCMStatus.CanSearchAndDisplayFlag,0) = 1
									OR ISNULL(surCMStatus.CanSearchAndDisplayFlag,0) = 1 OR  ISNULL(xtrCMStatus.CanSearchAndDisplayFlag,0) = 1
									OR ISNULL(mdpCMStatus.CanSearchAndDisplayFlag,0) = 1)

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
				,cc.CurrentXtrandsClientMembershipGUID
				,cc.CurrentMDPClientMembershipGUID
				,cc.CurrentBioMatrixMembershipDescription
				,cc.CurrentBioMatrixMembershipStatusDescription
				,cc.CurrentExtremeTherapyMembershipDescription
				,cc.CurrentExtremeTherapyMembershipStatusDescription
				,cc.CurrentSurgeryClientMembershipDescription
				,cc.CurrentSurgeryClientMembershipStatusDescription
				,cc.CurrentXtrandsClientMembershipDescription
				,cc.CurrentXtrandsClientMembershipStatusDescription
				,cc.CurrentMDPClientMembershipDescription
				,cc.CurrentMDPClientMembershipStatusDescription
				,cc.CreateDate
				,cc.CreateUser
				,cc.LastUpdate
				,cc.LastUpdateUser
			FROM CLIENT_CTE cc
				INNER JOIN datClientMembership cm on cc.ClientMembershipGUID = cm.ClientMembershipGUID
				INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
				INNER JOIN lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
			OPTION (RECOMPILE)
		END
		ELSE
		BEGIN
			;WITH CLIENT_CTE AS
			(

						SELECT DISTINCT c.ClientGUID as ClientGUID
							,c.ClientFullNameCalc as ClientFullName
							,CASE WHEN bioCM.ClientMembershipGUID IS NOT NULL AND ISNULL(bioCMStatus.IsActiveMembershipFlag,0) = 1 THEN bioCM.ClientMembershipGUID
								  WHEN extCM.ClientMembershipGUID IS NOT NULL AND ISNULL(extCMStatus.IsActiveMembershipFlag,0) = 1 THEN extCM.ClientMembershipGUID
								  WHEN surCM.ClientMembershipGUID IS NOT NULL AND ISNULL(surCMStatus.IsActiveMembershipFlag,0) = 1 THEN surCM.ClientMembershipGUID
								  WHEN xtrCM.ClientMembershipGUID IS NOT NULL AND ISNULL(xtrCMStatus.IsActiveMembershipFlag,0) = 1 THEN xtrCM.ClientMembershipGUID
								  WHEN mdpCM.ClientMembershipGUID IS NOT NULL AND ISNULL(mdpCMStatus.IsActiveMembershipFlag,0) = 1 THEN mdpCM.ClientMembershipGUID
								  ELSE COALESCE(bioCM.ClientMembershipGUID, extCM.ClientMembershipGUID, surCM.ClientMembershipGUID, xtrCM.ClientMembershipGUID, mdpCM.ClientMembershipGUID)
							 END as ClientMembershipGUID
							,c.CenterID as CenterID
							,cent.CenterDescriptionFullCalc as CenterDescription
							,cbt.CenterBusinessTypeDescriptionShort
							,c.Address1 as ClientAddress
							,c.City + IIF(s.[StateID] IS NULL, '', ', ' + RTRIM(s.[StateDescriptionShort])) + ' ' + c.[PostalCode] as ClientCityState
							,(SELECT TOP 1 PhoneNumber FROM datClientPhone WHERE ClientGUID = c.ClientGUID ORDER BY ClientPhoneSortOrder) as ClientPrimaryPhone
							,IIF(ISNULL(bioCMStatus.IsActiveMembershipFlag,0) = 1,c.CurrentBioMatrixClientMembershipGUID,NULL) as CurrentBioMatrixClientMembershipGUID
							,IIF(ISNULL(bioCMStatus.IsActiveMembershipFlag,0) = 1,bioM.MembershipDescription,NULL) as CurrentBioMatrixMembershipDescription
							,IIF(ISNULL(bioCMStatus.IsActiveMembershipFlag,0) = 1,bioCMStatus.ClientMembershipStatusDescription,NULL) as CurrentBioMatrixMembershipStatusDescription
							,IIF(ISNULL(extCMStatus.IsActiveMembershipFlag,0) = 1,c.CurrentExtremeTherapyClientMembershipGUID,NULL) as CurrentExtremeTherapyClientMembershipGUID
							,IIF(ISNULL(extCMStatus.IsActiveMembershipFlag,0) = 1,extM.MembershipDescription,NULL) as CurrentExtremeTherapyMembershipDescription
							,IIF(ISNULL(extCMStatus.IsActiveMembershipFlag,0) = 1,extCMStatus.ClientMembershipStatusDescription,NULL) as CurrentExtremeTherapyMembershipStatusDescription
							,IIF(ISNULL(surCMStatus.IsActiveMembershipFlag,0) = 1,c.CurrentSurgeryClientMembershipGUID,NULL) as CurrentSurgeryClientMembershipGUID
							,IIF(ISNULL(surCMStatus.IsActiveMembershipFlag,0) = 1,surM.MembershipDescription,NULL) as CurrentSurgeryClientMembershipDescription
							,IIF(ISNULL(surCMStatus.IsActiveMembershipFlag,0) = 1,surCMStatus.ClientMembershipStatusDescription,NULL) as CurrentSurgeryClientMembershipStatusDescription
							,IIF(ISNULL(xtrCMStatus.CanSearchAndDisplayFlag,0) = 1,c.CurrentXtrandsClientMembershipGUID,NULL) as CurrentXtrandsClientMembershipGUID
							,IIF(ISNULL(xtrCMStatus.CanSearchAndDisplayFlag,0) = 1,xtrM.MembershipDescription,NULL) as CurrentXtrandsClientMembershipDescription
							,IIF(ISNULL(xtrCMStatus.CanSearchAndDisplayFlag,0) = 1,xtrCMStatus.ClientMembershipStatusDescription,NULL) as CurrentXtrandsClientMembershipStatusDescription
							,IIF(ISNULL(mdpCMStatus.IsActiveMembershipFlag,0) = 1,c.CurrentMDPClientMembershipGUID,NULL) as CurrentMDPClientMembershipGUID
							,IIF(ISNULL(mdpCMStatus.IsActiveMembershipFlag,0) = 1,mdpM.MembershipDescription,NULL) as CurrentMDPClientMembershipDescription
							,IIF(ISNULL(mdpCMStatus.IsActiveMembershipFlag,0) = 1,mdpCMStatus.ClientMembershipStatusDescription,NULL) as CurrentMDPClientMembershipStatusDescription
							,c.CreateDate as CreateDate
							,c.CreateUser as CreateUser
							,c.LastUpdate as LastUpdate
							,c.LastUpdateUser as LastUpdateUser
							,config.IsHWIntegrationEnabled
						FROM dbo.datClient c
							INNER JOIN dbo.cfgCenter cent on c.CenterID = cent.CenterID
							INNER JOIN cfgConfigurationCenter config on cent.CenterID = config.CenterID
							INNER JOIN lkpCenterBusinessType cbt on config.CenterBusinessTypeId = cbt.CenterBusinessTypeID
							LEFT JOIN dbo.lkpState s on c.[StateID] = s.[StateID]
							LEFT JOIN dbo.datClientMembership bioCM on c.CurrentBioMatrixClientMembershipGUID = bioCM.ClientMembershipGUID
							LEFT JOIN dbo.cfgMembership bioM on bioCM.MembershipID = bioM.MembershipID
							LEFT JOIN dbo.LkpClientMembershipStatus bioCMStatus on bioCM.ClientMembershipStatusID = bioCMStatus.ClientMembershipStatusID
							LEFT JOIN dbo.datClientMembership extCM on c.CurrentExtremeTherapyClientMembershipGUID = extCM.ClientMembershipGUID
							LEFT JOIN dbo.datClientPhone cp ON c.ClientGUID = cp.ClientGUID
							LEFT JOIN dbo.cfgMembership extM on extCM.MembershipID = extM.MembershipID
							LEFT JOIN dbo.LkpClientMembershipStatus extCMStatus on extCM.ClientMembershipStatusID = extCMStatus.ClientMembershipStatusID
							LEFT JOIN dbo.datClientMembership surCM on c.CurrentSurgeryClientMembershipGUID = surCM.ClientMembershipGUID
							LEFT JOIN dbo.cfgMembership surM on surCM.MembershipID = surM.MembershipID
							LEFT JOIN dbo.LkpClientMembershipStatus surCMStatus on surCM.ClientMembershipStatusID = surCMStatus.ClientMembershipStatusID
							LEFT JOIN dbo.datClientMembership xtrCM on c.CurrentXtrandsClientMembershipGUID = xtrCM.ClientMembershipGUID
							LEFT JOIN dbo.cfgMembership xtrM on xtrCM.MembershipID = xtrM.MembershipID
							LEFT JOIN dbo.LkpClientMembershipStatus xtrCMStatus on xtrCM.ClientMembershipStatusID = xtrCMStatus.ClientMembershipStatusID
							LEFT JOIN dbo.datClientMembership mdpCM on c.CurrentMDPClientMembershipGUID = mdpCM.ClientMembershipGUID
							LEFT JOIN dbo.cfgMembership mdpM on mdpCM.MembershipID = mdpM.MembershipID
							LEFT JOIN dbo.lkpClientMembershipStatus mdpCMStatus on mdpCM.ClientMembershipStatusID = mdpCMStatus.ClientMembershipStatusID
						WHERE ((@CenterID IS NULL OR c.CenterID = @CenterID)
									OR (c.CenterID = @SurgeryCenterID AND (surCMStatus.ClientMembershipStatusDescriptionShort = @ClientMembershipStatus_SurgeryPerformed
																		OR surCMStatus.ClientMembershipStatusDescriptionShort = @ClientMembershipStatus_Canceled
																		OR (surM.MembershipDescriptionShort = @MembershipShowNoSale
																				AND surCMStatus.ClientMembershipStatusDescriptionShort = @ClientMembershipStatus_Active))))
							AND ((cbt.CenterBusinessTypeDescriptionShort  <> @BusinessUnitBrandDescriptionShortHW  and (cent.BusinessUnitBrandID = @BusinessUnitBrandID or config.IsHWIntegrationEnabled = 1)) or (cbt.CenterBusinessTypeDescriptionShort = @BusinessUnitBrandDescriptionShortHW  and (cent.BusinessUnitBrandID = @BusinessUnitBrandID)))
							--AND cent.BusinessUnitBrandID = @BusinessUnitBrandID
							AND (@ClientIdentifier IS NULL OR c.ClientIdentifier = @ClientIdentifier)
							AND (@FirstName IS NULL OR c.FirstName like @FirstName)
							AND (@LastName IS NULL OR c.LastName like @LastName)
							--AND (@PhoneNumber IS NULL OR c.ClientGUID IN (SELECT ClientGUID FROM datClientPhone WHERE PhoneNumber LIKE @PhoneNumber))
							AND (@PhoneNumber IS NULL OR cp.PhoneNumber LIKE @PhoneNumber)
							AND (@EmailAddress IS NULL OR c.EmailAddress like @EmailAddress)
							AND (ISNULL(bioCMStatus.IsActiveMembershipFlag,0) = 1 OR ISNULL(extCMStatus.IsActiveMembershipFlag,0) = 1
								OR ISNULL(surCMStatus.IsActiveMembershipFlag,0) = 1 OR ISNULL(xtrCMStatus.IsActiveMembershipFlag,0) = 1
								OR ISNULL(mdpCMStatus.IsActiveMembershipFlag,0) = 1)

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
				,cc.CurrentXtrandsClientMembershipGUID
				,cc.CurrentMDPClientMembershipGUID
				,cc.CurrentBioMatrixMembershipDescription
				,cc.CurrentBioMatrixMembershipStatusDescription
				,cc.CurrentExtremeTherapyMembershipDescription
				,cc.CurrentExtremeTherapyMembershipStatusDescription
				,cc.CurrentSurgeryClientMembershipDescription
				,cc.CurrentSurgeryClientMembershipStatusDescription
				,cc.CurrentXtrandsClientMembershipDescription
				,cc.CurrentXtrandsClientMembershipStatusDescription
				,cc.CurrentMDPClientMembershipDescription
				,cc.CurrentMDPClientMembershipStatusDescription
				,cc.CreateDate
				,cc.CreateUser
				,cc.LastUpdate
				,cc.LastUpdateUser
				,cc.IsHWIntegrationEnabled
			FROM CLIENT_CTE cc
				INNER JOIN datClientMembership cm on cc.ClientMembershipGUID = cm.ClientMembershipGUID
				INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
				INNER JOIN lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
			OPTION (RECOMPILE)
		END

END
