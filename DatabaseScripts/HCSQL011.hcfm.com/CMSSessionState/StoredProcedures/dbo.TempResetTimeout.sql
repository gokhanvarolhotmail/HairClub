/* CreateDate: 01/26/2010 10:12:08.630 , ModifyDate: 01/26/2010 10:12:08.630 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.TempResetTimeout
            @id     tSessionId
        AS
            UPDATE [CMSSessionState].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, GETUTCDATE())
            WHERE SessionId = @id
            RETURN 0
GO
