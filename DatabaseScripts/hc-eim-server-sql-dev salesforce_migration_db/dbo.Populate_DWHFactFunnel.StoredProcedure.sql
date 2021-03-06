/****** Object:  StoredProcedure [dbo].[Populate_DWHFactFunnel]    Script Date: 1/10/2022 10:03:12 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀搀戀漀崀⸀嬀倀漀瀀甀氀愀琀攀开䐀圀䠀䘀愀挀琀䘀甀渀渀攀氀崀 䄀匀ഀഀ
BEGIN਍    ⴀⴀ 匀䔀吀 一伀䌀伀唀一吀 伀一 愀搀搀攀搀 琀漀 瀀爀攀瘀攀渀琀 攀砀琀爀愀 爀攀猀甀氀琀 猀攀琀猀 昀爀漀洀ഀഀ
    -- interfering with SELECT statements.਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀഀ
਍    ⴀⴀ 䤀渀猀攀爀琀 猀琀愀琀攀洀攀渀琀猀 昀漀爀 瀀爀漀挀攀搀甀爀攀 栀攀爀攀ഀഀ
    CREATE Table #NewLeads(਍䤀搀䰀攀愀搀 瘀愀爀挀栀愀爀⠀㔀　⤀ഀഀ
)਍ഀഀ
insert into਍  ⌀一攀眀䰀攀愀搀猀ഀഀ
Select sl.Leadid from [dbo].[DimLead] sl਍眀栀攀爀攀 挀愀猀琀⠀猀氀⸀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀 愀猀 搀愀琀攀⤀ 㴀 䐀䄀吀䔀䄀䐀䐀⠀䐀䄀夀Ⰰ ⴀ㄀Ⰰ 䌀愀猀琀⠀䜀䔀吀䐀䄀吀䔀⠀⤀ 愀猀 搀愀琀攀⤀⤀ ഀഀ
union਍匀攀氀攀挀琀 猀琀⸀眀栀漀椀搀 昀爀漀洀 嬀栀挀ⴀ猀焀氀瀀漀漀氀ⴀ攀椀洀ⴀ瀀爀漀搀ⴀ攀甀猀㈀崀⸀伀䐀匀⸀匀䘀䐀䌀开吀愀猀欀 猀琀ഀഀ
where cast(st.LastModifiedDate as date) = DATEADD(DAY, -1, Cast(GETDATE() as date)) ਍ഀഀ
Delete from [dbo].[FactFunnel]਍眀栀攀爀攀 䰀攀愀搀䤀搀 椀渀 ⠀匀攀氀攀挀琀 ⨀ 昀爀漀洀 ⌀一攀眀䰀攀愀搀猀⤀ഀഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀ䤀一匀䔀刀吀ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀഀ
਍挀爀攀愀琀攀 吀愀戀氀攀 ⌀䰀攀愀搀ഀഀ
      (਍          䘀愀挀琀䐀愀琀攀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          FactDate datetime,਍          䰀攀愀搀䤀䐀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          LeadKey varchar(100),਍      䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
          [Accountkey] varchar(100),਍          䄀挀挀漀甀渀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          ContactID varchar(50),਍          䌀甀猀琀漀洀攀爀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          Membershipkey varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          FunnelStepKey varchar(20),਍          䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
          CenterKey varchar(100),਍          䌀攀渀琀攀爀䤀䐀  瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          CenterNumber varchar(100),਍          䤀猀嘀愀氀椀搀䰀攀愀搀 戀椀琀ഀഀ
      )਍      ഀഀ
      create Table #Appointment਍      ⠀ഀഀ
          FactDateKey varchar(100),਍          䘀愀挀琀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
          LeadID varchar(100),਍          䰀攀愀搀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          LeadCreatedDate datetime,਍          嬀䄀挀挀漀甀渀琀欀攀礀崀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          AccountID varchar(50),਍          䌀漀渀琀愀挀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          CustomerID varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀欀攀礀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          MembershipID varchar(50),਍          䘀甀渀渀攀氀匀琀攀瀀䬀攀礀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
          FunnelStep varchar(20),਍          䌀攀渀琀攀爀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          CenterID  varchar(50),਍          䌀攀渀琀攀爀一甀洀戀攀爀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          IsValidLead bit਍      ⤀ഀഀ
਍            挀爀攀愀琀攀 吀愀戀氀攀 ⌀匀栀漀眀ഀഀ
      (਍          䘀愀挀琀䐀愀琀攀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          FactDate datetime,਍          䰀攀愀搀䤀䐀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          LeadKey varchar(100),਍          䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
          [Accountkey] varchar(100),਍          䄀挀挀漀甀渀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          ContactID varchar(50),਍          䌀甀猀琀漀洀攀爀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          Membershipkey varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          FunnelStepKey varchar(20),਍          䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
          CenterKey varchar(100),਍          䌀攀渀琀攀爀䤀䐀  瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          CenterNumber varchar(100),਍          䤀猀嘀愀氀椀搀䰀攀愀搀 戀椀琀ഀഀ
      )਍ഀഀ
            create Table #NB਍      ⠀ഀഀ
          FactDateKey varchar(100),਍          䘀愀挀琀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
          LeadID varchar(100),਍          䰀攀愀搀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          LeadCreatedDate datetime,਍          嬀䄀挀挀漀甀渀琀欀攀礀崀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          AccountID varchar(50),਍          䌀漀渀琀愀挀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          CustomerID varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀欀攀礀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          MembershipID varchar(50),਍          䘀甀渀渀攀氀匀琀攀瀀䬀攀礀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
          FunnelStep varchar(20),਍          䌀攀渀琀攀爀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          CenterID  varchar(50),਍          䌀攀渀琀攀爀一甀洀戀攀爀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          IsValidLead bit਍      ⤀ഀഀ
਍            挀爀攀愀琀攀 吀愀戀氀攀 ⌀倀䌀倀ഀഀ
      (਍          䘀愀挀琀䐀愀琀攀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          FactDate datetime,਍          䰀攀愀搀䤀䐀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          LeadKey varchar(100),਍          䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
          [Accountkey] varchar(100),਍          䄀挀挀漀甀渀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          ContactID varchar(50),਍          䌀甀猀琀漀洀攀爀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          Membershipkey varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          FunnelStepKey varchar(20),਍          䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
          CenterKey varchar(100),਍          䌀攀渀琀攀爀䤀䐀  瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          CenterNumber varchar(100),਍          䤀猀嘀愀氀椀搀䰀攀愀搀 戀椀琀ഀഀ
      )਍ഀഀ
            create Table #FactFunnelTable਍      ⠀ഀഀ
          FactDateKey varchar(100),਍          䘀愀挀琀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀഀ
          LeadID varchar(100),਍          䰀攀愀搀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          LeadCreatedDate datetime,਍          嬀䄀挀挀漀甀渀琀欀攀礀崀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          AccountID varchar(50),਍          䌀漀渀琀愀挀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          CustomerID varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀欀攀礀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀഀ
          MembershipID varchar(50),਍          䘀甀渀渀攀氀匀琀攀瀀䬀攀礀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀഀ
          FunnelStep varchar(20),਍          䌀攀渀琀攀爀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          CenterID  varchar(50),਍          䌀攀渀琀攀爀一甀洀戀攀爀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀഀ
          IsValidLead bit਍      ⤀ഀഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀഀ
---LEAD਍      䤀渀猀攀爀琀 椀渀琀漀 ⌀䰀攀愀搀ഀഀ
      Select ਍      搀氀⸀嬀䌀爀攀愀琀攀搀䐀愀琀攀䬀攀礀崀 䄀匀 䘀愀挀琀䐀愀琀攀䬀攀礀ഀഀ
      ,dl.[LeadCreatedDate] AS FactDate਍      Ⰰ搀氀⸀䰀攀愀搀䤀䐀 ഀഀ
      ,dl.LeadKey਍      Ⰰ搀氀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀 䄀匀 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀ഀഀ
    ,NULL AS [Accountkey] ਍    Ⰰ搀氀⸀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀 䄀匀 䄀挀挀漀甀渀琀䤀䐀 ഀഀ
    ,dl.ConvertedContactId AS ContactID ਍    Ⰰ一唀䰀䰀 䄀匀 䌀甀猀琀漀洀攀爀䤀䐀 ഀഀ
    ,NULL AS Membershipkey ਍    Ⰰ一唀䰀䰀 䄀匀 䴀攀洀戀攀爀猀栀椀瀀䤀䐀 ഀഀ
    ,fs.FunnelStepKey਍    Ⰰ✀䰀攀愀搀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀ഀഀ
      , cntr.[CenterKey]਍      Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀䤀䐀崀ഀഀ
      , cntr.[CenterNumber]਍      Ⰰ搀氀⸀䤀猀嘀愀氀椀搀 愀猀 䤀猀嘀愀氀椀搀䰀攀愀搀 ഀഀ
      FROM [dbo].[DimLead] dl਍      氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀䐀椀洀䘀甀渀渀攀氀匀琀攀瀀崀 昀猀ഀഀ
      on fs.[FunnelStepName] = 'Lead'਍    䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀攀渀琀攀爀崀 挀渀琀爀ഀഀ
    ON cntr.[CenterKey] = dl.Centerkey਍  眀栀攀爀攀 搀氀⸀䰀攀愀搀䤀䐀 椀渀 ⠀猀攀氀攀挀琀 䤀䐀䰀攀愀搀 昀爀漀洀 ⌀一攀眀䰀攀愀搀猀⤀㬀ഀഀ
਍ഀഀ
--APPOINTMENT਍      圀椀琀栀 琀愀猀欀 愀猀 ⠀ഀഀ
      SELECT PriceQuoted__c QuotedPrice,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,[CreatedDate],਍      刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 戀⸀圀栀漀䤀搀 伀刀䐀䔀刀 䈀夀 愀挀琀椀瘀椀琀礀䐀愀琀攀 䄀匀䌀⤀ഀഀ
      AS RowNum਍      䘀刀伀䴀 嬀伀䐀匀崀⸀嬀匀䘀䐀䌀开吀愀猀欀崀 戀ഀഀ
      where trim(action__c) in ('Appointment','In House','Be Back') and result__c <> 'Void'਍      ⤀ഀഀ
            Insert into ਍           ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
            SELECT਍            搀琀⸀䐀愀琀攀䬀攀礀 䄀匀 䘀愀挀琀䐀愀琀攀䬀攀礀ഀഀ
          ,CASE WHEN (task.starttime__c not like '%NULL%') THEN cast(concat(left(task.ActivityDate,11),task.StartTime__c) as datetime)਍            䔀䰀匀䔀 琀愀猀欀⸀愀挀琀椀瘀椀琀礀搀愀琀攀 ഀഀ
            END AS FactDate਍          Ⰰ搀氀⸀䰀攀愀搀䤀䐀 ഀഀ
          ,dl.LeadKey਍          Ⰰ搀氀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀 䄀匀 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀ഀഀ
          ,NULL AS [Accountkey] ਍          Ⰰ搀氀⸀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀 䄀匀 䄀挀挀漀甀渀琀䤀䐀 ഀഀ
          ,dl.ConvertedContactId AS ContactID ਍          Ⰰ一唀䰀䰀 䄀匀 䌀甀猀琀漀洀攀爀䤀䐀 ഀഀ
          ,NULL AS Membershipkey ਍          Ⰰ一唀䰀䰀 䄀匀 䴀攀洀戀攀爀猀栀椀瀀䤀䐀 ഀഀ
          ,fs.FunnelStepKey਍          Ⰰ✀䄀瀀瀀漀椀渀琀洀攀渀琀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀 ഀഀ
      , cntr.[CenterKey]਍      Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀䤀䐀崀ഀഀ
      , cntr.[CenterNumber]਍          Ⰰ搀氀⸀䤀猀嘀愀氀椀搀 愀猀 䤀猀嘀愀氀椀搀䰀攀愀搀 ഀഀ
            FROM [dbo].[DimLead] dl਍            氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀䐀椀洀䘀甀渀渀攀氀匀琀攀瀀崀 昀猀ഀഀ
            on fs.[FunnelStepName] = 'Appointment'਍            䤀一一䔀刀 䨀伀䤀一 琀愀猀欀 漀渀 椀猀渀甀氀氀⠀搀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀Ⰰ搀氀⸀䰀攀愀搀䤀䐀⤀ 㴀 琀愀猀欀⸀眀栀漀椀搀 ഀഀ
            LEFT JOIN [dbo].[DimDate] dt਍            伀一 搀琀⸀䘀甀氀氀䐀愀琀攀 㴀 挀愀猀琀⠀琀愀猀欀⸀愀挀琀椀瘀椀琀礀搀愀琀攀 愀猀 搀愀琀攀⤀ഀഀ
      LEFT JOIN [dbo].[DimCenter] cntr਍      伀一 挀渀琀爀⸀嬀䌀攀渀琀攀爀䬀攀礀崀 㴀 搀氀⸀䌀攀渀琀攀爀欀攀礀ഀഀ
            where task.rownum=1 and dl.LeadID in (select IDLead from #NewLeads);਍ഀഀ
 ---SHOW     ਍      ഀഀ
      With task as (਍      匀䔀䰀䔀䌀吀 倀爀椀挀攀儀甀漀琀攀搀开开挀 儀甀漀琀攀搀倀爀椀挀攀Ⰰ戀⸀圀栀漀䤀搀Ⰰ刀攀猀甀氀琀开开挀 刀攀猀甀氀琀Ⰰ䄀挀琀椀漀渀开开挀 䄀挀琀椀漀渀Ⰰ匀琀愀爀琀吀椀洀攀开开挀Ⰰ 愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰ嬀䌀爀攀愀琀攀搀䐀愀琀攀崀Ⰰഀഀ
      ROW_NUMBER() OVER(PARTITION BY b.WhoId ORDER BY activityDate ASC)਍      䄀匀 刀漀眀一甀洀ഀഀ
      FROM [ODS].[SFDC_Task] b਍      眀栀攀爀攀 愀挀琀椀漀渀开开挀 椀渀 ⠀✀䄀瀀瀀漀椀渀琀洀攀渀琀✀Ⰰ✀䈀攀 䈀愀挀欀✀Ⰰ✀䤀渀 䠀漀甀猀攀✀⤀ 愀渀搀 ⠀爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 一漀 匀愀氀攀✀ 漀爀 爀攀猀甀氀琀开开挀㴀✀匀栀漀眀 匀愀氀攀✀⤀ ഀഀ
      )਍            䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
          #Show਍            匀䔀䰀䔀䌀吀ഀഀ
            dt.DateKey AS FactDateKey਍          Ⰰ䌀䄀匀䔀 圀䠀䔀一 ⠀琀愀猀欀⸀猀琀愀爀琀琀椀洀攀开开挀 渀漀琀 氀椀欀攀 ✀─一唀䰀䰀─✀⤀ 吀䠀䔀一 挀愀猀琀⠀挀漀渀挀愀琀⠀氀攀昀琀⠀琀愀猀欀⸀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰ㄀㄀⤀Ⰰ琀愀猀欀⸀匀琀愀爀琀吀椀洀攀开开挀⤀ 愀猀 搀愀琀攀琀椀洀攀⤀ഀഀ
          ELSE task.activitydate ਍          䔀一䐀 䄀匀 䘀愀挀琀䐀愀琀攀ഀഀ
          ,dl.LeadID ਍          Ⰰ搀氀⸀䰀攀愀搀䬀攀礀ഀഀ
          ,dl.[LeadCreatedDate] AS LeadCreatedDate਍          Ⰰ一唀䰀䰀 䄀匀 嬀䄀挀挀漀甀渀琀欀攀礀崀 ഀഀ
          ,dl.ConvertedAccountId AS AccountID ਍          Ⰰ搀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀 䄀匀 䌀漀渀琀愀挀琀䤀䐀 ഀഀ
          ,NULL AS CustomerID ਍          Ⰰ一唀䰀䰀 䄀匀 䴀攀洀戀攀爀猀栀椀瀀欀攀礀 ഀഀ
          ,NULL AS MembershipID ਍          Ⰰ昀猀⸀䘀甀渀渀攀氀匀琀攀瀀䬀攀礀ഀഀ
          ,'Show' as FunnelStep ਍      Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀䬀攀礀崀ഀഀ
      , cntr.[CenterID]਍      Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀一甀洀戀攀爀崀ഀഀ
          ,dl.IsValid as IsValidLead ਍            䘀刀伀䴀 嬀搀戀漀崀⸀嬀䐀椀洀䰀攀愀搀崀 搀氀ഀഀ
            left join [dbo].[DimFunnelStep] fs਍            漀渀 昀猀⸀嬀䘀甀渀渀攀氀匀琀攀瀀一愀洀攀崀 㴀 ✀匀栀漀眀✀ഀഀ
            INNER JOIN task on isnull(dl.ConvertedContactId,dl.LeadID) = task.whoid ਍            䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䐀愀琀攀崀 搀琀ഀഀ
            ON dt.FullDate = cast(task.activitydate as date)਍      䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀攀渀琀攀爀崀 挀渀琀爀ഀഀ
      ON cntr.[CenterKey] = dl.Centerkey਍            眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀ 愀渀搀 搀氀⸀䰀攀愀搀䤀䐀 椀渀 ⠀猀攀氀攀挀琀 䤀䐀䰀攀愀搀 昀爀漀洀 ⌀一攀眀䰀攀愀搀猀⤀㬀ഀഀ
਍ⴀⴀⴀⴀⴀ一䈀ഀഀ
      with membership as (਍            匀䔀䰀䔀䌀吀 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 倀䄀刀吀䤀吀䤀伀一 䈀夀 挀氀琀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀Ⰰ 爀最⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䐀攀猀挀爀椀瀀琀椀漀渀 伀刀䐀䔀刀 䈀夀 挀洀⸀䈀攀最椀渀䐀愀琀攀Ⰰ 挀洀⸀䔀渀搀䐀愀琀攀 ⤀ 䄀匀 ✀刀漀眀䤀䐀✀ഀഀ
            , 'First ' + rg.RevenueGroupDescriptionShort + ' Membership' AS 'Data'਍            Ⰰ 挀氀琀⸀䌀攀渀琀攀爀䤀䐀ഀഀ
            , clt.ClientIdentifier਍            Ⰰ 挀氀琀⸀䌀氀椀攀渀琀䘀甀氀氀一愀洀攀䄀氀琀䌀愀氀挀ഀഀ
            , rg.RevenueGroupDescriptionShort AS 'FunnelStep'਍            Ⰰ 挀洀⸀䈀攀最椀渀䐀愀琀攀ഀഀ
      , dt.DateKey as 'FactDateKey'਍            Ⰰ 挀洀⸀䔀渀搀䐀愀琀攀ഀഀ
            , cm.CancelDate਍            Ⰰ 挀洀⸀䴀漀渀琀栀氀礀䘀攀攀ഀഀ
            , clt.[SalesforceContactID]਍      Ⰰ挀氀琀⸀䌀氀椀攀渀琀䜀唀䤀䐀ഀഀ
      , dm.MembershipID਍      Ⰰ 搀洀⸀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀ഀഀ
            FROM [ODS].[CNCT_datClientMembership] cm਍            䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开挀昀最䴀攀洀戀攀爀猀栀椀瀀崀 洀ഀഀ
            ON m.MembershipID = cm.MembershipID਍            䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开刀攀瘀攀渀甀攀䜀爀漀甀瀀崀 爀最ഀഀ
            ON rg.RevenueGroupID = m.RevenueGroupID਍            䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀崀 戀猀ഀഀ
            ON bs.BusinessSegmentID = m.BusinessSegmentID਍            䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀崀 挀洀猀ഀഀ
            ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID਍            䤀一一䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀崀 挀氀琀ഀഀ
            ON clt.ClientGUID = cm.ClientGUID਍      䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䐀愀琀攀崀 搀琀ഀഀ
      ON dt.FullDate = cm.BeginDate਍      氀攀昀琀 䨀伀䤀一嬀搀戀漀崀⸀嬀䐀椀洀䴀攀洀戀攀爀猀栀椀瀀崀  搀洀ഀഀ
            ON m.MembershipID = dm.MembershipID਍            圀䠀䔀刀䔀 爀最⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 㴀 ✀一䈀✀ 愀渀搀 ⠀⠀嬀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀崀 渀漀琀 氀椀欀攀 ✀猀─✀ 愀渀搀 嬀䴀攀洀戀攀爀猀栀椀瀀一愀洀攀崀 渀漀琀 氀椀欀攀 ✀一攀眀─✀⤀ 漀爀 嬀䴀攀洀戀攀爀猀栀椀瀀一愀洀攀崀 渀漀琀 氀椀欀攀 ✀刀攀琀愀椀氀✀⤀ഀഀ
      )਍ഀഀ
      Insert into ਍            ⌀一䈀ഀഀ
            SELECT਍            洀⸀䘀愀挀琀䐀愀琀攀䬀攀礀ഀഀ
          , m.BeginDate AS FactDate਍          Ⰰ搀氀⸀䰀攀愀搀䤀䐀 ഀഀ
          ,dl.LeadKey਍          Ⰰ搀氀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀 䄀匀 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀ഀഀ
          ,NULL AS [Accountkey] ਍          Ⰰ搀氀⸀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀 䄀匀 䄀挀挀漀甀渀琀䤀䐀 ഀഀ
          ,dl.ConvertedContactId AS ContactID ਍          Ⰰ挀甀⸀嬀䌀甀猀琀漀洀攀爀䤀搀攀渀琀椀昀椀攀爀崀 䄀匀 䌀甀猀琀漀洀攀爀䤀䐀 ഀഀ
      , m.MembershipID਍      Ⰰ 洀⸀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀ഀഀ
          ,fs.FunnelStepKey਍          Ⰰ✀一䈀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀ഀഀ
      , cntr.[Centerkey] as [CenterKey]਍      Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀䤀搀崀 愀猀 嬀䌀攀渀琀攀爀䤀䐀崀ഀഀ
      , cntr.[CenterNumber]਍          Ⰰ搀氀⸀䤀猀嘀愀氀椀搀 愀猀 䤀猀嘀愀氀椀搀䰀攀愀搀 ഀഀ
            FROM [dbo].[DimLead] dl਍            氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀䐀椀洀䘀甀渀渀攀氀匀琀攀瀀崀 昀猀ഀഀ
            on fs.[FunnelStepName] = 'NB'਍            䤀一一䔀刀 䨀伀䤀一 洀攀洀戀攀爀猀栀椀瀀 洀ഀഀ
            on isnull(dl.ConvertedContactId,dl.LeadID) = m.[SalesforceContactID]਍      䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀甀猀琀漀洀攀爀崀 挀甀ഀഀ
      ON cu.[CustomerGUID] = m.ClientGUID਍      䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀攀渀琀攀爀崀 挀渀琀爀ഀഀ
      ON cu.[CenterKey] = cntr.Centerkey਍      眀栀攀爀攀 洀⸀刀漀眀䤀䐀㴀㄀ 愀渀搀 搀氀⸀䰀攀愀搀䤀䐀 椀渀 ⠀猀攀氀攀挀琀 䤀䐀䰀攀愀搀 昀爀漀洀 ⌀一攀眀䰀攀愀搀猀⤀㬀ഀഀ
਍ⴀⴀⴀⴀ倀䌀倀ഀഀ
਍      眀椀琀栀 洀攀洀戀攀爀猀栀椀瀀 愀猀 ⠀ഀഀ
          SELECT ROW_NUMBER() OVER ( PARTITION BY clt.[SalesforceContactID], rg.RevenueGroupDescription ORDER BY cm.BeginDate, cm.EndDate ) AS 'RowID'਍          Ⰰ ✀䘀椀爀猀琀 ✀ ⬀ 爀最⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 ⬀ ✀ 䴀攀洀戀攀爀猀栀椀瀀✀ 䄀匀 ✀䐀愀琀愀✀ഀഀ
          , clt.CenterID਍          Ⰰ 挀氀琀⸀䌀氀椀攀渀琀䤀搀攀渀琀椀昀椀攀爀ഀഀ
          , clt.ClientFullNameAltCalc਍          Ⰰ 爀最⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 䄀匀 ✀䘀甀渀渀攀氀匀琀攀瀀✀ഀഀ
      , cm.BeginDate਍      Ⰰ 搀琀⸀䐀愀琀攀䬀攀礀 愀猀 ✀䘀愀挀琀䐀愀琀攀䬀攀礀✀ഀഀ
      , cm.EndDate਍      Ⰰ 挀洀⸀䌀愀渀挀攀氀䐀愀琀攀ഀഀ
          , cm.MonthlyFee਍          Ⰰ 挀氀琀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀ഀഀ
      , dm.MembershipID਍      Ⰰ 搀洀⸀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀ഀഀ
      ,clt.ClientGUID਍          䘀刀伀䴀 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀崀 挀洀ഀഀ
      INNER JOIN [ODS].[CNCT_cfgMembership] m਍          伀一 洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀 㴀 挀洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀഀ
      INNER JOIN [ODS].[CNCT_RevenueGroup] rg਍          伀一 爀最⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀 㴀 洀⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀ഀഀ
      INNER JOIN [ODS].[CNCT_lkpBusinessSegment] bs਍          伀一 戀猀⸀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀 㴀 洀⸀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀ഀഀ
      INNER JOIN [ODS].[CNCT_lkpClientMembershipStatus] cms਍          伀一 挀洀猀⸀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀䤀䐀 㴀 挀洀⸀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀䤀䐀ഀഀ
      INNER JOIN [ODS].[CNCT_datClient] clt਍          伀一 挀氀琀⸀䌀氀椀攀渀琀䜀唀䤀䐀 㴀 挀洀⸀䌀氀椀攀渀琀䜀唀䤀䐀ഀഀ
      LEFT JOIN [dbo].[DimDate] dt਍      伀一 搀琀⸀䘀甀氀氀䐀愀琀攀 㴀 挀洀⸀䈀攀最椀渀䐀愀琀攀ഀഀ
      left JOIN[dbo].[DimMembership]  dm਍          伀一 洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀 㴀 搀洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀഀ
          WHERE rg.RevenueGroupDescriptionShort = 'PCP' and (([MembershipShortName] not like 's%' and [MembershipName] not like 'New%') or [MembershipName] not like 'Retail')਍      ⤀ഀഀ
਍      䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
            #PCP਍            匀䔀䰀䔀䌀吀ഀഀ
            m.FactDateKey਍          Ⰰ 洀⸀䈀攀最椀渀䐀愀琀攀 䄀匀 䘀愀挀琀䐀愀琀攀ഀഀ
          ,dl.LeadID ਍          Ⰰ搀氀⸀䰀攀愀搀䬀攀礀ഀഀ
          ,dl.[LeadCreatedDate] AS LeadCreatedDate਍          Ⰰ一唀䰀䰀 䄀匀 嬀䄀挀挀漀甀渀琀欀攀礀崀 ഀഀ
          ,dl.ConvertedAccountId AS AccountID ਍          Ⰰ搀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀 䄀匀 䌀漀渀琀愀挀琀䤀䐀 ഀഀ
          ,cu.[CustomerIdentifier] AS CustomerID ਍          Ⰰ 洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀഀ
        , m.MembershipKey਍          Ⰰ昀猀⸀䘀甀渀渀攀氀匀琀攀瀀䬀攀礀ഀഀ
          ,'PCP' as FunnelStep ਍        Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀欀攀礀崀 愀猀 嬀䌀攀渀琀攀爀䬀攀礀崀ഀഀ
        , cntr.[CenterId] as [CenterID]਍        Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀一甀洀戀攀爀崀ഀഀ
          ,dl.IsValid as IsValidLead ਍      䘀刀伀䴀 嬀搀戀漀崀⸀嬀䐀椀洀䰀攀愀搀崀 搀氀ഀഀ
      left join [dbo].[DimFunnelStep] fs਍          漀渀 昀猀⸀嬀䘀甀渀渀攀氀匀琀攀瀀一愀洀攀崀 㴀 ✀倀䌀倀✀ഀഀ
      inner JOIN membership m਍            漀渀 椀猀渀甀氀氀⠀搀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀Ⰰ搀氀⸀䰀攀愀搀䤀䐀⤀ 㴀 洀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀ഀഀ
      LEFT JOIN [dbo].[DimCustomer] cu਍          伀一 挀甀⸀嬀䌀甀猀琀漀洀攀爀䜀唀䤀䐀崀 㴀 洀⸀䌀氀椀攀渀琀䜀唀䤀䐀ഀഀ
      LEFT JOIN [dbo].[DimCenter] cntr਍        伀一 挀渀琀爀⸀嬀䌀攀渀琀攀爀䬀攀礀崀 㴀 挀甀⸀䌀攀渀琀攀爀欀攀礀ഀഀ
    where m.RowID=1 and dl.LeadID in (select IDLead from #NewLeads);਍ഀഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀഀ
਍      䤀渀猀攀爀琀 椀渀琀漀 ഀഀ
         #FactFunnelTable਍      匀攀氀攀挀琀 ⨀ ഀഀ
      From #Lead਍      唀渀椀漀渀 愀氀氀ഀഀ
      Select *਍      䘀爀漀洀 ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
      Union all਍      匀攀氀攀挀琀 ⨀ഀഀ
      From #Show਍      唀渀椀漀渀 愀氀氀ഀഀ
      Select * ਍      昀爀漀洀 ⌀一䈀ഀഀ
      Union all਍      匀攀氀攀挀琀 ⨀ ഀഀ
      from #PCP;਍ഀഀ
਍      椀渀猀攀爀琀 椀渀琀漀 嬀搀戀漀崀⸀嬀䘀愀挀琀䘀甀渀渀攀氀崀ഀഀ
      select ਍     嬀䘀愀挀琀䐀愀琀攀欀攀礀崀ഀഀ
      ,[FactDate]਍      Ⰰ嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀ഀഀ
      ,[Leadkey]਍      Ⰰ嬀䰀攀愀搀䤀搀崀ഀഀ
      ,[Accountkey]਍      Ⰰ嬀䄀挀挀漀甀渀琀䤀搀崀ഀഀ
      ,[ContactId]਍      Ⰰ嬀䌀甀猀琀漀洀攀爀䤀搀崀ഀഀ
      ,[Membershipkey]਍      Ⰰ嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀ഀഀ
      ,[FunnelStepKey]਍      Ⰰ嬀䘀甀渀渀攀氀匀琀攀瀀崀ഀഀ
      ,[CenterKey]਍      Ⰰ嬀䌀攀渀琀攀爀䤀䐀崀ഀഀ
      ,[CenterNumber]਍      Ⰰ嬀䤀猀瘀愀氀椀搀䰀攀愀搀崀ഀഀ
      from #FactFunnelTable਍    ഀഀ
਍ഀഀ
      ਍      䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䰀攀愀搀ഀഀ
      DROP TABLE #Appointment਍      䐀刀伀倀 吀䄀䈀䰀䔀 ⌀匀栀漀眀ഀഀ
      DROP TABLE #NB਍      䐀刀伀倀 吀䄀䈀䰀䔀 ⌀倀䌀倀ഀഀ
      DROP TABLE #FactFunnelTable਍ऀ  䐀刀伀倀 吀䄀䈀䰀䔀 ⌀一攀眀䰀攀愀搀猀ഀഀ
END਍䜀伀ഀഀ
