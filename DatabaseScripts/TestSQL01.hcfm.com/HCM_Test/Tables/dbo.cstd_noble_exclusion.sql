/* CreateDate: 09/26/2011 10:55:32.267 , ModifyDate: 08/11/2014 01:01:11.767 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
CREATE TABLE [dbo].[cstd_noble_exclusion](
	[noble_exclusion_id] [int] IDENTITY(1,1) NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[exclusion_date] [datetime] NOT NULL,
	[output_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_cstd_noble_exclusions] PRIMARY KEY CLUSTERED
(
	[noble_exclusion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [cstd_noble_exclusions_i2] ON [dbo].[cstd_noble_exclusion]
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_noble_exclusion] ADD  CONSTRAINT [DF_cstd_noble_exclusion_exclusion_date]  DEFAULT (getdate()) FOR [exclusion_date]
GO
ALTER TABLE [dbo].[cstd_noble_exclusion] ADD  CONSTRAINT [DF_cstd_noble_exclusions_output_flag]  DEFAULT ('N') FOR [output_flag]
GO
ALTER TABLE [dbo].[cstd_noble_exclusion]  WITH CHECK ADD  CONSTRAINT [FK_cstd_noble_exclusion_oncd_activity] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
GO
ALTER TABLE [dbo].[cstd_noble_exclusion] CHECK CONSTRAINT [FK_cstd_noble_exclusion_oncd_activity]
GO
-- =============================================
-- Create date: 21 September 2011
-- Project #  : 8
-- Description:	Sets any Noble Contact records to processed when a record
--				is added as a Noble Exclusion to prevent sending processed
--				records to Noble according to the below business rules.
--				 1. Exclusion record exists in Noble Contacts
--						cstd_noble_exclusion.activity_id = cstd_noble_contacts.activity_id
--				 2. Noble Contacts record has not been processed
--						cstd_noble_contacts.status = 'NEW'
-- =============================================
CREATE TRIGGER [dbo].[pso_NobleExclusionCreated]
   ON  [dbo].[cstd_noble_exclusion]
   AFTER INSERT,UPDATE
AS
BEGIN
	-- The cstd_noble_exclusion.activity_id for the inserted/updated exclusions.
	DECLARE @ActivityId NCHAR(10)

	-- Use a cursor so that everything processes if a transaction or batch insert/update is used.
	-- Process only the records fitting within the below business rules:
	--  1. Exclusion record exists in Noble Contacts
	--		cstd_noble_exclusion.activity_id = cstd_noble_contacts.activity_id
	--  2. Noble Contacts record has not been processed
	--		cstd_noble_contacts.status = 'NEW'
	DECLARE ExclusionCursor CURSOR FOR
		SELECT inserted.activity_id
		FROM inserted
		LEFT OUTER JOIN cstd_noble_contacts ON
			inserted.activity_id = cstd_noble_contacts.activity_id
		WHERE
		cstd_noble_contacts.activity_id IS NOT NULL AND
		cstd_noble_contacts.status = 'NEW'

	OPEN ExclusionCursor

	FETCH NEXT FROM ExclusionCursor
	INTO @ActivityId

	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- Update the Noble Contact record to show as processed so
		-- that it is not sent to Noble the next time the sync process
		-- runs.
		UPDATE cstd_noble_contacts
		SET
			status = 'PROCESSED',
			updated_date = GETDATE()
		WHERE activity_id = @ActivityId

		FETCH NEXT FROM ExclusionCursor
		INTO @ActivityId
	END
	CLOSE ExclusionCursor
	DEALLOCATE ExclusionCursor
END
GO
ALTER TABLE [dbo].[cstd_noble_exclusion] ENABLE TRIGGER [pso_NobleExclusionCreated]
GO
