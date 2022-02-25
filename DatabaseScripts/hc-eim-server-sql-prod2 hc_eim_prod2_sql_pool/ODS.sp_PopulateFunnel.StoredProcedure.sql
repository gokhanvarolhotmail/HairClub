/****** Object:  StoredProcedure [ODS].[sp_PopulateFunnel]    Script Date: 2/22/2022 9:20:35 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀伀䐀匀崀⸀嬀猀瀀开倀漀瀀甀氀愀琀攀䘀甀渀渀攀氀崀 䄀匀ഀ
BEGIN਍ഀ
    truncate table Reports.Funnel਍ഀ
/************************************************** CREATE TABLES *******************************************************/਍挀爀攀愀琀攀 吀愀戀氀攀 ⌀䌀漀渀琀愀挀琀ഀ
	(਍ऀ    椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    TaskID varchar(50),਍ऀ    儀甀漀琀攀搀倀爀椀挀攀 椀渀琀Ⰰഀ
	    SaletypeDescription varchar(100),਍ऀ    圀栀漀椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    Result varchar(50),਍ऀ    䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀 搀愀琀攀琀椀洀攀Ⰰഀ
		ActivityDateEST datetime,਍ऀ    䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀ
	    Contact bit,਍ऀ    䰀攀愀搀 戀椀琀Ⰰഀ
	    Appointment bit,਍ऀ    匀栀漀眀 戀椀琀Ⰰഀ
	    Sale bit,਍ऀ    一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀ
	    NewLeadToshow bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀愀氀攀 戀椀琀Ⰰഀ
		CreatedDate datetime,਍ऀऀ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀ഀ
	)਍ഀ
	create Table #Lead਍ऀ⠀ഀ
	    id varchar(50),਍ऀ    吀愀猀欀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    QuotedPrice int,਍ऀ    匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
	    Whoid varchar(50),਍ऀ    刀攀猀甀氀琀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    ActivityDateUTC datetime,਍ऀऀ䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 搀愀琀攀琀椀洀攀Ⰰഀ
	    FunnelStep varchar(20),਍ऀ    䌀漀渀琀愀挀琀 戀椀琀Ⰰഀ
	    Lead bit,਍ऀ    䄀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀ
	    Show bit,਍ऀ    匀愀氀攀 戀椀琀Ⰰഀ
	    NewLeadToappointment bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀栀漀眀 戀椀琀Ⰰഀ
	    NewLeadTosale bit,਍ऀऀ䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀ
		LastModifiedDate datetime਍ऀ⤀ഀ
਍ऀ挀爀攀愀琀攀 吀愀戀氀攀 ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀ
	(਍ऀ    椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    TaskID varchar(50),਍ऀ    儀甀漀琀攀搀倀爀椀挀攀 椀渀琀Ⰰഀ
	    SaletypeDescription varchar(100),਍ऀ    圀栀漀椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    Result varchar(50),਍ऀ    䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀 搀愀琀攀琀椀洀攀Ⰰഀ
		ActivityDateEST datetime,਍ऀ    䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀ
	    Contact bit,਍ऀ    䰀攀愀搀 戀椀琀Ⰰഀ
	    Appointment bit,਍ऀ    匀栀漀眀 戀椀琀Ⰰഀ
	    Sale bit,਍ऀ    一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀ
	    NewLeadToshow bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀愀氀攀 戀椀琀Ⰰഀ
		CreatedDate datetime,਍ऀऀ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀ഀ
	)਍ഀ
	create Table #Show਍ऀ⠀ഀ
	    id varchar(50),਍ऀ    吀愀猀欀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    QuotedPrice int,਍ऀ    匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
	    Whoid varchar(50),਍ऀ    刀攀猀甀氀琀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    ActivityDateUTC datetime,਍ऀऀ䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 搀愀琀攀琀椀洀攀Ⰰഀ
	    FunnelStep varchar(20),਍ऀ    䌀漀渀琀愀挀琀 戀椀琀Ⰰഀ
	    Lead bit,਍ऀ    䄀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀ
	    Show bit,਍ऀ    匀愀氀攀 戀椀琀Ⰰഀ
	    NewLeadToappointment bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀栀漀眀 戀椀琀Ⰰഀ
	    NewLeadTosale bit,਍ऀऀ䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀ
		LastModifiedDate datetime਍ऀ⤀ഀ
਍ऀ挀爀攀愀琀攀 吀愀戀氀攀 ⌀匀愀氀攀ഀ
	(਍ऀ    椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    TaskID varchar(50),਍ऀ    儀甀漀琀攀搀倀爀椀挀攀 椀渀琀Ⰰഀ
	    SaletypeDescription varchar(100),਍ऀ    圀栀漀椀搀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    Result varchar(50),਍ऀ    䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀 搀愀琀攀琀椀洀攀Ⰰഀ
		ActivityDateEST datetime,਍ऀ    䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀ
	    Contact bit,਍ऀ    䰀攀愀搀 戀椀琀Ⰰഀ
	    Appointment bit,਍ऀ    匀栀漀眀 戀椀琀Ⰰഀ
	    Sale bit,਍ऀ    一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀ
	    NewLeadToshow bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀愀氀攀 戀椀琀Ⰰഀ
		CreatedDate datetime,਍ऀऀ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀ഀ
	)਍ഀ
	create Table #FunnelTable਍ऀ⠀ഀ
	    id varchar(50),਍ऀ    吀愀猀欀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    QuotedPrice int,਍ऀ    匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
	    Whoid varchar(50),਍ऀ    刀攀猀甀氀琀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
	    ActivityDateUTC datetime,਍ऀऀ䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 搀愀琀攀琀椀洀攀Ⰰഀ
	    FunnelStep varchar(20),਍ऀ    䌀漀渀琀愀挀琀 戀椀琀Ⰰഀ
	    Lead bit,਍ऀ    䄀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀ
	    Show bit,਍ऀ    匀愀氀攀 戀椀琀Ⰰഀ
	    NewLeadToappointment bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀栀漀眀 戀椀琀Ⰰഀ
	    NewLeadTosale bit,਍ऀऀ䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀ
		LastModifiedDate datetime਍ऀ⤀ഀ
