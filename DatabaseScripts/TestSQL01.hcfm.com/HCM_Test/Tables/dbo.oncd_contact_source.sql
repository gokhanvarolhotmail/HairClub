/* CreateDate: 10/04/2006 16:26:48.313 , ModifyDate: 09/10/2019 22:26:07.447 */
/* ***HasTriggers*** TriggerCount: 3 */
GO
CREATE TABLE [dbo].[oncd_contact_source](
	[contact_source_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[media_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_dnis_number] [int] NULL,
	[cst_sub_source_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_source] PRIMARY KEY CLUSTERED
(
	[contact_source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_source_i2] ON [dbo].[oncd_contact_source]
(
	[contact_id] ASC,
	[primary_flag] ASC
)
INCLUDE([source_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_source]  WITH CHECK ADD  CONSTRAINT [contact_contact_sour_70] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_source] CHECK CONSTRAINT [contact_contact_sour_70]
GO
ALTER TABLE [dbo].[oncd_contact_source]  WITH CHECK ADD  CONSTRAINT [media_contact_sour_618] FOREIGN KEY([media_code])
REFERENCES [dbo].[onca_media] ([media_code])
GO
ALTER TABLE [dbo].[oncd_contact_source] CHECK CONSTRAINT [media_contact_sour_618]
GO
ALTER TABLE [dbo].[oncd_contact_source]  WITH CHECK ADD  CONSTRAINT [source_contact_sour_619] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[oncd_contact_source] CHECK CONSTRAINT [source_contact_sour_619]
GO
ALTER TABLE [dbo].[oncd_contact_source]  WITH CHECK ADD  CONSTRAINT [user_contact_sour_616] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_source] CHECK CONSTRAINT [user_contact_sour_616]
GO
ALTER TABLE [dbo].[oncd_contact_source]  WITH CHECK ADD  CONSTRAINT [user_contact_sour_617] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_source] CHECK CONSTRAINT [user_contact_sour_617]
GO
CREATE TRIGGER [dbo].[pso_oncd_contact_source_after_delete]
   ON  [dbo].[oncd_contact_source]
   AFTER DELETE
AS
	--Set Primary Source
	--Set Primary Source
	UPDATE cstd_contact_flat SET
		primary_source_description = s.description
	FROM deleted
	LEFT OUTER JOIN oncd_contact_source (NOLOCK) cs on cs.contact_id = deleted.contact_id
		AND cs.primary_flag = 'Y'
	LEFT OUTER JOIN onca_source (NOLOCK) s ON s.source_code = cs.source_code
	INNER JOIN cstd_contact_flat on deleted.contact_id = cstd_contact_flat.contact_id
GO
ALTER TABLE [dbo].[oncd_contact_source] ENABLE TRIGGER [pso_oncd_contact_source_after_delete]
GO
CREATE TRIGGER [dbo].[pso_oncd_contact_source_after_insert_update]
   ON  [dbo].[oncd_contact_source]
   AFTER INSERT, UPDATE
AS
	--Set Primary Source
	UPDATE cstd_contact_flat SET
		primary_source_description = s.description
	FROM inserted
	LEFT OUTER JOIN oncd_contact_source (NOLOCK) cs on cs.contact_id = inserted.contact_id
		AND cs.primary_flag = 'Y'
	LEFT OUTER JOIN onca_source (NOLOCK) s ON s.source_code = cs.source_code
	INNER JOIN cstd_contact_flat on inserted.contact_id = cstd_contact_flat.contact_id
GO
ALTER TABLE [dbo].[oncd_contact_source] ENABLE TRIGGER [pso_oncd_contact_source_after_insert_update]
GO
-- =============================================================================
-- Create date: 22 March 2010
-- Description:	Ensures that there is not more than one primary source per
--				contact.  This trigger does not ensure that a primary source is
--				assigned to a contact; just that there is only a single source
--				set as primary.
-- =============================================================================
CREATE TRIGGER [dbo].[pso_SinglePrimarySource]
   ON  [dbo].[oncd_contact_source]
   AFTER INSERT,UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @contactSourceId NCHAR(10)
	DECLARE @contactId NCHAR(10)

	-- The trigger should only run the first time and should not recurse.
    IF ((SELECT TRIGGER_NESTLEVEL()) = 1 )
	BEGIN

		-- Updated values are processed by triggers as a delete then insert.
		DECLARE contact_source_cursor CURSOR
		FOR
			SELECT inserted.contact_source_id, inserted.contact_id
			FROM inserted
			WHERE inserted.primary_flag = 'Y'

		OPEN contact_source_cursor

		FETCH NEXT FROM contact_source_cursor
		INTO @contactSourceId, @contactId

		WHILE ( @@FETCH_STATUS = 0 )
		BEGIN

			UPDATE oncd_contact_source
			SET primary_flag = 'N'
			WHERE
			contact_id = @contactId AND
			primary_flag = 'Y' AND
			contact_source_id <> @contactSourceId

			FETCH NEXT FROM contact_source_cursor
			INTO @contactSourceId, @contactId
		END

		CLOSE contact_source_cursor
		DEALLOCATE contact_source_cursor
	END
END
GO
ALTER TABLE [dbo].[oncd_contact_source] ENABLE TRIGGER [pso_SinglePrimarySource]
GO
