/****** Object:  StoredProcedure [ODS].[sp_Popultate_Factfunnel]    Script Date: 1/10/2022 10:03:12 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀伀䐀匀崀⸀嬀猀瀀开倀漀瀀甀氀琀愀琀攀开䘀愀挀琀昀甀渀渀攀氀崀 䄀匀 戀攀最椀渀ഀഀ
	਍ऀ琀爀甀渀挀愀琀攀 琀愀戀氀攀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 ഀഀ
	਍ऀⴀⴀⴀ䌀爀攀愀琀攀 琀攀洀瀀 吀愀戀氀攀猀ഀഀ
਍挀爀攀愀琀攀 吀愀戀氀攀 ⌀䌀漀渀琀愀挀琀ഀഀ
	(਍ऀ    椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    TaskID varchar(50),਍ऀ    儀甀漀琀攀搀倀爀椀挀攀 椀渀琀Ⰰഀഀ
	    SaletypeDescription varchar(100),਍ऀ    圀栀漀椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Result varchar(50),਍ऀ    䄀挀琀椀漀渀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    ActivityDateUTC datetime,਍ऀऀ䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    FunnelStep varchar(20),਍ऀ    䌀漀渀琀愀挀琀 戀椀琀Ⰰഀഀ
	    Lead bit,਍ऀ    䄀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    Show bit,਍ऀ    匀愀氀攀 戀椀琀Ⰰഀഀ
	    NewLeadToappointment bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀栀漀眀 戀椀琀Ⰰഀഀ
	    NewLeadTosale bit,਍ऀऀ䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		LastModifiedDate datetime਍ऀ⤀ഀഀ
	਍ऀ挀爀攀愀琀攀 吀愀戀氀攀 ⌀䰀攀愀搀ഀഀ
	(਍ऀ    椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    TaskID varchar(50),਍ऀ    儀甀漀琀攀搀倀爀椀挀攀 椀渀琀Ⰰഀഀ
	    SaletypeDescription varchar(100),਍ऀ    圀栀漀椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Result varchar(50),਍ऀ    䄀挀琀椀漀渀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    ActivityDateUTC datetime,਍ऀऀ䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    FunnelStep varchar(20),਍ऀ    䌀漀渀琀愀挀琀 戀椀琀Ⰰഀഀ
	    Lead bit,਍ऀ    䄀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    Show bit,਍ऀ    匀愀氀攀 戀椀琀Ⰰഀഀ
	    NewLeadToappointment bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀栀漀眀 戀椀琀Ⰰഀഀ
	    NewLeadTosale bit,਍ऀऀ䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		LastModifiedDate datetime਍ऀ⤀ഀഀ
	਍ऀ挀爀攀愀琀攀 吀愀戀氀攀 ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
	(਍ऀ    椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    TaskID varchar(50),਍ऀ    儀甀漀琀攀搀倀爀椀挀攀 椀渀琀Ⰰഀഀ
	    SaletypeDescription varchar(100),਍ऀ    圀栀漀椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Result varchar(50),਍ऀ    䄀挀琀椀漀渀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    ActivityDateUTC datetime,਍ऀऀ䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    FunnelStep varchar(20),਍ऀ    䌀漀渀琀愀挀琀 戀椀琀Ⰰഀഀ
	    Lead bit,਍ऀ    䄀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    Show bit,਍ऀ    匀愀氀攀 戀椀琀Ⰰഀഀ
	    NewLeadToappointment bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀栀漀眀 戀椀琀Ⰰഀഀ
	    NewLeadTosale bit,਍ऀऀ䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		LastModifiedDate datetime਍ऀ⤀ഀഀ
	਍ऀ挀爀攀愀琀攀 吀愀戀氀攀 ⌀匀栀漀眀ഀഀ
	(਍ऀ    椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    TaskID varchar(50),਍ऀ    儀甀漀琀攀搀倀爀椀挀攀 椀渀琀Ⰰഀഀ
	    SaletypeDescription varchar(100),਍ऀ    圀栀漀椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Result varchar(50),਍ऀ    䄀挀琀椀漀渀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    ActivityDateUTC datetime,਍ऀऀ䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    FunnelStep varchar(20),਍ऀ    䌀漀渀琀愀挀琀 戀椀琀Ⰰഀഀ
	    Lead bit,਍ऀ    䄀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    Show bit,਍ऀ    匀愀氀攀 戀椀琀Ⰰഀഀ
	    NewLeadToappointment bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀栀漀眀 戀椀琀Ⰰഀഀ
	    NewLeadTosale bit,਍ऀऀ䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		LastModifiedDate datetime਍ऀ⤀ഀഀ
	਍ऀ挀爀攀愀琀攀 吀愀戀氀攀 ⌀匀愀氀攀ഀഀ
	(਍ऀ    椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    TaskID varchar(50),਍ऀ    儀甀漀琀攀搀倀爀椀挀攀 椀渀琀Ⰰഀഀ
	    SaletypeDescription varchar(100),਍ऀ    圀栀漀椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Result varchar(50),਍ऀ    䄀挀琀椀漀渀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    ActivityDateUTC datetime,਍ऀऀ䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    FunnelStep varchar(20),਍ऀ    䌀漀渀琀愀挀琀 戀椀琀Ⰰഀഀ
	    Lead bit,਍ऀ    䄀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    Show bit,਍ऀ    匀愀氀攀 戀椀琀Ⰰഀഀ
	    NewLeadToappointment bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀栀漀眀 戀椀琀Ⰰഀഀ
	    NewLeadTosale bit,਍ऀऀ䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		LastModifiedDate datetime਍ऀ⤀ഀഀ
	਍ऀ挀爀攀愀琀攀 吀愀戀氀攀 ⌀䘀甀渀渀攀氀吀愀戀氀攀ഀഀ
	(਍ऀ    椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    TaskID varchar(50),਍ऀ    儀甀漀琀攀搀倀爀椀挀攀 椀渀琀Ⰰഀഀ
	    SaletypeDescription varchar(100),਍ऀ    圀栀漀椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Result varchar(50),਍ऀ    䄀挀琀椀漀渀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    ActivityDateUTC datetime,਍ऀऀ䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    FunnelStep varchar(20),਍ऀ    䌀漀渀琀愀挀琀 戀椀琀Ⰰഀഀ
	    Lead bit,਍ऀ    䄀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    Show bit,਍ऀ    匀愀氀攀 戀椀琀Ⰰഀഀ
	    NewLeadToappointment bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀栀漀眀 戀椀琀Ⰰഀഀ
	    NewLeadTosale bit,਍ऀऀ䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		LastModifiedDate datetime਍ऀ⤀ഀഀ
	਍ऀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀഀ
	---Insert into temp tables਍ऀഀഀ
	---Contact਍ऀ䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
	    #Contact਍ऀ匀攀氀攀挀琀 ഀഀ
	  sl.id਍ऀⰀ 渀甀氀氀 愀猀 吀愀猀欀䤀䐀ഀഀ
	, null as QuotedPrice਍ऀⰀ 渀甀氀氀 愀猀 匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
	, null as Whoid਍ऀⰀ 渀甀氀氀 愀猀 刀攀猀甀氀琀ഀഀ
	, null as Action਍ऀⰀ 猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀ഀഀ
	, dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate) as ActivityDateEST  ਍ऀⰀ ✀䌀漀渀琀愀挀琀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀 ഀഀ
	, 1 as Contact਍ऀⰀ 　 愀猀 氀攀愀搀ഀഀ
	, 0 as appointment਍ऀⰀ 　 愀猀 猀栀漀眀ഀഀ
	, 0 as sale਍ऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
	, 0 as NewLeadToshow਍ऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀愀氀攀ഀഀ
	, sl.CreatedDate਍ऀⰀ 猀氀⸀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀ഀഀ
	FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl਍ഀഀ
	਍ऀⴀⴀⴀ䰀攀愀搀ഀഀ
	EXEC    [ODS].[LeadValidation]਍ऀ䤀渀猀攀爀琀 椀渀琀漀  ⌀䰀攀愀搀ഀഀ
	Select ਍ऀ  猀氀⸀椀搀ഀഀ
	, null as TaskID਍ऀⰀ 渀甀氀氀 愀猀 儀甀漀琀攀搀倀爀椀挀攀ഀഀ
	, null as SaletypeDescription਍ऀⰀ 渀甀氀氀 愀猀 圀栀漀椀搀ഀഀ
	, null as Result਍ऀⰀ 渀甀氀氀 愀猀 䄀挀琀椀漀渀ഀഀ
	, sl.CreatedDate as ActivityDateUTC਍ऀⰀ 搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀  ഀഀ
	, 'Lead' as FunnelStep ਍ऀⰀ 　 愀猀 䌀漀渀琀愀挀琀ഀഀ
	, 1 as lead਍ऀⰀ 　 愀猀 愀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
	, 0 as show਍ऀⰀ 　 愀猀 猀愀氀攀ഀഀ
	, 0 as NewLeadToappointment਍ऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀栀漀眀ഀഀ
	, 0 as NewLeadTosale਍ऀⰀ 猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀ഀഀ
	, sl.LastModifiedDate਍ऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
	LEFT JOIN ODS.#IsInvalid a਍ऀ伀一 猀氀⸀椀搀 㴀 愀⸀䤀搀ഀഀ
	where a.IsInvalidLead is null; ਍ഀഀ
਍ऀഀഀ
	--Appointment਍ऀ圀椀琀栀 琀愀猀欀 愀猀 ⠀ഀഀ
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,LastModifiedDate,਍ऀ刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 戀⸀圀栀漀䤀搀 伀刀䐀䔀刀 䈀夀 愀挀琀椀瘀椀琀礀䐀愀琀攀 䄀匀䌀⤀ഀഀ
	AS RowNum਍ऀ䘀刀伀䴀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开吀愀猀欀崀 戀ഀഀ
	where trim(action__c) in ('Appointment','In House','Be Back') and result__c <> 'Void'਍ऀ⤀ഀഀ
		Insert into ਍ऀ     ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
		SELECT਍ऀऀ猀氀⸀椀搀ഀഀ
		, task.Taskid਍ऀऀⰀ 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀ഀഀ
		, ISNULL(task.saletypeDescription, 'Unknown') as saletypeDescription਍ऀऀⰀ 琀愀猀欀⸀眀栀漀椀搀ഀഀ
		, task.Result਍ऀऀⰀ 琀愀猀欀⸀䄀挀琀椀漀渀ഀഀ
		, NULL as ActivityDate਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀猀琀愀爀琀琀椀洀攀开开挀 渀漀琀 氀椀欀攀 ✀─一唀䰀䰀─✀⤀ 吀䠀䔀一 挀愀猀琀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 愀猀 搀愀琀攀琀椀洀攀⤀ഀഀ
			   ELSE task.ActivityDate ਍ऀऀऀ   䔀一䐀 䄀匀 䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀ഀഀ
		, 'Appointment' as FunnelStep਍ऀऀⰀ 　 愀猀 䌀漀渀琀愀挀琀ഀഀ
		, 0 as Lead਍ऀऀⰀ ㄀ 愀猀 䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
		, 0 as Show਍ऀऀⰀ 　 愀猀 匀愀氀攀ഀഀ
		, 0 as NewLeadToappointment਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀栀漀眀ഀഀ
		, 0 as NewLeadTosale਍ऀऀⰀ 琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀 愀猀 䌀爀攀愀琀攀搀䐀愀琀攀ഀഀ
		, task.LastModifiedDate਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId਍ऀऀ眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀㬀ഀഀ
਍ഀഀ
	਍ऀഀഀ
	---Show਍ऀഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId ORDER BY activityDate ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 愀挀琀椀漀渀开开挀 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䈀攀 䈀愀挀欀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀⤀ 愀渀搀 ⠀爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 一漀 匀愀氀攀✀ 漀爀 爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 匀愀氀攀✀⤀ ഀഀ
	)਍ऀऀ䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
	    #Show਍ऀऀ匀䔀䰀䔀䌀吀ഀഀ
		sl.id਍ऀऀⰀ 琀愀猀欀⸀吀愀猀欀椀搀ഀഀ
		, task.QuotedPrice਍ऀऀⰀ 䤀匀一唀䰀䰀⠀琀愀猀欀⸀猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ ✀唀渀欀渀漀眀渀✀⤀ 愀猀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
		, task.whoid਍ऀऀⰀ 琀愀猀欀⸀刀攀猀甀氀琀ഀഀ
		, task.Action਍ऀऀⰀ 一唀䰀䰀 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀ഀഀ
		, CASE WHEN (starttime__c not like '%NULL%') THEN cast(concat(left(task.ActivityDate,11),task.StartTime__c) as datetime)਍ऀऀऀ   䔀䰀匀䔀 琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀 ഀഀ
			   END AS ActivityDateEST਍ऀऀⰀ ✀匀栀漀眀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀ഀഀ
		, 0 as Contact਍ऀऀⰀ 　 愀猀 䰀攀愀搀ഀഀ
		, 0 as Appointment਍ऀऀⰀ ㄀ 愀猀 匀栀漀眀ഀഀ
		, 0 as Sale਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
		, 0 as NewLeadToshow਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀愀氀攀ഀഀ
		, task.ActivityDate as CreatedDate਍ऀऀⰀ 琀愀猀欀⸀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀ഀഀ
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl਍ऀऀ䤀一一䔀刀 䨀伀䤀一 琀愀猀欀 漀渀 椀猀渀甀氀氀⠀猀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀Ⰰ猀氀⸀椀搀⤀ 㴀 琀愀猀欀⸀眀栀漀椀搀  ⴀⴀ伀刀 猀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀 㴀 琀愀猀欀⸀圀栀漀䤀搀ഀഀ
		where task.rownum=1;਍ഀഀ
	਍ऀⴀⴀⴀ匀愀氀攀ഀഀ
	਍ऀ圀椀琀栀 琀愀猀欀 愀猀 ⠀ഀഀ
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,LastModifiedDate,਍ऀ刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 戀⸀圀栀漀䤀搀  伀刀䐀䔀刀 䈀夀 愀挀琀椀瘀椀琀礀䐀愀琀攀 䄀匀䌀⤀ഀഀ
	AS RowNum਍ऀ䘀刀伀䴀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开吀愀猀欀崀 戀ഀഀ
	where action__c in ('Appointment','Be Back','In House') and ( result__c='Show Sale') ਍ऀ⤀ഀഀ
		Insert into ਍ऀ    ⌀匀愀氀攀ഀഀ
		SELECT਍ऀऀ猀氀⸀椀搀ഀഀ
		, task.Taskid਍ऀऀⰀ 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀ഀഀ
		, ISNULL(task.saletypeDescription, 'Unknown') as saletypeDescription਍ऀऀⰀ 琀愀猀欀⸀眀栀漀椀搀ഀഀ
		, task.Result਍ऀऀⰀ 琀愀猀欀⸀䄀挀琀椀漀渀ഀഀ
		, NULL as ActivityDate਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀猀琀愀爀琀琀椀洀攀开开挀 渀漀琀 氀椀欀攀 ✀─一唀䰀䰀─✀⤀ 吀䠀䔀一 挀愀猀琀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 愀猀 搀愀琀攀琀椀洀攀⤀ഀഀ
			   ELSE task.ActivityDate ਍ऀऀऀ   䔀一䐀 䄀匀 䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀ഀഀ
		, 'Sale' as FunnelStep਍ऀऀⰀ 　 愀猀 䌀漀渀琀愀挀琀ഀഀ
		, 0 as Lead਍ऀऀⰀ 　 愀猀 䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
		, 0 as Show਍ऀऀⰀ ㄀ 愀猀 匀愀氀攀ഀഀ
		, 0 as NewLeadToappointment਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀栀漀眀ഀഀ
		, 0 as NewLeadTosale਍ऀऀⰀ 琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀 愀猀 䌀爀攀愀琀攀搀䐀愀琀攀ഀഀ
		, task.LastModifiedDate਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId਍ऀऀ眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀㬀ഀഀ
਍ऀⴀⴀⴀ吀攀洀瀀ഀഀ
਍ऀ圀椀琀栀 琀愀猀欀 愀猀 ⠀ഀഀ
	SELECT id Taskid,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,਍ऀ刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 戀⸀圀栀漀䤀搀  伀刀䐀䔀刀 䈀夀 愀挀琀椀瘀椀琀礀䐀愀琀攀 䄀匀䌀⤀ഀഀ
	AS RowNum਍ऀ䘀刀伀䴀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开吀愀猀欀崀 戀ഀഀ
	where activitydate is not null਍ऀ⤀ഀഀ
		਍ऀⴀⴀ椀渀猀攀爀琀 椀渀琀漀 ⌀琀攀洀瀀ഀഀ
	select RowNum, taskid , whoid, activitydate into #temp from task ਍ऀ眀栀攀爀攀 刀漀眀一甀洀 㴀 ㄀㬀ഀഀ
	਍ऀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀഀ
	਍ऀⴀⴀⴀ唀渀椀漀渀 吀愀戀氀攀猀ഀഀ
	਍ऀ䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
	   #FunnelTable਍ऀ匀攀氀攀挀琀 ⨀ ഀഀ
	FROM #Contact਍ऀ甀渀椀漀渀 愀氀氀ഀഀ
	Select * ਍ऀ䘀爀漀洀 ⌀䰀攀愀搀ഀഀ
	Union all਍ऀ匀攀氀攀挀琀 ⨀ഀഀ
	From #Appointment਍ऀ唀渀椀漀渀 愀氀氀ഀഀ
	Select *਍ऀ䘀爀漀洀 ⌀匀栀漀眀ഀഀ
	Union all਍ऀ匀攀氀攀挀琀 ⨀ ഀഀ
	from #Sale;਍ഀഀ
਍ऀ眀椀琀栀 渀攀眀氀攀愀搀 愀猀 ⠀ഀ
		SELECT਍ऀऀ椀搀Ⰰഀ
		COUNT(*) as number਍ऀऀ䘀刀伀䴀 ⌀昀甀渀渀攀氀吀愀戀氀攀ഀ
		WHERE id not IN਍ऀऀ⠀ഀ
		SELECT id FROM #funnelTable WHERE FunnelStep = 'Lead'਍ऀऀ⤀ഀ
		GROUP BY id਍ऀऀ䠀䄀嘀䤀一䜀 䌀伀唀一吀⠀⨀⤀ 㸀㄀ഀ
	)਍ऀ猀攀氀攀挀琀 愀⸀⨀ 椀渀琀漀 ⌀琀攀洀瀀漀爀愀氀 昀爀漀洀 ⌀昀甀渀渀攀氀吀愀戀氀攀 愀ഀ
	inner join newlead l਍ऀ漀渀 愀⸀椀搀 㴀 氀⸀椀搀ഀ
	where a.funnelstep = 'Contact'਍ഀ
	update  #temporal set FunnelStep = 'Lead'਍ഀ
	insert into #funneltable਍ऀ猀攀氀攀挀琀 ⨀ 昀爀漀洀  ⌀琀攀洀瀀漀爀愀氀ഀഀ
	਍ऀ甀瀀搀愀琀攀 ⌀昀甀渀渀攀氀吀愀戀氀攀 猀攀琀 一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 㴀 ㄀ഀഀ
	where id in (select id from #funnelTable where funnelstep='Appointment') ਍ऀ愀渀搀 昀甀渀渀攀氀猀琀攀瀀㴀✀䰀攀愀搀✀ഀഀ
	਍ऀ甀瀀搀愀琀攀 ⌀昀甀渀渀攀氀吀愀戀氀攀 猀攀琀 一攀眀䰀攀愀搀吀漀猀栀漀眀 㴀 ㄀ഀഀ
	where (id in (select id from #funnelTable where funnelstep='Show'))਍ऀ愀渀搀 昀甀渀渀攀氀猀琀攀瀀㴀✀䰀攀愀搀✀ഀഀ
	਍ऀ甀瀀搀愀琀攀 ⌀昀甀渀渀攀氀吀愀戀氀攀 猀攀琀 一攀眀䰀攀愀搀吀漀猀愀氀攀 㴀 ㄀ഀഀ
	where id in (select id from #funnelTable where funnelstep='Sale')਍ऀ愀渀搀 昀甀渀渀攀氀猀琀攀瀀 㴀✀䰀攀愀搀✀ഀഀ
਍ऀ甀瀀搀愀琀攀 ⌀昀甀渀渀攀氀吀愀戀氀攀 ഀഀ
		set TaskId = t.taskid਍ऀ䘀刀伀䴀 ⌀昀甀渀渀攀氀吀愀戀氀攀 昀ഀഀ
	INNER JOIN #temp t਍ऀ漀渀 昀⸀椀搀 㴀 琀⸀眀栀漀椀搀ഀഀ
	where (f.funnelstep ='Lead' or f.funnelstep ='Contact')਍ഀഀ
	਍ഀഀ
	/*਍ऀ匀攀氀攀挀琀 挀漀甀渀琀⠀⨀⤀ 昀爀漀洀 ⌀昀甀渀渀攀氀吀愀戀氀攀ഀഀ
	WHERE FunnelStep =  'Show' or FunnelStep  = 'sale'਍ऀ漀爀搀攀爀 戀礀 椀搀 搀攀猀挀Ⰰ 挀愀猀攀 圀栀攀渀 䘀甀渀渀攀氀匀琀攀瀀 㴀 ✀䌀漀渀琀愀挀琀✀ 琀栀攀渀 ㄀ഀഀ
	                When FunnelStep = 'Lead' then 2਍ऀ                眀栀攀渀 䘀甀渀渀攀氀匀琀攀瀀 㴀 ✀䄀瀀瀀漀椀渀琀洀攀渀琀✀ 琀栀攀渀 ㌀ഀഀ
	                when FunnelStep = 'Show' then 4਍ऀ                眀栀攀渀 䘀甀渀渀攀氀匀琀攀瀀 㴀 ✀猀愀氀攀✀ 琀栀攀渀 㔀 䔀一䐀ഀഀ
	*/਍ऀഀഀ
	਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
	DROP TABLE #Contact਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䰀攀愀搀ഀഀ
	DROP TABLE #Sale਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀匀栀漀眀ഀഀ
	DROP TABLE ODS.#IsInvalid਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀琀攀洀瀀ഀഀ
	DROP TABLE #temporal਍ऀഀഀ
	਍ഀഀ
	਍ऀഀഀ
	Insert into ਍ऀऀ     刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 ⠀嬀䌀漀渀琀愀挀琀䤀䐀崀ഀഀ
		  ,[SalesForceTaskID]਍ऀऀ  Ⰰ嬀䈀爀椀最栀琀倀愀琀琀攀爀渀䤀䐀崀ഀഀ
		  ,[LeadFunnelTransactionID]਍ऀऀ  Ⰰ嬀匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀崀ഀഀ
		  ,[Company]਍ऀऀ  Ⰰ嬀䘀甀渀渀攀氀匀琀攀瀀崀ഀഀ
		  ,[Funnelstatus]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䜀䌀䰀䤀䐀崀ഀഀ
		  ,[LeadCreateDateUTC]਍ऀऀ  Ⰰ嬀䰀攀愀搀䌀爀攀愀琀攀䐀愀琀攀䔀匀吀崀ഀഀ
		  ,[ActivityDateUTC]਍ऀऀ  Ⰰ嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀崀ഀഀ
		  ,[ReportCreateDate]਍ऀऀ  Ⰰ嬀䐀愀琀攀崀ഀഀ
		  ,[Time]਍ऀऀ  Ⰰ嬀䐀愀礀倀愀爀琀崀ഀഀ
		  ,[Hour]਍ऀऀ  Ⰰ嬀䴀椀渀甀琀攀崀ഀഀ
		  ,[Seconds]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀漀渀琀愀挀琀吀礀瀀攀崀ഀഀ
		  ,[OriginalSourcecode]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䐀椀愀氀攀搀一甀洀戀攀爀崀ഀഀ
		  ,[OriginalPhoneNumberAreaCode]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀ഀഀ
		  ,[OriginalCampaignChannel]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀一愀洀攀崀ഀഀ
		  ,[OriginalCampaignFormat]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀ഀഀ
		  ,[OriginalCampaignPromotionCode]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀ഀഀ
		  ,[OriginalCampaignEndDate]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀ഀഀ
		  ,[RecentSourcecode]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䐀椀愀氀攀搀一甀洀戀攀爀崀ഀഀ
		  ,[RecentPhoneNumberAreaCode]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀崀ഀഀ
		  ,[RecentCampaignChannel]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀一愀洀攀崀ഀഀ
		  ,[RecentCampaignFormat]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀崀ഀഀ
		  ,[RecentCampaignPromotionCode]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀崀ഀഀ
		  ,[RecentCampaignEndDate]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀崀ഀഀ
		  ,[PostalCode]਍ऀऀ  Ⰰ嬀刀攀最椀漀渀崀ഀഀ
		  ,[MarketDMA]਍ऀऀ  Ⰰ嬀䌀攀渀琀攀爀一愀洀攀崀ഀഀ
		  ,[CenterRegion]਍ऀऀ  Ⰰ嬀䌀攀渀琀攀爀䐀䴀䄀崀ഀഀ
		  ,[CenterType]਍ऀऀ  Ⰰ嬀䌀攀渀琀攀爀伀眀渀攀爀崀ഀഀ
		  ,[Language]਍ऀऀ  Ⰰ嬀䜀攀渀搀攀爀崀ഀഀ
		  ,[LastName]਍ऀऀ  Ⰰ嬀䘀椀爀猀琀一愀洀攀崀ഀഀ
		  ,[Phone]਍ऀऀ  Ⰰ嬀䴀漀戀椀氀攀倀栀漀渀攀崀ഀഀ
		  ,[Email]਍ऀऀ  Ⰰ嬀䔀琀栀渀椀挀椀琀礀崀ഀഀ
		  ,[HairLossCondition]਍ऀऀ  Ⰰ嬀䴀愀爀椀琀愀氀匀琀愀琀甀猀崀ഀഀ
		  ,[Occupation]਍ऀऀ  Ⰰ嬀䈀椀爀琀栀夀攀愀爀崀ഀഀ
		  ,[AgeBands]਍ऀऀ  Ⰰ嬀一攀眀䌀漀渀琀愀挀琀崀ഀഀ
		  ,[NewLead]਍ऀऀ  Ⰰ嬀一攀眀䄀瀀瀀漀椀渀琀洀攀渀琀崀ഀഀ
		  ,[NewShow]਍ऀऀ  Ⰰ嬀一攀眀匀愀氀攀崀ഀഀ
		  ,[NewLeadToAppointment]਍ऀऀ  Ⰰ嬀一攀眀䰀攀愀搀吀漀匀栀漀眀崀ഀഀ
		  ,[NewLeadToSale]਍ऀऀ  Ⰰ嬀儀甀漀琀攀搀倀爀椀挀攀崀ഀഀ
		  ,[PrimarySolution]਍ऀऀ  Ⰰ嬀䐀漀一漀琀䌀漀渀琀愀挀琀䘀氀愀最崀ഀഀ
		  ,[DoNotCallFlag]਍ऀऀ  Ⰰ嬀䐀漀一漀琀匀䴀匀䘀氀愀最崀ഀഀ
		  ,[DoNotEmailFlag]਍ऀऀ  Ⰰ嬀䐀漀一漀琀䴀愀椀氀䘀氀愀最崀ഀഀ
		  ,[IsDeleted]਍ऀऀ  Ⰰ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀⤀ഀഀ
