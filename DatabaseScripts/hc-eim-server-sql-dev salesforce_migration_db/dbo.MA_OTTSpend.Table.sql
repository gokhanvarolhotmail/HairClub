/****** Object:  Table [dbo].[MA_OTTSpend]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀䘀䘀ഀഀ
GO਍䌀刀䔀䄀吀䔀 䔀堀吀䔀刀一䄀䰀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䴀䄀开伀吀吀匀瀀攀渀搀崀ഀഀ
(਍ऀ嬀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Advertiser] [varchar](8000) NULL,਍ऀ嬀䄀搀瘀攀爀琀椀猀攀爀䌀甀爀爀攀渀挀礀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Campaign] [varchar](8000) NULL,਍ऀ嬀䄀搀䜀爀漀甀瀀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Creative] [varchar](8000) NULL,਍ऀ嬀䤀洀瀀爀攀猀猀椀漀渀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CNSpend] [varchar](8000) NULL਍⤀ഀഀ
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'MarketingAgencies/ManualUpload/3222021/Hair Club Spend 03.22.21.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)਍䜀伀ഀഀ
