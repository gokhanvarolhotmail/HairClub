/****** Object:  StoredProcedure [dss].[SetDatabaseCredentials]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀匀攀琀䐀愀琀愀戀愀猀攀䌀爀攀搀攀渀琀椀愀氀猀崀ഀഀ
    @DatabaseID	UNIQUEIDENTIFIER,਍    䀀䌀漀渀渀攀挀琀椀漀渀匀琀爀椀渀最 一嘀䄀刀䌀䠀䄀刀⠀䴀䄀堀⤀Ⰰഀഀ
    @CertificateName NVARCHAR(128),਍    䀀䔀渀挀爀礀瀀琀椀漀渀䬀攀礀一愀洀攀 一嘀䄀刀䌀䠀䄀刀⠀㄀㈀㠀⤀ഀഀ
AS਍䈀䔀䜀䤀一ഀഀ
    DECLARE @State INT਍    匀䔀吀 䀀匀琀愀琀攀 㴀 ⠀匀䔀䰀䔀䌀吀 嬀猀琀愀琀攀崀 䘀刀伀䴀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀 圀䠀䔀刀䔀 嬀椀搀崀 㴀 䀀䐀愀琀愀戀愀猀攀䤀䐀⤀ഀഀ
਍    䤀䘀 一伀吀 䔀堀䤀匀吀匀ഀഀ
        (SELECT * FROM sys.certificates WHERE name = @CertificateName)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('CERTIFICATE_NOT_EXIST', 16, 1)਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    IF NOT EXISTS਍        ⠀匀䔀䰀䔀䌀吀 ⨀ 䘀刀伀䴀 猀礀猀⸀猀礀洀洀攀琀爀椀挀开欀攀礀猀 圀䠀䔀刀䔀 渀愀洀攀 㴀 䀀䔀渀挀爀礀瀀琀椀漀渀䬀攀礀一愀洀攀⤀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䔀一䌀刀夀倀吀䤀伀一开䬀䔀夀开一伀吀开䔀堀䤀匀吀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    䔀堀䔀䌀⠀✀伀倀䔀一 匀夀䴀䴀䔀吀刀䤀䌀 䬀䔀夀 ✀⬀ 䀀䔀渀挀爀礀瀀琀椀漀渀䬀攀礀一愀洀攀 ⬀ ✀ 䐀䔀䌀刀夀倀吀䤀伀一 䈀夀 䌀䔀刀吀䤀䘀䤀䌀䄀吀䔀 ✀ ⬀ 䀀䌀攀爀琀椀昀椀挀愀琀攀一愀洀攀⤀ഀഀ
਍    唀倀䐀䄀吀䔀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀ഀഀ
    SET਍        嬀挀漀渀渀攀挀琀椀漀渀开猀琀爀椀渀最崀 㴀  䔀渀挀爀礀瀀琀䈀礀䬀攀礀⠀䬀攀礀开䜀唀䤀䐀⠀䀀䔀渀挀爀礀瀀琀椀漀渀䬀攀礀一愀洀攀⤀Ⰰ 䀀䌀漀渀渀攀挀琀椀漀渀匀琀爀椀渀最⤀ഀഀ
    WHERE [id] = @DatabaseID਍ഀഀ
    EXEC('CLOSE SYMMETRIC KEY ' + @EncryptionKeyName)਍ഀഀ
    IF (@State = 5) -- 5:SuspendedDueToWrongCredentials਍    䈀䔀䜀䤀一ഀഀ
        UPDATE [dss].[userdatabase]਍        匀䔀吀 嬀猀琀愀琀攀崀 㴀 　 ⴀⴀ 　㨀愀挀琀椀瘀攀ഀഀ
        WHERE [id] = @DatabaseID਍    䔀一䐀ഀഀ
END਍䜀伀ഀഀ
