/* CreateDate: 01/18/2005 09:34:08.233 , ModifyDate: 09/10/2019 22:56:14.507 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
CREATE TABLE [dbo].[oncd_activity_user](
	[activity_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
	[attendance] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_activity_user] PRIMARY KEY CLUSTERED
(
	[activity_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_user_i2] ON [dbo].[oncd_activity_user]
(
	[activity_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_user]  WITH CHECK ADD  CONSTRAINT [activity_activity_use_103] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_user] CHECK CONSTRAINT [activity_activity_use_103]
GO
ALTER TABLE [dbo].[oncd_activity_user]  WITH CHECK ADD  CONSTRAINT [user_activity_use_493] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_user] CHECK CONSTRAINT [user_activity_use_493]
GO
ALTER TABLE [dbo].[oncd_activity_user]  WITH CHECK ADD  CONSTRAINT [user_activity_use_494] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_user] CHECK CONSTRAINT [user_activity_use_494]
GO
ALTER TABLE [dbo].[oncd_activity_user]  WITH CHECK ADD  CONSTRAINT [user_activity_use_495] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_user] CHECK CONSTRAINT [user_activity_use_495]
GO
-- =============================================================================
-- Create date: 17 March 2010
-- Description:	Ensures that there is not more than one primary user per
--				activity.  This trigger does not ensure that a primary user is
--				assigned to an activity; just that there is only a single user
--				set as primary.
-- =============================================================================
CREATE TRIGGER [dbo].[pso_SinglePrimaryActivityUser]
   ON  [dbo].[oncd_activity_user]
   AFTER INSERT,UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @activityUserId NCHAR(10)
	DECLARE @activityId NCHAR(10)

	-- The trigger should only run the first time and should not recurse.
    IF ((SELECT TRIGGER_NESTLEVEL()) = 1 )
	BEGIN

		-- Updated values are processed by triggers as a delete then insert.
		DECLARE activity_user_cursor CURSOR
		FOR
			SELECT inserted.activity_user_id, inserted.activity_id
			FROM inserted
			WHERE inserted.primary_flag = 'Y'

		OPEN activity_user_cursor

		FETCH NEXT FROM activity_user_cursor
		INTO @activityUserId, @activityId

		WHILE ( @@FETCH_STATUS = 0 )
		BEGIN

			UPDATE oncd_activity_user
			SET primary_flag = 'N'
			WHERE
			activity_id = @activityId AND
			primary_flag = 'Y' AND
			activity_user_id <> @activityUserId

			FETCH NEXT FROM activity_user_cursor
			INTO @activityUserId, @activityId
		END

		CLOSE activity_user_cursor
		DEALLOCATE activity_user_cursor
	END
END
GO
ALTER TABLE [dbo].[oncd_activity_user] ENABLE TRIGGER [pso_SinglePrimaryActivityUser]
GO
