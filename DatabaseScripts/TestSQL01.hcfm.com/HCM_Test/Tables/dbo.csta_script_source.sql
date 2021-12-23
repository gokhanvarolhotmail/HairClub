/* CreateDate: 10/04/2006 16:26:48.517 , ModifyDate: 11/14/2012 17:11:05.687 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
CREATE TABLE [dbo].[csta_script_source](
	[script_source_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[script_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[assignment_date] [datetime] NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_script_source] PRIMARY KEY NONCLUSTERED
(
	[script_source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_script_source] ADD  CONSTRAINT [DF__csta_scri__activ__0F824689]  DEFAULT ('Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_script_source]  WITH NOCHECK ADD  CONSTRAINT [csta_script_csta_script_source_724] FOREIGN KEY([script_code])
REFERENCES [dbo].[csta_script] ([script_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_script_source] CHECK CONSTRAINT [csta_script_csta_script_source_724]
GO
ALTER TABLE [dbo].[csta_script_source]  WITH NOCHECK ADD  CONSTRAINT [onca_source_csta_script_source_770] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[csta_script_source] CHECK CONSTRAINT [onca_source_csta_script_source_770]
GO
-- =============================================================================
-- Create date: 14 November 2012
-- Description:	Ensures that csta_script.updated_date is updated when a source is
--              changed.
-- =============================================================================
CREATE TRIGGER [dbo].[ScriptSourceModified]
   ON  [dbo].[csta_script_source]
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
ALTER TABLE [dbo].[csta_script_source] ENABLE TRIGGER [ScriptSourceModified]
GO
