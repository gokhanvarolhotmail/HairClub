/****** Object:  Table [ODS].[Leads_HC_BI_Temp]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀䘀䘀ഀഀ
GO਍䌀刀䔀䄀吀䔀 䔀堀吀䔀刀一䄀䰀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀䰀攀愀搀猀开䠀䌀开䈀䤀开吀攀洀瀀崀ഀഀ
(਍ऀ嬀爀攀愀氀琀椀洀攀嘀愀氀椀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Leads] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀䤀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CubeAgencyOwnerType] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀䌀爀攀愀琀椀漀渀䐀愀琀攀䬀攀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CampaignAgency] [varchar](8000) NULL,਍ऀ嬀倀栀漀渀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[MobilePhone] [varchar](8000) NULL,਍ऀ嬀䔀洀愀椀氀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadActivityStatusc] [varchar](8000) NULL,਍ऀ嬀䰀愀猀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FirstName] [varchar](8000) NULL,਍ऀ嬀䰀攀愀搀匀漀甀爀挀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Status] [varchar](8000) NULL਍⤀ഀഀ
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'LeadValidation/leads05122021.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)਍䜀伀ഀഀ
