/****** Object:  Table [dbo].[DimCustomerMembership]    Script Date: 3/7/2022 8:42:19 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀崀ഀഀ
(਍ऀ嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CustomerMembershipID] [nvarchar](200) NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CustomerID] [nvarchar](200) NULL,਍ऀ嬀䌀攀渀琀攀爀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[CenterID] [int] NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[MembershipID] [int] NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀䤀䐀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[CustomerMembershipStatusName] [nvarchar](200) NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀一愀洀攀匀栀漀爀琀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[Member1_ID_Temp] [int] NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀䌀漀渀琀爀愀挀琀倀爀椀挀攀崀 嬀渀甀洀攀爀椀挀崀⠀㄀㤀Ⰰ 㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[CustomerMembershipContractPaidAmount] [numeric](19, 4) NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀䴀漀渀琀栀氀礀䘀攀攀崀 嬀渀甀洀攀爀椀挀崀⠀㄀㤀Ⰰ 㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[CustomerMembershipBeginDateKey] [int] NOT NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀䈀攀最椀渀䐀愀琀攀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[CustomerMembershipEndDateKey] [int] NOT NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀䔀渀搀䐀愀琀攀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[CustomerMembershipCancelDateKey] [int] NOT NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀䌀愀渀挀攀氀䐀愀琀攀崀 嬀搀愀琀攀崀 一唀䰀䰀Ⰰഀഀ
	[CustomerMembershipCancelReasonID] [int] NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀䌀愀渀挀攀氀刀攀愀猀漀渀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[CustomerMembershipIdentifier] [nvarchar](200) NULL,਍ऀ嬀一愀琀椀漀渀愀氀䴀漀渀琀栀氀礀䘀攀攀崀 嬀渀甀洀攀爀椀挀崀⠀㄀㤀Ⰰ 㐀⤀ 一唀䰀䰀Ⰰഀഀ
	[CustomerMembershipCreateDate] [datetime] NULL,਍ऀ嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[IsActive] [bit] NULL,਍ऀ嬀䐀圀䠀开䰀漀愀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[DWH_LastUpdateDate] [datetime] NULL,਍ऀ嬀匀漀甀爀挀攀匀礀猀琀攀洀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一伀吀 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀䔀倀䰀䤀䌀䄀吀䔀Ⰰഀഀ
	CLUSTERED INDEX਍ऀ⠀ഀഀ
		[CustomerMembershipKey] ASC਍ऀ⤀ഀഀ
)਍䜀伀ഀഀ
