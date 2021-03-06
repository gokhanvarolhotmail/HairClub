/****** Object:  StoredProcedure [dss].[GetDatabaseConnString]    Script Date: 1/10/2022 10:01:48 PM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀䔀䐀唀刀䔀 嬀搀猀猀崀⸀嬀䜀攀琀䐀愀琀愀戀愀猀攀䌀漀渀渀匀琀爀椀渀最崀ഀഀ
    @DatabaseId	UNIQUEIDENTIFIER,਍    䀀䌀攀爀琀椀昀椀挀愀琀攀一愀洀攀 一嘀䄀刀䌀䠀䄀刀⠀㄀㈀㠀⤀Ⰰഀഀ
    @EncryptionKeyName NVARCHAR(128)਍䄀匀ഀഀ
BEGIN਍ഀഀ
    IF NOT EXISTS਍        ⠀匀䔀䰀䔀䌀吀 ⨀ 䘀刀伀䴀 猀礀猀⸀挀攀爀琀椀昀椀挀愀琀攀猀 圀䠀䔀刀䔀 渀愀洀攀 㴀 䀀䌀攀爀琀椀昀椀挀愀琀攀一愀洀攀⤀ഀഀ
    BEGIN਍        刀䄀䤀匀䔀刀刀伀刀⠀✀䌀䔀刀吀䤀䘀䤀䌀䄀吀䔀开一伀吀开䔀堀䤀匀吀✀Ⰰ ㄀㘀Ⰰ ㄀⤀ഀഀ
        RETURN਍    䔀一䐀ഀഀ
਍    䤀䘀 一伀吀 䔀堀䤀匀吀匀ഀഀ
        (SELECT * FROM sys.symmetric_keys WHERE name = @EncryptionKeyName)਍    䈀䔀䜀䤀一ഀഀ
        RAISERROR('ENCRYPTION_KEY_NOT_EXIST', 16, 1)਍        刀䔀吀唀刀一ഀഀ
    END਍ഀഀ
    EXEC('OPEN SYMMETRIC KEY '+ @EncryptionKeyName + ' DECRYPTION BY CERTIFICATE ' + @CertificateName)਍ഀഀ
    SELECT CONVERT(NVARCHAR(MAX), DecryptByKey(connection_string)) AS 'connection_string'਍    䘀刀伀䴀 嬀搀猀猀崀⸀嬀甀猀攀爀搀愀琀愀戀愀猀攀崀ഀഀ
    WHERE [id] = @DatabaseId਍ഀഀ
    EXEC('CLOSE SYMMETRIC KEY ' + @EncryptionKeyName)਍ഀഀ
END਍䜀伀ഀഀ
