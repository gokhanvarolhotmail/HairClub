/* CreateDate: 05/14/2012 17:41:17.427 , ModifyDate: 02/04/2021 08:30:09.040 */
GO
/*
==============================================================================
PROCEDURE:                  mtnNightlyMaintenance

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Mike Tovbin

IMPLEMENTOR:                Mike Tovbin

DATE IMPLEMENTED:           02/27/2012

LAST REVISION DATE:			09/19/2019

==============================================================================
DESCRIPTION:    A daily maintenance job used to kick of nightly jobs.

==============================================================================
NOTES:
            * 02/27/2012 MVT - Created Stored Proc
			* 05/08/2012 MVT - Added Failed Fee Notification check to nightly job.
			* 10/01/2012 MVT - Added a stored proc to update client profitability
			* 10/25/2012 MVT - Added a stored proc to update order denormalization
			* 11/14/2012 MVT - Removed Client Profitability Update and Order Denormalization update.
								Now done as part of D_0700_SalesOrderDetailIdentifier_Update Job.
			* 11/06/2013 MVT - Added a stored proc to clean up inventory transfer requests.
			* 09/30/2014 MVT - Added a step to clean up Tricho View Appointments
			* 07/13/2016 SAL - Added a step to clear datSalesOrderTransaction.MonetraTransactionID
								if Credit Card is expired.
			* 07/14/2016 PRM - Added a step to set future appointment's priority color to high if
								they are within 90 days of their initial application
			* 06/14/2017 PRM - Added logic to default a client's anniversary date if it's not already set
			* 08/08/2017 SAL - Added a stored proc to create activities for missed appointments and
								a stored proc to create activities for missed room visits from the prior day.
							   Added @Yesterday variable to pass into these two new stored procs.
			* 08/14/2017 SAL - Comment out 08/08/2017 changes: execution of mtnCreateActivitiesForMissedAppointments and
								mtnCreateActivitiesForMissedClientVisits.  These were put on HOLD for now.
			* 09/11/2017 SAL - Reinstated execution of mtnCreateActivitiesForMissedAppointments and
								mtnCreateActivitiesForMissedClientVisits.
			* 01/11/2018 SAL - Added a stored proc to create activities for client's whose membership pricing is below
								National Pricing and their membership is due to expire.
			* 12/19/2018 SAL - Added a stored proc to set the national monthly fee on client memberships (TFS #11781)
			* 06/27/2019 SAL - Added a stored proc to set the stylist for Product Kit Add-On Monthly Fee
								sales orders (TFS #11702)
			* 09/19/2019 JLM - Remove missed client visit activities creation. (TFS #13107)

==============================================================================
SAMPLE EXECUTION:
EXEC [mtnNightlyMaintenance]
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnNightlyMaintenance]
AS
BEGIN

	DECLARE @Yesterday DATE = CONVERT(DATE, DATEADD(DAY, -1, GetDate()), 101)

	PRINT '[mtnActivateVendorContracts] STARTED - ' + CONVERT(char(10), GetDate(),114)
	EXEC [mtnActivateVendorContracts]
	PRINT '[mtnActivateCenterContracts] STARTED - ' + CONVERT(char(10), GetDate(),114)
	EXEC [mtnActivateCenterContracts]
	--PRINT '[mtnCreateFeeNotifications] STARTED - ' + CONVERT(char(10), GetDate(),114)
	--EXEC [mtnCreateFeeNotifications]
	PRINT '[mtnCleanupInventoryTransfers] STARTED - ' + CONVERT(char(10), GetDate(),114)
	EXEC [mtnCleanupInventoryTransfers]
	PRINT '[mtnCleanupTrichoViewAppointments] STARTED - ' + CONVERT(char(10), GetDate(),114)
	EXEC [mtnCleanupTrichoViewAppointments]
	PRINT '[mtnClearMonetraIDsForExpiredCreditCards] STARTED - ' + CONVERT(char(10), GetDate(),114)
	EXEC [mtnClearMonetraIDsForExpiredCreditCards]
	PRINT '[mtnSetAppointmentPriorityColor] STARTED - ' + CONVERT(char(10), GetDate(),114)
	EXEC [mtnSetAppointmentPriorityColor]
	PRINT '[mtnSetClientAnniversaryDates] STARTED - ' + CONVERT(char(10), GetDate(),114)
	EXEC [mtnSetClientAnniversaryDates]
	PRINT '[mtnCreateActivitiesForMissedAppointments] STARTED - ' + CONVERT(char(10), GetDate(),114)
	EXEC [mtnCreateActivitiesForMissedAppointments] @Yesterday
	PRINT '[mtnCreateActivitiesForNationalPricing] STARTED - ' + CONVERT(char(10), GetDate(),114)
	EXEC [mtnCreateActivitiesForNationalPricing]
	PRINT '[mtnSetNationalMonthlyFeeOnClientMemberships] STARTED - ' + CONVERT(char(10), GetDate(),114)
	EXEC [mtnSetNationalMonthlyFeeOnClientMemberships]
	PRINT '[mtnSetSalesOrderDetailStylistForProductKitAddOnMonthlyFee] STARTED - ' + CONVERT(char(10), GetDate(),114)
	EXEC [mtnSetSalesOrderDetailStylistForProductKitAddOnMonthlyFee]

	---- Update Client Profitability (Not initial run)
	--EXEC [dbaClientProfitabilityUpdate] 0

	---- Update Order Denormalization
	--EXEC [dbaOrderDenormalizationUpdate]

END
GO
