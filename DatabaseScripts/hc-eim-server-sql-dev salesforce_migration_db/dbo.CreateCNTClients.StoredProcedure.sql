/****** Object:  StoredProcedure [dbo].[CreateCNTClients]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀戀漀崀⸀嬀䌀爀攀愀琀攀䌀一吀䌀氀椀攀渀琀猀崀⠀䀀琀愀戀氀攀 瘀愀爀挀栀愀爀⠀㄀　　⤀⤀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
਍䐀刀伀倀 吀䄀䈀䰀䔀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀㬀ഀഀ
਍猀攀氀攀挀琀 ⨀ഀഀ
into dbo.[CNT_Clients_Account_Final]਍昀爀漀洀 搀戀漀⸀嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开吀漀琀愀氀崀㬀ഀഀ
਍䐀䔀䰀䔀吀䔀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀ഀഀ
FROM [CNT_Clients_Account_Final]਍䤀一一䔀刀 䨀伀䤀一 嬀匀䰀䘀开倀爀漀搀开䰀攀愀搀猀崀 䄀ഀഀ
	ON TRIM(LOWER([CNT_Clients_Account_Final].EMAILADDRESS)) = TRIM(LOWER(a.Email)) ; --3.879਍ഀഀ
DELETE [CNT_Clients_Account_Final]਍䘀刀伀䴀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀ഀഀ
INNER JOIN [SLF_Prod_Leads] A਍ऀ伀一 吀刀䤀䴀⠀䰀伀圀䔀刀⠀嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㄀⤀⤀ 㴀 刀䔀倀䰀䄀䌀䔀⠀ഀഀ
													REPLACE(਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀ刀䔀倀䰀䄀䌀䔀⠀ഀഀ
																TRIM(LOWER(a.Phone))਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀⰀ✀⠀✀Ⰰ✀✀⤀ഀഀ
															,')','')਍ऀऀऀऀऀऀऀऀऀऀऀऀⰀ✀ ✀Ⰰ✀✀⤀ഀഀ
where ([CNT_Clients_Account_Final].PHONE1 != '0' ਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㄀ 渀漀琀 氀椀欀攀 ✀㄀㄀㄀㄀㄀㄀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE1 not like '222222%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㄀ 渀漀琀 氀椀欀攀 ✀㌀㌀㌀㌀㌀㌀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE1 not like '444444%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㄀ 渀漀琀 氀椀欀攀 ✀㔀㔀㔀㔀㔀㔀─✀ ഀഀ
				AND [CNT_Clients_Account_Final].PHONE1 not like '666666%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㄀ 渀漀琀 氀椀欀攀 ✀㜀㜀㜀㜀㜀㜀─✀ ഀഀ
				AND [CNT_Clients_Account_Final].PHONE1 not like '888888%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㄀ 渀漀琀 氀椀欀攀 ✀㤀㤀㤀㤀㤀㤀─✀⤀ ⴀⴀⴀ㜀㄀㐀ഀഀ
਍ഀഀ
DELETE [CNT_Clients_Account_Final]਍䘀刀伀䴀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀ഀഀ
INNER JOIN [SLF_Prod_Leads] A਍ऀ伀一 吀刀䤀䴀⠀䰀伀圀䔀刀⠀嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㈀⤀⤀ 㴀 刀䔀倀䰀䄀䌀䔀⠀ഀഀ
													REPLACE(਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀ刀䔀倀䰀䄀䌀䔀⠀ഀഀ
																TRIM(LOWER(a.Phone))਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀⰀ✀⠀✀Ⰰ✀✀⤀ഀഀ
															,')','')਍ऀऀऀऀऀऀऀऀऀऀऀऀⰀ✀ ✀Ⰰ✀✀⤀ഀഀ
where ([CNT_Clients_Account_Final].PHONE2 != '0' ਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㈀ 渀漀琀 氀椀欀攀 ✀㄀㄀㄀㄀㄀㄀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE2 not like '222222%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㈀ 渀漀琀 氀椀欀攀 ✀㌀㌀㌀㌀㌀㌀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE2 not like '444444%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㈀ 渀漀琀 氀椀欀攀 ✀㔀㔀㔀㔀㔀㔀─✀ ഀഀ
				AND [CNT_Clients_Account_Final].PHONE2 not like '666666%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㈀ 渀漀琀 氀椀欀攀 ✀㜀㜀㜀㜀㜀㜀─✀ ഀഀ
				AND [CNT_Clients_Account_Final].PHONE2 not like '888888%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㈀ 渀漀琀 氀椀欀攀 ✀㤀㤀㤀㤀㤀㤀─✀⤀ ⴀⴀⴀ㌀㐀ഀഀ
਍ഀഀ
DELETE [CNT_Clients_Account_Final]਍䘀刀伀䴀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀ഀഀ
INNER JOIN [SLF_Prod_Leads] A਍ऀ伀一 吀刀䤀䴀⠀䰀伀圀䔀刀⠀嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㌀⤀⤀ 㴀 刀䔀倀䰀䄀䌀䔀⠀ഀഀ
													REPLACE(਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀ刀䔀倀䰀䄀䌀䔀⠀ഀഀ
																TRIM(LOWER(a.Phone))਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀⰀ✀⠀✀Ⰰ✀✀⤀ഀഀ
															,')','')਍ऀऀऀऀऀऀऀऀऀऀऀऀⰀ✀ ✀Ⰰ✀✀⤀ഀഀ
where ([CNT_Clients_Account_Final].PHONE3 != '0' ਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㌀ 渀漀琀 氀椀欀攀 ✀㄀㄀㄀㄀㄀㄀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE3 not like '222222%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㌀ 渀漀琀 氀椀欀攀 ✀㌀㌀㌀㌀㌀㌀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE3 not like '444444%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㌀ 渀漀琀 氀椀欀攀 ✀㔀㔀㔀㔀㔀㔀─✀ ഀഀ
				AND [CNT_Clients_Account_Final].PHONE3 not like '666666%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㌀ 渀漀琀 氀椀欀攀 ✀㜀㜀㜀㜀㜀㜀─✀ ഀഀ
				AND [CNT_Clients_Account_Final].PHONE3 not like '888888%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㌀ 渀漀琀 氀椀欀攀 ✀㤀㤀㤀㤀㤀㤀─✀⤀ ⴀⴀ㄀　ഀഀ
਍ഀഀ
 ਍䐀䔀䰀䔀吀䔀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀ഀഀ
FROM [CNT_Clients_Account_Final]਍䤀一一䔀刀 䨀伀䤀一 嬀匀䰀䘀开倀爀漀搀开䰀攀愀搀猀崀 䄀ഀഀ
	ON TRIM(LOWER([CNT_Clients_Account_Final].PHONE1)) = REPLACE(਍ऀऀऀऀऀऀऀऀऀऀऀऀऀ刀䔀倀䰀䄀䌀䔀⠀ഀഀ
														REPLACE(਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀ吀刀䤀䴀⠀䰀伀圀䔀刀⠀愀⸀䴀漀戀椀氀攀倀栀漀渀攀⤀⤀ഀഀ
																,'(','')਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀⰀ✀⤀✀Ⰰ✀✀⤀ഀഀ
												,' ','')਍眀栀攀爀攀 ⠀嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㄀ ℀㴀 ✀　✀ ഀഀ
				AND [CNT_Clients_Account_Final].PHONE1 not like '111111%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㄀ 渀漀琀 氀椀欀攀 ✀㈀㈀㈀㈀㈀㈀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE1 not like '333333%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㄀ 渀漀琀 氀椀欀攀 ✀㐀㐀㐀㐀㐀㐀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE1 not like '555555%' ਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㄀ 渀漀琀 氀椀欀攀 ✀㘀㘀㘀㘀㘀㘀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE1 not like '777777%' ਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㄀ 渀漀琀 氀椀欀攀 ✀㠀㠀㠀㠀㠀㠀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE1 not like '999999%') ---5਍ഀഀ
਍䐀䔀䰀䔀吀䔀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀ഀഀ
FROM [CNT_Clients_Account_Final]਍䤀一一䔀刀 䨀伀䤀一 嬀匀䰀䘀开倀爀漀搀开䰀攀愀搀猀崀 䄀ഀഀ
	ON TRIM(LOWER([CNT_Clients_Account_Final].PHONE2)) = REPLACE(਍ऀऀऀऀऀऀऀऀऀऀऀऀऀ刀䔀倀䰀䄀䌀䔀⠀ഀഀ
														REPLACE(਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀ吀刀䤀䴀⠀䰀伀圀䔀刀⠀愀⸀䴀漀戀椀氀攀倀栀漀渀攀⤀⤀ഀഀ
																,'(','')਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀⰀ✀⤀✀Ⰰ✀✀⤀ഀഀ
												,' ','')਍眀栀攀爀攀 ⠀嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㈀ ℀㴀 ✀　✀ ഀഀ
				AND [CNT_Clients_Account_Final].PHONE2 not like '111111%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㈀ 渀漀琀 氀椀欀攀 ✀㈀㈀㈀㈀㈀㈀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE2 not like '333333%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㈀ 渀漀琀 氀椀欀攀 ✀㐀㐀㐀㐀㐀㐀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE2 not like '555555%' ਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㈀ 渀漀琀 氀椀欀攀 ✀㘀㘀㘀㘀㘀㘀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE2 not like '777777%' ਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㈀ 渀漀琀 氀椀欀攀 ✀㠀㠀㠀㠀㠀㠀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE2 not like '999999%') ---1਍ഀഀ
਍䐀䔀䰀䔀吀䔀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀ഀഀ
FROM [CNT_Clients_Account_Final]਍䤀一一䔀刀 䨀伀䤀一 嬀匀䰀䘀开倀爀漀搀开䰀攀愀搀猀崀 䄀ഀഀ
	ON TRIM(LOWER([CNT_Clients_Account_Final].PHONE3)) = REPLACE(਍ऀऀऀऀऀऀऀऀऀऀऀऀऀ刀䔀倀䰀䄀䌀䔀⠀ഀഀ
														REPLACE(਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀ吀刀䤀䴀⠀䰀伀圀䔀刀⠀愀⸀䴀漀戀椀氀攀倀栀漀渀攀⤀⤀ഀഀ
																,'(','')਍ऀऀऀऀऀऀऀऀऀऀऀऀऀऀऀⰀ✀⤀✀Ⰰ✀✀⤀ഀഀ
												,' ','')਍眀栀攀爀攀 ⠀嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㌀ ℀㴀 ✀　✀ ഀഀ
				AND [CNT_Clients_Account_Final].PHONE3 not like '111111%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㌀ 渀漀琀 氀椀欀攀 ✀㈀㈀㈀㈀㈀㈀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE3 not like '333333%'਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㌀ 渀漀琀 氀椀欀攀 ✀㐀㐀㐀㐀㐀㐀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE3 not like '555555%' ਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㌀ 渀漀琀 氀椀欀攀 ✀㘀㘀㘀㘀㘀㘀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE3 not like '777777%' ਍ऀऀऀऀ䄀一䐀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀倀䠀伀一䔀㌀ 渀漀琀 氀椀欀攀 ✀㠀㠀㠀㠀㠀㠀─✀ഀഀ
				AND [CNT_Clients_Account_Final].PHONE3 not like '999999%') --1਍ഀഀ
਍䐀䔀䰀䔀吀䔀 嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀ഀഀ
FROM [CNT_Clients_Account_Final]਍䤀一一䔀刀 䨀伀䤀一 嬀匀䰀䘀开倀爀漀搀开䰀攀愀搀猀崀 䄀ഀഀ
	ON TRIM(LOWER([CNT_Clients_Account_Final].firstname)) = TRIM(LOWER(a.FirstName))਍ऀऀ愀渀搀 吀刀䤀䴀⠀䰀伀圀䔀刀⠀嬀䌀一吀开䌀氀椀攀渀琀猀开䄀挀挀漀甀渀琀开䘀椀渀愀氀崀⸀氀愀猀琀渀愀洀攀⤀⤀ 㴀 吀刀䤀䴀⠀䰀伀圀䔀刀⠀愀⸀氀愀猀琀渀愀洀攀⤀⤀ഀഀ
਍䔀一䐀ഀഀ
GO਍
