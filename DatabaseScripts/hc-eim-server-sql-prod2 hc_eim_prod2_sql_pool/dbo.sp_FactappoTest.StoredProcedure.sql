/****** Object:  StoredProcedure [dbo].[sp_FactappoTest]    Script Date: 3/7/2022 8:42:24 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀搀戀漀崀⸀嬀猀瀀开䘀愀挀琀愀瀀瀀漀吀攀猀琀崀 䄀匀ഀ
BEGIN਍    琀爀甀渀挀愀琀攀 琀愀戀氀攀 䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀吀攀猀琀㬀ഀ
਍    圀椀琀栀 琀愀猀欀 愀猀 ⠀ഀ
        SELECT a.*,਍        刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀⠀倀䄀刀吀䤀吀䤀伀一 䈀夀 愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䤀搀 伀刀䐀䔀刀 䈀夀 戀⸀䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀 䐀䔀匀䌀⤀ഀ
        AS RowNum਍        䘀刀伀䴀 搀戀漀⸀䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀吀攀猀琀䐀甀瀀猀 愀ഀ
        left join LeadCopyBB b on a.LeadId = b.LeadId਍        ⤀ഀ
    insert into FactAppointmentTest਍    猀攀氀攀挀琀   䘀愀挀琀䐀愀琀攀Ⰰഀ
                   FactTimeKey,਍                   䘀愀挀琀䐀愀琀攀䬀攀礀Ⰰഀ
                   AppointmentDate,਍                   䄀瀀瀀漀椀渀琀洀攀渀琀吀椀洀攀䬀攀礀Ⰰഀ
                   AppointmentDateKey,਍                   䰀攀愀搀䬀攀礀Ⰰഀ
                   LeadId,਍                   䄀挀挀漀甀渀琀䬀攀礀Ⰰഀ
                   AccountId,਍                   䌀漀渀琀愀挀琀䬀攀礀Ⰰഀ
                   ContactId,਍                   倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀Ⰰഀ
                   WorkTypeKey,਍                   圀漀爀欀吀礀瀀攀䤀搀Ⰰഀ
                   AccountAddress,਍                   䄀挀挀漀甀渀琀䌀椀琀礀Ⰰഀ
                   AccountState,਍                   䄀挀挀漀甀渀琀倀漀猀琀愀氀䌀漀搀攀Ⰰഀ
                   AccountCountry,਍                   䜀攀漀最爀愀瀀栀礀䬀攀礀Ⰰഀ
                   AppointmentDescription,਍                   䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀Ⰰഀ
                   CenterKey,਍                   匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀䤀搀Ⰰഀ
                   CenterNumber,਍                   䄀瀀瀀漀椀渀琀洀攀渀琀吀礀瀀攀䬀攀礀Ⰰഀ
                   AppointmentType,਍                   䄀瀀瀀漀椀渀琀洀攀渀琀䌀攀渀琀攀爀吀礀瀀攀Ⰰഀ
                   ExternalId,਍                   匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀Ⰰഀ
                   MeetingPlatformKey,਍                   䴀攀攀琀椀渀最倀氀愀琀昀漀爀洀䤀搀Ⰰഀ
                   MeetingPlatform,਍                   䐀圀䠀开䰀漀愀搀䐀愀琀攀Ⰰഀ
                   DWH_LastUpdateDate,਍                   倀愀爀攀渀琀刀攀挀漀爀搀䤀搀Ⰰഀ
                   AppointmentId,਍                   䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀Ⰰഀ
                   StatusKey,਍                   䌀愀渀挀攀氀氀愀琀椀漀渀刀攀愀猀漀渀Ⰰഀ
                   BeBackFlag,਍                   伀氀搀匀琀愀琀甀猀Ⰰഀ
                   AppoinmentStatusCategory,਍                   䤀猀䐀攀氀攀琀攀搀Ⰰഀ
                   IsOld,਍                   伀瀀瀀漀爀琀甀渀椀琀礀䤀搀Ⰰഀ
                   OpportunityStatus,਍                   伀瀀瀀漀爀琀甀渀椀琀礀䐀愀琀攀Ⰰഀ
                   OpportunityReferralCode,਍                   伀瀀瀀漀爀琀甀渀椀琀礀刀攀昀攀爀爀愀氀䌀漀搀攀䔀砀瀀椀爀愀琀椀漀渀䐀愀琀攀Ⰰഀ
                   OpportunityAmmount,਍                   倀攀爀昀漀爀洀攀爀Ⰰഀ
                   performerKey਍    昀爀漀洀 琀愀猀欀ഀ
    where task.RowNum = 1਍攀渀搀ഀഀ
GO਍
