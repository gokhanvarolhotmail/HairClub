/* CreateDate: 01/26/2010 10:12:08.627 , ModifyDate: 01/26/2010 10:12:08.627 */
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.TempRemoveStateItem
        @id     tSessionId,
        @lockCookie int
    AS
        DELETE [CMSSessionState].dbo.ASPStateTempSessions
        WHERE SessionId = @id AND LockCookie = @lockCookie
        RETURN 0
GO
