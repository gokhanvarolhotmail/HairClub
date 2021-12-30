/* CreateDate: 01/03/2014 07:07:46.500 , ModifyDate: 01/03/2014 07:07:46.500 */
GO
CREATE VIEW [core].[wait_types_categorized]
AS
    SELECT
        ct.category_name,
        ev.wait_type,
        ct.category_id,
        ct.ignore
    FROM core.wait_categories ct
    INNER JOIN core.wait_types ev ON (ev.category_id = ct.category_id)
GO