਍⼀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀䤀一匀䔀刀吀 䤀一吀伀 吀䔀䴀倀 吀䄀䈀䰀䔀匀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⼀ഀ
਍ഀ
	Insert into਍ऀ   ⌀䌀漀渀琀愀挀琀ഀ
	Select਍ऀ  猀氀⸀䰀攀愀搀䤀搀ഀ
	, null as TaskID਍ऀⰀ 渀甀氀氀 愀猀 儀甀漀琀攀搀倀爀椀挀攀ഀ
	, null as SaletypeDescription਍ऀⰀ 渀甀氀氀 愀猀 圀栀漀椀搀ഀ
	, null as Result਍ऀⰀ 猀氀⸀䰀攀愀搀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀ഀ
	, dateadd(mi,datepart(tz,CONVERT(datetime,sl.LeadLastActivityDate)    AT TIME ZONE 'Eastern Standard Time'),sl.LeadLastActivityDate) as ActivityDateEST਍ऀⰀ ✀䌀漀渀琀愀挀琀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀ഀ
	, 1 as Contact਍ऀⰀ 　 愀猀 氀攀愀搀ഀ
	, 0 as appointment਍ऀⰀ 　 愀猀 猀栀漀眀ഀ
	, 0 as sale਍ऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀ഀ
	, 0 as NewLeadToshow਍ऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀愀氀攀ഀ
	, sl.LeadCreatedDateUTC as CreatedDate਍ऀⰀ 一唀䰀䰀 䄀匀 䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀ഀ
	FROM dbo.VWLead sl਍ഀ
਍ऀⴀⴀⴀ䰀攀愀搀ഀ
	Insert into  #Lead਍ऀ匀攀氀攀挀琀ഀ
	  sl.leadid਍ऀⰀ 渀甀氀氀 愀猀 吀愀猀欀䤀䐀ഀ
	, null as QuotedPrice਍ऀⰀ 渀甀氀氀 愀猀 匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀ഀ
	, null as Whoid਍ऀⰀ 渀甀氀氀 愀猀 刀攀猀甀氀琀ഀ
	, sl.LeadLastActivityDate as ActivityDateUTC਍ऀⰀ 搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ猀氀⸀䰀攀愀搀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ猀氀⸀䰀攀愀搀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀⤀ 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀ഀ
	, 'Lead' as FunnelStep਍ऀⰀ 　 愀猀 䌀漀渀琀愀挀琀ഀ
	, 1 as lead਍ऀⰀ 　 愀猀 愀瀀瀀漀椀渀琀洀攀渀琀ഀ
	, 0 as show਍ऀⰀ 　 愀猀 猀愀氀攀ഀ
	, 0 as NewLeadToappointment਍ऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀栀漀眀ഀ
	, 0 as NewLeadTosale਍ऀⰀ 猀氀⸀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀 愀猀 䌀爀攀愀琀攀搀䐀愀琀攀ഀ
	, null as LastModifiedDate਍ऀ䘀刀伀䴀 搀戀漀⸀嘀圀䰀攀愀搀 猀氀ഀ
	where Isvalid = '1';਍ഀ
਍ഀ
--Appointment਍ऀ圀椀琀栀 琀愀猀欀 愀猀 ⠀ഀ
	SELECT AppointmentId Taskid,a.leadid as leadid,a.AppointmentStatus,a.AppointmentDate,FactDate,a.DWH_LastUpdateDate,a.accountid,a.externalTaskID,਍ऀ刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 愀⸀氀攀愀搀椀搀 伀刀䐀䔀刀 䈀夀 愀⸀䘀愀挀琀䐀愀琀攀 䄀匀䌀⤀ഀ
	AS RowNum਍ऀ䘀刀伀䴀 搀戀漀⸀䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀 愀ഀ
	left JOIN dbo.VWLead sl on a.LeadId=sl.leadid਍    氀攀昀琀 樀漀椀渀 搀椀洀愀挀挀漀甀渀琀 挀 漀渀 愀⸀愀挀挀漀甀渀琀椀搀㴀挀⸀愀挀挀漀甀渀琀椀搀ഀ
    left join dbo.VWLead d on c.accountid=d.convertedaccountid਍ऀ⤀ഀ
		Insert into਍ऀ      ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀ
		SELECT਍ऀऀ愀⸀氀攀愀搀椀搀ഀ
		, a.Taskid਍ऀऀⰀ 一唀䰀䰀 䄀匀 儀甀漀琀攀搀倀爀椀挀攀ഀ
		, 'Unknown' as saletypeDescription਍ऀऀⰀ 愀⸀氀攀愀搀椀搀ഀ
		, a.AppointmentStatus as Result਍ऀऀⰀ 一唀䰀䰀 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀ഀ
		, a.AppointmentDate AS ActivityDateEST਍ऀऀⰀ ✀䄀瀀瀀漀椀渀琀洀攀渀琀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀ഀ
		, 0 as Contact਍ऀऀⰀ 　 愀猀 䰀攀愀搀ഀ
		, 1 as Appointment਍ऀऀⰀ 　 愀猀 匀栀漀眀ഀ
		, 0 as Sale਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀ഀ
		, 0 as NewLeadToshow਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀愀氀攀ഀ
		, a.FactDate as CreatedDate਍ऀऀⰀ 愀⸀䐀圀䠀开䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀ഀ
		FROM task a਍        眀栀攀爀攀 刀漀眀一甀洀 㴀 ㄀ 愀渀搀 愀⸀吀愀猀欀椀搀 椀猀 渀漀琀 渀甀氀氀 愀渀搀 愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀 渀漀琀 氀椀欀攀 ✀䌀愀渀挀攀氀攀搀✀㬀ഀ
਍ഀ
	---Show਍        圀椀琀栀 琀愀猀欀 愀猀 ⠀ഀ
            SELECT OpportunityId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.LastModifiedDate,b.accountid,externaltaskid,਍            刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 戀⸀䰀攀愀搀䤀搀Ⰰ戀⸀愀挀挀漀甀渀琀椀搀 伀刀䐀䔀刀 䈀夀 戀⸀䘀愀挀琀䐀愀琀攀 䄀匀䌀⤀ഀ
            AS RowNum਍            䘀刀伀䴀 搀戀漀⸀䘀愀挀琀伀瀀瀀漀爀琀甀渀椀琀礀 戀ഀ
