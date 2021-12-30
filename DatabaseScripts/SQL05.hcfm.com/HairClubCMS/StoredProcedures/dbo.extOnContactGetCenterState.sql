/* CreateDate: 12/11/2012 14:57:18.713 , ModifyDate: 12/11/2012 14:57:18.713 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetCenterState

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetCenterState

==============================================================================
SAMPLE EXECUTION:
EXEC spApp_TREConsultations_GetCenterState 201
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetCenterState]
(
	@CenterNumber int
)
AS
BEGIN
	SET NOCOUNT ON

	-- Output results.
	SELECT oca.state_code
	FROM HCMSkylineTest..oncd_company oc WITH (NOLOCK)
		INNER JOIN HCMSkylineTest..oncd_company_address oca WITH (NOLOCK) ON oc.company_id = oca.company_id
	WHERE cst_center_number = @CenterNumber
END
GO
