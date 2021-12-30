/* CreateDate: 12/11/2012 14:57:18.770 , ModifyDate: 12/11/2012 14:57:18.770 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetHairScaleList

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dominic Leiba

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 7/29/2008

LAST REVISION DATE: 	 5/7/2010

==============================================================================
DESCRIPTION:	Interface with OnContact database
==============================================================================
NOTES:
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetHairScaleList

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetHairScaleList 1
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetHairScaleList]
(
	@GenderID int
)
AS
BEGIN
	SET NOCOUNT ON

	IF @GenderID = 1
	  BEGIN
		SELECT HairScaleCode, [Description]
		FROM HCBOS..ContactNorwoodScale
		WHERE Active = 1
		ORDER BY SortOrder
	  END
	ELSE
	  BEGIN
		SELECT HairScaleCode, [Description]
		FROM HCBOS..ContactLudwigScale
		WHERE Active = 1
		ORDER BY SortOrder
	  END
END
GO