਍ऀऀ匀䔀䰀䔀䌀吀 ഀഀ
		 NULL as 'ContactID'਍ऀऀⰀ 昀琀⸀吀愀猀欀椀搀 愀猀 匀愀氀攀猀䘀漀爀挀攀吀愀猀欀䤀䐀ഀഀ
		,NULL as [BrightPatternID]਍ऀऀⰀ一唀䰀䰀 䄀匀 䰀攀愀搀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀ഀഀ
		, sl.Id as SaleforceLeadID਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一⠀挀琀礀⸀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 㴀 ✀䠀愀渀猀 圀椀攀洀愀渀渀✀⤀ 吀䠀䔀一 ✀䠀愀渀猀 圀椀攀洀愀渀渀✀ഀഀ
			   ELSE 'Hair Club'਍ऀऀऀ   䔀一䐀 䄀匀 䌀漀洀瀀愀渀礀ഀഀ
		, ft.FunnelStep ਍ऀऀⰀ 猀氀⸀匀琀愀琀甀猀 愀猀 䘀甀渀渀攀氀匀琀愀琀甀猀ഀഀ
		--, NULL AS OriginalHCUID਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䜀䌀䤀䐀ഀഀ
		, sl.GCLID__c as OriginalGCLID਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䴀匀䌀䰀䬀䤀䐀ഀഀ
		--, NULL AS OriginalFBCLID਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䠀愀猀栀攀搀䔀洀愀椀氀ഀഀ
		--, NULL AS OriginalHashedPhone਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䠀䌀唀䤀䐀ഀഀ
		--, NULL AS RecentGCID਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䜀䌀䰀䤀䐀ഀഀ
		--, NULL AS RecentMSCLKID਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䘀䈀䌀䰀䤀䐀ഀഀ
		--, NULL AS RecentHashedEmail਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䠀愀猀栀攀搀倀栀漀渀攀ഀഀ
		, sl.CreatedDate as LeadCreateDateUTC਍ऀऀⰀ 搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 愀猀 䰀攀愀搀䌀爀攀愀琀攀䐀愀琀攀䔀匀吀ഀഀ
		, ft.ActivityDateUTC as ActivityDateUTC਍ऀऀⰀ 昀琀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀ഀഀ
		, sl.[ReportCreateDate__c] as ReportCreateDate਍ऀऀⰀ 挀愀猀琀⠀昀琀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 愀猀 搀愀琀攀⤀ 愀猀 䐀愀琀攀ഀഀ
		, cast(ft.ActivityDateEST as time) as time਍ऀऀⰀ 搀琀搀⸀䐀愀礀倀愀爀琀 愀猀 䐀愀礀倀愀爀琀ഀഀ
		, dtd.[Hour] as Hour਍ऀऀⰀ 搀琀搀⸀嬀洀椀渀甀琀攀崀 愀猀 䴀椀渀甀琀攀ഀഀ
		, dtd.[Second] as Seconds਍ऀऀⰀ 猀氀⸀䰀攀愀搀匀漀甀爀挀攀 䄀匀 伀爀椀最椀渀愀氀䌀漀渀琀愀挀琀吀礀瀀攀ഀഀ
		--, NULL AS OriginalContactGroup਍ऀऀⴀⴀⰀ 渀甀氀氀 愀猀 匀礀猀琀攀洀伀昀伀爀椀最椀渀ഀഀ
		--, NULL AS LeadState਍ऀऀⰀ 猀氀⸀匀漀甀爀挀攀开䌀漀搀攀开䰀攀最愀挀礀开开挀 愀猀 伀爀椀最椀渀愀氀匀漀甀爀挀攀挀漀搀攀ഀഀ
		--, NULL AS OriginalSourcecodeName਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀匀漀甀爀挀攀挀漀搀攀吀礀瀀攀ഀഀ
		--, NULL AS OriginalSourececodeGroup਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 猀漀挀⸀匀漀甀爀挀攀䌀漀搀攀开䰀开开挀 氀椀欀攀 ✀─䴀倀✀ഀഀ
				THEN soc.TollFreeMobileName__c਍ऀऀऀ䔀䰀匀䔀ഀഀ
				soc.TollFreeName__c਍ऀऀ  䔀一䐀 䄀匀 伀爀椀最椀渀愀氀䐀椀愀氀攀搀一甀洀戀攀爀ഀഀ
		, SUBSTRING(sl.PhoneAbr__c, 0,4 ) AS OriginalPhoneNumberAreaCode਍ऀऀⰀ 猀漀挀⸀嬀吀礀瀀攀崀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀ഀഀ
		--, NULL AS OriginalCampaignPurpose਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䴀攀琀栀漀搀ഀഀ
		, soc.Channel__c as OriginalCampaignChannel਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀ഀഀ
		--, NULL AS OriginalCampaignSource਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䌀漀渀琀攀渀琀吀礀瀀攀ഀഀ
		--, NULL AS OriginalCompaignContent਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀吀礀瀀攀ഀഀ
		, soc.Name  as OriginalCampaignName਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀吀愀挀琀椀挀ഀഀ
		, soc.Format__c as OriginalCampaignFormat਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀倀氀愀挀攀洀攀渀琀ഀഀ
		--, NULL AS OriginalCampaignCompany਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀ഀഀ
		--, NULL AS OriginalCampaignBudgetType਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀ഀഀ
		--, NULL AS OriginalCampaignRegion਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䴀愀爀欀攀琀䐀䴀䄀ഀഀ
		--, NULL AS OriginalCampaignAudience਍ऀऀⰀ 猀漀挀⸀䰀愀渀最甀愀最攀开开挀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀ഀഀ
		, soc.PromoCodeName__c as OriginalCampaignPromotionCode਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䰀愀渀搀椀渀最倀愀最攀唀刀䰀ഀഀ
		, soc.StartDate as OriginalCampaignStartDate਍ऀऀⰀ 猀漀挀⸀䔀渀搀䐀愀琀攀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀ഀഀ
		, soc.Status as OriginalCampaignStatus਍ऀऀⰀ 猀氀⸀刀攀挀攀渀琀匀漀甀爀挀攀䌀漀搀攀开开挀 愀猀 刀攀挀攀渀琀匀漀甀爀挀攀䌀漀搀攀ഀഀ
		--, NULL AS RecentSourcecodeName਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀匀漀甀爀挀攀挀漀搀攀吀礀瀀攀ഀഀ
		--, NULL AS RecentSourececodeGroup਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 猀爀挀⸀匀漀甀爀挀攀䌀漀搀攀开䰀开开挀 氀椀欀攀 ✀─䴀倀✀ഀഀ
				THEN src.TollFreeMobileName__c਍ऀऀऀ䔀䰀匀䔀ഀഀ
				src.TollFreeName__c਍ऀऀ  䔀一䐀 䄀匀 伀爀椀最椀渀愀氀䐀椀愀氀攀搀一甀洀戀攀爀ഀഀ
		, SUBSTRING(sl.PhoneAbr__c, 0,4 ) as RecentPhoneNumberAreaCode਍ऀऀⰀ 猀爀挀⸀嬀吀礀瀀攀崀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀ഀഀ
		--, NULL AS RecentCampaignPurpose਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀氀䌀愀洀瀀愀椀最渀䴀攀琀栀漀搀ഀഀ
		, src.Channel__c as RecentCampaignChannel਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䴀攀搀椀甀洀ഀഀ
		--, NULL AS RecentCampaignSource਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䌀漀渀琀攀渀琀吀礀瀀攀ഀഀ
		--, NULL AS RecentCompaignContent਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀吀礀瀀攀ഀഀ
		, src.Name as RecentCampaignName਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀吀愀挀琀椀挀ഀഀ
		, src.Format__c as RecentCampaignFormat਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀倀氀愀挀攀洀攀渀琀ഀഀ
		--, NULL AS RecentCampaignCompany਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䰀漀挀愀琀椀漀渀ഀഀ
		--, NULL AS RecentCampaignBudgetType਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀一愀洀攀ഀഀ
		--, NULL as RecentCampaignRegion਍ऀऀⴀⴀⰀ 一唀䰀䰀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䴀愀爀欀攀琀䐀䴀䄀ഀഀ
		--, NULL as RecentCampaignAudience਍ऀऀⰀ 猀爀挀⸀䰀愀渀最甀愀最攀开开挀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀ഀഀ
		, src.PromoCodeName__c as RecentCampaignPromotionCode਍ऀऀⴀⴀⰀ 一唀䰀䰀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䰀愀渀搀椀渀最倀愀最攀唀刀䰀ഀഀ
		, src.StartDate as RecentCampaignStartDate਍ऀऀⰀ 猀爀挀⸀䔀渀搀䐀愀琀攀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀ഀഀ
		, src.Status as RecentCampaignStatus਍ऀऀⴀⴀⰀ 一唀䰀䰀 愀猀 䠀漀眀䐀椀搀夀漀甀䠀攀愀爀䄀戀漀甀琀唀猀ഀഀ
		, sl.PostalCode as PostalCode ਍ऀऀⴀⴀⰀ 一唀䰀䰀 愀猀 䐀椀猀琀愀渀挀攀吀漀䄀猀猀椀最渀攀搀䌀攀渀琀攀爀ഀഀ
		--, NULL as DistanceToNearestCenter਍ऀऀⰀ 最⸀䐀䴀䄀䴀愀爀欀攀琀刀攀最椀漀渀 愀猀 刀攀最椀漀渀 ഀഀ
		, g.DMADescription as MarketDMA਍ऀऀⰀ 挀琀爀⸀䌀攀渀琀攀爀䐀攀猀挀爀椀瀀琀椀漀渀䘀甀氀氀䌀愀氀挀 愀猀 䌀攀渀琀攀爀一愀洀攀ഀഀ
		, cn.DMAMarketRegion as CenterRegion਍ऀऀⰀ 挀渀⸀䐀䴀䄀䐀攀猀挀爀椀瀀琀椀漀渀 愀猀 䌀攀渀琀攀爀䐀䴀䄀ഀഀ
		, ctr.CenterTypeDescription as CenterType਍ऀऀⰀ 挀琀爀⸀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀 愀猀 䌀攀渀琀攀爀伀眀渀攀爀ഀഀ
		, sl.Language__c as Language਍ऀऀⰀ 猀氀⸀䜀攀渀搀攀爀开开挀 愀猀 䜀攀渀搀攀爀ഀഀ
		, sl.LastName ਍ऀऀⰀ 猀氀⸀䘀椀爀猀琀一愀洀攀 ഀഀ
		, REPLACE(REPLACE(REPLACE(REPLACE(sl.[Phone],'(',''),')',''),' ',''),'-','') as 'Phone'਍ऀऀⰀ 刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀猀氀⸀嬀䴀漀戀椀氀攀倀栀漀渀攀崀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䄀匀 ✀䴀漀戀椀氀攀倀栀漀渀攀✀ഀഀ
		, sl.Email ਍ऀऀⰀ 猀氀⸀䔀琀栀渀椀挀椀琀礀开开挀 愀猀 䔀琀栀渀椀挀椀琀礀ഀഀ
		, Isnull(sl.NorwoodScale__c,sl.LudwigScale__c) as HairLossCondition਍ऀऀⰀ 猀氀⸀䴀愀爀椀琀愀氀匀琀愀琀甀猀开开挀 愀猀 䴀愀爀椀琀愀氀匀琀愀琀甀猀ഀഀ
		, sl.Occupation__c as Occupation਍ऀऀⴀⴀⰀ 一唀䰀䰀 愀猀 䠀䠀䤀渀挀漀洀攀ഀഀ
		, YEAR(sl.Birthday__c) as BirthYear਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 ㄀ 䄀一䐀 ㄀㜀⤀ 吀䠀䔀一 ✀唀渀搀攀爀 ㄀㠀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 18 AND 24) THEN '18 to 24'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 ㈀㔀 䄀一䐀 ㌀㐀⤀ 吀䠀䔀一 ✀㈀㔀 琀漀 ㌀㐀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 35 AND 44) THEN '35 to 44'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 㐀㔀 䄀一䐀 㔀㐀⤀ 吀䠀䔀一 ✀㐀㔀 琀漀 㔀㐀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 55 AND 64) THEN '55 to 64'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 㘀㔀 䄀一䐀 ㄀㈀　⤀ 吀䠀䔀一 ✀㘀㔀 ⬀✀ഀഀ
				 ELSE 'Unknown'਍ऀऀऀऀ䔀一䐀 䄀匀 䄀最攀䈀愀渀搀猀ഀഀ
		, ft.Contact as NewContact਍ऀऀⰀ 昀琀⸀䰀攀愀搀 愀猀 一攀眀䰀攀愀搀ഀഀ
		, ft.Appointment as NewAppointment਍ऀऀⰀ 昀琀⸀匀栀漀眀 愀猀 一攀眀匀栀漀眀ഀഀ
		, ft.Sale as NewSale਍ऀऀⰀ 昀琀⸀一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 愀猀 一攀眀䰀攀愀搀吀漀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
		, ft.NewLeadToshow as NewLeadToShow਍ऀऀⰀ 昀琀⸀一攀眀䰀攀愀搀吀漀猀愀氀攀 愀猀 一攀眀䰀攀愀搀吀漀匀愀氀攀ഀഀ
		, ft.QuotedPrice as QuotedPrice਍ऀऀⴀⴀⰀ 渀甀氀氀 愀猀 䌀漀渀琀爀愀挀琀攀搀倀爀椀挀攀ഀഀ
		--, Null as NetRevenue਍ऀऀⴀⴀⰀ 一甀氀氀 愀猀 䰀椀昀攀琀椀洀攀刀攀瘀攀渀甀攀ഀഀ
		, ft.saletypeDescription as PrimarySolution਍ऀऀⴀⴀⰀ 一甀氀氀 愀猀 匀漀氀甀琀椀漀渀ഀഀ
		--, Null as Service਍ऀऀⰀ 挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀䌀漀渀琀愀挀琀开开挀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀 愀猀 䐀漀一漀琀䌀漀渀琀愀挀琀䘀氀愀最ഀഀ
		, case when sl.DoNotCall = 1 then 'Y' else 'N' end as DoNotCallFlag਍ऀऀⰀ 挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀吀攀砀琀开开挀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀 愀猀 䐀漀一漀琀匀䴀匀䘀氀愀最ഀഀ
		, case when sl.DoNotEmail__c = 1 then 'Y' else 'N' end as DoNotEmailFlag਍ऀऀⰀ 挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀䴀愀椀氀开开挀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀 愀猀 䐀漀一漀琀䴀愀椀氀䘀氀愀最ഀഀ
		, sl.IsDeleted as 'IsDeleted'਍ऀऀⰀ 昀琀⸀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀ഀഀ
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl ਍ऀऀ氀攀昀琀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䌀愀洀瀀愀椀最渀 猀漀挀ഀഀ
		on sl.OriginalCampaignID__c = soc.Id ਍ऀऀ氀攀昀琀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䌀愀洀瀀愀椀最渀 猀爀挀ഀഀ
		on sl.RecentCampaign__c = src.Id ਍ऀऀ氀攀昀琀 樀漀椀渀 ⠀ഀഀ
			Select cc.CenterID਍ऀऀऀⰀ 挀挀⸀䌀攀渀琀攀爀一甀洀戀攀爀ഀഀ
			, cc.CenterDescriptionFullCalc ਍ऀऀऀⰀ 挀挀琀⸀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 ഀഀ
			, cco.CenterOwnershipDescription ਍ऀऀऀ昀爀漀洀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀䌀一䌀吀开䌀攀渀琀攀爀 挀挀 ഀഀ
			inner join [hc-sqlpool-eim-prod-eus2].ODS.CNCT_CenterOwnership cco ਍ऀऀऀ漀渀 挀挀⸀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䤀䐀 㴀 挀挀漀⸀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䤀䐀ഀഀ
			INNER join [hc-sqlpool-eim-prod-eus2].ODS.CNCT_CenterType cct ਍ऀऀऀ漀渀 挀挀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀 㴀 挀挀琀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀 ഀഀ
			where cc.isactiveflag = 1਍ऀऀ⤀ 愀猀 挀琀爀ഀഀ
		on ISNULL(sl.CenterNumber__c, sl.CenterID__c) = ctr.CenterNumber਍ऀऀ椀渀渀攀爀 樀漀椀渀 ⌀䘀甀渀渀攀氀吀愀戀氀攀 昀琀ഀഀ
		on sl.Id = ft.id਍ऀऀ氀攀昀琀 樀漀椀渀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开吀愀猀欀崀 琀猀欀ഀഀ
			on tsk.Id = ft.TaskId਍ऀऀ䰀䔀䘀吀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开䌀攀渀琀攀爀崀 挀攀渀琀攀爀ഀഀ
			ON tsk.CenterNumber__c = center.CenterId and center.isactiveflag = 1਍ऀऀ䰀䔀䘀吀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开䌀攀渀琀攀爀吀礀瀀攀崀 挀琀礀ഀഀ
			ON center.CenterTypeID = cty.CenterTypeID਍ऀऀ氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀䐀椀洀吀椀洀攀伀昀䐀愀礀崀 搀琀搀ഀഀ
		on trim(dtd.[Time24]) = trim(convert(varchar,ActivityDateEST,8))਍ऀऀ氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀䐀椀洀䜀攀漀最爀愀瀀栀礀崀 最ഀഀ
		on sl.PostalCode = g.DigitZipCode਍ऀऀ氀攀昀琀 樀漀椀渀 ⠀ഀഀ
			SELECT g.DigitZipCode਍ऀऀऀⰀ 最⸀䐀䴀䄀䌀漀搀攀ഀഀ
			, c.CenterNumber਍ऀऀऀⰀ 䐀䴀䄀䴀愀爀欀攀琀刀攀最椀漀渀ഀഀ
			, DMADescription਍ऀऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀嬀搀戀漀崀⸀嬀䐀椀洀䜀攀漀最爀愀瀀栀礀崀 最ഀഀ
			inner join [ODS].[CNCT_Center] c਍ऀऀऀ漀渀 挀⸀嬀倀漀猀琀愀氀䌀漀搀攀崀 㴀 最⸀嬀䐀椀最椀琀娀椀瀀䌀漀搀攀崀ഀഀ
			where c.isactiveflag=1) as cn਍ऀऀ漀渀 猀氀⸀嬀䌀攀渀琀攀爀一甀洀戀攀爀开开挀崀 㴀 挀渀⸀嬀䌀攀渀琀攀爀一甀洀戀攀爀崀ഀഀ
