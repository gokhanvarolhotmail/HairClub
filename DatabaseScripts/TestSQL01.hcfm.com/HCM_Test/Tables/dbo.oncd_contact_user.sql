/* CreateDate: 01/18/2005 09:34:09.250 , ModifyDate: 10/23/2017 12:35:40.133 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
CREATE TABLE [dbo].[oncd_contact_user](
	[contact_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[job_function_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_user] PRIMARY KEY CLUSTERED
(
	[contact_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_user_i1] ON [dbo].[oncd_contact_user]
(
	[contact_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_user]  WITH NOCHECK ADD  CONSTRAINT [contact_contact_user_75] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_user] CHECK CONSTRAINT [contact_contact_user_75]
GO
ALTER TABLE [dbo].[oncd_contact_user]  WITH NOCHECK ADD  CONSTRAINT [job_function_contact_user_626] FOREIGN KEY([job_function_code])
REFERENCES [dbo].[onca_job_function] ([job_function_code])
GO
ALTER TABLE [dbo].[oncd_contact_user] CHECK CONSTRAINT [job_function_contact_user_626]
GO
ALTER TABLE [dbo].[oncd_contact_user]  WITH NOCHECK ADD  CONSTRAINT [user_contact_user_623] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_user] CHECK CONSTRAINT [user_contact_user_623]
GO
ALTER TABLE [dbo].[oncd_contact_user]  WITH NOCHECK ADD  CONSTRAINT [user_contact_user_624] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_user] CHECK CONSTRAINT [user_contact_user_624]
GO
ALTER TABLE [dbo].[oncd_contact_user]  WITH NOCHECK ADD  CONSTRAINT [user_contact_user_625] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_user] CHECK CONSTRAINT [user_contact_user_625]
GO
-- =============================================================================
-- Create date: 22 March 2010
-- Description:	Ensures that there is not more than one primary user per
--				contact.  This trigger does not ensure that a primary user is
--				assigned to a contact; just that there is only a single user
--				set as primary.
-- =============================================================================
CREATE TRIGGER [dbo].[pso_SinglePrimaryUser]
   ON  [dbo].[oncd_contact_user]
   AFTER INSERT,UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @contactUserId NCHAR(10)
	DECLARE @contactId NCHAR(10)

	-- The trigger should only run the first time and should not recurse.
    IF ((SELECT TRIGGER_NESTLEVEL()) = 1 )
	BEGIN

		-- Updated values are processed by triggers as a delete then insert.
		DECLARE contact_user_cursor CURSOR
		FOR
			SELECT inserted.contact_user_id, inserted.contact_id
			FROM inserted
			WHERE inserted.primary_flag = 'Y'

		OPEN contact_user_cursor

		FETCH NEXT FROM contact_user_cursor
		INTO @contactUserId, @contactId

		WHILE ( @@FETCH_STATUS = 0 )
		BEGIN

			UPDATE oncd_contact_user
			SET primary_flag = 'N'
			WHERE
			contact_id = @contactId AND
			primary_flag = 'Y' AND
			contact_user_id <> @contactUserId

			FETCH NEXT FROM contact_user_cursor
			INTO @contactUserId, @contactId
		END

		CLOSE contact_user_cursor
		DEALLOCATE contact_user_cursor
	END
END
GO
ALTER TABLE [dbo].[oncd_contact_user] ENABLE TRIGGER [pso_SinglePrimaryUser]
GO
