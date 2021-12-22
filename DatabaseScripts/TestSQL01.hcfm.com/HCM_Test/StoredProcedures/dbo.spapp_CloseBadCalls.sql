/* CreateDate: 02/11/2009 14:55:58.170 , ModifyDate: 05/01/2010 14:48:11.077 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Oncontact PSO Fred Remers
-- Create date: 	9/11/09
-- Description:		Cancel bad calls.
-- =============================================
CREATE PROCEDURE [dbo].[spapp_CloseBadCalls]
AS
    UPDATE  oncd_activity
    set     result_code = 'CANCEL',
            completion_date = dbo.CombineDates(getdate(), null),
            completion_time = dbo.CombineDates(null, getdate()),
            completed_by_user_code = 'ADMINISTRATOR'
    --select count(*) from oncd_activity
    where   (action_code <> 'CONFIRM' and action_code <> 'APPOINT')
            and ( result_code is null or result_code = '')
            and exists ( select   *
                               from     oncd_activity_contact ac1 WITH ( UPDLOCK, HOLDLOCK )
                                        inner join oncd_activity_contact ac2 on ac1.contact_id = ac2.contact_id
                                        inner join oncd_activity act2 on act2.activity_id = ac2.activity_id
                               where    ac1.activity_id = oncd_activity.activity_id
                                        and act2.action_code = 'APPOINT'
                                        and ( act2.result_code IS null or act2.result_code = '')
                                        and dbo.combinedates(act2.due_Date,null) >= dbo.combinedates(getdate(), null)

                                        and dbo.CombineDates(act2.due_date, act2.start_time) >= isnull([dbo].[TimeForContact](getdate(), -5, isnull(act2.cst_time_zone_code, 'EST')), getdate()) )


--update  oncd_activity
--set     result_code = 'CANCEL',
--        completion_date = dbo.combinedates(getdate(), null),
--        completion_time = dbo.combinedates(null, getdate())
----select * from
--from    oncd_activity,
--        oncd_Activity act2
--        inner join oncd_activity_contact ac2 on act2.activity_id = ac2.activity_id
--        inner join oncd_activity_contact ac1 on ac2.contact_id = ac1.contact_Id
--WHERE   act2.action_code = 'APPOINT'
--        and ( act2.result_Code = ''
--              or act2.result_code is null
--            )
--        and act2.due_Date >= dbo.combinedates(getdate(), null)
--        and ac1.activity_Id = oncd_activity.activity_id
--        and not ( oncd_activity.action_code in ( 'CONFIRM', 'APPOINT' ) )
--        and ( oncd_activity.result_code = ''
--              or oncd_activity.result_code is null
--            )
GO
