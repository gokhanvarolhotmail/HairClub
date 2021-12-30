/* CreateDate: 12/11/2012 14:57:18.707 , ModifyDate: 12/11/2012 14:57:18.707 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetCenterCountry

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetCenterCountry

==============================================================================
SAMPLE EXECUTION:
EXEC spApp_TREConsultations_GetCenterCountry 201
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetCenterCountry]
(
	@CenterNumber int
)
AS
BEGIN
	SET NOCOUNT ON

	-- Output results.
	SELECT  ISNULL(oca.country_code, 'US') AS 'country_code'
	FROM HCMSkylineTest..oncd_company oc WITH (NOLOCK)
		INNER JOIN HCMSkylineTest..oncd_company_address oca WITH (NOLOCK) ON oc.company_id = oca.company_id
	WHERE cst_center_number = @CenterNumber
END
GO
