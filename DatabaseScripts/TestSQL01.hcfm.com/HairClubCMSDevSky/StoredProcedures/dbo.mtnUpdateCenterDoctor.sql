/* CreateDate: 08/05/2009 00:06:30.360 , ModifyDate: 02/27/2017 09:49:23.203 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnUpdateCenterDoctor

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		8/4/09

LAST REVISION DATE: 	8/4/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Updates a center's doctor and associated records

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnUpdateCenterDoctor 301, '764E4758-60F2-4810-907C-615C0E219F9D', '8/1/2009'

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnUpdateCenterDoctor]
	 @CenterID int,
	 @DoctorGUID uniqueidentifier,
	 @DoctorRegionID int,
	 @EffectiveDate date
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @PreviousDoctorGUID uniqueidentifier
	SELECT @PreviousDoctorGUID = EmployeeDoctorGUID FROM cfgCenter WHERE CenterID = @CenterID

	--update doctor on center record
	UPDATE cfgCenter
	SET EmployeeDoctorGUID = @DoctorGUID,
		DoctorRegionID = @DoctorRegionID,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = 'sa'
	WHERE CenterID = @CenterID

	--update Appointments (actually AppointmentEmployee records)
	UPDATE ae
	SET EmployeeGUID = @DoctorGUID,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = 'sa'
	FROM datAppointment a
		INNER JOIN datAppointmentEmployee ae ON a.AppointmentGUID = ae.AppointmentGUID
	WHERE CenterID = @CenterID
		AND EmployeeGUID = @PreviousDoctorGUID
		AND a.AppointmentDate >= @EffectiveDate

	--update Sales Orders (header record)
	UPDATE so
	SET EmployeeGUID = @DoctorGUID,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = 'sa'
	FROM datSalesOrder so
	WHERE CenterID = @CenterID
		AND EmployeeGUID = @PreviousDoctorGUID
		AND so.OrderDate >= @EffectiveDate

	--update Sales Order Details (Employee 1)
	UPDATE sod
	SET Employee1GUID = @DoctorGUID,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = 'sa'
	FROM datSalesOrder so
		INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
	WHERE CenterID = @CenterID
		AND Employee1GUID = @PreviousDoctorGUID
		AND so.OrderDate >= @EffectiveDate

	--update Sales Order Details (Employee 2)
	UPDATE sod
	SET Employee3GUID = @DoctorGUID,
		LastUpdate = GETUTCDATE(),
		LastUpdateUser = 'sa'
	FROM datSalesOrder so
		INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
	WHERE CenterID = @CenterID
		AND Employee3GUID = @PreviousDoctorGUID
		AND so.OrderDate >= @EffectiveDate


	/*
		--queries to verify what appts & sales orders were updated
		SELECT a.*
		FROM datAppointment a
			INNER JOIN datAppointmentEmployee ae ON a.AppointmentGUID = ae.AppointmentGUID
		WHERE CenterID = @CenterID
			AND EmployeeGUID = @DoctorGUID
			AND a.AppointmentDate >= @EffectiveDate

		SELECT so.*
		FROM datSalesOrder so
			INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
		WHERE CenterID = @CenterID
			AND so.OrderDate >= @EffectiveDate
			AND (
				so.EmployeeGUID = @DoctorGUID
				OR sod.Employee1GUID = @DoctorGUID
				OR sod.Employee2GUID = @DoctorGUID
			)
	*/
END
GO
