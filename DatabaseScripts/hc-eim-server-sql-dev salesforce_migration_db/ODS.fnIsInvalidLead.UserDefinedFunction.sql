/****** Object:  UserDefinedFunction [ODS].[fnIsInvalidLead]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 䘀唀一䌀吀䤀伀一 嬀伀䐀匀崀⸀嬀昀渀䤀猀䤀渀瘀愀氀椀搀䰀攀愀搀崀 ⠀䀀匀䘀䐀䌀开䰀攀愀搀䤀䐀 嬀一嘀䄀刀䌀䠀䄀刀崀⠀㌀　⤀⤀ 刀䔀吀唀刀一匀 吀䄀䈀䰀䔀ഀഀ
AS਍刀䔀吀唀刀一 ⠀ഀഀ
        SELECT DISTINCT਍                氀⸀䤀搀ഀഀ
        ,       1 AS 'IsInvalidLead'਍        䘀刀伀䴀    伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 氀ഀഀ
        WHERE   l.Id = @SFDC_LeadID਍                䄀一䐀 ⠀⠀ഀഀ
                        (਍                            氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀愀愀愀─✀ഀഀ
                            OR l.FirstName LIKE 'bbb%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀挀挀挀─✀ഀഀ
                            OR l.FirstName LIKE 'ddd%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀攀攀攀─✀ഀഀ
                            OR l.FirstName LIKE 'fff%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀最最最─✀ഀഀ
                            OR l.FirstName LIKE 'hhh%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀椀椀椀─✀ഀഀ
                            OR l.FirstName LIKE 'jjj%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀欀欀欀─✀ഀഀ
                            OR l.FirstName LIKE 'llll%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀洀洀洀─✀ഀഀ
                            OR l.FirstName LIKE 'nnn%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀漀漀漀─✀ഀഀ
                            OR l.FirstName LIKE 'ppp%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀焀焀焀─✀ഀഀ
                            OR l.FirstName LIKE 'rrr%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀猀猀猀─✀ഀഀ
                            OR l.FirstName LIKE 'ttt%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀甀甀甀─✀ഀഀ
                            OR l.FirstName LIKE 'vvv%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀眀眀眀─✀ഀഀ
                            OR l.FirstName LIKE 'xxx%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀礀礀礀─✀ഀഀ
                            OR l.FirstName LIKE 'zzz%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀─嬀─␀℀⌀䀀⨀崀─✀ഀഀ
                            OR l.FirstName LIKE '[0-9]%'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀琀攀猀琀─嬀　ⴀ㤀崀✀ഀഀ
                            OR l.FirstName LIKE 'test'਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䰀䤀䬀䔀 ✀㄀㈀㌀─✀ഀഀ
                            OR l.FirstName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )਍                            伀刀 氀⸀䘀椀爀猀琀一愀洀攀 䤀匀 一唀䰀䰀ഀഀ
                        )਍                        伀刀 ⠀ഀഀ
                            l.LastName LIKE 'aaa%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀戀戀戀─✀ഀഀ
                            OR  l.LastName LIKE 'ccc%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀搀搀搀─✀ഀഀ
                            OR  l.LastName LIKE 'eee%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀昀昀昀─✀ഀഀ
                            OR  l.LastName LIKE 'ggg%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀栀栀栀─✀ഀഀ
                            OR  l.LastName LIKE 'iii%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀樀樀樀─✀ഀഀ
                            OR  l.LastName LIKE 'kkk%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀氀氀氀氀─✀ഀഀ
                            OR  l.LastName LIKE 'mmm%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀渀渀渀─✀ഀഀ
                            OR  l.LastName LIKE 'ooo%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀瀀瀀瀀─✀ഀഀ
                            OR  l.LastName LIKE 'qqq%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀爀爀爀─✀ഀഀ
                            OR  l.LastName LIKE 'sss%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀琀琀琀─✀ഀഀ
                            OR  l.LastName LIKE 'uuu%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀瘀瘀瘀─✀ഀഀ
                            OR  l.LastName LIKE 'www%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀砀砀砀─✀ഀഀ
                            OR  l.LastName LIKE 'yyy%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀稀稀稀─✀ഀഀ
                            OR  l.LastName LIKE '%[&%$!#@*]%'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀嬀　ⴀ㤀崀─✀ഀഀ
                            OR  l.LastName LIKE 'test%[0-9]'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀琀攀猀琀✀ഀഀ
                            OR  l.LastName LIKE '%test'਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䰀䤀䬀䔀 ✀㄀㈀㌀─✀ഀഀ
                            OR  l.LastName IN ( 'FUCK', 'ASSHOLE', 'FUCKBOY', 'SHIT', 'BITCH', 'DICKHEAD', 'MOTHERFUCKER' )਍                            伀刀  氀⸀䰀愀猀琀一愀洀攀 䤀匀 一唀䰀䰀ഀഀ
                        )਍                        伀刀 ⠀⠀氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀昀愀琀✀ 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 㴀 ✀愀猀猀✀⤀ഀഀ
                            OR (l.FirstName = 'mickey' AND l.LastName = 'mouse')਍                            伀刀 ⠀氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀洀椀渀渀椀攀✀ 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 㴀 ✀洀漀甀猀攀✀⤀ഀഀ
                            OR (l.FirstName = 'donald' AND l.LastName = 'duck')਍                            伀刀 ⠀氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀搀愀椀猀礀✀ 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 㴀 ✀搀甀挀欀✀⤀ഀഀ
                            OR (l.FirstName = 'fuck' AND l.LastName = 'off')਍                            伀刀 ⠀氀⸀䘀椀爀猀琀一愀洀攀 㴀 ✀搀漀 渀漀琀✀ 䄀一䐀 氀⸀䰀愀猀琀一愀洀攀 㴀 ✀甀猀攀✀⤀ഀഀ
                        )਍                    ⤀ഀഀ
                OR (਍                    ⠀ഀഀ
                        l.Name NOT LIKE '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─䀀栀挀昀洀⸀挀漀洀✀ഀഀ
                        OR  l.Name LIKE '%hairclub.com'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─䀀琀攀猀琀⸀挀漀洀✀ഀഀ
                        OR  l.Name LIKE '%aaaa%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─戀戀戀戀─✀ഀഀ
                        OR  l.Name LIKE '%cccc%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─搀搀搀搀─✀ഀഀ
                        OR  l.Name LIKE '%eeee%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─昀昀昀昀─✀ഀഀ
                        OR  l.Name LIKE '%gggg%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─栀栀栀栀─✀ഀഀ
                        OR  l.Name LIKE '%iiii%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─樀樀樀樀─✀ഀഀ
                        OR  l.Name LIKE '%kkkk%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─氀氀氀氀─✀ഀഀ
                        OR  l.Name LIKE '%mmmm%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─渀渀渀渀─✀ഀഀ
                        OR  l.Name LIKE '%oooo%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─瀀瀀瀀瀀─✀ഀഀ
                        OR  l.Name LIKE '%rrrr%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─猀猀猀猀─✀ഀഀ
                        OR  l.Name LIKE '%tttt%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─甀甀甀甀─✀ഀഀ
                        OR  l.Name LIKE '%vvvv%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─眀眀眀眀─✀ഀഀ
                        OR  l.Name LIKE '%xxxx%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─礀礀礀礀─✀ഀഀ
                        OR  l.Name LIKE '%zzzz%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀─䔀䴀䄀䤀䰀⸀䌀伀䴀✀ഀഀ
                        OR  l.Name LIKE 'TEST123@%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀吀䔀匀吀䀀─✀ഀഀ
                        OR  l.Name LIKE 'TEST#@%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀吀䔀匀吀倀䔀刀匀伀一䀀─✀ഀഀ
                        OR  l.Name LIKE 'TESTWEB@%'਍                        伀刀  氀⸀一愀洀攀 䰀䤀䬀䔀 ✀吀䔀匀吀圀䔀䈀⌀䀀─✀ഀഀ
                        OR  l.Name IS NULL਍                    ⤀ഀഀ
                    AND (਍                            䰀䔀一⠀氀⸀倀栀漀渀攀䄀戀爀开开挀⤀ 一伀吀 䈀䔀吀圀䔀䔀一 ㄀　 䄀一䐀 ㄀㔀ഀഀ
                            OR  l.PhoneAbr__c LIKE '0000%'਍                            伀刀  氀⸀倀栀漀渀攀䄀戀爀开开挀 䰀䤀䬀䔀 ✀㄀㄀㄀㄀─✀ഀഀ
                            OR  l.PhoneAbr__c LIKE '2222%'਍                            伀刀  氀⸀倀栀漀渀攀䄀戀爀开开挀 䰀䤀䬀䔀 ✀㌀㌀㌀─✀ഀഀ
                            OR  l.PhoneAbr__c LIKE '4444%'਍                            伀刀  氀⸀倀栀漀渀攀䄀戀爀开开挀 䰀䤀䬀䔀 ✀㔀㔀㔀㔀─✀ഀഀ
                            OR  l.PhoneAbr__c LIKE '666%'਍                            伀刀  氀⸀倀栀漀渀攀䄀戀爀开开挀 䰀䤀䬀䔀 ✀㜀㜀㜀㜀㜀㜀㜀─✀ഀഀ
                            OR  l.PhoneAbr__c LIKE '8888888%'਍                            伀刀  氀⸀倀栀漀渀攀䄀戀爀开开挀 䰀䤀䬀䔀 ✀㤀㤀㤀㤀─✀ഀഀ
                            OR  l.PhoneAbr__c LIKE '123%'਍                            伀刀  䤀匀一唀䴀䔀刀䤀䌀⠀氀⸀倀栀漀渀攀䄀戀爀开开挀⤀ 㴀 　ഀഀ
                            OR  l.PhoneAbr__c IS NULL਍                        ⤀ഀഀ
                ))਍⤀ഀഀ
GO਍
