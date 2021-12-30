/* CreateDate: 09/22/2008 15:05:39.233 , ModifyDate: 01/25/2010 08:11:31.730 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_GetContactByID
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			7/18/2008
-- Date Implemented:		7/18/2008
-- Date Last Modified:		7/18/2008
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	BOS
-- Related Application:		The Right Experience
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_GetContactByID 'THW1HFIN61'
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_GetContactByID]
(
	@ContactID VARCHAR(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT  LTRIM(RTRIM(c.[contact_id])) AS 'contact_id'
	,       LTRIM(RTRIM(ISNULL(c.[salutation_code], ''))) AS 'salutation'
	,       dbo.pCase(LTRIM(RTRIM(ISNULL(c.[first_name], '')))) AS 'first_name'
	,       dbo.pCase(LTRIM(RTRIM(ISNULL(c.[middle_name], '')))) AS 'middle_name'
	,       dbo.pCase(LTRIM(RTRIM(ISNULL(c.[last_name], '')))) AS 'last_name'
	,       LTRIM(RTRIM(cp.[area_code])) + '-' + LEFT(LTRIM(cp.[phone_number]), 3) + '-' + RIGHT(RTRIM(cp.[phone_number]), 4) AS 'full_phone_number'
	,		LTRIM(RTRIM(ISNULL(cp.[area_code], ''))) AS 'area_code'
	,		LTRIM(RTRIM(ISNULL(cp.[phone_number], ''))) AS 'phone_number'
	,       LEFT(LTRIM(RTRIM(ca.[address_line_1])), 35) + ', ' + LEFT(LTRIM(RTRIM(ca.[address_line_2])), 13) AS 'address'
	,       LEFT(LTRIM(RTRIM(ISNULL(ca.[address_line_1], ''))), 50) AS 'address_line_1'
	,       LEFT(LTRIM(RTRIM(ISNULL(ca.[address_line_2], ''))), 50) AS 'address_line_2'
	,       ISNULL(dbo.pCase(LTRIM(RTRIM(ca.[city]))), '') AS 'city'
	,       LTRIM(RTRIM(ISNULL(ca.[state_code], ''))) AS 'state_code'
	,       LTRIM(RTRIM(ISNULL(ca.[zip_code], ''))) AS 'zip_code'
	,       LEFT(LTRIM(RTRIM(ISNULL(c.[cst_gender_code], ''))), 1) AS 'cst_gender_code'
	,       LTRIM(RTRIM(ISNULL(ce.[email], ''))) AS 'email'
	FROM    [HCM].[dbo].[oncd_company] co WITH ( NOLOCK )
			INNER JOIN [HCM].[dbo].[oncd_contact_company] cc WITH ( NOLOCK )
																  ON co.company_id = cc.company_id
																	 AND cc.primary_flag = 'y'
			INNER JOIN [HCM].[dbo].[oncd_contact] c WITH ( NOLOCK )
														 ON c.contact_id = cc.contact_id
			LEFT OUTER JOIN [HCM].[dbo].[oncd_contact_phone] cp WITH ( NOLOCK )
																	 ON c.contact_id = cp.contact_id
																		AND cp.primary_flag = 'Y'
			LEFT OUTER JOIN [HCM].[dbo].[oncd_contact_address] ca WITH ( NOLOCK )
																	   ON c.contact_id = ca.contact_id
																		  AND ca.primary_flag = 'Y'
			LEFT OUTER JOIN [HCM].[dbo].[oncd_contact_source] cs WITH ( NOLOCK )
																	  ON c.contact_id = cs.contact_id
																		 AND cs.primary_flag = 'Y'
			LEFT OUTER JOIN [HCM].[dbo].[oncd_contact_company] cca WITH ( NOLOCK )
																		on cca.contact_id = c.contact_id
																		   and cca.company_id <> co.company_id
			LEFT OUTER JOIN [HCM].[dbo].[oncd_company] AS coa
			  ON coa.company_id = cca.company_id
			LEFT OUTER JOIN [HCM].[dbo].[oncd_contact_email] ce WITH ( NOLOCK )
																	 ON c.contact_id = ce.contact_id
																		AND ce.primary_flag = 'Y'
	WHERE   c.[contact_id] = @ContactID
END
GO
