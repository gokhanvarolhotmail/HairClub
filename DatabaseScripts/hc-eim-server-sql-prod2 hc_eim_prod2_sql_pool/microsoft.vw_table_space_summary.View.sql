/****** Object:  View [microsoft].[vw_table_space_summary]    Script Date: 2/22/2022 9:20:31 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀洀椀挀爀漀猀漀昀琀崀⸀嬀瘀眀开琀愀戀氀攀开猀瀀愀挀攀开猀甀洀洀愀爀礀崀ഀഀ
AS SELECT਍    搀愀琀愀戀愀猀攀开渀愀洀攀ഀഀ
    , schema_name਍    Ⰰ 琀愀戀氀攀开渀愀洀攀ഀഀ
    , distribution_policy_name਍    Ⰰ 搀椀猀琀爀椀戀甀琀椀漀渀开挀漀氀甀洀渀ഀഀ
    , index_type_desc਍    Ⰰ 䌀伀唀一吀⠀搀椀猀琀椀渀挀琀 瀀愀爀琀椀琀椀漀渀开渀洀戀爀⤀ 䄀匀 嬀渀戀爀开瀀愀爀琀椀琀椀漀渀猀崀ഀഀ
    , SUM(row_count)                 AS [table_row_count]਍    Ⰰ 匀唀䴀⠀爀攀猀攀爀瘀攀搀开猀瀀愀挀攀开䜀䈀⤀         䄀匀 嬀琀愀戀氀攀开爀攀猀攀爀瘀攀搀开猀瀀愀挀攀开䜀䈀崀ഀഀ
    , SUM(data_space_GB)             AS [table_data_space_GB]਍    Ⰰ 匀唀䴀⠀椀渀搀攀砀开猀瀀愀挀攀开䜀䈀⤀            䄀匀 嬀琀愀戀氀攀开椀渀搀攀砀开猀瀀愀挀攀开䜀䈀崀ഀഀ
    , SUM(unused_space_GB)           AS [table_unused_space_GB]਍䘀刀伀䴀ഀഀ
    microsoft.vw_table_sizes਍䜀刀伀唀倀 䈀夀ഀഀ
    database_name਍    Ⰰ 猀挀栀攀洀愀开渀愀洀攀ഀഀ
    , table_name਍    Ⰰ 搀椀猀琀爀椀戀甀琀椀漀渀开瀀漀氀椀挀礀开渀愀洀攀ഀഀ
    , distribution_column਍    Ⰰ 椀渀搀攀砀开琀礀瀀攀开搀攀猀挀㬀ഀഀ
GO਍
