/* CreateDate: 01/26/2010 10:12:08.620 , ModifyDate: 01/26/2010 10:12:08.620 */
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.TempUpdateStateItemShort
            @id         tSessionId,
            @itemShort  tSessionItemShort,
            @timeout    int,
            @lockCookie int
        AS
            UPDATE [CMSSessionState].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, @timeout, GETUTCDATE()),
                SessionItemShort = @itemShort,
                Timeout = @timeout,
                Locked = 0
            WHERE SessionId = @id AND LockCookie = @lockCookie

            RETURN 0
GO
