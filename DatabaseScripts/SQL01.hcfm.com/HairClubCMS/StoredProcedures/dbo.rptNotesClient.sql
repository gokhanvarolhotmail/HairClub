/*===============================================================================================
 Procedure Name:            [rptNotesClient]
 Procedure Description:
 Created By:                Rachelen Hut
 Implemented By:            Rachelen Hut
 Date Created:              06/17/2014
 Destination Server:        HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
**NOTES**

===============================================================================================
CHANGE HISTORY:

================================================================================================

SAMPLE EXECUTION:

EXEC [rptNotesClient] 105270

================================================================================================
*/

CREATE PROCEDURE [dbo].[rptNotesClient](
	@ClientIdentifier INT)


AS
BEGIN

DECLARE @ClientGUID UNIQUEIDENTIFIER

--Find the ClientGUID using the @ClientIdentifier

SET @ClientGUID = (SELECT TOP 1 ClientGUID FROM datClient WHERE ClientIdentifier = @ClientIdentifier)


SELECT nc.ClientGUID
,	nc.NotesClientDate
,	MAX(ap.AppointmentDate) AS AppointmentDate
,	nt.NoteTypeDescription
,	nc.NotesClientGUID
,	nc.NotesClient
,	clt.FirstName
,	clt.LastName
,	clt.ClientIdentifier
,	nc.CreateUser AS 'UpdatedBy'
,	clt.CenterID
,	c.CenterDescriptionFullCalc

FROM datNotesClient nc
INNER JOIN lkpNoteType nt
	ON nc.NoteTypeID = nt.NoteTypeID
INNER JOIN datClient clt
	ON nc.ClientGUID = clt.ClientGUID
INNER JOIN dbo.cfgCenter c
	ON clt.CenterID = c.CenterID
LEFT JOIN dbo.datAppointment ap
	ON nc.AppointmentGUID = ap.AppointmentGUID
WHERE CAST(nc.ClientGUID AS VARCHAR(50))= @ClientGUID
GROUP BY nc.ClientGUID
,	nc.NotesClientDate
,	nt.NoteTypeDescription
,	nc.NotesClientGUID
,	nc.NotesClient
,	clt.FirstName
,	clt.LastName
,	clt.ClientIdentifier
,	nc.CreateUser
,	clt.CenterID
,	c.CenterDescriptionFullCalc
ORDER BY nc.NotesClientDate DESC


END
