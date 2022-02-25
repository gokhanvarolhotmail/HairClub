/****** Object:  StoredProcedure [ODS].[sp_PopulateDaily_GoogleFeed]    Script Date: 1/10/2022 10:03:12 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀伀䐀匀崀⸀嬀猀瀀开倀漀瀀甀氀愀琀攀䐀愀椀氀礀开䜀漀漀最氀攀䘀攀攀搀崀 䄀匀ഀഀ
BEGIN਍    ⴀⴀ 匀䔀吀 一伀䌀伀唀一吀 伀一 愀搀搀攀搀 琀漀 瀀爀攀瘀攀渀琀 攀砀琀爀愀 爀攀猀甀氀琀 猀攀琀猀 昀爀漀洀ഀഀ
    -- interfering with SELECT statements.਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍ऀഀഀ
truncate table [ODS].[Google]਍ഀഀ
----Create tables----------਍ഀഀ
create Table #Contact਍ऀ⠀ഀഀ
	    [GoogleClickID] varchar(2048),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀一愀洀攀 瘀愀爀挀栀愀爀⠀㄀　㈀㐀⤀Ⰰഀഀ
	    ConversionTime varchar(100),਍ऀऀ搀愀琀攀吀椀洀攀䜀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    ConversionValue VARCHAR(1000),਍ऀऀ䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀 瘀愀爀挀栀愀爀⠀㄀　⤀ഀഀ
	)਍ऀഀഀ
	create Table #Lead਍ऀ⠀ഀഀ
	    [GoogleClickID] varchar(2048),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀一愀洀攀 瘀愀爀挀栀愀爀⠀㄀　㈀㐀⤀Ⰰഀഀ
	    ConversionTime varchar(100),਍ऀऀ搀愀琀攀吀椀洀攀䜀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    ConversionValue VARCHAR(1000),਍ऀऀ䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀 瘀愀爀挀栀愀爀⠀㄀　⤀ഀഀ
	)਍ऀഀഀ
	create Table #Appointment਍ऀ⠀ഀഀ
	    [GoogleClickID] varchar(2048),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀一愀洀攀 瘀愀爀挀栀愀爀⠀㄀　㈀㐀⤀Ⰰഀഀ
	    ConversionTime varchar(100),਍ऀऀ搀愀琀攀吀椀洀攀䜀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    ConversionValue VARCHAR(1000),਍ऀऀ䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀 瘀愀爀挀栀愀爀⠀㄀　⤀ഀഀ
	)਍ऀഀഀ
	create Table #Show਍ऀ⠀ഀഀ
	    [GoogleClickID] varchar(2048),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀一愀洀攀 瘀愀爀挀栀愀爀⠀㄀　㈀㐀⤀Ⰰഀഀ
	    ConversionTime varchar(100),਍ऀऀ搀愀琀攀吀椀洀攀䜀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    ConversionValue VARCHAR(1000),਍ऀऀ䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀 瘀愀爀挀栀愀爀⠀㄀　⤀ഀഀ
	)਍ഀഀ
	create Table #Sale਍ऀ⠀ഀഀ
	    [GoogleClickID] varchar(2048),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀一愀洀攀 瘀愀爀挀栀愀爀⠀㄀　㈀㐀⤀Ⰰഀഀ
	    ConversionTime varchar(100),਍ऀऀ搀愀琀攀吀椀洀攀䜀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    ConversionValue VARCHAR(1000),਍ऀऀ䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀 瘀愀爀挀栀愀爀⠀㄀　⤀ഀഀ
	)਍ഀഀ
	਍ऀ挀爀攀愀琀攀 吀愀戀氀攀 ⌀匀愀氀攀唀渀欀渀漀眀渀ഀഀ
	(਍ऀ    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀 瘀愀爀挀栀愀爀⠀㈀　㐀㠀⤀Ⰰഀഀ
	    ConversionName varchar(1024),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
		dateTimeG datetime,਍ऀ    䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀 嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀Ⰰഀഀ
		ConversionCurrency varchar(10)਍ऀ⤀ഀഀ
	਍ऀ挀爀攀愀琀攀 吀愀戀氀攀 ⌀匀愀氀攀䔀堀吀ഀഀ
	(਍ऀ    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀 瘀愀爀挀栀愀爀⠀㈀　㐀㠀⤀Ⰰഀഀ
	    ConversionName varchar(1024),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
		dateTimeG datetime,਍ऀ    䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀 嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀Ⰰഀഀ
		ConversionCurrency varchar(10)਍ऀ⤀ഀഀ
਍ऀऀ挀爀攀愀琀攀 吀愀戀氀攀 ⌀匀愀氀攀䘀唀䔀ഀഀ
	(਍ऀ    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀 瘀愀爀挀栀愀爀⠀㈀　㐀㠀⤀Ⰰഀഀ
	    ConversionName varchar(1024),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
		dateTimeG datetime,਍ऀ    䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀 嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀Ⰰഀഀ
		ConversionCurrency varchar(10)਍ऀ⤀ഀഀ
		create Table #SaleFUT਍ऀ⠀ഀഀ
	    [GoogleClickID] varchar(2048),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀一愀洀攀 瘀愀爀挀栀愀爀⠀㄀　㈀㐀⤀Ⰰഀഀ
	    ConversionTime varchar(100),਍ऀऀ搀愀琀攀吀椀洀攀䜀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    ConversionValue VARCHAR(1000),਍ऀऀ䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀 瘀愀爀挀栀愀爀⠀㄀　⤀ഀഀ
	)਍ऀऀ挀爀攀愀琀攀 吀愀戀氀攀 ⌀匀愀氀攀堀琀爀愀渀搀猀ഀഀ
	(਍ऀ    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀 瘀愀爀挀栀愀爀⠀㈀　㐀㠀⤀Ⰰഀഀ
	    ConversionName varchar(1024),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
		dateTimeG datetime,਍ऀ    䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀 嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀Ⰰഀഀ
		ConversionCurrency varchar(10)਍ऀ⤀ഀഀ
		create Table #SaleXtrandsPlus਍ऀ⠀ഀഀ
	    [GoogleClickID] varchar(2048),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀一愀洀攀 瘀愀爀挀栀愀爀⠀㄀　㈀㐀⤀Ⰰഀഀ
	    ConversionTime varchar(100),਍ऀऀ搀愀琀攀吀椀洀攀䜀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    ConversionValue VARCHAR(1000),਍ऀऀ䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀 瘀愀爀挀栀愀爀⠀㄀　⤀ഀഀ
	)਍ഀഀ
	create Table #FunnelTable਍ऀ⠀ഀഀ
	    [GoogleClickID] varchar(2048),਍ऀ    䌀漀渀瘀攀爀猀椀漀渀一愀洀攀 瘀愀爀挀栀愀爀⠀㄀　㈀㐀⤀Ⰰഀഀ
	    ConversionTime varchar(100),਍ऀऀ搀愀琀攀吀椀洀攀䜀 搀愀琀攀琀椀洀攀Ⰰഀഀ
	    ConversionValue VARCHAR(1000),਍ऀऀ䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀 瘀愀爀挀栀愀爀⠀㄀　⤀ഀഀ
	)਍ഀഀ
਍ऀ䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
	    #Contact਍ऀ匀攀氀攀挀琀 ഀഀ
	 sl.GCLID__c AS [GoogleClickID]਍ऀⰀ ✀䤀洀瀀漀爀琀 ⴀ 䌀漀渀琀愀挀琀猀✀ 䄀匀 䌀漀渀瘀攀爀猀椀漀渀一愀洀攀ഀഀ
	, FORMAT(dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime਍ऀⰀ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀ 愀猀 搀愀琀攀吀椀洀攀䜀ഀഀ
	, '0.00' AS ConversionValue਍ऀⰀ ✀唀匀䐀✀ 䄀匀 䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀ഀഀ
	FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl਍ऀ圀䠀䔀刀䔀 猀氀⸀䜀䌀䰀䤀䐀开开挀 䤀匀 一伀吀 一唀䰀䰀㬀ഀഀ
਍ऀഀഀ
	---Lead਍ऀ䔀堀䔀䌀    嬀伀䐀匀崀⸀嬀䰀攀愀搀嘀愀氀椀搀愀琀椀漀渀崀ഀഀ
	Insert into  #Lead਍ऀ匀攀氀攀挀琀 ഀഀ
	 sl.GCLID__c AS [GoogleClickID]਍ऀⰀ ✀䤀洀瀀漀爀琀 ⴀ 䰀攀愀搀猀✀ 䄀匀 䌀漀渀瘀攀爀猀椀漀渀一愀洀攀ഀഀ
	, FORMAT(DATEADD(MINUTE,2,dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime਍ऀⰀ䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㈀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀⤀ 愀猀 搀愀琀攀吀椀洀攀䜀ഀഀ
	, '0.00' AS ConversionValue਍ऀⰀ ✀唀匀䐀✀ 䄀匀 䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀ഀഀ
	FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl਍ऀ䰀䔀䘀吀 䨀伀䤀一 伀䐀匀⸀⌀䤀猀䤀渀瘀愀氀椀搀 愀ഀഀ
	ON sl.id = a.Id਍ऀ眀栀攀爀攀 愀⸀䤀猀䤀渀瘀愀氀椀搀䰀攀愀搀 椀猀 渀甀氀氀 䄀一䐀 猀氀⸀䜀䌀䰀䤀䐀开开挀 䤀匀 一伀吀 一唀䰀䰀㬀 ഀഀ
਍ഀഀ
	਍ऀⴀⴀ䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ䌀爀攀愀琀攀搀䐀愀琀攀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId ORDER BY activityDate ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 琀爀椀洀⠀愀挀琀椀漀渀开开挀⤀ 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀Ⰰ✀䈀攀 䈀愀挀欀✀⤀ 愀渀搀 爀攀猀甀氀琀开开挀 㰀㸀 ✀嘀漀椀搀✀ഀഀ
	)਍ऀऀ䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
	     #Appointment਍ऀऀ匀䔀䰀䔀䌀吀ഀഀ
		 sl.GCLID__c AS [GoogleClickID]਍ऀऀⰀ ✀䤀洀瀀漀爀琀 ⴀ 䄀瀀瀀漀椀渀琀洀攀渀琀猀✀ 䄀匀 䌀漀渀瘀攀爀猀椀漀渀一愀洀攀ഀഀ
		,FORMAT(DATEADD(MINUTE,3,dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime਍ऀऀⰀ䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㌀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ猀氀⸀䌀爀攀愀琀攀搀䐀愀琀攀⤀⤀ 愀猀 搀愀琀攀吀椀洀攀䜀ഀഀ
		, '0.00' AS ConversionValue਍ऀऀⰀ ✀唀匀䐀✀ 䄀匀 䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀ഀഀ
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl਍ऀऀ䤀一一䔀刀 䨀伀䤀一 琀愀猀欀 漀渀 椀猀渀甀氀氀⠀猀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀Ⰰ猀氀⸀椀搀⤀ 㴀 琀愀猀欀⸀眀栀漀椀搀 ⴀⴀ伀刀 猀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀 㴀 琀愀猀欀⸀圀栀漀䤀搀ഀഀ
		where task.rownum=1 AND sl.GCLID__c IS NOT NULL; ਍ഀഀ
਍ऀഀഀ
	਍ऀⴀⴀⴀ匀栀漀眀ഀഀ
	਍ऀ圀椀琀栀 琀愀猀欀 愀猀 ⠀ഀഀ
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,਍ऀ刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 戀⸀圀栀漀䤀搀 伀刀䐀䔀刀 䈀夀 愀挀琀椀瘀椀琀礀䐀愀琀攀 䄀匀䌀⤀ഀഀ
	AS RowNum਍ऀ䘀刀伀䴀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开吀愀猀欀崀 戀ഀഀ
	where action__c in ('Appointment','Be Back','In House') and (result__c='Show No Sale' or result__c='Show Sale') ਍ऀ⤀ഀഀ
		Insert into ਍ऀ    ⌀匀栀漀眀ഀഀ
		SELECT਍ऀऀ 猀氀⸀䜀䌀䰀䤀䐀开开挀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
		, 'Import - Shows' AS ConversionName਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 ⠀猀琀愀爀琀琀椀洀攀开开挀 渀漀琀 氀椀欀攀 ✀─一唀䰀䰀─✀⤀ 吀䠀䔀一 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㈀Ⰰ䌀䄀匀吀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ ഀഀ
			  ELSE  FORMAT(DATEADD(MINUTE,2,task.ActivityDate),'MM/dd/yyyy hh:mm:s tt')਍ऀऀऀ  䔀一䐀 䄀匀 䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀ഀഀ
		,CASE WHEN (starttime__c not like '%NULL%') THEN (DATEADD(MINUTE,2,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) ਍ऀऀऀ  䔀䰀匀䔀  ⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㈀Ⰰ琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀⤀⤀ഀഀ
			  END AS dateTimeG਍ऀऀⰀ ✀　⸀　　✀ 䄀匀 䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀ഀഀ
		, 'USD' AS ConversionCurrency਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid  --OR sl.ConvertedContactId = task.WhoId਍ऀऀ眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀ 䄀一䐀 猀氀⸀䜀䌀䰀䤀䐀开开挀 䤀匀 一伀吀 一唀䰀䰀㬀 ഀഀ
਍ऀഀഀ
	---Sale਍ऀഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 愀挀琀椀漀渀开开挀 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䈀攀 䈀愀挀欀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀⤀ 愀渀搀 ⠀ 爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 匀愀氀攀✀⤀ ഀഀ
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] not in ('73','78')))਍ऀ⤀ഀഀ
		Insert into ਍ऀ    ⌀匀愀氀攀ഀഀ
		SELECT਍ऀऀ 猀氀⸀䜀䌀䰀䤀䐀开开挀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
		, 'Import - Sales' AS ConversionName਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 ⠀琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀 䤀匀 一唀䰀䰀 愀渀搀 琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀 渀漀琀 氀椀欀攀 ✀─一唀䰀䰀─✀⤀ 吀䠀䔀一 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㐀Ⰰ䌀䄀匀吀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ ഀഀ
			  WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c is NULL) THEN FORMAT(DATEADD(MINUTE,4,task.[ActivityDate]),'MM/dd/yyyy hh:mm:ss.00 tt')਍ऀऀऀ  䔀䰀匀䔀  䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㐀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀⤀Ⰰ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ഀഀ
			  END AS ConversionTime਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 ⠀琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀 䤀匀 一唀䰀䰀 愀渀搀 琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀 渀漀琀 氀椀欀攀 ✀─一唀䰀䰀─✀⤀ 吀䠀䔀一 ⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㐀Ⰰ䌀䄀匀吀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀⤀ ഀഀ
			  WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c is NULL) THEN (DATEADD(MINUTE,4,task.[ActivityDate]))਍ऀऀऀ  䔀䰀匀䔀  ⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㐀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀⤀⤀ഀഀ
			  END AS dateTimeG਍ऀऀⰀ ✀　⸀　　✀ 䄀匀 䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀ഀഀ
		, 'USD' AS ConversionCurrency਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId਍ऀऀ眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀ 䄀一䐀 猀氀⸀䜀䌀䰀䤀䐀开开挀 䤀匀 一伀吀 一唀䰀䰀㬀 ഀഀ
਍ऀⴀⴀⴀ䤀洀瀀漀爀琀 ⴀ 匀愀氀攀 ⴀ 䔀堀吀ഀഀ
਍ഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 愀挀琀椀漀渀开开挀 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䈀攀 䈀愀挀欀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀⤀ 愀渀搀 ⠀ 爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 匀愀氀攀✀⤀ ഀഀ
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] in ('72','12','14','11','13','19','20','25','70','71','6','45','43','27','62')))਍ऀ⤀ഀഀ
		Insert into ਍ऀ    ⌀匀愀氀攀䔀堀吀ഀഀ
		SELECT਍ऀऀ 猀氀⸀䜀䌀䰀䤀䐀开开挀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
		, 'Import - Sales - EXT' AS ConversionName਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 ⠀琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀 䤀匀 一唀䰀䰀⤀ 吀䠀䔀一 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ䌀䄀匀吀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ ഀഀ
			  ELSE  FORMAT(DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')਍ऀऀऀ  䔀一䐀 䄀匀 䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀ഀഀ
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN (DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) ਍ऀऀऀ  䔀䰀匀䔀  ⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀⤀⤀ഀഀ
			  END AS dateTimeG਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀 㴀 　 漀爀 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀 椀猀 渀甀氀氀 吀䠀䔀一 ✀　⸀　　✀ഀഀ
			ELSE format(task.QuotedPrice, N'#.##') ਍ऀऀऀ䔀一䐀 䄀匀 䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀ഀഀ
		, 'USD' AS ConversionCurrency਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId਍ऀऀ眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀ 䄀一䐀 猀氀⸀䜀䌀䰀䤀䐀开开挀 䤀匀 一伀吀 一唀䰀䰀㬀 ഀഀ
਍ⴀⴀⴀ䤀洀瀀漀爀琀 ⴀ 匀愀氀攀 ⴀ 䘀漀氀氀椀挀甀氀愀爀 唀渀椀琀 䔀砀琀爀愀挀琀 ⠀䘀唀䔀⤀ഀഀ
਍ഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 愀挀琀椀漀渀开开挀 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䈀攀 䈀愀挀欀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀⤀ 愀渀搀 ⠀ 爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 匀愀氀攀✀⤀ ഀഀ
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] in ('46','50','48')))਍ऀ⤀ഀഀ
		Insert into ਍ऀ    ⌀匀愀氀攀䘀唀䔀ഀഀ
		SELECT਍ऀऀ 猀氀⸀䜀䌀䰀䤀䐀开开挀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
		, 'Import - Sales - Follicular Unit Extract (FUE)' AS ConversionName਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 ⠀琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀 䤀匀 一唀䰀䰀⤀ 吀䠀䔀一 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ䌀䄀匀吀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀 琀琀✀⤀ ഀഀ
			  ELSE  FORMAT(DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')਍ऀऀऀ  䔀一䐀 䄀匀 䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀ഀഀ
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN (DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) ਍ऀऀऀ  䔀䰀匀䔀  ⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀⤀⤀ഀഀ
			  END AS dateTimeG਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀 㴀 　 漀爀 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀 椀猀 渀甀氀氀 吀䠀䔀一 ✀　⸀　　✀ഀഀ
			ELSE format(task.QuotedPrice, N'#.##') ਍ऀऀऀ䔀一䐀 䄀匀 䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀ഀഀ
		, 'USD' AS ConversionCurrency਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId਍ऀऀ眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀ 䄀一䐀 猀氀⸀䜀䌀䰀䤀䐀开开挀 䤀匀 一伀吀 一唀䰀䰀㬀 ഀഀ
਍ⴀⴀⴀ䤀洀瀀漀爀琀 ⴀ 匀愀氀攀 ⴀ 䘀漀氀氀椀挀甀氀愀爀 唀渀椀琀 吀爀愀渀猀瀀漀爀琀愀琀椀漀渀 ⠀䘀唀吀⤀ഀഀ
਍ഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 愀挀琀椀漀渀开开挀 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䈀攀 䈀愀挀欀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀⤀ 愀渀搀 ⠀ 爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 匀愀氀攀✀⤀ ഀഀ
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] in ('47','51','4')))਍ऀ⤀ഀഀ
		Insert into ਍ऀ    ⌀匀愀氀攀䘀唀吀ഀഀ
		SELECT਍ऀऀ 䤀匀一唀䰀䰀⠀猀氀⸀䜀䌀䰀䤀䐀开开挀Ⰰ✀ ✀⤀ 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
		, 'Import - Sales - Follicular Unit Transportation (FUT)' AS ConversionName਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 ⠀琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀 䤀匀 一唀䰀䰀⤀ 吀䠀䔀一 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ䌀䄀匀吀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ ഀഀ
			  ELSE  FORMAT(DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')਍ऀऀऀ  䔀一䐀 䄀匀 䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀ഀഀ
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN (DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) ਍ऀऀऀ  䔀䰀匀䔀  ⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀⤀⤀ഀഀ
			  END AS dateTimeG਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀 㴀 　 漀爀 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀 椀猀 渀甀氀氀 吀䠀䔀一 ✀　⸀　　✀ഀഀ
			ELSE format(task.QuotedPrice, N'#.##') ਍ऀऀऀ䔀一䐀 䄀匀 䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀ഀഀ
		, 'USD' AS ConversionCurrency਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId਍ऀऀ眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀ 䄀一䐀 猀氀⸀䜀䌀䰀䤀䐀开开挀 䤀匀 一伀吀 一唀䰀䰀㬀 ഀഀ
਍ⴀⴀⴀ䤀洀瀀漀爀琀 ⴀ 匀愀氀攀 ⴀ 堀琀爀愀渀搀猀ഀഀ
਍ഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 愀挀琀椀漀渀开开挀 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䈀攀 䈀愀挀欀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀⤀ 愀渀搀 ⠀ 爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 匀愀氀攀✀⤀ ഀഀ
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] in ('56','57','58','59','26','22','52','54')))਍ऀ⤀ഀഀ
		Insert into ਍ऀ    ⌀匀愀氀攀堀琀爀愀渀搀猀ഀഀ
		SELECT਍ऀऀ 猀氀⸀䜀䌀䰀䤀䐀开开挀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
		, 'Import - Sales - Xtrands' AS ConversionName਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 ⠀琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀 䤀匀 一唀䰀䰀⤀ 吀䠀䔀一 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ䌀䄀匀吀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ ഀഀ
			  ELSE  FORMAT(DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')਍ऀऀऀ  䔀一䐀 䄀匀 䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀ഀഀ
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN (DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) ਍ऀऀऀ  䔀䰀匀䔀  ⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀⤀⤀ഀഀ
			  END AS dateTimeG਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀 㴀 　 漀爀 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀 椀猀 渀甀氀氀 吀䠀䔀一 ✀　⸀　　✀ഀഀ
			ELSE format(task.QuotedPrice, N'#.##') ਍ऀऀऀ䔀一䐀 䄀匀 䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀ഀഀ
		, 'USD' AS ConversionCurrency਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId਍ऀऀ眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀ 䄀一䐀 猀氀⸀䜀䌀䰀䤀䐀开开挀 䤀匀 一伀吀 一唀䰀䰀㬀 ഀഀ
਍ⴀⴀⴀ䤀洀瀀漀爀琀 ⴀ 匀愀氀攀 ⴀ 堀琀爀愀渀搀猀 倀氀甀猀ഀഀ
਍ഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 愀挀琀椀漀渀开开挀 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䈀攀 䈀愀挀欀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀⤀ 愀渀搀 ⠀ 爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 匀愀氀攀✀⤀ ഀഀ
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] in ('28','69','29','40','15','16','30','39','10','1','65','23','61','24','60','64')))਍ऀ⤀ഀഀ
		Insert into ਍ऀ    ⌀匀愀氀攀堀琀爀愀渀搀猀倀氀甀猀ഀഀ
		SELECT਍ऀऀ 猀氀⸀䜀䌀䰀䤀䐀开开挀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
		, 'Import - Sales - Xtrands Plus' AS ConversionName਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 ⠀琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀 䤀匀 一唀䰀䰀⤀ 吀䠀䔀一 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ䌀䄀匀吀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ ഀഀ
			  ELSE  FORMAT(DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')਍ऀऀऀ  䔀一䐀 䄀匀 䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀ഀഀ
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN (DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) ਍ऀऀऀ  䔀䰀匀䔀  ⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀⤀⤀ഀഀ
			  END AS dateTimeG਍ऀऀⰀ 䌀䄀匀䔀 圀䠀䔀一 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀 㴀 　 漀爀 琀愀猀欀⸀儀甀漀琀攀搀倀爀椀挀攀 椀猀 渀甀氀氀 吀䠀䔀一 ✀　⸀　　✀ഀഀ
			ELSE format(task.QuotedPrice, N'#.##') ਍ऀऀऀ䔀一䐀 䄀匀 䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀ഀഀ
		, 'USD' AS ConversionCurrency਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId਍ऀऀ眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀ 䄀一䐀 猀氀⸀䜀䌀䰀䤀䐀开开挀 䤀匀 一伀吀 一唀䰀䰀㬀 ഀഀ
਍ഀഀ
	---Sale Unknown਍ऀഀഀ
	With task as (਍ऀ匀䔀䰀䔀䌀吀 椀搀 吀愀猀欀椀搀Ⰰ倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ匀愀氀攀吀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀开开挀 猀愀氀攀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀Ⰰഀഀ
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)਍ऀ䄀匀 刀漀眀一甀洀ഀഀ
	FROM [ODS].[SFDC_Task] b਍ऀ眀栀攀爀攀 愀挀琀椀漀渀开开挀 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䈀攀 䈀愀挀欀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀⤀ 愀渀搀 ⠀ 爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 匀愀氀攀✀⤀ ഀഀ
	and ([SaleTypeCode__c] is null or ([SaleTypeCode__c] in ('73','78')))਍ऀ⤀ഀഀ
		Insert into ਍ऀ    ⌀匀愀氀攀唀渀欀渀漀眀渀ഀഀ
		SELECT਍ऀऀ 猀氀⸀䜀䌀䰀䤀䐀开开挀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
		, 'Unknown' AS ConversionName਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 ⠀琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀 䤀匀 一唀䰀䰀 愀渀搀 琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀 渀漀琀 氀椀欀攀 ✀─一唀䰀䰀─✀⤀ 吀䠀䔀一 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ䌀䄀匀吀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ ഀഀ
			  WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c is NULL) THEN FORMAT(DATEADD(MINUTE,5,task.[ActivityDate]),'MM/dd/yyyy hh:mm:ss.00 tt')਍ऀऀऀ  䔀䰀匀䔀  䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀⤀Ⰰ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ഀഀ
			  END AS ConversionTime਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 ⠀琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀 䤀匀 一唀䰀䰀 愀渀搀 琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀 渀漀琀 氀椀欀攀 ✀─一唀䰀䰀─✀⤀ 吀䠀䔀一 ⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ䌀䄀匀吀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀⤀ ഀഀ
			  WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c is NULL) THEN (DATEADD(MINUTE,5,task.[ActivityDate]))਍ऀऀऀ  䔀䰀匀䔀  ⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ㔀Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀愀猀欀⸀嬀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀崀⤀⤀⤀ഀഀ
			  END AS dateTimeG਍ऀऀⰀ ✀　⸀　　✀ 䄀匀 䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀ഀഀ
		, 'USD' AS ConversionCurrency਍ऀऀ䘀刀伀䴀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开䰀攀愀搀 猀氀ഀഀ
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId਍ऀऀ眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀ 䄀一䐀 猀氀⸀䜀䌀䰀䤀䐀开开挀 䤀匀 一伀吀 一唀䰀䰀㬀 ഀഀ
਍ऀⴀⴀⴀ唀渀椀漀渀 吀愀戀氀攀猀ഀഀ
	਍ऀ䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
	   #FunnelTable਍ऀ匀攀氀攀挀琀 ⨀ ഀഀ
	FROM #Contact਍ऀ甀渀椀漀渀 愀氀氀ഀഀ
	Select * ਍ऀ䘀爀漀洀 ⌀䰀攀愀搀ഀഀ
	Union all਍ऀ匀攀氀攀挀琀 ⨀ഀഀ
	From #Appointment਍ऀ唀渀椀漀渀 愀氀氀ഀഀ
	Select *਍ऀ䘀爀漀洀 ⌀匀栀漀眀ഀഀ
	Union all਍ऀ匀攀氀攀挀琀 ⨀ ഀഀ
	from #Sale਍ऀ唀渀椀漀渀 愀氀氀ഀഀ
	Select * ਍ऀ昀爀漀洀 ⌀匀愀氀攀䔀堀吀ഀഀ
	Union all਍ऀ匀攀氀攀挀琀 ⨀ ഀഀ
	from #SaleFUE਍ऀ唀渀椀漀渀 愀氀氀ഀഀ
	Select * ਍ऀ昀爀漀洀 ⌀匀愀氀攀䘀唀吀ഀഀ
	Union all਍ऀ匀攀氀攀挀琀 ⨀ ഀഀ
	from #SaleXtrands਍ऀ唀渀椀漀渀 愀氀氀ഀഀ
	Select * ਍ऀ昀爀漀洀 ⌀匀愀氀攀堀琀爀愀渀搀猀倀氀甀猀ഀഀ
	Union all਍ऀ匀攀氀攀挀琀 ⨀ ഀഀ
	from #SaleUnknown;਍ഀഀ
	insert into਍ऀ嬀伀䐀匀崀⸀嬀䜀漀漀最氀攀崀ഀഀ
	select ਍ऀ搀椀猀琀椀渀挀琀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
      ,[ConversionName]਍      Ⰰ嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀ഀഀ
      ,[ConversionValue]਍      Ⰰ嬀䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀崀ഀഀ
	  ,[dateTimeG] from #FunnelTable਍ഀഀ
਍䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䌀漀渀琀愀挀琀ഀഀ
DROP TABLE #Lead਍䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
DROP TABLE #Show਍䐀刀伀倀 吀䄀䈀䰀䔀 ⌀匀愀氀攀ഀഀ
DROP TABLE #SaleUnknown਍䐀刀伀倀 吀䄀䈀䰀䔀 ⌀匀愀氀攀䔀堀吀ഀഀ
DROP TABLE #SaleFUE਍䐀刀伀倀 吀䄀䈀䰀䔀 ⌀匀愀氀攀䘀唀吀ഀഀ
DROP TABLE #SaleXtrands਍䐀刀伀倀 吀䄀䈀䰀䔀 ⌀匀愀氀攀堀琀爀愀渀搀猀倀氀甀猀ഀഀ
DROP TABLE #FunnelTable਍䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䤀猀䤀渀瘀愀氀椀搀ഀഀ
਍ഀഀ
END਍䜀伀ഀഀ
