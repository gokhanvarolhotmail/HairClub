/****** Object:  StoredProcedure [dbo].[UpdateDimLead]    Script Date: 3/7/2022 8:42:24 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀搀戀漀崀⸀嬀唀瀀搀愀琀攀䐀椀洀䰀攀愀搀崀 䄀匀ഀ
BEGIN਍ഀ
 ਍ഀ
 ਍ഀ
 ਍⼀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀儀唀䔀刀夀 吀伀 唀倀䐀䄀吀䔀 䰀䔀䄀䐀匀 圀䤀吀䠀伀唀吀䠀 䌀䄀䴀倀䄀䤀䜀一⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⼀ഀ
--Create temp tables਍䌀爀攀愀琀攀 吀愀戀氀攀 ⌀䌀漀渀琀愀挀琀ഀ
	(਍ऀ    䰀攀愀搀䤀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    Subject varchar(400),਍        刀漀眀一甀洀 椀渀琀Ⰰഀ
        OriginalCampaignId varchar(1024)਍ऀ⤀㬀ഀ
਍䌀爀攀愀琀攀 吀愀戀氀攀 ⌀一漀吀愀猀欀ഀ
	(਍ऀ    䰀攀愀搀䤀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    Subject varchar(400),਍        伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀 瘀愀爀挀栀愀爀⠀㄀　㈀㐀⤀ഀ
	);਍⼀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀ 䤀渀猀攀爀琀 椀渀琀漀 琀攀洀瀀 琀愀戀氀攀猀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⼀ഀ
    ਍ⴀⴀⴀⴀ䰀攀愀搀猀 眀椀琀栀漀甀琀栀 挀愀洀瀀愀椀最渀ഀ
਍    圀䤀吀䠀 䰀攀愀搀匀䌀  䄀匀 ⠀ഀ
    SELECT Id, Name,TOLL_FREE, Status, CreatedDate਍    䘀刀伀䴀 䰀攀愀搀圀椀琀栀漀甀琀䌀愀洀瀀愀椀最渀倀栀漀渀攀 ഀ
        UNION ALL਍    匀䔀䰀䔀䌀吀 䄀⸀䤀搀 Ⰰ䄀⸀一愀洀攀 Ⰰ䄀⸀吀伀䰀䰀开䘀刀䔀䔀Ⰰ 䄀⸀匀琀愀琀甀猀Ⰰ 䄀⸀䌀爀攀愀琀攀搀䐀愀琀攀ഀ
    FROM LeadWithoutCampaignMPhone A਍    䰀䔀䘀吀 䨀伀䤀一 䰀攀愀搀圀椀琀栀漀甀琀䌀愀洀瀀愀椀最渀倀栀漀渀攀 䈀 伀一 䄀⸀䤀搀 㴀 䈀⸀䤀搀ഀ
    WHERE B.Id IS NULL਍⤀Ⰰ 䄀䰀䰀䌀䄀䴀倀䄀䤀䜀一 䄀匀⠀ഀ
    SELECT C.Id AS ExternaIdCampaign, C.TollFreeMobileName__c, C.TollFreeName__c , C.Name  AS CampaignName,  C.SourceCode_L__c਍    䘀刀伀䴀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开䌀愀洀瀀愀椀最渀开伀氀搀开倀爀漀搀崀 䌀ഀ
    WHERE C.Status != 'Merged'਍⤀Ⰰ 䰀攀愀搀䴀漀戀椀氀攀 䄀匀⠀ഀ
    SELECT L.*, C.ExternaIdCampaign, C.CampaignName, NC.Status AS CampaignStatus, NC.Id AS NewCampaignId਍        Ⰰ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀ 瀀愀爀琀椀琀椀漀渀 戀礀 䰀⸀䤀搀 漀爀搀攀爀 戀礀 一䌀⸀匀琀愀琀甀猀 䐀䔀匀䌀⤀ 䄀匀 刀漀眀一甀洀ഀ
    FROM LeadSC L਍    䤀一一䔀刀 䨀伀䤀一 䄀䰀䰀䌀䄀䴀倀䄀䤀䜀一 䌀 伀一 䌀⸀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀开开挀 㴀 䰀⸀吀伀䰀䰀开䘀刀䔀䔀ഀ
    INNER JOIN [ODS].[SF_Campaign] NC ON NC.External_Id__c = C.ExternaIdCampaign਍    圀䠀䔀刀䔀 䰀⸀䌀爀攀愀琀攀搀䐀愀琀攀 䈀䔀吀圀䔀䔀一 一䌀⸀匀琀愀爀琀䐀愀琀攀 䄀一䐀 一䌀⸀䔀渀搀䐀愀琀攀  ഀ
਍ഀ
਍⤀匀䔀䰀䔀䌀吀 ⨀ ഀ
into #leadsWC਍䘀刀伀䴀 䰀攀愀搀䴀漀戀椀氀攀ഀ
WHERE RowNum =1;਍ഀ
਍ⴀⴀⴀ䰀攀愀搀猀 搀甀瀀氀椀挀愀琀攀 戀礀 攀洀愀椀氀ഀ
਍ ഀ
਍ 眀椀琀栀 搀甀瀀 愀猀ഀ
    (SELECT਍    刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀瀀愀爀琀椀琀椀漀渀 戀礀 攀洀愀椀氀 伀刀䐀䔀刀 䈀夀 攀洀愀椀氀 䄀匀䌀⤀ 䄀匀 刀漀眀一甀洀Ⰰഀ
    a.id,a.email,a.name from [ODS].[SF_Lead] a਍    椀渀渀攀爀 樀漀椀渀 搀椀洀氀攀愀搀 戀 漀渀 愀⸀椀搀㴀戀⸀氀攀愀搀椀搀ഀ
    where  b.isvalid=1 and a.isdeleted=0 and email is not null਍    愀渀搀   攀洀愀椀氀  椀渀ഀ
    (਍        猀攀氀攀挀琀 攀洀愀椀氀 昀爀漀洀 嬀伀䐀匀崀⸀嬀匀䘀开䰀攀愀搀崀 眀栀攀爀攀  挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ挀爀攀愀琀攀搀搀愀琀攀⤀㸀㴀✀㈀　㈀㄀ⴀ　㘀ⴀ　㄀✀ 愀渀搀 椀猀搀攀氀攀琀攀搀㴀　ഀ
        group by email਍        栀愀瘀椀渀最 挀漀甀渀琀⠀⨀⤀㸀㄀ഀ
        )਍    ⤀ഀ
select * into #DupByEmail from dup਍眀栀攀爀攀 刀漀眀一甀洀㸀㄀㬀ഀ
਍ ഀ
਍ ഀ
਍ഀ
---Leads duplicate by name਍ഀ
 ਍ഀ
 with dupname as਍    ⠀匀䔀䰀䔀䌀吀ഀ
    ROW_NUMBER() OVER(partition by a.name ORDER BY name,createddate desc) AS RowNum,਍    愀⸀椀搀Ⰰ愀⸀攀洀愀椀氀Ⰰ愀⸀渀愀洀攀Ⰰ愀⸀挀爀攀愀琀攀搀搀愀琀攀 昀爀漀洀 嬀伀䐀匀崀⸀嬀匀䘀开䰀攀愀搀崀 愀ഀ
    inner join dimlead b on a.id=b.leadid਍    眀栀攀爀攀  戀⸀椀猀瘀愀氀椀搀㴀㄀ 愀渀搀 愀⸀椀猀搀攀氀攀琀攀搀㴀　ഀ
    )਍猀攀氀攀挀琀 ⨀ 椀渀琀漀 ⌀䐀甀瀀䈀礀一愀洀攀 昀爀漀洀 搀甀瀀渀愀洀攀ഀ
where RowNum>1;਍ഀ
/*******************************************************UPDATE ***************************/਍⼀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀ 一䔀圀 䰀伀䜀䤀䌀 䤀䴀倀䰀䔀䴀䔀一吀䔀䐀 䘀伀刀 吀䠀䔀 圀䄀䰀䬀匀 䤀一 ⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⼀ഀ
 ਍ⴀⴀ䌀䄀匀䔀 伀一䔀Ⰰ 圀䠀䔀一 䄀 䰀䔀䄀䐀 䠀䄀嘀䔀 䄀 吀䄀匀䬀 䄀匀匀伀匀䤀䄀吀䔀䐀ഀ
