/* CreateDate: 01/26/2010 10:12:08.630 , ModifyDate: 01/26/2010 10:12:08.630 */
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.DeleteExpiredSessions
        AS
            DECLARE @now datetime
            SET @now = GETUTCDATE()

            DELETE [CMSSessionState].dbo.ASPStateTempSessions
            WHERE Expires < @now

            RETURN 0
GO
