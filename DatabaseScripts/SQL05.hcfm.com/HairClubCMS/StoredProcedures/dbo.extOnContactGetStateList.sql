/* CreateDate: 12/11/2012 14:57:18.833 , ModifyDate: 12/11/2012 14:57:18.833 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetStateList

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetStateList

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetStateList 'US'
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetStateList]
(
	@CountryCode varchar(2)
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT state_code AS 'ID', [description] AS 'Description'
	FROM HCMSkylineTest..onca_state
	WHERE   country_code = @CountryCode AND active = 'Y'
END
GO
