/****** Object:  StoredProcedure [dbo].[sp_UpdateLeadConsultForm]    Script Date: 1/10/2022 10:03:12 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀搀戀漀崀⸀嬀猀瀀开唀瀀搀愀琀攀䰀攀愀搀䌀漀渀猀甀氀琀䘀漀爀洀崀 䄀匀ഀഀ
BEGIN਍    唀倀䐀䄀吀䔀 嬀搀戀漀崀⸀嬀䐀椀洀䰀攀愀搀崀ഀഀ
    SET isconsultformcomplete = f.iscomplete਍    䘀刀伀䴀 ⠀ഀഀ
        SELECT *਍        䘀刀伀䴀 ⠀ഀഀ
            SELECT x.lead__c਍                Ⰰ 猀挀⸀氀愀猀琀洀漀搀椀昀椀攀搀搀愀琀攀ഀഀ
                , sc.is__completed__c AS iscomplete਍                Ⰰ 刀伀圀开一唀䴀䈀䔀刀⠀⤀ 伀嘀䔀刀 ⠀ഀഀ
                    PARTITION BY sc.Lead__c ORDER BY sc.LastModifiedDate DESC਍                    ⤀ 䄀匀 ✀刀漀眀䤀䐀✀ഀഀ
            FROM [ODS].[SFDC_ConsultationForm] sc਍            䤀一一䔀刀 䨀伀䤀一 ⠀ഀഀ
                SELECT LEad__c਍                    Ⰰ 洀愀砀⠀氀愀猀琀洀漀搀椀昀椀攀搀搀愀琀攀⤀ 䄀匀 洀漀搀椀昀椀攀搀ഀഀ
                FROM [ODS].[SFDC_ConsultationForm]਍                䜀刀伀唀倀 䈀夀 氀攀愀搀开开挀ഀഀ
                    , lastmodifieddate਍                ⤀ 䄀匀 砀ഀഀ
                ON x.lead__c = sc.lead__c਍                    䄀一䐀 猀挀⸀氀愀猀琀洀漀搀椀昀椀攀搀搀愀琀攀 㴀 砀⸀洀漀搀椀昀椀攀搀ഀഀ
            WHERE is__completed__c = 1਍            ⤀ 䄀匀 琀ഀഀ
        WHERE t.rowid = 1਍        ⤀ 䄀匀 昀ഀഀ
    WHERE f.lead__c = LeadId਍䔀一䐀ഀഀ
GO਍
