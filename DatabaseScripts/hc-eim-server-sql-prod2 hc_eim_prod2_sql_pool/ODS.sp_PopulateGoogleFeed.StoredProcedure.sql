/****** Object:  StoredProcedure [ODS].[sp_PopulateGoogleFeed]    Script Date: 3/1/2022 8:53:37 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀伀䐀匀崀⸀嬀猀瀀开倀漀瀀甀氀愀琀攀䜀漀漀最氀攀䘀攀攀搀崀 䄀匀ഀഀ
TRUNCATE TABLE [Reports].[Google] ;਍ഀഀ
----Create tables----------਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀䌀漀渀琀愀挀琀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     嘀䄀刀䌀䠀䄀刀⠀㄀　　⤀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀䰀攀愀搀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     嘀䄀刀䌀䠀䄀刀⠀㄀　　⤀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀䄀瀀瀀漀椀渀琀洀攀渀琀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     嘀䄀刀䌀䠀䄀刀⠀㄀　　⤀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀匀栀漀眀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     嘀䄀刀䌀䠀䄀刀⠀㄀　　⤀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀匀愀氀攀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     嘀䄀刀䌀䠀䄀刀⠀㄀　　⤀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀匀愀氀攀唀渀欀渀漀眀渀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     嘀䄀刀䌀䠀䄀刀⠀㄀　　⤀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀匀愀氀攀䔀堀吀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     䐀䄀吀䔀吀䤀䴀䔀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀匀愀氀攀䘀唀䔀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     嘀䄀刀䌀䠀䄀刀⠀㄀　　⤀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀匀愀氀攀䘀唀吀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     嘀䄀刀䌀䠀䄀刀⠀㄀　　⤀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀匀愀氀攀堀琀爀愀渀搀猀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     嘀䄀刀䌀䠀䄀刀⠀㄀　　⤀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀匀愀氀攀堀琀爀愀渀搀猀倀氀甀猀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     嘀䄀刀䌀䠀䄀刀⠀㄀　　⤀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䌀刀䔀䄀吀䔀 吀䄀䈀䰀䔀 嬀⌀䘀甀渀渀攀氀吀愀戀氀攀崀ഀഀ
(਍    嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀      嘀䄀刀䌀䠀䄀刀⠀㈀　㐀㠀⤀ഀഀ
  , [ConversionName]     VARCHAR(1024)਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀     嘀䄀刀䌀䠀䄀刀⠀㄀　　⤀ഀഀ
  , [dateTimeG]          DATETIME਍  Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀    嘀䄀刀䌀䠀䄀刀⠀㄀　　　⤀ഀഀ
  , [ConversionCurrency] VARCHAR(10)਍⤀ 㬀ഀഀ
਍䤀一匀䔀刀吀 䤀一吀伀 嬀⌀䌀漀渀琀愀挀琀崀ഀഀ
SELECT਍    嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
  , 'Import - Contacts' AS [ConversionName]਍  Ⰰ 䘀伀刀䴀䄀吀⠀ഀഀ
        DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate])਍        Ⰰ ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀ഀഀ
  , DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate]) AS [dateTimeG]਍  Ⰰ ✀　⸀　　✀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀ഀഀ
  , 'USD' AS [ConversionCurrency]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀䐀椀洀䰀攀愀搀崀 䄀匀 嬀猀氀崀ഀഀ
WHERE [sl].[GCLID] IS NOT NULL ;਍ഀഀ
---Lead਍䤀一匀䔀刀吀 䤀一吀伀 嬀⌀䰀攀愀搀崀ഀഀ
SELECT਍    嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
  , 'Import - Leads' AS [ConversionName]਍  Ⰰ 䘀伀刀䴀䄀吀⠀ഀഀ
        DATEADD(MINUTE, 2, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate]))਍      Ⰰ ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀ഀഀ
  , DATEADD(MINUTE, 2, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate])) AS [dateTimeG]਍  Ⰰ ✀　⸀　　✀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀ഀഀ
  , 'USD' AS [ConversionCurrency]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀䐀椀洀䰀攀愀搀崀 䄀匀 嬀猀氀崀ഀഀ
WHERE [Isvalid] = '1' AND [sl].[GCLID] IS NOT NULL ;਍ഀഀ
--Appointment਍圀䤀吀䠀 嬀琀愀猀欀崀ഀഀ
AS ( SELECT਍         嬀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀崀 䄀匀 嬀吀愀猀欀椀搀崀ഀഀ
       , [b].[LeadId]਍       Ⰰ 嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀崀ഀഀ
       , [b].[AppointmentDate]਍       Ⰰ 嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
       , [b].[DWH_LastUpdateDate]਍       Ⰰ 嬀戀崀⸀嬀愀挀挀漀甀渀琀椀搀崀ഀഀ
       , [b].[externalTaskID]਍       Ⰰ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 倀䄀刀吀䤀吀䤀伀一 䈀夀 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀Ⰰ 嬀戀崀⸀嬀䄀挀挀漀甀渀琀䤀搀崀 伀刀䐀䔀刀 䈀夀 嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀 䄀匀䌀 ⤀ 䄀匀 嬀刀漀眀一甀洀崀ഀഀ
     FROM [dbo].[FactAppointment] AS [b] )਍䤀一匀䔀刀吀 䤀一吀伀 嬀⌀䄀瀀瀀漀椀渀琀洀攀渀琀崀ഀഀ
SELECT਍    嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
  , 'Import - Appointments' AS [ConversionName]਍  Ⰰ 䘀伀刀䴀䄀吀⠀ഀഀ
        DATEADD(MINUTE, 3, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate]))਍      Ⰰ ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀ഀഀ
  , DATEADD(MINUTE, 3, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate])) AS [dateTimeG]਍  Ⰰ ✀　⸀　　✀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀ഀഀ
  , 'USD' AS [ConversionCurrency]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀䐀椀洀䰀攀愀搀崀 䄀匀 嬀猀氀崀ഀഀ
INNER JOIN [task] ON ISNULL([sl].[ConvertedContactId], [sl].[LeadId]) = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId਍圀䠀䔀刀䔀 嬀琀愀猀欀崀⸀嬀刀漀眀一甀洀崀 㴀 ㄀ 䄀一䐀 嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䤀匀 一伀吀 一唀䰀䰀 㬀ഀഀ
਍ⴀⴀⴀ匀栀漀眀ഀഀ
WITH [task]਍䄀匀 ⠀ 匀䔀䰀䔀䌀吀ഀഀ
         [AppointmentId] AS [Taskid]਍       Ⰰ 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀ഀഀ
       , [b].[OpportunityStatus]਍       Ⰰ 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
       , [b].[DWH_LastUpdateDate]਍       Ⰰ 嬀戀崀⸀嬀愀挀挀漀甀渀琀椀搀崀ഀഀ
       , [externaltaskid]਍       Ⰰ 嬀戀崀⸀嬀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀ഀഀ
       , ROW_NUMBER() OVER ( PARTITION BY [b].[LeadId], [b].[accountid] ORDER BY [b].[FactDate] ASC ) AS [RowNum]਍     䘀刀伀䴀 嬀搀戀漀崀⸀嬀䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀崀 䄀匀 嬀戀崀 ⤀ഀഀ
INSERT INTO [#Show]਍匀䔀䰀䔀䌀吀ഀഀ
    [sl].[GCLID] AS [GoogleClickID]਍  Ⰰ ✀䤀洀瀀漀爀琀 ⴀ 匀栀漀眀猀✀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀一愀洀攀崀ഀഀ
  , FORMAT(DATEADD(MINUTE, 2, CAST([task].[FactDate] AS DATETIME)), 'MM/dd/yyyy hh:mm:ss.00 tt') AS [ConversionTime]਍  Ⰰ ⠀ 䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ ㈀Ⰰ 嬀琀愀猀欀崀⸀嬀䘀愀挀琀䐀愀琀攀崀⤀⤀ 䄀匀 嬀搀愀琀攀吀椀洀攀䜀崀ഀഀ
  , '0.00' AS [ConversionValue]਍  Ⰰ ✀唀匀䐀✀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀䌀甀爀爀攀渀挀礀崀ഀഀ
FROM [dbo].[DimLead] AS [sl]਍䤀一一䔀刀 䨀伀䤀一 嬀琀愀猀欀崀 伀一 䤀匀一唀䰀䰀⠀嬀猀氀崀⸀嬀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀崀Ⰰ 嬀猀氀崀⸀嬀䰀攀愀搀䤀搀崀⤀ 㴀 嬀琀愀猀欀崀⸀嬀䰀攀愀搀䤀搀崀 ⴀⴀ伀刀 猀氀⸀䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀 㴀 琀愀猀欀⸀圀栀漀䤀搀ഀഀ
WHERE [task].[RowNum] = 1 AND [sl].[GCLID] IS NOT NULL AND [task].[OpportunityId] IS NOT NULL ;਍ഀഀ
---Sale਍圀䤀吀䠀 嬀琀愀猀欀崀ഀഀ
AS ( SELECT਍         嬀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀崀 䄀匀 嬀吀愀猀欀椀搀崀ഀഀ
       , [b].[LeadId]਍       Ⰰ 嬀戀崀⸀嬀伀瀀瀀漀爀琀甀渀椀琀礀匀琀愀琀甀猀崀ഀഀ
       , [b].[FactDate]਍       Ⰰ 嬀戀崀⸀嬀䐀圀䠀开䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀崀ഀഀ
       , [b].[AppointmentStatus]਍       Ⰰ 嬀愀挀挀漀甀渀琀椀搀崀ഀഀ
       , [ExternalTaskId]਍       Ⰰ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 倀䄀刀吀䤀吀䤀伀一 䈀夀 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀Ⰰ 嬀愀挀挀漀甀渀琀椀搀崀 伀刀䐀䔀刀 䈀夀 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀 䄀匀䌀 ⤀ 䄀匀 嬀刀漀眀一甀洀崀ഀഀ
     FROM [dbo].[FactAppointment] AS [b] )਍䤀一匀䔀刀吀 䤀一吀伀 嬀⌀匀愀氀攀崀ഀഀ
SELECT਍    嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
  , 'Import - Sales' AS [ConversionName]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ 㐀Ⰰ 䌀䄀匀吀⠀䰀䔀䘀吀⠀嬀琀愀猀欀崀⸀嬀䘀愀挀琀䐀愀琀攀崀Ⰰ ㄀㄀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀ഀഀ
  , ( DATEADD(MINUTE, 4, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]਍  Ⰰ ✀　⸀　　✀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀ഀഀ
  , 'USD' AS [ConversionCurrency]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀䐀椀洀䰀攀愀搀崀 䄀匀 嬀猀氀崀ഀഀ
INNER JOIN [task] ON ISNULL([sl].[ConvertedContactId], [sl].[leadId]) = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId਍圀䠀䔀刀䔀 嬀琀愀猀欀崀⸀嬀刀漀眀一甀洀崀 㴀 ㄀ 䄀一䐀 嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䤀匀 一伀吀 一唀䰀䰀 䄀一䐀 嬀琀愀猀欀崀⸀嬀伀瀀瀀漀爀琀甀渀椀琀礀匀琀愀琀甀猀崀 㴀 ✀䌀氀漀猀攀搀 圀漀渀✀ 㬀ഀഀ
਍ⴀⴀⴀ䤀洀瀀漀爀琀 ⴀ 匀愀氀攀 ⴀ 䔀堀吀ഀഀ
WITH [task]਍䄀匀 ⠀ 匀䔀䰀䔀䌀吀ഀഀ
         [AppointmentId] AS [Taskid]਍       Ⰰ 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀ഀഀ
       , [b].[OpportunityStatus]਍       Ⰰ 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
       , [b].[DWH_LastUpdateDate]਍       Ⰰ 嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀崀ഀഀ
       , [b].[accountid]਍       Ⰰ 嬀䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀崀ഀഀ
       , [b].[OpportunityId]਍       Ⰰ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 倀䄀刀吀䤀吀䤀伀一 䈀夀 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀Ⰰ 嬀戀崀⸀嬀愀挀挀漀甀渀琀椀搀崀 伀刀䐀䔀刀 䈀夀 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀 䄀匀䌀 ⤀ 䄀匀 嬀刀漀眀一甀洀崀ഀഀ
     FROM [dbo].[FactAppointment] AS [b]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀崀 䄀匀 嬀挀氀琀崀 伀一 嬀挀氀琀崀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀 㴀 嬀戀崀⸀嬀氀攀愀搀椀搀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]਍                                                              䄀一䐀 䌀䄀匀吀⠀嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀 䄀匀 䐀䄀吀䔀⤀ 㴀 嬀搀挀洀崀⸀嬀䈀攀最椀渀䐀愀琀攀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀崀 䄀匀 嬀戀猀崀 圀䤀吀䠀⠀ 一伀䰀伀䌀䬀 ⤀伀一 嬀戀猀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 嬀洀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀ഀഀ
     WHERE [bs].[BusinessSegmentDescription] = 'Extreme Therapy' )਍䤀一匀䔀刀吀 䤀一吀伀 嬀⌀匀愀氀攀䔀堀吀崀ഀഀ
SELECT਍    嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
  , 'Import - Sales - EXT' AS [ConversionName]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ 㔀Ⰰ 䌀䄀匀吀⠀䰀䔀䘀吀⠀嬀琀愀猀欀崀⸀嬀䘀愀挀琀䐀愀琀攀崀Ⰰ ㄀㄀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ഀഀ
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䌀䄀匀吀⠀✀　⸀　　✀ 䄀匀 䘀䰀伀䄀吀⤀Ⰰ 一✀⌀⸀⌀⌀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀ഀഀ
  , 'USD' AS [ConversionCurrency]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀崀 䄀匀 嬀猀氀崀ഀഀ
INNER JOIN [task] ON [sl].[LeadId] = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId਍圀䠀䔀刀䔀 嬀琀愀猀欀崀⸀嬀刀漀眀一甀洀崀 㴀 ㄀ 䄀一䐀 嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䤀匀 一伀吀 一唀䰀䰀 䄀一䐀 嬀琀愀猀欀崀⸀嬀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀 䤀匀 一伀吀 一唀䰀䰀 㬀ഀഀ
਍ⴀⴀⴀ䤀洀瀀漀爀琀 ⴀ 匀愀氀攀 ⴀ 䘀漀氀氀椀挀甀氀愀爀 唀渀椀琀 䔀砀琀爀愀挀琀 ⠀䘀唀䔀⤀ഀഀ
WITH [task]਍䄀匀 ⠀ 匀䔀䰀䔀䌀吀ഀഀ
         [AppointmentId] AS [Taskid]਍       Ⰰ 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀ഀഀ
       , [b].[OpportunityStatus]਍       Ⰰ 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
       , [b].[DWH_LastUpdateDate]਍       Ⰰ 嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀崀ഀഀ
       , [b].[accountid]਍       Ⰰ 嬀䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀崀ഀഀ
       , [b].[OpportunityId]਍       Ⰰ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 倀䄀刀吀䤀吀䤀伀一 䈀夀 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀Ⰰ 嬀戀崀⸀嬀愀挀挀漀甀渀琀椀搀崀 伀刀䐀䔀刀 䈀夀 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀 䄀匀䌀 ⤀ 䄀匀 嬀刀漀眀一甀洀崀ഀഀ
     FROM [dbo].[FactAppointment] AS [b]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀崀 䄀匀 嬀挀氀琀崀 伀一 嬀挀氀琀崀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀 㴀 嬀戀崀⸀嬀氀攀愀搀椀搀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]਍                                                              䄀一䐀 䌀䄀匀吀⠀嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀 䄀匀 䐀䄀吀䔀⤀ 㴀 嬀搀挀洀崀⸀嬀䈀攀最椀渀䐀愀琀攀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀崀 䄀匀 嬀戀猀崀 圀䤀吀䠀⠀ 一伀䰀伀䌀䬀 ⤀伀一 嬀戀猀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 嬀洀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀ഀഀ
     WHERE [bs].[BusinessSegmentDescription] = 'Surgery' )਍䤀一匀䔀刀吀 䤀一吀伀 嬀⌀匀愀氀攀䘀唀䔀崀ഀഀ
SELECT਍    嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
  , 'Import - Sales - Follicular Unit Extract (FUE)' AS [ConversionName]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ 㔀Ⰰ 䌀䄀匀吀⠀䰀䔀䘀吀⠀嬀琀愀猀欀崀⸀嬀䘀愀挀琀䐀愀琀攀崀Ⰰ ㄀㄀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀ഀഀ
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䌀䄀匀吀⠀✀　⸀　　✀ 䄀匀 䘀䰀伀䄀吀⤀Ⰰ 一✀⌀⸀⌀⌀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀ഀഀ
  , 'USD' AS [ConversionCurrency]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀崀 䄀匀 嬀猀氀崀ഀഀ
INNER JOIN [task] ON [sl].[LeadId] = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId਍圀䠀䔀刀䔀 嬀琀愀猀欀崀⸀嬀刀漀眀一甀洀崀 㴀 ㄀ 䄀一䐀 嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䤀匀 一伀吀 一唀䰀䰀 䄀一䐀 嬀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀 䤀匀 一伀吀 一唀䰀䰀 㬀ഀഀ
਍ⴀⴀⴀ䤀洀瀀漀爀琀 ⴀ 匀愀氀攀 ⴀ 䘀漀氀氀椀挀甀氀愀爀 唀渀椀琀 吀爀愀渀猀瀀漀爀琀愀琀椀漀渀 ⠀䘀唀吀⤀ഀഀ
WITH [task]਍䄀匀 ⠀ 匀䔀䰀䔀䌀吀ഀഀ
         [AppointmentId] AS [Taskid]਍       Ⰰ 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀ഀഀ
       , [b].[OpportunityStatus]਍       Ⰰ 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
       , [b].[DWH_LastUpdateDate]਍       Ⰰ 嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀崀ഀഀ
       , [b].[accountid]਍       Ⰰ 嬀䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀崀ഀഀ
       , [b].[OpportunityId]਍       Ⰰ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 倀䄀刀吀䤀吀䤀伀一 䈀夀 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀Ⰰ 嬀戀崀⸀嬀愀挀挀漀甀渀琀椀搀崀 伀刀䐀䔀刀 䈀夀 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀 䄀匀䌀 ⤀ 䄀匀 嬀刀漀眀一甀洀崀ഀഀ
     FROM [dbo].[FactAppointment] AS [b]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀崀 䄀匀 嬀挀氀琀崀 伀一 嬀挀氀琀崀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀 㴀 嬀戀崀⸀嬀氀攀愀搀椀搀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]਍                                                              䄀一䐀 䌀䄀匀吀⠀嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀 䄀匀 䐀䄀吀䔀⤀ 㴀 嬀搀挀洀崀⸀嬀䈀攀最椀渀䐀愀琀攀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀崀 䄀匀 嬀戀猀崀 圀䤀吀䠀⠀ 一伀䰀伀䌀䬀 ⤀伀一 嬀戀猀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 嬀洀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀ഀഀ
     WHERE [bs].[BusinessSegmentDescription] = 'Surgery Complete' )਍䤀一匀䔀刀吀 䤀一吀伀 嬀⌀匀愀氀攀䘀唀吀崀ഀഀ
SELECT਍    䤀匀一唀䰀䰀⠀嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀Ⰰ ✀ ✀⤀ 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
  , 'Import - Sales - Follicular Unit Transportation (FUT)' AS [ConversionName]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ 㔀Ⰰ 䌀䄀匀吀⠀䰀䔀䘀吀⠀嬀琀愀猀欀崀⸀嬀䘀愀挀琀䐀愀琀攀崀Ⰰ ㄀㄀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀ഀഀ
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䌀䄀匀吀⠀✀　⸀　　✀ 䄀匀 䘀䰀伀䄀吀⤀Ⰰ 一✀⌀⸀⌀⌀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀ഀഀ
  , 'USD' AS [ConversionCurrency]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀崀 䄀匀 嬀猀氀崀ഀഀ
INNER JOIN [task] ON [sl].[LeadId] = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId਍圀䠀䔀刀䔀 嬀琀愀猀欀崀⸀嬀刀漀眀一甀洀崀 㴀 ㄀ 䄀一䐀 嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䤀匀 一伀吀 一唀䰀䰀 䄀一䐀 嬀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀 䤀匀 一伀吀 一唀䰀䰀 㬀ഀഀ
਍ⴀⴀⴀ䤀洀瀀漀爀琀 ⴀ 匀愀氀攀 ⴀ 堀琀爀愀渀搀猀ഀഀ
WITH [task]਍䄀匀 ⠀ 匀䔀䰀䔀䌀吀ഀഀ
         [AppointmentId] AS [Taskid]਍       Ⰰ 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀ഀഀ
       , [b].[OpportunityStatus]਍       Ⰰ 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
       , [b].[DWH_LastUpdateDate]਍       Ⰰ 嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀崀ഀഀ
       , [b].[accountid]਍       Ⰰ 嬀䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀崀ഀഀ
       , [b].[OpportunityId]਍       Ⰰ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 倀䄀刀吀䤀吀䤀伀一 䈀夀 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀Ⰰ 嬀戀崀⸀嬀愀挀挀漀甀渀琀椀搀崀 伀刀䐀䔀刀 䈀夀 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀 䄀匀䌀 ⤀ 䄀匀 嬀刀漀眀一甀洀崀ഀഀ
     FROM [dbo].[FactAppointment] AS [b]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀崀 䄀匀 嬀挀氀琀崀 伀一 嬀挀氀琀崀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀 㴀 嬀戀崀⸀嬀氀攀愀搀椀搀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]਍                                                              䄀一䐀 䌀䄀匀吀⠀嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀 䄀匀 䐀䄀吀䔀⤀ 㴀 嬀搀挀洀崀⸀嬀䈀攀最椀渀䐀愀琀攀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀崀 䄀匀 嬀戀猀崀 圀䤀吀䠀⠀ 一伀䰀伀䌀䬀 ⤀伀一 嬀戀猀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 嬀洀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀ഀഀ
     WHERE [bs].[BusinessSegmentDescription] = 'Xtrands' )਍䤀一匀䔀刀吀 䤀一吀伀 嬀⌀匀愀氀攀堀琀爀愀渀搀猀崀ഀഀ
SELECT਍    嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
  , 'Import - Sales - Xtrands' AS [ConversionName]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ 㔀Ⰰ 䌀䄀匀吀⠀䰀䔀䘀吀⠀嬀琀愀猀欀崀⸀嬀䘀愀挀琀䐀愀琀攀崀Ⰰ ㄀㄀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀ഀഀ
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䌀䄀匀吀⠀✀　⸀　　✀ 䄀匀 䘀䰀伀䄀吀⤀Ⰰ 一✀⌀⸀⌀⌀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀ഀഀ
  , 'USD' AS [ConversionCurrency]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀崀 䄀匀 嬀猀氀崀ഀഀ
INNER JOIN [task] ON [sl].[LeadId] = [task].[leadid] --OR sl.ConvertedContactId = task.WhoId਍圀䠀䔀刀䔀 嬀琀愀猀欀崀⸀嬀刀漀眀一甀洀崀 㴀 ㄀ 䄀一䐀 嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䤀匀 一伀吀 一唀䰀䰀 䄀一䐀 嬀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀 䤀匀 一伀吀 一唀䰀䰀 㬀ഀഀ
਍ⴀⴀⴀ䤀洀瀀漀爀琀 ⴀ 匀愀氀攀 ⴀ 堀琀爀愀渀搀猀 倀氀甀猀ഀഀ
WITH [task]਍䄀匀 ⠀ 匀䔀䰀䔀䌀吀ഀഀ
         [AppointmentId] AS [Taskid]਍       Ⰰ 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀ഀഀ
       , [b].[OpportunityStatus]਍       Ⰰ 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
       , [b].[DWH_LastUpdateDate]਍       Ⰰ 嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀崀ഀഀ
       , [b].[accountid]਍       Ⰰ 嬀䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀崀ഀഀ
       , [b].[OpportunityId]਍       Ⰰ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 倀䄀刀吀䤀吀䤀伀一 䈀夀 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀Ⰰ 嬀戀崀⸀嬀愀挀挀漀甀渀琀椀搀崀 伀刀䐀䔀刀 䈀夀 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀 䄀匀䌀 ⤀ 䄀匀 嬀刀漀眀一甀洀崀ഀഀ
     FROM [dbo].[FactAppointment] AS [b]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀崀 䄀匀 嬀挀氀琀崀 伀一 嬀挀氀琀崀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀 㴀 嬀戀崀⸀嬀氀攀愀搀椀搀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]਍                                                              䄀一䐀 䌀䄀匀吀⠀嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀 䄀匀 䐀䄀吀䔀⤀ 㴀 嬀搀挀洀崀⸀嬀䈀攀最椀渀䐀愀琀攀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀崀 䄀匀 嬀戀猀崀 圀䤀吀䠀⠀ 一伀䰀伀䌀䬀 ⤀伀一 嬀戀猀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 嬀洀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀ഀഀ
     WHERE [bs].[BusinessSegmentDescription] = 'Xtrands+' )਍䤀一匀䔀刀吀 䤀一吀伀 嬀⌀匀愀氀攀堀琀爀愀渀搀猀倀氀甀猀崀ഀഀ
SELECT਍    嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
  , 'Import - Sales - Xtrands Plus' AS [ConversionName]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ 㔀Ⰰ 䌀䄀匀吀⠀䰀䔀䘀吀⠀嬀琀愀猀欀崀⸀嬀䘀愀挀琀䐀愀琀攀崀Ⰰ ㄀㄀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀ഀഀ
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䌀䄀匀吀⠀✀　⸀　　✀ 䄀匀 䘀䰀伀䄀吀⤀Ⰰ 一✀⌀⸀⌀⌀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀ഀഀ
  , 'USD' AS [ConversionCurrency]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀崀 䄀匀 嬀猀氀崀ഀഀ
INNER JOIN [task] ON [sl].[LeadId] = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId਍圀䠀䔀刀䔀 嬀琀愀猀欀崀⸀嬀刀漀眀一甀洀崀 㴀 ㄀ 䄀一䐀 嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䤀匀 一伀吀 一唀䰀䰀 䄀一䐀 嬀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀崀 䤀匀 一伀吀 一唀䰀䰀 㬀ഀഀ
਍ⴀⴀⴀ匀愀氀攀 唀渀欀渀漀眀渀ഀഀ
WITH [task]਍䄀匀 ⠀ 匀䔀䰀䔀䌀吀ഀഀ
         [AppointmentId] AS [Taskid]਍       Ⰰ 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀ഀഀ
       , [b].[OpportunityStatus]਍       Ⰰ 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀ഀഀ
       , [b].[DWH_LastUpdateDate]਍       Ⰰ 嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀崀ഀഀ
       , [b].[accountid]਍       Ⰰ 嬀䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀崀ഀഀ
       , [b].[OpportunityId]਍       Ⰰ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ 倀䄀刀吀䤀吀䤀伀一 䈀夀 嬀戀崀⸀嬀䰀攀愀搀䤀搀崀Ⰰ 嬀戀崀⸀嬀愀挀挀漀甀渀琀椀搀崀 伀刀䐀䔀刀 䈀夀 嬀戀崀⸀嬀䘀愀挀琀䐀愀琀攀崀 䄀匀䌀 ⤀ 䄀匀 嬀刀漀眀一甀洀崀ഀഀ
     FROM [dbo].[FactAppointment] AS [b]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀崀 䄀匀 嬀挀氀琀崀 伀一 嬀挀氀琀崀⸀嬀匀愀氀攀猀昀漀爀挀攀䌀漀渀琀愀挀琀䤀䐀崀 㴀 嬀戀崀⸀嬀氀攀愀搀椀搀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]਍                                                              䄀一䐀 䌀䄀匀吀⠀嬀戀崀⸀嬀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀崀 䄀匀 䐀䄀吀䔀⤀ 㴀 嬀搀挀洀崀⸀嬀䈀攀最椀渀䐀愀琀攀崀ഀഀ
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]਍     䰀䔀䘀吀 伀唀吀䔀刀 䨀伀䤀一 嬀伀䐀匀崀⸀嬀䌀一䌀吀开氀欀瀀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀崀 䄀匀 嬀戀猀崀 圀䤀吀䠀⠀ 一伀䰀伀䌀䬀 ⤀伀一 嬀戀猀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀 㴀 嬀洀崀⸀嬀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀崀ഀഀ
     WHERE [bs].[BusinessSegmentDescription] NOT IN ('Surgery', 'Surgery Complete', 'Extreme Therapy', 'Xtrands+', 'Xtrands'))਍䤀一匀䔀刀吀 䤀一吀伀 嬀⌀匀愀氀攀唀渀欀渀漀眀渀崀ഀഀ
SELECT਍    嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䄀匀 嬀䜀漀漀最氀攀䌀氀椀挀欀䤀䐀崀ഀഀ
  , 'Unknown' AS [ConversionName]਍  Ⰰ 䘀伀刀䴀䄀吀⠀䐀䄀吀䔀䄀䐀䐀⠀䴀䤀一唀吀䔀Ⰰ 㔀Ⰰ 䌀䄀匀吀⠀䰀䔀䘀吀⠀嬀琀愀猀欀崀⸀嬀䘀愀挀琀䐀愀琀攀崀Ⰰ ㄀㄀⤀ 䄀匀 䐀䄀吀䔀吀䤀䴀䔀⤀⤀Ⰰ ✀䴀䴀⼀搀搀⼀礀礀礀礀 栀栀㨀洀洀㨀猀猀⸀　　 琀琀✀⤀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀吀椀洀攀崀ഀഀ
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]਍  Ⰰ ✀　⸀　　✀ 䄀匀 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀ഀഀ
  , 'USD' AS [ConversionCurrency]਍䘀刀伀䴀 嬀搀戀漀崀⸀嬀嘀圀䰀攀愀搀崀 䄀匀 嬀猀氀崀ഀഀ
INNER JOIN [task] ON [sl].[LeadId] = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId਍圀䠀䔀刀䔀 嬀琀愀猀欀崀⸀嬀刀漀眀一甀洀崀 㴀 ㄀ 䄀一䐀 嬀猀氀崀⸀嬀䜀䌀䰀䤀䐀崀 䤀匀 一伀吀 一唀䰀䰀 㬀ഀഀ
਍ⴀⴀⴀ唀渀椀漀渀 吀愀戀氀攀猀ഀഀ
INSERT INTO [#FunnelTable]਍匀䔀䰀䔀䌀吀 ⨀ഀഀ
FROM [#Contact]਍唀一䤀伀一 䄀䰀䰀ഀഀ
SELECT *਍䘀刀伀䴀 嬀⌀䰀攀愀搀崀ഀഀ
UNION ALL਍匀䔀䰀䔀䌀吀 ⨀ഀഀ
FROM [#Appointment]਍唀一䤀伀一 䄀䰀䰀ഀഀ
SELECT *਍䘀刀伀䴀 嬀⌀匀栀漀眀崀ഀഀ
UNION ALL਍匀䔀䰀䔀䌀吀 ⨀ഀഀ
FROM [#Sale]਍唀一䤀伀一 䄀䰀䰀ഀഀ
SELECT *਍䘀刀伀䴀 嬀⌀匀愀氀攀䔀堀吀崀ഀഀ
UNION ALL਍匀䔀䰀䔀䌀吀 ⨀ഀഀ
FROM [#SaleFUE]਍唀一䤀伀一 䄀䰀䰀ഀഀ
SELECT *਍䘀刀伀䴀 嬀⌀匀愀氀攀䘀唀吀崀ഀഀ
UNION ALL਍匀䔀䰀䔀䌀吀 ⨀ഀഀ
FROM [#SaleXtrands]਍唀一䤀伀一 䄀䰀䰀ഀഀ
SELECT *਍䘀刀伀䴀 嬀⌀匀愀氀攀堀琀爀愀渀搀猀倀氀甀猀崀ഀഀ
UNION ALL਍匀䔀䰀䔀䌀吀 ⨀ഀഀ
FROM [#SaleUnknown] ;਍ഀഀ
INSERT INTO [Reports].[Google]਍匀䔀䰀䔀䌀吀 䐀䤀匀吀䤀一䌀吀ഀഀ
       [GoogleClickID]਍     Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀一愀洀攀崀ഀഀ
     , [ConversionTime]਍     Ⰰ 嬀䌀漀渀瘀攀爀猀椀漀渀嘀愀氀甀攀崀ഀഀ
     , [ConversionCurrency]਍     Ⰰ 嬀搀愀琀攀吀椀洀攀䜀崀ഀഀ
FROM [#FunnelTable] ;਍ഀഀ
DROP TABLE [#Contact] ;਍䐀刀伀倀 吀䄀䈀䰀䔀 嬀⌀䰀攀愀搀崀 㬀ഀഀ
DROP TABLE [#Appointment] ;਍䐀刀伀倀 吀䄀䈀䰀䔀 嬀⌀匀栀漀眀崀 㬀ഀഀ
DROP TABLE [#Sale] ;਍䐀刀伀倀 吀䄀䈀䰀䔀 嬀⌀匀愀氀攀唀渀欀渀漀眀渀崀 㬀ഀഀ
DROP TABLE [#SaleEXT] ;਍䐀刀伀倀 吀䄀䈀䰀䔀 嬀⌀匀愀氀攀䘀唀䔀崀 㬀ഀഀ
DROP TABLE [#SaleFUT] ;਍䐀刀伀倀 吀䄀䈀䰀䔀 嬀⌀匀愀氀攀堀琀爀愀渀搀猀崀 㬀ഀഀ
DROP TABLE [#SaleXtrandsPlus] ;਍䐀刀伀倀 吀䄀䈀䰀䔀 嬀⌀䘀甀渀渀攀氀吀愀戀氀攀崀 㬀ഀഀ
;਍䜀伀ഀഀ
