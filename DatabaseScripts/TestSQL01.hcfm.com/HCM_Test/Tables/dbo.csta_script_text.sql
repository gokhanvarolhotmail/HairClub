/* CreateDate: 10/04/2006 16:26:48.440 , ModifyDate: 11/14/2012 17:11:10.320 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
CREATE TABLE [dbo].[csta_script_text](
	[script_text_id] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[script_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_csta_script_text] PRIMARY KEY NONCLUSTERED
(
	[script_text_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ__csta_script_text__0CA5D9DE] ON [dbo].[csta_script_text]
(
	[script_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_script_text]  WITH CHECK ADD  CONSTRAINT [csta_script_csta_script_text_723] FOREIGN KEY([script_code])
REFERENCES [dbo].[csta_script] ([script_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_script_text] CHECK CONSTRAINT [csta_script_csta_script_text_723]
GO
-- =============================================================================
-- Create date: 14 November 2012
-- Description:	Ensures that csta_script.updated_date is updated when text is
--              changed.
-- =============================================================================
CREATE TRIGGER [dbo].[ScriptTextModified]
   ON  [dbo].[csta_script_text]
   AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	SET NOCOUNT ON;

    UPDATE csta_script
	SET
		updated_date = GETDATE()
	WHERE
		script_code IN (SELECT script_code FROM inserted
						UNION
						SELECT script_code FROM deleted)
END
GO
ALTER TABLE [dbo].[csta_script_text] ENABLE TRIGGER [ScriptTextModified]
GO
