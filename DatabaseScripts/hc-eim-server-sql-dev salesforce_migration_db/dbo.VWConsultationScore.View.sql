/****** Object:  View [dbo].[VWConsultationScore]    Script Date: 1/10/2022 10:03:11 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䌀漀渀猀甀氀琀愀琀椀漀渀匀挀漀爀攀崀ഀഀ
AS select  a.id leadid, leadkey,a.CreatedDate LeadCreatedDate,਍ 愀⸀䜀攀渀搀攀爀开开挀 Ⰰഀഀ
Age__c, AgeRange__c, Language__c,HairLossExperience__c,HairLossFamily__c, HairLossProductUsed__c,਍䠀愀椀爀䰀漀猀猀倀爀漀搀甀挀琀伀琀栀攀爀开开挀Ⰰ䠀愀椀爀䰀漀猀猀匀瀀漀琀开开挀Ⰰ䈀椀爀琀栀搀愀礀开开挀Ⰰ愀⸀䴀愀爀椀琀愀氀匀琀愀琀甀猀开开挀Ⰰ伀挀挀甀瀀愀琀椀漀渀开开挀Ⰰ䐀䤀匀䌀开开挀Ⰰ一漀爀眀漀漀搀匀挀愀氀攀开开挀Ⰰ䰀甀搀眀椀最匀挀愀氀攀开开挀Ⰰഀഀ
(case when a.Gender__c is null or a.Gender__c=''  then 0 else 1 end)  +਍⠀挀愀猀攀 眀栀攀渀 䄀最攀开开挀 椀猀 渀甀氀氀   琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀ ⬀ ഀഀ
(case when AgeRange__c is null then 0 else 1 end)+ ਍⠀挀愀猀攀 眀栀攀渀 䰀愀渀最甀愀最攀开开挀 椀猀 渀甀氀氀 琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀഀ
(case when HairLossExperience__c is null then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 䠀愀椀爀䰀漀猀猀䘀愀洀椀氀礀开开挀 椀猀 渀甀氀氀 琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀഀ
(case when HairLossProductUsed__c is null then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 䠀愀椀爀䰀漀猀猀倀爀漀搀甀挀琀伀琀栀攀爀开开挀 椀猀 渀甀氀氀 琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀഀ
(case when HairLossSpot__c is null then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 䈀椀爀琀栀搀愀礀开开挀 椀猀 渀甀氀氀 琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀഀ
(case when a.MaritalStatus__c is null then  0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 伀挀挀甀瀀愀琀椀漀渀开开挀 椀猀 渀甀氀氀 琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀഀ
(case when DISC__c is null then 0   else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 一漀爀眀漀漀搀匀挀愀氀攀开开挀 椀猀 渀甀氀氀 愀渀搀 䰀甀搀眀椀最匀挀愀氀攀开开挀 椀猀  渀甀氀氀  琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀 ⤀ 䌀漀渀猀甀氀琀刀攀愀搀礀䰀攀愀搀猀Ⰰഀഀ
c.createddate ConsultationFormDate,lead__c, How_did_you_hear_about_Hair__club__c,Referred_By__c, Steps_Taken__c,਍䠀漀眀开䰀漀渀最开吀栀椀渀欀椀渀最开开挀Ⰰ刀攀猀攀愀爀挀栀开䐀漀渀攀开开挀Ⰰ䠀愀椀爀开䰀漀猀猀开䔀昀昀攀挀琀猀开开挀Ⰰ吀攀氀氀开䄀渀礀漀渀攀开开挀Ⰰ䜀漀愀氀开伀昀开嘀椀猀椀琀开开挀Ⰰ匀瀀攀挀椀愀氀开䔀瘀攀渀琀猀开䤀洀瀀愀挀琀攀搀开开挀Ⰰഀഀ
Scale_Hair_Restore__c,Reason_For_Hair_Back__c,਍⠀挀愀猀攀 眀栀攀渀 䠀漀眀开搀椀搀开礀漀甀开栀攀愀爀开愀戀漀甀琀开䠀愀椀爀开开挀氀甀戀开开挀 椀猀  渀甀氀氀  琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀ
(case when [Referred_By__c] is null  then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 嬀匀琀攀瀀猀开吀愀欀攀渀开开挀崀 椀猀 渀甀氀氀  琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀ
(case when [How_Long_Thinking__c] is null then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 嬀刀攀猀攀愀爀挀栀开䐀漀渀攀开开挀崀 椀猀 渀甀氀氀 琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀ
(case when [Hair_Loss_Effects__c] is null  then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 嬀吀攀氀氀开䄀渀礀漀渀攀开开挀崀 椀猀 渀甀氀氀  琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀ
(case when [Goal_Of_Visit__c] is null  then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 嬀匀瀀攀挀椀愀氀开䔀瘀攀渀琀猀开䤀洀瀀愀挀琀攀搀开开挀崀 椀猀 渀甀氀氀   琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀⬀ഀ
(case when [Scale_Hair_Restore__c] is null  then 0 else 1 end)+਍⠀挀愀猀攀 眀栀攀渀 嬀刀攀愀猀漀渀开䘀漀爀开䠀愀椀爀开䈀愀挀欀开开挀崀 椀猀 渀甀氀氀   琀栀攀渀 　 攀氀猀攀 ㄀ 攀渀搀⤀ 䌀漀渀猀甀氀刀攀愀搀礀䌀漀渀猀甀氀琀愀琀椀漀渀䘀漀爀洀ഀഀ
from [ODS].[SFDC_Lead] a਍椀渀渀攀爀 樀漀椀渀 搀椀洀氀攀愀搀 戀 漀渀 愀⸀椀搀㴀戀⸀䰀攀愀搀䤀搀ഀഀ
left join [ODS].[SFDC_ConsultationForm] c on c.Lead__c=a.Id;਍䜀伀ഀഀ
