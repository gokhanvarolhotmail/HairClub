/* CreateDate: 01/25/2010 11:09:09.990 , ModifyDate: 05/01/2010 14:48:09.263 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW oncv_candidate_foreign_key
AS
SELECT     candidate_foreign_table.name  AS foreign_table_name,
           candidate_foreign_column.name AS foreign_column_name,
           candidate_primary_table.name  AS primary_table_name,
           candidate_primary_column.name AS primary_column_name,
           (CASE candidate_foreign_column.name WHEN candidate_primary_column.name THEN 1 ELSE 2 END) AS quality_rank
FROM       sysobjects AS candidate_primary_table
INNER JOIN syscolumns AS candidate_primary_column
        ON (candidate_primary_table.id = candidate_primary_column.id)
INNER JOIN syscolumns AS candidate_foreign_column
        ON (LOWER(RTRIM(candidate_foreign_column.name)) LIKE '%' + LOWER(RTRIM(candidate_primary_column.name)))
INNER JOIN sysobjects AS candidate_foreign_table
        ON (candidate_foreign_table.id = candidate_foreign_column.id)
INNER JOIN information_schema.table_constraints AS schema_primary_key_constraint
        ON (    schema_primary_key_constraint.table_name      = candidate_primary_table.name
            AND schema_primary_key_constraint.constraint_type = 'PRIMARY KEY')
INNER JOIN information_schema.key_column_usage  AS schema_primary_key_column
        ON (    schema_primary_key_column.constraint_name     = schema_primary_key_constraint.constraint_name
            AND schema_primary_key_column.column_name         = candidate_primary_column.name)
WHERE      candidate_foreign_table.xtype = 'U'
AND        candidate_primary_table.xtype = 'U'
AND            (    LOWER(RTRIM(candidate_primary_column.name)) = LOWER(RTRIM(SUBSTRING(candidate_primary_table.name, 6, LEN(candidate_primary_table.name) - 5)) + '_code')
                OR  LOWER(RTRIM(candidate_primary_column.name)) = LOWER(RTRIM(SUBSTRING(candidate_primary_table.name, 6, LEN(candidate_primary_table.name) - 5)) + '_id'))
AND        NOT (    LOWER(RTRIM(candidate_foreign_column.name)) = LOWER(RTRIM(SUBSTRING(candidate_foreign_table.name, 6, LEN(candidate_foreign_table.name) - 5)) + '_code')
                OR  LOWER(RTRIM(candidate_foreign_column.name)) = LOWER(RTRIM(SUBSTRING(candidate_foreign_table.name, 6, LEN(candidate_foreign_table.name) - 5)) + '_id'))
AND        NOT (    candidate_foreign_table.name  = candidate_primary_table.name
                AND candidate_foreign_column.name = candidate_primary_column.name)
AND        NOT (    LOWER(SUBSTRING(candidate_foreign_table.name, 4, 1))  = 'a'
                AND LOWER(SUBSTRING(candidate_primary_table.name, 4, 1)) <> 'a')
AND        candidate_foreign_column.xusertype  = candidate_primary_column.xusertype
AND        candidate_foreign_column.length     = candidate_primary_column.length
AND        candidate_foreign_column.xprec      = candidate_primary_column.xprec
AND        candidate_foreign_column.xscale     = candidate_primary_column.xscale
AND        NOT EXISTS (
           SELECT     'X'
           FROM       information_schema.key_column_usage other_schema_primary_key_column
               WHERE      other_schema_primary_key_column.constraint_name = schema_primary_key_constraint.constraint_name
               AND        other_schema_primary_key_column.ordinal_position > 1)
	AND        NOT EXISTS (
	           SELECT     'X'
	           FROM       sysforeignkeys AS existing_foreign_key
	           INNER JOIN sysobjects     AS existing_foreign_object
                       ON (existing_foreign_object.id = existing_foreign_key.constid)
	           INNER JOIN sysobjects     AS existing_foreign_table
                       ON (existing_foreign_table.id  = existing_foreign_key.fkeyid)
	           INNER JOIN syscolumns     AS existing_foreign_column
                       ON (    existing_foreign_column.id    = existing_foreign_table.id
                           AND existing_foreign_column.colid = existing_foreign_key.fkey)
	           WHERE      existing_foreign_table.name  = candidate_foreign_table.name
               AND        existing_foreign_column.name = candidate_foreign_column.name)
GO
