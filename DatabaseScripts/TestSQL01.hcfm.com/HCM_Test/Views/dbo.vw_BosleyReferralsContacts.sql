/* CreateDate: 07/15/2015 13:42:33.617 , ModifyDate: 08/01/2015 10:30:35.917 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vw_BosleyReferralsContacts
DESTINATION SERVER:		SQL03
DESTINATION DATABASE: 	HCM
IMPLEMENTOR:			DLeiba
------------------------------------------------------------------------
NOTES:

07/15/2015 - DL - Initial Rewrite to SQL03.
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_BosleyReferralsContacts WHERE source_code = 'BOSREFVAN'
***********************************************************************/
CREATE VIEW [dbo].[vw_BosleyReferralsContacts]
AS

SELECT  OC.contact_id
,		OC.creation_date
,		OC.created_by_user_code
,		OCS.source_code
,		OC.last_name
,		OC.first_name
,		OCA.address_line_1
,		OCA.address_line_2
,		OCA.city
,		OCA.state_code
,		OCA.zip_code
,		OCE.email
,		home_ph.area_code + home_ph.phone_number AS 'home_phone'
,		home_ph.primary_flag AS 'home_primary'
,		cell_ph.area_code + cell_ph.phone_number AS 'cell_phone'
,		cell_ph.primary_flag AS 'cell_primary'
,		business_ph.area_code + business_ph.phone_number AS 'business_phone'
,		business_ph.primary_flag AS 'business_primary'
,		home2_ph.area_code + home2_ph.phone_number AS 'home2_phone'
,		home2_ph.primary_flag AS 'home2_primary'
,		cell2_ph.area_code + cell2_ph.phone_number AS 'cell2_phone'
,		cell2_ph.primary_flag AS 'cell2_primary'
,		COM.cst_center_number AS 'center_number'
,		COM.company_name_1 AS 'center_name'
,		'' AS 'SaleType'
,       ISNULL(OC.cst_siebel_id, '') AS 'SiebelID'
FROM    oncd_contact OC
		INNER JOIN oncd_contact_company OCC
			ON OCC.contact_id = OC.contact_id
				AND OCC.primary_flag = 'Y'
		INNER JOIN oncd_company COM
			ON COM.company_id = OCC.company_id
		INNER JOIN oncd_contact_source OCS
			ON OCS.contact_id = OC.contact_id
				AND OCS.primary_flag = 'Y'
		LEFT OUTER JOIN oncd_contact_address OCA
			ON OCA.contact_id = OC.contact_id
				AND OCA.primary_flag = 'Y'
		LEFT OUTER JOIN oncd_contact_email OCE
			ON OCE.contact_id = OC.contact_id
				AND OCE.primary_flag = 'Y'
		LEFT OUTER JOIN oncd_contact_phone home_ph
			ON home_ph.contact_id = OC.contact_id
				AND home_ph.phone_type_code = 'HOME'
		LEFT OUTER JOIN oncd_contact_phone home2_ph
			ON home2_ph.contact_id = OC.contact_id
				AND home2_ph.phone_type_code = 'HOME2'
		LEFT OUTER JOIN oncd_contact_phone cell_ph
			ON cell_ph.contact_id = OC.contact_id
				AND cell_ph.phone_type_code = 'CELL'
		LEFT OUTER JOIN oncd_contact_phone cell2_ph
			ON cell2_ph.contact_id = OC.contact_id
				AND cell2_ph.phone_type_code = 'CELL2'
		LEFT OUTER JOIN oncd_contact_phone business_ph
			ON business_ph.contact_id = OC.contact_id
				AND business_ph.phone_type_code = 'BUSINESS'
--WHERE   OC.creation_date BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(ms,- 3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())+1, 0)))
GO
