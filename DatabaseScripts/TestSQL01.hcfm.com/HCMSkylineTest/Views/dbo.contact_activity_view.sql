/* CreateDate: 11/08/2012 13:47:38.163 , ModifyDate: 11/08/2012 13:47:38.163 */
GO
CREATE VIEW [dbo].[contact_activity_view]
AS
SELECT     c.contact_id
			, a.activity_id
            ,(SELECT     TOP 1 cst_center_number
            FROM          oncd_company co INNER JOIN
                                    oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id
            WHERE      primary_flag <> 'Y'
            ORDER BY sort_order) AS alt_center, a.due_date

            ,(SELECT     TOP 1 cst_center_number
            FROM      oncd_company co INNER JOIN
                            oncd_contact_company cco ON cco.company_id = co.company_id AND cco.contact_id = c.contact_id
            WHERE      primary_flag = 'Y') AS center
            , a.action_code
            , c.creation_date
            , a.result_code
FROM         dbo.oncd_contact c INNER JOIN
                      dbo.oncd_activity_contact ac ON ac.contact_id = c.contact_id INNER JOIN
                      dbo.oncd_activity a ON ac.activity_id = a.activity_id
WHERE     (a.due_date > '1/1/2003') AND (a.action_code <> 'INACTIVE') AND (a.due_date IS NOT NULL)
GO
