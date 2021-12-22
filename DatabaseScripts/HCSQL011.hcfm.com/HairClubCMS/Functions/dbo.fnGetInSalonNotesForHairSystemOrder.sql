/* CreateDate: 06/27/2011 20:28:28.230 , ModifyDate: 02/27/2017 09:49:37.343 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

FUNCTION:				fnGetInSalonNotesForHairSystemOrder

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	CMS

AUTHOR:					Michael Tovbin

IMPLEMENTOR:			Michael Tovbin

DATE IMPLEMENTED:		06/24/2011

LAST REVISION DATE:		06/24/2011

--------------------------------------------------------------------------------------------------------
NOTES: 	This function returns all the in-salon notes for the Hair System Order
			separated by a semicolon.

		* 06/24/2011 MVT - Script created

--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
SELECT [dbo].[fnGetInSalonNotesForHairSystemOrder] ('6C1CC299-717C-438E-9B60-0000682D9784')
***********************************************************************/

CREATE FUNCTION [dbo].[fnGetInSalonNotesForHairSystemOrder]
(
	@HairSystemOrderGuid uniqueidentifier
)
RETURNS VarChar(MAX)
AS
BEGIN
	DECLARE @LaceAndFactory VarChar(Max)
	DECLARE @Notes VarChar(MAX)
	SET @LaceAndFactory = null
	SET @Notes = null


	SELECT @Notes = COALESCE (@Notes + '; ', '') + nc.NotesClient
	FROM datNotesClient nc
		INNER JOIN lkpNoteType nt ON nc.NoteTypeID = nt.NoteTypeID
	WHERE nc.HairSystemOrderGUID = @HairSystemOrderGuid
		AND nt.NoteTypeDescriptionShort IN ('IS')
	ORDER BY nt.LastUpdate


	-- Return the result of the function
	RETURN ISNULL(@Notes,'')
END
GO
