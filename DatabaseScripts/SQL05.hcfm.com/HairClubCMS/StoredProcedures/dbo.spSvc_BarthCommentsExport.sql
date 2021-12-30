/* CreateDate: 04/06/2015 08:47:29.070 , ModifyDate: 06/23/2020 10:53:56.447 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthCommentsExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthCommentsExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthCommentsExport]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get Notes Data *************************************/
SELECT  DNC.NotesClientGUID
,		CC.CenterID AS 'CenterSSID'
,		CC.CenterDescriptionFullCalc AS 'CenterDescription'
,		DC.ClientIdentifier
,		DC.ClientNumber_Temp AS 'CMSClientIdentifier'
,		REPLACE(DC.FirstName, ',', '') AS 'FirstName'
,		REPLACE(DC.LastName, ',', '') AS 'LastName'
,		ISNULL(CM.MembershipDescription, '') AS 'Membership'
,		LNT.NoteTypeDescription AS 'NoteType'
,		ISNULL(LNST.NoteSubTypeDescription, '') AS 'SubNoteType'
,		DNC.NotesClientDate AS 'NoteDate'
,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DNC.NotesClient, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'Notes'
,		DHSO.HairSystemOrderNumber
,		DNC.SalesOrderGUID AS 'SalesOrderSSID'
,		DNC.IsFlagged
FROM    datNotesClient DNC
		INNER JOIN datClient DC
			ON DC.ClientGUID = DNC.ClientGUID
		INNER JOIN cfgCenter CC
			ON CC.CenterID = DC.CenterID
        INNER JOIN lkpNoteType LNT
            ON LNT.NoteTypeID = DNC.NoteTypeID
		LEFT OUTER JOIN datHairSystemOrder DHSO
			ON DHSO.HairSystemOrderGUID = DNC.HairSystemOrderGUID
		LEFT OUTER JOIN datClientMembership DCM
			ON DCM.ClientMembershipGUID = DNC.ClientMembershipGUID
		LEFT OUTER JOIN cfgMembership CM
			ON CM.MembershipID = DCM.MembershipID
		LEFT OUTER JOIN SQL01.HairClubCMS.dbo.lkpNoteSubType LNST
            ON LNST.NoteSubTypeID = DNC.NoteSubTypeID
WHERE	CC.CenterID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )
		AND LNT.NoteTypeID <> 2
		AND DNC.NotesClientDate >= CAST(DATEADD(DAY, -21, GETUTCDATE()) AS DATE)
--ORDER BY CC.CenterID
--,		DC.ClientIdentifier
--,		DNC.NoteTypeID

END
GO
