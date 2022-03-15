/****** Object:  Table [ODS].[CNCT_datAppointment]    Script Date: 3/7/2022 8:42:19 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䄀瀀瀀漀椀渀琀洀攀渀琀崀ഀഀ
(਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䜀唀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[AppointmentID_Temp] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀䜀唀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipGUID] [uniqueidentifier] NULL,਍ऀ嬀倀愀爀攀渀琀䄀瀀瀀漀椀渀琀洀攀渀琀䜀唀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[CenterID] [int] NULL,਍ऀ嬀䌀氀椀攀渀琀䠀漀洀攀䌀攀渀琀攀爀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ResourceID] [int] NULL,਍ऀ嬀䌀漀渀昀椀爀洀愀琀椀漀渀吀礀瀀攀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentTypeID] [int] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[StartTime] [time](0) NULL,਍ऀ嬀䔀渀搀吀椀洀攀崀 嬀琀椀洀攀崀⠀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CheckinTime] [datetime] NULL,਍ऀ嬀䌀栀攀挀欀漀甀琀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentSubject] [nvarchar](500) NULL,਍ऀ嬀䌀愀渀倀爀椀渀琀䌀漀洀洀攀渀琀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsNonAppointmentFlag] [bit] NULL,਍ऀ嬀刀攀挀甀爀爀攀渀挀攀刀甀氀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　㈀㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[StartDateTimeCalc] [datetime] NULL,਍ऀ嬀䔀渀搀䐀愀琀攀吀椀洀攀䌀愀氀挀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentDurationCalc] [time](0) NULL,਍ऀ嬀䌀爀攀愀琀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[CreateUser] [nvarchar](25) NULL,਍ऀ嬀䰀愀猀琀唀瀀搀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[LastUpdateUser] [nvarchar](25) NULL,਍ऀ嬀唀瀀搀愀琀攀匀琀愀洀瀀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀⤀ 一唀䰀䰀Ⰰഀഀ
	[AppointmentStatusID] [int] NULL,਍ऀ嬀䤀猀䐀攀氀攀琀攀搀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[OnContactActivityID] [nchar](10) NULL,਍ऀ嬀伀渀䌀漀渀琀愀挀琀䌀漀渀琀愀挀琀䤀䐀崀 嬀渀挀栀愀爀崀⠀㄀　⤀ 一唀䰀䰀Ⰰഀഀ
	[CheckedInFlag] [bit] NULL,਍ऀ嬀䤀猀䄀甀琀栀漀爀椀稀攀搀䘀氀愀最崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[LastChangeUser] [nvarchar](25) NOT NULL,਍ऀ嬀䰀愀猀琀䌀栀愀渀最攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ScalpHealthID] [int] NULL,਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀倀爀椀漀爀椀琀礀䌀漀氀漀爀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CompletedVisitTypeID] [int] NULL,਍ऀ嬀䤀猀䘀甀氀氀吀爀椀挀栀漀嘀椀攀眀崀 嬀戀椀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[SalesforceContactID] [nvarchar](18) NULL,਍ऀ嬀匀愀氀攀猀昀漀爀挀攀吀愀猀欀䤀䐀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀㠀⤀ 一唀䰀䰀Ⰰഀഀ
	[KorvueID] [int] NULL,਍ऀ嬀匀攀爀瘀椀挀攀匀琀愀爀琀吀椀洀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[ServiceEndTime] [datetime] NULL,਍ऀ嬀䤀猀䌀氀椀攀渀琀䌀漀渀琀愀挀琀䤀渀昀漀爀洀愀琀椀漀渀䌀漀渀昀椀爀洀攀搀崀 嬀戀椀琀崀 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 䠀䄀匀䠀 ⠀ 嬀匀愀氀攀猀昀漀爀挀攀吀愀猀欀䤀䐀崀 ⤀Ⰰഀഀ
	CLUSTERED COLUMNSTORE INDEX਍⤀ഀഀ
GO਍
