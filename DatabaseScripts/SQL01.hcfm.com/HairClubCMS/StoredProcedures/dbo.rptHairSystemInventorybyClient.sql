/*===============================================================================================
-- Procedure Name:			rptHairSystemInventorybyClient
-- Procedure Description:
--
-- Created By:				HDu
-- Implemented By:			HDu
-- Last Modified By:		HDu
--
-- Date Created:			10/26/2011
-- Date Implemented:		10/26/2011
-- Date Last Modified:		10/26/2011
--
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS

Sample Execution:
EXEC rptHairSystemInventorybyClient '201','28,30'
--------------------------------------------------------------------------------------------------------
NOTES: 	Returns hair systems in a center with the client and that client's CURRENT Membership

		* 10/26/2011 - HDu - 5902 Created new report stored proc
--------------------------------------------------------------------------------------------------------
================================================================================================*/
CREATE PROCEDURE [dbo].[rptHairSystemInventorybyClient]
(
	@CenterID INT,
	@MembershipID VARCHAR(MAX) = ''
)
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @APPLIEDHairSystemOrderStatusID INT,
		@ORDEREDHairSystemOrderStatusID INT
	SELECT @APPLIEDHairSystemOrderStatusID = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'APPLIED'
	SELECT @ORDEREDHairSystemOrderStatusID = HairSystemOrderStatusID FROM lkpHairSystemOrderStatus WHERE HairSystemOrderStatusDescriptionShort = 'ORDER'

SELECT
--GROUP
Region.RegionDescription AS 'Region' --by hso
,Center.CenterDescriptionFullCalc AS 'Center' --by hso
--CLIENT
,clients.ClientFullNameCalc AS 'Client'
,clients.MembershipDescription AS 'Membership'
,LastAppl.HairSystemOrderTransactionDate AS 'LastApplicationDate'
--HAIRSYSTEM
,CASE WHEN hair.HairSystemOrderStatusDescriptionShort IN ('CENT') THEN 1 ELSE 0 END AS 'InCenter'
,CASE WHEN hair.HairSystemOrderStatusDescriptionShort IN ('NEW','ORDER','HQ-Recv','HQ-Ship','FAC-Ship') THEN 1	ELSE 0 END AS 'OnOrder'
,hair.HairSystemOrderNumber AS 'HairOrderNumber'
,hair.HairSystemDescriptionShort AS 'SystemType'
,hair.HairSystemOrderStatusDescriptionShort AS 'Status'
,hair.DueDate AS 'DueDate'
,CASE WHEN hair.HairSystemOrderGUID IS NULL THEN 1 ELSE 0 END AS 'NoSystems'
,CASE WHEN clients.CenterID = hair.CenterID THEN 1 ELSE 0 END AS 'HSOInClientCenter'

FROM (
	SELECT
		hhh.ClientGUID
		, CASE WHEN hhh.HairSystemOrderStatusID = @ORDEREDHairSystemOrderStatusID THEN hhh.ClientHomeCenterID ELSE hhh.CenterID END AS 'CenterID'
		, hhh.HairSystemOrderGUID
		, hhh.HairSystemOrderNumber
		, hhh.DueDate
		, HSOS.HairSystemOrderStatusDescriptionShort
		, hs.HairSystemDescriptionShort
	FROM dbo.datHairSystemOrder hhh
	LEFT JOIN dbo.cfgHairSystem HS ON HS.HairSystemID = hhh.HairSystemID
	INNER JOIN dbo.lkpHairSystemOrderStatus HSOS ON HSOS.HairSystemOrderStatusID = hhh.HairSystemOrderStatusID
		AND HSOS.HairSystemOrderStatusDescriptionShort IN ('CENT','NEW','ORDER','HQ-Recv','HQ-Ship','FAC-Ship')
	LEFT JOIN dbo.datClient Client ON Client.ClientGUID = hhh.ClientGUID
	WHERE
	-- ORDER status are in corp/factory so use the ClientHomeCenter for ORDER status only
		(hhh.CenterID = @CenterID AND hhh.hairsystemorderstatusID <> @ORDEREDHairSystemOrderStatusID)
	OR	(hhh.ClientHomeCenterID = @CenterID AND hhh.HairSystemOrderStatusID = @ORDEREDHairSystemOrderStatusID)
) hair

FULL JOIN (
	SELECT Client.*, M.MembershipDescription, M.MembershipDescriptionShort
	FROM dbo.datClient Client
	--INNER JOIN dbo.datClientMembership CM ON CM.ClientGUID = Client.ClientGUID AND CM.IsActiveFlag = 1
	INNER JOIN (
		SELECT ClientGUID, MembershipID, ROW_NUMBER() OVER(PARTITION BY ClientGUID ORDER BY IsActiveFlag DESC, BeginDate DESC) AS CMRANKING
		FROM dbo.datClientMembership
	) CM ON CM.ClientGUID = Client.ClientGUID AND CMRANKING = 1
	INNER JOIN cfgMembership M ON M.MembershipID = CM.MembershipID
	WHERE Client.CenterID = @CenterID
		OR Client.ClientGUID IN (
				SELECT ClientGUID
				FROM datHairSystemOrder
				WHERE (CenterID = @CenterID AND hairsystemorderstatusID <> @ORDEREDHairSystemOrderStatusID)
				OR (ClientHomeCenterID = @CenterID AND HairSystemOrderStatusID = @ORDEREDHairSystemOrderStatusID)
		)
) clients ON clients.ClientGUID = hair.ClientGUID
	LEFT JOIN (
		SELECT ROW_NUMBER() OVER(PARTITION BY ClientGUID ORDER BY HairSystemOrderTransactionDate DESC) AS LastRank, ClientGUID, HairSystemOrderTransactionDate
		FROM dbo.datHairSystemOrderTransaction
		WHERE NewHairSystemOrderStatusID = @APPLIEDHairSystemOrderStatusID
	) LastAppl ON LastAppl.ClientGUID = clients.ClientGUID AND LastAppl.LastRank = 1
	LEFT JOIN dbo.cfgCenter Center ON clients.CenterId = Center.CenterID --AND Center.IsActiveFlag = 1
		LEFT JOIN dbo.lkpRegion Region ON Center.RegionID = Region.RegionID
ORDER BY Region, Center, Client
END
