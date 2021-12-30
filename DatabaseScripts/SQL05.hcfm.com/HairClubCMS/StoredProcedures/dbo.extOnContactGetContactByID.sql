/* CreateDate: 12/11/2012 14:57:18.757 , ModifyDate: 12/11/2012 14:57:18.757 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactGetContactByID

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_GetContactByID

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactGetContactByID 'THW1HFIN61'
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactGetContactByID]
(
	@ContactID varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT  LTRIM(RTRIM(c.contact_id)) AS 'contact_id', LTRIM(RTRIM(ISNULL(c.salutation_code, ''))) AS 'salutation',
		dbo.[pCase](LTRIM(RTRIM(ISNULL(c.first_name, '')))) AS 'first_name', dbo.[pCase](LTRIM(RTRIM(ISNULL(c.middle_name, '')))) AS 'middle_name', dbo.[pCase](LTRIM(RTRIM(ISNULL(c.last_name, '')))) AS 'last_name',
		LTRIM(RTRIM(cp.area_code)) + '-' + LEFT(LTRIM(cp.phone_number), 3) + '-' + RIGHT(RTRIM(cp.phone_number), 4) AS 'full_phone_number', LTRIM(RTRIM(ISNULL(cp.area_code, ''))) AS 'area_code', LTRIM(RTRIM(ISNULL(cp.phone_number, ''))) AS 'phone_number',
		LEFT(LTRIM(RTRIM(ca.address_line_1)), 35) + ', ' + LEFT(LTRIM(RTRIM(ca.address_line_2)), 13) AS 'address', LEFT(LTRIM(RTRIM(ISNULL(ca.address_line_1, ''))), 50) AS 'address_line_1', LEFT(LTRIM(RTRIM(ISNULL(ca.address_line_2, ''))), 50) AS 'address_line_2',
		ISNULL(dbo.[pCase](LTRIM(RTRIM(ca.city))), '') AS 'city', LTRIM(RTRIM(ISNULL(ca.state_code, ''))) AS 'state_code', LTRIM(RTRIM(ISNULL(ca.zip_code, ''))) AS 'zip_code',
		LEFT(LTRIM(RTRIM(ISNULL(c.cst_gender_code, ''))), 1) AS 'cst_gender_code', LTRIM(RTRIM(ISNULL(ce.email, ''))) AS 'email', cs.source_code as 'source_code'
	FROM HCMSkylineTest..oncd_company co WITH ( NOLOCK )
		INNER JOIN HCMSkylineTest..oncd_contact_company cc WITH ( NOLOCK ) ON co.company_id = cc.company_id AND cc.primary_flag = 'y'
			  INNER JOIN HCMSkylineTest..oncd_contact c WITH ( NOLOCK ) ON c.contact_id = cc.contact_id
			  LEFT JOIN HCMSkylineTest..oncd_contact_phone cp WITH ( NOLOCK ) ON c.contact_id = cp.contact_id AND cp.primary_flag = 'Y'
			  LEFT JOIN HCMSkylineTest..oncd_contact_address ca WITH ( NOLOCK ) ON c.contact_id = ca.contact_id AND ca.primary_flag = 'Y'
			  LEFT JOIN HCMSkylineTest..oncd_contact_source cs WITH ( NOLOCK ) ON c.contact_id = cs.contact_id AND cs.primary_flag = 'Y'
			  LEFT JOIN HCMSkylineTest..oncd_contact_company cca WITH ( NOLOCK ) ON cca.contact_id = c.contact_id AND cca.company_id <> co.company_id
			  LEFT JOIN HCMSkylineTest..oncd_company AS coa ON coa.company_id = cca.company_id
			  LEFT JOIN HCMSkylineTest..oncd_contact_email ce WITH ( NOLOCK ) ON c.contact_id = ce.contact_id AND ce.primary_flag = 'Y'
	WHERE   c.contact_id = @ContactID

END
GO
