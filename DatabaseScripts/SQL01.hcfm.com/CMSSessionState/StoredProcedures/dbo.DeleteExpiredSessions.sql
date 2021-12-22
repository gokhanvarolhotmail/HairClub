CREATE PROCEDURE dbo.DeleteExpiredSessions
        AS
            DECLARE @now datetime
            SET @now = GETUTCDATE()

            DELETE [CMSSessionState].dbo.ASPStateTempSessions
            WHERE Expires < @now

            RETURN 0
