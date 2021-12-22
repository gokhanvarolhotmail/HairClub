/***********************************************************************
PROCEDURE:				mtnCheckOutVirtualCenterShowNoSaleConsults
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		4/29/2020
DESCRIPTION:			Used to update the Check-Out time for Show No Sale
						Consultations associated with Virtual Centers
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC mtnCheckOutVirtualCenterShowNoSaleConsults
***********************************************************************/
CREATE PROCEDURE mtnCheckOutVirtualCenterShowNoSaleConsults
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @CurrentDate DATETIME
,		@TargetDate DATETIME
,		@User NVARCHAR(25)


SET @CurrentDate = CAST(GETDATE() AS DATE)
SET @TargetDate = DATEADD(DAY, -7, @CurrentDate)
SET @User = 'VirtualCheckout'


/********************************** Check-Out Show No Sale Consultations for the Last 7 Days *************************************/
UPDATE	a
SET		a.CheckoutTime = DATEADD(MINUTE, a.AppointmentDurationCalc, a.CheckinTime)
,		a.LastUpdate = GETUTCDATE()
,		a.LastUpdateUser = @User
FROM	datAppointment a
		INNER JOIN cfgCenter ctr
			ON ctr.CenterID = a.CenterID
		INNER JOIN datClient clt
			ON clt.ClientGUID = a.ClientGUID
		INNER JOIN datClientMembership cm
			ON cm.ClientMembershipGUID = a.ClientMembershipGUID
		INNER JOIN cfgMembership m
			ON m.MembershipID = cm.MembershipID
		INNER JOIN lkpAppointmentType lat
			ON lat.AppointmentTypeID = a.AppointmentTypeID
WHERE	ctr.CenterNumber IN ( 901, 902, 903, 904 ) -- Virtual Center
		AND a.AppointmentDate >= @TargetDate AND a.AppointmentDate < @CurrentDate -- Last 7 Days
		AND lat.AppointmentTypeDescriptionShort IN ( 'SlsCon', 'TrichoView' ) -- Sales Consultation, TrichoView Appointment
		AND a.CheckedInFlag = 1 -- Checked In
		AND a.CheckoutTime IS NULL -- Not Checked Out
		AND m.MembershipDescriptionShort IN ( 'SHOWNOSALE', 'SNSSURGOFF' ) -- Client Is In A Show No Sale Membership
		AND ISNULL(a.IsDeletedFlag, 0) = 0 -- Appointment Is Not Deleted

END
