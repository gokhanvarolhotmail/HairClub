/****** Object:  StoredProcedure [dss].[OpsChangeSubscriptionState_ALL]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍ⴀⴀ 䐀椀猀愀戀氀攀 漀爀 䔀渀愀戀氀攀 䄀䰀䰀 匀唀䈀匀䌀刀䤀倀吀䤀伀一匀 䤀一 䄀 匀䌀䄀䰀䔀 唀一䤀吀 戀礀 猀攀琀琀椀渀最 琀栀攀 猀甀戀猀挀爀椀瀀琀椀漀渀猀琀愀琀攀 昀椀攀氀搀 椀渀 搀猀猀⸀猀甀戀猀挀爀椀瀀琀椀漀渀 琀愀戀氀攀ഀഀ
-- Disable - set field to 1਍ⴀⴀ 䔀渀愀戀氀攀  ⴀ 猀攀琀 昀椀攀氀搀 琀漀 　 ⠀䐀攀昀愀甀氀琀 瘀愀氀甀攀⤀ഀഀ
CREATE PROCEDURE [dss].[OpsChangeSubscriptionState_ALL]਍    䀀匀琀愀琀攀 一嘀䄀刀䌀䠀䄀刀⠀㌀　⤀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
਍    䐀䔀䌀䰀䄀刀䔀 䀀猀琀愀琀攀瘀愀氀甀攀 吀䤀一夀䤀一吀ഀഀ
    SET @statevalue =਍        䌀䄀匀䔀 䀀匀琀愀琀攀ഀഀ
            WHEN 'Disable'	THEN 1਍            圀䠀䔀一 ✀䔀渀愀戀氀攀✀ऀ吀䠀䔀一 　ഀഀ
            ELSE NULL਍        䔀一䐀ഀഀ
    IF @statevalue IS NULL਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('@State argument is wrong. Must be Disable or Enable.', 16, 1)਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    UPDATE dss.subscription SET subscriptionstate = @statevalue਍ഀഀ
    DECLARE @rows INT਍    匀䔀吀 䀀爀漀眀猀 㴀 䀀䀀刀伀圀䌀伀唀一吀ഀഀ
    IF @rows = 0਍    䈀䔀䜀䤀一ഀഀ
        PRINT 'No change was made. Please check!'਍    䔀一䐀ഀഀ
    ELSE਍    䈀䔀䜀䤀一ഀഀ
        PRINT 'All subscriptions have been changed to state ' + @State + ', rows = ' + convert(nvarchar(30), @rows) + '.'਍    䔀一䐀ഀഀ
END਍䜀伀ഀഀ
