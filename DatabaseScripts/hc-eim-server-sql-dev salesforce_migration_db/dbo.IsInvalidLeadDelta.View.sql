/****** Object:  View [dbo].[IsInvalidLeadDelta]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
਍ഀഀ
/****** Object:  StoredProcedure [ODS].[LeadValidation]    Script Date: 15/04/2021 8:58:12 a. m. ******/਍ഀഀ
CREATE VIEW [dbo].[IsInvalidLeadDelta] AS ਍ഀഀ
		SELECT DISTINCT਍ऀऀऀऀऀऀ氀⸀䤀搀ഀഀ
				,       1 AS 'IsInvalidLead'਍ऀऀऀऀ䘀刀伀䴀  嬀搀戀漀崀⸀嬀匀䰀䘀开倀爀漀搀开䰀攀愀搀猀开䐀䔀䰀吀䄀崀 氀ഀഀ
				WHERE  ((਍                                ⠀ഀഀ
                                    l.FirstName LIKE 'aaa%'਍ऀऀऀऀऀऀऀऀऀ伀刀 䤀匀一唀䴀䔀刀䤀䌀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䘀椀爀猀琀一愀洀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ ⤀㴀㄀ऀऀऀⴀⴀⴀⴀⴀ⨀⨀⨀⨀⨀挀栀愀渀最攀ഀഀ
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
									OR l.FirstName = ''਍                                ⤀ഀഀ
                                OR (਍                                    氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀愀愀愀─✀ഀഀ
									OR ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(l.LastName,'(',''),')',''),' ',''),'-','') ) = 1  -----*****change਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀戀戀戀─✀ഀഀ
                                    OR  l.LastName LIKE 'ccc%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀搀搀搀─✀ഀഀ
                                    OR  l.LastName LIKE 'eee%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀昀昀昀─✀ഀഀ
                                    OR  l.LastName LIKE 'ggg%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀栀栀栀─✀ഀഀ
                                    OR  l.LastName LIKE 'iii%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀樀樀樀─✀ഀഀ
                                    OR  l.LastName LIKE 'kkk%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀氀氀氀氀─✀ഀഀ
                                    OR  l.LastName LIKE 'mmm%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀渀渀渀─✀ഀഀ
                                    OR  l.LastName LIKE 'ooo%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀瀀瀀瀀─✀ഀഀ
                                    OR  l.LastName LIKE 'qqq%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀爀爀爀─✀ഀഀ
                                    OR  l.LastName LIKE 'sss%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀琀琀琀─✀ഀഀ
                                    OR  l.LastName LIKE 'uuu%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀瘀瘀瘀─✀ഀഀ
                                    OR  l.LastName LIKE 'www%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀砀砀砀─✀ഀഀ
                                    OR  l.LastName LIKE 'yyy%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀稀稀稀─✀ഀഀ
                                    OR  l.LastName LIKE '%[!@#$%^&*?:{}|<>\]%'				-----*****change removed (), periods (.), and forward slash /਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀嬀　ⴀ㤀崀─✀ഀഀ
                                    OR  l.LastName LIKE 'test%[0-9]%'						----***** change adde left bracket after 9 ]਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀琀攀猀琀✀ഀഀ
                                    OR  l.LastName LIKE '%test'਍                                    ⴀⴀ伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀琀攀猀琀─✀ऀऀऀऀऀⴀⴀⴀⴀⴀ⨀⨀⨀⨀⨀琀栀椀猀 椀猀 愀 挀栀愀渀最攀 戀攀挀愀甀猀攀 瀀攀漀瀀氀攀 渀愀洀攀搀 ✀吀攀猀琀愀✀Ⰰ ✀吀攀猀琀攀爀✀Ⰰ 吀攀猀琀愀瘀攀爀搀攀ഀഀ
                                    OR  l.LastName LIKE '123%'਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䤀一 ⠀ ✀䘀唀䌀䬀✀Ⰰ ✀䄀匀匀䠀伀䰀䔀✀Ⰰ ✀䘀唀䌀䬀䈀伀夀✀Ⰰ ✀匀䠀䤀吀✀Ⰰ ✀䈀䤀吀䌀䠀✀Ⰰ ✀䐀䤀䌀䬀䠀䔀䄀䐀✀Ⰰ ✀䴀伀吀䠀䔀刀䘀唀䌀䬀䔀刀✀ ⤀ഀഀ
									OR  l.LastName like '[.]'					-----*****this is a change		added check for periods only - s/b invalid਍                                    伀刀  氀⸀䰀愀猀琀一愀洀攀 䤀匀 一唀䰀䰀ഀഀ
									OR  l.LastName = ''਍                                ⤀ഀഀ
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
                        ))਍ഀഀ
਍ഀഀ
਍䜀伀ഀഀ