਍ഀ
with cte as (਍    猀攀氀攀挀琀 愀⸀䰀攀愀搀䤀搀Ⰰ戀⸀匀甀戀樀攀挀琀Ⰰ刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 愀⸀氀攀愀搀椀搀 伀刀䐀䔀刀 䈀夀 戀⸀䌀爀攀愀琀攀搀䐀愀琀攀 䄀匀䌀⤀ഀ
	AS RowNum from DimLead a --1769਍    椀渀渀攀爀 樀漀椀渀 伀䐀匀⸀匀䘀开吀愀猀欀 戀 漀渀 愀⸀䰀攀愀搀䤀搀 㴀 戀⸀圀栀漀䤀搀 ⴀⴀ ㌀　㠀㐀ഀ
    where OriginalCampaignId is null and LeadSource is null and b.Subject is not null਍⤀ഀ
਍椀渀猀攀爀琀 椀渀琀漀 ⌀䌀漀渀琀愀挀琀 ⠀䰀攀愀搀䤀搀Ⰰ 匀甀戀樀攀挀琀Ⰰ 刀漀眀一甀洀⤀ഀ
select LeadId,਍ऀ   琀爀椀洀⠀匀甀戀樀攀挀琀⤀ Ⰰഀ
       RowNum from cte where RowNum = 1਍ഀ
update #Contact਍猀攀琀 猀甀戀樀攀挀琀 㴀 ✀䌀愀氀氀✀ഀ
where  trim(Subject) in (਍    ✀䈀爀漀挀栀甀爀攀 䌀愀氀氀✀Ⰰഀ
    'Brochure Call Call Back',਍    ✀䌀愀氀氀✀Ⰰഀ
    'call tried to connect  threw a text message ,call and sight call, on Saturday no answer . will reach out on tuesday again',਍    ✀䌀愀氀氀㨀 䠀䌀 ⴀ 䐀椀愀氀 一漀眀✀Ⰰഀ
    'Call: HC English - Inbound Ad Call with MHSA Promo',਍    ✀䌀愀氀氀㨀 䠀䌀 䔀渀最氀椀猀栀 ⴀ 䤀渀戀漀甀渀搀 䈀漀猀氀攀礀 刀攀昀攀爀爀愀氀 䌀愀氀氀✀Ⰰഀ
    'Call: HC English - Inbound Caller ID Call',਍    ✀䌀愀氀氀㨀 䠀䌀 䔀渀最氀椀猀栀 ⴀ 䤀渀戀漀甀渀搀 刀攀猀挀栀攀搀甀氀攀 䰀椀渀攀 䌀愀氀氀✀Ⰰഀ
    'Call: HC English - Inbound Text Reschedule Line Call',਍    ✀䌀愀氀氀㨀 䠀䌀 䔀渀最氀椀猀栀 ⴀ 伀甀琀戀漀甀渀搀 䌀愀氀氀✀Ⰰഀ
    'Call: HC English - Outbound Confirmation Call',਍    ✀䌀愀氀氀㨀 䠀䌀 匀瀀愀渀椀猀栀 ⴀ 䤀渀戀漀甀渀搀 䄀搀 䌀愀氀氀 眀椀琀栀 䴀䠀匀䄀 倀爀漀洀漀✀Ⰰഀ
    'Call: HC Spanish - Inbound Ad Call with Special Promo',਍    ✀䌀愀氀氀㨀 䠀䌀 匀瀀愀渀椀猀栀 ⴀ 䤀渀戀漀甀渀搀 䌀愀氀氀攀爀 䤀䐀 䌀愀氀氀✀Ⰰഀ
    'Call: HC Spanish - Outbound Call',਍    ✀䌀愀氀氀㨀 䠀䌀 匀瀀愀渀椀猀栀ⴀ 䤀渀戀漀甀渀搀 刀攀猀挀栀攀搀甀氀攀 䰀椀渀攀 䌀愀氀氀✀Ⰰഀ
    'Call: HW - Dial Now',਍    ✀䌀愀氀氀㨀 䠀圀 䔀渀最氀椀猀栀  ⴀ 伀甀琀戀漀甀渀搀 䌀漀渀昀椀爀洀愀琀椀漀渀 䌀愀氀氀✀Ⰰഀ
    'Call: HW English - Inbound Ad Call with MHSA Promo',਍    ✀䌀愀氀氀㨀 䤀䌀 䌀愀氀氀猀✀Ⰰഀ
    'Cancel Call',਍    ✀䌀愀渀挀攀氀 䌀愀氀氀 䌀愀氀氀 䈀愀挀欀✀Ⰰഀ
    'Confirmation Call',਍    ✀䤀渀戀漀甀渀搀 䌀愀氀氀✀Ⰰഀ
    'Inbound Chat Interaction',਍    ✀䰀氀愀洀愀搀愀✀Ⰰഀ
    'Llamada: HC - Dial Now',਍    ✀䰀氀愀洀愀搀愀㨀 䠀䌀 䔀渀最氀椀猀栀 ⴀ 䤀渀戀漀甀渀搀 䄀搀 䌀愀氀氀 眀椀琀栀 䴀䠀匀䄀 倀爀漀洀漀✀Ⰰഀ
    'Llamada: HC English - Inbound Ad Call with Special Promo',਍    ✀䰀氀愀洀愀搀愀㨀 䠀䌀 䔀渀最氀椀猀栀 ⴀ 伀甀琀戀漀甀渀搀 䌀漀渀昀椀爀洀愀琀椀漀渀 䌀愀氀氀✀Ⰰഀ
    'Llamada: HC Spanish - Inbound Ad Call with MHSA Promo',਍    ✀䰀氀愀洀愀搀愀㨀 䠀䌀 匀瀀愀渀椀猀栀 ⴀ 伀甀琀戀漀甀渀搀 䌀愀氀氀✀Ⰰഀ
    'Manual Outbound Call',਍    ✀一漀 匀栀漀眀 䌀愀氀氀✀Ⰰഀ
    'No Show Call Call Back',਍    ✀倀爀攀瘀椀攀眀㨀 䠀䌀 䔀渀最氀椀猀栀 ⴀ 伀甀琀戀漀甀渀搀 䌀愀氀氀✀Ⰰഀ
    'Preview: HC English - Outbound Confirmation Call',਍    ✀倀爀攀瘀椀攀眀㨀 䠀䌀 匀瀀愀渀椀猀栀 ⴀ 伀甀琀戀漀甀渀搀 䌀愀氀氀✀Ⰰഀ
    'Vista Previa (preview): HC English - Outbound Call',਍    ✀嘀椀猀琀愀 倀爀攀瘀椀愀 ⠀瀀爀攀瘀椀攀眀⤀㨀 䠀䌀 匀瀀愀渀椀猀栀 ⴀ 伀甀琀戀漀甀渀搀 䌀愀氀氀✀ഀ
਍    ⤀ഀ
਍甀瀀搀愀琀攀 ⌀䌀漀渀琀愀挀琀ഀ
set subject = 'Email'਍眀栀攀爀攀  琀爀椀洀⠀匀甀戀樀攀挀琀⤀ 椀渀 ⠀ഀ
    'Email:',਍    ✀䔀洀愀椀氀㨀 㔀⼀㈀　⼀㈀㄀ 挀漀渀猀甀氀琀 愀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰഀ
    'Email: Angela - See you this afternoon!',਍    ✀䔀洀愀椀氀㨀 䄀瀀瀀琀 愀琀 䠀愀椀爀 䌀氀甀戀 䄀洀愀爀椀氀氀漀✀Ⰰഀ
    'Email: Black Friday event',਍    ✀䔀洀愀椀氀㨀 䐀愀渀渀礀 ⴀ 匀攀攀 礀漀甀 吀漀搀愀礀℀✀Ⰰഀ
    'Email: Follow Up',਍    ✀䔀洀愀椀氀㨀 䠀愀椀爀 䌀氀甀戀 䈀甀爀渀愀戀礀 䌀漀渀猀甀氀琀愀琀椀漀渀✀Ⰰഀ
    'Email: HairClub - Sorry we missed you!',਍    ✀䔀洀愀椀氀㨀 䠀愀椀爀䌀氀甀戀 䰀漀甀椀猀瘀椀氀氀攀 嘀椀爀琀甀愀氀 䌀漀渀猀甀氀琀愀琀椀漀渀✀Ⰰഀ
    'Email: Hector - see you tomorrow!',਍    ✀䔀洀愀椀氀㨀 䠀攀氀氀漀✀Ⰰഀ
    'Email: Hi Sandra',਍    ✀䔀洀愀椀氀㨀 䠀漀氀愀℀✀Ⰰഀ
    'Email: I Look Forward to Meeting You!',਍    ✀䔀洀愀椀氀㨀 䨀愀礀ⴀ 匀攀攀 礀漀甀 匀愀琀甀爀搀愀礀℀✀Ⰰഀ
    'Email: Martin- See you tomorrow!',਍    ✀䔀洀愀椀氀㨀 匀愀瘀攀 甀瀀 琀漀 ␀㜀㔀　 琀栀椀猀 眀攀攀欀✀Ⰰഀ
    'Email: Sorry I missed you!',਍    ✀䔀洀愀椀氀㨀 匀瀀爀椀渀最 椀猀 椀渀 琀栀攀 䠀愀椀爀✀Ⰰഀ
    'Email: Video Consultation',਍    ✀䔀洀愀椀氀㨀 嘀椀爀琀甀愀氀 䌀漀渀猀甀氀琀愀琀椀漀渀✀ഀ
਍    ⤀ഀ
਍ഀ
update #Contact਍猀攀琀 猀甀戀樀攀挀琀 㴀 ✀匀䴀匀✀ഀ
where  trim(Subject) in (਍    ✀匀䴀匀 䤀渀琀攀爀愀挀琀椀漀渀✀Ⰰഀ
    'SMS Message Received',਍    ✀吀攀砀琀 䌀漀渀昀椀爀洀愀琀椀漀渀✀ഀ
਍    ⤀ഀ
਍甀瀀搀愀琀攀 ⌀䌀漀渀琀愀挀琀ഀ
set subject = 'WALK-IN'਍眀栀攀爀攀  琀爀椀洀⠀匀甀戀樀攀挀琀⤀ 椀渀 ⠀ഀ
    'WALK-IN',਍    ✀䌀攀渀琀攀爀✀ഀ
    )਍ഀ
update #Contact਍猀攀琀 猀甀戀樀攀挀琀 㴀 ✀圀攀戀 䌀栀愀琀✀ഀ
where  trim(Subject) in (਍    ✀圀攀戀 䌀栀愀琀✀Ⰰഀ
    'Web Chat : ACE SMS',਍    ✀圀攀戀 䌀栀愀琀㨀 䄀䌀䔀 匀䴀匀✀Ⰰഀ
    'Web Chat: HW SMS',਍    ✀圀攀戀 䌀栀愀琀㨀 䤀䌀 匀䴀匀✀ഀ
਍    ⤀ഀ
਍甀瀀搀愀琀攀 ⌀䌀漀渀琀愀挀琀ഀ
set subject = 'Web Page'਍眀栀攀爀攀  琀爀椀洀⠀匀甀戀樀攀挀琀⤀ 椀渀 ⠀ഀ
    'Web Form'਍    ⤀ഀ
਍甀瀀搀愀琀攀 ⌀䌀漀渀琀愀挀琀ഀ
set OriginalCampaignId = a.Id਍昀爀漀洀 伀䐀匀⸀匀䘀开䌀愀洀瀀愀椀最渀 愀ഀ
where #Contact.Subject = a.SourceCode_L__c and #Contact.Subject  = 'WALK-IN';਍ഀ
਍ഀ
--CASE NUMBER TOW WHEN A LEAD DOESN'T HAVE A TASK ASOSSUATED BUT IS CONVERTED਍ഀ
with cte as (਍    猀攀氀攀挀琀 愀⸀䰀攀愀搀䤀搀 昀爀漀洀 䐀椀洀䰀攀愀搀 愀 ⴀⴀ㄀㜀㘀㤀ഀ
    inner join ODS.SF_Account b on a.ConvertedAccountId = b.id -- 3084਍    眀栀攀爀攀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀 椀猀 渀甀氀氀 愀渀搀 䰀攀愀搀匀漀甀爀挀攀 椀猀 渀甀氀氀ഀ
)਍ഀ
insert into #NoTask (LeadId,Subject)਍猀攀氀攀挀琀 䰀攀愀搀䤀搀Ⰰഀ
       'WALK-IN'਍ऀ    昀爀漀洀 挀琀攀ഀ
਍甀瀀搀愀琀攀 ⌀一漀吀愀猀欀ഀ
set OriginalCampaignId = a.Id਍昀爀漀洀 伀䐀匀⸀匀䘀开䌀愀洀瀀愀椀最渀 愀ഀ
where #NoTask.Subject = a.SourceCode_L__c and #NoTask.Subject  = 'WALK-IN'਍ ഀ
਍ഀ
਍ഀ
਍ഀ
/**************************************Update DimLead****************************************************************************/਍ⴀⴀ唀瀀搀愀琀攀 漀爀椀最椀渀愀氀 挀愀洀瀀愀椀最渀ഀ
update dbo.dimlead਍猀攀琀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀 㴀 戀⸀一攀眀䌀愀洀瀀愀椀最渀䤀搀ഀ
from dbo.dimlead a਍椀渀渀攀爀 樀漀椀渀 ⌀氀攀愀搀猀圀䌀 戀ഀ
on b.ID = a.LeadId਍眀栀攀爀攀 挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ愀⸀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 㸀 ✀㈀　㈀㄀ⴀ　㘀ⴀ㄀㐀✀ 愀渀搀 愀⸀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀 椀猀 渀甀氀氀ഀ
਍甀瀀搀愀琀攀 搀戀漀⸀䐀椀洀䰀攀愀搀ഀ
set OriginalCampaignId = b.CampaignId,਍伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀 㴀 挀⸀匀漀甀爀挀攀䌀漀搀攀开䰀开开挀ഀ
from dbo.DimLead a਍椀渀渀攀爀 樀漀椀渀 漀搀猀⸀匀䘀开䌀愀洀瀀愀椀最渀䴀攀洀戀攀爀 戀 漀渀 愀⸀䰀攀愀搀䤀搀 㴀 戀⸀䰀攀愀搀䤀搀ഀ
inner join ods.SF_Campaign c on b.CampaignId = c.Id਍眀栀攀爀攀 挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ愀⸀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 㸀 ✀㈀　㈀㄀ⴀ　㘀ⴀ㄀㐀✀ 愀渀搀 戀⸀䌀愀洀瀀愀椀最渀䤀搀 椀猀 渀漀琀 渀甀氀氀ഀ
਍ഀ
਍ⴀⴀ唀瀀搀愀琀攀 椀猀 瘀愀氀椀搀 昀氀愀最 愀渀搀 椀猀搀甀瀀瀀氀椀挀愀琀攀戀礀攀洀愀椀氀 昀氀愀最ഀ
update dbo.dimlead਍猀攀琀 嬀䤀猀䐀甀瀀氀椀挀愀琀攀䈀礀䔀洀愀椀氀崀 㴀 ㄀ഀ
    ,[isValid] = 0਍昀爀漀洀 搀戀漀⸀搀椀洀氀攀愀搀 愀ഀ
inner join #DupByEmail b਍漀渀 戀⸀䤀䐀 㴀 愀⸀䰀攀愀搀䤀搀ഀ
਍ഀ
਍ഀ
--Update isdupplicatebyname flag਍甀瀀搀愀琀攀 搀戀漀⸀搀椀洀氀攀愀搀ഀ
set [IsDuplicateByName] = 1਍昀爀漀洀 搀戀漀⸀搀椀洀氀攀愀搀 愀ഀ
inner join #DupByName b਍漀渀 戀⸀䤀䐀 㴀 愀⸀䰀攀愀搀䤀搀ഀ
਍甀瀀搀愀琀攀 䐀椀洀䰀攀愀搀ഀ
set IsDeleted = 1਍眀栀攀爀攀 䰀攀愀搀䤀搀 渀漀琀 椀渀 ⠀猀攀氀攀挀琀 椀搀 昀爀漀洀 伀䐀匀⸀匀䘀开䰀攀愀搀⤀ഀ
਍ⴀⴀ唀瀀搀愀琀攀 昀椀爀猀琀 眀愀氀欀䤀渀 挀愀猀攀ഀ
update DimLead਍  猀攀琀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀 㴀 愀⸀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀ഀ
from #Contact  a਍眀栀攀爀攀 愀⸀䰀攀愀搀䤀搀 㴀 䐀椀洀䰀攀愀搀⸀䰀攀愀搀䤀搀 愀渀搀 䐀椀洀䰀攀愀搀⸀䰀攀愀搀䤀搀 椀猀 渀漀琀 渀甀氀氀ഀ
਍ⴀⴀ唀瀀搀愀琀攀 猀攀挀漀渀搀 圀愀氀欀䤀渀 挀愀猀攀ഀ
update DimLead਍  猀攀琀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀 㴀 愀⸀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀ഀ
from #NoTask  a਍眀栀攀爀攀 愀⸀䰀攀愀搀䤀搀 㴀 䐀椀洀䰀攀愀搀⸀䰀攀愀搀䤀搀 愀渀搀 䐀椀洀䰀攀愀搀⸀䰀攀愀搀䤀搀 椀猀 渀漀琀 渀甀氀氀ഀ
਍ഀ
਍⼀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀刀攀愀氀漀愀搀 琀愀戀氀攀 昀漀爀 戀愀爀琀栀 攀砀瀀漀爀琀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⼀ഀ
਍琀爀甀渀挀愀琀攀 琀愀戀氀攀 搀戀漀⸀䰀攀愀搀猀圀椀琀栀漀甀琀䌀愀洀瀀愀椀最渀ഀ
਍椀渀猀攀爀琀 椀渀琀漀 搀戀漀⸀䰀攀愀搀猀圀椀琀栀漀甀琀䌀愀洀瀀愀椀最渀 ⠀ഀ
       [ID]਍      Ⰰ嬀一攀眀䌀愀洀瀀愀椀最渀䤀搀崀ഀ
      ,[ExternalIdCampaign]਍      Ⰰ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀⤀ഀ
਍猀攀氀攀挀琀ഀ
       [ID]਍      Ⰰ嬀一攀眀䌀愀洀瀀愀椀最渀䤀搀崀ഀ
      ,[ExternaIdCampaign]਍      Ⰰ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀ഀ
      from #leadsWC਍ഀ
਍ ഀ
drop Table #Contact਍搀爀漀瀀 吀愀戀氀攀 ⌀一漀吀愀猀欀ഀ
drop table #leadsWC਍搀爀漀瀀 琀愀戀氀攀 ⌀䐀甀瀀䈀礀䔀洀愀椀氀ഀ
drop table #DupByName਍ഀ
਍ഀ
਍䔀一䐀ഀഀ
GO਍
