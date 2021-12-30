/* CreateDate: 08/07/2018 11:40:43.217 , ModifyDate: 08/07/2018 11:50:33.717 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthHSOInventoryExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
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
,       clt.CenterID AS 'ClientCenterID'
,       clt.ClientNumber_Temp AS 'CMS25ClientNo'
,       clt.ClientIdentifier AS 'CMS42ClientIdentifier'
,       REPLACE(clt.FirstName, ',', '') AS 'FirstName'
,       REPLACE(clt.LastName, ',', '') AS 'LastName'
,       hso.HairSystemOrderNumber AS 'HSONumber'
,       chs.HairSystemDescriptionShort AS 'SystemType'
,       hos.HairSystemOrderStatusDescriptionShort AS 'CurrentStatus'
,       COALESCE(mClt.MembershipDescription, mHso.MembershipDescription) AS 'CurClientMembership'
,       mHso.MembershipDescription AS 'HSOMembership'
FROM    datHairSystemOrder hso WITH	( NOLOCK )
		INNER JOIN datClient clt WITH ( NOLOCK )
			ON clt.ClientGUID = hso.ClientGUID
		INNER JOIN lkpHairSystemOrderStatus hos WITH ( NOLOCK )
			ON hos.HairSystemOrderStatusID = hso.HairSystemOrderStatusID
		INNER JOIN cfgHairSystem chs WITH ( NOLOCK )
			ON chs.HairSystemID = hso.HairSystemID
		INNER JOIN datClientMembership dcmHso WITH ( NOLOCK )
			ON dcmHso.ClientMembershipGUID = hso.ClientMembershipGUID
		INNER JOIN cfgMembership mHso WITH ( NOLOCK )
			ON mHso.MembershipID = dcmHso.MembershipID
		LEFT OUTER JOIN datClientMembership dcmClt WITH ( NOLOCK )
			ON dcmClt.ClientMembershipGUID = clt.CurrentBioMatrixClientMembershipGUID
		LEFT OUTER JOIN cfgMembership mClt WITH ( NOLOCK )
			ON mClt.MembershipID = dcmClt.MembershipID
WHERE	hso.CenterID IN ( 745, 746, 747, 748, 804, 805, 806, 807, 811, 814, 817, 820, 821, 822 )
		AND hso.HairSystemOrderStatusID IN ( 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22 )

END
GO
