/****** Object:  StoredProcedure [ODS].[sp_PopultateDaily_Factfunnel]    Script Date: 1/10/2022 10:03:12 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀伀䐀匀崀⸀嬀猀瀀开倀漀瀀甀氀琀愀琀攀䐀愀椀氀礀开䘀愀挀琀昀甀渀渀攀氀崀 䄀匀 戀攀最椀渀ഀഀ
਍䐀䔀䌀䰀䄀刀䔀 䀀䴀愀砀䴀漀搀椀昀椀攀搀䐀愀琀攀 䐀䄀吀䔀吀䤀䴀䔀㬀ഀഀ
SET @MaxModifiedDate = (select max(LastModifiedDate) from [hc-sqlpool-eim-prod-eus2].Reports.Funnel) ਍ऀഀഀ
CREATE Table  #AllLeads(਍䤀搀䰀攀愀搀 瘀愀爀挀栀愀爀⠀㔀　⤀ഀഀ
)਍ഀഀ
CREATE  Table #NewLeads(਍䤀搀䰀攀愀搀 瘀愀爀挀栀愀爀⠀㔀　⤀ഀഀ
)਍ഀഀ
਍䌀刀䔀䄀吀䔀 吀愀戀氀攀  ⌀唀瀀搀愀琀攀䰀攀愀搀猀⠀ഀഀ
IdLead varchar(50)਍⤀ഀഀ
਍椀渀猀攀爀琀 椀渀琀漀ഀഀ
	#AllLeads਍匀攀氀攀挀琀 猀氀⸀椀搀 昀爀漀洀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
where cast(sl.LastModifiedDate as date) >=  cast(@MaxModifiedDate as date)਍甀渀椀漀渀ഀഀ
Select st.whoid from [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Task st਍眀栀攀爀攀 挀愀猀琀⠀猀琀⸀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀 愀猀 搀愀琀攀⤀ 㸀㴀 挀愀猀琀⠀䀀䴀愀砀䴀漀搀椀昀椀攀搀䐀愀琀攀 愀猀 搀愀琀攀⤀ഀഀ
਍椀渀猀攀爀琀 椀渀琀漀ഀഀ
	#NewLeads ਍猀攀氀攀挀琀 䤀搀䰀攀愀搀 昀爀漀洀 ⌀䄀氀氀䰀攀愀搀猀ഀഀ
where IdLead  not in (select saleforceleadid from [hc-sqlpool-eim-prod-eus2].Reports.Funnel)਍ഀഀ
insert into਍ऀ⌀唀瀀搀愀琀攀䰀攀愀搀猀 ഀഀ
select IdLead from #AllLeads਍眀栀攀爀攀 䤀搀䰀攀愀搀  椀渀 ⠀猀攀氀攀挀琀 猀愀氀攀昀漀爀挀攀氀攀愀搀椀搀 昀爀漀洀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀⤀ഀഀ
	਍ऀഀഀ
---Create temp Tables਍ഀഀ
create Table #Contact਍ऀ⠀ഀഀ
	    id varchar(50),਍ऀ    吀愀猀欀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    QuotedPrice int,਍ऀ    匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
	    Whoid varchar(50),਍ऀ    刀攀猀甀氀琀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Action varchar(50),਍ऀ    䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		ActivityDateEST datetime,਍ऀ    䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
	    Contact bit,਍ऀ    䰀攀愀搀 戀椀琀Ⰰഀഀ
	    Appointment bit,਍ऀ    匀栀漀眀 戀椀琀Ⰰഀഀ
	    Sale bit,਍ऀ    一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    NewLeadToshow bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀愀氀攀 戀椀琀Ⰰഀഀ
		CreatedDate datetime,਍ऀऀ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀ഀഀ
	)਍ऀഀഀ
	create Table #Lead਍ऀ⠀ഀഀ
	    id varchar(50),਍ऀ    吀愀猀欀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    QuotedPrice int,਍ऀ    匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
	    Whoid varchar(50),਍ऀ    刀攀猀甀氀琀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Action varchar(50),਍ऀ    䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		ActivityDateEST datetime,਍ऀ    䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
	    Contact bit,਍ऀ    䰀攀愀搀 戀椀琀Ⰰഀഀ
	    Appointment bit,਍ऀ    匀栀漀眀 戀椀琀Ⰰഀഀ
	    Sale bit,਍ऀ    一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    NewLeadToshow bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀愀氀攀 戀椀琀Ⰰഀഀ
		CreatedDate datetime,਍ऀऀ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀ഀഀ
	)਍ऀഀഀ
	create Table #Appointment਍ऀ⠀ഀഀ
	    id varchar(50),਍ऀ    吀愀猀欀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    QuotedPrice int,਍ऀ    匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
	    Whoid varchar(50),਍ऀ    刀攀猀甀氀琀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Action varchar(50),਍ऀ    䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		ActivityDateEST datetime,਍ऀ    䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
	    Contact bit,਍ऀ    䰀攀愀搀 戀椀琀Ⰰഀഀ
	    Appointment bit,਍ऀ    匀栀漀眀 戀椀琀Ⰰഀഀ
	    Sale bit,਍ऀ    一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    NewLeadToshow bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀愀氀攀 戀椀琀Ⰰഀഀ
		CreatedDate datetime,਍ऀऀ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀ഀഀ
	)਍ऀഀഀ
	create Table #Show਍ऀ⠀ഀഀ
	    id varchar(50),਍ऀ    吀愀猀欀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    QuotedPrice int,਍ऀ    匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
	    Whoid varchar(50),਍ऀ    刀攀猀甀氀琀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Action varchar(50),਍ऀ    䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		ActivityDateEST datetime,਍ऀ    䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
	    Contact bit,਍ऀ    䰀攀愀搀 戀椀琀Ⰰഀഀ
	    Appointment bit,਍ऀ    匀栀漀眀 戀椀琀Ⰰഀഀ
	    Sale bit,਍ऀ    一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    NewLeadToshow bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀愀氀攀 戀椀琀Ⰰഀഀ
		CreatedDate datetime,਍ऀऀ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀ഀഀ
	)਍ऀഀഀ
	create Table #Sale਍ऀ⠀ഀഀ
	    id varchar(50),਍ऀ    吀愀猀欀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    QuotedPrice int,਍ऀ    匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
	    Whoid varchar(50),਍ऀ    刀攀猀甀氀琀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Action varchar(50),਍ऀ    䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		ActivityDateEST datetime,਍ऀ    䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
	    Contact bit,਍ऀ    䰀攀愀搀 戀椀琀Ⰰഀഀ
	    Appointment bit,਍ऀ    匀栀漀眀 戀椀琀Ⰰഀഀ
	    Sale bit,਍ऀ    一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    NewLeadToshow bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀愀氀攀 戀椀琀Ⰰഀഀ
		CreatedDate datetime,਍ऀऀ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀ഀഀ
	)਍ऀഀഀ
	create Table #FunnelTable਍ऀ⠀ഀഀ
	    id varchar(50),਍ऀ    吀愀猀欀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    QuotedPrice int,਍ऀ    匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
	    Whoid varchar(50),਍ऀ    刀攀猀甀氀琀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
	    Action varchar(50),਍ऀ    䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀 搀愀琀攀琀椀洀攀Ⰰഀഀ
		ActivityDateEST datetime,਍ऀ    䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
	    Contact bit,਍ऀ    䰀攀愀搀 戀椀琀Ⰰഀഀ
	    Appointment bit,਍ऀ    匀栀漀眀 戀椀琀Ⰰഀഀ
	    Sale bit,਍ऀ    一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀 戀椀琀Ⰰഀഀ
	    NewLeadToshow bit,਍ऀ    一攀眀䰀攀愀搀吀漀猀愀氀攀 戀椀琀Ⰰഀഀ
		CreatedDate datetime,਍ऀऀ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀ഀഀ
	)਍ऀഀഀ
	-----------------------------------------------------------------------------------------਍ऀⴀⴀⴀ䤀渀猀攀爀琀 椀渀琀漀 琀攀洀瀀 琀愀戀氀攀猀ഀഀ
	਍ऀⴀⴀⴀ䌀漀渀琀愀挀琀ഀഀ
	Insert into ਍ऀ    ⌀䌀漀渀琀愀挀琀ഀഀ
	Select ਍ऀ  猀氀⸀椀搀ഀഀ
	, null as TaskID਍ऀⰀ 渀甀氀氀 愀猀 儀甀漀琀攀搀倀爀椀挀攀ഀഀ
	, null as SaletypeDescription਍ऀⰀ 渀甀氀氀 愀猀 圀栀漀椀搀ഀഀ
	, null as Result਍ऀⰀ 渀甀氀氀 愀猀 䄀挀琀椀漀渀ഀഀ
	, sl.CreatedDate as ActivityDateUTC਍ऀⰀ 搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀  ഀഀ
	, 'Contact' as FunnelStep ਍ऀⰀ ㄀ 愀猀 䌀漀渀琀愀挀琀ഀഀ
	, 0 as lead਍ऀⰀ 　 愀猀 愀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
	, 0 as show਍ऀⰀ 　 愀猀 猀愀氀攀ഀഀ
	, 0 as NewLeadToappointment਍ऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀栀漀眀ഀഀ
	, 0 as NewLeadTosale਍ऀⰀ 猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀ഀഀ
	, sl.LastModifiedDate਍ऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
਍ऀഀഀ
	---Lead਍ऀ䔀堀䔀䌀    嬀伀䐀匀崀⸀嬀䰀攀愀搀嘀愀氀椀搀愀琀椀漀渀崀ഀഀ
	Insert into  #Lead਍ऀ匀攀氀攀挀琀 ഀഀ
	  sl.id਍ऀⰀ 渀甀氀氀 愀猀 吀愀猀欀䤀䐀ഀഀ
	, null as QuotedPrice਍ऀⰀ 渀甀氀氀 愀猀 匀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
	, null as Whoid਍ऀⰀ 渀甀氀氀 愀猀 刀攀猀甀氀琀ഀഀ
	, null as Action਍ऀⰀ 猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀ഀഀ
	, dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate) as ActivityDateEST  ਍ऀⰀ ✀䰀攀愀搀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀 ഀഀ
	, 0 as Contact਍ऀⰀ ㄀ 愀猀 氀攀愀搀ഀഀ
	, 0 as appointment਍ऀⰀ 　 愀猀 猀栀漀眀ഀഀ
	, 0 as sale਍ऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
	, 0 as NewLeadToshow਍ऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀愀氀攀ഀഀ
	, sl.CreatedDate਍ऀⰀ 猀氀⸀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀ഀഀ
	FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl਍ऀ䰀䔀䘀吀 䨀伀䤀一 伀䐀匀⸀⌀䤀猀䤀渀瘀愀氀椀搀 愀ഀഀ
	ON sl.id = a.Id਍ऀ眀栀攀爀攀 愀⸀䤀猀䤀渀瘀愀氀椀搀䰀攀愀搀 椀猀 渀甀氀氀㬀 ഀഀ
਍ഀഀ
	਍ऀⴀⴀ䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId ORDER BY activityDate ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 琀爀椀洀⠀愀挀琀椀漀渀开开挀⤀ 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀Ⰰ✀䈀攀 䈀愀挀欀✀⤀ 愀渀搀 爀攀猀甀氀琀开开挀 㰀㸀 ✀嘀漀椀搀✀ഀഀ
	)਍ऀऀ䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
	     #Appointment਍ऀऀ匀䔀䰀䔀䌀吀ഀഀ
		sl.id਍ऀऀⰀ 琀愀猀欀⸀吀愀猀欀椀搀ഀഀ
		, task.QuotedPrice਍ऀऀⰀ 䤀匀一唀䰀䰀⠀琀愀猀欀⸀猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ ✀唀渀欀渀漀眀渀✀⤀ 愀猀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
		, task.whoid਍ऀऀⰀ 琀愀猀欀⸀刀攀猀甀氀琀ഀഀ
		, task.Action਍ऀऀⰀ 一唀䰀䰀 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀ഀഀ
		, CASE WHEN (starttime__c not like '%NULL%') THEN cast(concat(left(task.ActivityDate,11),task.StartTime__c) as datetime)਍ऀऀऀ   䔀䰀匀䔀 琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀 ഀഀ
			   END AS ActivityDateEST਍ऀऀⰀ ✀䄀瀀瀀漀椀渀琀洀攀渀琀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀ഀഀ
		, 0 as Contact਍ऀऀⰀ 　 愀猀 䰀攀愀搀ഀഀ
		, 1 as Appointment਍ऀऀⰀ 　 愀猀 匀栀漀眀ഀഀ
		, 0 as Sale਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
		, 0 as NewLeadToshow਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀愀氀攀ഀഀ
		, task.ActivityDate as CreatedDate਍ऀऀⰀ 琀愀猀欀⸀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀ഀഀ
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl਍ऀऀ䤀一一䔀刀 䨀伀䤀一 琀愀猀欀 漀渀 椀猀渀甀氀氀⠀猀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀Ⰰ猀氀⸀椀搀⤀ 㴀 琀愀猀欀⸀眀栀漀椀搀 ⴀⴀ伀刀 猀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀 㴀 琀愀猀欀⸀圀栀漀䤀搀ഀഀ
		where task.rownum=1;਍ഀഀ
਍ऀഀഀ
	਍ऀⴀⴀⴀ匀栀漀眀ഀഀ
	਍ऀ圀椀琀栀 琀愀猀欀 愀猀 ⠀ഀഀ
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,LastModifiedDate,਍ऀ刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 戀⸀圀栀漀䤀搀 伀刀䐀䔀刀 䈀夀 愀挀琀椀瘀椀琀礀䐀愀琀攀 䄀匀䌀⤀ഀഀ
	AS RowNum਍ऀ䘀刀伀䴀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开吀愀猀欀崀 戀ഀഀ
	where action__c in ('Appointment','Be Back','In House') and (result__c='Show No Sale' or result__c='Show Sale') ਍ऀ⤀ഀഀ
		Insert into ਍ऀ    ⌀匀栀漀眀ഀഀ
		SELECT਍ऀऀ猀氀⸀椀搀ഀഀ
		, task.Taskid਍ऀऀⰀ 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀ഀഀ
		, ISNULL(task.saletypeDescription, 'Unknown') as saletypeDescription਍ऀऀⰀ 琀愀猀欀⸀眀栀漀椀搀ഀഀ
		, task.Result਍ऀऀⰀ 琀愀猀欀⸀䄀挀琀椀漀渀ഀഀ
		, NULL as ActivityDate਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 ⠀猀琀愀爀琀琀椀洀攀开开挀 渀漀琀 氀椀欀攀 ✀─一唀䰀䰀─✀⤀ 吀䠀䔀一 挀愀猀琀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 愀猀 搀愀琀攀琀椀洀攀⤀ഀഀ
			   ELSE task.ActivityDate ਍ऀऀऀ   䔀一䐀 䄀匀 䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀ഀഀ
		, 'Show' as FunnelStep਍ऀऀⰀ 　 愀猀 䌀漀渀琀愀挀琀ഀഀ
		, 0 as Lead਍ऀऀⰀ 　 愀猀 䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
		, 1 as Show਍ऀऀⰀ 　 愀猀 匀愀氀攀ഀഀ
		, 0 as NewLeadToappointment਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀栀漀眀ഀഀ
		, 0 as NewLeadTosale਍ऀऀⰀ 琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀 愀猀 䌀爀攀愀琀攀搀䐀愀琀攀ഀഀ
		, task.LastModifiedDate਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid  --OR sl.ConvertedContactId = task.WhoId਍ऀऀ眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀㬀ഀഀ
਍ऀഀഀ
	---Sale਍ऀഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY activityDate ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 愀挀琀椀漀渀开开挀 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䈀攀 䈀愀挀欀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀⤀ 愀渀搀 ⠀ 爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 匀愀氀攀✀⤀ ഀഀ
	)਍ऀऀ䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
	    #Sale਍ऀऀ匀䔀䰀䔀䌀吀ഀഀ
		sl.id਍ऀऀⰀ 琀愀猀欀⸀吀愀猀欀椀搀ഀഀ
		, task.QuotedPrice਍ऀऀⰀ 䤀匀一唀䰀䰀⠀琀愀猀欀⸀猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ ✀唀渀欀渀漀眀渀✀⤀ 愀猀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
		, task.whoid਍ऀऀⰀ 琀愀猀欀⸀刀攀猀甀氀琀ഀഀ
		, task.Action਍ऀऀⰀ 一唀䰀䰀 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀ഀഀ
		, CASE WHEN (starttime__c not like '%NULL%') THEN cast(concat(left(task.ActivityDate,11),task.StartTime__c) as datetime)਍ऀऀऀ   䔀䰀匀䔀 琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀 ഀഀ
			   END AS ActivityDateEST਍ऀऀⰀ ✀匀愀氀攀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀ഀഀ
		, 0 as Contact਍ऀऀⰀ 　 愀猀 䰀攀愀搀ഀഀ
		, 0 as Appointment਍ऀऀⰀ 　 愀猀 匀栀漀眀ഀഀ
		, 1 as Sale਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀愀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
		, 0 as NewLeadToshow਍ऀऀⰀ 　 愀猀 一攀眀䰀攀愀搀吀漀猀愀氀攀ഀഀ
		, task.ActivityDate as CreatedDate਍ऀऀⰀ 琀愀猀欀⸀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀ഀഀ
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl਍ऀऀ䤀一一䔀刀 䨀伀䤀一 琀愀猀欀 漀渀 椀猀渀甀氀氀⠀猀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀Ⰰ猀氀⸀椀搀⤀ 㴀 琀愀猀欀⸀眀栀漀椀搀 ⴀⴀ伀刀 猀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀 㴀 琀愀猀欀⸀圀栀漀䤀搀ഀഀ
		where task.rownum=1;਍ഀഀ
	---Temp਍ഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY activityDate ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 愀挀琀椀瘀椀琀礀搀愀琀攀 椀猀 渀漀琀 渀甀氀氀ഀഀ
	)਍ऀऀഀഀ
	--insert into #temp਍ऀ猀攀氀攀挀琀 刀漀眀一甀洀Ⰰ 琀愀猀欀椀搀 Ⰰ 眀栀漀椀搀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀 椀渀琀漀 ⌀琀攀洀瀀 昀爀漀洀 琀愀猀欀 ഀഀ
	where RowNum = 1;਍ऀഀഀ
	-------------------------------------------------------------------------------------------------਍ऀഀഀ
	---Union Tables਍ऀഀഀ
	Insert into ਍ऀ   ⌀䘀甀渀渀攀氀吀愀戀氀攀ഀഀ
	Select * ਍ऀ䘀刀伀䴀 ⌀䌀漀渀琀愀挀琀ഀഀ
	union all਍ऀ匀攀氀攀挀琀 ⨀ ഀഀ
	From #Lead਍ऀ唀渀椀漀渀 愀氀氀ഀഀ
	Select *਍ऀ䘀爀漀洀 ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
	Union all਍ऀ匀攀氀攀挀琀 ⨀ഀഀ
	From #Show਍ऀ唀渀椀漀渀 愀氀氀ഀഀ
	Select * ਍ऀ昀爀漀洀 ⌀匀愀氀攀㬀ഀഀ
਍ഀഀ
	with newlead as (਍ऀऀ匀䔀䰀䔀䌀吀ഀ
		id,਍ऀऀ䌀伀唀一吀⠀⨀⤀ 愀猀 渀甀洀戀攀爀ഀ
		FROM #funnelTable਍ऀऀ圀䠀䔀刀䔀 椀搀 渀漀琀 䤀一ഀ
		(਍ऀऀ匀䔀䰀䔀䌀吀 椀搀 䘀刀伀䴀 ⌀昀甀渀渀攀氀吀愀戀氀攀 圀䠀䔀刀䔀 䘀甀渀渀攀氀匀琀攀瀀 㴀 ✀䰀攀愀搀✀ഀ
		)਍ऀऀ䜀刀伀唀倀 䈀夀 椀搀ഀ
		HAVING COUNT(*) >1਍ऀ⤀ഀ
	select a.* into #temporal from #funnelTable a਍ऀ椀渀渀攀爀 樀漀椀渀 渀攀眀氀攀愀搀 氀ഀ
	on a.id = l.id਍ऀ眀栀攀爀攀 愀⸀昀甀渀渀攀氀猀琀攀瀀 㴀 ✀䌀漀渀琀愀挀琀✀ഀ
਍ऀ甀瀀搀愀琀攀  ⌀琀攀洀瀀漀爀愀氀 猀攀琀 䘀甀渀渀攀氀匀琀攀瀀 㴀 ✀䰀攀愀搀✀ഀ
਍ऀ椀渀猀攀爀琀 椀渀琀漀 ⌀昀甀渀渀攀氀琀愀戀氀攀ഀ
	select * from  #temporal਍ऀഀഀ
	update #funnelTable set NewLeadToappointment = 1਍ऀ眀栀攀爀攀 椀搀 椀渀 ⠀猀攀氀攀挀琀 椀搀 昀爀漀洀 ⌀昀甀渀渀攀氀吀愀戀氀攀 眀栀攀爀攀 昀甀渀渀攀氀猀琀攀瀀㴀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀⤀ ഀഀ
	and funnelstep='Lead'਍ऀഀഀ
	update #funnelTable set NewLeadToshow = 1਍ऀ眀栀攀爀攀 ⠀椀搀 椀渀 ⠀猀攀氀攀挀琀 椀搀 昀爀漀洀 ⌀昀甀渀渀攀氀吀愀戀氀攀 眀栀攀爀攀 昀甀渀渀攀氀猀琀攀瀀㴀✀匀栀漀眀✀⤀⤀ഀഀ
	and funnelstep='Lead'਍ऀഀഀ
	update #funnelTable set NewLeadTosale = 1਍ऀ眀栀攀爀攀 椀搀 椀渀 ⠀猀攀氀攀挀琀 椀搀 昀爀漀洀 ⌀昀甀渀渀攀氀吀愀戀氀攀 眀栀攀爀攀 昀甀渀渀攀氀猀琀攀瀀㴀✀匀愀氀攀✀⤀ഀഀ
	and funnelstep ='Lead'਍ഀഀ
	update #funnelTable ਍ऀऀ猀攀琀 吀愀猀欀䤀搀 㴀 琀⸀琀愀猀欀椀搀ഀഀ
	FROM #funnelTable f਍ऀ䤀一一䔀刀 䨀伀䤀一 ⌀琀攀洀瀀 琀ഀഀ
	on f.id = t.whoid਍ऀ眀栀攀爀攀 ⠀昀⸀昀甀渀渀攀氀猀琀攀瀀 㴀✀䰀攀愀搀✀ 漀爀 昀⸀昀甀渀渀攀氀猀琀攀瀀 㴀✀䌀漀渀琀愀挀琀✀⤀ഀഀ
਍ऀഀഀ
਍ऀ⼀⨀ഀഀ
	Select count(*) from #funnelTable਍ऀ圀䠀䔀刀䔀 䘀甀渀渀攀氀匀琀攀瀀 㴀  ✀匀栀漀眀✀ 漀爀 䘀甀渀渀攀氀匀琀攀瀀  㴀 ✀猀愀氀攀✀ഀഀ
	order by id desc, case When FunnelStep = 'Contact' then 1਍ऀ                圀栀攀渀 䘀甀渀渀攀氀匀琀攀瀀 㴀 ✀䰀攀愀搀✀ 琀栀攀渀 ㈀ഀഀ
	                when FunnelStep = 'Appointment' then 3਍ऀ                眀栀攀渀 䘀甀渀渀攀氀匀琀攀瀀 㴀 ✀匀栀漀眀✀ 琀栀攀渀 㐀ഀഀ
	                when FunnelStep = 'sale' then 5 END਍ऀ⨀⼀ഀഀ
	਍ऀഀഀ
	DROP TABLE #Appointment਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䌀漀渀琀愀挀琀ഀഀ
	DROP TABLE #Lead਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀匀愀氀攀ഀഀ
	DROP TABLE #Show਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 伀䐀匀⸀⌀䤀猀䤀渀瘀愀氀椀搀ഀഀ
	DROP TABLE #temp਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀琀攀洀瀀漀爀愀氀ഀഀ
	਍ऀഀഀ
਍ऀഀഀ
	਍ऀ䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
		     Reports.Funnel ([ContactID]਍ऀऀ  Ⰰ嬀匀愀氀攀猀䘀漀爀挀攀吀愀猀欀䤀䐀崀ഀഀ
		  ,[BrightPatternID]਍ऀऀ  Ⰰ嬀䰀攀愀搀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀ഀഀ
		  ,[SaleforceLeadID]਍ऀऀ  Ⰰ嬀䌀漀洀瀀愀渀礀崀ഀഀ
		  ,[FunnelStep]਍ऀऀ  Ⰰ嬀䘀甀渀渀攀氀猀琀愀琀甀猀崀ഀഀ
		  ,[OriginalGCLID]਍ऀऀ  Ⰰ嬀䰀攀愀搀䌀爀攀愀琀攀䐀愀琀攀唀吀䌀崀ഀഀ
		  ,[LeadCreateDateEST]਍ऀऀ  Ⰰ嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀崀ഀഀ
		  ,[ActivityDateEST]਍ऀऀ  Ⰰ嬀刀攀瀀漀爀琀䌀爀攀愀琀攀䐀愀琀攀崀ഀഀ
		  ,[Date]਍ऀऀ  Ⰰ嬀吀椀洀攀崀ഀഀ
		  ,[DayPart]਍ऀऀ  Ⰰ嬀䠀漀甀爀崀ഀഀ
		  ,[Minute]਍ऀऀ  Ⰰ嬀匀攀挀漀渀搀猀崀ഀഀ
		  ,[OriginalContactType]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀匀漀甀爀挀攀挀漀搀攀崀ഀഀ
		  ,[OriginalDialedNumber]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀ഀഀ
		  ,[OriginalCampaignAgency]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀ഀഀ
		  ,[OriginalCampaignName]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀ഀഀ
		  ,[OriginalCampaignLanguage]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀ഀഀ
		  ,[OriginalCampaignStartDate]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀ഀഀ
		  ,[OriginalCampaignStatus]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀匀漀甀爀挀攀挀漀搀攀崀ഀഀ
		  ,[RecentDialedNumber]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀ഀഀ
		  ,[RecentCampaignAgency]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀ഀഀ
		  ,[RecentCampaignName]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀ഀഀ
		  ,[RecentCampaignLanguage]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀ഀഀ
		  ,[RecentCampaignStartDate]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀ഀഀ
		  ,[RecentCampaignStatus]਍ऀऀ  Ⰰ嬀倀漀猀琀愀氀䌀漀搀攀崀ഀഀ
		  ,[Region]਍ऀऀ  Ⰰ嬀䴀愀爀欀攀琀䐀䴀䄀崀ഀഀ
		  ,[CenterName]਍ऀऀ  Ⰰ嬀䌀攀渀琀攀爀刀攀最椀漀渀崀ഀഀ
		  ,[CenterDMA]਍ऀऀ  Ⰰ嬀䌀攀渀琀攀爀吀礀瀀攀崀ഀഀ
		  ,[CenterOwner]਍ऀऀ  Ⰰ嬀䰀愀渀最甀愀最攀崀ഀഀ
		  ,[Gender]਍ऀऀ  Ⰰ嬀䰀愀猀琀一愀洀攀崀ഀഀ
		  ,[FirstName]਍ऀऀ  Ⰰ嬀倀栀漀渀攀崀ഀഀ
		  ,[MobilePhone]਍ऀऀ  Ⰰ嬀䔀洀愀椀氀崀ഀഀ
		  ,[Ethnicity]਍ऀऀ  Ⰰ嬀䠀愀椀爀䰀漀猀猀䌀漀渀搀椀琀椀漀渀崀ഀഀ
		  ,[MaritalStatus]਍ऀऀ  Ⰰ嬀伀挀挀甀瀀愀琀椀漀渀崀ഀഀ
		  ,[BirthYear]਍ऀऀ  Ⰰ嬀䄀最攀䈀愀渀搀猀崀ഀഀ
		  ,[NewContact]਍ऀऀ  Ⰰ嬀一攀眀䰀攀愀搀崀ഀഀ
		  ,[NewAppointment]਍ऀऀ  Ⰰ嬀一攀眀匀栀漀眀崀ഀഀ
		  ,[NewSale]਍ऀऀ  Ⰰ嬀一攀眀䰀攀愀搀吀漀䄀瀀瀀漀椀渀琀洀攀渀琀崀ഀഀ
		  ,[NewLeadToShow]਍ऀऀ  Ⰰ嬀一攀眀䰀攀愀搀吀漀匀愀氀攀崀ഀഀ
		  ,[QuotedPrice]਍ऀऀ  Ⰰ嬀倀爀椀洀愀爀礀匀漀氀甀琀椀漀渀崀ഀഀ
		  ,[DoNotContactFlag]਍ऀऀ  Ⰰ嬀䐀漀一漀琀䌀愀氀氀䘀氀愀最崀ഀഀ
		  ,[DoNotSMSFlag]਍ऀऀ  Ⰰ嬀䐀漀一漀琀䔀洀愀椀氀䘀氀愀最崀ഀഀ
		  ,[DoNotMailFlag]਍ऀऀ  Ⰰ嬀䤀猀䐀攀氀攀琀攀搀崀ഀഀ
		  ,[LastModifiedDate])਍ഀഀ
		SELECT ਍ऀऀ 一唀䰀䰀 愀猀 ✀䌀漀渀琀愀挀琀䤀䐀✀ഀഀ
		, ft.Taskid as SalesForceTaskID਍ऀऀⰀ一唀䰀䰀 愀猀 嬀䈀爀椀最栀琀倀愀琀琀攀爀渀䤀䐀崀ഀഀ
		,NULL AS LeadFunnelTransactionID਍ऀऀⰀ 猀氀⸀䤀搀 愀猀 匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀ഀഀ
		, CASE WHEN(cty.CenterTypeDescription = 'Hans Wiemann') THEN 'Hans Wiemann'਍ऀऀऀ   䔀䰀匀䔀 ✀䠀愀椀爀 䌀氀甀戀✀ഀഀ
			   END AS Company਍ऀऀⰀ 昀琀⸀䘀甀渀渀攀氀匀琀攀瀀 ഀഀ
		, sl.Status as FunnelStatus਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䠀䌀唀䤀䐀ഀഀ
		--, NULL AS OriginalGCID਍ऀऀⰀ 猀氀⸀䜀䌀䰀䤀䐀开开挀 愀猀 伀爀椀最椀渀愀氀䜀䌀䰀䤀䐀ഀഀ
		--, NULL AS OriginalMSCLKID਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䘀䈀䌀䰀䤀䐀ഀഀ
		--, NULL AS OriginalHashedEmail਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䠀愀猀栀攀搀倀栀漀渀攀ഀഀ
		--, NULL AS RecentHCUID਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䜀䌀䤀䐀ഀഀ
		--, NULL AS RecentGCLID਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䴀匀䌀䰀䬀䤀䐀ഀഀ
		--, NULL AS RecentFBCLID਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䠀愀猀栀攀搀䔀洀愀椀氀ഀഀ
		--, NULL AS RecentHashedPhone਍ऀऀⰀ 猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀 愀猀 䰀攀愀搀䌀爀攀愀琀攀䐀愀琀攀唀吀䌀ഀഀ
		, dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate) as LeadCreateDateEST਍ऀऀⰀ 昀琀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀 愀猀 䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀ഀഀ
		, ft.ActivityDateEST as ActivityDateEST਍ऀऀⰀ 猀氀⸀嬀刀攀瀀漀爀琀䌀爀攀愀琀攀䐀愀琀攀开开挀崀 愀猀 刀攀瀀漀爀琀䌀爀攀愀琀攀䐀愀琀攀ഀഀ
		, cast(ft.ActivityDateEST as date) as Date਍ऀऀⰀ 挀愀猀琀⠀昀琀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 愀猀 琀椀洀攀⤀ 愀猀 琀椀洀攀ഀഀ
		, dtd.DayPart as DayPart਍ऀऀⰀ 搀琀搀⸀嬀䠀漀甀爀崀 愀猀 䠀漀甀爀ഀഀ
		, dtd.[minute] as Minute਍ऀऀⰀ 搀琀搀⸀嬀匀攀挀漀渀搀崀 愀猀 匀攀挀漀渀搀猀ഀഀ
		, sl.LeadSource AS OriginalContactType਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀漀渀琀愀挀琀䜀爀漀甀瀀ഀഀ
		--, null as SystemOfOrigin਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 䰀攀愀搀匀琀愀琀攀ഀഀ
		, sl.Source_Code_Legacy__c as OriginalSourcecode਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀匀漀甀爀挀攀挀漀搀攀一愀洀攀ഀഀ
		--, NULL AS OriginalSourcecodeType਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀匀漀甀爀攀挀攀挀漀搀攀䜀爀漀甀瀀ഀഀ
		, CASE WHEN soc.SourceCode_L__c like '%MP'਍ऀऀऀऀ吀䠀䔀一 猀漀挀⸀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀开开挀ഀഀ
			ELSE਍ऀऀऀऀ猀漀挀⸀吀漀氀氀䘀爀攀攀一愀洀攀开开挀ഀഀ
		  END AS OriginalDialedNumber਍ऀऀⰀ 匀唀䈀匀吀刀䤀一䜀⠀猀氀⸀倀栀漀渀攀䄀戀爀开开挀Ⰰ 　Ⰰ㐀 ⤀ 䄀匀 伀爀椀最椀渀愀氀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀ഀഀ
		, soc.[Type] as OriginalCampaignAgency਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀倀甀爀瀀漀猀攀ഀഀ
		--, NULL AS OriginalCampaignMethod਍ऀऀⰀ 猀漀挀⸀䌀栀愀渀渀攀氀开开挀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀ഀഀ
		--, NULL AS OriginalCampaignMedium਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀ഀഀ
		--, NULL AS OriginalCampaignContentType਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀漀洀瀀愀椀最渀䌀漀渀琀攀渀琀ഀഀ
		--, NULL AS OriginalCampaignType਍ऀऀⰀ 猀漀挀⸀一愀洀攀  愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀一愀洀攀ഀഀ
		--, NULL AS OriginalCampaignTactic਍ऀऀⰀ 猀漀挀⸀䘀漀爀洀愀琀开开挀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀ഀഀ
		--, NULL AS OriginalCampaignPlacement਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀ഀഀ
		--, NULL AS OriginalCampaignLocation਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀吀礀瀀攀ഀഀ
		--, NULL AS OriginalCampaignBudgetName਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀刀攀最椀漀渀ഀഀ
		--, NULL AS OriginalCampaignMarketDMA਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䄀甀搀椀攀渀挀攀ഀഀ
		, soc.Language__c as OriginalCampaignLanguage਍ऀऀⰀ 猀漀挀⸀倀爀漀洀漀䌀漀搀攀一愀洀攀开开挀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀ഀഀ
		--, NULL AS OriginalCampaignLandingPageURL਍ऀऀⰀ 猀漀挀⸀匀琀愀爀琀䐀愀琀攀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀ഀഀ
		, soc.EndDate as OriginalCampaignEndDate਍ऀऀⰀ 猀漀挀⸀匀琀愀琀甀猀 愀猀 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀ഀഀ
		, sl.RecentSourceCode__c as RecentSourceCode਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀匀漀甀爀挀攀挀漀搀攀一愀洀攀ഀഀ
		--, NULL AS RecentSourcecodeType਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀匀漀甀爀攀挀攀挀漀搀攀䜀爀漀甀瀀ഀഀ
		, CASE WHEN src.SourceCode_L__c like '%MP'਍ऀऀऀऀ吀䠀䔀一 猀爀挀⸀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀开开挀ഀഀ
			ELSE਍ऀऀऀऀ猀爀挀⸀吀漀氀氀䘀爀攀攀一愀洀攀开开挀ഀഀ
		  END AS OriginalDialedNumber਍ऀऀⰀ 匀唀䈀匀吀刀䤀一䜀⠀猀氀⸀倀栀漀渀攀䄀戀爀开开挀Ⰰ 　Ⰰ㐀 ⤀ 愀猀 刀攀挀攀渀琀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀ഀഀ
		, src.[Type] as RecentCampaignAgency਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀倀甀爀瀀漀猀攀ഀഀ
		--, NULL AS RecentlCampaignMethod਍ऀऀⰀ 猀爀挀⸀䌀栀愀渀渀攀氀开开挀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀ഀഀ
		--, NULL AS RecentCampaignMedium਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀匀漀甀爀挀攀ഀഀ
		--, NULL AS RecentCampaignContentType਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀漀洀瀀愀椀最渀䌀漀渀琀攀渀琀ഀഀ
		--, NULL AS RecentCampaignType਍ऀऀⰀ 猀爀挀⸀一愀洀攀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀一愀洀攀ഀഀ
		--, NULL AS RecentCampaignTactic਍ऀऀⰀ 猀爀挀⸀䘀漀爀洀愀琀开开挀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀ഀഀ
		--, NULL AS RecentCampaignPlacement਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䌀漀洀瀀愀渀礀ഀഀ
		--, NULL AS RecentCampaignLocation਍ऀऀⴀⴀⰀ 一唀䰀䰀 䄀匀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䈀甀搀最攀琀吀礀瀀攀ഀഀ
		--, NULL AS RecentCampaignBudgetName਍ऀऀⴀⴀⰀ 一唀䰀䰀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀刀攀最椀漀渀ഀഀ
		--, NULL as RecentCampaignMarketDMA਍ऀऀⴀⴀⰀ 一唀䰀䰀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䄀甀搀椀攀渀挀攀ഀഀ
		, src.Language__c as RecentCampaignLanguage਍ऀऀⰀ 猀爀挀⸀倀爀漀洀漀䌀漀搀攀一愀洀攀开开挀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀ഀഀ
		--, NULL as RecentCampaignLandingPageURL਍ऀऀⰀ 猀爀挀⸀匀琀愀爀琀䐀愀琀攀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀匀琀愀爀琀䐀愀琀攀ഀഀ
		, src.EndDate as RecentCampaignEndDate਍ऀऀⰀ 猀爀挀⸀匀琀愀琀甀猀 愀猀 刀攀挀攀渀琀䌀愀洀瀀愀椀最渀匀琀愀琀甀猀ഀഀ
		--, NULL as HowDidYouHearAboutUs਍ऀऀⰀ 猀氀⸀倀漀猀琀愀氀䌀漀搀攀 愀猀 倀漀猀琀愀氀䌀漀搀攀 ഀഀ
		--, NULL as DistanceToAssignedCenter਍ऀऀⴀⴀⰀ 一唀䰀䰀 愀猀 䐀椀猀琀愀渀挀攀吀漀一攀愀爀攀猀琀䌀攀渀琀攀爀ഀഀ
		, g.DMAMarketRegion as Region ਍ऀऀⰀ 最⸀䐀䴀䄀䐀攀猀挀爀椀瀀琀椀漀渀 愀猀 䴀愀爀欀攀琀䐀䴀䄀ഀഀ
		, ctr.CenterDescriptionFullCalc as CenterName਍ऀऀⰀ 挀渀⸀䐀䴀䄀䴀愀爀欀攀琀刀攀最椀漀渀 愀猀 䌀攀渀琀攀爀刀攀最椀漀渀ഀഀ
		, cn.DMADescription as CenterDMA਍ऀऀⰀ 挀琀爀⸀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 愀猀 䌀攀渀琀攀爀吀礀瀀攀ഀഀ
		, ctr.CenterOwnershipDescription as CenterOwner਍ऀऀⰀ 猀氀⸀䰀愀渀最甀愀最攀开开挀 愀猀 䰀愀渀最甀愀最攀ഀഀ
		, sl.Gender__c as Gender਍ऀऀⰀ 猀氀⸀䰀愀猀琀一愀洀攀 ഀഀ
		, sl.FirstName ਍ऀऀⰀ 刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀猀氀⸀嬀倀栀漀渀攀崀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ 愀猀 ✀倀栀漀渀攀✀ഀഀ
		, REPLACE(REPLACE(REPLACE(REPLACE(sl.[MobilePhone],'(',''),')',''),' ',''),'-','') AS 'MobilePhone'਍ऀऀⰀ 猀氀⸀䔀洀愀椀氀 ഀഀ
		, sl.Ethnicity__c as Ethnicity਍ऀऀⰀ 䤀猀渀甀氀氀⠀猀氀⸀一漀爀眀漀漀搀匀挀愀氀攀开开挀Ⰰ猀氀⸀䰀甀搀眀椀最匀挀愀氀攀开开挀⤀ 愀猀 䠀愀椀爀䰀漀猀猀䌀漀渀搀椀琀椀漀渀ഀഀ
		, sl.MaritalStatus__c as MaritalStatus਍ऀऀⰀ 猀氀⸀伀挀挀甀瀀愀琀椀漀渀开开挀 愀猀 伀挀挀甀瀀愀琀椀漀渀ഀഀ
		--, NULL as HHIncome਍ऀऀⰀ 夀䔀䄀刀⠀猀氀⸀䈀椀爀琀栀搀愀礀开开挀⤀ 愀猀 䈀椀爀琀栀夀攀愀爀ഀഀ
		, CASE WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 1 AND 17) THEN 'Under 18'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 ㄀㠀 䄀一䐀 ㈀㐀⤀ 吀䠀䔀一 ✀㄀㠀 琀漀 ㈀㐀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 25 AND 34) THEN '25 to 34'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 ㌀㔀 䄀一䐀 㐀㐀⤀ 吀䠀䔀一 ✀㌀㔀 琀漀 㐀㐀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 45 AND 54) THEN '45 to 54'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 㔀㔀 䄀一䐀 㘀㐀⤀ 吀䠀䔀一 ✀㔀㔀 琀漀 㘀㐀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 65 AND 120) THEN '65 +'਍ऀऀऀऀ 䔀䰀匀䔀 ✀唀渀欀渀漀眀渀✀ഀഀ
				END AS AgeBands਍ऀऀⰀ 昀琀⸀䌀漀渀琀愀挀琀 愀猀 一攀眀䌀漀渀琀愀挀琀ഀഀ
		, ft.Lead as NewLead਍ऀऀⰀ 昀琀⸀䄀瀀瀀漀椀渀琀洀攀渀琀 愀猀 一攀眀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
		, ft.Show as NewShow਍ऀऀⰀ 昀琀⸀匀愀氀攀 愀猀 一攀眀匀愀氀攀ഀഀ
		, ft.NewLeadToappointment as NewLeadToAppointment਍ऀऀⰀ 昀琀⸀一攀眀䰀攀愀搀吀漀猀栀漀眀 愀猀 一攀眀䰀攀愀搀吀漀匀栀漀眀ഀഀ
		, ft.NewLeadTosale as NewLeadToSale਍ऀऀⰀ 昀琀⸀儀甀漀琀攀搀倀爀椀挀攀 愀猀 儀甀漀琀攀搀倀爀椀挀攀ഀഀ
		--, null as ContractedPrice਍ऀऀⴀⴀⰀ 一甀氀氀 愀猀 一攀琀刀攀瘀攀渀甀攀ഀഀ
		--, Null as LifetimeRevenue਍ऀऀⰀ 昀琀⸀猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 愀猀 倀爀椀洀愀爀礀匀漀氀甀琀椀漀渀ഀഀ
		--, Null as Solution਍ऀऀⴀⴀⰀ 一甀氀氀 愀猀 匀攀爀瘀椀挀攀ഀഀ
		, case when sl.DoNotContact__c = 1 then 'Y' else 'N' end as DoNotContactFlag਍ऀऀⰀ 挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀䌀愀氀氀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀 愀猀 䐀漀一漀琀䌀愀氀氀䘀氀愀最ഀഀ
		, case when sl.DoNotText__c = 1 then 'Y' else 'N' end as DoNotSMSFlag਍ऀऀⰀ 挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀䔀洀愀椀氀开开挀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀 愀猀 䐀漀一漀琀䔀洀愀椀氀䘀氀愀最ഀഀ
		, case when sl.DoNotMail__c = 1 then 'Y' else 'N' end as DoNotMailFlag਍ऀऀⰀ 猀氀⸀䤀猀䐀攀氀攀琀攀搀 愀猀 ✀䤀猀䐀攀氀攀琀攀搀✀ഀഀ
		, ft.LastModifiedDate਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀 ഀഀ
		left join [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Campaign soc਍ऀऀ漀渀 猀氀⸀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀䐀开开挀 㴀 猀漀挀⸀䤀搀 ഀഀ
		left join [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Campaign src਍ऀऀ漀渀 猀氀⸀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀开开挀 㴀 猀爀挀⸀䤀搀 ഀഀ
		left join (਍ऀऀऀ匀攀氀攀挀琀 挀挀⸀䌀攀渀琀攀爀䤀䐀ഀഀ
			, cc.CenterDescriptionFullCalc ਍ऀऀऀⰀ 挀挀琀⸀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 ഀഀ
			, cco.CenterOwnershipDescription ਍ऀऀऀ昀爀漀洀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀䌀一䌀吀开䌀攀渀琀攀爀 挀挀 ഀഀ
			inner join [hc-sqlpool-eim-prod-eus2].ODS.CNCT_CenterOwnership cco ਍ऀऀऀ漀渀 挀挀⸀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䤀䐀 㴀 挀挀漀⸀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䤀䐀ഀഀ
			INNER join [hc-sqlpool-eim-prod-eus2].ODS.CNCT_CenterType cct ਍ऀऀऀ漀渀 挀挀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀 㴀 挀挀琀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀 ഀഀ
			where cc.isactiveflag = 1਍ऀऀ⤀ 愀猀 挀琀爀ഀഀ
		on ISNULL(sl.CenterNumber__c, sl.CenterID__c) = ctr.CenterID਍ऀऀ椀渀渀攀爀 樀漀椀渀 ⌀䘀甀渀渀攀氀吀愀戀氀攀 昀琀ഀഀ
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
	where sl.Id in (Select * from #NewLeads) ਍ഀഀ
਍ऀ甀瀀搀愀琀攀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 ഀഀ
	set [ContactID] = NULL਍ऀऀ  Ⰰ嬀匀愀氀攀猀䘀漀爀挀攀吀愀猀欀䤀䐀崀 㴀 昀琀⸀吀愀猀欀椀搀ഀഀ
		  ,[BrightPatternID] = NULL਍ऀऀ  Ⰰ嬀䰀攀愀搀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀 㴀 一唀䰀䰀ഀഀ
		  ,[SaleforceLeadID] = sl.Id਍ऀऀ  Ⰰ嬀䌀漀洀瀀愀渀礀崀 㴀 䌀䄀匀䔀 圀䠀䔀一⠀挀琀礀⸀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀 㴀 ✀䠀愀渀猀 圀椀攀洀愀渀渀✀⤀ 吀䠀䔀一 ✀䠀愀渀猀 圀椀攀洀愀渀渀✀ഀഀ
					   ELSE 'Hair Club' end਍ऀऀ  Ⰰ嬀䘀甀渀渀攀氀匀琀攀瀀崀 㴀 昀琀⸀䘀甀渀渀攀氀匀琀攀瀀ഀഀ
		  ,[Funnelstatus] = sl.Status਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䜀䌀䰀䤀䐀崀 㴀 猀氀⸀䜀䌀䰀䤀䐀开开挀ഀഀ
		  ,[OriginalContactType] = sl.LeadSource਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀匀漀甀爀挀攀挀漀搀攀崀 㴀 猀氀⸀匀漀甀爀挀攀开䌀漀搀攀开䰀攀最愀挀礀开开挀ഀഀ
		  ,[OriginalDialedNumber] = CASE WHEN soc.SourceCode_L__c like '%MP'਍ऀऀऀऀऀऀऀऀऀ吀䠀䔀一 猀漀挀⸀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀开开挀ഀഀ
									ELSE soc.TollFreeName__c end਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀 㴀 匀唀䈀匀吀刀䤀一䜀⠀猀氀⸀倀栀漀渀攀䄀戀爀开开挀Ⰰ 　Ⰰ㐀 ⤀ഀഀ
		  ,[OriginalCampaignAgency] = soc.[Type]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 㴀 猀漀挀⸀䌀栀愀渀渀攀氀开开挀ഀഀ
		  ,[OriginalCampaignName] = soc.Name਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 猀漀挀⸀䘀漀爀洀愀琀开开挀ഀഀ
		  ,[OriginalCampaignLanguage] = soc.Language__c਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 㴀 猀漀挀⸀倀爀漀洀漀䌀漀搀攀一愀洀攀开开挀ഀഀ
		  ,[OriginalCampaignStartDate] = soc.StartDate਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 㴀 猀漀挀⸀䔀渀搀䐀愀琀攀ഀഀ
		  ,[OriginalCampaignStatus] = soc.Status਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀匀漀甀爀挀攀挀漀搀攀崀 㴀 猀氀⸀刀攀挀攀渀琀匀漀甀爀挀攀䌀漀搀攀开开挀ഀഀ
		  ,[RecentDialedNumber] = CASE WHEN src.SourceCode_L__c like '%MP'਍ऀऀऀऀऀऀऀऀ  吀䠀䔀一 猀爀挀⸀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀开开挀ഀഀ
								  ELSE src.TollFreeName__c end਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀 㴀 匀唀䈀匀吀刀䤀一䜀⠀猀氀⸀倀栀漀渀攀䄀戀爀开开挀Ⰰ 　Ⰰ㐀 ⤀ഀഀ
		  ,[RecentCampaignAgency] = src.[Type]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 㴀 猀爀挀⸀䌀栀愀渀渀攀氀开开挀ഀഀ
		  ,[RecentCampaignName] = src.Name਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 猀爀挀⸀䘀漀爀洀愀琀开开挀ഀഀ
		  ,[RecentCampaignLanguage] = src.Language__c਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 㴀 猀爀挀⸀倀爀漀洀漀䌀漀搀攀一愀洀攀开开挀ഀഀ
		  ,[RecentCampaignStartDate] = src.StartDate਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 㴀 猀爀挀⸀䔀渀搀䐀愀琀攀ഀഀ
		  ,[RecentCampaignStatus] = src.Status਍ऀऀ  Ⰰ嬀倀漀猀琀愀氀䌀漀搀攀崀 㴀 猀氀⸀倀漀猀琀愀氀䌀漀搀攀ഀഀ
		  ,[Region] = g.DMAMarketRegion਍ऀऀ  Ⰰ嬀䴀愀爀欀攀琀䐀䴀䄀崀 㴀 最⸀䐀䴀䄀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
		  ,[CenterName] = ctr.CenterDescriptionFullCalc਍ऀऀ  Ⰰ嬀䌀攀渀琀攀爀刀攀最椀漀渀崀 㴀 挀渀⸀䐀䴀䄀䴀愀爀欀攀琀刀攀最椀漀渀ഀഀ
		  ,[CenterDMA] = cn.DMADescription਍ऀऀ  Ⰰ嬀䌀攀渀琀攀爀吀礀瀀攀崀 㴀 挀琀爀⸀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
		  ,[CenterOwner] = ctr.CenterOwnershipDescription਍ऀऀ  Ⰰ嬀䰀愀渀最甀愀最攀崀 㴀 猀氀⸀䰀愀渀最甀愀最攀开开挀ഀഀ
		  ,[Gender] = sl.Gender__c ਍ऀऀ  Ⰰ嬀䰀愀猀琀一愀洀攀崀 㴀 猀氀⸀䰀愀猀琀一愀洀攀 ഀഀ
		  ,[FirstName] = sl.FirstName ਍ऀऀ  Ⰰ嬀倀栀漀渀攀崀 㴀 刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀猀氀⸀嬀倀栀漀渀攀崀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ഀഀ
		  ,[MobilePhone] = REPLACE(REPLACE(REPLACE(REPLACE(sl.[MobilePhone],'(',''),')',''),' ',''),'-','')਍ऀऀ  Ⰰ嬀䔀洀愀椀氀崀 㴀 猀氀⸀䔀洀愀椀氀 ഀഀ
		  ,[Ethnicity] = sl.Ethnicity__c਍ऀऀ  Ⰰ嬀䠀愀椀爀䰀漀猀猀䌀漀渀搀椀琀椀漀渀崀 㴀 䤀猀渀甀氀氀⠀猀氀⸀一漀爀眀漀漀搀匀挀愀氀攀开开挀Ⰰ猀氀⸀䰀甀搀眀椀最匀挀愀氀攀开开挀⤀ഀഀ
		  ,[MaritalStatus] = sl.MaritalStatus__c਍ऀऀ  Ⰰ嬀伀挀挀甀瀀愀琀椀漀渀崀 㴀 猀氀⸀伀挀挀甀瀀愀琀椀漀渀开开挀ഀഀ
		  ,[BirthYear] = YEAR(sl.Birthday__c)਍ऀऀ  Ⰰ嬀䄀最攀䈀愀渀搀猀崀 㴀 䌀䄀匀䔀 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 ㄀ 䄀一䐀 ㄀㜀⤀ 吀䠀䔀一 ✀唀渀搀攀爀 ㄀㠀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 18 AND 24) THEN '18 to 24'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 ㈀㔀 䄀一䐀 ㌀㐀⤀ 吀䠀䔀一 ✀㈀㔀 琀漀 ㌀㐀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 35 AND 44) THEN '35 to 44'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 㐀㔀 䄀一䐀 㔀㐀⤀ 吀䠀䔀一 ✀㐀㔀 琀漀 㔀㐀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 55 AND 64) THEN '55 to 64'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 㘀㔀 䄀一䐀 ㄀㈀　⤀ 吀䠀䔀一 ✀㘀㔀 ⬀✀ഀഀ
				 ELSE 'Unknown' end਍ऀऀ  Ⰰ嬀一攀眀䌀漀渀琀愀挀琀崀 㴀 昀琀⸀䌀漀渀琀愀挀琀ഀഀ
		  ,[NewLead] = ft.Lead਍ऀऀ  Ⰰ嬀一攀眀䄀瀀瀀漀椀渀琀洀攀渀琀崀 㴀 昀琀⸀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
		  ,[NewShow] = ft.Show਍ऀऀ  Ⰰ嬀一攀眀匀愀氀攀崀 㴀 昀琀⸀匀愀氀攀ഀഀ
		  ,[NewLeadToAppointment] = ft.NewLeadToappointment਍ऀऀ  Ⰰ嬀一攀眀䰀攀愀搀吀漀匀栀漀眀崀 㴀 昀琀⸀一攀眀䰀攀愀搀吀漀猀栀漀眀ഀഀ
		  ,[NewLeadToSale] = ft.NewLeadTosale਍ऀऀ  Ⰰ嬀儀甀漀琀攀搀倀爀椀挀攀崀 㴀 昀琀⸀儀甀漀琀攀搀倀爀椀挀攀ഀഀ
		  ,[PrimarySolution] = ft.saletypeDescription਍ऀऀ  Ⰰ嬀䐀漀一漀琀䌀漀渀琀愀挀琀䘀氀愀最崀 㴀  挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀䌀漀渀琀愀挀琀开开挀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀ഀഀ
		  ,[DoNotCallFlag] =  case when sl.DoNotCall = 1 then 'Y' else 'N' end਍ऀऀ  Ⰰ嬀䐀漀一漀琀匀䴀匀䘀氀愀最崀 㴀  挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀吀攀砀琀开开挀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀ഀഀ
		  ,[DoNotEmailFlag] =  case when sl.DoNotEmail__c = 1 then 'Y' else 'N' end਍ऀऀ  Ⰰ嬀䐀漀一漀琀䴀愀椀氀䘀氀愀最崀 㴀  挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀䴀愀椀氀开开挀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀ഀഀ
		  ,[IsDeleted] = sl.IsDeleted਍ऀऀ  Ⰰ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 㴀 昀琀⸀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀ഀഀ
	FROM Reports.Funnel  r਍ऀ椀渀渀攀爀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
	on r.saleforceleadid = sl.id਍ऀ氀攀昀琀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䌀愀洀瀀愀椀最渀 猀漀挀ഀഀ
		on sl.OriginalCampaignID__c = soc.Id ਍ऀऀ氀攀昀琀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䌀愀洀瀀愀椀最渀 猀爀挀ഀഀ
		on sl.RecentCampaign__c = src.Id ਍ऀऀ氀攀昀琀 樀漀椀渀 ⠀ഀഀ
			Select cc.CenterID਍ऀऀऀⰀ 挀挀⸀䌀攀渀琀攀爀䐀攀猀挀爀椀瀀琀椀漀渀䘀甀氀氀䌀愀氀挀 ഀഀ
			, cct.CenterTypeDescription ਍ऀऀऀⰀ 挀挀漀⸀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀 ഀഀ
			from [hc-sqlpool-eim-prod-eus2].ODS.CNCT_Center cc ਍ऀऀऀ椀渀渀攀爀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀䌀一䌀吀开䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀 挀挀漀 ഀഀ
			on cc.CenterOwnershipID = cco.CenterOwnershipID਍ऀऀऀ䤀一一䔀刀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀䌀一䌀吀开䌀攀渀琀攀爀吀礀瀀攀 挀挀琀 ഀഀ
			on cc.CenterTypeID = cct.CenterTypeID ਍ऀऀऀ眀栀攀爀攀 挀挀⸀椀猀愀挀琀椀瘀攀昀氀愀最 㴀 ㄀ഀഀ
		) as ctr਍ऀऀ漀渀 䤀匀一唀䰀䰀⠀猀氀⸀䌀攀渀琀攀爀一甀洀戀攀爀开开挀Ⰰ 猀氀⸀䌀攀渀琀攀爀䤀䐀开开挀⤀ 㴀 挀琀爀⸀䌀攀渀琀攀爀䤀䐀ഀഀ
		inner join #FunnelTable ft਍ऀऀ漀渀 猀氀⸀䤀搀 㴀 昀琀⸀椀搀ഀഀ
		left join [ODS].[SFDC_Task] tsk਍ऀऀऀ漀渀 琀猀欀⸀䤀搀 㴀 昀琀⸀吀愀猀欀䤀搀ഀഀ
		LEFT JOIN [ODS].[CNCT_Center] center਍ऀऀऀ伀一 琀猀欀⸀䌀攀渀琀攀爀一甀洀戀攀爀开开挀 㴀 挀攀渀琀攀爀⸀䌀攀渀琀攀爀䤀搀 愀渀搀 挀攀渀琀攀爀⸀椀猀愀挀琀椀瘀攀昀氀愀最 㴀 ㄀ഀഀ
		LEFT JOIN [ODS].[CNCT_CenterType] cty਍ऀऀऀ伀一 挀攀渀琀攀爀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀 㴀 挀琀礀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀ഀഀ
		left join [dbo].[DimTimeOfDay] dtd਍ऀऀ漀渀 琀爀椀洀⠀搀琀搀⸀嬀吀椀洀攀㈀㐀崀⤀ 㴀 琀爀椀洀⠀挀漀渀瘀攀爀琀⠀瘀愀爀挀栀愀爀Ⰰ昀琀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀Ⰰ㠀⤀⤀ഀഀ
		left join [dbo].[DimGeography] g਍ऀऀ漀渀 猀氀⸀倀漀猀琀愀氀䌀漀搀攀 㴀 最⸀䐀椀最椀琀娀椀瀀䌀漀搀攀ഀഀ
		left join (਍ऀऀऀ匀䔀䰀䔀䌀吀 最⸀䐀椀最椀琀娀椀瀀䌀漀搀攀ഀഀ
			, g.DMACode਍ऀऀऀⰀ 挀⸀䌀攀渀琀攀爀一甀洀戀攀爀ഀഀ
			, DMAMarketRegion਍ऀऀऀⰀ 䐀䴀䄀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
			FROM [hc-sqlpool-eim-prod-eus2].[dbo].[DimGeography] g਍ऀऀऀ椀渀渀攀爀 樀漀椀渀 嬀伀䐀匀崀⸀嬀䌀一䌀吀开䌀攀渀琀攀爀崀 挀ഀഀ
			on c.[PostalCode] = g.[DigitZipCode]਍ऀऀऀ眀栀攀爀攀 挀⸀椀猀愀挀琀椀瘀攀昀氀愀最㴀㄀⤀ 愀猀 挀渀ഀഀ
		on sl.[CenterNumber__c] = cn.[CenterNumber]਍ऀऀ眀栀攀爀攀 猀氀⸀䤀搀 椀渀 ⠀匀攀氀攀挀琀 ⨀ 昀爀漀洀 ⌀唀瀀搀愀琀攀䰀攀愀搀猀⤀ 愀渀搀 昀琀⸀嬀䘀甀渀渀攀氀匀琀攀瀀崀 㴀 ✀䌀漀渀琀愀挀琀✀ഀഀ
	;਍ഀഀ
		update Reports.Funnel ਍ऀ猀攀琀 嬀䌀漀渀琀愀挀琀䤀䐀崀 㴀 一唀䰀䰀ഀഀ
		  ,[SalesForceTaskID] = ft.Taskid਍ऀऀ  Ⰰ嬀䈀爀椀最栀琀倀愀琀琀攀爀渀䤀䐀崀 㴀 一唀䰀䰀ഀഀ
		  ,[LeadFunnelTransactionID] = NULL਍ऀऀ  Ⰰ嬀匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀崀 㴀 猀氀⸀䤀搀ഀഀ
		  ,[Company] = CASE WHEN(cty.CenterTypeDescription = 'Hans Wiemann') THEN 'Hans Wiemann'਍ऀऀऀऀऀ   䔀䰀匀䔀 ✀䠀愀椀爀 䌀氀甀戀✀ 攀渀搀ഀഀ
		  ,[FunnelStep] = ft.FunnelStep਍ऀऀ  Ⰰ嬀䘀甀渀渀攀氀猀琀愀琀甀猀崀 㴀 猀氀⸀匀琀愀琀甀猀ഀഀ
		  ,[OriginalGCLID] = sl.GCLID__c਍ऀऀ  Ⰰ嬀䰀攀愀搀䌀爀攀愀琀攀䐀愀琀攀唀吀䌀崀 㴀 猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀ഀഀ
		  ,[LeadCreateDateEST] = dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate)਍ऀऀ  Ⰰ嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀崀 㴀 昀琀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀唀吀䌀ഀഀ
		  ,[ActivityDateEST] = ft.ActivityDateEST਍ऀऀ  Ⰰ嬀刀攀瀀漀爀琀䌀爀攀愀琀攀䐀愀琀攀崀 㴀 猀氀⸀嬀刀攀瀀漀爀琀䌀爀攀愀琀攀䐀愀琀攀开开挀崀ഀഀ
		  ,[Date] = cast(ft.ActivityDateEST as date)਍ऀऀ  Ⰰ嬀吀椀洀攀崀 㴀 挀愀猀琀⠀昀琀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀 愀猀 琀椀洀攀⤀ഀഀ
		  ,[DayPart] = dtd.DayPart਍ऀऀ  Ⰰ嬀䠀漀甀爀崀 㴀 搀琀搀⸀嬀䠀漀甀爀崀ഀഀ
		  ,[Minute] = dtd.[minute]਍ऀऀ  Ⰰ嬀匀攀挀漀渀搀猀崀 㴀 搀琀搀⸀嬀匀攀挀漀渀搀崀ഀഀ
		  ,[OriginalContactType] = sl.LeadSource਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀匀漀甀爀挀攀挀漀搀攀崀 㴀 猀氀⸀匀漀甀爀挀攀开䌀漀搀攀开䰀攀最愀挀礀开开挀ഀഀ
		  ,[OriginalDialedNumber] = CASE WHEN soc.SourceCode_L__c like '%MP'਍ऀऀऀऀऀऀऀऀऀ吀䠀䔀一 猀漀挀⸀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀开开挀ഀഀ
									ELSE soc.TollFreeName__c end਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀 㴀 匀唀䈀匀吀刀䤀一䜀⠀猀氀⸀倀栀漀渀攀䄀戀爀开开挀Ⰰ 　Ⰰ㐀 ⤀ഀഀ
		  ,[OriginalCampaignAgency] = soc.[Type]਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 㴀 猀漀挀⸀䌀栀愀渀渀攀氀开开挀ഀഀ
		  ,[OriginalCampaignName] = soc.Name਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 猀漀挀⸀䘀漀爀洀愀琀开开挀ഀഀ
		  ,[OriginalCampaignLanguage] = soc.Language__c਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 㴀 猀漀挀⸀倀爀漀洀漀䌀漀搀攀一愀洀攀开开挀ഀഀ
		  ,[OriginalCampaignStartDate] = soc.StartDate਍ऀऀ  Ⰰ嬀伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 㴀 猀漀挀⸀䔀渀搀䐀愀琀攀ഀഀ
		  ,[OriginalCampaignStatus] = soc.Status਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀匀漀甀爀挀攀挀漀搀攀崀 㴀 猀氀⸀刀攀挀攀渀琀匀漀甀爀挀攀䌀漀搀攀开开挀ഀഀ
		  ,[RecentDialedNumber] = CASE WHEN src.SourceCode_L__c like '%MP'਍ऀऀऀऀऀऀऀऀ  吀䠀䔀一 猀爀挀⸀吀漀氀氀䘀爀攀攀䴀漀戀椀氀攀一愀洀攀开开挀ഀഀ
								  ELSE src.TollFreeName__c end਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀倀栀漀渀攀一甀洀戀攀爀䄀爀攀愀䌀漀搀攀崀 㴀 匀唀䈀匀吀刀䤀一䜀⠀猀氀⸀倀栀漀渀攀䄀戀爀开开挀Ⰰ 　Ⰰ㐀 ⤀ഀഀ
		  ,[RecentCampaignAgency] = src.[Type]਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䌀栀愀渀渀攀氀崀 㴀 猀爀挀⸀䌀栀愀渀渀攀氀开开挀ഀഀ
		  ,[RecentCampaignName] = src.Name਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䘀漀爀洀愀琀崀 㴀 猀爀挀⸀䘀漀爀洀愀琀开开挀ഀഀ
		  ,[RecentCampaignLanguage] = src.Language__c਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀倀爀漀洀漀琀椀漀渀䌀漀搀攀崀 㴀 猀爀挀⸀倀爀漀洀漀䌀漀搀攀一愀洀攀开开挀ഀഀ
		  ,[RecentCampaignStartDate] = src.StartDate਍ऀऀ  Ⰰ嬀刀攀挀攀渀琀䌀愀洀瀀愀椀最渀䔀渀搀䐀愀琀攀崀 㴀 猀爀挀⸀䔀渀搀䐀愀琀攀ഀഀ
		  ,[RecentCampaignStatus] = src.Status਍ऀऀ  Ⰰ嬀倀漀猀琀愀氀䌀漀搀攀崀 㴀 猀氀⸀倀漀猀琀愀氀䌀漀搀攀ഀഀ
		  ,[Region] = g.DMAMarketRegion਍ऀऀ  Ⰰ嬀䴀愀爀欀攀琀䐀䴀䄀崀 㴀 最⸀䐀䴀䄀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
		  ,[CenterName] = ctr.CenterDescriptionFullCalc਍ऀऀ  Ⰰ嬀䌀攀渀琀攀爀刀攀最椀漀渀崀 㴀 挀渀⸀䐀䴀䄀䴀愀爀欀攀琀刀攀最椀漀渀ഀഀ
		  ,[CenterDMA] = cn.DMADescription਍ऀऀ  Ⰰ嬀䌀攀渀琀攀爀吀礀瀀攀崀 㴀 挀琀爀⸀䌀攀渀琀攀爀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
		  ,[CenterOwner] = ctr.CenterOwnershipDescription਍ऀऀ  Ⰰ嬀䰀愀渀最甀愀最攀崀 㴀 猀氀⸀䰀愀渀最甀愀最攀开开挀ഀഀ
		  ,[Gender] = sl.Gender__c ਍ऀऀ  Ⰰ嬀䰀愀猀琀一愀洀攀崀 㴀 猀氀⸀䰀愀猀琀一愀洀攀 ഀഀ
		  ,[FirstName] = sl.FirstName ਍ऀऀ  Ⰰ嬀倀栀漀渀攀崀 㴀 刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀刀䔀倀䰀䄀䌀䔀⠀猀氀⸀嬀倀栀漀渀攀崀Ⰰ✀⠀✀Ⰰ✀✀⤀Ⰰ✀⤀✀Ⰰ✀✀⤀Ⰰ✀ ✀Ⰰ✀✀⤀Ⰰ✀ⴀ✀Ⰰ✀✀⤀ഀഀ
		  ,[MobilePhone] = REPLACE(REPLACE(REPLACE(REPLACE(sl.[MobilePhone],'(',''),')',''),' ',''),'-','')਍ऀऀ  Ⰰ嬀䔀洀愀椀氀崀 㴀 猀氀⸀䔀洀愀椀氀 ഀഀ
		  ,[Ethnicity] = sl.Ethnicity__c਍ऀऀ  Ⰰ嬀䠀愀椀爀䰀漀猀猀䌀漀渀搀椀琀椀漀渀崀 㴀 䤀猀渀甀氀氀⠀猀氀⸀一漀爀眀漀漀搀匀挀愀氀攀开开挀Ⰰ猀氀⸀䰀甀搀眀椀最匀挀愀氀攀开开挀⤀ഀഀ
		  ,[MaritalStatus] = sl.MaritalStatus__c਍ऀऀ  Ⰰ嬀伀挀挀甀瀀愀琀椀漀渀崀 㴀 猀氀⸀伀挀挀甀瀀愀琀椀漀渀开开挀ഀഀ
		  ,[BirthYear] = YEAR(sl.Birthday__c)਍ऀऀ  Ⰰ嬀䄀最攀䈀愀渀搀猀崀 㴀 䌀䄀匀䔀 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 ㄀ 䄀一䐀 ㄀㜀⤀ 吀䠀䔀一 ✀唀渀搀攀爀 ㄀㠀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 18 AND 24) THEN '18 to 24'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 ㈀㔀 䄀一䐀 ㌀㐀⤀ 吀䠀䔀一 ✀㈀㔀 琀漀 ㌀㐀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 35 AND 44) THEN '35 to 44'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 㐀㔀 䄀一䐀 㔀㐀⤀ 吀䠀䔀一 ✀㐀㔀 琀漀 㔀㐀✀ഀഀ
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 55 AND 64) THEN '55 to 64'਍ऀऀऀऀ 圀䠀䔀一⠀䌀䄀匀吀⠀䐀䄀吀䔀䐀䤀䘀䘀⠀礀攀愀爀Ⰰ 猀氀⸀䈀椀爀琀栀搀愀礀开开挀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀ 䄀匀 䤀一吀⤀ 䈀䔀吀圀䔀䔀一 㘀㔀 䄀一䐀 ㄀㈀　⤀ 吀䠀䔀一 ✀㘀㔀 ⬀✀ഀഀ
				 ELSE 'Unknown' end਍ऀऀ  Ⰰ嬀一攀眀䌀漀渀琀愀挀琀崀 㴀 昀琀⸀䌀漀渀琀愀挀琀ഀഀ
		  ,[NewLead] = ft.Lead਍ऀऀ  Ⰰ嬀一攀眀䄀瀀瀀漀椀渀琀洀攀渀琀崀 㴀 昀琀⸀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
		  ,[NewShow] = ft.Show਍ऀऀ  Ⰰ嬀一攀眀匀愀氀攀崀 㴀 昀琀⸀匀愀氀攀ഀഀ
		  ,[NewLeadToAppointment] = ft.NewLeadToappointment਍ऀऀ  Ⰰ嬀一攀眀䰀攀愀搀吀漀匀栀漀眀崀 㴀 昀琀⸀一攀眀䰀攀愀搀吀漀猀栀漀眀ഀഀ
		  ,[NewLeadToSale] = ft.NewLeadTosale਍ऀऀ  Ⰰ嬀儀甀漀琀攀搀倀爀椀挀攀崀 㴀 昀琀⸀儀甀漀琀攀搀倀爀椀挀攀ഀഀ
		  ,[PrimarySolution] = ft.saletypeDescription਍ऀऀ  Ⰰ嬀䐀漀一漀琀䌀漀渀琀愀挀琀䘀氀愀最崀 㴀  挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀䌀漀渀琀愀挀琀开开挀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀ഀഀ
		  ,[DoNotCallFlag] =  case when sl.DoNotCall = 1 then 'Y' else 'N' end਍ऀऀ  Ⰰ嬀䐀漀一漀琀匀䴀匀䘀氀愀最崀 㴀  挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀吀攀砀琀开开挀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀ഀഀ
		  ,[DoNotEmailFlag] =  case when sl.DoNotEmail__c = 1 then 'Y' else 'N' end਍ऀऀ  Ⰰ嬀䐀漀一漀琀䴀愀椀氀䘀氀愀最崀 㴀  挀愀猀攀 眀栀攀渀 猀氀⸀䐀漀一漀琀䴀愀椀氀开开挀 㴀 ㄀ 琀栀攀渀 ✀夀✀ 攀氀猀攀 ✀一✀ 攀渀搀ഀഀ
		  ,[IsDeleted] = sl.IsDeleted਍ऀऀ  Ⰰ嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 㴀 昀琀⸀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀ഀഀ
	FROM Reports.Funnel  r਍ऀ椀渀渀攀爀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
	on r.saleforceleadid = sl.id਍ऀ氀攀昀琀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䌀愀洀瀀愀椀最渀 猀漀挀ഀഀ
		on sl.OriginalCampaignID__c = soc.Id ਍ऀऀ氀攀昀琀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䌀愀洀瀀愀椀最渀 猀爀挀ഀഀ
		on sl.RecentCampaign__c = src.Id ਍ऀऀ氀攀昀琀 樀漀椀渀 ⠀ഀഀ
			Select cc.CenterID਍ऀऀऀⰀ 挀挀⸀䌀攀渀琀攀爀䐀攀猀挀爀椀瀀琀椀漀渀䘀甀氀氀䌀愀氀挀 ഀഀ
			, cct.CenterTypeDescription ਍ऀऀऀⰀ 挀挀漀⸀䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀 ഀഀ
			from [hc-sqlpool-eim-prod-eus2].ODS.CNCT_Center cc ਍ऀऀऀ椀渀渀攀爀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀䌀一䌀吀开䌀攀渀琀攀爀伀眀渀攀爀猀栀椀瀀 挀挀漀 ഀഀ
			on cc.CenterOwnershipID = cco.CenterOwnershipID਍ऀऀऀ䤀一一䔀刀 樀漀椀渀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀䌀一䌀吀开䌀攀渀琀攀爀吀礀瀀攀 挀挀琀 ഀഀ
			on cc.CenterTypeID = cct.CenterTypeID ਍ऀऀऀ眀栀攀爀攀 挀挀⸀椀猀愀挀琀椀瘀攀昀氀愀最 㴀 ㄀ഀഀ
		) as ctr਍ऀऀ漀渀 䤀匀一唀䰀䰀⠀猀氀⸀䌀攀渀琀攀爀一甀洀戀攀爀开开挀Ⰰ 猀氀⸀䌀攀渀琀攀爀䤀䐀开开挀⤀ 㴀 挀琀爀⸀䌀攀渀琀攀爀䤀䐀ഀഀ
		inner join #FunnelTable ft਍ऀऀ漀渀 猀氀⸀䤀搀 㴀 昀琀⸀椀搀ഀഀ
		left join [ODS].[SFDC_Task] tsk਍ऀऀऀ漀渀 琀猀欀⸀䤀搀 㴀 昀琀⸀吀愀猀欀䤀搀ഀഀ
		LEFT JOIN [ODS].[CNCT_Center] center਍ऀऀऀ伀一 琀猀欀⸀䌀攀渀琀攀爀一甀洀戀攀爀开开挀 㴀 挀攀渀琀攀爀⸀䌀攀渀琀攀爀䤀搀 愀渀搀 挀攀渀琀攀爀⸀椀猀愀挀琀椀瘀攀昀氀愀最 㴀 ㄀ഀഀ
		LEFT JOIN [ODS].[CNCT_CenterType] cty਍ऀऀऀ伀一 挀攀渀琀攀爀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀 㴀 挀琀礀⸀䌀攀渀琀攀爀吀礀瀀攀䤀䐀ഀഀ
		left join [dbo].[DimTimeOfDay] dtd਍ऀऀ漀渀 琀爀椀洀⠀搀琀搀⸀嬀吀椀洀攀㈀㐀崀⤀ 㴀 琀爀椀洀⠀挀漀渀瘀攀爀琀⠀瘀愀爀挀栀愀爀Ⰰ昀琀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀䔀匀吀Ⰰ㠀⤀⤀ഀഀ
		left join [dbo].[DimGeography] g਍ऀऀ漀渀 猀氀⸀倀漀猀琀愀氀䌀漀搀攀 㴀 最⸀䐀椀最椀琀娀椀瀀䌀漀搀攀ഀഀ
		left join (਍ऀऀऀ匀䔀䰀䔀䌀吀 最⸀䐀椀最椀琀娀椀瀀䌀漀搀攀ഀഀ
			, g.DMACode਍ऀऀऀⰀ 挀⸀䌀攀渀琀攀爀一甀洀戀攀爀ഀഀ
			, DMAMarketRegion਍ऀऀऀⰀ 䐀䴀䄀䐀攀猀挀爀椀瀀琀椀漀渀ഀഀ
			FROM [hc-sqlpool-eim-prod-eus2].[dbo].[DimGeography] g਍ऀऀऀ椀渀渀攀爀 樀漀椀渀 嬀伀䐀匀崀⸀嬀䌀一䌀吀开䌀攀渀琀攀爀崀 挀ഀഀ
			on c.[PostalCode] = g.[DigitZipCode]਍ऀऀऀ眀栀攀爀攀 挀⸀椀猀愀挀琀椀瘀攀昀氀愀最㴀㄀⤀ 愀猀 挀渀ഀഀ
		on sl.[CenterNumber__c] = cn.[CenterNumber]਍ऀऀ眀栀攀爀攀 猀氀⸀䤀搀 椀渀 ⠀匀攀氀攀挀琀 ⨀ 昀爀漀洀 ⌀唀瀀搀愀琀攀䰀攀愀搀猀⤀ 愀渀搀 昀琀⸀嬀䘀甀渀渀攀氀匀琀攀瀀崀 渀漀琀 椀渀 ⠀✀䌀漀渀琀愀挀琀✀⤀㬀ഀഀ
਍ഀഀ
਍甀瀀搀愀琀攀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 猀攀琀 刀攀最椀漀渀 㴀 䘀甀渀渀攀氀⸀䌀攀渀琀攀爀刀攀最椀漀渀ഀഀ
where PostalCode is null or Region is null਍ഀഀ
update Reports.Funnel set MarketDMA = Funnel.CenterDMA਍眀栀攀爀攀 倀漀猀琀愀氀䌀漀搀攀 椀猀 渀甀氀氀 漀爀 䴀愀爀欀攀琀䐀䴀䄀 椀猀 渀甀氀氀ഀഀ
਍甀瀀搀愀琀攀 刀攀瀀漀爀琀猀⸀䘀甀渀渀攀氀 猀攀琀 䌀攀渀琀攀爀刀攀最椀漀渀 㴀 䘀甀渀渀攀氀⸀刀攀最椀漀渀ഀഀ
where CenterRegion is null਍ഀഀ
update Reports.Funnel set CenterDMA = Funnel.MarketDMA਍眀栀攀爀攀 䌀攀渀琀攀爀䐀䴀䄀 椀猀 渀甀氀氀㬀ഀഀ
਍ഀഀ
With lead_temp as (਍ऀऀ匀䔀䰀䔀䌀吀 嬀匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀崀Ⰰ嬀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀ഀഀ
		FROM Reports.Funnel ਍ऀऀ眀栀攀爀攀 昀甀渀渀攀氀猀琀攀瀀 㴀 ✀䰀攀愀搀✀ ⴀⴀ愀渀搀 嬀匀愀氀攀昀漀爀挀攀䰀攀愀搀䤀䐀崀 㴀✀　　儀昀㐀　　　　　㌀洀匀砀嘀䔀䄀唀✀ഀഀ
		)਍ऀऀⴀⴀ椀渀猀攀爀琀 椀渀琀漀 ⌀琀攀洀瀀ഀഀ
		select [SaleforceLeadID],[FunnelTransactionID] into #update_transaction from lead_temp;਍ഀഀ
update Reports.Funnel ਍ऀ猀攀琀 嬀䰀攀愀搀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀 㴀 甀⸀嬀䘀甀渀渀攀氀吀爀愀渀猀愀挀琀椀漀渀䤀䐀崀ഀഀ
FROM Reports.Funnel  r਍䤀一一䔀刀 䨀伀䤀一 ⌀甀瀀搀愀琀攀开琀爀愀渀猀愀挀琀椀漀渀 甀ഀഀ
on r.[SaleforceLeadID] = u.[SaleforceLeadID];਍ഀഀ
With bpcd as (਍ऀऀ匀䔀䰀䔀䌀吀 嬀瀀欀椀搀崀Ⰰ挀愀猀琀⠀嬀挀甀猀琀漀洀㌀崀 愀猀 瘀愀爀挀栀愀爀⤀ 挀甀猀琀漀洀㌀ഀഀ
		FROM [ODS].[BP_CallDetail]਍ऀऀ眀栀攀爀攀 挀甀猀琀漀洀㌀ 椀猀 渀漀琀 渀甀氀氀ഀഀ
		)਍ऀऀⴀⴀ椀渀猀攀爀琀 椀渀琀漀 ⌀琀攀洀瀀ഀഀ
		select [pkid],cast([custom3]  as varchar) custom3 into #pkid from bpcd;਍ഀഀ
਍ഀഀ
update Reports.Funnel ਍ऀ猀攀琀 嬀䈀爀椀最栀琀倀愀琀琀攀爀渀䤀䐀崀 㴀 戀⸀瀀欀椀搀ഀഀ
FROM Reports.Funnel  r਍䤀一一䔀刀 䨀伀䤀一 ⌀瀀欀椀搀 戀ഀഀ
on r.[SalesForceTaskID] = b.custom3;਍ഀഀ
With bpcd_lead as (਍ऀऀ匀䔀䰀䔀䌀吀 嬀瀀欀椀搀崀Ⰰ挀愀猀琀⠀嬀挀甀猀琀漀洀㄀崀 愀猀 瘀愀爀挀栀愀爀⤀ 挀甀猀琀漀洀㄀Ⰰ嬀猀琀愀爀琀开琀椀洀攀崀Ⰰ刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 挀甀猀琀漀洀㄀ 伀刀䐀䔀刀 䈀夀 嬀猀琀愀爀琀开琀椀洀攀崀 䄀匀䌀⤀ 愀猀 爀漀眀渀甀洀ഀഀ
		FROM [ODS].[BP_CallDetail]਍ऀऀ眀栀攀爀攀 挀甀猀琀漀洀㌀ 椀猀 渀漀琀 渀甀氀氀ഀഀ
		)਍ऀऀⴀⴀ椀渀猀攀爀琀 椀渀琀漀 ⌀琀攀洀瀀ഀഀ
		select [pkid],cast([custom1]  as varchar) custom1,[start_time],rownum into #pkid_lead from bpcd_lead਍ऀऀ眀栀攀爀攀 爀漀眀渀甀洀 㴀 ㄀㬀ഀഀ
਍ഀഀ
update Reports.Funnel ਍ऀ猀攀琀 嬀䈀爀椀最栀琀倀愀琀琀攀爀渀䤀䐀崀 㴀 戀⸀瀀欀椀搀ഀഀ
FROM Reports.Funnel  r਍䤀一一䔀刀 䨀伀䤀一 ⌀瀀欀椀搀开氀攀愀搀 戀ഀഀ
on r.[SaleforceLeadID] = b.custom1਍ഀഀ
਍ഀഀ
	DROP TABLE #FunnelTable਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀甀瀀搀愀琀攀开琀爀愀渀猀愀挀琀椀漀渀ഀഀ
	DROP TABLE #pkid਍ऀ䐀刀伀倀 吀䄀䈀䰀䔀 ⌀瀀欀椀搀开氀攀愀搀ഀഀ
	DROP TABLE #NewLeads਍ഀഀ
end਍        ഀഀ
GO਍
