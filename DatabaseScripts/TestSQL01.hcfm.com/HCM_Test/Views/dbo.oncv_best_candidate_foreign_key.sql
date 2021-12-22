/* CreateDate: 01/25/2010 11:09:10.130 , ModifyDate: 05/01/2010 14:48:09.290 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW oncv_best_candidate_foreign_key
AS
SELECT  candidate.foreign_table_name,
        candidate.foreign_column_name,
        candidate.primary_table_name,
        candidate.primary_column_name,
        candidate.quality_rank
FROM    oncv_candidate_foreign_key AS candidate
INNER JOIN (
       SELECT   foreign_table_name,
                foreign_column_name,
                MIN(quality_rank) AS best_quality_rank
       FROM     oncv_candidate_foreign_key
       GROUP BY foreign_table_name,
                foreign_column_name) AS leading_candidate
        ON (    leading_candidate.foreign_table_name  = candidate.foreign_table_name
            AND leading_candidate.foreign_column_name = candidate.foreign_column_name
            AND leading_candidate.best_quality_rank   = candidate.quality_rank)
GO
