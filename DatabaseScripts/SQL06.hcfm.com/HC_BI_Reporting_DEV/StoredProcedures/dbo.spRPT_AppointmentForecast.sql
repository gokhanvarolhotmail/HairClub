/* CreateDate: 07/12/2011 09:34:57.813 , ModifyDate: 03/28/2013 15:55:04.653 */
GO
/*
==============================================================================

PROCEDURE:				spRPT_AppointmentForecast

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_Reporting

RELATED APPLICATION:

AUTHOR: 				Marlon Burrell

IMPLEMENTOR: 			Marlon Burrell

DATE CREATED: 			4/24/08

DATE IMPLEMENTED: 		4/24/08

LAST REVISION DATE: 	07/12/2011

==============================================================================
DESCRIPTION:	Report to display next 14 days of appointments
==============================================================================
NOTES:	09/24/2009 - JH - Converted this report to run off of HairClub CMS.
		12/10/2009 - DL	- Added 'All Doctors' functionality
		07/12/2011 - KM - Migrated to SQL06
		03/28/2013 - KM - Added like '[356]%'
==============================================================================
GRANT EXECUTE ON spRPT_AppointmentForecast to IIS
==============================================================================
SAMPLE EXECUTION:

spRPT_AppointmentForecast '301', 1
spRPT_AppointmentForecast 'Didocha', 1
spRPT_AppointmentForecast 'ALL', 1
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRPT_AppointmentForecast]
(
	@Center VARCHAR(50),
	@Type INT
)
AS
	SET NOCOUNT ON

	CREATE TABLE #DateLookup
	  (
		[DateKey] INT PRIMARY KEY
	  , [DateFull] DATETIME
	  , [CharacterDate] VARCHAR(10)
	  , [FullYear] CHAR(4)
	  , [QuarterNumber] TINYINT
	  , [WeekNumber] TINYINT
	  , [WeekDayName] VARCHAR(10)
	  , [MonthDay] TINYINT
	  , [MonthName] VARCHAR(12)
	  , [YearDay] SMALLINT
	  , [DateDefinition] VARCHAR(30)
	  , [WeekDay] TINYINT
	  , [MonthNumber] TINYINT
	  , [WeekStart] VARCHAR(10)
	  , [WeekEnd] VARCHAR(10)
	  )


	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME
	DECLARE @TempDate DATETIME

	SET @StartDate = CONVERT(VARCHAR(12), GETDATE(), 101)
	SET @EndDate = CONVERT(VARCHAR(12), DATEADD(DAY, 60, GETDATE()), 101)

	WHILE @StartDate < @EndDate
	  BEGIN
		INSERT  INTO #DateLookup
				(
				  [DateKey]
				, [DateFull]
				, [FullYear]
				, [QuarterNumber]
				, [WeekNumber]
				, [WeekDayName]
				, [MonthDay]
				, [MonthName]
				, [YearDay]
				, [DateDefinition]
				, [CharacterDate]
				, [WeekDay]
				, [MonthNumber]
				, [WeekStart]
				, [WeekEnd]
				)
				SELECT  CONVERT(VARCHAR(8), @StartDate, 112)
				,       @StartDate
				,       YEAR(@StartDate)
				,       DATEPART(qq, @StartDate)
				,       DATEPART(ww, @StartDate)
				,       DATENAME(dw, @StartDate)
				,       DATEPART(dd, @StartDate)
				,       DATENAME(mm, @StartDate)
				,       DATEPART(dy, @StartDate)
				,       DATENAME(mm, @StartDate) + ' ' + CAST(DATEPART(dd, @StartDate) AS CHAR(2)) + ', ' + CAST(DATEPART(yy, @StartDate) AS CHAR(4))
				,       CONVERT(VARCHAR(10), @StartDate, 101)
				,       DATEPART(dw, @StartDate)
				,       DATEPART(mm, @StartDate)
				,		CONVERT(VARCHAR(10), [dbo].[fxStartOfWeek](@StartDate, 2), 101)
				,		CONVERT(VARCHAR(10), [dbo].[fxEndOfWeek](@StartDate, 2), 101)

		SET @StartDate = DATEADD(dd, 1, @StartDate)
	  END


SELECT  CONVERT(VARCHAR, DATENAME(dw, #DateLookup.[DateFull])) + ' - ' + CONVERT(VARCHAR(10), #DateLookup.[DateFull], 101) AS 'CurrentDate'
,       #DateLookup.[WeekNumber]
,       #DateLookup.[WeekStart]
,       #DateLookup.[WeekEnd]
,       vwAppointments.CenterDescriptionFullCalc AS 'Center'
,       vwAppointments.ClientFullNameAltCalc AS 'Client'
,       vwAppointments.AppointmentDate AS 'ApptDate'
,       vwAppointments.StartTime
,       vwAppointments.EndTime
,       CAST(STUFF(RIGHT(CONVERT(varchar(26), CAST(vwAppointments.StartTime AS DATETIME), 109), 15), 7, 7, ' ') AS VARCHAR(12)) + ' - '
        + CAST(STUFF(RIGHT(CONVERT(varchar(26), CAST(vwAppointments.EndTime AS DATETIME), 109), 15), 7, 7, ' ') AS VARCHAR(12)) AS 'Time'
,       vwAppointments.Duration AS 'TotalDuration'
,       vwAppointments.SalesCodeDescriptionShort AS 'SalesCode'
,       vwAppointments.SalesCodeDescription AS 'Description'
,       vwAppointments.Duration
,       CONVERT(VARCHAR(10), GETDATE(), 101) AS 'StartDate'
,       CONVERT(VARCHAR(10), DATEADD(DAY, 14, GETDATE()), 101) AS 'EndDate'
,       vwAppointments.ClientHomeCenterDescriptionFullCalc AS 'ToCenter'
,       vwAppointments.Grafts AS 'Grafts'
,       vwAppointments.DoctorRegionDescription AS 'Doctor'
FROM    #DateLookup
        LEFT OUTER JOIN vwAppointments
          ON #DateLookup.[DateFull] = vwAppointments.AppointmentDate
             AND vwAppointments.CenterID LIKE CASE ISNUMERIC(@Center)
                                                WHEN 1 THEN @Center
                                                ELSE '%'
                                              END
WHERE   vwAppointments.CenterID like '[356]%'
		AND vwAppointments.SalesCodeDescriptionShort LIKE CASE WHEN @Type = 2 THEN 'SURPOST%'
                                                           ELSE '%'
                                                      END
        AND vwAppointments.CenterID LIKE CASE ISNUMERIC(@Center)
                                           WHEN 1 THEN @Center
                                           ELSE '%'
                                         END
        AND vwAppointments.DoctorRegionDescription LIKE CASE WHEN ISNUMERIC(@Center) = 1 OR @Center = 'ALL'
                                                          THEN '%'
                                                          ELSE '%' + @Center
                                                        END
ORDER BY vwAppointments.DoctorRegionDescription
,		vwAppointments.AppointmentDate
,       vwAppointments.StartTime
,       vwAppointments.CenterID
GO
