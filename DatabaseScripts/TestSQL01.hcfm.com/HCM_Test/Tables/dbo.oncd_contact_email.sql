/* CreateDate: 01/18/2005 09:34:08.890 , ModifyDate: 10/23/2017 12:35:40.127 */
/* ***HasTriggers*** TriggerCount: 3 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_contact_email](
	[contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[email_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_valid_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_skip_trace_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_email] PRIMARY KEY CLUSTERED
(
	[contact_email_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_contact_email_i3] ON [dbo].[oncd_contact_email]
(
	[contact_id] ASC,
	[primary_flag] ASC
)
INCLUDE([email],[cst_valid_flag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_email_i2] ON [dbo].[oncd_contact_email]
(
	[contact_id] ASC,
	[primary_flag] ASC,
	[active] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_email] ADD  CONSTRAINT [DF_oncd_contact_email_cst_valid_flag]  DEFAULT (N'Y') FOR [cst_valid_flag]
GO
ALTER TABLE [dbo].[oncd_contact_email]  WITH CHECK ADD  CONSTRAINT [contact_contact_emai_76] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_email] CHECK CONSTRAINT [contact_contact_emai_76]
GO
ALTER TABLE [dbo].[oncd_contact_email]  WITH CHECK ADD  CONSTRAINT [contact_email_vendor] FOREIGN KEY([cst_skip_trace_vendor_code])
REFERENCES [dbo].[csta_skip_trace_vendor] ([skip_trace_vendor_code])
GO
ALTER TABLE [dbo].[oncd_contact_email] CHECK CONSTRAINT [contact_email_vendor]
GO
ALTER TABLE [dbo].[oncd_contact_email]  WITH CHECK ADD  CONSTRAINT [email_type_contact_emai_592] FOREIGN KEY([email_type_code])
REFERENCES [dbo].[onca_email_type] ([email_type_code])
GO
ALTER TABLE [dbo].[oncd_contact_email] CHECK CONSTRAINT [email_type_contact_emai_592]
GO
ALTER TABLE [dbo].[oncd_contact_email]  WITH CHECK ADD  CONSTRAINT [user_contact_emai_590] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_email] CHECK CONSTRAINT [user_contact_emai_590]
GO
ALTER TABLE [dbo].[oncd_contact_email]  WITH CHECK ADD  CONSTRAINT [user_contact_emai_591] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_email] CHECK CONSTRAINT [user_contact_emai_591]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 24 September 2012
-- Description:	Removes Unicode
-- =============================================
CREATE TRIGGER [dbo].[pso_oncd_contact_email_remove_unicode_insert]
   ON  [dbo].[oncd_contact_email]
   INSTEAD OF INSERT
AS
BEGIN

INSERT INTO [dbo].[oncd_contact_email]
           ([contact_email_id]
           ,[contact_id]
           ,[email_type_code]
           ,[email]
           ,[description]
           ,[active]
           ,[sort_order]
           ,[creation_date]
           ,[created_by_user_code]
           ,[updated_date]
           ,[updated_by_user_code]
           ,[primary_flag])
     SELECT
            inserted.contact_email_id
           ,inserted.contact_id
           ,inserted.email_type_code
           ,dbo.RemoveUnicode(email)
           ,dbo.RemoveUnicode(description)
           ,dbo.RemoveUnicode(active)
           ,inserted.sort_order
           ,inserted.creation_date
           ,inserted.created_by_user_code
           ,inserted.updated_date
           ,inserted.updated_by_user_code
           ,dbo.RemoveUnicode(primary_flag)
     FROM inserted

END
GO
ALTER TABLE [dbo].[oncd_contact_email] DISABLE TRIGGER [pso_oncd_contact_email_remove_unicode_insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 24 September 2012
-- Description:	Removes Unicode
-- =============================================
CREATE TRIGGER [dbo].[pso_oncd_contact_email_remove_unicode_update]
   ON  [dbo].[oncd_contact_email]
   INSTEAD OF UPDATE
AS
BEGIN

UPDATE [dbo].[oncd_contact_email]
   SET [contact_email_id] = inserted.contact_email_id
      ,[contact_id] = inserted.contact_id
      ,[email_type_code] = inserted.email_type_code
      ,[email] = dbo.RemoveUnicode(inserted.email)
      ,[description] = dbo.RemoveUnicode(inserted.description)
      ,[active] = dbo.RemoveUnicode(inserted.active)
      ,[sort_order] = inserted.sort_order
      ,[creation_date] = inserted.creation_date
      ,[created_by_user_code] = inserted.created_by_user_code
      ,[updated_date] = inserted.updated_date
      ,[updated_by_user_code] = inserted.updated_by_user_code
      ,[primary_flag] = dbo.RemoveUnicode(inserted.primary_flag)
FROM inserted
WHERE inserted.contact_email_id = oncd_contact_email.contact_email_id


END
GO
ALTER TABLE [dbo].[oncd_contact_email] DISABLE TRIGGER [pso_oncd_contact_email_remove_unicode_update]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================
-- Create date: 22 March 2010
-- Description:	Ensures that there is not more than one primary email per
--				contact.  This trigger does not ensure that a primary email is
--				assigned to a contact; just that there is only a single email
--				set as primary.
-- =============================================================================
CREATE TRIGGER [dbo].[pso_SinglePrimaryEmail]
   ON  [dbo].[oncd_contact_email]
   AFTER INSERT,UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @contactEmailId NCHAR(10)
	DECLARE @contactId NCHAR(10)

	-- The trigger should only run the first time and should not recurse.
    IF ((SELECT TRIGGER_NESTLEVEL()) = 1 )
	BEGIN

		-- Updated values are processed by triggers as a delete then insert.
		DECLARE contact_email_cursor CURSOR
		FOR
			SELECT inserted.contact_email_id, inserted.contact_id
			FROM inserted
			WHERE inserted.primary_flag = 'Y'

		OPEN contact_email_cursor

		FETCH NEXT FROM contact_email_cursor
		INTO @contactEmailId, @contactId

		WHILE ( @@FETCH_STATUS = 0 )
		BEGIN

			UPDATE oncd_contact_email
			SET primary_flag = 'N'
			WHERE
			contact_id = @contactId AND
			primary_flag = 'Y' AND
			contact_email_id <> @contactEmailId

			FETCH NEXT FROM contact_email_cursor
			INTO @contactEmailId, @contactId
		END

		CLOSE contact_email_cursor
		DEALLOCATE contact_email_cursor
	END
END
GO
ALTER TABLE [dbo].[oncd_contact_email] ENABLE TRIGGER [pso_SinglePrimaryEmail]
GO
