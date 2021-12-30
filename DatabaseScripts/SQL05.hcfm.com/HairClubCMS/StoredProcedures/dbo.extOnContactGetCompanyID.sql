/* CreateDate: 12/11/2012 14:57:18.720 , ModifyDate: 12/11/2012 14:57:18.720 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetCompanyID

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetCompanyID

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetCompanyID
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetCompanyID]
(
	@CenterNumber int
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT company_id
	FROM HCMSkylineTest..oncd_company
	WHERE cst_center_number = @CenterNumber
END
GO
