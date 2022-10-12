/****** Object:  View [dbo].[VWFactSalesTransPerformer]    Script Date: 3/23/2022 10:16:56 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䘀愀挀琀匀愀氀攀猀吀爀愀渀猀倀攀爀昀漀爀洀攀爀崀ഀഀ
AS SELECT	਍ऀ䘀匀吀⸀嬀伀爀搀攀爀䐀愀琀攀䬀攀礀崀ഀഀ
	,FST.[OrderDate]਍ऀⰀ搀戀漀⸀䜀攀琀䰀漀挀愀氀䘀爀漀洀唀吀䌀⠀䘀匀吀⸀嬀伀爀搀攀爀䐀愀琀攀崀Ⰰ 吀娀⸀嬀唀吀䌀伀昀昀猀攀琀崀Ⰰ 吀娀⸀嬀唀猀攀猀䐀愀礀䰀椀最栀琀匀愀瘀椀渀最猀䘀氀愀最崀⤀ 䄀匀 嬀伀爀搀攀爀䐀愀琀攀䰀漀挀愀氀唀吀䌀崀ഀഀ
	,CONVERT(DATETIME,FST.[OrderDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time') AS [OrderDateEastern]਍ऀⰀ 䘀匀吀⸀嬀伀爀搀攀爀䐀攀琀愀椀氀䤀搀崀ഀഀ
	, FST.[OrderId]਍ऀⰀ 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䬀攀礀崀ഀഀ
	, FST.[SalesCodeId]਍ऀⰀ 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀崀ഀഀ
	, DSC.[SalesCodeNameShort]਍ऀⰀ 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䬀攀礀崀ഀഀ
	, FST.[SalesCodeDepartmentId]਍ऀⰀ 䐀匀䌀䐀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀一愀洀攀崀ഀഀ
	, FST.[CustomerId]਍ऀⰀ 䘀匀吀⸀嬀䌀甀猀琀漀洀攀爀䬀攀礀崀ഀഀ
	, FST.[ServiceAppointmentId] as AppointmentId਍ऀⰀ 䘀匀吀⸀嬀倀攀爀昀漀爀洀攀爀䤀搀崀ഀഀ
	, FST.[PerformerName]਍ऀⰀ 䐀䌀倀⸀䌀攀渀琀攀爀一甀洀戀攀爀 愀猀 倀攀爀昀漀爀洀攀爀䠀漀洀攀䌀攀渀琀攀爀ഀഀ
    , SU.CenterId  as PerformerHomeCenterID਍    Ⰰ 䐀䌀倀⸀䌀攀渀琀攀爀䬀攀礀 愀猀 倀攀爀昀漀爀洀攀爀䠀漀洀攀䌀攀渀琀攀爀䬀攀礀ഀഀ
	, CASE WHEN ((FST.[SalesCodeDepartmentId] IN (2020) AND DM.[RevenueGroupID] = 1 ) --RevGrp (NewBus)਍ऀऀऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㄀ ⴀⴀ䈀甀猀匀攀最 ⠀䈀䤀伀⤀ഀഀ
			AND DM.[MembershipShortName] IN ( 'TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO' ))਍ऀऀऀ伀刀 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 䤀一 ⠀ ✀一䈀㄀刀䔀嘀圀伀✀Ⰰ ✀䔀堀吀刀䔀嘀圀伀✀Ⰰ ✀匀唀刀䌀刀䔀䐀䤀吀倀䌀倀✀Ⰰ✀匀唀刀䌀刀䔀䐀䤀吀一䈀㄀✀ ⤀ ഀഀ
				AND DM.[MembershipShortName] NOT IN ( 'EXT6','EXT12','EXT18','EXTENH6','EXTENH12', 'EXTENH9',਍ऀऀऀऀऀ✀䔀堀吀䴀䔀䴀✀Ⰰ✀䔀堀吀䴀䔀䴀匀伀䰀✀Ⰰ✀䔀堀吀䤀一䤀吀䤀䄀䰀✀Ⰰ✀䔀堀吀倀刀䔀䴀䴀䔀一✀Ⰰ ✀䔀堀吀倀刀䔀䴀圀伀䴀✀Ⰰ ✀䜀刀䄀䐀✀Ⰰ✀䜀刀䐀匀嘀䔀娀✀Ⰰ✀䜀刀䄀䐀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀䔀娀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㘀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀匀伀䰀㄀㈀✀Ⰰഀഀ
					'GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER','NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',਍ऀऀऀऀऀ✀一倀刀䔀䴀㐀㠀✀Ⰰ✀一倀刀䔀䴀㘀　✀Ⰰ✀一倀刀䔀䴀㜀㈀✀Ⰰ✀倀伀匀吀䔀堀吀✀Ⰰ ✀䔀堀吀䘀䰀䔀堀✀Ⰰ ✀䔀堀吀䘀䰀䔀堀匀伀䰀✀ ⤀⤀ഀഀ
			AND FST.[SalesCodeDepartmentId] <> 3065 --Exclude Laser਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ഀഀ
			END AS NB_TradAmt਍ഀഀ
	, CASE WHEN ((( FST.[SalesCodeDepartmentId] IN ( 2020 ) OR DSC.[SalesCodeNameShort] LIKE 'SURCREDIT%' )਍ऀऀऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀✀䜀刀䄀䐀✀Ⰰ✀䜀刀䄀䐀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀䔀娀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㘀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀✀Ⰰ✀䜀刀䐀匀嘀匀伀䰀✀Ⰰ✀䔀䰀䤀吀䔀一䈀✀Ⰰ✀䔀䰀䤀吀䔀一䈀匀伀䰀✀Ⰰഀഀ
													'NSILVER', 'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36', 'NPREM48',਍ऀऀऀऀऀऀऀऀऀऀऀऀऀ✀一倀刀䔀䴀㘀　✀Ⰰ✀一倀刀䔀䴀㜀㈀✀Ⰰ✀䠀圀匀䤀䰀嘀䔀刀✀Ⰰ✀䠀圀䜀伀䰀䐀✀Ⰰ✀䠀圀倀䰀䄀吀✀⤀ഀഀ
			AND DSC.[SalesCodeNameShort] NOT IN ('EFTFEE','PCPREVWO')਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㰀㸀 ㌀　㘀㔀⤀ഀഀ
			OR ( FST.[SalesCodeDepartmentId] IN ( 2020 ) AND DM.[MembershipShortName] IN ( 'GRDSVEZ' )))਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ഀഀ
			END AS NB_GradAmt਍ഀഀ
	, CASE WHEN (( FST.[SalesCodeDepartmentId] IN (2020) OR (DSC.[SalesCodeNameShort] LIKE 'SURCREDIT%') )਍ऀऀऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀✀䔀堀吀㘀✀Ⰰ ✀䔀堀吀㄀㈀✀Ⰰ ✀䔀堀吀㄀㠀✀Ⰰ✀䔀堀吀䔀一䠀㘀✀Ⰰ ✀䔀堀吀䔀一䠀㄀㈀✀Ⰰ ✀䔀堀吀䔀一䠀㤀✀Ⰰ ✀䔀堀吀䤀一䤀吀䤀䄀䰀✀Ⰰ✀一刀䔀匀吀伀刀圀䬀✀Ⰰ✀一刀䔀匀吀䈀䤀圀䬀✀Ⰰഀഀ
													'NRESTORE', 'LASER82','HWEXTBAS','HWEXTPLUS','HWANAGEN')਍ऀऀऀ䄀一䐀 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀一伀吀 䤀一 ⠀✀䔀䘀吀䘀䔀䔀✀Ⰰ✀倀䌀倀刀䔀嘀圀伀✀Ⰰ✀倀䌀倀䴀䈀刀倀䴀吀✀⤀ഀഀ
			AND FST.[SalesCodeDepartmentId] <> 3065 --Exclude Laser਍ऀऀऀ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ഀഀ
			END AS NB_ExtAmt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN ( 2025 )	--Add-on Salescodes in Dept 2025 5/1/2017 km਍ऀऀऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 䤀一 ⠀ ㈀Ⰰ㌀ ⤀ഀഀ
			AND DSC.[SalesCodeNameShort] NOT IN ( 'BOSMEMADJTG','BOSMEMADJTGBPS','MEDADDONPMTTRI' ) )	਍ऀऀऀ伀刀 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㈀　㈀　⤀ 䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀 㴀 ㄀㌀⤀ഀഀ
			OR (DSC.[SalesCodeNameShort] IN ('NB1REVWO', 'EXTREVWO') AND DM.[MembershipShortName] IN ('POSTEXT'))਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ഀഀ
			END S_PostExtAmt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020) AND DM.[RevenueGroupID] = 1	਍ऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 㘀ऀ䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㰀㸀 ㌀　㘀㔀 ⴀⴀ䔀砀挀氀甀搀攀 䰀愀猀攀爀ഀഀ
				) THEN FST.[OrderExtendedPriceCalc] ELSE 0 ਍ऀऀऀऀ䔀一䐀 䄀匀 一䈀开堀琀爀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 㔀　㘀㈀ 䄀一䐀 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 一伀吀 䤀一 ⠀ ✀䄀䐀䐀伀一䴀䐀倀✀Ⰰ ✀匀嘀䌀匀䴀倀✀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
			WHEN FST.[SalesCodeDepartmentId] = 2020 AND DM.[MembershipShortName] = 'MDP' THEN FST.[OrderExtendedPriceCalc]਍ऀऀऀ圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㈀　㌀　 ⤀ 䄀一䐀 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 㴀 ✀䴀䔀䐀䄀䐀䐀伀一倀䴀吀匀䴀倀✀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 ⴀⴀ䄀搀搀攀搀 䈀漀猀氀攀礀 匀䴀倀ഀഀ
			ELSE 0  END AS NB_MDPAmt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]਍ऀऀऀ圀䠀䔀一 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀崀 䰀䤀䬀䔀 ✀─挀愀瀀─✀ 䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㈀　㈀　 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]਍ऀऀऀ䔀䰀匀䔀 　 䔀一䐀 䄀匀 一䈀开䰀愀猀攀爀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㈀　㈀　⤀ 䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䤀搀崀 一伀吀 䤀一 ⠀㤀㄀㈀Ⰰ㤀㄀㌀Ⰰ㄀㘀㔀㌀Ⰰ㄀㘀㔀㐀Ⰰ㄀㘀㔀㔀Ⰰ㄀㘀㔀㘀Ⰰ㄀㘀㘀㄀Ⰰ㄀㘀㘀㈀Ⰰ㄀㘀㘀㐀Ⰰ㄀㘀㘀㔀⤀  ⴀⴀ吀栀攀猀攀 愀爀攀 吀爀椀ⴀ䜀攀渀 漀爀 倀刀倀 䄀搀搀ⴀ伀渀猀ഀഀ
				AND DM.[BusinessSegmentID] = 3 ਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ഀഀ
			END AS S_SurAmt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeId] IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665)  --These are Tri-Gen or PRP Add-Ons਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀 䤀一 ⠀ 㐀㌀Ⰰ㐀㐀Ⰰ㈀㔀㤀Ⰰ㈀㘀　Ⰰ㈀㘀㄀Ⰰ㈀㘀㈀Ⰰ㈀㘀㌀Ⰰ㈀㘀㐀Ⰰ㈀㘀㔀Ⰰ㈀㘀㘀Ⰰ㈀㘀㜀Ⰰ㈀㘀㠀Ⰰ㈀㘀㤀Ⰰ㈀㜀　Ⰰ㌀㄀㘀Ⰰ㌀㄀㜀 ⤀⤀ ഀഀ
			THEN FST.[OrderExtendedPriceCalc] ELSE 0	਍ऀऀऀ䔀一䐀 匀开倀刀倀䄀洀琀ഀഀ
਍ഀഀ
FROM [dbo].[FactSalesTransaction] FST਍ऀ䤀一一䔀刀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䴀攀洀戀攀爀猀栀椀瀀崀 䐀䴀ഀഀ
		ON FST.[MembershipId] = DM.[MembershipId] ਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀匀愀氀攀猀䌀漀搀攀崀 䐀匀䌀 ഀഀ
		ON DSC.[SalesCodeID] = FST.[SalesCodeId]਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀崀 䐀匀䌀䐀 ഀഀ
		ON DSCD.[SalesCodeDepartmentID] = FST.[SalesCodeDepartmentId]਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀攀渀琀攀爀崀 䐀䌀 ഀഀ
		ON DC.[CenterID] = FST.[CenterId]਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀吀椀洀攀娀漀渀攀崀 吀娀ഀഀ
		ON TZ.[TimeZoneID] = DC.[TimeZoneID]਍ऀ䰀䔀䘀吀 䨀伀䤀一 䐀椀洀匀礀猀琀攀洀唀猀攀爀 猀甀 ഀഀ
		ON su.UserId = convert(varchar(250), FST.PerformerId)਍    䰀䔀䘀吀 䨀伀䤀一 䐀椀洀䌀攀渀琀攀爀 䐀䌀倀ഀഀ
        ON DCP.CenterID = su.CenterId਍ഀഀ
WHERE (FST.[IsVoided] = 0 AND FST.[IsClosed] = 1) AND CONVERT(DATE,FST.[OrderDate]) >= '2020-01-01';਍䜀伀ഀഀ
