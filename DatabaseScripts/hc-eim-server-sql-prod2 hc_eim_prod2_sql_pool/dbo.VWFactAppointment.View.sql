/****** Object:  View [dbo].[VWFactAppointment]    Script Date: 3/1/2022 8:53:35 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀崀 䄀匀 眀椀琀栀 䘀愀挀琀愀瀀瀀琀挀琀攀 愀猀ഀ
(਍猀攀氀攀挀琀 愀⸀嬀䘀愀挀琀䐀愀琀攀崀Ⰰഀ
		a.AppointmentDate                as         AppointmentDateUTC,਍       愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀䬀攀礀             愀猀         䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀䬀攀礀唀吀䌀Ⰰ       愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀吀椀洀攀䬀攀礀Ⰰഀ
       a.LeadKey,       a.LeadId,       a.AccountKey,       a.AppointmentStatus,਍       愀⸀䄀瀀瀀漀椀渀洀攀渀琀匀琀愀琀甀猀䌀愀琀攀最漀爀礀Ⰰ       愀⸀䄀挀挀漀甀渀琀䤀搀Ⰰഀ
       a.Centerkey,਍       愀⸀䌀攀渀琀攀爀渀甀洀戀攀爀Ⰰഀ
       a.AppointmentTypeKey,਍       愀⸀戀攀戀愀挀欀昀氀愀最Ⰰഀ
       a.appointmentid,਍ऀ   愀⸀攀砀琀攀爀渀愀氀琀愀猀欀椀搀Ⰰഀ
       isnull(a.isdeleted, 0)         AS         isdeleted,਍       挀愀猀攀ഀ
           when IsOld = 0 then dateadd(mi, datepart(tz,਍                                                    䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ 愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀⤀ 䄀吀 吀䤀䴀䔀 娀伀一䔀ഀ
                                                    'Eastern Standard Time'), a.AppointmentDate)਍           攀氀猀攀 愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀 攀渀搀 䄀匀         䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀Ⰰഀ
            a.IsOld,਍ऀ   ऀ  愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀吀礀瀀攀Ⰰഀ
		  a.OpportunityId,਍ऀऀ  愀⸀伀瀀瀀漀爀琀甀渀椀琀礀匀琀愀琀甀猀Ⰰഀ
		  a.OpportunityDate	,਍ऀऀ  愀⸀伀瀀瀀漀爀琀甀渀椀琀礀䄀洀洀漀甀渀琀Ⰰഀ
          a.Performer,਍          愀⸀瀀攀爀昀漀爀洀攀爀䬀攀礀Ⰰഀ
          a.ParentRecordType਍昀爀漀洀 昀愀挀琀愀瀀瀀漀椀渀琀洀攀渀琀 愀ഀ
where case਍           眀栀攀渀 䤀猀伀氀搀 㴀 　 琀栀攀渀 搀愀琀攀愀搀搀⠀洀椀Ⰰ 搀愀琀攀瀀愀爀琀⠀琀稀Ⰰഀ
                                                    CONVERT(datetime, a.AppointmentDate) AT TIME ZONE਍                                                    ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀⤀ഀ
           else a.AppointmentDate end>=CONVERT(date,dateadd(d,-(day(getdate()-1)),getdate()),106)਍甀渀椀漀渀 愀氀氀ഀ
select a.[FactDate],਍ऀऀ愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀                愀猀         䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀唀吀䌀Ⰰഀ
       a.AppointmentDateKey             as         AppointmentDateKeyUTC,       a.AppointmentTimeKey,਍       愀⸀䰀攀愀搀䬀攀礀Ⰰ       愀⸀䰀攀愀搀䤀搀Ⰰ       愀⸀䄀挀挀漀甀渀琀䬀攀礀Ⰰ       愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀Ⰰഀ
       a.AppoinmentStatusCategory,       a.AccountId,਍       愀⸀䌀攀渀琀攀爀欀攀礀Ⰰഀ
       a.Centernumber,਍       愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀吀礀瀀攀䬀攀礀Ⰰഀ
       a.bebackflag,਍       愀⸀愀瀀瀀漀椀渀琀洀攀渀琀椀搀Ⰰഀ
	   a.externaltaskid,਍       椀猀渀甀氀氀⠀愀⸀椀猀搀攀氀攀琀攀搀Ⰰ 　⤀         䄀匀         椀猀搀攀氀攀琀攀搀Ⰰഀ
       case਍           眀栀攀渀 䤀猀伀氀搀 㴀 　 琀栀攀渀 搀愀琀攀愀搀搀⠀洀椀Ⰰ 搀愀琀攀瀀愀爀琀⠀琀稀Ⰰഀ
                                                    CONVERT(datetime, a.AppointmentDate) AT TIME ZONE਍                                                    ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀⤀ഀ
           else a.AppointmentDate end AS         AppointmentDate,਍            愀⸀䤀猀伀氀搀Ⰰഀ
	   	   a.AppointmentType,਍ऀऀ  愀⸀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀Ⰰഀ
		  a.OpportunityStatus,਍ऀऀ  愀⸀伀瀀瀀漀爀琀甀渀椀琀礀䐀愀琀攀Ⰰഀ
		  a.OpportunityAmount,਍          愀⸀倀攀爀昀漀爀洀攀爀Ⰰഀ
          a.performerKey,਍          愀⸀倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀ഀ
		  from FactAppointmentTracking a਍⤀Ⰰഀ
 assignedcte as਍⠀ 猀攀氀攀挀琀  挀挀⸀一愀洀攀 Ⰰ戀戀⸀匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀Ⰰ爀漀眀开渀甀洀戀攀爀⠀⤀ 漀瘀攀爀⠀瀀愀爀琀椀琀椀漀渀 戀礀  戀戀⸀猀攀爀瘀椀挀攀愀瀀瀀漀椀渀琀洀攀渀琀椀搀 漀爀搀攀爀 戀礀 猀攀爀瘀椀挀攀愀瀀瀀漀椀渀琀洀攀渀琀椀搀⤀ 愀猀 刀一ഀ
    from  ODS.AssignedResource bb ਍    氀攀昀琀  樀漀椀渀 伀䐀匀⸀匀攀爀瘀椀挀攀刀攀猀漀甀爀挀攀 挀挀 漀渀 挀挀⸀椀搀 㴀 戀戀⸀匀攀爀瘀椀挀攀刀攀猀漀甀爀挀攀䤀搀ഀ
  )਍猀攀氀攀挀琀 愀⸀嬀䘀愀挀琀䐀愀琀攀崀Ⰰഀ
		a.AppointmentDateUTC,਍       愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀䬀攀礀唀吀䌀Ⰰഀ
       a.AppointmentTimeKey,਍       愀⸀䰀攀愀搀䬀攀礀Ⰰഀ
       a.LeadId,਍       愀⸀䄀挀挀漀甀渀琀䬀攀礀Ⰰഀ
       a.AppointmentStatus,਍       愀⸀䄀瀀瀀漀椀渀洀攀渀琀匀琀愀琀甀猀䌀愀琀攀最漀爀礀Ⰰഀ
       a.AccountId,਍       愀⸀䌀攀渀琀攀爀欀攀礀Ⰰഀ
       a.Centernumber,਍       愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀吀礀瀀攀䬀攀礀Ⰰഀ
       b.CenterDescription,਍       戀⸀䌀攀渀琀攀爀琀礀瀀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰഀ
       isnull(c.leadFullName, d.AccountFullName) Name,਍       愀⸀戀攀戀愀挀欀昀氀愀最Ⰰഀ
       a.appointmentid,਍ऀ   愀⸀攀砀琀攀爀渀愀氀琀愀猀欀椀搀Ⰰഀ
       isnull(a.isdeleted, 0)         AS         isdeleted,਍       挀瀀⸀䄀最攀渀挀礀一愀洀攀䐀攀爀椀瘀攀搀Ⰰഀ
       a.AppointmentDate,਍       搀搀⸀䐀愀琀攀䬀攀礀                     䄀匀         䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀䬀攀礀Ⰰഀ
          a.IsOld,਍ऀऀ  椀猀渀甀氀氀⠀愀⸀䰀攀愀搀䤀搀Ⰰ搀⸀䄀挀挀漀甀渀琀䔀砀琀攀爀渀愀氀䤀搀⤀ 愀猀 䰀攀愀搀䤀搀䔀砀琀攀爀渀愀氀Ⰰഀ
		  a.AppointmentType,਍ऀऀ  愀⸀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀Ⰰഀ
		  a.OpportunityStatus,਍ऀऀ  愀⸀伀瀀瀀漀爀琀甀渀椀琀礀䐀愀琀攀Ⰰഀ
		  a.OpportunityAmmount,਍ऀऀ  挀漀愀氀攀猀挀攀⠀愀⸀瀀攀爀昀漀爀洀攀爀Ⰰ戀戀⸀一愀洀攀⤀ 愀猀 倀攀爀昀漀爀洀攀爀Ⰰഀ
          a.performerKey,਍          愀⸀倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀Ⰰഀ
          du.UserId਍昀爀漀洀 䘀愀挀琀愀瀀瀀琀挀琀攀 愀ഀ
         left join dimcenter b on a.CenterKey = b.CenterKey਍         氀攀昀琀 樀漀椀渀 搀椀洀氀攀愀搀 挀 漀渀 愀⸀氀攀愀搀欀攀礀 㴀 挀⸀氀攀愀搀欀攀礀ഀ
         left join VWDimCampaign cp on c.originalcampaignkey = cp.campaignkey਍         氀攀昀琀 樀漀椀渀 搀椀洀愀挀挀漀甀渀琀 搀 漀渀 愀⸀愀挀挀漀甀渀琀欀攀礀 㴀 搀⸀愀挀挀漀甀渀琀欀攀礀ഀ
         left join dimAppointmentType e on a.AppointmentTypeKey = e.Appointmenttypekey਍         氀攀昀琀 樀漀椀渀 䐀椀洀䐀愀琀攀 搀搀 漀渀 挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ愀瀀瀀漀椀渀琀洀攀渀琀搀愀琀攀⤀ 㴀ഀ
                                 convert(date, dd.FullDate)਍         氀攀昀琀  樀漀椀渀 愀猀猀椀最渀攀搀挀琀攀 戀戀 漀渀 愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀 㴀 戀戀⸀匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀 愀渀搀 戀戀⸀刀一㴀㄀ഀ
         left join dbo.DimSystemUser du on coalesce(a.performer,bb.Name) = du.UserName and du.SourceSystem = 'Salesforce';਍䜀伀ഀഀ
