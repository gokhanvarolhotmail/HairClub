/* CreateDate: 01/18/2005 09:34:08.157 , ModifyDate: 09/10/2019 22:54:57.240 */
/* ***HasTriggers*** TriggerCount: 2 */
GO
CREATE TABLE [dbo].[oncd_activity_contact](
	[activity_contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[assignment_date] [datetime] NULL,
	[attendance] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_activity_contact] PRIMARY KEY CLUSTERED
(
	[activity_contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_oncd_activity_contact_creation_date] ON [dbo].[oncd_activity_contact]
(
	[creation_date] ASC
)
INCLUDE([contact_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_contact] ON [dbo].[oncd_activity_contact]
(
	[contact_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_contact_i2] ON [dbo].[oncd_activity_contact]
(
	[activity_id] ASC,
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_contact_i3] ON [dbo].[oncd_activity_contact]
(
	[activity_id] ASC
)
INCLUDE([contact_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_contact]  WITH CHECK ADD  CONSTRAINT [activity_activity_con_98] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_contact] CHECK CONSTRAINT [activity_activity_con_98]
GO
ALTER TABLE [dbo].[oncd_activity_contact]  WITH CHECK ADD  CONSTRAINT [contact_activity_con_104] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_contact] CHECK CONSTRAINT [contact_activity_con_104]
GO
ALTER TABLE [dbo].[oncd_activity_contact]  WITH CHECK ADD  CONSTRAINT [user_activity_con_455] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_contact] CHECK CONSTRAINT [user_activity_con_455]
GO
ALTER TABLE [dbo].[oncd_activity_contact]  WITH CHECK ADD  CONSTRAINT [user_activity_con_456] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_contact] CHECK CONSTRAINT [user_activity_con_456]
GO
-- =============================================
-- Author:		Oncontact PSO Fred Remers
-- ALTER  date: 4/23/08
-- Description:	Call sp to close activities based on action/result

-- ALTER  date: 10/1/2009
-- Description: Exec dbo.pso_CheckSourceCode
-- =============================================
CREATE TRIGGER [dbo].[pso_oncd_activity_contact_insert]
   ON  [dbo].[oncd_activity_contact]
   AFTER INSERT AS
BEGIN
	DECLARE @activity_id nchar(10)
	DECLARE @action_code nchar(10)
	DECLARE @result_code nchar(10)
	DECLARE @contact_id nchar(10)

	IF ( (SELECT trigger_nestlevel() ) <= 2 )
	BEGIN
		IF Cursor_Status('local', 'cursor_activity_contact_insert') >= 0
		BEGIN
			CLOSE cursor_activity_contact_insert
			DEALLOCATE cursor_activity_contact_insert
		END

		IF Cursor_Status('global', 'cursor_activity_contact_insert') >= 0
		BEGIN
			CLOSE cursor_activity_contact_insert
			DEALLOCATE cursor_activity_contact_insert
		END

		-- Check to make sure that the trigger user exists in onca_user and add it if the user does not
		IF (SELECT user_code FROM onca_user WHERE user_code = 'TRIGGER') IS NULL
		INSERT INTO onca_user (user_code, description, display_name, active) VALUES ('TRIGGER', 'Trigger', 'Trigger', 'N')

		DECLARE cursor_activity_contact_insert CURSOR FOR
			SELECT top 1 activity_id, contact_id
			FROM inserted

		OPEN cursor_activity_contact_insert

		FETCH NEXT FROM cursor_activity_contact_insert INTO @activity_id, @contact_id

		SET @action_code = (select action_code from oncd_activity where activity_id = @activity_id)
		SET @result_code = (select result_code from oncd_activity where activity_id = @activity_id)

		WHILE (  @@fetch_status = 0 )
		BEGIN
			exec pso_DispositionActivities @activity_id, @action_code, @result_code, @contact_id
			exec dbo.pso_CheckSourceCode @activity_id
			FETCH NEXT FROM cursor_activity_contact_insert INTO @activity_id, @contact_id
		END



		CLOSE cursor_activity_contact_insert
		DEALLOCATE cursor_activity_contact_insert
	END
END
GO
ALTER TABLE [dbo].[oncd_activity_contact] ENABLE TRIGGER [pso_oncd_activity_contact_insert]
GO
CREATE TRIGGER [dbo].[pso_QueueAssignment]
   ON  [dbo].[oncd_activity_contact]
   AFTER INSERT, UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE oncd_activity
	SET cst_queue_id = dbo.psoTemporaryQueueAssignment(	oncd_activity.due_date,
														oncd_activity.action_code,
														oncd_contact.cst_language_code,
														oncd_activity.creation_date,
														oncd_activity.created_by_user_code,
														oncd_contact.cst_age_range_code)
	FROM inserted WITH (NOLOCK)
	INNER JOIN oncd_activity WITH (NOLOCK) ON inserted.activity_id = oncd_activity.activity_id
	INNER JOIN oncd_contact WITH (NOLOCK) ON inserted.contact_id = oncd_contact.contact_id
	WHERE
	oncd_contact.contact_status_code = 'LEAD' AND
	oncd_contact.do_not_solicit = 'N' AND
	oncd_contact.cst_do_not_call = 'N' AND
	oncd_activity.result_code IS NULL AND
	oncd_activity.cst_queue_id IS NULL

	--INSERT INTO cstd_queue_staging (activity_id)
	--SELECT inserted.activity_id
	--FROM inserted
	--INNER JOIN oncd_activity (NOLOCK) ON inserted.activity_id = oncd_activity.activity_id
	--WHERE oncd_activity.result_code IS NULL

	--DECLARE @ActivityId NCHAR(10)
	--SET @ActivityId = (SELECT TOP 1 activity_id FROM cstd_queue_staging)

	--WHILE (@ActivityId IS NOT NULL)
	--BEGIN
	--	DELETE FROM cstd_queue_staging WHERE activity_id = @ActivityId

	--	EXEC psoQueueAssign @ActivityId

	--	SET @ActivityId = (SELECT TOP 1 activity_id FROM cstd_queue_staging)
	--END
END
GO
ALTER TABLE [dbo].[oncd_activity_contact] ENABLE TRIGGER [pso_QueueAssignment]
GO
