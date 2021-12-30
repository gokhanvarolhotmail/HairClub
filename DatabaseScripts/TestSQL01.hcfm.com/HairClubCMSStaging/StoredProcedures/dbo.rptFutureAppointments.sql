/* CreateDate: 02/18/2013 07:43:35.710 , ModifyDate: 03/26/2018 10:54:24.663 */
GO
/***********************************************************************
PROCEDURE:				rptFutureAppointments
DESTINATION SERVER:		SQL01
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Shaun Hankermeyer
IMPLEMENTOR:			Shaun Hankermeyer
DATE IMPLEMENTED:		3/17/2009
DESCRIPTION:			2/26/2018
------------------------------------------------------------------------
NOTES:

Retrieve data for future appointments.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC rptFutureAppointments '61A35D2B-3AC2-4676-9197-0CED8F1922CD'
***********************************************************************/
CREATE PROCEDURE rptFutureAppointments
(
	@SalesOrderGUID UNIQUEIDENTIFIER
)
AS
BEGIN

SET NOCOUNT ON;


SELECT  DISTINCT TOP ( 5 )
		x_A.AppointmentDate
,       x_A.StartDateTimeCalc
,       x_A.CheckinTime
,       dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag)
,		x_A.AbbreviatedNameCalc AS 'EmpName'
,       x_A.SalesCodeDescription AS 'Srvc'
,		x_A.AppointmentDurationCalc
FROM    datSalesOrder so
        INNER JOIN cfgCenter ctr
            ON ctr.CenterID = so.CenterID
        INNER JOIN lkpTimeZone tz
            ON tz.TimeZoneID = ctr.TimeZoneID
        CROSS APPLY ( SELECT    da.AppointmentDate
                      ,         da.StartDateTimeCalc
                      ,         da.CheckinTime
                      ,         sc.SalesCodeDescriptionShort
                      ,         sc.SalesCodeDescription
                      ,         da.AppointmentDurationCalc
					  ,			de.AbbreviatedNameCalc
                      FROM      datAppointment da
                                INNER JOIN datAppointmentDetail dad
                                    ON dad.AppointmentGUID = da.AppointmentGUID
								INNER JOIN datAppointmentEmployee ae
									ON ae.AppointmentGUID = da.AppointmentGUID
								INNER JOIN datEmployee de
									ON de.EmployeeGUID = ae.EmployeeGUID
                                INNER JOIN cfgSalesCode sc
                                    ON sc.SalesCodeID = dad.SalesCodeID
                      WHERE     da.ClientGUID = so.ClientGUID
                                AND ISNULL(da.IsDeletedFlag, 0) = 0
                    ) x_A
WHERE   so.SalesOrderGUID = @SalesOrderGUID
        AND x_A.StartDateTimeCalc > dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag)
        AND x_A.CheckinTime IS NULL
ORDER BY x_A.StartDateTimeCalc ASC

END
GO
