/* CreateDate: 01/26/2010 10:12:08.617 , ModifyDate: 01/26/2010 10:12:08.617 */
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.TempInsertStateItemLong
            @id         tSessionId,
            @itemLong   tSessionItemLong,
            @timeout    int
        AS
            DECLARE @now AS datetime
            DECLARE @nowLocal AS datetime

            SET @now = GETUTCDATE()
            SET @nowLocal = GETDATE()

            INSERT [CMSSessionState].dbo.ASPStateTempSessions
                (SessionId,
                 SessionItemLong,
                 Timeout,
                 Expires,
                 Locked,
                 LockDate,
                 LockDateLocal,
                 LockCookie)
            VALUES
                (@id,
                 @itemLong,
                 @timeout,
                 DATEADD(n, @timeout, @now),
                 0,
                 @now,
                 @nowLocal,
                 1)

            RETURN 0
GO