਍ഀഀ
	update Reports.Funnel set Region = Funnel.CenterRegion਍眀栀攀爀攀 倀漀猀琀愀氀䌀漀搀攀 椀猀 渀甀氀氀 漀爀 刀攀最椀漀渀 椀猀 渀甀氀氀ഀഀ
਍甀瀀搀愀琀攀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 猀攀琀 䴀愀爀欀攀琀䐀䴀䄀 㴀 䘀甀渀渀攀氀⸀䌀攀渀琀攀爀䐀䴀䄀ഀഀ
where PostalCode is null or MarketDMA is null਍ഀഀ
update Reports.Funnel set CenterRegion = Funnel.Region਍眀栀攀爀攀 䌀攀渀琀攀爀刀攀最椀漀渀 椀猀 渀甀氀氀ഀഀ
਍甀瀀搀愀琀攀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 猀攀琀 䌀攀渀琀攀爀䐀䴀䄀 㴀 䘀甀渀渀攀氀⸀䴀愀爀欀攀琀䐀䴀䄀ഀഀ
where CenterDMA is null;਍ഀഀ
਍圀椀琀栀 氀攀愀搀开琀攀洀瀀 愀猀 ⠀ഀഀ
		SELECT [SaleforceLeadID],[FunnelTransactionID]਍ऀऀ䘀刀伀䴀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 ഀഀ
		where funnelstep = 'Lead' --and [SaleforceLeadID] ='00Qf4000003mSxVEAU'਍ऀऀ⤀ഀഀ
		--insert into #temp਍ऀऀ猀攀氀攀挀琀 嬀匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀崀Ⰰ嬀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀 椀渀琀漀 ⌀甀瀀搀愀琀攀开琀爀愀渀猀愀挀琀椀漀渀 昀爀漀洀 氀攀愀搀开琀攀洀瀀㬀ഀഀ
