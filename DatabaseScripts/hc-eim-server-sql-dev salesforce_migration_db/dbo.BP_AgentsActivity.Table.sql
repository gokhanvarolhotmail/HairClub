/****** Object:  Table [dbo].[BP_AgentsActivity]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀䘀䘀ഀഀ
GO਍䌀刀䔀䄀吀䔀 䔀堀吀䔀刀一䄀䰀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䈀倀开䄀最攀渀琀猀䄀挀琀椀瘀椀琀礀崀ഀഀ
(਍ऀ嬀椀搀崀 嬀瘀愀爀戀椀渀愀爀礀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[pkid] [int] NULL,਍ऀ嬀愀挀琀椀瘀椀琀礀开椀搀崀 嬀瘀愀爀戀椀渀愀爀礀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[login_id] [varchar](8000) NULL,਍ऀ嬀昀椀爀猀琀开渀愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[last_name] [varchar](8000) NULL,਍ऀ嬀琀攀愀洀开渀愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[agent_country] [varchar](8000) NULL,਍ऀ嬀愀最攀渀琀开挀椀琀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[rank] [varchar](8000) NULL,਍ऀ嬀愀最最开爀甀渀开椀搀崀 嬀瘀愀爀戀椀渀愀爀礀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[start_time] [datetime2](7) NULL,਍ऀ嬀愀挀琀椀瘀椀琀礀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[duration] [bigint] NULL,਍ऀ嬀搀攀琀愀椀氀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[pending_time] [bigint] NULL,਍ऀ嬀琀愀氀欀开琀椀洀攀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[hold_time] [bigint] NULL,਍ऀ嬀栀攀氀搀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[max_hold] [bigint] NULL,਍ऀ嬀愀挀眀开琀椀洀攀崀 嬀戀椀最椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[service_name] [varchar](8000) NULL,਍ऀ嬀漀爀椀最椀渀愀琀椀漀渀开渀甀洀戀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[destination_number] [varchar](8000) NULL,਍ऀ嬀攀砀琀攀爀渀愀氀开渀甀洀戀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[other_party_phone_type] [varchar](8000) NULL,਍ऀ嬀搀椀猀瀀漀猀椀琀椀漀渀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[agent_disposition_name] [varchar](8000) NULL,਍ऀ嬀愀最攀渀琀开搀椀猀瀀漀猀椀琀椀漀渀开挀漀搀攀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[agent_disposition_notes] [varchar](8000) NULL,਍ऀ嬀猀攀猀猀椀漀渀开椀搀崀 嬀瘀愀爀戀椀渀愀爀礀崀⠀洀愀砀⤀ 一唀䰀䰀Ⰰഀഀ
	[media_type] [varchar](8000) NULL,਍ऀ嬀挀愀猀攀开渀甀洀戀攀爀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[email_completion_time] [bigint] NULL,਍ऀ嬀眀漀爀欀椀琀攀洀开椀搀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[call_detail_id] [varbinary](max) NULL,਍ऀ嬀栀愀猀开猀挀爀攀攀渀开爀攀挀漀爀搀椀渀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[cobrowsing] [bit] NULL,਍ऀ嬀挀甀猀琀漀洀㄀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[custom2] [varchar](8000) NULL,਍ऀ嬀挀甀猀琀漀洀㌀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[custom4] [varchar](8000) NULL,਍ऀ嬀挀甀猀琀漀洀㔀崀 嬀瘀愀爀挀栀愀爀崀⠀㠀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[ip_address] [varchar](8000) NULL਍⤀ഀഀ
WITH (DATA_SOURCE = [hc-eim-filesystem-prod_hceimdlakeprod_dfs_core_windows_net],LOCATION = N'Brightpattern/AgentActivity/History.parquet',FILE_FORMAT = [SynapseParquetFormat],REJECT_TYPE = VALUE,REJECT_VALUE = 0)਍䜀伀ഀഀ
