/****** Object:  View [microsoft].[vw_table_sizes]    Script Date: 3/1/2022 8:53:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [microsoft].[vw_table_sizes]
AS WITH [base]
AS (
   SELECT
       GETDATE() AS [execution_time]
     , DB_NAME() AS [database_name]
     , [s].[name] AS [schema_name]
     , [t].[name] AS [table_name]
     , QUOTENAME([s].[name]) + '.' + QUOTENAME([t].[name]) AS [two_part_name]
     , [nt].[name] AS [node_table_name]
     , ROW_NUMBER() OVER ( PARTITION BY [nt].[name] ORDER BY( SELECT NULL )) AS [node_table_name_seq]
     , [tp].[distribution_policy_desc] AS [distribution_policy_name]
     , [c].[name] AS [distribution_column]
     , [nt].[distribution_id] AS [distribution_id]
     , [i].[type] AS [index_type]
     , [i].[type_desc] AS [index_type_desc]
     , [nt].[pdw_node_id] AS [pdw_node_id]
     , [pn].[type] AS [pdw_node_type]
     , [pn].[name] AS [pdw_node_name]
     , [di].[name] AS [dist_name]
     , [di].[position] AS [dist_position]
     , [nps].[partition_number] AS [partition_nmbr]
     , [nps].[reserved_page_count] AS [reserved_space_page_count]
     , [nps].[reserved_page_count] - [nps].[used_page_count] AS [unused_space_page_count]
     , [nps].[in_row_data_page_count] + [nps].[row_overflow_used_page_count] + [nps].[lob_used_page_count] AS [data_space_page_count]
     , [nps].[reserved_page_count] - ( [nps].[reserved_page_count] - [nps].[used_page_count] )
       - ( [in_row_data_page_count] + [row_overflow_used_page_count] + [lob_used_page_count] ) AS [index_space_page_count]
     , [nps].[row_count] AS [row_count]
   FROM [sys].[schemas] AS [s]
   INNER JOIN [sys].[tables] AS [t] ON [s].[schema_id] = [t].[schema_id]
   INNER JOIN [sys].[indexes] AS [i] ON [t].[object_id] = [i].[object_id] AND [i].[index_id] <= 1
   INNER JOIN [sys].[pdw_table_distribution_properties] AS [tp] ON [t].[object_id] = [tp].[object_id]
   INNER JOIN [sys].[pdw_table_mappings] AS [tm] ON [t].[object_id] = [tm].[object_id]
   INNER JOIN [sys].[pdw_nodes_tables] AS [nt] ON [tm].[physical_name] = [nt].[name]
   INNER JOIN [sys].[dm_pdw_nodes] AS [pn] ON [nt].[pdw_node_id] = [pn].[pdw_node_id]
   INNER JOIN [sys].[pdw_distributions] AS [di] ON [nt].[distribution_id] = [di].[distribution_id]
   INNER JOIN [sys].[dm_pdw_nodes_db_partition_stats] AS [nps] ON [nt].[object_id] = [nps].[object_id]
                                                              AND [nt].[pdw_node_id] = [nps].[pdw_node_id]
                                                              AND [nt].[distribution_id] = [nps].[distribution_id]
   LEFT OUTER JOIN( SELECT * FROM [sys].[pdw_column_distribution_properties] WHERE [distribution_ordinal] = 1 ) AS [cdp] ON [t].[object_id] = [cdp].[object_id]
   LEFT OUTER JOIN [sys].[columns] AS [c] ON [cdp].[object_id] = [c].[object_id] AND [cdp].[column_id] = [c].[column_id] )
   , [size]
AS ( SELECT
         [base].[execution_time]
       , [base].[database_name]
       , [schema_name]
       , [table_name]
       , [base].[two_part_name]
       , [node_table_name]
       , [base].[node_table_name_seq]
       , [distribution_policy_name]
       , [distribution_column]
       , [distribution_id]
       , [index_type]
       , [index_type_desc]
       , [pdw_node_id]
       , [pdw_node_type]
       , [pdw_node_name]
       , [dist_name]
       , [dist_position]
       , [partition_nmbr]
       , [reserved_space_page_count]
       , [base].[unused_space_page_count]
       , [base].[data_space_page_count]
       , [base].[index_space_page_count]
       , [row_count]
       , ( [reserved_space_page_count] * 8.0 ) AS [reserved_space_KB]
       , ( [reserved_space_page_count] * 8.0 ) / 1000 AS [reserved_space_MB]
       , ( [reserved_space_page_count] * 8.0 ) / 1000000 AS [reserved_space_GB]
       , ( [reserved_space_page_count] * 8.0 ) / 1000000000 AS [reserved_space_TB]
       , ( [base].[unused_space_page_count] * 8.0 ) AS [unused_space_KB]
       , ( [base].[unused_space_page_count] * 8.0 ) / 1000 AS [unused_space_MB]
       , ( [base].[unused_space_page_count] * 8.0 ) / 1000000 AS [unused_space_GB]
       , ( [base].[unused_space_page_count] * 8.0 ) / 1000000000 AS [unused_space_TB]
       , ( [base].[data_space_page_count] * 8.0 ) AS [data_space_KB]
       , ( [base].[data_space_page_count] * 8.0 ) / 1000 AS [data_space_MB]
       , ( [base].[data_space_page_count] * 8.0 ) / 1000000 AS [data_space_GB]
       , ( [base].[data_space_page_count] * 8.0 ) / 1000000000 AS [data_space_TB]
       , ( [base].[index_space_page_count] * 8.0 ) AS [index_space_KB]
       , ( [base].[index_space_page_count] * 8.0 ) / 1000 AS [index_space_MB]
       , ( [base].[index_space_page_count] * 8.0 ) / 1000000 AS [index_space_GB]
       , ( [base].[index_space_page_count] * 8.0 ) / 1000000000 AS [index_space_TB]
     FROM [base] )
SELECT *
FROM [size];
GO
