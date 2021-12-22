/* CreateDate: 01/18/2005 09:34:12.560 , ModifyDate: 10/15/2013 00:45:57.060 */
/* ***HasTriggers*** TriggerCount: 2 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_user_log](
	[user_log_id] [int] NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[last_activity_time] [datetime] NULL,
 CONSTRAINT [pk_onca_user_log] PRIMARY KEY CLUSTERED
(
	[user_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_user_log]  WITH CHECK ADD  CONSTRAINT [user_user_log_264] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_user_log] CHECK CONSTRAINT [user_user_log_264]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[pso_QueueUserHistory]
   ON  [dbo].[onca_user_log]
   AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO csta_queue_user_history (start_date, queue_id, user_code)
	SELECT GETDATE(), dbo.psoUserQueue(user_code), user_code FROM inserted

	UPDATE csta_queue_user_history
	SET end_date = GETDATE()
	FROM csta_queue_user_history
	INNER JOIN deleted ON csta_queue_user_history.user_code = deleted.user_code
	WHERE csta_queue_user_history.end_date IS NULL

END
GO
ALTER TABLE [dbo].[onca_user_log] ENABLE TRIGGER [pso_QueueUserHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================
-- Create date: 7 July 2010
-- Description:	Calls pso_RemoveLockedContacts passing the user_code that was
--				either added or removed from onca_user_log.
-- =============================================================================
CREATE TRIGGER [dbo].[pso_UnlockContacts]
   ON  [dbo].[onca_user_log]
   AFTER INSERT, DELETE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @UserCode NCHAR(20)

	SET @UserCode = (SELECT TOP 1 user_code FROM inserted)

	IF (@UserCode IS NOT NULL)
	BEGIN
		EXEC pso_RemoveLockedContacts @UserCode
	END

	SET @UserCode = (SELECT TOP 1 user_code FROM deleted)

	IF (@UserCode IS NOT NULL)
	BEGIN
		EXEC pso_RemoveLockedContacts @UserCode
	END
END
GO
ALTER TABLE [dbo].[onca_user_log] ENABLE TRIGGER [pso_UnlockContacts]
GO
