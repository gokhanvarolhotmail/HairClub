/****** Object:  Table [ODS].[MA_TargetsTemp]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀䘀䘀ഀഀ
GO਍䌀刀䔀䄀吀䔀 䔀堀吀䔀刀一䄀䰀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀䴀䄀开吀愀爀最攀琀猀吀攀洀瀀崀ഀഀ
(਍ऀ嬀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Month] [varchar](8000) NULL,਍ऀ嬀䈀甀搀最攀琀吀礀瀀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Agency] [varchar](8000) NULL,਍ऀ嬀䌀栀愀渀渀攀氀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Medium] [varchar](8000) NULL,਍ऀ嬀匀漀甀爀挀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Budget] [varchar](8000) NULL,਍ऀ嬀䰀漀挀愀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[BudgetAmount] [varchar](8000) NULL,਍ऀ嬀吀愀爀攀最攀琀开䰀攀愀搀猀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CurrencyConversion] [varchar](8000) NULL਍⤀ഀഀ
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'MarketingAgencies/ManualUpload/Targets/Hairclub Budget Template - May - 20210504.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)਍䜀伀ഀഀ
