/****** Object:  Table [dbo].[Leads06232021]    Script Date: 3/7/2022 8:42:23 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀䘀䘀ഀഀ
GO਍䌀刀䔀䄀吀䔀 䔀堀吀䔀刀一䄀䰀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䰀攀愀搀猀　㘀㈀㌀㈀　㈀㄀崀ഀഀ
(਍ऀ嬀䰀攀愀搀䤀䐀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ExternalID] [varchar](8000) NULL,਍ऀ嬀䜀䌀䰀䤀䐀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[FirstName] [varchar](8000) NULL,਍ऀ嬀䰀愀猀琀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Email] [varchar](8000) NULL,਍ऀ嬀倀栀漀渀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Mobile] [varchar](8000) NULL,਍ऀ嬀䌀椀琀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[StateProvince] [varchar](8000) NULL,਍ऀ嬀娀椀瀀倀漀猀琀愀氀䌀漀搀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Country] [varchar](8000) NULL,਍ऀ嬀刀愀琀椀渀最崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadOwner] [varchar](8000) NULL,਍ऀ嬀䌀爀攀愀琀攀搀䈀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadRecordType] [varchar](8000) NULL,਍ऀ嬀䌀爀攀愀琀攀䐀愀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadStatus] [varchar](8000) NULL,਍ऀ嬀䌀漀渀瘀攀爀琀攀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[LeadSource] [varchar](8000) NULL,਍ऀ嬀圀攀戀猀椀琀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Gender] [varchar](8000) NULL,਍ऀ嬀䄀最攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Birthdate] [varchar](8000) NULL,਍ऀ嬀䔀琀栀渀椀挀椀琀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DoNotCall] [varchar](8000) NULL,਍ऀ嬀䐀漀一漀琀䌀漀渀琀愀挀琀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DoNotEmail] [varchar](8000) NULL,਍ऀ嬀䐀漀一漀琀䴀愀椀氀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DoNotText] [varchar](8000) NULL,਍ऀ嬀匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[PromoCode] [varchar](8000) NULL,਍ऀ嬀䐀一䌀嘀愀氀椀搀愀琀椀漀渀䴀漀戀椀氀攀倀栀漀渀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[DNCValidationPhone] [varchar](8000) NULL਍⤀ഀഀ
WITH (DATA_SOURCE = [filesystemeim_steimdatalakeprod2_dfs_core_windows_net],LOCATION = N'Leads Report-2021-06-24-13-39-49.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)਍䜀伀ഀഀ
