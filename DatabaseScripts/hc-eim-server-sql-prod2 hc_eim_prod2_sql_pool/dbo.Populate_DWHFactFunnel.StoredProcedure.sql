/****** Object:  StoredProcedure [dbo].[Populate_DWHFactFunnel]    Script Date: 3/23/2022 10:16:58 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀搀戀漀崀⸀嬀倀漀瀀甀氀愀琀攀开䐀圀䠀䘀愀挀琀䘀甀渀渀攀氀崀 䄀匀ഀ
BEGIN਍    ⴀⴀ 匀䔀吀 一伀䌀伀唀一吀 伀一 愀搀搀攀搀 琀漀 瀀爀攀瘀攀渀琀 攀砀琀爀愀 爀攀猀甀氀琀 猀攀琀猀 昀爀漀洀ഀ
    -- interfering with SELECT statements.਍    匀䔀吀 一伀䌀伀唀一吀 伀一ഀ
਍琀爀甀渀挀愀琀攀 琀愀戀氀攀 搀戀漀⸀䘀愀挀琀䘀甀渀渀攀氀ഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀ䤀一匀䔀刀吀ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀ
਍挀爀攀愀琀攀 吀愀戀氀攀 ⌀䰀攀愀搀ഀ
      (਍          䘀愀挀琀䐀愀琀攀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          FactDate datetime,਍          䰀攀愀搀䤀䐀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          LeadKey varchar(100),਍          䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀ
          [Accountkey] varchar(100),਍          䄀挀挀漀甀渀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          ContactID varchar(50),਍          䌀甀猀琀漀洀攀爀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          Membershipkey varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          FunnelStepKey varchar(20),਍          䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀ
          CenterKey varchar(100),਍          䌀攀渀琀攀爀䤀䐀  瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          CenterNumber varchar(100),਍          䤀猀嘀愀氀椀搀䰀攀愀搀 戀椀琀ഀ
      )਍ഀ
      create Table #Appointment਍      ⠀ഀ
          FactDateKey varchar(100),਍          䘀愀挀琀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀ
          LeadID varchar(100),਍          䰀攀愀搀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          LeadCreatedDate datetime,਍          嬀䄀挀挀漀甀渀琀欀攀礀崀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          AccountID varchar(50),਍          䌀漀渀琀愀挀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          CustomerID varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀欀攀礀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          MembershipID varchar(50),਍          䘀甀渀渀攀氀匀琀攀瀀䬀攀礀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀ
          FunnelStep varchar(20),਍          䌀攀渀琀攀爀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          CenterID  varchar(50),਍          䌀攀渀琀攀爀一甀洀戀攀爀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          IsValidLead bit਍      ⤀ഀ
਍            挀爀攀愀琀攀 吀愀戀氀攀 ⌀匀栀漀眀ഀ
      (਍          䘀愀挀琀䐀愀琀攀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          FactDate datetime,਍          䰀攀愀搀䤀䐀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          LeadKey varchar(100),਍          䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀ
          [Accountkey] varchar(100),਍          䄀挀挀漀甀渀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          ContactID varchar(50),਍          䌀甀猀琀漀洀攀爀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          Membershipkey varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          FunnelStepKey varchar(20),਍          䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀ
          CenterKey varchar(100),਍          䌀攀渀琀攀爀䤀䐀  瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          CenterNumber varchar(100),਍          䤀猀嘀愀氀椀搀䰀攀愀搀 戀椀琀ഀ
      )਍ഀ
            create Table #NB਍      ⠀ഀ
          FactDateKey varchar(100),਍          䘀愀挀琀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀ
          LeadID varchar(100),਍          䰀攀愀搀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          LeadCreatedDate datetime,਍          嬀䄀挀挀漀甀渀琀欀攀礀崀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          AccountID varchar(50),਍          䌀漀渀琀愀挀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          CustomerID varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀欀攀礀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          MembershipID varchar(50),਍          䘀甀渀渀攀氀匀琀攀瀀䬀攀礀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀ
          FunnelStep varchar(20),਍          䌀攀渀琀攀爀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          CenterID  varchar(50),਍          䌀攀渀琀攀爀一甀洀戀攀爀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          IsValidLead bit਍      ⤀ഀ
਍            挀爀攀愀琀攀 吀愀戀氀攀 ⌀倀䌀倀ഀ
      (਍          䘀愀挀琀䐀愀琀攀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          FactDate datetime,਍          䰀攀愀搀䤀䐀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          LeadKey varchar(100),਍          䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀ
          [Accountkey] varchar(100),਍          䄀挀挀漀甀渀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          ContactID varchar(50),਍          䌀甀猀琀漀洀攀爀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          Membershipkey varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          FunnelStepKey varchar(20),਍          䘀甀渀渀攀氀匀琀攀瀀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀ
          CenterKey varchar(100),਍          䌀攀渀琀攀爀䤀䐀  瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          CenterNumber varchar(100),਍          䤀猀嘀愀氀椀搀䰀攀愀搀 戀椀琀ഀ
      )਍ഀ
            create Table #FactFunnelTable਍      ⠀ഀ
          FactDateKey varchar(100),਍          䘀愀挀琀䐀愀琀攀 搀愀琀攀琀椀洀攀Ⰰഀ
          LeadID varchar(100),਍          䰀攀愀搀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          LeadCreatedDate datetime,਍          嬀䄀挀挀漀甀渀琀欀攀礀崀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          AccountID varchar(50),਍          䌀漀渀琀愀挀琀䤀䐀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          CustomerID varchar(50),਍          䴀攀洀戀攀爀猀栀椀瀀欀攀礀 瘀愀爀挀栀愀爀⠀㔀　⤀Ⰰഀ
          MembershipID varchar(50),਍          䘀甀渀渀攀氀匀琀攀瀀䬀攀礀 瘀愀爀挀栀愀爀⠀㈀　⤀Ⰰഀ
          FunnelStep varchar(20),਍          䌀攀渀琀攀爀䬀攀礀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          CenterID  varchar(50),਍          䌀攀渀琀攀爀一甀洀戀攀爀 瘀愀爀挀栀愀爀⠀㄀　　⤀Ⰰഀ
          IsValidLead bit਍      ⤀ഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀ
---LEAD਍      䤀渀猀攀爀琀 椀渀琀漀 ⌀䰀攀愀搀ഀ
      Select਍      搀琀⸀䐀愀琀攀䬀攀礀 䄀匀 䘀愀挀琀䐀愀琀攀䬀攀礀ഀ
      ,dateadd(mi,datepart(tz,CONVERT(datetime,dl.[LeadCreatedDateUTC])    AT TIME ZONE 'Eastern Standard Time'),dl.[LeadCreatedDateUTC]) AS FactDate਍      Ⰰ搀氀⸀䰀攀愀搀䤀䐀ഀ
      ,dl.LeadKey਍      Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ搀氀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ搀氀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀崀⤀ 䄀匀 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀ഀ
      ,NULL AS [Accountkey]਍      Ⰰ搀氀⸀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀 䄀匀 䄀挀挀漀甀渀琀䤀䐀ഀ
      ,null AS ContactID਍      Ⰰ一唀䰀䰀 䄀匀 䌀甀猀琀漀洀攀爀䤀䐀ഀ
      ,NULL AS Membershipkey਍      Ⰰ一唀䰀䰀 䄀匀 䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀ
      ,fs.FunnelStepKey਍      Ⰰ✀䰀攀愀搀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀ഀ
      , cntr.[CenterKey]਍      Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀䤀䐀崀ഀ
      , cntr.[CenterNumber]਍      Ⰰ搀氀⸀䤀猀嘀愀氀椀搀 愀猀 䤀猀嘀愀氀椀搀䰀攀愀搀ഀ
      FROM [dbo].[VWLead] dl਍      氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀䐀椀洀䘀甀渀渀攀氀匀琀攀瀀崀 昀猀ഀ
      on fs.[FunnelStepName] = 'Lead'਍    䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀攀渀琀攀爀崀 挀渀琀爀ഀ
    ON cntr.[CenterKey] = dl.Centerkey਍    䰀䔀䘀吀 䨀伀䤀一 搀戀漀⸀䐀椀洀䐀愀琀攀 搀琀ഀ
    ON dt.FullDate = convert(date,dateadd(mi,datepart(tz,CONVERT(datetime,dl.[LeadCreatedDateUTC])    AT TIME ZONE 'Eastern Standard Time'),dl.[LeadCreatedDateUTC]));਍ഀ
਍ⴀⴀ䄀倀倀伀䤀一吀䴀䔀一吀ഀ
      With task as (਍        匀䔀䰀䔀䌀吀 䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀 吀愀猀欀椀搀Ⰰ椀猀渀甀氀氀⠀愀⸀氀攀愀搀椀搀Ⰰ搀⸀䰀攀愀搀䤀搀⤀ 愀猀 氀攀愀搀椀搀Ⰰ愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀Ⰰ愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀Ⰰ䘀愀挀琀䐀愀琀攀Ⰰ愀⸀䐀圀䠀开䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀Ⰰ愀⸀愀挀挀漀甀渀琀椀搀Ⰰ愀⸀攀砀琀攀爀渀愀氀吀愀猀欀䤀䐀Ⰰഀ
        ROW_NUMBER() OVER(PARTITION BY isnull(a.leadid,d.LeadId) ORDER BY a.AppointmentDate ASC)਍        䄀匀 刀漀眀一甀洀ഀ
        FROM dbo.FactAppointment a਍        氀攀昀琀 䨀伀䤀一 搀戀漀⸀䐀椀洀䰀攀愀搀 猀氀 漀渀 愀⸀䰀攀愀搀䤀搀㴀猀氀⸀氀攀愀搀椀搀ഀ
        left join dimaccount c on a.accountid=c.accountid਍        氀攀昀琀 樀漀椀渀 搀椀洀氀攀愀搀 搀 漀渀 挀⸀愀挀挀漀甀渀琀椀搀㴀搀⸀挀漀渀瘀攀爀琀攀搀愀挀挀漀甀渀琀椀搀ഀ
        )਍            䤀渀猀攀爀琀 椀渀琀漀ഀ
           #Appointment਍            匀䔀䰀䔀䌀吀ഀ
            dt.DateKey AS FactDateKey਍          Ⰰ 琀愀猀欀⸀䘀愀挀琀䐀愀琀攀 䄀匀 䘀愀挀琀䐀愀琀攀ഀ
          ,dl.LeadID਍          Ⰰ搀氀⸀䰀攀愀搀䬀攀礀ഀ
          ,dateadd(mi,datepart(tz,CONVERT(datetime,dl.[LeadCreatedDateUTC])    AT TIME ZONE 'Eastern Standard Time'),dl.[LeadCreatedDateUTC]) AS LeadCreatedDate਍          Ⰰ一唀䰀䰀 䄀匀 嬀䄀挀挀漀甀渀琀欀攀礀崀ഀ
          ,dl.ConvertedAccountId AS AccountID਍          Ⰰ渀甀氀氀 䄀匀 䌀漀渀琀愀挀琀䤀䐀ഀ
          ,NULL AS CustomerID਍          Ⰰ一唀䰀䰀 䄀匀 䴀攀洀戀攀爀猀栀椀瀀欀攀礀ഀ
          ,NULL AS MembershipID਍          Ⰰ昀猀⸀䘀甀渀渀攀氀匀琀攀瀀䬀攀礀ഀ
          ,'Appointment' as FunnelStep਍          Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀䬀攀礀崀ഀ
          , cntr.[CenterID]਍          Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀一甀洀戀攀爀崀ഀ
          ,dl.IsValid as IsValidLead਍            䘀刀伀䴀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀崀 搀氀ഀ
            left join [dbo].[DimFunnelStep] fs਍            漀渀 昀猀⸀嬀䘀甀渀渀攀氀匀琀攀瀀一愀洀攀崀 㴀 ✀䄀瀀瀀漀椀渀琀洀攀渀琀✀ഀ
            INNER JOIN task on dl.LeadID = task.leadid਍            䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䐀愀琀攀崀 搀琀ഀ
            ON dt.FullDate = cast(task.FactDate as date)਍      䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀攀渀琀攀爀崀 挀渀琀爀ഀ
      ON cntr.[CenterKey] = dl.Centerkey਍            眀栀攀爀攀 琀愀猀欀⸀爀漀眀渀甀洀㴀㄀㬀ഀ
਍ ⴀⴀⴀ匀䠀伀圀ഀ
਍       圀椀琀栀 琀愀猀欀 愀猀 ⠀ഀ
            SELECT b.OpportunityId Taskid,b.LeadId,b.OpportunityStatus,b.AppointmentDate as FactDate,b.accountid,externaltaskid,਍            刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 戀⸀䰀攀愀搀䤀搀Ⰰ戀⸀愀挀挀漀甀渀琀椀搀 伀刀䐀䔀刀 䈀夀 戀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀 䄀匀䌀⤀ഀ
            AS RowNum਍            䘀刀伀䴀 搀戀漀⸀嘀圀䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀 戀ഀ
਍            ⤀ഀ
            Insert into਍          ⌀匀栀漀眀ഀ
            SELECT਍            搀琀⸀䐀愀琀攀䬀攀礀 䄀匀 䘀愀挀琀䐀愀琀攀䬀攀礀ഀ
          ,task.FactDate AS FactDate਍          Ⰰ搀氀⸀䰀攀愀搀䤀䐀ഀ
          ,dl.LeadKey਍          Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ搀氀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ搀氀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀崀⤀ 䄀匀 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀ഀ
          ,NULL AS [Accountkey]਍          Ⰰ搀氀⸀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀 䄀匀 䄀挀挀漀甀渀琀䤀䐀ഀ
          ,null AS ContactID਍          Ⰰ一唀䰀䰀 䄀匀 䌀甀猀琀漀洀攀爀䤀䐀ഀ
          ,NULL AS Membershipkey਍          Ⰰ一唀䰀䰀 䄀匀 䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀ
          ,fs.FunnelStepKey਍          Ⰰ✀匀栀漀眀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀ഀ
          , cntr.[CenterKey]਍          Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀䤀䐀崀ഀ
          , cntr.[CenterNumber]਍          Ⰰ搀氀⸀䤀猀嘀愀氀椀搀 愀猀 䤀猀嘀愀氀椀搀䰀攀愀搀ഀ
            FROM [dbo].[VWLead] dl਍            氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀䐀椀洀䘀甀渀渀攀氀匀琀攀瀀崀 昀猀ഀ
            on fs.[FunnelStepName] = 'Show'਍            䤀一一䔀刀 䨀伀䤀一 琀愀猀欀 漀渀 搀氀⸀䰀攀愀搀䤀䐀 㴀 琀愀猀欀⸀䰀攀愀搀䤀搀ഀ
            LEFT JOIN [dbo].[DimDate] dt਍            伀一 搀琀⸀䘀甀氀氀䐀愀琀攀 㴀 挀愀猀琀⠀琀愀猀欀⸀䘀愀挀琀䐀愀琀攀 愀猀 搀愀琀攀⤀ഀ
      LEFT JOIN [dbo].[DimCenter] cntr਍      伀一 挀渀琀爀⸀嬀䌀攀渀琀攀爀䬀攀礀崀 㴀 搀氀⸀䌀攀渀琀攀爀欀攀礀ഀ
            where task.rownum=1 and task.Taskid is not null;਍ഀ
-----NB਍      眀椀琀栀 洀攀洀戀攀爀猀栀椀瀀 愀猀 ⠀ഀ
            SELECT ROW_NUMBER() OVER ( PARTITION BY clt.[SalesforceContactID], rg.RevenueGroupDescription ORDER BY cm.BeginDate, cm.EndDate ) AS 'RowID'਍            Ⰰ ✀䘀椀爀猀琀 ✀ ⬀ 爀最⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 ⬀ ✀ 䴀攀洀戀攀爀猀栀椀瀀✀ 䄀匀 ✀䐀愀琀愀✀ഀ
            , clt.CenterID਍            Ⰰ 挀氀琀⸀䌀氀椀攀渀琀䤀搀攀渀琀椀昀椀攀爀ഀ
            , clt.ClientFullNameAltCalc਍            Ⰰ 爀最⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 䄀匀 ✀䘀甀渀渀攀氀匀琀攀瀀✀ഀ
            , cm.BeginDate਍            Ⰰ 搀琀⸀䐀愀琀攀䬀攀礀 愀猀 ✀䘀愀挀琀䐀愀琀攀䬀攀礀✀ഀ
            , cm.EndDate਍            Ⰰ 挀洀⸀䌀愀渀挀攀氀䐀愀琀攀ഀ
            , cm.MonthlyFee਍            Ⰰ 挀氀琀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀ഀ
            ,clt.ClientGUID਍            Ⰰ 搀洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀ
            , dm.MembershipKey਍            䘀刀伀䴀 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀崀 挀洀ഀ
            INNER JOIN [ODS].[CNCT_cfgMembership] m਍            伀一 洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀 㴀 挀洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀ
            INNER JOIN [ODS].[CNCT_RevenueGroup] rg਍            伀一 爀最⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀 㴀 洀⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀ഀ
            INNER JOIN [ODS].[CNCT_lkpBusinessSegment] bs਍            伀一 戀猀⸀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀 㴀 洀⸀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀ഀ
            INNER JOIN [ODS].[CNCT_lkpClientMembershipStatus] cms਍            伀一 挀洀猀⸀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀䤀䐀 㴀 挀洀⸀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀䤀䐀ഀ
            INNER JOIN [ODS].[CNCT_datClient] clt਍            伀一 挀氀琀⸀䌀氀椀攀渀琀䜀唀䤀䐀 㴀 挀洀⸀䌀氀椀攀渀琀䜀唀䤀䐀ഀ
      LEFT JOIN [dbo].[DimDate] dt਍      伀一 搀琀⸀䘀甀氀氀䐀愀琀攀 㴀 挀洀⸀䈀攀最椀渀䐀愀琀攀ഀ
      left JOIN[dbo].[DimMembership]  dm਍            伀一 洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀 㴀 搀洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀ
            WHERE rg.RevenueGroupDescriptionShort = 'NB' and (([MembershipShortName] not like 's%' and [MembershipName] not like 'New%') or [MembershipName] not like 'Retail') and਍                  䐀䴀⸀䴀攀洀戀攀爀猀栀椀瀀匀栀漀爀琀一愀洀攀 一伀吀 䤀一 ⠀ ✀匀䠀伀圀匀䄀䰀䔀✀Ⰰ ✀匀䠀伀圀一伀匀䄀䰀䔀✀Ⰰ ✀匀一匀匀唀刀䜀伀䘀䘀✀Ⰰ ✀刀䔀吀䄀䤀䰀✀Ⰰ ✀䠀䌀䘀䬀✀Ⰰ ✀一伀一倀䜀䴀✀Ⰰ ✀䴀伀䐀䔀䰀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀䔀✀Ⰰ ✀䔀䴀倀䰀伀夀䔀堀吀✀Ⰰ ✀䴀伀䐀䔀䰀䔀堀吀✀Ⰰ✀䔀䴀倀䰀伀夀䔀䔀㘀✀ ⤀ഀ
      )਍ഀ
਍ഀ
      Insert into਍            ⌀一䈀ഀ
            SELECT਍            洀⸀䘀愀挀琀䐀愀琀攀䬀攀礀ഀ
          , m.BeginDate AS FactDate਍          Ⰰ搀氀⸀䰀攀愀搀䤀䐀ഀ
          ,dl.LeadKey਍          Ⰰ搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ搀氀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ搀氀⸀嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀唀吀䌀崀⤀ 䄀匀 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀ഀ
          ,NULL AS [Accountkey]਍          Ⰰ搀氀⸀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀 䄀匀 䄀挀挀漀甀渀琀䤀䐀ഀ
          ,null AS ContactID਍          Ⰰ挀甀⸀嬀䌀甀猀琀漀洀攀爀䤀搀攀渀琀椀昀椀攀爀崀 䄀匀 䌀甀猀琀漀洀攀爀䤀䐀ഀ
          , m.MembershipID਍          Ⰰ 洀⸀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀ഀ
          ,fs.FunnelStepKey਍          Ⰰ✀一䈀✀ 愀猀 䘀甀渀渀攀氀匀琀攀瀀ഀ
          , cntr.[Centerkey] as [CenterKey]਍          Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀䤀搀崀 愀猀 嬀䌀攀渀琀攀爀䤀䐀崀ഀ
          , cntr.[CenterNumber]਍          Ⰰ搀氀⸀䤀猀嘀愀氀椀搀 愀猀 䤀猀嘀愀氀椀搀䰀攀愀搀ഀ
            FROM [dbo].[VWLead] dl਍            氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀䐀椀洀䘀甀渀渀攀氀匀琀攀瀀崀 昀猀ഀ
            on fs.[FunnelStepName] = 'NB'਍            䤀一一䔀刀 䨀伀䤀一 洀攀洀戀攀爀猀栀椀瀀 洀ഀ
            on isnull(dl.LeadID,dl.ConvertedAccountId) = m.[SalesforceContactID]਍      䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀甀猀琀漀洀攀爀崀 挀甀ഀ
      ON cu.[CustomerGUID] = m.ClientGUID਍      䰀䔀䘀吀 䨀伀䤀一 嬀搀戀漀崀⸀嬀䐀椀洀䌀攀渀琀攀爀崀 挀渀琀爀ഀ
      ON cu.[CenterKey] = cntr.Centerkey਍      眀栀攀爀攀 洀⸀刀漀眀䤀䐀㴀㄀ 㬀ഀ
਍ⴀⴀⴀⴀ倀䌀倀ഀ
਍      眀椀琀栀 洀攀洀戀攀爀猀栀椀瀀 愀猀 ⠀ഀ
          SELECT ROW_NUMBER() OVER ( PARTITION BY clt.[SalesforceContactID], rg.RevenueGroupDescription ORDER BY cm.BeginDate, cm.EndDate ) AS 'RowID'਍          Ⰰ ✀䘀椀爀猀琀 ✀ ⬀ 爀最⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 ⬀ ✀ 䴀攀洀戀攀爀猀栀椀瀀✀ 䄀匀 ✀䐀愀琀愀✀ഀ
          , clt.CenterID਍          Ⰰ 挀氀琀⸀䌀氀椀攀渀琀䤀搀攀渀琀椀昀椀攀爀ഀ
          , clt.ClientFullNameAltCalc਍          Ⰰ 爀最⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 䄀匀 ✀䘀甀渀渀攀氀匀琀攀瀀✀ഀ
          , cm.BeginDate਍          Ⰰ 搀琀⸀䐀愀琀攀䬀攀礀 愀猀 ✀䘀愀挀琀䐀愀琀攀䬀攀礀✀ഀ
          , cm.EndDate਍          Ⰰ 挀洀⸀䌀愀渀挀攀氀䐀愀琀攀ഀ
          , cm.MonthlyFee਍          Ⰰ 挀氀琀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀ഀ
          , dm.MembershipID਍          Ⰰ 搀洀⸀䴀攀洀戀攀爀猀栀椀瀀䬀攀礀ഀ
          ,clt.ClientGUID਍          䘀刀伀䴀 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀崀 挀洀ഀ
      INNER JOIN [ODS].[CNCT_cfgMembership] m਍          伀一 洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀 㴀 挀洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀ
      INNER JOIN [ODS].[CNCT_RevenueGroup] rg਍          伀一 爀最⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀 㴀 洀⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀ഀ
      INNER JOIN [ODS].[CNCT_lkpBusinessSegment] bs਍          伀一 戀猀⸀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀 㴀 洀⸀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀ഀ
      INNER JOIN [ODS].[CNCT_lkpClientMembershipStatus] cms਍          伀一 挀洀猀⸀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀䤀䐀 㴀 挀洀⸀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀匀琀愀琀甀猀䤀䐀ഀ
      INNER JOIN [ODS].[CNCT_datClient] clt਍          伀一 挀氀琀⸀䌀氀椀攀渀琀䜀唀䤀䐀 㴀 挀洀⸀䌀氀椀攀渀琀䜀唀䤀䐀ഀ
      LEFT JOIN [dbo].[DimDate] dt਍      伀一 搀琀⸀䘀甀氀氀䐀愀琀攀 㴀 挀洀⸀䈀攀最椀渀䐀愀琀攀ഀ
      left JOIN[dbo].[DimMembership]  dm਍          伀一 洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀 㴀 搀洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀ
          WHERE rg.RevenueGroupDescriptionShort = 'PCP' and (([MembershipShortName] not like 's%' and [MembershipName] not like 'New%') or [MembershipName] not like 'Retail')਍      ⤀ഀ
਍      䤀渀猀攀爀琀 椀渀琀漀ഀ
            #PCP਍            匀䔀䰀䔀䌀吀ഀ
            m.FactDateKey਍          Ⰰ 洀⸀䈀攀最椀渀䐀愀琀攀 䄀匀 䘀愀挀琀䐀愀琀攀ഀ
          ,dl.LeadID਍          Ⰰ搀氀⸀䰀攀愀搀䬀攀礀ഀ
          ,dateadd(mi,datepart(tz,CONVERT(datetime,dl.[LeadCreatedDateUTC])    AT TIME ZONE 'Eastern Standard Time'),dl.[LeadCreatedDateUTC]) AS LeadCreatedDate਍          Ⰰ 一唀䰀䰀 䄀匀 嬀䄀挀挀漀甀渀琀欀攀礀崀ഀ
          , dl.ConvertedAccountId AS AccountID਍          Ⰰ 渀甀氀氀 䄀匀 䌀漀渀琀愀挀琀䤀䐀ഀ
          , cu.[CustomerIdentifier] AS CustomerID਍          Ⰰ 洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀ
          , m.MembershipKey਍          Ⰰ 昀猀⸀䘀甀渀渀攀氀匀琀攀瀀䬀攀礀ഀ
          ,'PCP' as FunnelStep਍          Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀欀攀礀崀 愀猀 嬀䌀攀渀琀攀爀䬀攀礀崀ഀ
          , cntr.[CenterId] as [CenterID]਍          Ⰰ 挀渀琀爀⸀嬀䌀攀渀琀攀爀一甀洀戀攀爀崀ഀ
          ,dl.IsValid as IsValidLead਍      䘀刀伀䴀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀崀 搀氀ഀ
      left join [dbo].[DimFunnelStep] fs਍          漀渀 昀猀⸀嬀䘀甀渀渀攀氀匀琀攀瀀一愀洀攀崀 㴀 ✀倀䌀倀✀ഀ
      inner JOIN membership m਍            漀渀 椀猀渀甀氀氀⠀搀氀⸀䰀攀愀搀䤀䐀Ⰰ搀氀⸀䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀⤀ 㴀 洀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀ഀ
      LEFT JOIN [dbo].[DimCustomer] cu਍          伀一 挀甀⸀嬀䌀甀猀琀漀洀攀爀䜀唀䤀䐀崀 㴀 洀⸀䌀氀椀攀渀琀䜀唀䤀䐀ഀ
      LEFT JOIN [dbo].[DimCenter] cntr਍        伀一 挀渀琀爀⸀嬀䌀攀渀琀攀爀䬀攀礀崀 㴀 挀甀⸀䌀攀渀琀攀爀欀攀礀ഀ
    where m.RowID=1;਍ഀ
਍ⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀⴀഀ
਍      䤀渀猀攀爀琀 椀渀琀漀ഀ
         #FactFunnelTable਍      匀攀氀攀挀琀 ⨀ഀ
      From #Lead਍      唀渀椀漀渀 愀氀氀ഀ
      Select *਍      䘀爀漀洀 ⌀䄀瀀瀀漀椀渀琀洀攀渀琀ഀ
      Union all਍      匀攀氀攀挀琀 ⨀ഀ
      From #Show਍      唀渀椀漀渀 愀氀氀ഀ
      Select *਍      昀爀漀洀 ⌀一䈀ഀ
      Union all਍      匀攀氀攀挀琀 ⨀ഀ
      from #PCP;਍ഀ
਍      椀渀猀攀爀琀 椀渀琀漀 嬀搀戀漀崀⸀嬀䘀愀挀琀䘀甀渀渀攀氀崀ഀ
      select਍       嬀䘀愀挀琀䐀愀琀攀欀攀礀崀ഀ
      ,[FactDate]਍      Ⰰ嬀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀崀ഀ
      ,[Leadkey]਍      Ⰰ嬀䰀攀愀搀䤀搀崀ഀ
      ,[Accountkey]਍      Ⰰ嬀䄀挀挀漀甀渀琀䤀搀崀ഀ
      ,[ContactId]਍      Ⰰ嬀䌀甀猀琀漀洀攀爀䤀搀崀ഀ
      ,[Membershipkey]਍      Ⰰ嬀䴀攀洀戀攀爀猀栀椀瀀䤀搀崀ഀ
      ,[FunnelStepKey]਍      Ⰰ嬀䘀甀渀渀攀氀匀琀攀瀀崀ഀ
      ,[CenterKey]਍      Ⰰ嬀䌀攀渀琀攀爀䤀䐀崀ഀ
      ,[CenterNumber]਍      Ⰰ嬀䤀猀瘀愀氀椀搀䰀攀愀搀崀ഀ
      from #FactFunnelTable਍ഀ
਍ഀ
਍      䐀刀伀倀 吀䄀䈀䰀䔀 ⌀䰀攀愀搀ഀ
      DROP TABLE #Appointment਍      䐀刀伀倀 吀䄀䈀䰀䔀 ⌀匀栀漀眀ഀ
      DROP TABLE #NB਍      䐀刀伀倀 吀䄀䈀䰀䔀 ⌀倀䌀倀ഀ
      DROP TABLE #FactFunnelTable਍ഀ
END਍䜀伀ഀഀ
