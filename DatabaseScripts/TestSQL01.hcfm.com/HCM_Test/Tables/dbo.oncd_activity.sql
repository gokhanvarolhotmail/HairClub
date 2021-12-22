/* CreateDate: 01/18/2005 09:34:08.093 , ModifyDate: 09/10/2019 23:07:44.787 */
/* ***HasTriggers*** TriggerCount: 8 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_activity](
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[recur_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[opportunity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[incident_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[due_date] [datetime] NULL,
	[start_time] [datetime] NULL,
	[duration] [int] NULL,
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[completion_date] [datetime] NULL,
	[completion_time] [datetime] NULL,
	[completed_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[priority] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[notify_when_completed] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[confirmed_time] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[confirmed_time_from] [datetime] NULL,
	[confirmed_time_to] [datetime] NULL,
	[document_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[milestone_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_override_time_zone] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_lock_date] [datetime] NULL,
	[cst_lock_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_activity_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_promotion_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_no_followup_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_followup_time] [datetime] NULL,
	[cst_followup_date] [datetime] NULL,
	[cst_time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_utc_start_date] [datetime] NULL,
	[cst_brochure_download] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_queue_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_in_noble_queue] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_language_code]  AS ([dbo].[psoActivityLanguage]([activity_id])),
 CONSTRAINT [pk_oncd_activity] PRIMARY KEY CLUSTERED
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_activity_i1] ON [dbo].[oncd_activity]
(
	[completion_date] ASC,
	[completed_by_user_code] ASC
)
INCLUDE([cst_queue_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_activity_i2] ON [dbo].[oncd_activity]
(
	[result_code] ASC,
	[cst_time_zone_code] ASC,
	[action_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_activity_i3] ON [dbo].[oncd_activity]
(
	[result_code] ASC,
	[action_code] ASC,
	[due_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_activity_i4] ON [dbo].[oncd_activity]
(
	[action_code] ASC,
	[creation_date] ASC
)
INCLUDE([result_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_oncd_activity_action_code_INCL] ON [dbo].[oncd_activity]
(
	[action_code] ASC
)
INCLUDE([activity_id],[due_date],[start_time],[creation_date],[completion_date],[completion_time],[completed_by_user_code],[updated_date],[result_code],[source_code],[cst_activity_type_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_oncd_activity_completion_date_INCL] ON [dbo].[oncd_activity]
(
	[completion_date] ASC,
	[source_code] ASC
)
INCLUDE([activity_id],[due_date],[action_code],[creation_date],[result_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_i10] ON [dbo].[oncd_activity]
(
	[cst_in_noble_queue] ASC
)
INCLUDE([action_code],[result_code],[cst_time_zone_code],[due_date],[start_time]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_i14] ON [dbo].[oncd_activity]
(
	[creation_date] ASC,
	[created_by_user_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_i16] ON [dbo].[oncd_activity]
(
	[action_code] ASC,
	[result_code] ASC,
	[cst_activity_type_code] ASC,
	[cst_time_zone_code] ASC,
	[due_date] ASC,
	[start_time] ASC
)
INCLUDE([creation_date]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_i18] ON [dbo].[oncd_activity]
(
	[cst_lock_by_user_code] ASC,
	[cst_queue_id] ASC
)
INCLUDE([activity_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_i19] ON [dbo].[oncd_activity]
(
	[cst_queue_id] ASC,
	[result_code] ASC
)
INCLUDE([activity_id])
WHERE ([oncd_activity].[result_code] IS NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [oncd_activity_i20] ON [dbo].[oncd_activity]
(
	[result_code] ASC,
	[completion_date] DESC,
	[completion_time] DESC,
	[activity_id] ASC
)
INCLUDE([cst_queue_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [oncd_activity_i21] ON [dbo].[oncd_activity]
(
	[completion_date] DESC,
	[completion_time] DESC,
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_i23] ON [dbo].[oncd_activity]
(
	[result_code] ASC,
	[cst_queue_id] ASC,
	[due_date] ASC,
	[cst_lock_by_user_code] ASC
)
INCLUDE([start_time],[cst_time_zone_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_i24] ON [dbo].[oncd_activity]
(
	[action_code] ASC,
	[due_date] ASC
)
INCLUDE([activity_id],[start_time]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_i7] ON [dbo].[oncd_activity]
(
	[action_code] ASC,
	[result_code] ASC,
	[due_date] ASC,
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [oncd_activity_i9] ON [dbo].[oncd_activity]
(
	[due_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity] ADD  CONSTRAINT [DF_oncd_activity_cst_brochure_download]  DEFAULT (N'N') FOR [cst_brochure_download]
GO
ALTER TABLE [dbo].[oncd_activity] ADD  CONSTRAINT [DF_oncd_activity_cst_in_noble_queue]  DEFAULT (N'N') FOR [cst_in_noble_queue]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [action_activity_439] FOREIGN KEY([action_code])
REFERENCES [dbo].[onca_action] ([action_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [action_activity_439]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [address_type_activity_443] FOREIGN KEY([batch_address_type_code])
REFERENCES [dbo].[onca_address_type] ([address_type_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [address_type_activity_443]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [batch_status_activity_441] FOREIGN KEY([batch_status_code])
REFERENCES [dbo].[onca_batch_status] ([batch_status_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [batch_status_activity_441]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [campaign_activity_445] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [campaign_activity_445]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [csta_activity_type_oncd_activity_816] FOREIGN KEY([cst_activity_type_code])
REFERENCES [dbo].[csta_activity_type] ([activity_type_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [csta_activity_type_oncd_activity_816]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [document_activity_447] FOREIGN KEY([document_id])
REFERENCES [dbo].[onca_document] ([document_id])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [document_activity_447]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [FK_oncd_activity_csta_promotion_code] FOREIGN KEY([cst_promotion_code])
REFERENCES [dbo].[csta_promotion_code] ([promotion_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [FK_oncd_activity_csta_promotion_code]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [FK_oncd_activity_csta_queue] FOREIGN KEY([cst_queue_id])
REFERENCES [dbo].[csta_queue] ([queue_id])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [FK_oncd_activity_csta_queue]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [incident_activity_183] FOREIGN KEY([incident_id])
REFERENCES [dbo].[oncd_incident] ([incident_id])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [incident_activity_183]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [milestone_ac_activity_448] FOREIGN KEY([milestone_activity_id])
REFERENCES [dbo].[onca_milestone_activity] ([milestone_activity_id])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [milestone_ac_activity_448]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [onca_project_oncd_activity_444] FOREIGN KEY([project_code])
REFERENCES [dbo].[onca_project] ([project_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [onca_project_oncd_activity_444]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [onca_user_oncd_activity_812] FOREIGN KEY([cst_lock_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [onca_user_oncd_activity_812]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [opportunity_activity_182] FOREIGN KEY([opportunity_id])
REFERENCES [dbo].[oncd_opportunity] ([opportunity_id])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [opportunity_activity_182]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [project_activity_790] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [project_activity_790]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [project_activity_797] FOREIGN KEY([project_code])
REFERENCES [dbo].[onca_project] ([project_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [project_activity_797]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [recur_activity_208] FOREIGN KEY([recur_id])
REFERENCES [dbo].[oncd_recur] ([recur_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [recur_activity_208]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [result_activity_440] FOREIGN KEY([result_code])
REFERENCES [dbo].[onca_result] ([result_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [result_activity_440]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [result_activity_442] FOREIGN KEY([batch_result_code])
REFERENCES [dbo].[onca_result] ([result_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [result_activity_442]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [source_activity_446] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [source_activity_446]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [user_activity_436] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [user_activity_436]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [user_activity_437] FOREIGN KEY([completed_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [user_activity_437]
GO
ALTER TABLE [dbo].[oncd_activity]  WITH CHECK ADD  CONSTRAINT [user_activity_438] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity] CHECK CONSTRAINT [user_activity_438]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================
-- Create date: 9 November 2011
-- Description:	Stores the modifications done to an Activity.
-- ============================================================================
CREATE TRIGGER [dbo].[pso_ActivityHistory]
   ON [dbo].[oncd_activity]
   AFTER UPDATE
AS
BEGIN
INSERT INTO cstd_activity_history
           ([activity_id]
           ,[recur_id]
           ,[opportunity_id]
           ,[incident_id]
           ,[due_date]
           ,[start_time]
           ,[duration]
           ,[action_code]
           ,[description]
           ,[creation_date]
           ,[created_by_user_code]
           ,[completion_date]
           ,[completion_time]
           ,[completed_by_user_code]
           ,[updated_date]
           ,[updated_by_user_code]
           ,[result_code]
           ,[batch_status_code]
           ,[batch_result_code]
           ,[batch_address_type_code]
           ,[priority]
           ,[project_code]
           ,[notify_when_completed]
           ,[campaign_code]
           ,[source_code]
           ,[confirmed_time]
           ,[confirmed_time_from]
           ,[confirmed_time_to]
           ,[document_id]
           ,[milestone_activity_id]
           ,[cst_override_time_zone]
           ,[cst_lock_date]
           ,[cst_lock_by_user_code]
           ,[cst_activity_type_code]
           ,[cst_promotion_code]
           ,[cst_no_followup_flag]
           ,[cst_followup_time]
           ,[cst_followup_date]
           ,[cst_time_zone_code]
           ,[project_id]
           ,[cst_utc_start_date])
SELECT [activity_id]
           ,[recur_id]
           ,[opportunity_id]
           ,[incident_id]
           ,[due_date]
           ,[start_time]
           ,[duration]
           ,[action_code]
           ,[description]
           ,[creation_date]
           ,[created_by_user_code]
           ,[completion_date]
           ,[completion_time]
           ,[completed_by_user_code]
           ,[updated_date]
           ,[updated_by_user_code]
           ,[result_code]
           ,[batch_status_code]
           ,[batch_result_code]
           ,[batch_address_type_code]
           ,[priority]
           ,[project_code]
           ,[notify_when_completed]
           ,[campaign_code]
           ,[source_code]
           ,[confirmed_time]
           ,[confirmed_time_from]
           ,[confirmed_time_to]
           ,[document_id]
           ,[milestone_activity_id]
           ,[cst_override_time_zone]
           ,[cst_lock_date]
           ,[cst_lock_by_user_code]
           ,[cst_activity_type_code]
           ,[cst_promotion_code]
           ,[cst_no_followup_flag]
           ,[cst_followup_time]
           ,[cst_followup_date]
           ,[cst_time_zone_code]
           ,[project_id]
           ,[cst_utc_start_date]
          FROM deleted

END
GO
ALTER TABLE [dbo].[oncd_activity] DISABLE TRIGGER [pso_ActivityHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[pso_ActivityQueueHistory]
   ON  [dbo].[oncd_activity]
   AFTER INSERT, UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO csta_queue_history ( queue_date, queue_id, activity_id)
    SELECT GETDATE(), inserted.cst_queue_id, inserted.activity_id FROM inserted
	LEFT JOIN deleted on inserted.activity_id = deleted.activity_id
	WHERE
	inserted.cst_queue_id IS NOT NULL AND
	(inserted.cst_queue_id <> deleted.cst_queue_id OR deleted.cst_queue_id IS NULL)

END
GO
ALTER TABLE [dbo].[oncd_activity] ENABLE TRIGGER [pso_ActivityQueueHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Oncontact PSO Fred Remers
-- ALTER  date: 4/26/07
-- Description:	Trigger to generate followup activity
--
-- ALTER  date: 11/29/07
-- ALTER    by: Oncontact PSO Toby Clubb
-- Description: Added auditing information to closing activities
--
-- ALTER  date: 11/30/07
-- ALTER    by: Oncontact PSO Toby Clubb
-- Description: Added logic to check for do not call and do not solicit flags
--				before creating no show follow up activities.
--
-- ALTER  date: 4/2/08
-- ALTER    by: Oncontact PSO Fred Remers
-- Description: Application was changed to allow entry of a call back date/time for Confirm calls
--				Updated trigger to use entered date/time for generated activity
--
-- ALTER  date: 4/23/08
-- ALTER	by: Oncontact PSO Fred Remers
-- Description: Offloaded some processing to other stored procs
--				If Open Appointment never create new Marketing Activities
--				If No Open Appointments, take newest Marketing Activity and cancel any existing.
--
-- ALTER  date: 5/1/08
-- ALTER    by: Oncontact PSO Fred Remers
-- Description: Updated logic to not let confirms be generated if appointment has passed.
--
-- ALTER  date: 6/18/08
-- ALTER    by: Oncontact PSO Fred Remers
-- Description: If action code is APPOINT and result is NOSHOW, check how many APPOINT/NOSHOW
--				calls the contact has. If 4 or more, do not generate NOSHOW followup activity
--
-- ALTER  date: 12/04/08
-- ALTER    by: Oncontact PSO Fred Remers
-- Description: Added call to stored procedure pso_CheckContactStatus to maintain contact
--				status based on activity data
--
-- Updated:		6/1/2009 Added call to dbo.pso_CheckSourceCode
-- Updated By:	Oncontact PSO Fred Remers
--
-- ALTER date	9/28/2009
-- ALTER		Oncontact PSO Fred Remers
-- Description	Added check to exclude contacts with surgery_consultation_flag = 'Y'
--				on SHNOBUYCAL actvity generation

-- ALTER date	12/23/2009
-- ALTER		Oncontact PSO
-- Description	Assured usage of datetime values for comparisson logic between appointment date and current date

-- ALTER date	01/26/2010
-- ALTER		Oncontact PSO
-- Description	Per Hairclub request, create CONFIRM activities until the Appointment time instead of stopping at
--				the date of the Appointment.

-- ALTER Date	2 July 2010
-- ALTER		Oncontact PSO
-- Description	Per Hairclub request:
--				1. Need to delay the confirmation call activity for 15 minutes for the following scenario:
--						When a next day appointment is booked or is rescheduled for a different time on the following day.
--				2. When a "Same day" appointment is booked or rescheduled as long as it is still scheduled for the “Same Day” a following activity of “Confirm Call” should be created with a default result of “Direct Confirm” by a system trigger and the newly created “Confirm Activity” should be credited to the agent who booked or rescheduled the appointment.

-- ALTER Date	2 August 2010
-- ALTER		Oncontact PSO
-- Description	1. Added time zone handling so that activities scheduled in other timezones will correctly create followup activities.
--				2. General cleanup to ease readability.

-- Update Date:	11 July 2011
-- Description: No longer automatically closes/skips brochures.

-- Update Date: 24 August 2011
-- Description: Use Appointment date rather than Confirmation Call date to determine whether or
--				not the Confirmation Call should have 15 minutes added to the start time.

-- Update Date: 3 November 2011
-- Description: Next day Confirmation Calls should be resulted as Direct Confirm rather than
--              added to the queue.

-- Update Date: 25 May 2012
-- Description: Removing the automatic Direct Confirmation that occurs for Same Day/Next Day appointments when they come from TM 801 and TM 500

-- Update Date: 16 July 2015
-- Update By  : MJW - Workwise
-- Description: Removing the automatic Direct Confirmation that occurs for Same Day/Next Day appointments when they come from TM8xxx
-- =============================================

CREATE TRIGGER [dbo].[pso_GenerateFollowupActivity]
ON  [dbo].[oncd_activity]
AFTER UPDATE AS
BEGIN
	SET NOCOUNT ON;

	IF ( (SELECT trigger_nestlevel() ) <= 1 )
	BEGIN
		IF Cursor_Status('local', 'cursor_activity_data') >= 0
		BEGIN
			CLOSE cursor_activity_data;
			DEALLOCATE cursor_activity_data;
		END

		IF Cursor_Status('global', 'cursor_activity_data') >= 0
		BEGIN
			CLOSE cursor_activity_data;
			DEALLOCATE cursor_activity_data;
		END

		DECLARE @activity_id					NCHAR(10)
		DECLARE @action_code					NCHAR(10)
		DECLARE @old_action_code				NCHAR(10)
		DECLARE @result_code					NCHAR(10)
		DECLARE @old_result_code				NCHAR(10)
		DECLARE @cst_no_followup_flag			NCHAR(1)
		DECLARE @updated_by_user_code			NCHAR(20)
		DECLARE @created_by_user_code			NCHAR(20)
		DECLARE @due_date						DATETIME
		DECLARE @start_time						DATETIME
		DECLARE @user							NCHAR(20)
		DECLARE @primary_contact_id				NCHAR(10)
		DECLARE @new_activity_id				NCHAR(10)
		DECLARE @cst_create_activity_flag		NCHAR(1)
		DECLARE @cst_followup_time				INT
		DECLARE @cst_followup_time_type			NCHAR(2)
		DECLARE @cst_followup_action_code		NCHAR(10)
		DECLARE @appointment_date				DATETIME
		DECLARE @true_appointment_date			DATETIME
		DECLARE @appointment_date_string		CHAR(10)
		DECLARE @appointment_time				DATETIME
		DECLARE @cst_followup_date_in			DATETIME
		DECLARE @cst_followup_time_in			DATETIME
		DECLARE @difference_in_days				INT
		DECLARE @check_followup_flag			NCHAR(1)
		DECLARE @orig_primary_user				NCHAR(20)
		DECLARE @cst_activity_type_code			NCHAR(10)
		DECLARE @new_cst_activity_type_code		NCHAR(10)
		DECLARE @has_open_appointment			NCHAR(1)
		DECLARE @is_marketing_activity			NCHAR(1)
		DECLARE @do_not_call_flag				NCHAR(1)
		DECLARE @do_not_solicit_flag			NCHAR(1)
		DECLARE @followup_result_code			NCHAR(10)
		DECLARE @followup_completion_date		DATETIME
		DECLARE @followup_completion_time		DATETIME
		DECLARE @followup_completion_user_code	NCHAR(20)

		DECLARE @serverDateTime					DATETIME	-- Holds the full date and time when the trigger is called.
		DECLARE @serverDate						DATETIME	-- Holds the date when the trigger is called with 00:00:00 for the time.
		DECLARE @serverTime						DATETIME	-- Holds the time when the trigger is called with 1/1/1900 for the date.
		DECLARE @serverTimeZoneOffset			INT			-- Holds the Greenwich Offset for the server.
		DECLARE @centerTimeZoneOffset			INT			-- Holds the Greenwich Offset for the center associated with the activity.

		DECLARE @CenterTimeZoneCode				NCHAR(10)
		DECLARE @ConfirmationCallUTC			DATETIME
		DECLARE @EndOfCallingUTC				DATETIME

		SET @serverDateTime = GETDATE()
		SET @serverDate = DATEADD(DAY, DATEDIFF(DAY, 0, @serverDateTime), 0)
		SET @serverTime = DATEADD(MILLISECOND, DATEDIFF(MILLISECOND, @serverDate, @serverDateTime), '1/1/1900')
		SET	@serverTimeZoneOffset = (SELECT greenwich_offset FROM onca_time_zone WHERE time_zone_code = 'EST')

		EXEC psoEnsureUserExists 'TRIGGER', 'Trigger'

		DECLARE cursor_activity_data CURSOR FOR
			SELECT top 1 deleted.action_code, deleted.result_code, inserted.activity_id,
			inserted.action_code, inserted.result_code, inserted.cst_no_followup_flag,
			inserted.updated_by_user_code, inserted.due_date, inserted.start_time,
			inserted.created_by_user_code, inserted.cst_followup_date, inserted.cst_followup_time,
			inserted.cst_activity_type_code
			FROM inserted
			LEFT OUTER JOIN deleted on inserted.activity_id = deleted.activity_id

		OPEN cursor_activity_data

		FETCH NEXT FROM cursor_activity_data INTO @old_action_code, @old_result_code, @activity_id, @action_code,
				@result_code, @cst_no_followup_flag, @updated_by_user_code, @due_date, @start_time,
				@created_by_user_code, @cst_followup_date_in, @cst_followup_time_in, @new_cst_activity_type_code

		WHILE (  @@fetch_status = 0 )
		BEGIN
			SET @check_followup_flag = 'N';

			SET @followup_result_code			= NULL;
			SET @followup_completion_date		= NULL;
			SET @followup_completion_time		= NULL;
			SET @followup_completion_user_code	= NULL;

			SET @primary_contact_id		= (SELECT dbo.psoGetActivityPrimaryContact(@activity_id))
			SET @CenterTimeZoneCode		= (SELECT dbo.psoGetContactCenterTimeZone(@primary_contact_id))
			SET @CenterTimeZoneOffset	= (SELECT dbo.psoGetTimeZoneOffset(@CenterTimeZoneCode))

			INSERT INTO cstd_sql_job_log (name, message)
			VALUES ('Activity Trigger', 'Contact: ' + @primary_contact_id + ' Action: ' + @action_code)

			EXEC pso_DispositionActivities @activity_id, @action_code, @result_code, @primary_contact_id
			EXEC pso_CheckContactStatus    @activity_id, @action_code, @result_code, @primary_contact_id

			IF (@result_code = 'NOCALL')
			BEGIN
				EXEC psoProcessDoNotCallResult @primary_contact_id, @updated_by_user_code
			END
			ELSE IF (@result_code = 'PRANK')
			BEGIN
				EXEC psoProcessPrankResult @primary_contact_id, @updated_by_user_code
			END
			ELSE IF (@result_code = 'NOCONTACT')
			BEGIN
				EXEC psoProcessDoNotContactResult @primary_contact_id, @updated_by_user_code
			END
			ELSE IF (@result_code = 'NOTEXT')
			BEGIN
				EXEC psoProcessDoNotTextResult @primary_contact_id, @updated_by_user_code
			END

			IF (@action_code = 'CONFIRM' AND @result_code = 'DRCTCNFIRM' AND @old_result_code IS NULL)
			BEGIN
				SET @orig_primary_user = (SELECT dbo.psoGetActivityPrimaryUser(@activity_id))

				IF (@orig_primary_user <> @updated_by_user_code)
				BEGIN
					EXEC psoAssignActivityPrimaryUser @activity_id, @updated_by_user_code
				END
			END

			IF ISNULL(@action_code, ' ') <> ISNULL(@old_action_code, ' ')
				IF ISNULL(@result_code, ' ') <> ' '
					SET @check_followup_flag = 'Y'

			IF ISNULL(@result_code, ' ') <> ISNULL(@old_result_code, ' ')
				SET @check_followup_flag = 'Y'

			IF ISNULL(@cst_no_followup_flag, 'N') = 'Y'
				SET @check_followup_flag = 'N'

			IF @check_followup_flag = 'Y'
			BEGIN

				SELECT TOP 1
				@cst_create_activity_flag = cst_create_activity_flag,
				@cst_followup_time = cst_follow_up_time,
				@cst_followup_time_type = cst_followup_time_type,
				@cst_followup_action_code = cst_followup_action_code,
				@cst_activity_type_code = ISNULL(cst_activity_type_code, @new_cst_activity_type_code)
				FROM onca_action_result
				WHERE
				action_code = @action_code AND
				result_code = @result_code

				SET @has_open_appointment	= (SELECT dbo.psoContactHasOpenAppointment(@primary_contact_id))
				SET @is_marketing_activity	= (SELECT dbo.psoIsMarketingAction(@cst_followup_action_code))

				IF (@is_marketing_activity = 'Y' AND @has_open_appointment = 'Y')
				BEGIN
					GOTO next_record
				END

				IF ISNULL(@cst_create_activity_flag, 'N') = 'Y'
				BEGIN



					DECLARE @description			NCHAR(50)

					SET @description = (	SELECT TOP 1
											description
											FROM onca_action
											WHERE
											action_code = @cst_followup_action_code)

					SET @user = @updated_by_user_code

					IF ISNULL(@user, ' ') = ' '
						SET @user = @created_by_user_code

					IF @cst_followup_action_code = 'CONFIRM'
					BEGIN
						DECLARE @today				DATETIME
						DECLARE @tomorrow			DATETIME
						DECLARE @today_string		CHAR(10)
						DECLARE @tomorrow_string	CHAR(10)

						SET @today = @serverDate
						SET @today_string = CONVERT(CHAR(10), @today, 101)
						SET @tomorrow = DATEADD(dd, 1, @today)
						SET @tomorrow_string = CONVERT(char(10), @tomorrow, 101)

						--Get original appointment values
						EXEC psoGetContactAppointmentDateTime @primary_contact_id, @appointment_date OUTPUT, @appointment_time OUTPUT

						SET @true_appointment_date = dbo.CombineDates(@appointment_date, @appointment_time)

						-- Skip this record if the appointment has already occurred.
						-- Appointment scheduled time is less than the current time.
						IF (dbo.CompareDates(@appointment_date,
											 @appointment_time,
											 @centerTimeZoneOffset,
											 @serverDate,
											 @serverTime,
											 @serverTimeZoneOffset) >= 0)
						BEGIN
							GOTO next_record
						END

						IF(@result_code = 'CALLBACK')
						BEGIN
							SELECT TOP 1
							@due_date = cst_followup_date,
							@start_time = cst_followup_time
							FROM oncd_activity
							WHERE
							activity_id = @activity_id
						END
						ELSE IF @result_code IN ('BUSY','NOANSWER','VOICEMAIL','INDCONFIRM','NOCONFIRM','VMCONFIRM')
						BEGIN
							SET @start_time = (SELECT dbo.psoCalculateFollowUpTime(@cst_followup_time_type, @cst_followup_time, @serverDateTime))
							SET @due_date = CONVERT(CHAR(10), @serverDate, 101);

							IF dbo.CombineDates(@start_time, NULL) > dbo.CombineDates(@due_date, NULL)
							BEGIN
								SET @difference_in_days = DATEDIFF(dd, @due_date, @start_time)
								SET @due_date = DATEADD(dd, @difference_in_days, @due_date)
							END

							-- Do not create an additional Confirmation Call Activity if the Appointment would
							-- be prior to the created Confirmation Call.
							IF (dbo.CompareDates(@appointment_date,
												 @appointment_time,
												 @centerTimeZoneOffset,
												 @serverDate,
												 @start_time,
												 @serverTimeZoneOffset) >= 0)
							BEGIN
								GOTO next_record
							END
						END
						ELSE
						BEGIN

							SET @appointment_date_string = CONVERT(CHAR(10), @appointment_date, 101)
							--If appointment_date is today or tomorrow, set confirmation date to today and continue
							--without checking for next available confirmation date
							IF(@appointment_date_string = @tomorrow_string)
							BEGIN
								SET @due_date = CONVERT(CHAR(10), @today, 101)
							END
							ELSE IF (@appointment_date_string = @today_string)
							BEGIN
								-- Skip the creation of the confirmation activity if the appointment time
								-- has occurred.
								IF (dbo.CompareDates(@serverDate,
													 @appointment_time,
													 @centerTimeZoneOffset,
													 @serverDate,
													 @serverTime,
													 @serverTimeZoneOffset) >= 0)
								BEGIN
									GOTO next_record
								END
								ELSE
								BEGIN
									SET @due_date = CONVERT(CHAR(10), @today, 101)
								END
							END
							ELSE
							BEGIN
								--Decrement appointment date since confirm should happen at least 1
								--day prior to appointment
								SET @appointment_date = (SELECT dbo.psoGetConfirmDate(@appointment_date))
								SET @appointment_date_string = CONVERT(CHAR(10), @appointment_date, 101)

								IF (dbo.CompareDates(@appointment_date,
													 NULL,
													 @centerTimeZoneOffset,
													 @serverDate,
													 NULL,
													 @serverTimeZoneOffset) <= 0)
								BEGIN
									SET @due_date = @appointment_date
								END
								ELSE
								BEGIN
									GOTO next_record
								END
							END
							--Set start time to due date date time = 12:00:00
							SET @start_time = dbo.CombineDates(@due_date, NULL)

							-- Ensure that the Confirm Call is not scheduled prior to the current
							-- date.  If the time portion is not included, the date could be prior to
							-- the current date/time which will cause the call to go to the top of the
							-- dialing queue and cause a conflict because the Contact may still be on
							-- the original call.
							IF (dbo.CombineDates(@true_appointment_date, NULL) = dbo.CombineDates(@today, NULL) OR
								dbo.CombineDates(@true_appointment_date, NULL) = dbo.CombineDates(@tomorrow, NULL))
							BEGIN
								--SET @followup_completion_user_code = @created_by_user_code;
								SET @followup_completion_user_code = @updated_by_user_code;

								IF (@followup_completion_user_code = 'TRIGGER')
								BEGIN
									SET @followup_completion_user_code = (SELECT completed_by_user_code FROM oncd_activity WHERE activity_id = @activity_id)

									INSERT INTO cstd_sql_job_log (name, message)
									VALUES ('pso_GenerateFollowupActivity', 'Changing follow-up user from TRIGGER to ' + @followup_completion_user_code + ' on Activity: ' + @activity_id)
								END

								INSERT INTO cstd_sql_job_log (name, message)
								VALUES ('pso_GenerateFollowupActivity', '1 Follow up Completion User is ' + @followup_completion_user_code + ' on Activity: ' + @activity_id)

								IF (@followup_completion_user_code IN ('TM 801', 'TM 500', 'TM 600', 'TM9000') OR RTRIM(@followup_completion_user_code) LIKE 'TM8[0-9][0-9][0-9]')
								BEGIN
									SET @followup_completion_user_code = NULL
									SET @followup_result_code = NULL
									SET @followup_completion_date = NULL
									SET @followup_completion_time = NULL
								END
								ELSE
								BEGIN
									--EXEC psoAssignActivityPrimaryUser @activity_id, @followup_completion_user_code

									SET @followup_result_code = 'DRCTCNFIRM';
									SET @followup_completion_date = dbo.CombineDates(@serverDate, NULL);
									SET @followup_completion_time = dbo.CombineDates(NULL, @serverTime);
								END
							END

							-- If the appointment is scheduled for today, result the followup confirmation
							-- call to be a Direct Confirm by the current user.
							IF (dbo.CompareDates(@appointment_date,
												 NULL,
												 @centerTimeZoneOffset,
												 @serverDate,
												 NULL,
												 @ServerTimeZoneOffset) = 0)
							BEGIN
								SET @followup_completion_user_code = @updated_by_user_code;

								IF (@followup_completion_user_code = 'TRIGGER')
								BEGIN
									SET @followup_completion_user_code = (SELECT completed_by_user_code FROM oncd_activity WHERE activity_id = @activity_id)

									INSERT INTO cstd_sql_job_log (name, message)
									VALUES ('pso_GenerateFollowupActivity', 'Changing follow-up user from TRIGGER to ' + @followup_completion_user_code + ' on Activity: ' + @activity_id)
								END

								INSERT INTO cstd_sql_job_log (name, message)
								VALUES ('pso_GenerateFollowupActivity', '2 Follow up Completion User is ' + @followup_completion_user_code + ' on Activity: ' + @activity_id)

								IF (@followup_completion_user_code IN ('TM 801', 'TM 500', 'TM 600', 'TM9000') OR RTRIM(@followup_completion_user_code) LIKE 'TM8[0-9][0-9][0-9]')
								BEGIN
									SET @followup_completion_user_code = NULL
									SET @followup_result_code = NULL
									SET @followup_completion_date = NULL
									SET @followup_completion_time = NULL
								END
								ELSE
								BEGIN
									--EXEC psoAssignActivityPrimaryUser @activity_id, @followup_completion_user_code

									SET @followup_result_code = 'DRCTCNFIRM';
									SET @followup_completion_date = dbo.CombineDates(@serverDate, NULL);
									SET @followup_completion_time = dbo.CombineDates(NULL, @serverTime);
								END
							END
							ELSE
							BEGIN
								-- Determine if the Confirmation Call is scheduled to be after calling ends
								-- for that time zone.  All calling for the time zone ends at 9:00 PM.
								-- If the Confirmation Call would be scheduled after the calling ends, move the
								-- Confirmation Call to the next day at 12:00:00 AM
								SET @ConfirmationCallUTC = dbo.ConvertToUTC(dbo.CombineDates(@due_date, @start_time), 'EST')
								SET @EndOfCallingUTC	 = dbo.ConvertToUTC(dbo.CombineDates(@due_date, '9:00 PM'), @CenterTimeZoneCode)

								IF (@ConfirmationCallUTC > @EndOfCallingUTC)
								BEGIN
									SET @due_date = DATEADD(DAY, 1, @due_date)
									SET @start_time = '1/1/1900 00:00:00'
								END
							END
						END --if result = busy or cancel
					END --If (@result_code = 'CONFIRM')
					ELSE IF (@cst_followup_action_code = 'BROCHURE' OR @result_code = 'BROCHURE')
					BEGIN
						DECLARE @country_code NCHAR(20)
						DECLARE @days_to_add INT

						SET @country_code = (SELECT dbo.psoGetContactCountry(@primary_contact_id))

						IF ISNULL(@country_code, ' ') = ' '
							SET @country_code = 'US'

						IF @country_code = 'CA'
							SET @days_to_add = (	SELECT TOP 1
													setting_value
													FROM onca_setting
													WHERE
													setting_name = 'BROCHURE_ACTIVITY_DAYS_CANADA')
						ELSE
							SET @days_to_add = (	SELECT TOP 1
													setting_value
													FROM onca_setting
													WHERE
													setting_name = 'BROCHURE_ACTIVITY_DAYS_USA')

						SET @due_date = DATEADD(dd, @days_to_add, @serverDate)
						SET @start_time = (DATEPART(mm, @due_date) + DATEPART(dd, @due_date) + DATEPART(yy, @due_date))

					END --If brochure
					ELSE IF @cst_followup_action_code = 'CALLBACK'
					BEGIN
						SELECT TOP 1
						@due_date = cst_followup_date,
						@start_time = cst_followup_time
						FROM oncd_activity
						WHERE
						activity_id = @activity_id
					END -- If Callback
					--for appointment activities dispositioned as noshow
					ELSE IF (@cst_followup_action_code IN ('OUTCALL','BROCHCALL','CANCELCALL','NOSHOWCALL') AND
							 @action_code = 'APPOINT' AND
							 @result_code = 'NOSHOW')
					BEGIN
						IF (@cst_followup_action_code = 'NOSHOWCALL')
						BEGIN
							DECLARE @actCount INT
							SET @actCount = (	SELECT COUNT(*)
												FROM oncd_activity
												INNER JOIN oncd_activity_contact ON
													oncd_activity_contact.activity_id = oncd_activity.activity_id AND
													oncd_activity_contact.contact_id = @primary_contact_id
												WHERE
												action_code = 'APPOINT' AND
												result_code = 'NOSHOW')

							IF (ISNULL(@actCount, 0) > 4)
							BEGIN
								GOTO next_record
							END
						END

						SELECT @due_date = @serverDate
						SET @start_time = (SELECT dbo.psoCalculateFollowUpTime(@cst_followup_time_type, @cst_followup_time, @serverTime))

						-- Adjust the due date if the appointment is scheduled for the future.
						--IF (dbo.CompareDates(@start_time,
						--					 NULL,
						--					 @centerTimeZoneOffset,
						--					 @due_date,
						--					 NULL,
						--					 @ServerTimeZoneOffset) < 0)
						--BEGIN
						--	SET @difference_in_days = DATEDIFF(dd, @due_date, @start_time)
						--	SET @due_date = DATEADD(dd, @difference_in_days, @due_date)
						--END
						IF (@start_time >= '1/2/1900')
						BEGIN
							SET @difference_in_days = DATEDIFF(dd, '1/1/1900', @start_time)
							SET @due_date = DATEADD(dd, @difference_in_days, @due_date)
						END
					END

					ELSE IF @result_code IN ('BUSY','NOANSWER')
					BEGIN
						select @due_date = @serverDate
						SET @start_time = (SELECT dbo.psoCalculateFollowUpTime(@cst_followup_time_type, @cst_followup_time, @serverTime))

						--IF (dbo.CompareDates(@start_time,
						--					 NULL,
						--					 @centerTimeZoneOffset,
						--					 @due_date,
						--					 NULL,
						--					 @ServerTimeZoneOffset) < 0)
						--BEGIN
						--	SET @difference_in_days = DATEDIFF(dd, @due_date, @start_time)
						--	SET @due_date = DATEADD(dd, @difference_in_days, @due_date)
						--END

						IF (@start_time >= '1/2/1900')
						BEGIN
							SET @difference_in_days = DATEDIFF(dd, '1/1/1900', @start_time)
							SET @due_date = DATEADD(dd, @difference_in_days, @due_date)
						END
					END
					ELSE IF (@result_code = 'CALLBACK')
					BEGIN
						SET @due_date = @cst_followup_date_in
						SET @start_time = @cst_followup_time_in
					END
					ELSE
					BEGIN
						SET @due_date = (SELECT dbo.psoCalculateFollowUpTime(@cst_followup_time_type, @cst_followup_time, @serverDateTime))
					END

					IF (@cst_followup_action_code = 'SHNOBUYCAL')
					BEGIN
						IF (SELECT dbo.psoIsSurgeryConsultation(@primary_contact_id)) = 'Y'
						BEGIN
							GOTO next_record
						END
					END

					EXEC onc_create_primary_key 10, 'oncd_activity', 'activity_id', @new_activity_id OUTPUT, 'TRG'

					SET @do_not_call_flag = (SELECT dbo.psoIsDoNotCall(@primary_contact_id))
					SET @do_not_solicit_flag = (SELECT dbo.psoIsDoNotContact(@primary_contact_id))

					IF (@do_not_call_flag <> 'Y' AND @do_not_solicit_flag <> 'Y')
					BEGIN
						INSERT INTO oncd_activity(
							activity_id,
							due_date,
							start_time,
							action_code,
							description,
							creation_date,
							created_by_user_code,
							updated_date,
							updated_by_user_code,
							source_code,
							cst_override_time_zone,
							cst_activity_type_code,
							cst_promotion_code,
							cst_time_zone_code,
							result_code,
							completion_date,
							completion_time,
							completed_by_user_code)

						SELECT
							@new_activity_id,
							dbo.CombineDates(@due_date, null),
							dbo.CombineDates(null, @start_time),
							@cst_followup_action_code,
							@description,
							@serverDateTime,
							@user,
							@serverDateTime,
							@user,
							source_code,
							cst_override_time_zone,
							@cst_activity_type_code,
							cst_promotion_code,
							cst_time_zone_code,
							@followup_result_code,
							@followup_completion_date,
							@followup_completion_time,
							@followup_completion_user_code
							FROM oncd_activity
							WHERE activity_id = @activity_id

						EXEC psoCopyActivityContacts @activity_id, @new_activity_id, @user
						EXEC psoCopyActivityUsers @activity_id, @new_activity_id, @user
						EXEC psoCopyActivityCompanies @activity_id, @new_activity_id, @user

						IF (@cst_followup_action_code = 'CONFIRM' AND @followup_result_code = 'DRCTCNFIRM')
						BEGIN
							EXEC psoAssignActivityPrimaryUser @new_activity_id, @followup_completion_user_code
						END

					END
				END
			END

	next_record:

		EXEC dbo.pso_CheckSourceCode @activity_id

		EXEC psoRemoveDuplicateOpenActivities @primary_contact_id

		FETCH NEXT FROM cursor_activity_data INTO @old_action_code, @old_result_code, @activity_id, @action_code, @result_code, @cst_no_followup_flag, @updated_by_user_code, @due_date, @start_time, @created_by_user_code, @cst_followup_date_in, @cst_followup_time_in, @new_cst_activity_type_code
		END
		CLOSE cursor_activity_data
		DEALLOCATE cursor_activity_data
	END
END
GO
ALTER TABLE [dbo].[oncd_activity] ENABLE TRIGGER [pso_GenerateFollowupActivity]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================
-- Create date: 21 September 2011
-- Project #  : 8
-- Description:	Used for Noble Additions.
--				When an Activity is inserted and the following criteria are met
--				the oncd_activity.activity_id will be inserted into cstd_noble_contacts.
--				 1. Activity Action is a Noble Addition.
--						onca_action.cst_noble_addition = 'Y'
--				 2. Activity's Result is not set.
--						oncd_activity.result_code IS NULL
--				 3. Activity was not previously added to Noble Contacts List.
--						oncd_activity.activity_id not in cstd_noble_contacts.activity_id
--				 4. Activity is due on the current date.
--						oncd_activity.due_date = current date
--
-- Update date: 19 December 2011
-- Project #  : 65
-- Description: Changed the business logic to add brochure requests from Pagelinx (TM600)
--				immediately to the Noble Additions file.
-- ============================================================================
CREATE TRIGGER [dbo].[pso_NobleAdditions]
   ON [dbo].[oncd_activity]
   AFTER INSERT
AS
BEGIN
	-- The oncd_activity.activity_id for the inserted/updated activities.
	DECLARE @ActivityId NCHAR(10)

	-- Use a cursor so that everything processes if a transaction or batch insert/update is used.
	-- Process only the records fitting within the below business rules:
	--  1. Activity Action is a Noble Addition.
	--		onca_action.cst_noble_addition = 'Y'
	--  2. Activity's Result is not set.
	--		oncd_activity.result_code IS NULL
	--  3. Activity was not previously added to Noble Contacts List.
	--		oncd_activity.activity_id not in cstd_noble_contacts.activity_id
	--	4. Activity is due on the current date or created by TM 600 and is a Brochure Call.
	--		oncd_activity.due_date = current date
	DECLARE ActivityCursor CURSOR FOR
		SELECT inserted.activity_id
		FROM inserted
		INNER JOIN onca_action ON
			inserted.action_code = onca_action.action_code
		LEFT OUTER JOIN cstd_noble_contacts ON
			inserted.activity_id = cstd_noble_contacts.activity_id
		WHERE
		inserted.result_code IS NULL AND
		cstd_noble_contacts.activity_id IS NULL AND
		onca_action.cst_noble_addition = 'Y' AND
		(dbo.CombineDates(inserted.due_date, NULL) = dbo.CombineDates(GETDATE(), NULL) OR
		(inserted.created_by_user_code = 'TM 600' AND inserted.action_code = 'BROCHCALL'))

	OPEN ActivityCursor

	FETCH NEXT FROM ActivityCursor
	INTO @ActivityId

	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- Add the activity record to the Noble Contacts.
		-- Use the table defaults for following columns:
		--	1. status			-	'NEW'
		--  2. creation_date	-	GETDATE()
		INSERT INTO cstd_noble_contacts (activity_id)
			VALUES (@ActivityId)

		-- Verify the Source Code
		EXEC pso_CheckSourceCode @ActivityId

		FETCH NEXT FROM ActivityCursor
		INTO @ActivityId
	END
	CLOSE ActivityCursor
	DEALLOCATE ActivityCursor

END
GO
ALTER TABLE [dbo].[oncd_activity] ENABLE TRIGGER [pso_NobleAdditions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================
-- Create date: 21 September 2011
-- Project #  : 8
-- Description:	Used for Noble Exclusions.
--				When an Activity is inserted or updated and the following
--				criteria are met the oncd_activity.activity_id will be inserted
--				into cstd_noble_exclusion:
--				 1. Activity Action is a Noble Exclusion.
--						onca_action.cst_noble_exclusion = 'Y'
--				 2. Activity's Result is set.
--						oncd_activity.result_code IS NOT NULL
--				 3. Activity was not previously added to Noble Exclusion List.
--						oncd_activity.activity_id not in cstd_noble_exclusion.activity_id
--				 4. Activity is due on the current date.
--						oncd_activity.due_date = current date
-- Update date: 12 October 2011
-- Project #  : 43
-- Description: Ingore the Activity's due date.
-- ============================================================================
CREATE TRIGGER [dbo].[pso_NobleExclusions]
   ON [dbo].[oncd_activity]
   AFTER INSERT,UPDATE
AS
BEGIN
	-- The oncd_activity.activity_id for the inserted/updated activities.
	DECLARE @ActivityId NCHAR(10)

	-- Use a cursor so that everything processes if a transaction or batch insert/update is used.
	-- Process only the records fitting within the below business rules:
	--	1. Activity Action is a Noble Exclusion.
	--		onca_action.cst_noble_exclusion = 'Y'
	--	2. Activity's Result is set.
	--		oncd_activity.result_code IS NOT NULL
	--	3. Activity was not previously added to Noble Exclusion List.
	--		oncd_activity.activity_id not in cstd_noble_exclusion.activity_id
	DECLARE ActivityCursor CURSOR FOR
		SELECT inserted.activity_id
		FROM inserted
		INNER JOIN onca_action ON
			inserted.action_code = onca_action.action_code
		LEFT OUTER JOIN cstd_noble_exclusion ON
			inserted.activity_id = cstd_noble_exclusion.activity_id
		WHERE
		inserted.result_code IS NOT NULL AND
		cstd_noble_exclusion.noble_exclusion_id IS NULL AND
		onca_action.cst_noble_exclusion = 'Y'

	OPEN ActivityCursor

	FETCH NEXT FROM ActivityCursor
	INTO @ActivityId

	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- Add the activity record to the Noble Exclusions.
		-- Use the table defaults for following columns:
		--	1. noble_exclusion_id -	IDENTITY
		--  2. exclusion_date     -	GETDATE()
		--  3. output_flag        - 'N'
		INSERT INTO cstd_noble_exclusion (activity_id)
			VALUES(@ActivityId)

		FETCH NEXT FROM ActivityCursor
		INTO @ActivityId
	END
	CLOSE ActivityCursor
	DEALLOCATE ActivityCursor

END
GO
ALTER TABLE [dbo].[oncd_activity] ENABLE TRIGGER [pso_NobleExclusions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[pso_oncd_activity_remove_unicode_insert]
   ON  [dbo].[oncd_activity]
   INSTEAD OF INSERT
AS
BEGIN

INSERT INTO [dbo].[oncd_activity]
           ([activity_id]
           ,[recur_id]
           ,[opportunity_id]
           ,[incident_id]
           ,[due_date]
           ,[start_time]
           ,[duration]
           ,[action_code]
           ,[description]
           ,[creation_date]
           ,[created_by_user_code]
           ,[completion_date]
           ,[completion_time]
           ,[completed_by_user_code]
           ,[updated_date]
           ,[updated_by_user_code]
           ,[result_code]
           ,[batch_status_code]
           ,[batch_result_code]
           ,[batch_address_type_code]
           ,[priority]
           ,[project_code]
           ,[notify_when_completed]
           ,[campaign_code]
           ,[source_code]
           ,[confirmed_time]
           ,[confirmed_time_from]
           ,[confirmed_time_to]
           ,[document_id]
           ,[milestone_activity_id]
           ,[cst_override_time_zone]
           ,[cst_lock_date]
           ,[cst_lock_by_user_code]
           ,[cst_activity_type_code]
           ,[cst_promotion_code]
           ,[cst_no_followup_flag]
           ,[cst_followup_time]
           ,[cst_followup_date]
           ,[cst_time_zone_code]
           ,[project_id]
           ,[cst_utc_start_date]
           ,[cst_brochure_download])
     SELECT
           inserted.activity_id
           ,inserted.recur_id
           ,inserted.opportunity_id
           ,inserted.incident_id
           ,inserted.due_date
           ,inserted.start_time
           ,inserted.duration
           ,inserted.action_code
           ,dbo.RemoveUnicode(inserted.description)
           ,inserted.creation_date
           ,inserted.created_by_user_code
           ,inserted.completion_date
           ,inserted.completion_time
           ,inserted.completed_by_user_code
           ,inserted.updated_date
           ,inserted.updated_by_user_code
           ,inserted.result_code
           ,inserted.batch_status_code
           ,inserted.batch_result_code
           ,inserted.batch_address_type_code
           ,dbo.RemoveUnicode(inserted.priority)
           ,inserted.project_code
           ,dbo.RemoveUnicode(inserted.notify_when_completed)
           ,inserted.campaign_code
           ,inserted.source_code
           ,dbo.RemoveUnicode(inserted.confirmed_time)
           ,inserted.confirmed_time_from
           ,inserted.confirmed_time_to
           ,inserted.document_id
           ,inserted.milestone_activity_id
           ,dbo.RemoveUnicode(inserted.cst_override_time_zone)
           ,inserted.cst_lock_date
           ,inserted.cst_lock_by_user_code
           ,inserted.cst_activity_type_code
           ,inserted.cst_promotion_code
           ,dbo.RemoveUnicode(inserted.cst_no_followup_flag)
           ,inserted.cst_followup_time
           ,inserted.cst_followup_date
           ,dbo.RemoveUnicode(inserted.cst_time_zone_code)
           ,inserted.project_id
           ,inserted.cst_utc_start_date
           ,dbo.RemoveUnicode(inserted.cst_brochure_download)
	FROM inserted


END
GO
ALTER TABLE [dbo].[oncd_activity] DISABLE TRIGGER [pso_oncd_activity_remove_unicode_insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 24 September 2012
-- Description:	Removes Unicode
-- =============================================
CREATE TRIGGER [dbo].[pso_oncd_activity_remove_unicode_UPDATE]
   ON  [dbo].[oncd_activity]
   INSTEAD OF UPDATE
AS
BEGIN

UPDATE [dbo].[oncd_activity]
   SET [activity_id] = inserted.activity_id
      ,[recur_id] = inserted.recur_id
      ,[opportunity_id] = inserted.opportunity_id
      ,[incident_id] = inserted.incident_id
      ,[due_date] = inserted.due_date
      ,[start_time] = inserted.start_time
      ,[duration] = inserted.duration
      ,[action_code] = inserted.action_code
      ,[description] = dbo.RemoveUnicode(inserted.description)
      ,[creation_date] = inserted.creation_date
      ,[created_by_user_code] = inserted.created_by_user_code
      ,[completion_date] = inserted.completion_date
      ,[completion_time] = inserted.completion_time
      ,[completed_by_user_code] = inserted.completed_by_user_code
      ,[updated_date] = inserted.updated_date
      ,[updated_by_user_code] = inserted.updated_by_user_code
      ,[result_code] = inserted.result_code
      ,[batch_status_code] = inserted.batch_status_code
      ,[batch_result_code] = inserted.batch_result_code
      ,[batch_address_type_code] = inserted.batch_address_type_code
      ,[priority] = dbo.RemoveUnicode(inserted.priority)
      ,[project_code] = inserted.project_code
      ,[notify_when_completed] = dbo.RemoveUnicode(inserted.notify_when_completed)
      ,[campaign_code] = inserted.campaign_code
      ,[source_code] = inserted.source_code
      ,[confirmed_time] = dbo.RemoveUnicode(inserted.confirmed_time)
      ,[confirmed_time_from] = inserted.confirmed_time_from
      ,[confirmed_time_to] = inserted.confirmed_time_to
      ,[document_id] = inserted.document_id
      ,[milestone_activity_id] = inserted.milestone_activity_id
      ,[cst_override_time_zone] = dbo.RemoveUnicode(inserted.cst_override_time_zone)
      ,[cst_lock_date] = inserted.cst_lock_date
      ,[cst_lock_by_user_code] = inserted.cst_lock_by_user_code
      ,[cst_activity_type_code] = inserted.cst_activity_type_code
      ,[cst_promotion_code] = inserted.cst_promotion_code
      ,[cst_no_followup_flag] = dbo.RemoveUnicode(inserted.cst_no_followup_flag)
      ,[cst_followup_time] = inserted.cst_followup_time
      ,[cst_followup_date] = inserted.cst_followup_date
      ,[cst_time_zone_code] = dbo.RemoveUnicode(inserted.cst_time_zone_code)
      ,[project_id] = inserted.project_id
      ,[cst_utc_start_date] = inserted.cst_utc_start_date
      ,[cst_brochure_download] = dbo.RemoveUnicode(inserted.cst_brochure_download)
FROM inserted
WHERE inserted.activity_id = oncd_activity.activity_id

END
GO
ALTER TABLE [dbo].[oncd_activity] DISABLE TRIGGER [pso_oncd_activity_remove_unicode_UPDATE]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================
-- Create date: 25 August 2011
-- Description:	Calculates and sets oncd_activity.cst_utc_start_date.
-- ==================================================================
CREATE TRIGGER [dbo].[pso_SetUTCStartDate]
   ON  [dbo].[oncd_activity]
   AFTER INSERT,UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ActivityId		NCHAR(10)
	DECLARE @DueDate		DATETIME
	DECLARE @StartTime		DATETIME
	DECLARE @TimeZoneCode	NCHAR(10)
	DECLARE @UTCStartDate	DATETIME
	DECLARE @CalcStartDate	DATETIME

    DECLARE ActivityUTCCursor CURSOR FOR
		SELECT
			i.activity_id,
			i.due_date,
			i.start_time,
			i.cst_time_zone_code,
			i.cst_utc_start_date
		FROM Inserted i
		LEFT OUTER JOIN deleted d ON d.activity_id = i.activity_id
		WHERE
		--action_code = 'APPOINT' AND
		i.result_code IS NULL AND (
			((i.due_date IS NOT NULL AND d.due_date IS NULL) OR i.due_date <> d.due_date) OR
			((i.start_time IS NOT NULL AND d.start_time IS NULL) OR i.start_time <> d.start_time) OR
			((i.cst_time_zone_code IS NOT NULL AND d.cst_time_zone_code IS NULL) OR i.cst_time_zone_code <> d.cst_time_zone_code)
		)

	OPEN ActivityUTCCursor

	FETCH NEXT FROM ActivityUTCCursor
		INTO @ActivityId, @DueDate, @StartTime, @TimeZoneCode, @UTCStartDate

	WHILE (@@fetch_status = 0)
	BEGIN
		IF @TimeZoneCode IS NULL
			SET @TimeZoneCode = 'EST'

		SET @CalcStartDate = dbo.ConvertToUTC(dbo.CombineDates(@DueDate, @StartTime), @TimeZoneCode)

		IF (@CalcStartDate <> @UTCStartDate OR
			@UTCStartDate IS NULL)
		BEGIN
			UPDATE oncd_activity
			SET cst_utc_start_date = @CalcStartDate,
				cst_time_zone_code = @TimeZoneCode
			WHERE activity_id = @ActivityId
		END

		FETCH NEXT FROM ActivityUTCCursor
			INTO @ActivityId, @DueDate, @StartTime, @TimeZoneCode, @UTCStartDate
	END
	CLOSE ActivityUTCCursor
	DEALLOCATE ActivityUTCCursor

END
GO
ALTER TABLE [dbo].[oncd_activity] ENABLE TRIGGER [pso_SetUTCStartDate]
GO