਍甀瀀搀愀琀攀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 ഀഀ
	set [LeadFunnelTransactionID] = u.[FunnelTransactionID]਍䘀刀伀䴀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀  爀ഀഀ
INNER JOIN #update_transaction u਍漀渀 爀⸀嬀匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀崀 㴀 甀⸀嬀匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀崀㬀ഀഀ
਍圀椀琀栀 戀瀀挀搀 愀猀 ⠀ഀഀ
		SELECT [pkid],cast([custom3] as varchar) custom3਍ऀऀ䘀刀伀䴀 嬀伀䐀匀崀⸀嬀䈀倀开䌀愀氀氀䐀攀琀愀椀氀崀ഀഀ
		where custom3 is not null਍ऀऀ⤀ഀഀ
		--insert into #temp਍ऀऀ猀攀氀攀挀琀 嬀瀀欀椀搀崀Ⰰ挀愀猀琀⠀嬀挀甀猀琀漀洀㌀崀  愀猀 瘀愀爀挀栀愀爀⤀ 挀甀猀琀漀洀㌀ 椀渀琀漀 ⌀瀀欀椀搀 昀爀漀洀 戀瀀挀搀㬀ഀഀ
਍ഀഀ
਍甀瀀搀愀琀攀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 ഀഀ
	set [BrightPatternID] = b.pkid਍䘀刀伀䴀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀  爀ഀഀ
