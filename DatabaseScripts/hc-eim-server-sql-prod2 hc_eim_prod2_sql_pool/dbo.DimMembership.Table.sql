/****** Object:  Table [dbo].[DimMembership]    Script Date: 3/7/2022 8:42:19 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䴀攀洀戀攀爀猀栀椀瀀崀ഀഀ
(਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀崀 嬀椀渀琀崀 䤀䐀䔀一吀䤀吀夀⠀㄀Ⰰ㄀⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[MembershipID] [int] NOT NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀一愀洀攀崀 嬀瘀愀爀挀栀愀爀崀⠀㈀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[MembershipShortName] [varchar](200) NULL,਍ऀ嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[BusinessSegmentID] [int] NOT NULL,਍ऀ嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[RevenueGroupID] [int] NOT NULL,਍ऀ嬀䜀攀渀搀攀爀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[GenderID] [varchar](100) NULL,਍ऀ嬀䐀甀爀愀琀椀漀渀䴀漀渀琀栀猀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ContractPrice] [decimal](18, 0) NULL,਍ऀ嬀䴀漀渀琀栀氀礀䘀攀攀崀 嬀搀攀挀椀洀愀氀崀⠀㄀㠀Ⰰ 　⤀ 一唀䰀䰀Ⰰഀഀ
	[IsTaxableFlag] [bit] NULL,਍ऀ嬀䤀猀䐀攀昀愀甀氀琀䴀攀洀戀攀爀猀栀椀瀀䘀氀愀最崀 嬀戀椀琀崀 一唀䰀䰀Ⰰഀഀ
	[IsActive] [bit] NULL,਍ऀ嬀䐀圀䠀开䌀爀攀愀琀攀搀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀Ⰰഀഀ
	[DWH_LastUpdateDate] [datetime] NULL,਍ऀ嬀匀漀甀爀挀攀匀礀猀琀攀洀崀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一伀吀 一唀䰀䰀Ⰰഀഀ
	[BusinessSegmentName] [nvarchar](200) NULL,਍ऀ嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀匀栀漀爀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[RevenueGroupName] [nvarchar](200) NULL,਍ऀ嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀匀栀漀爀琀一愀洀攀崀 嬀渀瘀愀爀挀栀愀爀崀⠀㄀　　⤀ 一唀䰀䰀Ⰰഀഀ
	[MembershipCreateDate] [datetime] NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀崀 嬀搀愀琀攀琀椀洀攀崀 一唀䰀䰀ഀഀ
)਍圀䤀吀䠀ഀഀ
(਍ऀ䐀䤀匀吀刀䤀䈀唀吀䤀伀一 㴀 刀䔀倀䰀䤀䌀䄀吀䔀Ⰰഀഀ
	CLUSTERED INDEX਍ऀ⠀ഀഀ
		[MembershipKey] ASC਍ऀ⤀ഀഀ
)਍䜀伀ഀഀ
