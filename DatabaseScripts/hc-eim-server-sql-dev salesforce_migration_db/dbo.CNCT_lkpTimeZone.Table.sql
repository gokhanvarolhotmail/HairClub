/****** Object:  Table [dbo].[CNCT_lkpTimeZone]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀䘀䘀ഀഀ
GO਍䌀刀䔀䄀吀䔀 䔀堀吀䔀刀一䄀䰀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䌀一䌀吀开氀欀瀀吀椀洀攀娀漀渀攀崀ഀഀ
(਍ऀ嬀吀椀洀攀娀漀渀攀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[TimeZoneSortOrder] [int] NULL,਍ऀ嬀吀椀洀攀娀漀渀攀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[TimeZoneDescriptionShort] [varchar](8000) NULL,਍ऀ嬀唀吀䌀伀昀昀猀攀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[UsesDayLightSavingsFlag] [bit] NULL,਍ऀ嬀䤀猀䄀挀琀椀瘀攀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[CreateDate] [datetime2](7) NULL,਍ऀ嬀䌀爀攀愀琀攀唀猀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LastUpdate] [datetime2](7) NULL,਍ऀ嬀䰀愀猀琀唀瀀搀愀琀攀唀猀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[UpdateStamp] [varbinary](8000) NULL਍⤀ഀഀ
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'Connect/TimeZone/History.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)਍䜀伀ഀഀ
