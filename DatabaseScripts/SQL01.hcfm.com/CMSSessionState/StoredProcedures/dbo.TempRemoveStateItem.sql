CREATE PROCEDURE dbo.TempRemoveStateItem
        @id     tSessionId,
        @lockCookie int
    AS
        DELETE [CMSSessionState].dbo.ASPStateTempSessions
        WHERE SessionId = @id AND LockCookie = @lockCookie
        RETURN 0
