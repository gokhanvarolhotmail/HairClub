/****** Object:  StoredProcedure [ODS].[UpdateLeadEmaiPhones]    Script Date: 1/10/2022 10:03:12 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀伀䐀匀崀⸀嬀唀瀀搀愀琀攀䰀攀愀搀䔀洀愀椀倀栀漀渀攀猀崀 䄀匀ഀഀ
BEGIN਍    ⴀⴀ 匀䔀吀 一伀䌀伀唀一吀 伀一 愀搀搀攀搀 琀漀 瀀爀攀瘀攀渀琀 攀砀琀爀愀 爀攀猀甀氀琀 猀攀琀猀 昀爀漀洀ഀഀ
    -- interfering with SELECT statements.਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    ⴀⴀ 䤀渀猀攀爀琀 猀琀愀琀攀洀攀渀琀猀 昀漀爀 瀀爀漀挀攀搀甀爀攀 栀攀爀攀ഀഀ
    UPDATE [ODS].[SFDC_Lead]਍ऀ匀䔀吀  嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开䰀攀愀搀崀⸀攀洀愀椀氀 㴀 攀⸀渀愀洀攀ഀഀ
	from [ODS].[SFDC_Lead] l਍ऀ樀漀椀渀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开䔀洀愀椀氀开开挀崀 攀ഀഀ
	on e.lead__c = l.id਍ऀ眀栀攀爀攀 氀⸀攀洀愀椀氀 椀猀 渀甀氀氀  愀渀搀 攀⸀渀愀洀攀 椀猀 渀漀琀 渀甀氀氀ഀഀ
਍ऀ唀倀䐀䄀吀䔀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开䰀攀愀搀崀ഀഀ
	SET  [ODS].[SFDC_Lead].phone = p.name਍ऀ昀爀漀洀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开䰀攀愀搀崀 氀ഀഀ
	join [ODS].[SFDC_Phone__c] p਍ऀ漀渀 瀀⸀氀攀愀搀开开挀 㴀 氀⸀椀搀ഀഀ
	where l.phone is null and (p.name is not null and p.Type__c = 'Home')਍ഀഀ
	UPDATE [ODS].[SFDC_Lead]਍ऀ匀䔀吀  嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开䰀攀愀搀崀⸀洀漀戀椀氀攀瀀栀漀渀攀 㴀 瀀⸀渀愀洀攀ഀഀ
	from [ODS].[SFDC_Lead] l਍ऀ樀漀椀渀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开倀栀漀渀攀开开挀崀 瀀ഀഀ
	on p.lead__c = l.id਍ऀ眀栀攀爀攀 氀⸀瀀栀漀渀攀 椀猀 渀甀氀氀 愀渀搀 ⠀瀀⸀渀愀洀攀 椀猀 渀漀琀 渀甀氀氀 愀渀搀 瀀⸀吀礀瀀攀开开挀 㴀 ✀䌀攀氀氀✀⤀ഀഀ
਍䔀一䐀ഀഀ
GO਍
