/****** Object:  View [dbo].[VWFactSalesTransaction]    Script Date: 2/22/2022 9:20:31 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䘀愀挀琀匀愀氀攀猀吀爀愀渀猀愀挀琀椀漀渀崀 䄀匀 圀䤀吀䠀 䴀䔀䐀䄀䐀䐀伀一 䄀匀 ⠀ഀഀ
	SELECT	ROW_NUMBER() OVER ( PARTITION BY clt.ClientIdentifier,sc.SalesCodeDescriptionShort ORDER BY so.OrderDate DESC) AS 'Ranking'਍ऀऀऀⰀऀऀ猀漀⸀匀愀氀攀猀伀爀搀攀爀䜀唀䤀䐀ഀഀ
			,		sod.SalesOrderDetailGUID਍ऀऀऀⰀऀऀ猀漀⸀䤀渀瘀漀椀挀攀一甀洀戀攀爀ഀഀ
			,		clt.ClientIdentifier਍ऀऀऀⰀऀऀ挀氀琀⸀䌀氀椀攀渀琀䘀甀氀氀一愀洀攀䄀氀琀䌀愀氀挀ഀഀ
			,		m.MembershipDescription਍ऀऀऀⰀऀऀ挀洀猀⸀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
			,		so.OrderDate਍ऀऀऀⰀऀऀ猀挀⸀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 ഀഀ
			,		sc.SalesCodeDescription ਍ऀऀऀⰀऀऀ猀漀搀⸀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀ഀഀ
	FROM	[ODS].[CNCT_datSalesOrderDetail]  sod਍ऀऀऀ䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀匀愀氀攀猀伀爀搀攀爀崀 猀漀ഀഀ
				ON so.SalesOrderGUID = sod.SalesOrderGUID਍ऀऀऀ䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开䌀攀渀琀攀爀崀 挀琀爀ഀഀ
				ON ctr.CenterID = so.CenterID਍ऀऀऀ䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀吀椀洀攀娀漀渀攀崀 琀稀ഀഀ
				ON tz.TimeZoneID = ctr.TimeZoneID਍ऀऀऀ䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开挀昀最匀愀氀攀猀䌀漀搀攀崀 猀挀ഀഀ
				ON sc.SalesCodeID = sod.SalesCodeID਍ऀऀऀ䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀崀 挀氀琀ഀഀ
				ON clt.ClientGUID = so.ClientGUID਍ऀऀऀ䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀崀  挀洀ഀഀ
				ON cm.ClientMembershipGUID = so.ClientMembershipGUID਍ऀऀऀ䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀崀 挀洀猀ഀഀ
				ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID਍ऀऀऀ䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开挀昀最䴀攀洀戀攀爀猀栀椀瀀崀 洀ഀഀ
				ON m.MembershipID = cm.MembershipID਍ऀ圀䠀䔀刀䔀ऀ⠀猀挀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀 䤀一 ⠀ ✀䴀䔀䐀䄀䐀䐀伀一吀䜀✀Ⰰ✀䴀䔀䐀䄀䐀䐀伀一吀䜀㤀✀Ⰰ✀䠀䴀䔀䐀䄀䐀䐀伀一✀Ⰰ✀䠀䴀䔀䐀䄀䐀䐀伀一㌀✀⤀ഀഀ
				OR sc.SalesCodeID IN(912,913,1653,1654,1655,1656,1661,1662,1664,1665) 	--Add-on Salescodes in Dept 2025 5/1/2017 km਍ऀऀऀऀ䄀一䐀 洀⸀洀攀洀戀攀爀猀栀椀瀀椀搀 椀渀 ⠀ 㐀㌀Ⰰ㐀㐀Ⰰ㈀㔀㤀Ⰰ㈀㘀　Ⰰ㈀㘀㄀Ⰰ㈀㘀㈀Ⰰ㈀㘀㌀Ⰰ㈀㘀㐀Ⰰ㈀㘀㔀Ⰰ㈀㘀㘀Ⰰ㈀㘀㜀Ⰰ㈀㘀㠀Ⰰ㈀㘀㤀Ⰰ㈀㜀　Ⰰ㌀㄀㘀Ⰰ㌀㄀㜀 ⤀⤀ ഀഀ
				OR(sc.[SalesCodeDepartmentID] IN ( 1060 )  		਍ऀऀऀऀ䄀一䐀 猀挀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀 㴀 ✀䌀䄀一䌀䔀䰀䄀䐀䐀伀一✀ഀഀ
				AND m.BusinessSegmentID = 3)਍ऀऀऀ䄀一䐀 猀漀⸀䤀猀嘀漀椀搀攀搀䘀氀愀最 㴀 　ഀഀ
), Services AS (਍ऀ匀䔀䰀䔀䌀吀ऀ刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 倀䄀刀吀䤀吀䤀伀一 䈀夀 挀氀琀⸀䌀氀椀攀渀琀䤀搀攀渀琀椀昀椀攀爀 伀刀䐀䔀刀 䈀夀 猀漀⸀伀爀搀攀爀䐀愀琀攀 ⤀ 䄀匀 ✀刀漀眀䤀䐀✀ഀഀ
				,		so.SalesOrderGUID਍ऀऀऀऀⰀऀऀ猀漀搀⸀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀䜀唀䤀䐀ഀഀ
				,		so.InvoiceNumber਍ऀऀऀऀⰀऀऀ挀氀琀⸀䌀氀椀攀渀琀䤀搀攀渀琀椀昀椀攀爀ഀഀ
				,		CONVERT(VARCHAR, clt.ClientIdentifier) + ' - ' + clt.ClientFullNameAlt2Calc AS 'ClientName'਍ऀऀऀऀⰀऀऀ洀⸀䴀攀洀戀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀 䄀匀 ✀䴀攀洀戀攀爀猀栀椀瀀✀ഀഀ
				,		cms.ClientMembershipStatusDescription AS 'MembershipStatus'਍ऀऀऀऀⴀⴀⰀऀऀ䠀愀椀爀䌀氀甀戀䌀䴀匀⸀搀戀漀⸀䜀攀琀䰀漀挀愀氀䘀爀漀洀唀吀䌀⠀猀漀⸀伀爀搀攀爀䐀愀琀攀Ⰰ 琀稀⸀唀吀䌀伀昀昀猀攀琀Ⰰ 琀稀⸀唀猀攀猀䐀愀礀䰀椀最栀琀匀愀瘀椀渀最猀䘀氀愀最⤀ 䄀匀 ✀伀爀搀攀爀䐀愀琀攀✀ഀഀ
				,		sc.SalesCodeDescriptionShort AS 'SalesCode'਍ऀऀऀऀⰀऀऀ猀挀⸀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀 䄀匀 ✀䐀攀猀挀爀椀瀀琀椀漀渀✀ഀഀ
				,		sod.ExtendedPriceCalc AS 'Price'਍ऀ䘀刀伀䴀ऀ嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀崀 猀漀搀ഀഀ
			INNER JOIN [ODS].[CNCT_datSalesOrder] so਍ऀऀऀऀ伀一 猀漀⸀匀愀氀攀猀伀爀搀攀爀䜀唀䤀䐀 㴀 猀漀搀⸀匀愀氀攀猀伀爀搀攀爀䜀唀䤀䐀ഀഀ
			INNER JOIN [ODS].[CNCT_Center] ctr਍ऀऀऀऀ伀一 挀琀爀⸀䌀攀渀琀攀爀䤀䐀 㴀 猀漀⸀䌀攀渀琀攀爀䤀䐀ഀഀ
			INNER JOIN [ODS].[CNCT_lkpTimeZone] tz਍ऀऀऀऀ伀一 琀稀⸀吀椀洀攀娀漀渀攀䤀䐀 㴀 挀琀爀⸀吀椀洀攀娀漀渀攀䤀䐀ഀഀ
			INNER JOIN [ODS].[CNCT_cfgSalesCode] sc਍ऀऀऀऀ伀一 猀挀⸀匀愀氀攀猀䌀漀搀攀䤀䐀 㴀 猀漀搀⸀匀愀氀攀猀䌀漀搀攀䤀䐀ഀഀ
			INNER JOIN [ODS].[CNCT_datClient] clt਍ऀऀऀऀ伀一 挀氀琀⸀䌀氀椀攀渀琀䜀唀䤀䐀 㴀 猀漀⸀䌀氀椀攀渀琀䜀唀䤀䐀ഀഀ
			INNER JOIN [ODS].[CNCT_datClientMembership] cm਍ऀऀऀऀ伀一 挀洀⸀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䜀唀䤀䐀 㴀 猀漀⸀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀䜀唀䤀䐀ഀഀ
			INNER JOIN [ODS].[CNCT_lkpClientMembershipStatus] cms਍ऀऀऀऀ伀一 挀洀猀⸀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀䤀䐀 㴀 挀洀⸀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀䤀䐀ഀഀ
			INNER JOIN [ODS].[CNCT_cfgMembership] m਍ऀऀऀऀ伀一 洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀 㴀 挀洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀഀ
	WHERE	sc.SalesCodeDepartmentID = 5062਍ऀऀऀ䄀一䐀 猀挀⸀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 一伀吀 䤀一 ⠀ ✀匀嘀䌀匀䴀倀✀Ⰰ ✀䄀䐀䐀伀一䴀䐀倀✀ ⤀ഀഀ
			AND so.IsVoidedFlag = 0਍⤀ഀഀ
SELECT	਍ऀ䘀匀吀⸀嬀伀爀搀攀爀䐀愀琀攀崀ഀഀ
	,dbo.GetLocalFromUTC(FST.[OrderDate], TZ.[UTCOffset], TZ.[UsesDayLightSavingsFlag]) AS [OrderDateLocalUTC]਍ऀⰀ䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀吀䤀䴀䔀Ⰰ䘀匀吀⸀嬀伀爀搀攀爀䐀愀琀攀崀 䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀唀吀䌀✀ 䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀ 䄀匀 嬀伀爀搀攀爀䐀愀琀攀䔀愀猀琀攀爀渀崀ഀഀ
	--dateadd(mi,datepart(tz,CONVERT(datetime,FST.[OrderDate] ) AT TIME ZONE 'Eastern Standard Time')) AS [OrderDate] ਍ऀⴀⴀⰀ 䘀匀吀⸀嬀伀爀搀攀爀䐀愀琀攀崀 䄀匀 嬀伀爀搀攀爀䐀愀琀攀伀爀椀最椀渀愀氀崀ഀഀ
	, FST.[OrderDetailId]਍ऀⰀ 䘀匀吀⸀嬀伀爀搀攀爀䤀搀崀ഀഀ
	, FST.[SalesCodeKey]਍ऀⰀ 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䤀搀崀ഀഀ
	, DSC.[SalesCodeName]਍ऀⰀ 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䬀攀礀崀ഀഀ
	, FST.[SalesCodeDepartmentId]਍ऀⰀ 䐀匀䌀䐀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀一愀洀攀崀ഀഀ
	, FST.[OrderTypeKey]਍ऀⰀ 䘀匀吀⸀嬀伀爀搀攀爀吀礀瀀攀䤀搀崀ഀഀ
	, FST.[CenterKey]਍ऀⰀ 䘀匀吀⸀嬀䌀攀渀琀攀爀䤀搀崀ഀഀ
	, FST.[MembershipKey]਍ऀⰀ 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀ഀഀ
	, DM.[RevenueGroupID]਍ऀⰀ 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀ഀഀ
	, FST.[OrderUserId]਍ऀⰀ 䘀匀吀⸀嬀䌀甀猀琀漀洀攀爀䤀搀崀ഀഀ
	, FST.[LeadId]਍ऀⰀ 䘀匀吀⸀嬀䄀挀挀漀甀渀琀䤀搀崀ഀഀ
	, FST.[AppointmentId]਍ऀⰀ 䘀匀吀⸀嬀倀攀爀昀漀爀洀攀爀䤀搀崀ഀഀ
	, FST.[OrderQuantity]਍ऀⰀ 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
	, FST.[OrderPrice]਍ऀⰀ 䘀匀吀⸀嬀伀爀搀攀爀䐀椀猀挀漀甀渀琀崀ഀഀ
	, FST.[OrderTax1]਍ऀⰀ 䘀匀吀⸀嬀伀爀搀攀爀吀愀砀㈀崀ഀഀ
	, FST.[OrderTaxRate1]਍ऀⰀ 䘀匀吀⸀嬀伀爀搀攀爀吀愀砀刀愀琀攀㈀崀ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010 )   -- Agreements (MMAgree)਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀 䤀一 ⠀㐀㌀Ⰰ㈀㔀㤀Ⰰ㈀㘀　Ⰰ㈀㘀㄀Ⰰ㈀㘀㈀Ⰰ㈀㘀㌀Ⰰ㈀㘀㐀Ⰰ㌀㄀㘀⤀ ⴀⴀⴀⴀ 䘀椀爀猀琀 匀甀爀最攀爀礀 ⠀㄀猀琀匀唀刀䜀⤀ഀഀ
			THEN 1  ELSE 0 ਍ऀऀ䔀一䐀 匀㄀开匀愀氀攀䌀渀琀 ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㄀　㤀㤀 ⤀ ⴀⴀ 䌀愀渀挀攀氀氀愀琀椀漀渀猀 ⠀䴀䴀䌀愀渀挀攀氀⤀ഀഀ
			AND FST.[MembershipId] in (43,259,260,261,262,263,264, 44,265,266,267,268,269,270,316,317)  ---- First Surgery (1stSURG)਍ऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 ഀഀ
			END S_CancelCnt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010 ) -- Agreements (MMAgree)਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀  䤀一⠀㐀㌀Ⰰ㈀㔀㤀Ⰰ㈀㘀　Ⰰ㈀㘀㄀Ⰰ㈀㘀㈀Ⰰ㈀㘀㌀Ⰰ㈀㘀㐀Ⰰ㌀㄀㘀⤀ ⴀⴀⴀⴀ 䘀椀爀猀琀 匀甀爀最攀爀礀 ⠀㄀猀琀匀唀刀䜀⤀ ഀഀ
			THEN 1  ELSE 0 END ਍ऀऀऀऀⴀഀഀ
			CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 ) -- Cancellations (MMCancel)਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀  䤀一 ⠀㐀㌀Ⰰ㈀㔀㤀Ⰰ㈀㘀　Ⰰ㈀㘀㄀Ⰰ㈀㘀㈀Ⰰ㈀㘀㌀Ⰰ㈀㘀㐀Ⰰ㌀㄀㘀⤀ ⴀⴀⴀⴀ 䘀椀爀猀琀 匀甀爀最攀爀礀 ⠀㄀猀琀匀唀刀䜀⤀ഀഀ
			THEN 1 ELSE 0 ਍ऀऀऀ䔀一䐀  䄀匀 匀㄀开一攀琀匀愀氀攀猀䌀渀琀ऀഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㈀　㈀　 ⤀ ⴀⴀ 䴀攀洀戀攀爀猀栀椀瀀 刀攀瘀攀渀甀攀 ⠀䴀刀刀攀瘀攀渀甀攀⤀ഀഀ
			AND FST.[MembershipId]  IN (58,43,259,260,261,262,263,264,316) ਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䤀搀崀 一伀吀 䤀一 ⠀㤀㄀㈀Ⰰ㤀㄀㌀Ⰰ㄀㘀㔀㌀Ⰰ㄀㘀㔀㐀Ⰰ㄀㘀㔀㔀Ⰰ㄀㘀㔀㘀Ⰰ㄀㘀㘀㄀Ⰰ㄀㘀㘀㈀Ⰰ㄀㘀㘀㐀Ⰰ㄀㘀㘀㔀⤀   ⴀⴀ刀攀洀漀瘀椀渀最 倀刀倀 昀爀漀洀 䄀搀搀琀氀 匀甀爀最攀爀礀 䄀洀漀甀渀琀 ⴀⴀ 䘀椀爀猀琀 匀甀爀最攀爀礀 ⠀㄀猀琀匀唀刀䜀⤀ഀഀ
			THEN FST.[OrderExtendedPriceCalc] ELSE 0 ਍ऀऀऀ䔀一䐀 匀㄀开一攀琀匀愀氀攀猀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㄀　㄀　Ⰰ ㄀　㌀　Ⰰ ㄀　㐀　 ⤀ഀഀ
			AND FST.[MembershipId]  IN (43,259,260,261,262,263,264,316)਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀䌀漀渀琀䈀愀氀䴀漀渀攀礀䌀栀愀渀最攀崀 䔀䰀匀䔀 　 ഀഀ
			END S1_ContractAmountAmt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010, 1030, 1040 )਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀  䤀一 ⠀㐀㌀Ⰰ㈀㔀㤀Ⰰ㈀㘀　Ⰰ㈀㘀㄀Ⰰ㈀㘀㈀Ⰰ㈀㘀㌀Ⰰ㈀㘀㐀Ⰰ㌀㄀㘀⤀ ഀഀ
			THEN FST.[GraftsQuantityTotalChange] ELSE 0 ਍ऀऀऀ䔀一䐀  匀㄀开䔀猀琀䜀爀愀昀琀猀䌀渀琀   ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀倀倀匀䜀䴀漀渀攀礀䄀搀樀甀猀琀洀攀渀琀崀 㰀㸀 　 ഀഀ
			AND FST.[MembershipId]  IN (43,259,260,261,262,263,264,316) ਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀倀倀匀䜀䴀漀渀攀礀䄀搀樀甀猀琀洀攀渀琀崀 䔀䰀匀䔀 　 ഀഀ
			END AS S1_EstPerGraftsAmt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1075,1090 )  -- Conversions(MMConv) Renewals (MMRenew)਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀  䤀一⠀㐀㐀Ⰰ㈀㘀㔀Ⰰ㈀㘀㘀Ⰰ㈀㘀㜀Ⰰ㈀㘀㠀Ⰰ㈀㘀㤀Ⰰ㈀㜀　Ⰰ㌀㄀㜀⤀ ഀഀ
			THEN 1 ELSE 0 END ਍ऀऀऀऀⴀഀഀ
			CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 )  -- Cancellations (MMCancel)਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀  䤀一 ⠀㐀㐀Ⰰ㈀㘀㔀Ⰰ㈀㘀㘀Ⰰ㈀㘀㜀Ⰰ㈀㘀㠀Ⰰ㈀㘀㤀Ⰰ㈀㜀　Ⰰ㌀㄀㜀⤀ ഀഀ
			THEN 1 ELSE 0 ਍ऀऀऀ䔀一䐀 匀䄀开一攀琀匀愀氀攀猀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㈀　㈀　 ⤀  ⴀⴀ 䴀攀洀戀攀爀猀栀椀瀀 刀攀瘀攀渀甀攀 ⠀䴀刀刀攀瘀攀渀甀攀⤀ഀഀ
			AND FST.[MembershipId]  IN (44,265,266,267,268,269,270,317) ਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䤀搀崀 一伀吀 䤀一 ⠀㤀㄀㈀Ⰰ㤀㄀㌀Ⰰ㄀㘀㔀㌀Ⰰ㄀㘀㔀㐀Ⰰ㄀㘀㔀㔀Ⰰ㄀㘀㔀㘀Ⰰ㄀㘀㘀㄀Ⰰ㄀㘀㘀㈀Ⰰ㄀㘀㘀㐀Ⰰ㄀㘀㘀㔀⤀ ⴀⴀ刀攀洀漀瘀椀渀最 倀刀倀 昀爀漀洀 䄀搀搀琀氀 匀甀爀最攀爀礀 䄀洀漀甀渀琀ഀഀ
			THEN FST.[OrderExtendedPriceCalc] ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 匀䄀开一攀琀匀愀氀攀猀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㄀　㜀㔀Ⰰ ㄀　㌀　Ⰰ ㄀　㐀　Ⰰ ㄀　㤀　 ⤀ऀⴀⴀ 䌀漀渀瘀攀爀猀椀漀渀猀 笀䴀䴀䌀漀渀瘀⤀  刀攀渀攀眀愀氀猀 ⠀䴀䴀刀攀渀攀眀⤀ഀഀ
			AND FST.[MembershipId]  IN (44,265,266,267,268,269,270,317) ਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀䌀漀渀琀䈀愀氀䴀漀渀攀礀䌀栀愀渀最攀崀 䔀䰀匀䔀 　 ഀഀ
			END AS SA_ContractAmountAmt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1030, 1040, 1075, 1090 )  -- Conversions {MMConv)  Renewals (MMRenew)਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀  䤀一⠀㐀㐀Ⰰ㈀㘀㔀Ⰰ㈀㘀㘀Ⰰ㈀㘀㜀Ⰰ㈀㘀㠀Ⰰ㈀㘀㤀Ⰰ㈀㜀　Ⰰ㌀㄀㜀⤀ ഀഀ
			THEN FST.[GraftsQuantityTotalChange] ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 匀䄀开䔀猀琀䜀爀愀昀琀猀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀倀倀匀䜀䴀漀渀攀礀䄀搀樀甀猀琀洀攀渀琀崀 㰀㸀 　 ഀഀ
			AND FST.[MembershipId]  IN(44,265,266,267,268,269,270,317) ਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀倀倀匀䜀䴀漀渀攀礀䄀搀樀甀猀琀洀攀渀琀崀 䔀䰀匀䔀 　 ഀഀ
			END AS SA_EstPerGraftAmt਍ഀഀ
	, CASE ਍ऀऀऀ圀䠀䔀一 䌀伀一嘀䔀刀吀⠀䐀䄀吀䔀Ⰰ䘀匀吀⸀嬀伀爀搀攀爀䐀愀琀攀崀⤀ 㰀  ✀㈀　㄀㌀ⴀ㄀　ⴀ　㔀✀ഀഀ
					THEN CASE WHEN FST.[SalesCodeDepartmentId] IN ( 2025 ) --AND DM.[BusinessSegmentID] in ( 2,3 )  --  Post Extreme (MRPostExt) ਍ऀऀऀऀऀऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀 䔀䰀匀䔀 　 䔀一䐀ഀഀ
			WHEN CONVERT(DATE,FST.[OrderDate]) >=  '2013-10-05'਍ऀऀऀ吀䠀䔀一 䌀䄀匀䔀 圀䠀䔀一 䌀䌀⸀嬀䌀攀渀琀攀爀䈀甀猀椀渀攀猀猀吀礀瀀攀䤀䐀崀 㴀 ㄀ ഀഀ
						THEN CASE WHEN (FST.[SalesCodeDepartmentId] IN ( 2025 ) ਍ऀऀऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 䤀一 ⠀ ㈀Ⰰ㌀ ⤀ ഀഀ
							AND FST.[SalesCodeId] NOT IN(917,918,1230,1231) )   --'MEDADDONTG','MEDADDONTG9','HMEDADDON','HMEDADDON3' --  Post Extreme (MRPostExt)਍ऀऀऀऀऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀 䔀䰀匀䔀 　 䔀一䐀 ഀഀ
				WHEN CC.[CenterBusinessTypeID] IN (2,3) ਍ऀऀऀऀ吀䠀䔀一 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㄀　㄀　Ⰰ㄀　㄀㔀 ⤀  ഀഀ
							AND FST.[MembershipId] = 13਍ऀऀऀऀऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀 䔀䰀匀䔀 　 䔀一䐀 ⴀⴀ圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㄀　　㘀 ⤀ऀⴀⴀ䄀搀搀椀琀椀漀渀愀氀 䴀攀搀椀挀愀氀 匀攀爀瘀椀挀攀猀ⴀⴀऀऀ吀䠀䔀一 ㄀ഀഀ
				-		਍ऀऀऀ䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㄀　㤀㤀 ⤀  ഀഀ
					AND FST.[MembershipId] = 13਍ऀऀऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 ഀഀ
					END ਍ऀऀऀऀ䔀一䐀 ഀഀ
			END S_PostExtCnt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN ( 2025 )	--Add-on Salescodes in Dept 2025 5/1/2017 km਍ऀऀऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 䤀一 ⠀ ㈀Ⰰ㌀ ⤀ഀഀ
			AND DSC.[SalesCodeNameShort] NOT IN ( 'BOSMEMADJTG','BOSMEMADJTGBPS','MEDADDONPMTTRI' ) )	਍ऀऀऀ伀刀 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㈀　㈀　⤀ 䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀 㴀 ㄀㌀⤀ഀഀ
			OR (DSC.[SalesCodeNameShort] IN ('NB1REVWO', 'EXTREVWO') AND DM.[MembershipShortName] IN ('POSTEXT'))਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ഀഀ
			END S_PostExtAmt਍ഀഀ
	, CASE WHEN (MEDADDON.SalesOrderDetailGUID IS NOT NULL AND DSC.[SalesCodeNameShort] IN ( 'MEDADDONTG','MEDADDONTG9','HMEDADDON','HMEDADDON3')	--Add-on Salescodes in Dept 2025 5/1/2017 km਍ऀऀऀऀऀ䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀 椀渀 ⠀ 㐀㌀Ⰰ㐀㐀Ⰰ㈀㔀㤀Ⰰ㈀㘀　Ⰰ㈀㘀㄀Ⰰ㈀㘀㈀Ⰰ㈀㘀㌀Ⰰ㈀㘀㐀Ⰰ㈀㘀㔀Ⰰ㈀㘀㘀Ⰰ㈀㘀㜀Ⰰ㈀㘀㠀Ⰰ㈀㘀㤀Ⰰ㈀㜀　Ⰰ㌀㄀㘀Ⰰ㌀㄀㜀 ⤀⤀ ഀഀ
			THEN 1 ELSE 0 END਍ऀऀऀऀⴀ ഀഀ
			CASE WHEN (MEDADDON.SalesOrderDetailGUID IS NOT NULL AND FST.[SalesCodeDepartmentId] IN ( 1060 )  ਍ऀऀऀऀऀऀ䄀一䐀 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 㴀 ✀䌀䄀一䌀䔀䰀䄀䐀䐀伀一✀ 䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㌀⤀ ⴀⴀ匀甀爀最攀爀礀ഀഀ
				THEN 1 ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 匀开倀刀倀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䤀搀崀 䤀一 ⠀㤀㄀㈀Ⰰ㤀㄀㌀Ⰰ㄀㘀㔀㌀Ⰰ㄀㘀㔀㐀Ⰰ㄀㘀㔀㔀Ⰰ㄀㘀㔀㘀Ⰰ㄀㘀㘀㄀Ⰰ㄀㘀㘀㈀Ⰰ㄀㘀㘀㐀Ⰰ㄀㘀㘀㔀⤀  ⴀⴀ吀栀攀猀攀 愀爀攀 吀爀椀ⴀ䜀攀渀 漀爀 倀刀倀 䄀搀搀ⴀ伀渀猀ഀഀ
			AND FST.[MembershipId] IN ( 43,44,259,260,261,262,263,264,265,266,267,268,269,270,316,317 )) ਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　ऀഀഀ
			END S_PRPAmt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 5060 ) -- Surgery (SVSurg)਍ऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 ഀഀ
			END AS S_SurgeryPerformedCnt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 5060 ) -- Surgery (SVSurg)਍ऀऀऀ吀䠀䔀一 䐀䌀䴀⸀嬀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀䌀漀渀琀爀愀挀琀倀爀椀挀攀崀  䔀䰀匀䔀 　 ഀഀ
			END AS S_SurgeryPerformedAmt ਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 5060 )   -- Surgery (SVSurg)਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀 䔀䰀匀䔀 　ऀഀഀ
			END AS S_SurgeryGraftsCnt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 7015 ) -- Deposit Count਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀 䔀䰀匀䔀 　ऀഀഀ
			END AS S1_DepositsTakenCnt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 7015 )  --Deposits Amt਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　ऀഀഀ
			END AS S1_DepositsTakenAmt਍ഀഀ
	, ISNULL(( CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010 ) AND DM.[BusinessSegmentID] <> 3਍ऀऀऀऀ䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀ ✀匀䠀伀圀匀䄀䰀䔀✀Ⰰ ✀匀䠀伀圀一伀匀䄀䰀䔀✀Ⰰ ✀匀一匀匀唀刀䜀伀䘀䘀✀Ⰰ ✀刀䔀吀䄀䤀䰀✀Ⰰ ✀䠀䌀䘀䬀✀Ⰰ ✀一伀一倀䜀䴀✀Ⰰ ✀䴀伀䐀䔀䰀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䴀伀䐀䔀䰀䔀堀吀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ഀഀ
			THEN 1 ELSE ( CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010, 2025, 1075, 1090 ) AND DSC.[SalesCodeNameShort] NOT IN ( 'POSTEXTPMT','POSTEXTPMTUS' )਍ऀऀऀऀऀऀऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀ ✀匀䠀伀圀匀䄀䰀䔀✀Ⰰ ✀匀䠀伀圀一伀匀䄀䰀䔀✀Ⰰ ✀匀一匀匀唀刀䜀伀䘀䘀✀Ⰰ ✀刀䔀吀䄀䤀䰀✀ ⤀ 䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㌀ऀ䄀一䐀 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀 㸀 　 ഀഀ
											THEN 1 ELSE 0 END)਍ऀऀऀ䔀一䐀⤀Ⰰ 　⤀ ⬀ 䤀匀一唀䰀䰀⠀⠀ 䌀䄀匀䔀 圀䠀䔀一 匀攀爀瘀椀挀攀猀⸀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀䜀唀䤀䐀 䤀匀 一伀吀 一唀䰀䰀 吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 ⤀Ⰰ 　⤀ 䄀匀 一䈀开䜀爀漀猀猀一䈀㄀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀䤀猀䜀甀愀爀愀渀琀攀攀崀㴀 ㄀ ഀഀ
			THEN (CASE WHEN FST.[SalesCodeDepartmentId] IN (1010) ਍ऀऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀✀吀刀䄀䐀䤀吀䤀伀一✀Ⰰ✀一䄀䰀䄀䌀䄀刀吀䔀✀Ⰰ✀一䘀伀䰀䰀䤀䜀刀䘀吀✀Ⰰ✀䠀圀䈀刀䤀伀✀⤀ഀഀ
						THEN 1 ELSE 0 END਍ऀऀऀऀऀऀⴀഀഀ
  					CASE WHEN FST.[SalesCodeDepartmentId] IN (1099) ਍ऀऀऀऀऀऀ䄀一䐀 ⠀䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀✀吀刀䄀䐀䤀吀䤀伀一✀Ⰰ✀一䄀䰀䄀䌀䄀刀吀䔀✀Ⰰ✀一䘀伀䰀䰀䤀䜀刀䘀吀✀Ⰰ✀䠀圀䈀刀䤀伀✀⤀⤀ഀഀ
						THEN 1 ELSE 0 END) ਍ऀऀऀऀऀऀ䔀䰀匀䔀 ⠀䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㄀　⤀ ഀഀ
								AND DM.[MembershipShortName] IN ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO')਍ऀऀऀऀऀऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀ഀഀ
						-਍  ऀऀऀऀऀ䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㤀㤀⤀ ഀഀ
						AND (PREVDM.[MembershipShortName] IN ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO') ਍ऀऀऀऀऀऀ漀爀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 椀渀 ⠀✀吀刀䄀䐀䤀吀䤀伀一✀Ⰰ✀一䄀䰀䄀䌀䄀刀吀䔀✀Ⰰ✀一䘀伀䰀䰀䤀䜀刀䘀吀✀Ⰰ✀䠀圀䈀刀䤀伀✀⤀ഀഀ
					) THEN 1 ELSE 0 END)	਍ऀऀऀ䔀一䐀ऀ䄀匀 一䈀开吀爀愀搀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㈀　㈀　⤀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ ⤀ ⴀⴀ刀攀瘀䜀爀瀀 ⠀一攀眀䈀甀猀⤀ഀഀ
			AND DM.[BusinessSegmentID] = 1 --BusSeg (BIO)਍ऀऀऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀ ✀吀刀䄀䐀䤀吀䤀伀一✀Ⰰ✀一䄀䰀䄀䌀䄀刀吀䔀✀Ⰰ✀一䘀伀䰀䰀䤀䜀刀䘀吀✀Ⰰ✀䠀圀䈀刀䤀伀✀ ⤀⤀ഀഀ
			OR (DSC.[SalesCodeNameShort] IN ( 'NB1REVWO', 'EXTREVWO', 'SURCREDITPCP','SURCREDITNB1' ) ਍ऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀ ✀䔀堀吀㘀✀Ⰰ✀䔀堀吀㄀㈀✀Ⰰ✀䔀堀吀㄀㠀✀Ⰰ✀䔀堀吀䔀一䠀㘀✀Ⰰ✀䔀堀吀䔀一䠀㄀㈀✀Ⰰ ✀䔀堀吀䔀一䠀㤀✀Ⰰഀഀ
					'EXTMEM','EXTMEMSOL','EXTINITIAL','EXTPREMMEN', 'EXTPREMWOM', 'GRAD','GRDSVEZ','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12',਍ऀऀऀऀऀ✀䜀刀䐀匀嘀✀Ⰰ✀䜀刀䐀匀嘀匀伀䰀✀Ⰰ✀䔀䰀䤀吀䔀一䈀✀Ⰰ✀䔀䰀䤀吀䔀一䈀匀伀䰀✀Ⰰ✀一匀䤀䰀嘀䔀刀✀Ⰰ✀一䴀䤀一䤀倀刀䔀䴀✀Ⰰ✀一䜀伀䰀䐀✀Ⰰ✀一倀䰀䄀吀䤀一唀䴀✀Ⰰ✀一䐀䤀䄀䴀伀一䐀✀Ⰰ✀一倀刀䔀䴀䤀䔀刀䔀✀Ⰰ✀一匀唀倀䔀刀倀刀䔀䴀✀Ⰰ✀一唀䰀吀刀䄀倀刀䔀䴀✀Ⰰ✀一倀刀䔀䴀㈀㐀✀Ⰰ✀一倀刀䔀䴀㌀㘀✀Ⰰഀഀ
					'NPREM48','NPREM60','NPREM72','POSTEXT', 'EXTFLEX', 'EXTFLEXSOL' ))਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㰀㸀 ㌀　㘀㔀 ⴀⴀ䔀砀挀氀甀搀攀 䰀愀猀攀爀ഀഀ
			THEN FST.[OrderExtendedPriceCalc] ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 一䈀开吀爀愀搀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀䤀猀䜀甀愀爀愀渀琀攀攀崀 㴀 ㄀ ഀഀ
			THEN (CASE WHEN FST.[SalesCodeDepartmentId] IN (1010) ਍ऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 ഀഀ
					IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',਍ऀऀऀऀऀऀ✀一䴀䤀一䤀倀刀䔀䴀✀Ⰰ✀一䜀伀䰀䐀✀Ⰰ✀一倀䰀䄀吀䤀一唀䴀✀Ⰰ✀一䐀䤀䄀䴀伀一䐀✀Ⰰ✀一倀刀䔀䴀䤀䔀刀䔀✀Ⰰ✀一匀唀倀䔀刀倀刀䔀䴀✀Ⰰ✀一唀䰀吀刀䄀倀刀䔀䴀✀Ⰰ✀一倀刀䔀䴀㈀㐀✀Ⰰ✀一倀刀䔀䴀㌀㘀✀Ⰰഀഀ
						'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT')਍ऀऀऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀ഀഀ
						-਍ऀऀऀऀ䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㤀㤀⤀ ഀഀ
					AND (DM.[MembershipShortName] ਍ऀऀऀऀऀ䤀一 ⠀✀䜀刀䄀䐀✀Ⰰ✀䜀刀䄀䐀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀䔀娀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㘀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀✀Ⰰ✀䜀刀䐀匀嘀匀伀䰀✀Ⰰ✀䔀䰀䤀吀䔀一䈀✀Ⰰ✀䔀䰀䤀吀䔀一䈀匀伀䰀✀Ⰰ✀一匀䤀䰀嘀䔀刀✀Ⰰഀഀ
						'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',਍ऀऀऀऀऀऀ✀一倀刀䔀䴀㐀㠀✀Ⰰ✀一倀刀䔀䴀㘀　✀Ⰰ✀一倀刀䔀䴀㜀㈀✀Ⰰ✀䠀圀匀䤀䰀嘀䔀刀✀Ⰰ✀䠀圀䜀伀䰀䐀✀Ⰰ✀䠀圀倀䰀䄀吀✀⤀⤀ഀഀ
					THEN 1 ELSE 0 END) ਍ऀऀऀऀऀ䔀䰀匀䔀 ⠀䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㄀　⤀ ഀഀ
							AND DM.[MembershipShortName] ਍ऀऀऀऀऀऀऀ䤀一 ⠀✀䜀刀䄀䐀✀Ⰰ✀䜀刀䄀䐀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀䔀娀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㘀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀✀Ⰰ✀䜀刀䐀匀嘀匀伀䰀✀Ⰰ✀䔀䰀䤀吀䔀一䈀✀Ⰰ✀䔀䰀䤀吀䔀一䈀匀伀䰀✀Ⰰ✀一匀䤀䰀嘀䔀刀✀Ⰰഀഀ
								'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',਍ऀऀऀऀऀऀऀऀ✀一倀刀䔀䴀㐀㠀✀Ⰰ✀一倀刀䔀䴀㘀　✀Ⰰ✀一倀刀䔀䴀㜀㈀✀Ⰰ✀䠀圀匀䤀䰀嘀䔀刀✀Ⰰ✀䠀圀䜀伀䰀䐀✀Ⰰ✀䠀圀倀䰀䄀吀✀⤀ഀഀ
						THEN 1 ELSE 0 END਍ऀऀऀऀऀऀⴀഀഀ
					CASE WHEN FST.[SalesCodeDepartmentId] IN (1099) ਍ऀऀऀऀऀऀऀ䄀一䐀 ⠀倀刀䔀嘀䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀ഀഀ
							IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',਍ऀऀऀऀऀऀऀऀ✀一䴀䤀一䤀倀刀䔀䴀✀Ⰰ✀一䜀伀䰀䐀✀Ⰰ✀一倀䰀䄀吀䤀一唀䴀✀Ⰰ✀一䐀䤀䄀䴀伀一䐀✀Ⰰ✀一倀刀䔀䴀䤀䔀刀䔀✀Ⰰ✀一匀唀倀䔀刀倀刀䔀䴀✀Ⰰ✀一唀䰀吀刀䄀倀刀䔀䴀✀Ⰰ✀一倀刀䔀䴀㈀㐀✀Ⰰ✀一倀刀䔀䴀㌀㘀✀Ⰰഀഀ
								'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT')਍ऀऀऀऀऀऀऀऀ伀刀ഀഀ
								DM.[MembershipShortName] IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL',਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀ✀䔀䰀䤀吀䔀一䈀✀Ⰰ✀䔀䰀䤀吀䔀一䈀匀伀䰀✀Ⰰ✀一匀䤀䰀嘀䔀刀✀Ⰰ✀一䴀䤀一䤀倀刀䔀䴀✀Ⰰ✀一䜀伀䰀䐀✀Ⰰ✀一倀䰀䄀吀䤀一唀䴀✀Ⰰ✀一䐀䤀䄀䴀伀一䐀✀Ⰰ✀一倀刀䔀䴀䤀䔀刀䔀✀Ⰰ✀一匀唀倀䔀刀倀刀䔀䴀✀Ⰰഀഀ
																'NULTRAPREM','NPREM24','NPREM36','NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT'))਍ऀऀऀऀऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀⤀ ഀഀ
					END AS NB_GradCnt਍ഀഀ
	, CASE WHEN ((( FST.[SalesCodeDepartmentId] IN ( 2020 ) OR DSC.[SalesCodeNameShort] LIKE 'SURCREDIT%' )਍ऀऀऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀✀䜀刀䄀䐀✀Ⰰ✀䜀刀䄀䐀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀䔀娀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㘀✀Ⰰ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀匀伀䰀㄀㈀✀Ⰰ✀䜀刀䐀匀嘀✀Ⰰ✀䜀刀䐀匀嘀匀伀䰀✀Ⰰ✀䔀䰀䤀吀䔀一䈀✀Ⰰ✀䔀䰀䤀吀䔀一䈀匀伀䰀✀Ⰰഀഀ
													'NSILVER', 'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36', 'NPREM48',਍ऀऀऀऀऀऀऀऀऀऀऀऀऀ✀一倀刀䔀䴀㘀　✀Ⰰ✀一倀刀䔀䴀㜀㈀✀Ⰰ✀䠀圀匀䤀䰀嘀䔀刀✀Ⰰ✀䠀圀䜀伀䰀䐀✀Ⰰ✀䠀圀倀䰀䄀吀✀⤀ഀഀ
			AND DSC.[SalesCodeNameShort] NOT IN ('EFTFEE','PCPREVWO')਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㰀㸀 ㌀　㘀㔀⤀ഀഀ
			OR ( FST.[SalesCodeDepartmentId] IN ( 2020 ) AND DM.[MembershipShortName] IN ( 'GRDSVEZ' )))਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ഀഀ
			END AS NB_GradAmt਍ഀഀ
	, CASE WHEN FST.[IsGuarantee] = 1 ਍ऀऀऀ吀䠀䔀一 ⠀䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㄀　⤀ഀഀ
					AND DM.[RevenueGroupID] = 1 --RevGrp (NewBus)਍ऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㈀ ⴀⴀ䈀甀猀匀攀最 ⠀䔀堀吀⤀ഀഀ
					AND DM.[MembershipShortName] <> 'POSTEXT'਍ऀऀऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀ഀഀ
				-਍ऀऀऀऀ䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀䐀 䤀一 ⠀㄀　㤀㤀⤀ ഀഀ
					AND DM.[MembershipShortName] IN ('EXT6', 'EXT12', 'EXT18','EXTENH6', 'EXTENH12', 'EXTENH9', 'EXTINITIAL',਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀ✀一刀䔀匀吀伀刀圀䬀✀Ⰰ✀一刀䔀匀吀䈀䤀圀䬀✀Ⰰ✀一刀䔀匀吀伀刀䔀✀Ⰰ✀䰀䄀匀䔀刀㠀㈀✀Ⰰ✀䠀圀䔀堀吀䈀䄀匀✀Ⰰ✀䠀圀䔀堀吀倀䰀唀匀✀Ⰰ✀䠀圀䄀一䄀䜀䔀一✀⤀ഀഀ
					THEN 1 ELSE 0 END) ਍ऀऀऀऀऀ䔀䰀匀䔀⠀䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㄀　⤀ഀഀ
								AND DM.[RevenueGroupID] = 1 --RevGrp (NewBus)਍ऀऀऀऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㈀ ⴀⴀ䈀甀猀匀攀最 ⠀䔀堀吀⤀ഀഀ
								AND DM.[MembershipShortName] <> 'POSTEXT'਍ऀऀऀऀऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 ऀ䔀一䐀ഀഀ
							-਍ऀऀऀऀऀऀऀ䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㤀㤀⤀ ഀഀ
								AND (PREVDM.[RevenueGroupID] = 1 or DM.[RevenueGroupID] = 1) --RevGrp (NewBus)਍ऀऀऀऀऀऀऀऀ䄀一䐀 ⠀倀刀䔀嘀䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㈀  漀爀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㈀⤀ⴀⴀ䈀甀猀匀攀最 ⠀䔀堀吀⤀ഀഀ
								AND (PREVDM.[MembershipShortName] <> 'POSTEXT' ਍ऀऀऀऀऀऀऀऀऀ伀刀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 㰀㸀 ✀倀伀匀吀䔀堀吀✀⤀ഀഀ
					THEN 1 ELSE 0 END)਍ऀऀऀ䔀一䐀 䄀匀 一䈀开䔀砀琀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀⠀ 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㈀　㈀　⤀ 伀刀 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 䰀䤀䬀䔀 ✀匀唀刀䌀刀䔀䐀䤀吀─✀⤀ ⤀ഀഀ
			AND DM.[MembershipShortName] IN ('EXT6', 'EXT12', 'EXT18','EXTENH6', 'EXTENH12', 'EXTENH9', 'EXTINITIAL','NRESTORWK','NRESTBIWK',਍ऀऀऀऀऀऀऀऀऀऀऀऀऀ✀一刀䔀匀吀伀刀䔀✀Ⰰ ✀䰀䄀匀䔀刀㠀㈀✀Ⰰ✀䠀圀䔀堀吀䈀䄀匀✀Ⰰ✀䠀圀䔀堀吀倀䰀唀匀✀Ⰰ✀䠀圀䄀一䄀䜀䔀一✀⤀ഀഀ
			AND DSC.[SalesCodeNameShort]NOT IN ('EFTFEE','PCPREVWO','PCPMBRPMT')਍ऀऀऀ䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㰀㸀 ㌀　㘀㔀 ⴀⴀ䔀砀挀氀甀搀攀 䰀愀猀攀爀ഀഀ
			) THEN FST.[OrderExtendedPriceCalc] ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 一䈀开䔀砀琀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀䤀猀䜀甀愀爀愀渀琀攀攀崀 㴀 ㄀ ഀഀ
			THEN (CASE WHEN FST.[SalesCodeDepartmentId] IN (1010)਍ऀऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 㘀ഀഀ
						THEN 1 ELSE 0 END਍ऀऀऀऀऀⴀഀഀ
					CASE WHEN DM.[RevenueGroupID] IN (1099) ਍ऀऀऀऀऀऀⴀⴀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀✀堀琀爀愀渀搀✀Ⰰ✀堀琀爀愀渀搀㘀✀Ⰰ ✀堀琀爀愀渀搀㄀㈀✀⤀ ⴀⴀ刀䠀 　㠀⼀㄀㌀⼀㈀　㄀㠀ഀഀ
						AND DM.[RevenueGroupID] = 1 AND DM.[BusinessSegmentID] = 6਍ऀऀऀऀऀऀ吀䠀䔀一 ㄀ ऀ䔀䰀匀䔀 　 ऀ䔀一䐀⤀ ഀഀ
			ELSE (CASE WHEN FST.[SalesCodeDepartmentId] IN (1010) ਍ऀऀऀऀऀऀⴀⴀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀✀堀琀爀愀渀搀✀Ⰰ✀堀琀爀愀渀搀㘀✀Ⰰ ✀堀琀爀愀渀搀㄀㈀✀⤀ ⴀⴀ刀䠀 　㠀⼀㄀㌀⼀㈀　㄀㠀ഀഀ
						AND DM.[RevenueGroupID] = 1 AND DM.[BusinessSegmentID] = 6਍ऀऀऀऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀ഀഀ
					-਍ऀऀऀऀऀ䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㤀㤀⤀ ഀഀ
						--AND (PREVDM.MembershipDescriptionShort IN ('Xtrand','Xtrand6', 'Xtrand12') --RH 08/13/2018਍ऀऀऀऀऀऀⴀⴀ伀刀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 椀渀 ⠀✀堀琀爀愀渀搀✀Ⰰ✀堀琀爀愀渀搀㘀✀Ⰰ ✀堀琀爀愀渀搀㄀㈀✀⤀⤀ഀഀ
						AND ((PREVDM.[RevenueGroupID] = 1 AND PREVDM.[BusinessSegmentID] = 6)਍ऀऀऀऀऀऀ伀刀 ⠀䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 㘀⤀⤀ഀഀ
						THEN 1 ELSE 0 END)	਍ऀऀऀ䔀一䐀ऀ䄀匀 一䈀开堀琀爀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㈀　㈀　⤀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ऀഀഀ
					AND DM.[BusinessSegmentID] = 6	AND FST.[SalesCodeDepartmentId] <> 3065 --Exclude Laser਍ऀऀऀऀ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ഀഀ
				END AS NB_XtrAmt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN (5010) THEN FST.[OrderQuantity] ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 一䈀开䄀瀀瀀猀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㜀㔀⤀ 䄀一䐀 倀刀䔀嘀䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㈀ 䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㄀ഀഀ
			THEN FST.[OrderQuantity] ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 一䈀开䈀䤀伀䌀漀渀瘀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㜀㔀⤀ 䄀一䐀 倀刀䔀嘀䐀䴀⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㈀ऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㈀ഀഀ
			THEN FST.[OrderQuantity] ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 一䈀开䔀堀吀䌀漀渀瘀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㜀㔀⤀ 䄀一䐀 倀刀䔀嘀䐀䴀⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㈀ऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 㘀ഀഀ
			THEN FST.[OrderQuantity] ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 一䈀开堀吀刀䌀漀渀瘀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䤀搀崀 䤀一 ⠀㌀㤀㤀⤀  吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 䄀匀 一䈀开刀攀洀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㈀　㈀　⤀ 䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㄀ ഀഀ
					and DM.[RevenueGroupID] IN (2,3) AND DM.[MembershipShortName] NOT IN ('MODEL','EMPLOYEE','EMPLOYEXT','MODELEXT','EMPLOYEE6') AND DSC.[SalesCodeNameShort] NOT IN ('EXTREVWO','NB1REVWO') )਍ऀऀऀऀ伀刀 ഀഀ
				(DM.[MembershipShortName] IN ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL') AND DSC.[SalesCodeNameShort] IN ('EXTREVWO') )਍ऀऀऀऀ伀刀 ഀഀ
				(FST.[SalesCodeDepartmentId] IN (2020) and DM.[MembershipShortName] IN ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL'))਍ऀऀऀऀ伀刀ऀഀഀ
				(FST.[SalesCodeDepartmentId] IN (2020) AND DM.[BusinessSegmentID] = 6 AND DM.[RevenueGroupID] = 2 )਍ऀऀऀऀ伀刀ഀഀ
				(DSC.[SalesCodeNameShort] IN ('PCPREVWO','PCPMBRPMT','EFTFEE')	AND DM.[MembershipShortName] NOT IN  ('GRDSVEZ'))਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ഀഀ
			END AS PCP_NB2Amt਍ഀഀ
	, CASE WHEN ((FST.[SalesCodeDepartmentId] IN (2020) AND DM.[BusinessSegmentID] = 1 ਍ऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㈀ऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀✀一伀一倀䜀䴀✀Ⰰ✀䴀伀䐀䔀䰀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ✀䴀伀䐀䔀䰀䔀堀吀✀Ⰰ✀䔀堀吀㘀✀Ⰰ ✀䔀堀吀㄀㈀✀Ⰰ✀䔀堀吀㄀㠀✀Ⰰ ✀䔀堀吀䔀一䠀㘀✀Ⰰ ✀䔀堀吀䔀一䠀㄀㈀✀Ⰰ ✀䔀堀吀䔀一䠀㤀✀Ⰰ ✀䔀堀吀䤀一䤀吀䤀䄀䰀✀Ⰰ✀一刀䔀匀吀伀刀圀䬀✀Ⰰ✀一刀䔀匀吀䈀䤀圀䬀✀Ⰰ✀一刀䔀匀吀伀刀䔀✀Ⰰ ✀䰀䄀匀䔀刀㠀㈀✀⤀ഀഀ
					AND DSC.[SalesCodeNameShort] NOT IN ('EXTREVWO','NB1REVWO'))਍ऀऀऀऀऀ伀刀 ഀഀ
					(DM.[MembershipShortName] IN  ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL') ਍ऀऀऀऀऀ䄀一䐀 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 䤀一 ⠀✀䔀堀吀刀䔀嘀圀伀✀⤀⤀ഀഀ
								--OR ਍ऀऀऀऀऀऀऀऀⴀⴀऀ⠀䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀✀堀吀䐀䴀䔀䴀匀伀䰀✀Ⰰ✀堀吀刀䄀一䐀䴀䔀䴀✀⤀⤀   ⴀⴀ刀攀洀漀瘀攀搀 刀䠀 　㈀⼀㄀㈀⼀㈀　㄀㔀 ⴀ 椀琀 搀椀搀 渀漀琀 氀椀洀椀琀 堀琀爀愀渀搀猀 爀攀瘀攀渀甀攀ഀഀ
					OR ਍ऀऀऀऀऀ⠀䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀✀一伀一倀䜀䴀✀⤀ 䄀一䐀 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 䤀一 ⠀✀䔀䘀吀䘀䔀䔀✀Ⰰ✀倀䌀倀䴀䈀刀倀䴀吀✀⤀⤀ഀഀ
					OR	਍ऀऀऀऀऀ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㈀　㈀　⤀ऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一  ⠀✀䔀堀吀䴀䔀䴀✀Ⰰ✀䔀堀吀䴀䔀䴀匀伀䰀✀Ⰰ ✀䔀堀吀倀刀䔀䴀䴀䔀一✀Ⰰ ✀䔀堀吀倀刀䔀䴀圀伀䴀✀Ⰰ✀刀刀䔀匀吀伀刀圀䬀✀Ⰰ✀刀刀䔀匀吀䈀䤀圀䬀✀Ⰰ✀刀刀䔀匀吀伀刀䔀✀Ⰰ✀䠀圀䄀一䄀䜀䔀一刀刀✀Ⰰ✀䠀圀䔀堀吀刀刀䈀䄀✀Ⰰ✀䠀圀䔀堀吀刀刀倀䰀✀Ⰰ✀䔀堀吀䘀䰀䔀堀✀Ⰰ✀䔀堀吀䘀䰀䔀堀匀伀䰀✀⤀⤀ഀഀ
					OR	਍ऀऀऀऀऀ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㈀　㈀　⤀ ⴀⴀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀✀堀吀刀䄀一䐀䴀䔀䴀✀Ⰰ✀堀吀䐀䴀䔀䴀匀伀䰀✀Ⰰ✀堀吀䐀䴀䔀䴀㄀　　　✀Ⰰ✀堀吀䐀䴀匀伀㄀　　　✀⤀⤀  ⴀⴀ䄀搀搀攀搀 刀䠀 　㈀⼀㄀㈀⼀㈀　㄀㔀 琀漀 氀椀洀椀琀 堀琀爀愀渀搀猀 爀攀瘀攀渀甀攀 琀漀 眀栀攀爀攀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㈀　㈀　⤀ഀഀ
					AND DM.[BusinessSegmentID] = 6 AND DM.[RevenueGroupID] = 2 ) --RH 8/13/2018਍ऀऀऀऀऀ伀刀ഀഀ
					(DSC.[SalesCodeNameShort] IN ('PCPREVWO','PCPMBRPMT','EFTFEE') AND DM.[MembershipShortName] NOT IN ('NONPGM', 'GRDSVEZ')) ) ਍ऀऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ऀ䔀䰀匀䔀 　 ഀഀ
				END AS PCP_PCPAmt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020) AND DM.[BusinessSegmentID] = 1 AND DM.[RevenueGroupID] = 2਍ऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀✀一伀一倀䜀䴀✀Ⰰ✀堀吀刀䄀一䐀䴀䔀䴀✀Ⰰ✀堀吀䐀䴀䔀䴀匀伀䰀✀Ⰰ✀堀吀䐀䴀䔀䴀㄀　　　✀Ⰰ✀堀吀䐀䴀匀伀㄀　　　✀⤀ ഀഀ
					AND DSC.[SalesCodeNameShort] NOT IN ('EXTREVWO','NB1REVWO'))਍ऀऀऀऀ伀刀 ഀഀ
				(DM.[BusinessSegmentID] = 1 AND DSC.[SalesCodeNameShort] IN ('EFTFEE','PCPMBRPMT','PCPREVWO'))																		਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ഀഀ
			END AS PCP_BioAmt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020) --Membership Revenue਍ऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 㘀 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㈀ ⤀ഀഀ
					--AND DM.[MembershipShortName] IN('XTRANDMEM','XTDMEMSOL','XTDMEM1000','XTDMSO1000')) --This is already in BusinessSegmentID = 6਍ऀऀऀऀ伀刀 ഀഀ
				(DM.[BusinessSegmentID] = 6 AND DSC.[SalesCodeNameShort] IN ('EFTFEE','PCPMBRPMT','PCPREVWO')਍ऀऀऀऀऀऀऀऀⴀⴀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一⠀✀堀吀刀䄀一䐀䴀䔀䴀✀Ⰰ✀堀吀䐀䴀䔀䴀匀伀䰀✀Ⰰ✀堀吀䐀䴀䔀䴀㄀　　　✀Ⰰ✀堀吀䐀䴀匀伀㄀　　　✀⤀ ഀഀ
					AND DM.[RevenueGroupID] = 2 )				਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　  ഀഀ
			END AS PCP_XtrAmt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020) ਍ऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㈀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㈀⤀ഀഀ
				OR ਍ऀऀऀऀ⠀䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一  ⠀✀䔀堀吀䴀䔀䴀✀Ⰰ✀䔀堀吀䴀䔀䴀匀伀䰀✀Ⰰ ✀䔀堀吀倀刀䔀䴀䴀䔀一✀Ⰰ ✀䔀堀吀倀刀䔀䴀圀伀䴀✀Ⰰ✀刀刀䔀匀吀伀刀圀䬀✀Ⰰ✀刀刀䔀匀吀䈀䤀圀䬀✀Ⰰ✀刀刀䔀匀吀伀刀䔀✀Ⰰ✀䠀圀䄀一䄀䜀䔀一刀刀✀Ⰰ✀䠀圀䔀堀吀刀刀䈀䄀✀Ⰰ✀䠀圀䔀堀吀刀刀倀䰀✀Ⰰ✀䔀堀吀䘀䰀䔀堀✀Ⰰ✀䔀堀吀䘀䰀䔀堀匀伀䰀✀⤀ ഀഀ
					AND DSC.[SalesCodeNameShort] IN ('EXTREVWO'))਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ऀഀഀ
			END AS PCP_ExtMemAmt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020, 7035)  --Added RH 01/16/2015਍ऀऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀✀一伀一倀䜀䴀✀Ⰰ✀刀䔀吀䄀䤀䰀✀Ⰰ✀䠀䌀䘀䬀✀⤀ऀ䄀一䐀 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 一伀吀 䤀一 ⠀✀倀䌀倀䴀䈀刀倀䴀吀✀Ⰰ✀䔀䘀吀䘀䔀䔀✀⤀⤀ഀഀ
			THEN FST.[OrderExtendedPriceCalc]	ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 倀䌀倀一漀渀倀最洀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㄀　㜀　⤀ 吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 ഀഀ
		END AS PCP_UpgCnt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN (1080)  THEN 1 ELSE 0 ਍ऀऀ䔀一䐀 䄀匀 倀䌀倀开䐀眀渀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㔀　㄀　Ⰰ㔀　㈀　Ⰰ㔀　㌀　Ⰰ㔀　㌀㔀Ⰰ㔀　㌀㜀Ⰰ㔀　㐀　Ⰰ㔀　㔀　Ⰰ㜀　㌀㔀⤀ 䄀一䐀 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 㰀㸀 ✀䄀䐀䐀伀一䴀䐀倀✀ ⤀ഀഀ
					AND DM.[BusinessSegmentID] IN (1,2,4,6) ਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 ഀഀ
			END AS ServiceAmt਍ഀഀ
	, CASE WHEN ( FST.[SalesCodeDepartmentId] = 3065 OR DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) ਍ऀऀऀ吀䠀䔀一 　 ഀഀ
			ELSE CASE WHEN ( dscd.SalesCodeDivisionID = 30 AND DM.[BusinessSegmentID] IN ( 1, 2, 4, 6, 7 ) )਍ऀऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 䔀一䐀 ഀഀ
			END AS RetailAmt਍ഀഀ
	, CASE WHEN ਍ऀऀऀ䌀䄀匀䔀 圀䠀䔀一 ⠀ 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㔀　㄀　Ⰰ㔀　㈀　Ⰰ㔀　㌀　Ⰰ㔀　㌀㔀Ⰰ㔀　㌀㜀Ⰰ㔀　㐀　Ⰰ㔀　㔀　Ⰰ㜀　㌀㔀⤀ 䄀一䐀 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 㰀㸀 ✀䄀䐀䐀伀一䴀䐀倀✀ ⤀ഀഀ
					AND DM.[BusinessSegmentID] IN (1,2,4,6) ਍ऀऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀 䔀䰀匀䔀 　 䔀一䐀 㸀 　 ഀഀ
				THEN 1 	ELSE 0 END AS ClientServicedCnt਍ഀഀ
	, CASE WHEN (dscd.SalesCodeDivisionID IN (20)) THEN FST.[OrderExtendedPriceCalc]	ELSE 0 	END AS NetMembershipAmt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] NOT IN (5060,5061,7010,7030,7050,7051) AND DSCD.[SalesCodeDivisionID] NOT IN (10)਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ऀ䔀䰀匀䔀 　 ऀഀഀ
			END AS NetSalesAmt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN (1010, 1075, 1090, 2025)  AND DM.[BusinessSegmentID] = 3 	AND FST.[IsRefunded] = 0਍ऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 ഀഀ
			END AS S_GrossSurCnt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010, 1075,1090 )  -- Conversions(MMConv) Renewals (MMRenew)਍ऀऀऀऀ䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀  椀渀 ⠀㐀㌀Ⰰ㐀㐀Ⰰ㈀㔀㤀Ⰰ㈀㘀　Ⰰ㈀㘀㄀Ⰰ㈀㘀㈀Ⰰ㈀㘀㌀Ⰰ㈀㘀㐀Ⰰ㈀㘀㔀Ⰰ㈀㘀㘀Ⰰ㈀㘀㜀Ⰰ㈀㘀㠀Ⰰ㈀㘀㤀Ⰰ㈀㜀　Ⰰ ㌀㄀㜀Ⰰ㌀㄀㘀⤀ ഀഀ
			THEN 1 ELSE 0 END ਍ऀऀⴀഀഀ
		CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 )  -- Cancellations (MMCancel)਍ऀऀऀऀ䄀一䐀 䘀匀吀⸀嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀  椀渀 ⠀㐀㌀Ⰰ㐀㐀Ⰰ㈀㔀㤀Ⰰ㈀㘀　Ⰰ㈀㘀㄀Ⰰ㈀㘀㈀Ⰰ㈀㘀㌀Ⰰ㈀㘀㐀Ⰰ㈀㘀㔀Ⰰ㈀㘀㘀Ⰰ㈀㘀㜀Ⰰ㈀㘀㠀Ⰰ㈀㘀㤀Ⰰ㈀㜀　Ⰰ㌀㄀㜀Ⰰ㌀㄀㘀⤀ ഀഀ
				AND DSC.[SalesCodeNameShort] <> 'CANCELADDON'		--Add-on 9/20/2017 rh ਍ऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 ഀഀ
			END AS S_SurCnt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN (2020) AND FST.[SalesCodeId] NOT IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665)  --These are Tri-Gen or PRP Add-Ons਍ऀऀऀऀ䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㌀ ഀഀ
			THEN FST.[OrderExtendedPriceCalc] ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 匀开匀甀爀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㌀　㘀㔀⤀⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀ഀഀ
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020) THEN FST.[OrderQuantity] ਍ऀऀऀ圀䠀䔀一 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀崀 䰀䤀䬀䔀 ✀─氀愀猀攀爀─✀ 䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㈀　㈀　⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀  ഀഀ
			ELSE 0 END AS LaserCnt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN (3065) THEN FST.[OrderExtendedPriceCalc] ELSE 0 ਍ऀऀऀ䔀一䐀 䄀匀 䰀愀猀攀爀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 匀攀爀瘀椀挀攀猀⸀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀䜀唀䤀䐀 䤀匀 一伀吀 一唀䰀䰀 吀䠀䔀一 ㄀ഀഀ
			WHEN FST.[SalesCodeDepartmentId] IN ( 1010 ) AND DM.[MembershipShortName] = 'MDP' THEN 1਍ऀऀऀ圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㄀　　㘀 ⤀ 䄀一䐀 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 㴀 ✀䄀䐀䐀伀一匀䴀倀✀ 吀䠀䔀一 ㄀   ⴀⴀ䄀搀搀攀搀 䈀漀猀氀攀礀 匀䴀倀ഀഀ
			ELSE 0 END ਍ऀऀⴀ ഀഀ
		CASE WHEN ( (FST.[SalesCodeDepartmentId] = 1099 AND  Services.SalesOrderDetailGUID IS NOT NULL) ਍ऀऀऀऀऀ伀刀 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㄀　㤀㤀  ⴀⴀ 䌀愀渀挀攀氀氀愀琀椀漀渀猀 ⠀䴀䴀䌀愀渀挀攀氀⤀ഀഀ
					AND  DM.[MembershipShortName] = 'MDP'  ) )਍ऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 ഀഀ
			END AS NB_MDPCnt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] = 5062 AND DSC.[SalesCodeNameShort] NOT IN ( 'ADDONMDP', 'SVCSMP' ) THEN FST.[OrderExtendedPriceCalc]਍ऀऀऀ圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㈀　㈀　 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 㴀 ✀䴀䐀倀✀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
			WHEN FST.[SalesCodeDepartmentId] IN ( 2030 ) AND DSC.[SalesCodeNameShort] = 'MEDADDONPMTSMP' THEN FST.[OrderExtendedPriceCalc] --Added Bosley SMP਍ऀऀऀ䔀䰀匀䔀 　  䔀一䐀 䄀匀 一䈀开䴀䐀倀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㌀　㘀㔀⤀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀⤀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀ഀഀ
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]਍ऀऀऀ圀䠀䔀一 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀崀 䰀䤀䬀䔀 ✀─氀愀猀攀爀─✀ 䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㈀　㈀　 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀ഀഀ
			ELSE 0 END AS NB_LaserCnt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]਍ऀऀऀ圀䠀䔀一 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀崀 䰀䤀䬀䔀 ✀─挀愀瀀─✀ 䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㈀　㈀　 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]਍ऀऀऀ䔀䰀匀䔀 　 䔀一䐀 䄀匀 一䈀开䰀愀猀攀爀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㌀　㘀㔀⤀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 䤀一 ⠀㈀Ⰰ㌀Ⰰ㐀Ⰰ㔀⤀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀ഀഀ
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )	THEN FST.[OrderQuantity]਍ऀऀऀ圀䠀䔀一 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀崀 䰀䤀䬀䔀 ✀─氀愀猀攀爀─✀ 䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㈀　㈀　 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 䤀一 ⠀㈀Ⰰ㌀Ⰰ㐀Ⰰ㔀⤀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀ഀഀ
			ELSE 0 END AS PCP_LaserCnt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]਍ऀऀऀ圀䠀䔀一 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀崀 䰀䤀䬀䔀 ✀─挀愀瀀─✀ 䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㈀　㈀　 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 䤀一 ⠀㈀Ⰰ㌀Ⰰ㐀Ⰰ㔀⤀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 一伀吀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]  ਍ऀऀऀ䔀䰀匀䔀 　 䔀一䐀 䄀匀 倀䌀倀开䰀愀猀攀爀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀ 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㌀　㘀㔀 ⤀ 吀䠀䔀一 　ഀഀ
			ELSE CASE WHEN ( dscd.SalesCodeDivisionID = 30 AND DM.[BusinessSegmentID] IN ( 1, 2, 4, 6, 7 ) AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]਍ऀऀऀऀऀऀ䔀䰀匀䔀 　 䔀一䐀ऀഀഀ
			END AS EMP_RetailAmt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]਍ऀऀऀ圀䠀䔀一 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀崀 䰀䤀䬀䔀 ✀─挀愀瀀─✀ 䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㈀　㈀　 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀ഀഀ
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity] ਍ऀऀऀ䔀䰀匀䔀 　 䔀一䐀 䄀匀 䔀䴀倀开一䈀开䰀愀猀攀爀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㌀　㘀㔀⤀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]਍ऀऀऀ圀䠀䔀一 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀崀 䰀䤀䬀䔀 ✀─氀愀猀攀爀─✀ 䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㈀　㈀　 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
			ELSE 0 END AS EMP_NB_LaserAmt਍ഀഀ
	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity] ਍ऀऀऀ圀䠀䔀一 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀崀 䰀䤀䬀䔀 ✀─挀愀瀀─✀ 䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㈀　㈀　 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 䤀一 ⠀㈀Ⰰ㌀Ⰰ㐀Ⰰ㔀⤀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀儀甀愀渀琀椀琀礀崀  ഀഀ
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]  ਍ऀऀऀ䔀䰀匀䔀 　 䔀一䐀 䄀匀 䔀䴀倀开倀䌀倀开䰀愀猀攀爀䌀渀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀㌀　㘀㔀⤀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 䤀一 ⠀㈀Ⰰ㌀Ⰰ㐀Ⰰ㔀⤀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]਍ऀऀऀ圀䠀䔀一 ⠀䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀崀 䰀䤀䬀䔀 ✀─氀愀猀攀爀─✀ 䄀一䐀 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 㴀 ㈀　㈀　 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 䤀一 ⠀㈀Ⰰ㌀Ⰰ㐀Ⰰ㔀⤀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 䤀一 ⠀ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䔀䴀倀䰀伀夀堀吀刀✀Ⰰ ✀䔀䴀倀䰀伀夀䴀䐀倀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ ⤀ 吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
			ELSE 0 END AS EMP_PCP_LaserAmt਍ഀഀ
-- **** New Metrics based on SQL06 ->[HC_BI_CMS_DDS].[bi_cms_dds].[vwFactSalesConect] ******਍ഀഀ
	,  (((isnull(FST.[OrderPrice],(0))*isnull(FST.[OrderQuantity],(0))-isnull(FST.[OrderDiscount],(0)))਍ऀऀऀऀऀऀऀऀऀऀ⬀椀猀渀甀氀氀⠀䘀匀吀⸀嬀伀爀搀攀爀吀愀砀㄀崀Ⰰ⠀　⤀⤀⤀⬀椀猀渀甀氀氀⠀䘀匀吀⸀嬀伀爀搀攀爀吀愀砀㈀崀Ⰰ⠀　⤀⤀⤀ ഀഀ
		AS	[SF-ExtendedPricePlusTax]  ਍ഀഀ
਍ऀⰀ  ⠀椀猀渀甀氀氀⠀䘀匀吀⸀嬀伀爀搀攀爀吀愀砀㄀崀Ⰰ⠀　⤀⤀⬀椀猀渀甀氀氀⠀䘀匀吀⸀嬀伀爀搀攀爀吀愀砀㈀崀Ⰰ⠀　⤀⤀⤀ ഀഀ
		AS [SF-TotalTaxAmount]  ਍ഀഀ
	,CASE WHEN ( DM.[BusinessSegmentID] = 1 AND DM.[RevenueGroupID] = 2 AND FST.[SalesCodeId] = 351 ) ਍ऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 䄀匀 倀䌀倀开䌀堀䰀ഀഀ
਍ऀⰀ䌀䄀匀䔀 圀䠀䔀一 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 䤀一 ⠀ ✀䄀䰀䌀䠀伀䠀✀Ⰰ ✀䄀䰀䌀䠀伀䠀㈀✀ ⤀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ ഀഀ
			THEN FST.[OrderExtendedPriceCalc] ELSE 0 END AS NB_ALCAmt਍ഀഀ
	,CASE WHEN DSC.[SalesCodeNameShort] IN ( 'ALCHOH', 'ALCHOH2' ) AND DM.[RevenueGroupID] = 2 AND DM.[MembershipShortName] = 'NONPGM' ਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 䔀一䐀 䄀匀 一䈀㈀开䄀䰀䌀䄀洀琀ഀഀ
਍ऀⰀ䌀䄀匀䔀 圀䠀䔀一 䐀匀䌀⸀嬀匀愀氀攀猀䌀漀搀攀一愀洀攀匀栀漀爀琀崀 䤀一 ⠀ ✀䄀䰀䌀䠀伀䠀✀Ⰰ ✀䄀䰀䌀䠀伀䠀㈀✀ ⤀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㈀ 䄀一䐀 䐀䴀⸀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 㰀㸀 ✀一伀一倀䜀䴀✀ ഀഀ
			THEN FST.[OrderExtendedPriceCalc] ELSE 0 END AS PCP_ALCAmt਍ऀऀഀഀ
	,CASE WHEN DSC.[SalesCodeNameShort] IN ('480-116') ਍ऀऀऀ吀䠀䔀一 䘀匀吀⸀嬀伀爀搀攀爀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀 䔀䰀匀䔀 　 䔀一䐀 䄀匀 刀攀琀愀椀氀开匀倀䄀䄀洀琀ഀഀ
਍ऀⰀ 䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㄀　㤀㤀 ⤀ 䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 ㄀ 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ ഀഀ
			THEN 1 ELSE 0 END AS NB_XTRP_CancelCnt਍ഀഀ
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 ) AND DM.[BusinessSegmentID] = 2 AND DM.[RevenueGroupID] = 1 ਍ऀऀऀ吀䠀䔀一 ㄀ 䔀䰀匀䔀 　 䔀一䐀 䄀匀 一䈀开䔀堀吀开䌀愀渀挀攀氀䌀渀琀ഀഀ
਍ऀⰀ䌀䄀匀䔀 圀䠀䔀一 䘀匀吀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀搀崀 䤀一 ⠀ ㄀　㤀㤀 ⤀ 䄀一䐀 䐀䴀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 㘀 䄀一䐀 䐀䴀⸀嬀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀崀 㴀 ㄀ഀഀ
			THEN 1 ELSE 0 END AS NB_XTR_CancelCnt਍ഀഀ
਍ഀഀ
FROM [dbo].[FactSalesTransaction] FST਍ऀ䤀一一䔀刀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䴀攀洀戀攀爀猀栀椀瀀崀 䐀䴀ഀഀ
		ON FST.[MembershipId] = DM.[MembershipId] ਍ऀ䤀一一䔀刀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀甀猀琀漀洀攀爀䴀攀洀戀攀爀猀栀椀瀀崀 䐀䌀䴀 ഀഀ
		ON DCM.[CustomerMembershipID] = FST.[CustomerMembershipId]਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀匀愀氀攀猀䌀漀搀攀崀 䐀匀䌀 ഀഀ
		ON DSC.[SalesCodeID] = FST.[SalesCodeId]਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀崀 䐀匀䌀䐀 ഀഀ
		ON DSCD.[SalesCodeDepartmentID] = FST.[SalesCodeDepartmentId]਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开挀昀最䌀漀渀昀椀最甀爀愀琀椀漀渀䌀攀渀琀攀爀崀 䌀䌀ഀഀ
		ON FST.[CenterId] = CC.CenterID ਍ऀ䰀䔀䘀吀 䨀伀䤀一 匀攀爀瘀椀挀攀猀 ഀഀ
		ON Services.SalesOrderDetailGUID = FST.[OrderDetailId] AND Services.RowID = 1਍ऀ䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 䴀䔀䐀䄀䐀䐀伀一 ഀഀ
		ON MEDADDON.SalesOrderDetailGUID = FST.[OrderDetailId] AND MEDADDON.Ranking = 1਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䴀攀洀戀攀爀猀栀椀瀀崀 倀刀䔀嘀䐀䴀ഀഀ
		ON FST.[PreviousMembershipId] = PREVDM.[MembershipId] ਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀攀渀琀攀爀崀 䐀䌀 ഀഀ
		ON DC.[CenterID] = FST.[CenterId]਍ऀ䰀䔀䘀吀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀吀椀洀攀娀漀渀攀崀 吀娀ഀഀ
		ON TZ.[TimeZoneID] = DC.[TimeZoneID]਍ഀഀ
WHERE (FST.[IsVoided] = 0 AND FST.[IsClosed] = 1) AND CONVERT(DATE,FST.[OrderDate]) >= '2019-01-01';਍䜀伀ഀഀ
