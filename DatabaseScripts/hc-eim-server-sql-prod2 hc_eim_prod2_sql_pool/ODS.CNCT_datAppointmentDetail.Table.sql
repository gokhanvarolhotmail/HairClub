/****** Object:  Table [ODS].[CNCT_datAppointmentDetail]    Script Date: 2/22/2022 9:20:31 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䄀瀀瀀漀椀渀琀洀攀渀琀䐀攀琀愀椀氀崀ഀഀ
(਍ऀ嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀攀琀愀椀氀䜀唀䤀䐀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentGUID] [uniqueidentifier] NULL,਍ऀ嬀匀愀氀攀猀䌀漀搀攀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[AppointmentDetailDuration] [int] NULL,਍ऀ嬀䌀爀攀愀琀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[CreateUser] [nvarchar](50) NULL,਍ऀ嬀䰀愀猀琀唀瀀搀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[LastUpdateUser] [nvarchar](50) NULL,਍ऀ嬀儀甀愀渀琀椀琀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[Price] [money] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = HASH ( [AppointmentGUID] ),਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
)਍䜀伀ഀഀ
