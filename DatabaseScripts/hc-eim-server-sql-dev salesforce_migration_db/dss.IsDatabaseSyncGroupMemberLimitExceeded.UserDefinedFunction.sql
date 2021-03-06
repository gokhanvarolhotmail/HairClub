/****** Object:  UserDefinedFunction [dss].[IsDatabaseSyncGroupMemberLimitExceeded]    Script Date: 1/10/2022 10:01:47 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 䘀唀一䌀吀䤀伀一 嬀搀猀猀崀⸀嬀䤀猀䐀愀琀愀戀愀猀攀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䰀椀洀椀琀䔀砀挀攀攀搀攀搀崀ഀഀ
(਍    䀀䐀愀琀愀戀愀猀攀䤀䐀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀ഀഀ
)਍刀䔀吀唀刀一匀 䤀一吀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    -- check the number of sync group memberships for a database in a server.਍ഀഀ
    DECLARE @DatabaseGroupMembershipCount INT਍    䐀䔀䌀䰀䄀刀䔀 䀀䐀愀琀愀戀愀猀攀䜀爀漀甀瀀䴀攀洀戀攀爀猀栀椀瀀䰀椀洀椀琀 䤀一吀ഀഀ
਍    匀䔀吀 䀀䐀愀琀愀戀愀猀攀䜀爀漀甀瀀䴀攀洀戀攀爀猀栀椀瀀䰀椀洀椀琀 㴀 ⠀匀䔀䰀䔀䌀吀 嬀䴀愀砀嘀愀氀甀攀崀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀猀挀愀氀攀甀渀椀琀氀椀洀椀琀猀崀 圀䠀䔀刀䔀 嬀一愀洀攀崀 㴀 ✀䐀戀匀礀渀挀䜀爀漀甀瀀䴀攀洀戀攀爀䌀漀甀渀琀倀攀爀匀攀爀瘀攀爀✀⤀ഀഀ
਍    ⴀⴀ 最攀琀 琀栀攀 ⌀ 漀昀 洀攀洀戀攀爀猀ഀഀ
    SET @DatabaseGroupMembershipCount = (SELECT COUNT([id]) FROM [dss].[syncgroupmember] WHERE [databaseid] = @DatabaseID)਍                                        ⴀⴀ 愀氀猀漀 椀渀挀氀甀搀攀 琀栀攀 栀甀戀ഀഀ
                                        + (SELECT COUNT([id]) FROM [dss].[syncgroup] WHERE [hub_memberid] = @DatabaseID)਍ഀഀ
    IF (@DatabaseGroupMembershipCount >= @DatabaseGroupMembershipLimit)਍    䈀䔀䜀䤀一ഀഀ
        RETURN 1਍    䔀一䐀ഀഀ
਍    刀䔀吀唀刀一 　ഀഀ
END਍䜀伀ഀഀ
