/* CreateDate: 12/11/2012 14:57:18.787 , ModifyDate: 12/11/2012 14:57:18.787 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetNoSaleReasonsList

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetNoSaleReasonsList

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetNoSaleReasonsList
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetNoSaleReasonsList]
AS
BEGIN
	SET NOCOUNT ON

	SELECT ReasonCode, [Description]
	FROM HCBOS..NoSaleReasons
	WHERE Active = 1
	ORDER BY SortOrder
END
GO