਍            ⤀ഀ
਍ऀऀ䤀渀猀攀爀琀 椀渀琀漀ഀ
	    #Show਍ऀऀ匀䔀䰀䔀䌀吀ഀ
		a.leadid਍ऀऀⰀ 愀⸀吀愀猀欀椀搀ഀ
		, null as QuotedPrice਍ऀऀⰀ ✀唀渀欀渀漀眀渀✀ 愀猀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀ഀ
		, a.LeadId਍ऀऀⰀ 愀⸀伀瀀瀀漀爀琀甀渀椀琀礀匀琀愀琀甀猀 愀猀 刀攀猀甀氀琀ഀ
		, NULL as ActivityDate਍ऀऀⰀ 愀⸀䘀愀挀琀䐀愀琀攀 䄀匀 䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀ഀ
		, 'Show' as FunnelStep਍ऀऀⰀ 　 愀猀 䌀漀渀琀愀挀琀ഀ
		, 0 as Lead਍ऀऀⰀ 　 愀猀 䄀瀀瀀漀椀渀琀洀攀渀琀ഀ
		, 1 as Show਍ऀऀⰀ 　 愀猀 匀愀氀攀ഀ
		, 0 as NewLeadToappointment਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀栀漀眀ഀ
		, 0 as NewLeadTosale਍ऀऀⰀ 愀⸀䘀愀挀琀䐀愀琀攀 愀猀 䌀爀攀愀琀攀搀䐀愀琀攀ഀ
		, a.LastModifiedDate਍        䘀刀伀䴀 琀愀猀欀 愀ഀ
		left JOIN dbo.VWLead sl on a.LeadId=sl.leadid਍        氀攀昀琀 樀漀椀渀 搀椀洀愀挀挀漀甀渀琀 挀 漀渀 愀⸀愀挀挀漀甀渀琀椀搀㴀挀⸀愀挀挀漀甀渀琀椀搀ഀ
       -- left join dbo.VWLead d on c.accountid=d.convertedaccountid਍        眀栀攀爀攀 刀漀眀一甀洀 㴀 ㄀ 愀渀搀 愀⸀吀愀猀欀椀搀 椀猀 渀漀琀 渀甀氀氀 愀渀搀 愀⸀伀瀀瀀漀爀琀甀渀椀琀礀匀琀愀琀甀猀 椀猀 渀漀琀 渀甀氀氀 㬀ഀ
਍ഀ
਍ऀⴀⴀⴀ匀愀氀攀ഀ
਍ऀऀ圀椀琀栀 琀愀猀欀 愀猀 ⠀ഀ
            SELECT OpportunityId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.LastModifiedDate,Iswon,accountid,ExternalTaskId,਍            刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 戀⸀䰀攀愀搀䤀搀Ⰰ愀挀挀漀甀渀琀椀搀 伀刀䐀䔀刀 䈀夀 戀⸀䘀愀挀琀䐀愀琀攀 䄀匀䌀⤀ഀ
            AS RowNum਍            䘀刀伀䴀 搀戀漀⸀䘀愀挀琀伀瀀瀀漀爀琀甀渀椀琀礀 戀ഀ
਍            ⤀ഀ
਍ऀऀ䤀渀猀攀爀琀 椀渀琀漀ഀ
	    #Sale਍ऀऀ匀䔀䰀䔀䌀吀ഀ
		a.leadid਍ऀऀⰀ 愀⸀吀愀猀欀椀搀ഀ
		, null as QuotedPrice਍ऀऀⰀ ✀唀渀欀渀漀眀渀✀ 愀猀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀ഀ
		, a.LeadId਍ऀऀⰀ 愀⸀伀瀀瀀漀爀琀甀渀椀琀礀匀琀愀琀甀猀 愀猀 刀攀猀甀氀琀ഀ
		, NULL as ActivityDate਍ऀऀⰀ 愀⸀䘀愀挀琀䐀愀琀攀 䄀匀 䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀ഀ
		, 'Sale' as FunnelStep਍ऀऀⰀ 　 愀猀 䌀漀渀琀愀挀琀ഀ
		, 0 as Lead਍ऀऀⰀ 　 愀猀 䄀瀀瀀漀椀渀琀洀攀渀琀ഀ
		, 0 as Show਍ऀऀⰀ ㄀ 愀猀 匀愀氀攀ഀ
		, 0 as NewLeadToappointment਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀栀漀眀ഀ
		, 0 as NewLeadTosale਍ऀऀⰀ 愀⸀䘀愀挀琀䐀愀琀攀 愀猀 䌀爀攀愀琀攀搀䐀愀琀攀ഀ
		, a.LastModifiedDate਍ऀऀ䘀刀伀䴀 琀愀猀欀 愀ഀ
		left JOIN dbo.VWLead sl on a.LeadId=sl.leadid਍        氀攀昀琀 樀漀椀渀 搀椀洀愀挀挀漀甀渀琀 挀 漀渀 愀⸀愀挀挀漀甀渀琀椀搀㴀挀⸀愀挀挀漀甀渀琀椀搀ഀ
       -- left join dbo.VWLead d on c.accountid=d.convertedaccountid਍        眀栀攀爀攀 刀漀眀一甀洀 㴀 ㄀ഀ
        and a.IsWon = '1' and a.Taskid is not null and a.OpportunityStatus = 'Closed Won';਍ഀ