INNER JOIN #pkid b਍漀渀 爀⸀嬀匀愀氀攀猀䘀漀爀挀攀吀愀猀欀䤀䐀崀 㴀 戀⸀挀甀猀琀漀洀㌀㬀ഀഀ
਍圀椀琀栀 戀瀀挀搀开氀攀愀搀 愀猀 ⠀ഀഀ
		SELECT [pkid],cast([custom1] as varchar) custom1,[start_time],ROW_NUMBER() OVER(PARTITION BY custom1 ORDER BY [start_time] ASC) as rownum਍ऀऀ䘀刀伀䴀 嬀伀䐀匀崀⸀嬀䈀倀开䌀愀氀氀䐀攀琀愀椀氀崀ഀഀ
		where custom3 is not null਍ऀऀ⤀ഀഀ
		--insert into #temp਍ऀऀ猀攀氀攀挀琀 嬀瀀欀椀搀崀Ⰰ挀愀猀琀⠀嬀挀甀猀琀漀洀㄀崀  愀猀 瘀愀爀挀栀愀爀⤀ 挀甀猀琀漀洀㄀Ⰰ嬀猀琀愀爀琀开琀椀洀攀崀Ⰰ爀漀眀渀甀洀 椀渀琀漀 ⌀瀀欀椀搀开氀攀愀搀 昀爀漀洀 戀瀀挀搀开氀攀愀搀ഀഀ
		where rownum = 1;਍ഀഀ
਍甀瀀搀愀琀攀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 ഀഀ
	set [BrightPatternID] = b.pkid਍䘀刀伀䴀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀  爀ഀഀ
INNER JOIN #pkid_lead b਍漀渀 爀⸀嬀匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀崀 㴀 戀⸀挀甀猀琀漀洀㄀ഀഀ
਍ഀഀ
਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䘀甀渀渀攀氀吀愀戀氀攀ഀഀ
	DROP TABLE #update_transaction਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀瀀欀椀搀ഀഀ
	DROP TABLE #pkid_lead਍ऀഀഀ
end਍ഀഀ
਍ഀഀ
GO਍
