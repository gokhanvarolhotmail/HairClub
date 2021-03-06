/****** Object:  UserDefinedFunction [ODS].[fnValidMail]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 䘀唀一䌀吀䤀伀一 嬀伀䐀匀崀⸀嬀昀渀嘀愀氀椀搀䴀愀椀氀崀 ⠀䀀䔀洀愀椀氀䤀渀 嬀瘀愀爀挀栀愀爀崀⠀㄀　　⤀⤀ 刀䔀吀唀刀一匀 瘀愀爀挀栀愀爀⠀㄀　　⤀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
਍ⴀⴀ 䌀爀攀愀琀攀搀㨀 㤀⼀䘀攀戀⼀㈀　㈀㄀ 䈀礀 䔀䤀䴀 吀攀愀洀ഀഀ
-- Purpose: Based on the logic received, this function validates the correct email address and returns the email address or NULL਍ⴀⴀ 䤀渀瀀甀琀 倀愀爀愀洀猀㨀 䔀䴀䄀䤀䰀 椀渀 瘀愀爀挀栀愀爀 搀愀琀愀 琀礀瀀攀ഀഀ
-- Output Params: EMAIL or NULL depending on the valid or not. In case the email is not valid, the it returns a NULL value਍ഀഀ
    DECLARE @EmailOut varchar(100);਍    匀䔀吀 䀀䔀洀愀椀氀伀甀琀 㴀ഀഀ
		CASE਍ऀऀⴀⴀ 吀栀攀 昀漀氀氀漀眀椀渀最 氀漀最椀挀 椀猀 爀攀甀猀攀搀 昀爀漀洀 琀栀攀 䈀䤀 攀渀瘀椀爀漀渀洀攀渀琀⸀ 䤀昀 愀渀礀 漀昀 琀栀攀 昀漀氀氀漀眀椀渀最 爀甀氀攀猀 最攀琀猀 搀攀琀攀挀琀攀搀Ⰰ 琀栀攀 攀䴀愀椀氀 椀猀 一伀吀 瘀愀氀椀搀ഀഀ
			WHEN PATINDEX('%[&'',":;!+=\/()<>]%', LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', ''))))) > 0 -- Invalid characters਍ऀऀऀ伀刀 倀䄀吀䤀一䐀䔀堀⠀✀嬀䀀⸀ⴀ开崀─✀Ⰰ 䰀伀圀䔀刀⠀䰀吀刀䤀䴀⠀刀吀刀䤀䴀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀䤀匀一唀䰀䰀⠀䌀伀一嘀䔀刀吀⠀嘀䄀刀䌀䠀䄀刀Ⰰ䀀䔀洀愀椀氀䤀渀⤀Ⰰ 一唀䰀䰀⤀Ⰰ ✀崀✀Ⰰ ✀✀⤀Ⰰ ✀嬀✀Ⰰ ✀✀⤀⤀⤀⤀⤀ 㸀 　 ⴀⴀ 嘀愀氀椀搀 戀甀琀 挀愀渀渀漀琀 戀攀 猀琀愀爀琀椀渀最 挀栀愀爀愀挀琀攀爀ഀഀ
			OR PATINDEX('%[@.-_]', LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', ''))))) > 0 -- Valid but cannot be ending character਍ऀऀऀ伀刀 䰀伀圀䔀刀⠀䰀吀刀䤀䴀⠀刀吀刀䤀䴀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀䤀匀一唀䰀䰀⠀䌀伀一嘀䔀刀吀⠀嘀䄀刀䌀䠀䄀刀Ⰰ䀀䔀洀愀椀氀䤀渀⤀Ⰰ 一唀䰀䰀⤀Ⰰ ✀崀✀Ⰰ ✀✀⤀Ⰰ ✀嬀✀Ⰰ ✀✀⤀⤀⤀⤀ 一伀吀 䰀䤀䬀䔀 ✀─䀀─⸀─✀ ⴀⴀ 䴀甀猀琀 挀漀渀琀愀椀渀 愀琀 氀攀愀猀琀 漀渀攀 䀀 愀渀搀 漀渀攀 ⸀ഀഀ
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%..%' -- Cannot have two periods in a row਍ऀऀऀ伀刀 䰀伀圀䔀刀⠀䰀吀刀䤀䴀⠀刀吀刀䤀䴀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀䤀匀一唀䰀䰀⠀䌀伀一嘀䔀刀吀⠀嘀䄀刀䌀䠀䄀刀Ⰰ䀀䔀洀愀椀氀䤀渀⤀Ⰰ 一唀䰀䰀⤀Ⰰ ✀崀✀Ⰰ ✀✀⤀Ⰰ ✀嬀✀Ⰰ ✀✀⤀⤀⤀⤀ 䰀䤀䬀䔀 ✀─䀀─䀀─✀ ⴀⴀ 䌀愀渀渀漀琀 栀愀瘀攀 琀眀漀 䀀 愀渀礀眀栀攀爀攀ഀഀ
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%.@%'਍ऀऀऀ伀刀 䰀伀圀䔀刀⠀䰀吀刀䤀䴀⠀刀吀刀䤀䴀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀䤀匀一唀䰀䰀⠀䌀伀一嘀䔀刀吀⠀嘀䄀刀䌀䠀䄀刀Ⰰ䀀䔀洀愀椀氀䤀渀⤀Ⰰ 一唀䰀䰀⤀Ⰰ ✀崀✀Ⰰ ✀✀⤀Ⰰ ✀嬀✀Ⰰ ✀✀⤀⤀⤀⤀ 䰀䤀䬀䔀 ✀─䀀⸀─✀ ⴀⴀ 䌀愀渀渀漀琀 栀愀瘀攀 䀀 愀渀搀 ⸀ 渀攀砀琀 琀漀 攀愀挀栀 漀琀栀攀爀ഀഀ
			OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%.or'਍ऀऀऀ伀刀 䰀伀圀䔀刀⠀䰀吀刀䤀䴀⠀刀吀刀䤀䴀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀䤀匀一唀䰀䰀⠀䌀伀一嘀䔀刀吀⠀嘀䄀刀䌀䠀䄀刀Ⰰ䀀䔀洀愀椀氀䤀渀⤀Ⰰ 一唀䰀䰀⤀Ⰰ ✀崀✀Ⰰ ✀✀⤀Ⰰ ✀嬀✀Ⰰ ✀✀⤀⤀⤀⤀ 䰀䤀䬀䔀 ✀─⸀渀攀✀ ⴀⴀ 䴀椀猀猀椀渀最 氀愀猀琀 氀攀琀琀攀爀ഀഀ
			-- Why not Camaroon or Colombia? Just commented the following lines to allow those countries take into account:਍ऀऀऀⴀⴀ 伀刀 䰀伀圀䔀刀⠀䰀吀刀䤀䴀⠀刀吀刀䤀䴀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀䤀匀一唀䰀䰀⠀䌀伀一嘀䔀刀吀⠀嘀䄀刀䌀䠀䄀刀Ⰰ䀀䔀洀愀椀氀䤀渀⤀Ⰰ 一唀䰀䰀⤀Ⰰ ✀崀✀Ⰰ ✀✀⤀Ⰰ ✀嬀✀Ⰰ ✀✀⤀⤀⤀⤀ 䰀䤀䬀䔀 ✀─⸀挀洀✀ഀഀ
			-- OR LOWER(LTRIM(RTRIM(REPLACE(REPLACE(ISNULL(CONVERT(VARCHAR,@EmailIn), NULL), ']', ''), '[', '')))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos਍ऀऀऀ吀䠀䔀一ഀഀ
				NULL਍ऀऀऀ䔀䰀匀䔀ഀഀ
				-- If thew email address is a valid one, we return it back.਍ऀऀऀऀ䰀伀圀䔀刀⠀䰀吀刀䤀䴀⠀刀吀刀䤀䴀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀䤀匀一唀䰀䰀⠀䌀伀一嘀䔀刀吀⠀嘀䄀刀䌀䠀䄀刀Ⰰ䀀䔀洀愀椀氀䤀渀⤀Ⰰ 一唀䰀䰀⤀Ⰰ ✀崀✀Ⰰ ✀✀⤀Ⰰ ✀嬀✀Ⰰ ✀✀⤀⤀⤀⤀ഀഀ
		END;਍    刀䔀吀唀刀一⠀䀀䔀洀愀椀氀伀甀琀⤀㬀ഀഀ
END਍䜀伀ഀഀ
