/* CreateDate: 11/08/2012 13:47:15.030 , ModifyDate: 11/05/2015 11:41:52.163 */
GO
CREATE VIEW [dbo].[lead_info]
AS
SELECT  c.contact_id,
            c.first_name,
            c.last_name,
            c.creation_date,
            c.created_by_user_code,
            cp.area_code,
            cp.phone_number,
            RTRIM(ca.address_line_1) AS 'address_line_1',
            RTRIM(ca.address_line_2) AS 'address_line_2',
            ca.city,
            ca.state_code,
            ca.zip_code,
            cz.adi_flag,
            ce.email,
            CASE WHEN co.cst_center_number IS NULL THEN coa.cst_center_number ELSE co.cst_center_number END AS territory,
            CASE WHEN co.cst_center_number IS NOT NULL THEN coa.cst_center_number ELSE NULL END AS alt_center,
            c.cst_gender_code,
            pc.description AS cst_promotion_code,
            c.cst_complete_sale,
            c.cst_language_code,
            c.contact_status_code,
			cs.source_code AS 'leadSourceCode'
    FROM    dbo.oncd_contact AS c
            LEFT OUTER JOIN dbo.oncd_contact_phone AS cp ON cp.contact_id = c.contact_id
                                                            AND cp.primary_flag = 'Y'
            LEFT OUTER JOIN dbo.oncd_contact_address AS ca ON ca.contact_id = c.contact_id
                                                              AND ca.primary_flag = 'Y'
            LEFT OUTER JOIN dbo.oncd_contact_email AS ce ON ce.contact_id = c.contact_id
                                                            AND ce.primary_flag = 'Y'

			LEFT OUTER JOIN dbo.oncd_contact_source AS cs ON cs.contact_id = c.contact_id
                                              AND cs.primary_flag = 'Y'
			LEFT OUTER JOIN dbo.csta_promotion_code AS pc ON pc.promotion_code = c.cst_promotion_code

            LEFT OUTER JOIN --mod
            dbo.oncd_contact_company AS cc ON cc.contact_id = c.contact_id
                                              AND cc.primary_flag <> 'Y'
            LEFT OUTER JOIN dbo.oncd_contact_company AS cca ON c.contact_id = cca.contact_id
                                                               and cca.contact_company_id = ( SELECT TOP ( 1 )
                                                                                                        contact_company_id
                                                                                              FROM      dbo.oncd_contact_company
                                                                                              WHERE     ( contact_id = c.contact_id )
                                                                                                        AND ( primary_flag = 'Y' )
                                                                                            )
            LEFT OUTER JOIN --mod
            dbo.oncd_company AS co ON co.company_id = cc.company_id
            LEFT OUTER JOIN dbo.oncd_company AS coa ON coa.company_id = cca.company_id
            LEFT OUTER JOIN --mod
            dbo.cstd_company_zip_code AS cz ON coa.company_id = cz.company_id
                                               AND cz.zip_from = ca.zip_code
GO
