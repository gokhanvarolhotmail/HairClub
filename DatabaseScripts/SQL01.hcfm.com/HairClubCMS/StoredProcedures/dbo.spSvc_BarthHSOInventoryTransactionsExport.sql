/* CreateDate: 03/23/2022 10:42:29.050 , ModifyDate: 03/23/2022 10:43:06.173 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthHSOInventoryTransactionsExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthHSOInventoryTransactionsExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthHSOInventoryTransactionsExport]
(
	@StartDate DATETIME = NULL
,	@EndDate DATETIME = NULL
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get HSO Transaction Data *************************************/
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
         SET @StartDate = DATEADD(DAY, -1, CONVERT(VARCHAR, GETDATE(), 101))
         SET @EndDate = @StartDate + ' 23:59:59'
   END


SELECT  hsot.HairSystemOrderTransactionDate AS 'TransactionDate'
,       hso.HairSystemOrderNumber AS 'HSONumber'
,       hsot.CenterID AS 'NewCenter'
,       hsot.PreviousCenterID AS 'PrevCenter'
,       cl.CenterID AS 'ClientCenter'
,       cl.ClientNumber_Temp AS 'CMS25ClientNo'
,       cl.ClientIdentifier AS 'ClientIdentifier'
,       hsotnew.HairSystemOrderStatusDescriptionShort AS 'NewStat'
,       hsotcur.HairSystemOrderStatusDescriptionShort AS 'PrevStat'
,       hsotproc.HairSystemOrderProcessDescription AS 'ProcessDescription'
,       hs.HairSystemDescriptionShort AS 'SystemType'
,       ISNULL(clmem.membershipdescription, hsomem.membershipdescription) AS 'CurClientMembership'
,       hsomem.membershipdescription AS 'HSOMembership'
FROM    datHairSystemOrderTransaction hsot
        INNER JOIN datHairSystemOrder hso
            ON hsot.HairSystemOrderGUID = hso.HairSystemOrderGUID
        INNER JOIN datClient cl
            ON hso.ClientGUID = cl.ClientGUID
        INNER JOIN cfgCenter c
            ON cl.centerid = c.CenterID
        INNER JOIN lkpHairSystemOrderStatus hsotnew
            ON hsot.NewHairSystemOrderStatusID = hsotnew.HairSystemOrderStatusID
        LEFT OUTER JOIN lkpHairSystemOrderStatus hsotcur
            ON hsot.PreviousHairSystemOrderStatusID = hsotcur.HairSystemOrderStatusID
        INNER JOIN lkpHairSystemOrderProcess hsotproc
            ON hsot.HairSystemOrderProcessID = hsotproc.HairSystemOrderProcessID
        INNER JOIN cfgHairSystem hs
            ON hso.HairSystemID = hs.HairSystemID
        INNER JOIN datClientMembership hsoclm
            ON hso.ClientMembershipGUID = hsoclm.ClientMembershipGUID
        LEFT OUTER JOIN cfgmembership hsomem
            ON hsoclm.membershipid = hsomem.membershipid
        LEFT OUTER JOIN datClientMembership clclm
            ON cl.CurrentBioMatrixClientMembershipGUID = clclm.ClientMembershipGUID
        LEFT OUTER JOIN cfgmembership clmem
            ON clclm.membershipid = clmem.membershipid
WHERE   c.CenterID IN ( 745, 746, 747, 748, 804, 805, 806, 807, 811, 814, 817, 820, 821, 822 )
        AND hsot.HairSystemOrderTransactionDate BETWEEN @StartDate AND @EndDate
ORDER BY hsot.CenterID
,       hso.HairSystemOrderNumber
,       hsot.HairSystemOrderTransactionDate

END
GO
