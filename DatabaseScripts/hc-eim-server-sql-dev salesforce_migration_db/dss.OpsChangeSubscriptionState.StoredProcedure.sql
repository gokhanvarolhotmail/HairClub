/****** Object:  StoredProcedure [dss].[OpsChangeSubscriptionState]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ⴀⴀ 䐀椀猀愀戀氀攀 漀爀 䔀渀愀戀氀攀 愀 猀甀戀猀挀爀椀瀀琀椀漀渀 戀礀 猀攀琀琀椀渀最 琀栀攀 猀甀戀猀挀爀椀瀀琀椀漀渀猀琀愀琀攀 昀椀攀氀搀 椀渀 搀猀猀⸀猀甀戀猀挀爀椀瀀琀椀漀渀 琀愀戀氀攀ഀഀ
-- Disable - set field to 1਍ⴀⴀ 䔀渀愀戀氀攀  ⴀ 猀攀琀 昀椀攀氀搀 琀漀 　 ⠀䐀攀昀愀甀氀琀 瘀愀氀甀攀⤀ഀഀ
CREATE PROCEDURE [dss].[OpsChangeSubscriptionState]਍    䀀䐀猀猀匀攀爀瘀攀爀䤀搀 唀一䤀儀唀䔀䤀䐀䔀一吀䤀䘀䤀䔀刀Ⰰഀഀ
    @State NVARCHAR(30)਍䄀匀ഀഀ
BEGIN਍    䤀䘀 䀀䐀猀猀匀攀爀瘀攀爀䤀搀 䤀匀 一唀䰀䰀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䀀䐀猀猀匀攀爀瘀攀爀䤀搀 愀爀最甀洀攀渀琀 椀猀 渀甀氀氀⸀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    䐀䔀䌀䰀䄀刀䔀 䀀猀琀愀琀攀瘀愀氀甀攀 吀䤀一夀䤀一吀ഀഀ
    SET @statevalue =਍        䌀䄀匀䔀 䀀匀琀愀琀攀ഀഀ
            WHEN 'Disable'	THEN 1਍            圀䠀䔀一 ✀䔀渀愀戀氀攀✀ऀ吀䠀䔀一 　ഀഀ
            ELSE NULL਍        䔀一䐀ഀഀ
    IF @statevalue IS NULL਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('@State argument is wrong. Must be Disable or Enable.', 16, 1)਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    UPDATE dss.subscription SET subscriptionstate = @statevalue਍    圀䠀䔀刀䔀 椀搀 㴀 䀀䐀猀猀匀攀爀瘀攀爀䤀搀ഀഀ
਍    䤀䘀 䀀䀀刀伀圀䌀伀唀一吀 㴀 　ഀഀ
    BEGIN਍        倀刀䤀一吀 ✀一漀 挀栀愀渀最攀 眀愀猀 洀愀搀攀⸀ 倀氀攀愀猀攀 挀栀攀挀欀℀✀ഀഀ
    END਍    䔀䰀匀䔀ഀഀ
    BEGIN਍        倀刀䤀一吀 ✀匀甀戀猀挀爀椀瀀琀椀漀渀 ✀ ⬀ 䌀䄀匀吀⠀䀀䐀猀猀匀攀爀瘀攀爀䤀搀 䄀匀 一嘀䄀刀䌀䠀䄀刀⠀㄀㈀㠀⤀⤀ ⬀ ✀ 栀愀猀 戀攀攀渀 挀栀愀渀最攀搀 琀漀 猀琀愀琀攀 ✀ ⬀ 䀀匀琀愀琀攀 ⬀ ✀⸀✀ഀഀ
    END਍䔀一䐀ഀഀ
GO਍
