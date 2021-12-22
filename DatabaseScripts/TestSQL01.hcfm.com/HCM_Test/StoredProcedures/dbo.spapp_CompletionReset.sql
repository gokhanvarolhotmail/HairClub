/* CreateDate: 09/04/2007 09:40:45.527 , ModifyDate: 06/04/2014 14:17:31.073 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spapp_CompletionReset
DESTINATION SERVER:		SQL03
DESTINATION DATABASE:	HCM
RELATED APPLICATION:	TRE
AUTHOR:					Howard Abelow
IMPLEMENTOR:			Howard Abelow
DATE IMPLEMENTED:		08/23/2007
------------------------------------------------------------------------
NOTES:

03/15/2013 - KM - Added delete of SQL01 Appointments.
02/12/2014 - DL - Added code to prevent a SHOWSALE from being reset.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spapp_CompletionReset  'QKDL9NBITX', '4GONDQMITX'
***********************************************************************/
CREATE PROCEDURE [dbo].[spapp_CompletionReset]
(
	@activity_id varchar(10),
    @contact_id varchar(10)
)
AS
BEGIN TRANSACTION
SET XACT_ABORT ON


DECLARE @errorstr VARCHAR(MAX)
DECLARE @errorsvr INT = 11
DECLARE @errorstate INT = 1
DECLARE @ResultCode VARCHAR(50)


SET @ResultCode = (SELECT LTRIM(RTRIM(oa.result_code)) FROM oncd_activity oa WHERE oa.activity_id = @activity_id)


IF @ResultCode = 'SHOWSALE'
   BEGIN
         SET @errorstr = 'You cannot reset an activity completed as a SHOWSALE!'
         RAISERROR(@errorstr,@errorsvr,@errorstate);
         RETURN
   END


-- Reset Activity
UPDATE  [HCM].[dbo].[oncd_activity]
SET     [completion_date] = NULL
,       [completed_by_user_code] = NULL
,       [result_code] = NULL
WHERE   [activity_id] = @activity_id
        AND result_code NOT IN ( 'CANCEL', 'RESCHEDULE' )


-- Delete Completion
DELETE  FROM [HCM].[dbo].[cstd_contact_completion]
WHERE   [activity_id] = @activity_id

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


-- Delete Demographics
DELETE  FROM [HCM].[dbo].[cstd_activity_demographic]
WHERE   [activity_id] = @activity_id

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


-- Update complete sale column in contact
UPDATE  [HCM].[dbo].[oncd_contact]
SET     [cst_complete_sale] = NULL
WHERE   [contact_id] = @contact_id

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


--
-- Delete related appointments created with the Activity being reset
--
UPDATE  SO
SET     so.appointmentguid = NULL
FROM    [sql01].Hairclubcms.dbo.datSalesOrder so
        INNER JOIN [sql01].Hairclubcms.dbo.datAppointment a
            ON so.appointmentguid = a.appointmentguid
WHERE   a.[OnContactActivityID] = @activity_id

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


DELETE  ad
FROM    [sql01].Hairclubcms.dbo.datAppointmentDetail ad
        INNER JOIN [sql01].Hairclubcms.dbo.datAppointment a
            ON a.AppointmentGuid = ad.AppointmentGuid
WHERE   a.[OnContactActivityID] = @activity_id

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


DELETE  ae
FROM    [sql01].Hairclubcms.dbo.datAppointmentEmployee ae
        INNER JOIN [sql01].Hairclubcms.dbo.datAppointment a
            ON a.AppointmentGuid = ae.AppointmentGuid
WHERE   a.[OnContactActivityID] = @activity_id

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


DELETE  ap
FROM    [sql01].Hairclubcms.dbo.datAppointmentPhoto ap
        INNER JOIN [sql01].Hairclubcms.dbo.datAppointment a
            ON a.AppointmentGuid = ap.AppointmentGuid
WHERE   a.[OnContactActivityID] = @activity_id

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


DELETE  a
FROM    [sql01].Hairclubcms.dbo.datAppointment a
WHERE   a.[OnContactActivityID] = @activity_id

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


SET XACT_ABORT OFF
COMMIT TRANSACTION
GO
