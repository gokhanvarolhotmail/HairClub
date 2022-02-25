/****** Object:  Table [dbo].[FactAppointment]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀崀ഀഀ
(਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[FactDate] [datetime] NULL,਍ऀ嬀䘀愀挀琀吀椀洀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[FactDateKey] [int] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentTimeKey] [int] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[LeadKey] [int] NULL,਍ऀ嬀䰀攀愀搀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountKey] [int] NULL,਍ऀ嬀䄀挀挀漀甀渀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[ContactKey] [int] NULL,਍ऀ嬀䌀漀渀琀愀挀琀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[ParentRecordType] [nvarchar](2048) NULL,਍ऀ嬀圀漀爀欀吀礀瀀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[WorkTypeId] [nvarchar](2048) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䄀搀搀爀攀猀猀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountCity] [nvarchar](2048) NULL,਍ऀ嬀䄀挀挀漀甀渀琀匀琀愀琀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[AccountPostalCode] [nvarchar](250) NULL,਍ऀ嬀䄀挀挀漀甀渀琀䌀漀甀渀琀爀礀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[GeographyKey] [int] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀攀猀挀爀椀瀀琀椀漀渀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㐀　　　⤀ 一唀䰀䰀Ⰰഀഀ
	[AppointmentStatus] [nvarchar](2048) NULL,਍ऀ嬀䌀攀渀琀攀爀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ServiceTerritoryId] [nvarchar](2048) NULL,਍ऀ嬀䌀攀渀琀攀爀一甀洀戀攀爀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentTypeKey] [int] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀吀礀瀀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[AppointmentCenterType] [nvarchar](2048) NULL,਍ऀ嬀䔀砀琀攀爀渀愀氀䤀搀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[ServiceAppointment] [nvarchar](2048) NULL,਍ऀ嬀䴀攀攀琀椀渀最倀氀愀琀昀漀爀洀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[MeetingPlatformId] [nvarchar](2048) NULL,਍ऀ嬀䴀攀攀琀椀渀最倀氀愀琀昀漀爀洀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　㐀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[DWH_LoadDate] [datetime] NULL,਍ऀ嬀䐀圀䠀开䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[SourceSystem] [nvarchar](2048) NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[BeBackFlag] [bit] NULL,਍ऀ嬀䤀猀伀氀搀崀 嬀椀渀琀崀 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀伀唀一䐀开刀伀䈀䤀一Ⰰഀഀ
	CLUSTERED COLUMNSTORE INDEX਍⤀ഀഀ
GO਍
