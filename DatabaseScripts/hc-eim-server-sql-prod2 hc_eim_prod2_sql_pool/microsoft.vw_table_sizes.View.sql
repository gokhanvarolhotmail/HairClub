/****** Object:  View [microsoft].[vw_table_sizes]    Script Date: 3/7/2022 8:42:19 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀洀椀挀爀漀猀漀昀琀崀⸀嬀瘀眀开琀愀戀氀攀开猀椀稀攀猀崀ഀഀ
AS WITH [base]਍䄀匀 ⠀ഀഀ
   SELECT਍       䜀䔀吀䐀䄀吀䔀⠀⤀ 䄀匀 嬀攀砀攀挀甀琀椀漀渀开琀椀洀攀崀ഀഀ
     , DB_NAME() AS [database_name]਍     Ⰰ 嬀猀崀⸀嬀渀愀洀攀崀 䄀匀 嬀猀挀栀攀洀愀开渀愀洀攀崀ഀഀ
     , [t].[name] AS [table_name]਍     Ⰰ 儀唀伀吀䔀一䄀䴀䔀⠀嬀猀崀⸀嬀渀愀洀攀崀⤀ ⬀ ✀⸀✀ ⬀ 儀唀伀吀䔀一䄀䴀䔀⠀嬀琀崀⸀嬀渀愀洀攀崀⤀ 䄀匀 嬀琀眀漀开瀀愀爀琀开渀愀洀攀崀ഀഀ
     , [nt].[name] AS [node_table_name]਍     Ⰰ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 倀䄀刀吀䤀吀䤀伀一 䈀夀 嬀渀琀崀⸀嬀渀愀洀攀崀 伀刀䐀䔀刀 䈀夀⠀ 匀䔀䰀䔀䌀吀 一唀䰀䰀 ⤀⤀ 䄀匀 嬀渀漀搀攀开琀愀戀氀攀开渀愀洀攀开猀攀焀崀ഀഀ
     , [tp].[distribution_policy_desc] AS [distribution_policy_name]਍     Ⰰ 嬀挀崀⸀嬀渀愀洀攀崀 䄀匀 嬀搀椀猀琀爀椀戀甀琀椀漀渀开挀漀氀甀洀渀崀ഀഀ
     , [nt].[distribution_id] AS [distribution_id]਍     Ⰰ 嬀椀崀⸀嬀琀礀瀀攀崀 䄀匀 嬀椀渀搀攀砀开琀礀瀀攀崀ഀഀ
     , [i].[type_desc] AS [index_type_desc]਍     Ⰰ 嬀渀琀崀⸀嬀瀀搀眀开渀漀搀攀开椀搀崀 䄀匀 嬀瀀搀眀开渀漀搀攀开椀搀崀ഀഀ
     , [pn].[type] AS [pdw_node_type]਍     Ⰰ 嬀瀀渀崀⸀嬀渀愀洀攀崀 䄀匀 嬀瀀搀眀开渀漀搀攀开渀愀洀攀崀ഀഀ
     , [di].[name] AS [dist_name]਍     Ⰰ 嬀搀椀崀⸀嬀瀀漀猀椀琀椀漀渀崀 䄀匀 嬀搀椀猀琀开瀀漀猀椀琀椀漀渀崀ഀഀ
     , [nps].[partition_number] AS [partition_nmbr]਍     Ⰰ 嬀渀瀀猀崀⸀嬀爀攀猀攀爀瘀攀搀开瀀愀最攀开挀漀甀渀琀崀 䄀匀 嬀爀攀猀攀爀瘀攀搀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀ഀഀ
     , [nps].[reserved_page_count] - [nps].[used_page_count] AS [unused_space_page_count]਍     Ⰰ 嬀渀瀀猀崀⸀嬀椀渀开爀漀眀开搀愀琀愀开瀀愀最攀开挀漀甀渀琀崀 ⬀ 嬀渀瀀猀崀⸀嬀爀漀眀开漀瘀攀爀昀氀漀眀开甀猀攀搀开瀀愀最攀开挀漀甀渀琀崀 ⬀ 嬀渀瀀猀崀⸀嬀氀漀戀开甀猀攀搀开瀀愀最攀开挀漀甀渀琀崀 䄀匀 嬀搀愀琀愀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀ഀഀ
     , [nps].[reserved_page_count] - ( [nps].[reserved_page_count] - [nps].[used_page_count] )਍       ⴀ ⠀ 嬀椀渀开爀漀眀开搀愀琀愀开瀀愀最攀开挀漀甀渀琀崀 ⬀ 嬀爀漀眀开漀瘀攀爀昀氀漀眀开甀猀攀搀开瀀愀最攀开挀漀甀渀琀崀 ⬀ 嬀氀漀戀开甀猀攀搀开瀀愀最攀开挀漀甀渀琀崀 ⤀ 䄀匀 嬀椀渀搀攀砀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀ഀഀ
     , [nps].[row_count] AS [row_count]਍   䘀刀伀䴀 嬀猀礀猀崀⸀嬀猀挀栀攀洀愀猀崀 䄀匀 嬀猀崀ഀഀ
   INNER JOIN [sys].[tables] AS [t] ON [s].[schema_id] = [t].[schema_id]਍   䤀一一䔀刀 䨀伀䤀一 嬀猀礀猀崀⸀嬀椀渀搀攀砀攀猀崀 䄀匀 嬀椀崀 伀一 嬀琀崀⸀嬀漀戀樀攀挀琀开椀搀崀 㴀 嬀椀崀⸀嬀漀戀樀攀挀琀开椀搀崀 䄀一䐀 嬀椀崀⸀嬀椀渀搀攀砀开椀搀崀 㰀㴀 ㄀ഀഀ
   INNER JOIN [sys].[pdw_table_distribution_properties] AS [tp] ON [t].[object_id] = [tp].[object_id]਍   䤀一一䔀刀 䨀伀䤀一 嬀猀礀猀崀⸀嬀瀀搀眀开琀愀戀氀攀开洀愀瀀瀀椀渀最猀崀 䄀匀 嬀琀洀崀 伀一 嬀琀崀⸀嬀漀戀樀攀挀琀开椀搀崀 㴀 嬀琀洀崀⸀嬀漀戀樀攀挀琀开椀搀崀ഀഀ
   INNER JOIN [sys].[pdw_nodes_tables] AS [nt] ON [tm].[physical_name] = [nt].[name]਍   䤀一一䔀刀 䨀伀䤀一 嬀猀礀猀崀⸀嬀搀洀开瀀搀眀开渀漀搀攀猀崀 䄀匀 嬀瀀渀崀 伀一 嬀渀琀崀⸀嬀瀀搀眀开渀漀搀攀开椀搀崀 㴀 嬀瀀渀崀⸀嬀瀀搀眀开渀漀搀攀开椀搀崀ഀഀ
   INNER JOIN [sys].[pdw_distributions] AS [di] ON [nt].[distribution_id] = [di].[distribution_id]਍   䤀一一䔀刀 䨀伀䤀一 嬀猀礀猀崀⸀嬀搀洀开瀀搀眀开渀漀搀攀猀开搀戀开瀀愀爀琀椀琀椀漀渀开猀琀愀琀猀崀 䄀匀 嬀渀瀀猀崀 伀一 嬀渀琀崀⸀嬀漀戀樀攀挀琀开椀搀崀 㴀 嬀渀瀀猀崀⸀嬀漀戀樀攀挀琀开椀搀崀ഀഀ
                                                              AND [nt].[pdw_node_id] = [nps].[pdw_node_id]਍                                                              䄀一䐀 嬀渀琀崀⸀嬀搀椀猀琀爀椀戀甀琀椀漀渀开椀搀崀 㴀 嬀渀瀀猀崀⸀嬀搀椀猀琀爀椀戀甀琀椀漀渀开椀搀崀ഀഀ
   LEFT OUTER JOIN( SELECT * FROM [sys].[pdw_column_distribution_properties] WHERE [distribution_ordinal] = 1 ) AS [cdp] ON [t].[object_id] = [cdp].[object_id]਍   䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀猀礀猀崀⸀嬀挀漀氀甀洀渀猀崀 䄀匀 嬀挀崀 伀一 嬀挀搀瀀崀⸀嬀漀戀樀攀挀琀开椀搀崀 㴀 嬀挀崀⸀嬀漀戀樀攀挀琀开椀搀崀 䄀一䐀 嬀挀搀瀀崀⸀嬀挀漀氀甀洀渀开椀搀崀 㴀 嬀挀崀⸀嬀挀漀氀甀洀渀开椀搀崀 ⤀ഀഀ
   , [size]਍䄀匀 ⠀ 匀䔀䰀䔀䌀吀ഀഀ
         [base].[execution_time]਍       Ⰰ 嬀戀愀猀攀崀⸀嬀搀愀琀愀戀愀猀攀开渀愀洀攀崀ഀഀ
       , [schema_name]਍       Ⰰ 嬀琀愀戀氀攀开渀愀洀攀崀ഀഀ
       , [base].[two_part_name]਍       Ⰰ 嬀渀漀搀攀开琀愀戀氀攀开渀愀洀攀崀ഀഀ
       , [base].[node_table_name_seq]਍       Ⰰ 嬀搀椀猀琀爀椀戀甀琀椀漀渀开瀀漀氀椀挀礀开渀愀洀攀崀ഀഀ
       , [distribution_column]਍       Ⰰ 嬀搀椀猀琀爀椀戀甀琀椀漀渀开椀搀崀ഀഀ
       , [index_type]਍       Ⰰ 嬀椀渀搀攀砀开琀礀瀀攀开搀攀猀挀崀ഀഀ
       , [pdw_node_id]਍       Ⰰ 嬀瀀搀眀开渀漀搀攀开琀礀瀀攀崀ഀഀ
       , [pdw_node_name]਍       Ⰰ 嬀搀椀猀琀开渀愀洀攀崀ഀഀ
       , [dist_position]਍       Ⰰ 嬀瀀愀爀琀椀琀椀漀渀开渀洀戀爀崀ഀഀ
       , [reserved_space_page_count]਍       Ⰰ 嬀戀愀猀攀崀⸀嬀甀渀甀猀攀搀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀ഀഀ
       , [base].[data_space_page_count]਍       Ⰰ 嬀戀愀猀攀崀⸀嬀椀渀搀攀砀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀ഀഀ
       , [row_count]਍       Ⰰ ⠀ 嬀爀攀猀攀爀瘀攀搀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀 ⨀ 㠀⸀　 ⤀ 䄀匀 嬀爀攀猀攀爀瘀攀搀开猀瀀愀挀攀开䬀䈀崀ഀഀ
       , ( [reserved_space_page_count] * 8.0 ) / 1000 AS [reserved_space_MB]਍       Ⰰ ⠀ 嬀爀攀猀攀爀瘀攀搀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀 ⨀ 㠀⸀　 ⤀ ⼀ ㄀　　　　　　 䄀匀 嬀爀攀猀攀爀瘀攀搀开猀瀀愀挀攀开䜀䈀崀ഀഀ
       , ( [reserved_space_page_count] * 8.0 ) / 1000000000 AS [reserved_space_TB]਍       Ⰰ ⠀ 嬀戀愀猀攀崀⸀嬀甀渀甀猀攀搀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀 ⨀ 㠀⸀　 ⤀ 䄀匀 嬀甀渀甀猀攀搀开猀瀀愀挀攀开䬀䈀崀ഀഀ
       , ( [base].[unused_space_page_count] * 8.0 ) / 1000 AS [unused_space_MB]਍       Ⰰ ⠀ 嬀戀愀猀攀崀⸀嬀甀渀甀猀攀搀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀 ⨀ 㠀⸀　 ⤀ ⼀ ㄀　　　　　　 䄀匀 嬀甀渀甀猀攀搀开猀瀀愀挀攀开䜀䈀崀ഀഀ
       , ( [base].[unused_space_page_count] * 8.0 ) / 1000000000 AS [unused_space_TB]਍       Ⰰ ⠀ 嬀戀愀猀攀崀⸀嬀搀愀琀愀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀 ⨀ 㠀⸀　 ⤀ 䄀匀 嬀搀愀琀愀开猀瀀愀挀攀开䬀䈀崀ഀഀ
       , ( [base].[data_space_page_count] * 8.0 ) / 1000 AS [data_space_MB]਍       Ⰰ ⠀ 嬀戀愀猀攀崀⸀嬀搀愀琀愀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀 ⨀ 㠀⸀　 ⤀ ⼀ ㄀　　　　　　 䄀匀 嬀搀愀琀愀开猀瀀愀挀攀开䜀䈀崀ഀഀ
       , ( [base].[data_space_page_count] * 8.0 ) / 1000000000 AS [data_space_TB]਍       Ⰰ ⠀ 嬀戀愀猀攀崀⸀嬀椀渀搀攀砀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀 ⨀ 㠀⸀　 ⤀ 䄀匀 嬀椀渀搀攀砀开猀瀀愀挀攀开䬀䈀崀ഀഀ
       , ( [base].[index_space_page_count] * 8.0 ) / 1000 AS [index_space_MB]਍       Ⰰ ⠀ 嬀戀愀猀攀崀⸀嬀椀渀搀攀砀开猀瀀愀挀攀开瀀愀最攀开挀漀甀渀琀崀 ⨀ 㠀⸀　 ⤀ ⼀ ㄀　　　　　　 䄀匀 嬀椀渀搀攀砀开猀瀀愀挀攀开䜀䈀崀ഀഀ
       , ( [base].[index_space_page_count] * 8.0 ) / 1000000000 AS [index_space_TB]਍     䘀刀伀䴀 嬀戀愀猀攀崀 ⤀ഀഀ
SELECT *਍䘀刀伀䴀 嬀猀椀稀攀崀㬀ഀഀ
GO਍
