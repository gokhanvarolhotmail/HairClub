/* CreateDate: 07/28/2016 16:20:08.163 , ModifyDate: 11/13/2018 10:35:24.677 */
GO
/*
==============================================================================
PROCEDURE:                  mtnSetAppointmentPriorityColor

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		Tablet App

AUTHOR:                     Paul Madary

IMPLEMENTOR:                Paul Madary

DATE IMPLEMENTED:           02/27/2012

LAST REVISION DATE:			07/13/2016

==============================================================================
DESCRIPTION:    Sets the Priority Status Color on Appointments to High when the client is still within 90 days of their initial appointment.

==============================================================================
NOTES:
            * 07/14/2016 PRM - Created Stored Proc
			* 11/13/2018 MVT - Updated to use UTC date for Last Update (TFS #11593)

==============================================================================
SAMPLE EXECUTION:
EXEC [mtnSetAppointmentPriorityColor]
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnSetAppointmentPriorityColor]
AS
BEGIN

DECLARE @AppointmentPriorityColorID_High int = 1
DECLARE @CurrentDate date = CAST(GETDATE() AS DATE)

UPDATE datAppointment
SET AppointmentPriorityColorID = @AppointmentPriorityColorID_High,
	LastUpdateUser = 'High Priority For 90 Days',
	LastUpdate = GETUTCDATE()
--SELECT c.ClientFullNameCalc, a.StartDateTimeCalc, cma.AccumDate, a.*
FROM datAppointment a
	INNER JOIN datClient c ON a.ClientGUID = c.ClientGUID
	INNER JOIN datClientMembership cm ON a.ClientMembershipGUID = cm.ClientMembershipGUID
	INNER JOIN datClientMembershipAccum cma ON cm.ClientMembershipGUID = cma.ClientMembershipGUID
	INNER JOIN cfgAccumulator acc ON cma.AccumulatorID = acc.AccumulatorID
	INNER JOIN cfgMembership m On cm.MembershipID = m.MembershipID
	INNER JOIN lkpBusinessSegment bs ON m.BusinessSegmentID = bs.BusinessSegmentID
	INNER JOIN lkpRevenueGroup rg ON m.RevenueGroupID = rg.RevenueGroupID
WHERE a.IsDeletedFlag = 0 AND a.CheckinTime IS NULL
	AND a.AppointmentDate BETWEEN @CurrentDate AND DATEADD (day, 7, @CurrentDate) --only update appointments coming up in case something changes between now and then
	AND (a.AppointmentPriorityColorID <> @AppointmentPriorityColorID_High OR a.AppointmentPriorityColorID IS NULL)
	AND bs.BusinessSegmentDescriptionShort = 'BIO' AND rg.RevenueGroupDescriptionShort = 'NB'
	AND acc.AccumulatorDescriptionShort = 'InitApp'
	AND (cma.AccumDate IS NULL OR cma.AccumDate > DATEADD (day, -90, a.AppointmentDate))

END
GO
