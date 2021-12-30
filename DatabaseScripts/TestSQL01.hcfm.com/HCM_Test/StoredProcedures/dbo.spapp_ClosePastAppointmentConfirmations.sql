/* CreateDate: 09/28/2007 14:55:01.703 , ModifyDate: 05/01/2010 14:48:11.047 */
GO
-- =============================================
-- Author:			Oncontact PSO Fred Remers
-- Create date: 	9/20/07
-- Description:		Close confirm activities with EXPIRED
--					for records where appointment date has passed
--					and open confirms exist
-- Update date:		10/31/2007 (Russ Kahler)
--					Modified logic to determine records to expire.
--					12/14/2007 (Matt Wegner)
--					Added UPDLOCK to select to prevent deadlocking
-- =============================================
CREATE PROCEDURE [dbo].[spapp_ClosePastAppointmentConfirmations]
AS
    UPDATE  oncd_activity
    set     result_code = 'EXPIRED',
            completion_date = dbo.CombineDates(getdate(), null),
            completion_time = dbo.CombineDates(null, getdate()),
            completed_by_user_code = 'ADMINISTRATOR'
    where   action_code = 'CONFIRM'
            and ( result_code is null
                  or result_code = ''
                )
            and not ( exists ( select   *
                               from     oncd_activity_contact ac1 WITH ( UPDLOCK, HOLDLOCK )
                                        inner join oncd_activity_contact ac2 on ac1.contact_id = ac2.contact_id
                                        inner join oncd_activity act2 on act2.activity_id = ac2.activity_id
                               where    ac1.activity_id = oncd_activity.activity_id
                                        and act2.action_code = 'APPOINT'
                                        and ( act2.result_code IS null
                                              or act2.result_code = ''
                                            )
                                        and dbo.CombineDates(act2.due_date,
                                                             act2.start_time) >= isnull([dbo].[TimeForContact](getdate(), -5, isnull(act2.cst_time_zone_code, 'EST')), getdate()) ) )
GO
