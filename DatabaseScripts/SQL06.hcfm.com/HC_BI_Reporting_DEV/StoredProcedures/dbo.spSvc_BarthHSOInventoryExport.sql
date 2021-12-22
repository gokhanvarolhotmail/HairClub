/***********************************************************************
PROCEDURE:				spSvc_BarthHSOInventoryExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthHSOInventoryExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthHSOInventoryExport]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get HSO Data *************************************/
SELECT  hso.CenterID AS 'CenterID'
,       cl.CenterID AS 'ClientCenterID'
,       cl.ClientNumber_Temp AS 'CMS25ClientNo'
,       cl.ClientIdentifier AS 'CMS42ClientIdentifier'
,       REPLACE(cl.FirstName, ',', '') AS 'FirstName'
,       REPLACE(cl.LastName, ',', '') AS 'LastName'
,       hso.HairSystemOrderNumber AS 'HSONumber'
,       hs.HairSystemDescriptionShort AS 'SystemType'
,       hsostat.HairSystemOrderStatusDescriptionShort AS 'CurrentStatus'
,       ISNULL(clmem.membershipdescription, hsomem.membershipdescription) AS 'CurClientMembership'
,       hsomem.membershipdescription AS 'HSOMembership'
FROM    [SQL05].Hairclubcms.dbo.datHairSystemOrder HSO
        INNER JOIN [SQL05].Hairclubcms.dbo.cfgCenter C
            ON hso.CenterID = c.CenterID
        INNER JOIN [SQL05].Hairclubcms.dbo.datClient CL
            ON hso.ClientGUID = cl.ClientGUID
        INNER JOIN [SQL05].Hairclubcms.dbo.datClientMembership HSOCLM
            ON hso.ClientMembershipGUID = hsoclm.ClientMembershipGUID
        INNER JOIN [SQL05].Hairclubcms.dbo.cfgmembership HSOMEM
            ON hsoclm.membershipid = hsomem.membershipid
        LEFT OUTER JOIN [SQL05].Hairclubcms.dbo.datClientMembership CLCLM
            ON cl.CurrentBioMatrixClientMembershipGUID = clclm.ClientMembershipGUID
        LEFT OUTER JOIN [SQL05].Hairclubcms.dbo.cfgmembership CLMEM
            ON clclm.membershipid = clmem.membershipid
        INNER JOIN [SQL05].Hairclubcms.dbo.lkpHairSystemOrderStatus HSOSTAT
            ON hso.HairSystemOrderStatusID = hsostat.HairSystemOrderStatusID
        INNER JOIN [SQL05].Hairclubcms.dbo.cfgHairSystem HS
            ON hso.HairSystemID = hs.HairSystemID
WHERE   hso.HairSystemOrderStatusID IN ( 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22 )
        AND c.RegionID = 6
ORDER BY hso.CenterID
,       hso.HairSystemOrderDate

END
