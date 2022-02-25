/****** Object:  StoredProcedure [ODS].[LeadValidation]    Script Date: 1/10/2022 10:03:12 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀伀䐀匀崀⸀嬀䰀攀愀搀嘀愀氀椀搀愀琀椀漀渀崀 䄀匀ഀഀ
BEGIN਍ऀ䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 伀䐀匀⸀⌀䤀猀䤀渀瘀愀氀椀搀ഀഀ
	WITH਍ऀऀ⠀ഀഀ
			DISTRIBUTION = HASH ( [Id] ),਍ऀऀऀ䌀䰀唀匀吀䔀刀䔀䐀 䌀伀䰀唀䴀一匀吀伀刀䔀 䤀一䐀䔀堀ഀഀ
		)਍ऀ䄀匀ഀഀ
		SELECT DISTINCT਍ऀऀऀऀऀऀ氀⸀䤀搀ഀഀ
				,       1 AS 'IsInvalidLead'਍ऀऀऀऀ䘀刀伀䴀    伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 氀ഀഀ
				WHERE  Lead_Activity_Status__c = 'Invalid' or ((਍                                ⠀ഀഀ
                                    l.FirstName LIKE 'aaa%'਍ऀऀऀऀऀऀऀऀऀ伀刀 䤀匀一唀䴀䔀刀䤀䌀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䰀愀猀琀一愀洀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ ⤀㴀㄀ऀऀऀⴀⴀⴀⴀⴀ⨀⨀⨀⨀⨀挀栀愀渀最攀ഀഀ
                                    OR l.FirstName LIKE 'bbb%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀挀挀挀─✀ഀഀ
                                    OR l.FirstName LIKE 'ddd%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀攀攀攀─✀ഀഀ
                                    OR l.FirstName LIKE 'fff%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀最最最─✀ഀഀ
                                    OR l.FirstName LIKE 'hhh%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀椀椀椀─✀ഀഀ
                                    OR l.FirstName LIKE 'jjj%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀欀欀欀─✀ഀഀ
                                    OR l.FirstName LIKE 'llll%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀洀洀洀─✀ഀഀ
                                    OR l.FirstName LIKE 'nnn%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀漀漀漀─✀ഀഀ
                                    OR l.FirstName LIKE 'ppp%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀焀焀焀─✀ഀഀ
                                    OR l.FirstName LIKE 'rrr%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀猀猀猀─✀ഀഀ
                                    OR l.FirstName LIKE 'ttt%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀甀甀甀─✀ഀഀ
                                    OR l.FirstName LIKE 'vvv%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀眀眀眀─✀ഀഀ
                                    OR l.FirstName LIKE 'xxx%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀礀礀礀─✀ഀഀ
                                    OR l.FirstName LIKE 'zzz%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀─嬀℀䀀⌀␀─帀☀⨀㼀㨀笀紀簀㰀㸀尀崀─✀ऀऀऀऀऀⴀⴀⴀⴀⴀ⨀⨀⨀⨀⨀挀栀愀渀最攀 爀攀洀漀瘀攀搀 ⠀⤀Ⰰ 瀀攀爀椀漀搀猀 ⠀⸀⤀Ⰰ 愀渀搀 昀漀爀眀愀爀搀 猀氀愀猀栀 ⼀ഀഀ
                                    OR l.FirstName LIKE '[0-9]%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀琀攀猀琀─嬀　ⴀ㤀崀✀ഀഀ
                                    OR l.FirstName LIKE 'test'਍                                    ⴀⴀ伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀琀攀猀琀─✀ഀഀ
                                    OR l.FirstName LIKE '%test'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀㄀㈀㌀─✀ഀഀ
                                    OR l.FirstName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䤀匀 一唀䰀䰀ഀഀ
                                )਍                                伀刀 ⠀ഀഀ
                                    l.LastName LIKE 'aaa%'਍ऀऀऀऀऀऀऀऀऀ伀刀 䤀匀一唀䴀䔀刀䤀䌀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䰀愀猀琀一愀洀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ ⤀ 㴀 ㄀  ⴀⴀⴀⴀⴀ⨀⨀⨀⨀⨀挀栀愀渀最攀ഀഀ
                                    OR  l.LastName LIKE 'bbb%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀挀挀挀─✀ഀഀ
                                    OR  l.LastName LIKE 'ddd%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀攀攀攀─✀ഀഀ
                                    OR  l.LastName LIKE 'fff%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀最最最─✀ഀഀ
                                    OR  l.LastName LIKE 'hhh%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀椀椀椀─✀ഀഀ
                                    OR  l.LastName LIKE 'jjj%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀欀欀欀─✀ഀഀ
                                    OR  l.LastName LIKE 'llll%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀洀洀洀─✀ഀഀ
                                    OR  l.LastName LIKE 'nnn%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀漀漀漀─✀ഀഀ
                                    OR  l.LastName LIKE 'ppp%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀焀焀焀─✀ഀഀ
                                    OR  l.LastName LIKE 'rrr%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀猀猀猀─✀ഀഀ
                                    OR  l.LastName LIKE 'ttt%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀甀甀甀─✀ഀഀ
                                    OR  l.LastName LIKE 'vvv%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀眀眀眀─✀ഀഀ
                                    OR  l.LastName LIKE 'xxx%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀礀礀礀─✀ഀഀ
                                    OR  l.LastName LIKE 'zzz%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀─嬀℀䀀⌀␀─帀☀⨀㼀㨀笀紀簀㰀㸀尀崀─✀ऀऀऀऀⴀⴀⴀⴀⴀ⨀⨀⨀⨀⨀挀栀愀渀最攀 爀攀洀漀瘀攀搀 ⠀⤀Ⰰ 瀀攀爀椀漀搀猀 ⠀⸀⤀Ⰰ 愀渀搀 昀漀爀眀愀爀搀 猀氀愀猀栀 ⼀ഀഀ
                                    OR  l.LastName LIKE '[0-9]%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀琀攀猀琀─嬀　ⴀ㤀崀─✀ऀऀऀऀऀऀⴀⴀⴀⴀ⨀⨀⨀⨀⨀ 挀栀愀渀最攀 愀搀搀攀 氀攀昀琀 戀爀愀挀欀攀琀 愀昀琀攀爀 㤀 崀ഀഀ
                                    OR  l.LastName LIKE 'test'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀─琀攀猀琀✀ഀഀ
                                    --OR  l.LastName LIKE 'test%'					-----*****this is a change because people named 'Testa', 'Tester', Testaverde਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀㄀㈀㌀─✀ഀഀ
                                    OR  l.LastName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )਍ऀऀऀऀऀऀऀऀऀⴀⴀ伀刀  氀⸀䰀愀猀琀一愀洀攀 氀椀欀攀 ✀嬀⸀崀✀ऀऀऀऀऀⴀⴀⴀⴀⴀ⨀⨀⨀⨀⨀琀栀椀猀 椀猀 愀 挀栀愀渀最攀ऀऀ愀搀搀攀搀 挀栀攀挀欀 昀漀爀 瀀攀爀椀漀搀猀 漀渀氀礀 ⴀ 猀⼀戀 椀渀瘀愀氀椀搀ഀഀ
                                    OR  l.LastName IS NULL਍                                ⤀ഀഀ
                                OR ((l.FirstName = 'fat' AND l.LastName = 'ass')਍                                    伀刀 ⠀氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀洀椀挀欀攀礀✀ 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 㴀 ✀洀漀甀猀攀✀⤀ഀഀ
                                    OR (l.FirstName = 'minnie' AND l.LastName = 'mouse')਍                                    伀刀 ⠀氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀搀漀渀愀氀搀✀ 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 㴀 ✀搀甀挀欀✀⤀ഀഀ
                                    OR (l.FirstName = 'daisy' AND l.LastName = 'duck')਍                                    伀刀 ⠀氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀昀甀挀欀✀ 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 㴀 ✀漀昀昀✀⤀ഀഀ
                                    OR (l.FirstName = 'do not' AND l.LastName = 'use')਍                                    伀刀 ⠀氀⸀䘀椀爀猀琀一愀洀攀 䤀匀 一唀䰀䰀 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 䤀匀 一唀䰀䰀⤀ഀഀ
                                )਍                            ⤀ഀഀ
                        OR (    ਍                                氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─䀀栀挀昀洀⸀挀漀洀✀ഀഀ
                                OR  l.Email LIKE '%hairclub.com'਍                            ⤀ഀഀ
                        OR (਍                            ⠀ഀഀ
                                l.Email NOT LIKE '%[-A-Z0-9_][@][A-Z0-9]%[.][A-Z0-9]%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─䀀栀挀昀洀⸀挀漀洀✀ഀഀ
                                OR  l.Email LIKE '%hairclub.c%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─䀀琀攀猀琀⸀挀漀洀✀ഀഀ
                                OR  l.Email LIKE '%aaaa%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─戀戀戀戀─✀ഀഀ
                                OR  l.Email LIKE '%cccc%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─搀搀搀搀─✀ഀഀ
                                OR  l.Email LIKE '%eeee%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─昀昀昀昀─✀ഀഀ
                                OR  l.Email LIKE '%gggg%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─栀栀栀栀─✀ഀഀ
                                OR  l.Email LIKE '%iiii%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─樀樀樀樀─✀ഀഀ
                                OR  l.Email LIKE '%kkkk%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─氀氀氀氀─✀ഀഀ
                                OR  l.Email LIKE '%mmmm%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─渀渀渀渀─✀ഀഀ
                                OR  l.Email LIKE '%oooo%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─瀀瀀瀀瀀─✀ഀഀ
                                OR  l.Email LIKE '%rrrr%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─猀猀猀猀─✀ഀഀ
                                OR  l.Email LIKE '%tttt%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─甀甀甀甀─✀ഀഀ
                                OR  l.Email LIKE '%vvvv%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─眀眀眀眀─✀ഀഀ
                                OR  l.Email LIKE '%xxxx%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─礀礀礀礀─✀ഀഀ
                                OR  l.Email LIKE '%zzzz%'਍                                ⴀⴀ伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─䔀䴀䄀䤀䰀⸀䌀伀䴀✀ऀऀऀऀⴀⴀⴀⴀ⨀⨀⨀⨀⨀圀攀 戀攀氀椀攀瘀攀 琀栀椀猀 椀猀 愀 瘀愀氀椀搀 攀洀愀椀氀 搀漀洀愀椀渀ഀഀ
                                OR  l.Email LIKE 'TEST123@%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀吀䔀匀吀䀀─✀ഀഀ
                                OR  l.Email LIKE 'TEST#@%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀吀䔀匀吀倀䔀刀匀伀一䀀─✀ഀഀ
                                OR  l.Email LIKE 'TESTWEB@%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀吀䔀匀吀圀䔀䈀⌀䀀─✀ഀഀ
                                OR  l.Email IS NULL਍                            ⤀ഀഀ
                            AND (਍                                    䰀䔀一⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀⤀ 一伀吀 䈀䔀吀圀䔀䔀一 ㄀　 䄀一䐀 ㄀㔀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '0000%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㄀㄀㄀㄀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '2222%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㌀㌀㌀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '4444%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㔀㔀㔀㔀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '666%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㜀㜀㜀㜀㜀㜀㜀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '8888888%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㤀㤀㤀㤀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '123%'਍                                    ⴀⴀ伀刀  䤀匀一唀䴀䔀刀䤀䌀⠀氀⸀倀栀漀渀攀⤀ 㴀 　ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') IS NULL਍                                ⤀ഀഀ
                            AND (਍                                    䰀䔀一⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀⤀ 一伀吀 䈀䔀吀圀䔀䔀一 ㄀　 䄀一䐀 ㄀㔀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '0000%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㄀㄀㄀㄀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '2222%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㌀㌀㌀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '4444%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㔀㔀㔀㔀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '666%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㜀㜀㜀㜀㜀㜀㜀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '8888888%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㤀㤀㤀㤀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '123%'਍                                    ⴀⴀ伀刀  䤀匀一唀䴀䔀刀䤀䌀⠀氀⸀倀栀漀渀攀⤀ 㴀 　ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') IS NULL਍                                ⤀ഀഀ
                        ))਍䔀一䐀ഀഀ
਍䜀伀ഀഀ
