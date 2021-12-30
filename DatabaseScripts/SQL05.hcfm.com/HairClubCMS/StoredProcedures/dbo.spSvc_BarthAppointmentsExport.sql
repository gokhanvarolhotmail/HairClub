/* CreateDate: 04/06/2015 08:44:14.283 , ModifyDate: 02/16/2021 09:24:23.887 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthAppointmentsExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthAppointmentsExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthAppointmentsExport]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get Appointment Data *************************************/
-- Appointments
SELECT  CC.CenterID AS 'CenterSSID'
,		CC.CenterDescriptionFullCalc AS 'CenterDescription'
,		DA.AppointmentGUID AS 'AppointmentSSID'
,		DA.AppointmentID_Temp AS 'CMSAppointmentID'
,		CLT.ClientIdentifier
,		CLT.ClientNumber_Temp AS 'CMSClientIdentifier'
,		REPLACE(CLT.FirstName, ',', '') AS 'FirstName'
,		REPLACE(CLT.LastName, ',', '') AS 'LastName'
,		CM.MembershipDescription AS 'Membership'
,		DA.AppointmentDate
,		DA.StartTime AS 'AppointmentTime'
,		DA.CheckinTime
,		DA.CheckoutTime
,		ISNULL(LAT.AppointmentTypeDescription, '') AS 'AppointmentType'
,		CSC.SalesCodeID
,		CSC.SalesCodeDescriptionShort AS 'SalesCode'
,		DAD.AppointmentDetailDuration AS 'Duration'
,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DNC.NotesClient, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'Notes'
,		CASE WHEN DNC.NotesClientDate IS NULL THEN '' ELSE CONVERT(VARCHAR(11), DNC.NotesClientDate, 101) END AS 'NoteDate'
,		DE.EmployeeGUID AS 'EmployeeSSID'
,		DE.EmployeeInitials AS 'StylistInitials'
,		REPLACE(DE.EmployeeFullNameCalc, ',', '') AS 'StylistName'
,		DA.CreateDate
,		DA.IsDeletedFlag
,		ISNULL(DA.SalesforceContactID, '') AS 'SFDC_LeadID'
,		ISNULL(DA.SalesforceTaskID, '') AS 'SFDC_TaskID'
,		DA.LastUpdateUser
FROM    datAppointment DA
		INNER JOIN cfgCenter CC
			ON CC.CenterID = DA.CenterID
		INNER JOIN lkpRegion LR
			ON LR.RegionID = CC.RegionID
        INNER JOIN datAppointmentDetail DAD
            ON DAD.AppointmentGUID = DA.AppointmentGUID
		INNER JOIN cfgSalesCode CSC
			ON CSC.SalesCodeID = DAD.SalesCodeID
		LEFT OUTER JOIN datClient CLT
			ON CLT.ClientGUID = DA.ClientGUID
		LEFT OUTER JOIN datClientMembership DCM
			ON DCM.ClientMembershipGUID = DA.ClientMembershipGUID
		LEFT OUTER JOIN cfgMembership CM
			ON CM.MembershipID = DCM.MembershipID
		LEFT OUTER JOIN datAppointmentEmployee DAE
			ON DAE.AppointmentGUID = DA.AppointmentGUID
		LEFT OUTER JOIN datEmployee DE
			ON DE.EmployeeGUID = DAE.EmployeeGUID
		LEFT OUTER JOIN datNotesClient DNC
			ON DNC.AppointmentGUID = DA.AppointmentGUID
		LEFT OUTER JOIN lkpAppointmentType LAT
			ON LAT.AppointmentTypeID = DA.AppointmentTypeID
WHERE	CC.CenterID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )
		AND CC.IsActiveFlag = 1
		AND DA.AppointmentDate >= '1/1/2020'--DATEADD(DAY, -21, GETDATE())

END
GO
