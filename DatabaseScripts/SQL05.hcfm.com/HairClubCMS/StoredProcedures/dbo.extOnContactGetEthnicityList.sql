/* CreateDate: 12/11/2012 14:57:18.763 , ModifyDate: 12/11/2012 14:57:18.763 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetEthnicityList

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetEthnicityList

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetEthnicityList
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetEthnicityList]
AS
BEGIN
	SET NOCOUNT ON

	SELECT EthnicityCode, [Description]
	FROM HCBOS..ContactEthnicity
	WHERE Active = 1
	ORDER BY SortOrder
END
GO
