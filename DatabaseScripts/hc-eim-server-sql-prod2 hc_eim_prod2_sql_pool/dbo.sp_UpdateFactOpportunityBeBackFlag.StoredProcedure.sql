/****** Object:  StoredProcedure [dbo].[sp_UpdateFactOpportunityBeBackFlag]    Script Date: 3/23/2022 10:16:58 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀搀戀漀崀⸀嬀猀瀀开唀瀀搀愀琀攀䘀愀挀琀伀瀀瀀漀爀琀甀渀椀琀礀䈀攀䈀愀挀欀䘀氀愀最崀 䄀匀ഀഀ
begin਍ഀഀ
਍    甀瀀搀愀琀攀 䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
    set BeBackFlag = 1਍    昀爀漀洀 䘀愀挀琀伀瀀瀀漀爀琀甀渀椀琀礀 昀漀ഀഀ
    where fo.LeadId = FactAppointment.LeadId਍      愀渀搀 昀漀⸀䤀猀圀漀渀 㴀 　ഀഀ
      and FactAppointment.AppointmentDate > fo.FactDate਍      愀渀搀 愀戀猀⠀搀愀琀攀搀椀昀昀⠀搀愀礀Ⰰ 䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀Ⰰ 昀漀⸀䘀愀挀琀䐀愀琀攀⤀⤀ 㰀㴀 ㌀㘀㔀ഀഀ
      and abs(datediff(day, FactAppointment.AppointmentDate, fo.FactDate)) > 0਍ഀഀ
    select count(*), BeBackFlag਍    昀爀漀洀 䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀ഀഀ
    where convert(date, AppointmentDate) >= '2021-06-15'਍    最爀漀甀瀀 戀礀 䈀攀䈀愀挀欀䘀氀愀最ഀഀ
਍ഀഀ
end਍䜀伀ഀഀ
