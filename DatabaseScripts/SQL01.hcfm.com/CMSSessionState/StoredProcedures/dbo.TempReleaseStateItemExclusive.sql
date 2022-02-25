/* CreateDate: 01/26/2010 10:12:08.607 , ModifyDate: 01/26/2010 10:12:08.607 */
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.TempReleaseStateItemExclusive
            @id         tSessionId,
            @lockCookie int
        AS
            UPDATE [CMSSessionState].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, GETUTCDATE()),
                Locked = 0
            WHERE SessionId = @id AND LockCookie = @lockCookie

            RETURN 0
GO