਍ഀ
	---Temp਍ഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY activityDate ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀ
	FROM ods.SF_Task b਍ऀ眀栀攀爀攀 愀挀琀椀瘀椀琀礀搀愀琀攀 椀猀 渀漀琀 渀甀氀氀ഀ
	)਍ഀ
	--insert into #temp਍ऀ猀攀氀攀挀琀 刀漀眀一甀洀Ⰰ 琀愀猀欀椀搀 Ⰰ 眀栀漀椀搀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀 椀渀琀漀 ⌀琀攀洀瀀 昀爀漀洀 琀愀猀欀ഀ
	where RowNum = 1;਍ഀ
	-------------------------------------------------------------------------------------------------਍ഀ
	---Union Tables਍ഀ
    Insert into਍ऀ   ⌀䘀甀渀渀攀氀吀愀戀氀攀ഀ
	Select *਍ऀ䘀刀伀䴀 ⌀䌀漀渀琀愀挀琀ഀ
	union all਍ऀ匀攀氀攀挀琀 ⨀ഀ
	From #Lead਍ऀ唀渀椀漀渀 愀氀氀ഀ
	Select *਍ऀ䘀爀漀洀 ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀ
	Union all਍ऀ匀攀氀攀挀琀 ⨀ഀ
	From #Show਍ऀ唀渀椀漀渀 愀氀氀ഀ
	Select *਍ऀ昀爀漀洀 ⌀匀愀氀攀㬀ഀ
਍ഀ
਍ഀ
਍⼀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀唀倀䐀䄀吀䔀 䘀唀一一䔀䰀 吀䄀䈀䰀䔀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⼀ഀ
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
	insert into #funneltable਍ऀ猀攀氀攀挀琀 ⨀ 昀爀漀洀  ⌀琀攀洀瀀漀爀愀氀ഀ
