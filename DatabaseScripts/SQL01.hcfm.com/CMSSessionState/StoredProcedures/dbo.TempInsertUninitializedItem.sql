/* CreateDate: 01/26/2010 10:12:08.610 , ModifyDate: 01/26/2010 10:12:08.610 */
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.TempInsertUninitializedItem
            @id         tSessionId,
            @itemShort  tSessionItemShort,
            @timeout    int
        AS

            DECLARE @now AS datetime
            DECLARE @nowLocal AS datetime

            SET @now = GETUTCDATE()
            SET @nowLocal = GETDATE()

            INSERT [CMSSessionState].dbo.ASPStateTempSessions
                (SessionId,
                 SessionItemShort,
                 Timeout,
                 Expires,
                 Locked,
                 LockDate,
                 LockDateLocal,
                 LockCookie,
                 Flags)
            VALUES
                (@id,
                 @itemShort,
                 @timeout,
                 DATEADD(n, @timeout, @now),
                 0,
                 @now,
                 @nowLocal,
                 1,
                 1)

            RETURN 0
GO
