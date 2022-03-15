/* CreateDate: 04/10/2014 12:15:12.080 , ModifyDate: 03/11/2022 08:43:37.937 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthHSOInventoryTransactionsExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
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
         SET @StartDate = DATEADD(DAY, -2, CONVERT(VARCHAR, GETDATE(), 101))
         SET @EndDate = @StartDate + ' 23:59:59'
		 --SET @EndDate = GETDATE()
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
FROM    [SQL05].HairclubCMS.dbo.datHairSystemOrderTransaction hsot
        INNER JOIN [SQL05].HairclubCMS.dbo.datHairSystemOrder hso
            ON hsot.HairSystemOrderGUID = hso.HairSystemOrderGUID
        INNER JOIN [SQL05].HairclubCMS.dbo.datClient cl
            ON hso.ClientGUID = cl.ClientGUID
        INNER JOIN [SQL05].HairclubCMS.dbo.cfgCenter c
            ON cl.centerid = c.CenterID
        INNER JOIN [SQL05].HairclubCMS.dbo.lkpHairSystemOrderStatus hsotnew
            ON hsot.NewHairSystemOrderStatusID = hsotnew.HairSystemOrderStatusID
        LEFT OUTER JOIN [SQL05].HairclubCMS.dbo.lkpHairSystemOrderStatus hsotcur
            ON hsot.PreviousHairSystemOrderStatusID = hsotcur.HairSystemOrderStatusID
        INNER JOIN [SQL05].HairclubCMS.dbo.lkpHairSystemOrderProcess hsotproc
            ON hsot.HairSystemOrderProcessID = hsotproc.HairSystemOrderProcessID
        INNER JOIN [SQL05].HairclubCMS.dbo.cfgHairSystem hs
            ON hso.HairSystemID = hs.HairSystemID
        INNER JOIN [SQL05].HairclubCMS.dbo.datClientMembership hsoclm
            ON hso.ClientMembershipGUID = hsoclm.ClientMembershipGUID
        LEFT OUTER JOIN [SQL05].HairclubCMS.dbo.cfgmembership hsomem
            ON hsoclm.membershipid = hsomem.membershipid
        LEFT OUTER JOIN [SQL05].HairclubCMS.dbo.datClientMembership clclm
            ON cl.CurrentBioMatrixClientMembershipGUID = clclm.ClientMembershipGUID
        LEFT OUTER JOIN [SQL05].HairclubCMS.dbo.cfgmembership clmem
            ON clclm.membershipid = clmem.membershipid
WHERE   c.RegionID = 6
        AND hsot.HairSystemOrderTransactionDate BETWEEN @StartDate AND @EndDate
ORDER BY hsot.CenterID
,       hso.HairSystemOrderNumber
,       hsot.HairSystemOrderTransactionDate

END
GO