਍    甀瀀搀愀琀攀 ⌀昀甀渀渀攀氀吀愀戀氀攀 猀攀琀 一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 㴀 ㄀ഀ
	where id in (select id from #funnelTable where funnelstep='Appointment')਍ऀ愀渀搀 昀甀渀渀攀氀猀琀攀瀀㴀✀䰀攀愀搀✀ഀ
਍ऀ甀瀀搀愀琀攀 ⌀昀甀渀渀攀氀吀愀戀氀攀 猀攀琀 一攀眀䰀攀愀搀吀漀猀栀漀眀 㴀 ㄀ഀ
	where (id in (select id from #funnelTable where funnelstep='Show'))਍ऀ愀渀搀 昀甀渀渀攀氀猀琀攀瀀㴀✀䰀攀愀搀✀ഀ
਍ऀ甀瀀搀愀琀攀 ⌀昀甀渀渀攀氀吀愀戀氀攀 猀攀琀 一攀眀䰀攀愀搀吀漀猀愀氀攀 㴀 ㄀ഀ
	where id in (select id from #funnelTable where funnelstep='Sale')਍ऀ愀渀搀 昀甀渀渀攀氀猀琀攀瀀 㴀✀䰀攀愀搀✀ഀ
਍    甀瀀搀愀琀攀 ⌀昀甀渀渀攀氀吀愀戀氀攀ഀ
		set TaskId = t.taskid਍ऀ䘀刀伀䴀 ⌀昀甀渀渀攀氀吀愀戀氀攀 昀ഀ
	INNER JOIN #temp t਍ऀ漀渀 昀⸀椀搀 㴀 琀⸀眀栀漀椀搀ഀ
	where (f.funnelstep ='Lead' or f.funnelstep ='Contact')਍ഀ
਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀ
	DROP TABLE #Contact਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䰀攀愀搀ഀ
	DROP TABLE #Sale਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀匀栀漀眀ഀ
	DROP TABLE #temp਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀琀攀洀瀀漀爀愀氀㬀ഀ
਍ഀ
/****************************************INSERT INTO REPORTS FUNNEL TABLE***************************************/਍ഀ
    With recentcampaign as (਍    匀䔀䰀䔀䌀吀 戀⸀⨀Ⰰഀ
    ROW_NUMBER() OVER(PARTITION BY b.CampaignId ORDER BY b.CreatedDate ASC)਍    䄀匀 刀漀眀一甀洀ഀ
    FROM ods.SF_CampaignMember b਍ഀ
਍    ⤀ഀ
਍ऀ䤀渀猀攀爀琀 椀渀琀漀ഀ
		     Reports.Funnel ([ContactID]਍ऀऀ  Ⰰ嬀匀愀氀攀猀䘀漀爀挀攀吀愀猀欀䤀䐀崀ഀ
		  ,[BrightPatternID]਍ऀऀ  Ⰰ嬀䰀攀愀搀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀ഀ
		  ,[SaleforceLeadID]਍ऀऀ  Ⰰ嬀䌀漀洀瀀愀渀礀崀ഀ
		  ,[FunnelStep]਍ऀऀ  Ⰰ嬀䘀甀渀渀攀氀猀琀愀琀甀猀崀ഀ
		  ,[OriginalGCLID]਍ऀऀ  Ⰰ嬀䰀攀愀搀䌀爀攀愀琀攀䐀愀琀攀唀吀䌀崀ഀ
		  ,[LeadCreateDateEST]਍ऀऀ  Ⰰ嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀崀ഀ
		  ,[ActivityDateEST]਍ऀऀ  Ⰰ嬀刀攀瀀漀爀琀䌀爀攀愀琀攀䐀愀琀攀崀ഀ
		  ,[Date]਍ऀऀ  Ⰰ嬀吀椀洀攀崀ഀ
		  ,[DayPart]਍ऀऀ  Ⰰ嬀䠀漀甀爀崀ഀ
		  ,[Minute]਍ऀऀ  Ⰰ嬀匀攀挀漀渀搀猀崀ഀ
		  ,[OriginalContactType]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀匀漀甀爀挀攀挀漀搀攀崀ഀ
		  ,[OriginalDialedNumber]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀ഀ
		  ,[OriginalCampaignAgency]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀ഀ
		  ,[OriginalCampaignName]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀ഀ
		  ,[OriginalCampaignLanguage]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀ഀ
		  ,[OriginalCampaignStartDate]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀ഀ
		  ,[OriginalCampaignStatus]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀匀漀甀爀挀攀挀漀搀攀崀ഀ
		  ,[RecentDialedNumber]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀ഀ
		  ,[RecentCampaignAgency]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀ഀ
		  ,[RecentCampaignName]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀ഀ
		  ,[RecentCampaignLanguage]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀ഀ
		  ,[RecentCampaignStartDate]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀ഀ
		  ,[RecentCampaignStatus]਍ऀऀ  Ⰰ嬀倀漀猀琀愀氀䌀漀搀攀崀ഀ
		  ,[Region]਍ऀऀ  Ⰰ嬀䴀愀爀欀攀琀䐀䴀䄀崀ഀ
		  ,[CenterName]਍ऀऀ  Ⰰ嬀䌀攀渀琀攀爀刀攀最椀漀渀崀ഀ
		  ,[CenterDMA]਍ऀऀ  Ⰰ嬀䌀攀渀琀攀爀吀礀瀀攀崀ഀ
		  ,[CenterOwner]਍ऀऀ  Ⰰ嬀䰀愀渀最甀愀最攀崀ഀ
		  ,[Gender]਍ऀऀ  Ⰰ嬀䰀愀猀琀一愀洀攀崀ഀ
		  ,[FirstName]਍ऀऀ  Ⰰ嬀倀栀漀渀攀崀ഀ
		  ,[MobilePhone]਍ऀऀ  Ⰰ嬀䔀洀愀椀氀崀ഀ
		  ,[Ethnicity]਍ऀऀ  Ⰰ嬀䠀愀椀爀䰀漀猀猀䌀漀渀搀椀琀椀漀渀崀ഀ
		  ,[MaritalStatus]਍ऀऀ  Ⰰ嬀伀挀挀甀瀀愀琀椀漀渀崀ഀ
		  ,[BirthYear]਍ऀऀ  Ⰰ嬀䄀最攀䈀愀渀搀猀崀ഀ
		  ,[NewContact]਍ऀऀ  Ⰰ嬀一攀眀䰀攀愀搀崀ഀ
		  ,[NewAppointment]਍ऀऀ  Ⰰ嬀一攀眀匀栀漀眀崀ഀ
		  ,[NewSale]਍ऀऀ  Ⰰ嬀一攀眀䰀攀愀搀吀漀䄀瀀瀀漀椀渀琀洀攀渀琀崀ഀ
		  ,[NewLeadToShow]਍ऀऀ  Ⰰ嬀一攀眀䰀攀愀搀吀漀匀愀氀攀崀ഀ
		  ,[QuotedPrice]਍ऀऀ  Ⰰ嬀倀爀椀洀愀爀礀匀漀氀甀琀椀漀渀崀ഀ
		  ,[DoNotContactFlag]਍ऀऀ  Ⰰ嬀䐀漀一漀琀䌀愀氀氀䘀氀愀最崀ഀ
		  ,[DoNotSMSFlag]਍ऀऀ  Ⰰ嬀䐀漀一漀琀䔀洀愀椀氀䘀氀愀最崀ഀ
		  ,[DoNotMailFlag]਍ऀऀ  Ⰰ嬀䤀猀䐀攀氀攀琀攀搀崀ഀ
		  ,[LastModifiedDate])਍ഀ
		SELECT਍ऀऀ 一唀䰀䰀 愀猀 ✀䌀漀渀琀愀挀琀䤀䐀✀ഀ
		, ft.Taskid as SalesForceTaskID਍ऀऀⰀ一唀䰀䰀 愀猀 嬀䈀爀椀最栀琀倀愀琀琀攀爀渀䤀䐀崀ഀ
		,NULL AS LeadFunnelTransactionID਍ऀऀⰀ 猀氀⸀䰀攀愀搀䤀搀 愀猀 匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀ഀ
		, CASE WHEN(cty.CenterTypeDescription = 'Hans Wiemann') THEN 'Hans Wiemann'਍ऀऀऀ   䔀䰀匀䔀 ✀䠀愀椀爀 䌀氀甀戀✀ഀ
			   END AS Company਍ऀऀⰀ 昀琀⸀䘀甀渀渀攀氀匀琀攀瀀ഀ
		, sl.LeadStatus as FunnelStatus਍ऀऀⰀ 猀氀⸀䜀䌀䰀䤀䐀 愀猀 伀爀椀最椀渀愀氀䜀䌀䰀䤀䐀ഀ
		, sl.LeadCreatedDateUTC as LeadCreateDateUTC਍ऀऀⰀ 搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ猀氀⸀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ猀氀⸀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀⤀ 愀猀 䰀攀愀搀䌀爀攀愀琀攀䐀愀琀攀䔀匀吀ഀ
		, ft.ActivityDateUTC as ActivityDateUTC਍ऀऀⰀ 昀琀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀ഀ
		, sl.LeadCreatedDateUTC as ReportCreateDate਍ऀऀⰀ 挀愀猀琀⠀昀琀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 愀猀 搀愀琀攀⤀ 愀猀 䐀愀琀攀ഀ
		, cast(ft.ActivityDateEST as time) as time਍ऀऀⰀ 搀琀搀⸀䐀愀礀倀愀爀琀 愀猀 䐀愀礀倀愀爀琀ഀ
		, dtd.[Hour] as Hour਍ऀऀⰀ 搀琀搀⸀嬀洀椀渀甀琀攀崀 愀猀 䴀椀渀甀琀攀ഀ
		, dtd.[Second] as Seconds਍ऀऀⰀ 猀氀⸀匀漀甀爀挀攀一愀洀攀 䄀匀 伀爀椀最椀渀愀氀䌀漀渀琀愀挀琀吀礀瀀攀ഀ
		, soc.SourceCode as OriginalSourcecode਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 猀漀挀⸀匀漀甀爀挀攀䌀漀搀攀 氀椀欀攀 ✀─䴀倀✀ഀ
				THEN soc.TollFreeMobileName਍ऀऀऀ䔀䰀匀䔀ഀ
				soc.TollFreeName਍ऀऀ  䔀一䐀 䄀匀 伀爀椀最椀渀愀氀䐀椀愀氀攀搀一甀洀戀攀爀ഀ
		, SUBSTRING(sl.LeadPhone, 0,4 ) AS OriginalPhoneNumberAreaCode਍ऀऀⰀ 猀漀挀⸀䄀最攀渀挀礀一愀洀攀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀ഀ
		, soc.CampaignChannel as OriginalCampaignChannel਍ऀऀⰀ 猀漀挀⸀䌀愀洀瀀愀椀最渀一愀洀攀  愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀一愀洀攀ഀ
		, soc.CampaignFormat as OriginalCampaignFormat਍ऀऀⰀ 猀漀挀⸀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀ഀ
		, soc.PromoCode as OriginalCampaignPromotionCode਍ऀऀⰀ 猀漀挀⸀匀琀愀爀琀䐀愀琀攀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀ഀ
		, soc.EndDate as OriginalCampaignEndDate਍ऀऀⰀ 猀漀挀⸀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀ഀ
	    , sl.SourceName as RecentSourceCode਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 爀漀挀⸀匀漀甀爀挀攀䌀漀搀攀 氀椀欀攀 ✀─䴀倀✀ഀ
				THEN roc.TollFreeMobileName਍ऀऀऀ䔀䰀匀䔀ഀ
				roc.TollFreeName਍ऀऀ  䔀一䐀 䄀匀 伀爀椀最椀渀愀氀䐀椀愀氀攀搀一甀洀戀攀爀ഀ
		, SUBSTRING(sl.LeadPhone, 0,4 ) as RecentPhoneNumberAreaCode਍ऀऀⰀ 爀漀挀⸀䌀愀洀瀀愀椀最渀吀礀瀀攀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䄀最攀渀挀礀ഀ
		, roc.CampaignChannel as RecentCampaignChannel਍ऀऀⰀ 爀漀挀⸀䌀愀洀瀀愀椀最渀一愀洀攀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀一愀洀攀ഀ
		, roc.CampaignFormat as RecentCampaignFormat਍ऀऀⰀ 爀漀挀⸀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䰀愀渀最甀愀最攀ഀ
		, roc.PromoCode as RecentCampaignPromotionCode਍ऀऀⰀ 爀漀挀⸀匀琀愀爀琀䐀愀琀攀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀ഀ
		, roc.EndDate as RecentCampaignEndDate਍ऀऀⰀ 爀漀挀⸀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀ഀ
		, sl.CenterPostalCode as PostalCode਍ऀऀⰀ 最⸀䐀䴀䄀䴀愀爀欀攀琀刀攀最椀漀渀 愀猀 刀攀最椀漀渀ഀ
		, g.DMADescription as MarketDMA਍ऀऀⰀ 挀琀爀⸀䌀攀渀琀攀爀䐀攀猀挀爀椀瀀琀椀漀渀䘀甀氀氀䌀愀氀挀 愀猀 䌀攀渀琀攀爀一愀洀攀ഀ
		, cn.DMAMarketRegion as CenterRegion਍ऀऀⰀ 挀渀⸀䐀䴀䄀䐀攀猀挀爀椀瀀琀椀漀渀 愀猀 䌀攀渀琀攀爀䐀䴀䄀ഀ
		, ctr.CenterTypeDescription as CenterType਍ऀऀⰀ 挀琀爀⸀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀 愀猀 䌀攀渀琀攀爀伀眀渀攀爀ഀ
		, sl.LeadLanguage as Language਍ऀऀⰀ 猀氀⸀䰀攀愀搀䜀攀渀搀攀爀 愀猀 䜀攀渀搀攀爀ഀ
		, sl.LeadLastname਍ऀऀⰀ 猀氀⸀䰀攀愀搀一愀洀攀ഀ
		, REPLACE(REPLACE(REPLACE(REPLACE(sl.LeadPhone,'(',''),')',''),' ',''),'-','') as 'Phone'਍ऀऀⰀ 刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀猀氀⸀䰀攀愀搀䴀漀戀椀氀攀倀栀漀渀攀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 䄀匀 ✀䴀漀戀椀氀攀倀栀漀渀攀✀ഀ
		, sl.LeadEmail਍ऀऀⰀ 猀氀⸀䰀攀愀搀䔀琀栀渀椀挀椀琀礀 愀猀 䔀琀栀渀椀挀椀琀礀ഀ
		, Isnull(sl.NorwoodScale,sl.LudwigScale) as HairLossCondition਍ऀऀⰀ 猀氀⸀䰀攀愀搀䴀愀爀椀琀愀氀匀琀愀琀甀猀 愀猀 䴀愀爀椀琀愀氀匀琀愀琀甀猀ഀ
		, sl.LeadOccupation as Occupation਍ऀऀⰀ 夀䔀䄀刀⠀猀氀⸀䰀攀愀搀䈀椀爀琀栀搀愀礀⤀ 愀猀 䈀椀爀琀栀夀攀愀爀ഀ
		, CASE WHEN(CAST(DATEDIFF(year, sl.LeadBirthday, getdate()) AS INT) BETWEEN 1 AND 17) THEN 'Under 18'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䰀攀愀搀䈀椀爀琀栀搀愀礀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 ㄀㠀 䄀一䐀 ㈀㐀⤀ 吀䠀䔀一 ✀㄀㠀 琀漀 ㈀㐀✀ഀ
				 WHEN(CAST(DATEDIFF(year, sl.LeadBirthday, getdate()) AS INT) BETWEEN 25 AND 34) THEN '25 to 34'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䰀攀愀搀䈀椀爀琀栀搀愀礀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 ㌀㔀 䄀一䐀 㐀㐀⤀ 吀䠀䔀一 ✀㌀㔀 琀漀 㐀㐀✀ഀ
				 WHEN(CAST(DATEDIFF(year, sl.LeadBirthday, getdate()) AS INT) BETWEEN 45 AND 54) THEN '45 to 54'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䰀攀愀搀䈀椀爀琀栀搀愀礀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 㔀㔀 䄀一䐀 㘀㐀⤀ 吀䠀䔀一 ✀㔀㔀 琀漀 㘀㐀✀ഀ
				 WHEN(CAST(DATEDIFF(year, sl.LeadBirthday, getdate()) AS INT) BETWEEN 65 AND 120) THEN '65 +'਍ऀऀऀऀ 䔀䰀匀䔀 ✀唀渀欀渀漀眀渀✀ഀ
				END AS AgeBands਍ऀऀⰀ 昀琀⸀䌀漀渀琀愀挀琀 愀猀 一攀眀䌀漀渀琀愀挀琀ഀ
		, ft.Lead as NewLead਍ऀऀⰀ 昀琀⸀䄀瀀瀀漀椀渀琀洀攀渀琀 愀猀 一攀眀䄀瀀瀀漀椀渀琀洀攀渀琀ഀ
		, ft.Show as NewShow਍ऀऀⰀ 昀琀⸀匀愀氀攀 愀猀 一攀眀匀愀氀攀ഀ
		, ft.NewLeadToappointment as NewLeadToAppointment਍ऀऀⰀ 昀琀⸀一攀眀䰀攀愀搀吀漀猀栀漀眀 愀猀 一攀眀䰀攀愀搀吀漀匀栀漀眀ഀ
		, ft.NewLeadTosale as NewLeadToSale਍ऀऀⰀ 昀琀⸀儀甀漀琀攀搀倀爀椀挀攀 愀猀 儀甀漀琀攀搀倀爀椀挀攀ഀ
		, ft.saletypeDescription as PrimarySolution਍ऀऀⰀ 挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀䌀漀渀琀愀挀琀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀 愀猀 䐀漀一漀琀䌀漀渀琀愀挀琀䘀氀愀最ഀ
		, case when sl.DoNotCall = 1 then 'Y' else 'N' end as DoNotCallFlag਍ऀऀⰀ 挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀吀攀砀琀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀 愀猀 䐀漀一漀琀匀䴀匀䘀氀愀最ഀ
		, case when sl.DoNotEmail = 1 then 'Y' else 'N' end as DoNotEmailFlag਍ऀऀⰀ 挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀䴀愀椀氀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀 愀猀 䐀漀一漀琀䴀愀椀氀䘀氀愀最ഀ
		, sl.IsDeleted as 'IsDeleted'਍ऀऀⰀ 昀琀⸀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀ഀ
		FROM VWLead sl਍ऀऀ氀攀昀琀 樀漀椀渀 ⠀ 猀攀氀攀挀琀 ⨀ 昀爀漀洀 爀攀挀攀渀琀挀愀洀瀀愀椀最渀ഀ
		            where RowNum = 2) as rcg਍ऀऀ漀渀 爀挀最⸀䌀愀洀瀀愀椀最渀䤀搀 㴀 猀氀⸀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀ഀ
		left join dbo.DimCampaign soc਍ऀऀ漀渀 猀氀⸀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀 㴀 猀漀挀⸀䌀愀洀瀀愀椀最渀䤀搀ഀ
		left join dbo.DimCampaign roc਍ऀऀ漀渀 爀漀挀⸀䌀愀洀瀀愀椀最渀䤀搀 㴀 爀挀最⸀䌀愀洀瀀愀椀最渀䤀搀ഀ
		left join (਍ऀऀऀ匀攀氀攀挀琀 挀挀⸀䌀攀渀琀攀爀䤀䐀ഀ
			, cc.CenterNumber਍ऀऀऀⰀ 挀挀⸀䌀攀渀琀攀爀䐀攀猀挀爀椀瀀琀椀漀渀䘀甀氀氀䌀愀氀挀ഀ
			, cct.CenterTypeDescription਍ऀऀऀⰀ 挀挀漀⸀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀ഀ
			from ODS.CNCT_Center cc਍ऀऀऀ椀渀渀攀爀 樀漀椀渀 伀䐀匀⸀䌀一䌀吀开䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀 挀挀漀ഀ
			on cc.CenterOwnershipID = cco.CenterOwnershipID਍ऀऀऀ䤀一一䔀刀 樀漀椀渀 伀䐀匀⸀䌀一䌀吀开䌀攀渀琀攀爀吀礀瀀攀 挀挀琀ഀ
			on cc.CenterTypeID = cct.CenterTypeID਍ऀऀऀ眀栀攀爀攀 挀挀⸀椀猀愀挀琀椀瘀攀昀氀愀最 㴀 ㄀ഀ
		) as ctr਍ऀऀ漀渀 猀氀⸀䌀攀渀琀攀爀一甀洀戀攀爀 㴀 挀琀爀⸀䌀攀渀琀攀爀一甀洀戀攀爀ഀ
		inner join #FunnelTable ft਍ऀऀ漀渀 猀氀⸀氀攀愀搀椀搀 㴀 昀琀⸀椀搀ഀ
		LEFT JOIN [ODS].[CNCT_Center] center਍ऀऀऀ伀一 猀氀⸀䌀攀渀琀攀爀一甀洀戀攀爀 㴀 挀攀渀琀攀爀⸀䌀攀渀琀攀爀䤀搀 愀渀搀 挀攀渀琀攀爀⸀椀猀愀挀琀椀瘀攀昀氀愀最 㴀 ㄀ഀ
		LEFT JOIN [ODS].[CNCT_CenterType] cty਍ऀऀऀ伀一 挀攀渀琀攀爀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀 㴀 挀琀礀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀ഀ
		left join [dbo].[DimTimeOfDay] dtd਍ऀऀ漀渀 琀爀椀洀⠀搀琀搀⸀嬀吀椀洀攀㈀㐀崀⤀ 㴀 琀爀椀洀⠀挀漀渀瘀攀爀琀⠀瘀愀爀挀栀愀爀Ⰰ䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀Ⰰ㠀⤀⤀ഀ
		left join [dbo].[DimGeography] g਍ऀऀ漀渀 猀氀⸀䌀攀渀琀攀爀倀漀猀琀愀氀䌀漀搀攀 㴀 最⸀䐀椀最椀琀娀椀瀀䌀漀搀攀ഀ
		left join (਍ऀऀऀ匀䔀䰀䔀䌀吀 最⸀䐀椀最椀琀娀椀瀀䌀漀搀攀ഀ
			, g.DMACode਍ऀऀऀⰀ 挀⸀䌀攀渀琀攀爀一甀洀戀攀爀ഀ
			, DMAMarketRegion਍ऀऀऀⰀ 䐀䴀䄀䐀攀猀挀爀椀瀀琀椀漀渀ഀ
			FROM [dbo].[DimGeography] g਍ऀऀऀ椀渀渀攀爀 樀漀椀渀 嬀伀䐀匀崀⸀嬀䌀一䌀吀开䌀攀渀琀攀爀崀 挀ഀ
			on c.[PostalCode] = g.[DigitZipCode]਍ऀऀऀ眀栀攀爀攀 挀⸀椀猀愀挀琀椀瘀攀昀氀愀最㴀㄀⤀ 愀猀 挀渀ഀ
		on sl.[CenterNumber] = cn.[CenterNumber];਍ഀ
਍⼀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀唀倀䐀䄀吀䔀 刀䔀倀伀刀吀匀 䘀唀一一䔀䰀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⨀⼀ഀ
਍甀瀀搀愀琀攀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 猀攀琀 刀攀最椀漀渀 㴀 䘀甀渀渀攀氀⸀䌀攀渀琀攀爀刀攀最椀漀渀ഀ
where PostalCode is null or Region is null਍ഀ
update Reports.Funnel set MarketDMA = Funnel.CenterDMA਍眀栀攀爀攀 倀漀猀琀愀氀䌀漀搀攀 椀猀 渀甀氀氀 漀爀 䴀愀爀欀攀琀䐀䴀䄀 椀猀 渀甀氀氀ഀ
਍甀瀀搀愀琀攀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 猀攀琀 䌀攀渀琀攀爀刀攀最椀漀渀 㴀 䘀甀渀渀攀氀⸀刀攀最椀漀渀ഀ
where CenterRegion is null਍ഀ
update Reports.Funnel set CenterDMA = Funnel.MarketDMA਍眀栀攀爀攀 䌀攀渀琀攀爀䐀䴀䄀 椀猀 渀甀氀氀㬀ഀ
਍ഀ
With lead_temp as (਍ऀऀ匀䔀䰀䔀䌀吀 嬀匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀崀Ⰰ嬀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀ഀ
		FROM Reports.Funnel਍ऀऀ眀栀攀爀攀 昀甀渀渀攀氀猀琀攀瀀 㴀 ✀䰀攀愀搀✀ ⴀⴀ愀渀搀 嬀匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀崀 㴀✀　　儀昀㐀　　　　　㌀洀匀砀嘀䔀䄀唀✀ഀ
		)਍ऀऀⴀⴀ椀渀猀攀爀琀 椀渀琀漀 ⌀琀攀洀瀀ഀ
		select [SaleforceLeadID],[FunnelTransactionID] into #update_transaction from lead_temp;਍ഀ
update Reports.Funnel਍ऀ猀攀琀 嬀䰀攀愀搀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀 㴀 甀⸀嬀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀ഀ
FROM Reports.Funnel  r਍䤀一一䔀刀 䨀伀䤀一 ⌀甀瀀搀愀琀攀开琀爀愀渀猀愀挀琀椀漀渀 甀ഀ
on r.[SaleforceLeadID] = u.[SaleforceLeadID];਍ഀ
With bpcd as (਍ऀऀ匀䔀䰀䔀䌀吀 嬀瀀欀椀搀崀Ⰰ挀愀猀琀⠀嬀挀甀猀琀漀洀㌀崀 愀猀 瘀愀爀挀栀愀爀⤀ 挀甀猀琀漀洀㌀ഀ
		FROM [ODS].[BP_CallDetail]਍ऀऀ眀栀攀爀攀 挀甀猀琀漀洀㌀ 椀猀 渀漀琀 渀甀氀氀ഀ
		)਍ऀऀⴀⴀ椀渀猀攀爀琀 椀渀琀漀 ⌀琀攀洀瀀ഀ
		select [pkid],cast([custom3]  as varchar) custom3 into #pkid from bpcd;਍ഀ
਍ഀ
update Reports.Funnel਍ऀ猀攀琀 嬀䈀爀椀最栀琀倀愀琀琀攀爀渀䤀䐀崀 㴀 戀⸀瀀欀椀搀ഀ
FROM Reports.Funnel  r਍䤀一一䔀刀 䨀伀䤀一 ⌀瀀欀椀搀 戀ഀ
on r.[SalesForceTaskID] = b.custom3;਍ഀ
With bpcd_lead as (਍ऀऀ匀䔀䰀䔀䌀吀 嬀瀀欀椀搀崀Ⰰ挀愀猀琀⠀嬀挀甀猀琀漀洀㄀崀 愀猀 瘀愀爀挀栀愀爀⤀ 挀甀猀琀漀洀㄀Ⰰ嬀猀琀愀爀琀开琀椀洀攀崀Ⰰ刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 挀甀猀琀漀洀㄀ 伀刀䐀䔀刀 䈀夀 嬀猀琀愀爀琀开琀椀洀攀崀 䄀匀䌀⤀ 愀猀 爀漀眀渀甀洀ഀ
		FROM [ODS].[BP_CallDetail]਍ऀऀ眀栀攀爀攀 挀甀猀琀漀洀㌀ 椀猀 渀漀琀 渀甀氀氀ഀ
		)਍ऀऀⴀⴀ椀渀猀攀爀琀 椀渀琀漀 ⌀琀攀洀瀀ഀ
		select [pkid],cast([custom1]  as varchar) custom1,[start_time],rownum into #pkid_lead from bpcd_lead਍ऀऀ眀栀攀爀攀 爀漀眀渀甀洀 㴀 ㄀㬀ഀ
਍ഀ
update Reports.Funnel਍ऀ猀攀琀 嬀䈀爀椀最栀琀倀愀琀琀攀爀渀䤀䐀崀 㴀 戀⸀瀀欀椀搀ഀ
FROM Reports.Funnel  r਍䤀一一䔀刀 䨀伀䤀一 ⌀瀀欀椀搀开氀攀愀搀 戀ഀ
on r.[SaleforceLeadID] = b.custom1਍ഀ
਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䘀甀渀渀攀氀吀愀戀氀攀ഀ
	DROP TABLE #update_transaction਍    䐀刀伀倀 吀䄀䈀䰀䔀 ⌀瀀欀椀搀ഀ
	DROP TABLE #pkid_lead਍ഀ
END਍䜀伀ഀഀ
