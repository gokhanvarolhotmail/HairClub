/****** Object:  Table [dbo].[FactSalesTransaction]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀搀戀漀崀⸀嬀䘀愀挀琀匀愀氀攀猀吀爀愀渀猀愀挀琀椀漀渀崀ഀഀ
(਍ऀ嬀伀爀搀攀爀䐀愀琀攀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[SalesOrderKey] [int] NOT NULL,਍ऀ嬀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[SalesOrderTypeKey] [int] NOT NULL,਍ऀ嬀䌀攀渀琀攀爀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ClientKey] [int] NOT NULL,਍ऀ嬀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[ClientMembershipKey] [int] NOT NULL,਍ऀ嬀匀愀氀攀猀䌀漀搀攀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Employee1Key] [int] NOT NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㈀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Employee3Key] [int] NOT NULL,਍ऀ嬀䔀洀瀀氀漀礀攀攀㐀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[Quantity] [int] NULL,਍ऀ嬀倀爀椀挀攀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[Discount] [money] NULL,਍ऀ嬀䔀砀琀攀渀搀攀搀倀爀椀挀攀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[Tax1] [money] NULL,਍ऀ嬀吀愀砀㈀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[TaxRate1] [money] NULL,਍ऀ嬀吀愀砀刀愀琀攀㈀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[ExtendedPricePlusTax] [money] NULL,਍ऀ嬀吀漀琀愀氀吀愀砀䄀洀漀甀渀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[InsertAuditKey] [int] NULL,਍ऀ嬀唀瀀搀愀琀攀䄀甀搀椀琀䬀攀礀崀 嬀椀渀琀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[RowTimeStamp] [datetime] NOT NULL,਍ऀ嬀洀猀爀攀瀀氀开琀爀愀渀开瘀攀爀猀椀漀渀崀 嬀甀渀椀焀甀攀椀搀攀渀琀椀昀椀攀爀崀 一伀吀 一唀䰀䰀Ⰰഀഀ
	[IsClosed] [tinyint] NULL,਍ऀ嬀䤀猀嘀漀椀搀攀搀崀 嬀琀椀渀礀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[ContactKey] [int] NULL,਍ऀ嬀匀漀甀爀挀攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[GenderKey] [int] NULL,਍ऀ嬀伀挀挀甀瀀愀琀椀漀渀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[EthnicityKey] [int] NULL,਍ऀ嬀䴀愀爀椀琀愀氀匀琀愀琀甀猀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[HairLossTypeKey] [int] NULL,਍ऀ嬀䄀最攀刀愀渀最攀䬀攀礀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[PromotionCodeKey] [int] NULL,਍ऀ嬀匀㄀开匀愀氀攀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[S_CancelCnt] [int] NULL,਍ऀ嬀匀㄀开一攀琀匀愀氀攀猀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[S1_NetSalesAmt] [money] NULL,਍ऀ嬀匀㄀开䌀漀渀琀爀愀挀琀䄀洀漀甀渀琀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[S1_EstGraftsCnt] [int] NULL,਍ऀ嬀匀㄀开䔀猀琀倀攀爀䜀爀愀昀琀猀䄀洀琀崀 嬀昀氀漀愀琀崀 一唀䰀䰀Ⰰഀഀ
	[SA_NetSalesCnt] [int] NULL,਍ऀ嬀匀䄀开一攀琀匀愀氀攀猀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[SA_ContractAmountAmt] [money] NULL,਍ऀ嬀匀䄀开䔀猀琀䜀爀愀昀琀猀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[SA_EstPerGraftAmt] [float] NULL,਍ऀ嬀匀开倀漀猀琀䔀砀琀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[S_PostExtAmt] [money] NULL,਍ऀ嬀匀开匀甀爀最攀爀礀倀攀爀昀漀爀洀攀搀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[S_SurgeryPerformedAmt] [money] NULL,਍ऀ嬀匀开匀甀爀最攀爀礀䜀爀愀昀琀猀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[S1_DepositsTakenCnt] [int] NULL,਍ऀ嬀匀㄀开䐀攀瀀漀猀椀琀猀吀愀欀攀渀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[NB_GrossNB1Cnt] [int] NULL,਍ऀ嬀一䈀开吀爀愀搀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NB_TradAmt] [money] NULL,਍ऀ嬀一䈀开䜀爀愀搀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NB_GradAmt] [money] NULL,਍ऀ嬀一䈀开䔀砀琀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NB_ExtAmt] [money] NULL,਍ऀ嬀一䈀开䄀瀀瀀猀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NB_BIOConvCnt] [int] NULL,਍ऀ嬀一䈀开䔀堀吀䌀漀渀瘀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[PCP_NB2Amt] [money] NULL,਍ऀ嬀倀䌀倀开倀䌀倀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[PCP_BioAmt] [money] NULL,਍ऀ嬀倀䌀倀开䔀砀琀䴀攀洀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[PCPNonPgmAmt] [money] NULL,਍ऀ嬀匀攀爀瘀椀挀攀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[RetailAmt] [money] NULL,਍ऀ嬀䌀氀椀攀渀琀匀攀爀瘀椀挀攀搀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NetMembershipAmt] [money] NULL,਍ऀ嬀匀开䜀爀漀猀猀匀甀爀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[S_SurCnt] [int] NULL,਍ऀ嬀匀开匀甀爀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[AccountID] [int] NULL,਍ऀ嬀倀䌀倀开唀瀀最䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[PCP_DwnCnt] [int] NULL,਍ऀ嬀一䈀开刀攀洀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NB_XTRAmt] [money] NULL,਍ऀ嬀一䈀开堀吀刀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NB_XTRConvCnt] [int] NULL,਍ऀ嬀倀䌀倀开堀琀爀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[MbrPromotion] [varchar](10) NULL,਍ऀ嬀一攀琀匀愀氀攀猀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[S_PRPCnt] [int] NULL,਍ऀ嬀匀开倀刀倀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[LaserAmt] [money] NULL,਍ऀ嬀匀开匀琀爀椀瀀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[S_StripAmt] [money] NULL,਍ऀ嬀匀开䄀爀琀愀猀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[S_ArtasAmt] [money] NULL,਍ऀ嬀䰀愀猀攀爀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[NB_MDPCnt] [int] NULL,਍ऀ嬀一䈀开䴀䐀倀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[NB_LaserCnt] [int] NULL,਍ऀ嬀一䈀开䰀愀猀攀爀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[PCP_LaserCnt] [int] NULL,਍ऀ嬀倀䌀倀开䰀愀猀攀爀䄀洀琀崀 嬀洀漀渀攀礀崀 一唀䰀䰀Ⰰഀഀ
	[EMP_RetailAmt] [money] NULL,਍ऀ嬀䔀䴀倀开一䈀开䰀愀猀攀爀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[EMP_NB_LaserAmt] [money] NULL,਍ऀ嬀䔀䴀倀开倀䌀倀开䰀愀猀攀爀䌀渀琀崀 嬀椀渀琀崀 一唀䰀䰀Ⰰഀഀ
	[EMP_PCP_LaserAmt] [money] NULL਍⤀ഀഀ
WITH਍⠀ഀഀ
	DISTRIBUTION = ROUND_ROBIN,਍ऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
)਍䜀伀ഀഀ
