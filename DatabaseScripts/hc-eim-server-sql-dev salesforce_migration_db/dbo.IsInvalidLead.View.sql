/****** Object:  View [dbo].[IsInvalidLead]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
਍⼀⨀⨀⨀⨀⨀⨀ 伀戀樀攀挀琀㨀  匀琀漀爀攀搀倀爀漀挀攀搀甀爀攀 嬀伀䐀匀崀⸀嬀䰀攀愀搀嘀愀氀椀搀愀琀椀漀渀崀    匀挀爀椀瀀琀 䐀愀琀攀㨀 ㄀㔀⼀　㐀⼀㈀　㈀㄀ 㠀㨀㔀㠀㨀㄀㈀ 愀⸀ 洀⸀ ⨀⨀⨀⨀⨀⨀⼀ഀഀ
਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀䤀猀䤀渀瘀愀氀椀搀䰀攀愀搀崀 䄀匀 ഀഀ
਍ऀऀ匀䔀䰀䔀䌀吀 䐀䤀匀吀䤀一䌀吀ഀഀ
						l.Id਍ऀऀऀऀⰀ       ㄀ 䄀匀 ✀䤀猀䤀渀瘀愀氀椀搀䰀攀愀搀✀ഀഀ
				FROM  [dbo].[SLF_Prod_Leads] l਍ऀऀऀऀ圀䠀䔀刀䔀  ⠀⠀ഀഀ
                                (਍                                    氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀愀愀愀─✀ഀഀ
									OR ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(l.FirstName,'(',''),')',''),' ',''),'-','') )=1			-----*****change਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀戀戀戀─✀ഀഀ
                                    OR l.FirstName LIKE 'ccc%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀搀搀搀─✀ഀഀ
                                    OR l.FirstName LIKE 'eee%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀昀昀昀─✀ഀഀ
                                    OR l.FirstName LIKE 'ggg%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀栀栀栀─✀ഀഀ
                                    OR l.FirstName LIKE 'iii%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀樀樀樀─✀ഀഀ
                                    OR l.FirstName LIKE 'kkk%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀氀氀氀氀─✀ഀഀ
                                    OR l.FirstName LIKE 'mmm%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀渀渀渀─✀ഀഀ
                                    OR l.FirstName LIKE 'ooo%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀瀀瀀瀀─✀ഀഀ
                                    OR l.FirstName LIKE 'qqq%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀爀爀爀─✀ഀഀ
                                    OR l.FirstName LIKE 'sss%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀琀琀琀─✀ഀഀ
                                    OR l.FirstName LIKE 'uuu%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀瘀瘀瘀─✀ഀഀ
                                    OR l.FirstName LIKE 'www%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀砀砀砀─✀ഀഀ
                                    OR l.FirstName LIKE 'yyy%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀稀稀稀─✀ഀഀ
                                    OR l.FirstName LIKE '%[!@#$%^&*?:{}|<>\]%'					-----*****change removed (), periods (.), and forward slash /਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀嬀　ⴀ㤀崀─✀ഀഀ
                                    OR l.FirstName LIKE 'test%[0-9]'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀琀攀猀琀✀ഀഀ
                                    --OR l.FirstName LIKE 'test%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀─琀攀猀琀✀ഀഀ
                                    OR l.FirstName LIKE '123%'਍                                    伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䤀一 ⠀ ✀䘀唀䌀䬀✀Ⰰ ✀䄀匀匀䠀伀䰀䔀✀Ⰰ ✀䘀唀䌀䬀䈀伀夀✀Ⰰ ✀匀䠀䤀吀✀Ⰰ ✀䈀䤀吀䌀䠀✀Ⰰ ✀䐀䤀䌀䬀䠀䔀䄀䐀✀Ⰰ ✀䴀伀吀䠀䔀刀䘀唀䌀䬀䔀刀✀ ⤀ഀഀ
                                    OR l.FirstName IS NULL਍ऀऀऀऀऀऀऀऀऀ伀刀 氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀✀ഀഀ
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
                                    OR  l.LastName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )਍ऀऀऀऀऀऀऀऀऀ伀刀  氀⸀䰀愀猀琀一愀洀攀 氀椀欀攀 ✀嬀⸀崀✀ऀऀऀऀऀⴀⴀⴀⴀⴀ⨀⨀⨀⨀⨀琀栀椀猀 椀猀 愀 挀栀愀渀最攀ऀऀ愀搀搀攀搀 挀栀攀挀欀 昀漀爀 瀀攀爀椀漀搀猀 漀渀氀礀 ⴀ 猀⼀戀 椀渀瘀愀氀椀搀ഀഀ
                                    OR  l.LastName IS NULL਍ऀऀऀऀऀऀऀऀऀ伀刀  氀⸀䰀愀猀琀一愀洀攀 㴀 ✀✀ഀഀ
                                )਍                                伀刀 ⠀⠀氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀昀愀琀✀ 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 㴀 ✀愀猀猀✀⤀ഀഀ
                                    OR (l.FirstName = 'mickey' AND l.LastName = 'mouse')਍                                    伀刀 ⠀氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀洀椀渀渀椀攀✀ 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 㴀 ✀洀漀甀猀攀✀⤀ഀഀ
                                    OR (l.FirstName = 'donald' AND l.LastName = 'duck')਍                                    伀刀 ⠀氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀搀愀椀猀礀✀ 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 㴀 ✀搀甀挀欀✀⤀ഀഀ
                                    OR (l.FirstName = 'fuck' AND l.LastName = 'off')਍                                    伀刀 ⠀氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀搀漀 渀漀琀✀ 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 㴀 ✀甀猀攀✀⤀ഀഀ
                                    OR (l.FirstName IS NULL AND l.LastName IS NULL)਍                                ⤀ഀഀ
                            )਍                        伀刀 ⠀    ഀഀ
                                l.Email LIKE '%@hcfm.com'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─栀愀椀爀挀氀甀戀⸀挀漀洀✀ഀഀ
                            )਍                        伀刀 ⠀ഀഀ
                            (਍                                氀⸀䔀洀愀椀氀 一伀吀 䰀䤀䬀䔀 ✀─嬀ⴀ䄀ⴀ娀　ⴀ㤀开崀嬀䀀崀嬀䄀ⴀ娀　ⴀ㤀崀─嬀⸀崀嬀䄀ⴀ娀　ⴀ㤀崀─✀ഀഀ
                                OR  l.Email LIKE '%@hcfm.com'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─栀愀椀爀挀氀甀戀⸀挀─✀ഀഀ
                                OR  l.Email LIKE '%@test.com'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─愀愀愀愀─✀ഀഀ
                                OR  l.Email LIKE '%bbbb%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─挀挀挀挀─✀ഀഀ
                                OR  l.Email LIKE '%dddd%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─攀攀攀攀─✀ഀഀ
                                OR  l.Email LIKE '%ffff%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─最最最最─✀ഀഀ
                                OR  l.Email LIKE '%hhhh%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─椀椀椀椀─✀ഀഀ
                                OR  l.Email LIKE '%jjjj%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─欀欀欀欀─✀ഀഀ
                                OR  l.Email LIKE '%llll%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─洀洀洀洀─✀ഀഀ
                                OR  l.Email LIKE '%nnnn%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─漀漀漀漀─✀ഀഀ
                                OR  l.Email LIKE '%pppp%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─爀爀爀爀─✀ഀഀ
                                OR  l.Email LIKE '%ssss%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─琀琀琀琀─✀ഀഀ
                                OR  l.Email LIKE '%uuuu%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─瘀瘀瘀瘀─✀ഀഀ
                                OR  l.Email LIKE '%wwww%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─砀砀砀砀─✀ഀഀ
                                OR  l.Email LIKE '%yyyy%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀─稀稀稀稀─✀ഀഀ
                                --OR  l.Email LIKE '%EMAIL.COM'				----*****We believe this is a valid email domain਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀吀䔀匀吀㄀㈀㌀䀀─✀ഀഀ
                                OR  l.Email LIKE 'TEST@%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀吀䔀匀吀⌀䀀─✀ഀഀ
                                OR  l.Email LIKE 'TESTPERSON@%'਍                                伀刀  氀⸀䔀洀愀椀氀 䰀䤀䬀䔀 ✀吀䔀匀吀圀䔀䈀䀀─✀ഀഀ
                                OR  l.Email LIKE 'TESTWEB#@%'਍                                伀刀  氀⸀䔀洀愀椀氀 䤀匀 一唀䰀䰀ഀഀ
                            )਍                            䄀一䐀 ⠀ഀഀ
                                    LEN(REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','')) NOT BETWEEN 10 AND 15਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀　　　　─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '1111%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㈀㈀㈀㈀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '333%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㐀㐀㐀㐀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '5555%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㘀㘀㘀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '7777777%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㠀㠀㠀㠀㠀㠀㠀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.phone,'(',''),')',''),' ',''),'-','') LIKE '9999%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㄀㈀㌀─✀ഀഀ
                                    --OR  ISNUMERIC(l.Phone) = 0਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀瀀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䤀匀 一唀䰀䰀ഀഀ
                                )਍                            䄀一䐀 ⠀ഀഀ
                                    LEN(REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','')) NOT BETWEEN 10 AND 15਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀　　　　─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '1111%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㈀㈀㈀㈀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '333%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㐀㐀㐀㐀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '5555%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㘀㘀㘀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '7777777%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㠀㠀㠀㠀㠀㠀㠀─✀ഀഀ
                                    OR  REPLACE(REPLACE(REPLACE(REPLACE(l.MobilePhone,'(',''),')',''),' ',''),'-','') LIKE '9999%'਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䰀䤀䬀䔀 ✀㄀㈀㌀─✀ഀഀ
                                    --OR  ISNUMERIC(l.Phone) = 0਍                                    伀刀  刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀氀⸀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䤀匀 一唀䰀䰀ഀഀ
                                )਍                        ⤀⤀ഀഀ
਍ഀഀ
਍ഀഀ
GO਍
