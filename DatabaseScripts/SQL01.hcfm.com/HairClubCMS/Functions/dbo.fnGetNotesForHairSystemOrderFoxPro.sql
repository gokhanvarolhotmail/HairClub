/***********************************************************************

FUNCTION:				fnGetNotesForHairSystemOrderFoxPro

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	CMS

AUTHOR:					Michael Tovbin

IMPLEMENTOR:			Michael Tovbin

DATE IMPLEMENTED:		10/26/2011

LAST REVISION DATE:		10/26/2011

--------------------------------------------------------------------------------------------------------
NOTES: 	This function returns all the notes for the Hair System Order
			separated by a semicolon. Includes Lace Length for FoxPro export.

		* 10/26/11 MVT - Script created
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
SELECT [dbo].[fnGetNotesForHairSystemOrderFoxPro] ('6C1CC299-717C-438E-9B60-0000682D9784')
***********************************************************************/

CREATE FUNCTION [dbo].[fnGetNotesForHairSystemOrderFoxPro]
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

	SELECT @LaceAndFactory = COALESCE('Lace Length:' + fll.HairSystemFrontalLaceLengthDescriptionShort + '; ','') +
						COALESCE(fn.HairSystemFactoryNoteDescription + '; ', '')
						--LTRIM(RTRIM(CONVERT(VarChar(MAX),hso.FactoryNote))) +
						--CASE WHEN LEN(RTRIM(LTRIM(CONVERT(VarChar(MAX),hso.FactoryNote)))) > 0 THEN '; ' ELSE '' END
	FROM datHairSystemOrder hso
		LEFT JOIN lkpHairSystemFrontalLaceLength fll on hso.HairSystemFrontalLaceLengthID = fll.HairSystemFrontalLaceLengthID
		LEFT JOIN lkpHairSystemFactoryNote fn on hso.HairSystemFactoryNoteID = fn.HairSystemFactoryNoteID
	WHERE hso.HairSystemOrderGUID = @HairSystemOrderGuid

	SELECT @Notes = COALESCE (@Notes + '; ', '') + nc.NotesClient
	FROM datNotesClient nc
		INNER JOIN lkpNoteType nt ON nc.NoteTypeID = nt.NoteTypeID
	WHERE nc.HairSystemOrderGUID = @HairSystemOrderGuid
		AND nt.NoteTypeDescriptionShort IN ('SI')
	ORDER BY nt.NoteTypeDescriptionShort


	-- Return the result of the function
	RETURN ISNULL(@LaceAndFactory,'') + ISNULL(@Notes,'')
END
