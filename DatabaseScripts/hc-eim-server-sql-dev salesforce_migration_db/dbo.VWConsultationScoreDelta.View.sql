/****** Object:  View [dbo].[VWConsultationScoreDelta]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ഀഀ
CREATE VIEW [dbo].[VWConsultationScoreDelta]਍䄀匀 猀攀氀攀挀琀  䤀搀Ⰰ䌀爀攀愀琀攀搀䐀愀琀攀Ⰰഀഀ
 Gender__c ,਍䄀最攀开开挀Ⰰ 䄀最攀刀愀渀最攀开开挀Ⰰ 䰀愀渀最甀愀最攀开开挀Ⰰ䠀愀椀爀䰀漀猀猀䔀砀瀀攀爀椀攀渀挀攀开开挀Ⰰ䠀愀椀爀䰀漀猀猀䘀愀洀椀氀礀开开挀Ⰰ 䠀愀椀爀䰀漀猀猀倀爀漀搀甀挀琀唀猀攀搀开开挀Ⰰഀഀ
HairLossProductOther__c,HairLossSpot__c,Birthday__c,MaritalStatus__c,Occupation__c,DISC__c,NorwoodScale__c,LudwigScale__c,਍⠀挀愀猀攀 眀栀攀渀 䜀攀渀搀攀爀开开挀 椀猀 渀甀氀氀 漀爀 䜀攀渀搀攀爀开开挀㴀✀✀  琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀  ⬀ഀഀ
(case when Age__c is null   then 0 else 1 end) + ਍⠀挀愀猀攀 眀栀攀渀 䄀最攀刀愀渀最攀开开挀 椀猀 渀甀氀氀 琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ ഀഀ
(case when Language__c is null then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 䠀愀椀爀䰀漀猀猀䔀砀瀀攀爀椀攀渀挀攀开开挀 椀猀 渀甀氀氀 琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀഀ
(case when HairLossFamily__c is null then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 䠀愀椀爀䰀漀猀猀倀爀漀搀甀挀琀唀猀攀搀开开挀 椀猀 渀甀氀氀 琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀഀ
(case when HairLossProductOther__c is null then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 䠀愀椀爀䰀漀猀猀匀瀀漀琀开开挀 椀猀 渀甀氀氀 琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀഀ
(case when Birthday__c is null then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 䴀愀爀椀琀愀氀匀琀愀琀甀猀开开挀 椀猀 渀甀氀氀 琀栀攀渀  　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀഀ
(case when Occupation__c is null then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 䐀䤀匀䌀开开挀 椀猀 渀甀氀氀 琀栀攀渀 　   攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀഀ
(case when NorwoodScale__c is null and LudwigScale__c is  null  then 0 else 1 end ) ConsultReadyLeads਍䘀刀伀䴀 匀䰀䘀开倀爀漀搀开䰀攀愀搀猀开䐀䔀䰀吀䄀ഀഀ
GO਍
