/****** Object:  View [dbo].[VWFactAppointment_Live]    Script Date: 3/23/2022 10:16:56 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀开䰀椀瘀攀崀 䄀匀 眀椀琀栀 䘀愀挀琀愀瀀瀀琀挀琀攀 愀猀 ഀ
(਍猀攀氀攀挀琀 愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀                愀猀         䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀唀吀䌀Ⰰഀ
       a.AppointmentDateKey             as         AppointmentDateKeyUTC,       a.AppointmentTimeKey,਍       愀⸀䰀攀愀搀䬀攀礀Ⰰ       愀⸀䰀攀愀搀䤀搀Ⰰ       愀⸀䄀挀挀漀甀渀琀䬀攀礀Ⰰ       愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀Ⰰഀ
       a.AppoinmentStatusCategory,       a.AccountId,਍       愀⸀䌀攀渀琀攀爀欀攀礀Ⰰഀ
       a.Centernumber,਍       愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀吀礀瀀攀䬀攀礀Ⰰഀ
       a.bebackflag,਍       愀⸀愀瀀瀀漀椀渀琀洀攀渀琀椀搀Ⰰഀ
	   a.externaltaskid,਍       椀猀渀甀氀氀⠀愀⸀椀猀搀攀氀攀琀攀搀Ⰰ 　⤀         䄀匀         椀猀搀攀氀攀琀攀搀Ⰰഀ
       case਍           眀栀攀渀 䤀猀伀氀搀 㴀 　 琀栀攀渀 搀愀琀攀愀搀搀⠀洀椀Ⰰ 搀愀琀攀瀀愀爀琀⠀琀稀Ⰰഀ
                                                    CONVERT(datetime, a.AppointmentDate) AT TIME ZONE਍                                                    ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀⤀ഀ
           else a.AppointmentDate end AS         AppointmentDate,਍            愀⸀䤀猀伀氀搀Ⰰഀ
	   	  a.AppointmentType,਍ऀऀ  愀⸀伀瀀瀀漀爀琀甀渀椀琀礀䤀搀Ⰰഀ
		  a.OpportunityStatus,਍ऀऀ  愀⸀伀瀀瀀漀爀琀甀渀椀琀礀䐀愀琀攀ऀⰀഀ
		  a.OpportunityAmmount,਍          愀⸀倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀ഀ
from factappointment a਍眀栀攀爀攀 椀猀漀氀搀㴀　ഀ
),਍ 愀猀猀椀最渀攀搀挀琀攀 愀猀ഀ
( select  cc.Name ,bb.ServiceAppointmentId,row_number() over(partition by  bb.serviceappointmentid order by serviceappointmentid) as RN਍    昀爀漀洀  伀䐀匀⸀䄀猀猀椀最渀攀搀刀攀猀漀甀爀挀攀 戀戀 ഀ
    left  join ODS.ServiceResource cc on cc.id = bb.ServiceResourceId਍  ⤀ഀ
select a.AppointmentDateUTC,਍       愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀䬀攀礀唀吀䌀Ⰰഀ
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
		  a.OpportunityAmmount,਍          愀⸀倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀Ⰰഀ
		  bb.Name as Performer਍昀爀漀洀 䘀愀挀琀愀瀀瀀琀挀琀攀 愀ഀ
         left join dimcenter b on a.CenterKey = b.CenterKey਍         氀攀昀琀 樀漀椀渀 搀椀洀氀攀愀搀 挀 漀渀 愀⸀氀攀愀搀欀攀礀 㴀 挀⸀氀攀愀搀欀攀礀ഀ
         left join VWDimCampaign cp on c.originalcampaignkey = cp.campaignkey਍         氀攀昀琀 樀漀椀渀 搀椀洀愀挀挀漀甀渀琀 搀 漀渀 愀⸀愀挀挀漀甀渀琀欀攀礀 㴀 搀⸀愀挀挀漀甀渀琀欀攀礀ഀ
         left join dimAppointmentType e on a.AppointmentTypeKey = e.Appointmenttypekey਍         氀攀昀琀 樀漀椀渀 䐀椀洀䐀愀琀攀 搀搀 漀渀 挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ愀瀀瀀漀椀渀琀洀攀渀琀搀愀琀攀⤀ 㴀ഀ
                                 convert(date, dd.FullDate)਍         氀攀昀琀  樀漀椀渀 愀猀猀椀最渀攀搀挀琀攀 戀戀 漀渀 愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀 㴀 戀戀⸀匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀 愀渀搀 戀戀⸀刀一㴀㄀㬀ഀഀ
GO਍
