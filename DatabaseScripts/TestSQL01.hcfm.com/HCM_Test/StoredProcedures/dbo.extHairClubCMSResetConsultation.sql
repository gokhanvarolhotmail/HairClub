/* CreateDate: 06/16/2014 15:25:13.460 , ModifyDate: 07/25/2014 11:31:11.733 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSResetConsultation
DESTINATION SERVER:		SQL03
DESTINATION DATABASE:	HCM
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		06/05/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHairClubCMSResetConsultation '5H6EOJBITX','GA5OW99ITX'
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSResetConsultation]
(
	@ContactID VARCHAR(10),
	@ActivityID VARCHAR(10)
)
AS
SET XACT_ABORT ON
BEGIN TRANSACTION


DECLARE @ResultCode VARCHAR(50)
DECLARE @errorstr VARCHAR(MAX)
DECLARE @errorsvr INT = 11
DECLARE @errorstate INT = 1


SET @ResultCode = (SELECT LTRIM(RTRIM(oa.result_code)) FROM oncd_activity oa WHERE oa.activity_id = @ActivityID)


IF @ResultCode = 'SHOWSALE'
   BEGIN
         SET @errorstr = 'You cannot reset an activity completed as a SHOWSALE!'
         RAISERROR(@errorstr, @errorsvr, @errorstate);
         RETURN
   END


-- Reset Activity
UPDATE  oncd_activity
SET     completion_date = NULL
,       completed_by_user_code = NULL
,       result_code = NULL
WHERE   activity_id = @ActivityID
        AND result_code NOT IN ( 'CANCEL', 'RESCHEDULE' )

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


-- Delete Completion
DELETE  FROM cstd_contact_completion
WHERE   activity_id = @ActivityID

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


-- Delete Demographics
DELETE  FROM cstd_activity_demographic
WHERE   activity_id = @ActivityID

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


-- Update complete sale column in contact
UPDATE  oncd_contact
SET     cst_complete_sale = NULL
WHERE   contact_id = @ContactID

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


--
-- Delete related appointments created with the Activity being reset
--
UPDATE  so
SET     so.appointmentguid = NULL
FROM    SQL01.HairClubCMS.dbo.datSalesOrder so
        INNER JOIN SQL01.HairClubCMS.dbo.datAppointment a
            ON so.appointmentguid = a.appointmentguid
WHERE   a.OnContactActivityID = @ActivityID

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


DELETE  ad
FROM    SQL01.HairClubCMS.dbo.datAppointmentDetail ad
        INNER JOIN SQL01.HairClubCMS.dbo.datAppointment a
            ON a.AppointmentGuid = ad.AppointmentGuid
WHERE   a.OnContactActivityID = @ActivityID

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


DELETE  ae
FROM    SQL01.HairClubCMS.dbo.datAppointmentEmployee ae
        INNER JOIN SQL01.HairClubCMS.dbo.datAppointment a
            ON a.AppointmentGuid = ae.AppointmentGuid
WHERE   a.OnContactActivityID = @ActivityID

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


DELETE  ap
FROM    SQL01.HairClubCMS.dbo.datAppointmentPhoto ap
        INNER JOIN SQL01.HairClubCMS.dbo.datAppointment a
            ON a.AppointmentGuid = ap.AppointmentGuid
WHERE   a.OnContactActivityID = @ActivityID

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


DELETE  a
FROM    SQL01.HairClubCMS.dbo.datAppointment a
WHERE   a.OnContactActivityID = @ActivityID

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END


COMMIT TRANSACTION
GO
