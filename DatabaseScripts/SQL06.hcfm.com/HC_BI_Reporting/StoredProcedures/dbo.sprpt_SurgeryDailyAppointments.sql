/* CreateDate: 09/13/2011 15:50:45.860 , ModifyDate: 03/28/2013 15:51:32.103 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				sprpt_SurgeryDailyAppointments

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Hung Du

DATE IMPLEMENTED:		09/13/2011

LAST REVISION DATE: 	09/13/2011

==============================================================================
DESCRIPTION:	Shows daily appointments for surgery sales for a date range
				or for the default Today + 7 days for a specific doctor or all
==============================================================================
NOTES:
--
9/13/2011	- HD - Create
--

==============================================================================
GRANT EXECUTE ON  sprpt_SurgeryDailyAppointments TO IIS
==============================================================================
SAMPLE EXECUTION:

EXEC [sprpt_SurgeryDailyAppointments] '3/1/2013', '7/31/2013', 'jones'

EXEC [sprpt_SurgeryDailyAppointments]
==============================================================================
*/
CREATE PROCEDURE [dbo].[sprpt_SurgeryDailyAppointments]
	@StartDate	DATETIME = NULL -- Optional, linked with EndDate , Defaults to Today
,	@EndDate	DATETIME = NULL -- Optional, linked with StartDate, Defaults to Today + 7 days
,	@DoctorRegionDescriptionShort VARCHAR(10) = NULL -- Optional
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

IF (@StartDate IS NULL OR @StartDate ='' OR @EndDate IS NULL OR @EndDate = '')
BEGIN
	SELECT @StartDate = CONVERT(VARCHAR(10),GETDATE(),120)
	, @EndDate = DATEADD(DAY,7,@StartDate)
END

SELECT
 INFO.CenterKey 'CenterKey'
,INFO.AppointmentDate
,LEFT(INFO.AppointmentStartTime,8) AppointmentStartTime
,LEFT(INFO.AppointmentEndTime,8) AppointmentEndTime
,Appointment.CenterDescriptionFullCalc AS 'Appt_Center'
,Client.ClientFullName + ' (' + CAST(Client.ClientIdentifier AS VARCHAR(100)) + ') ' AS ClientFullName
,Appointment.ClientHomeCenterDescriptionFullCalc AS 'ClientCenter'
,Appointment.SalesCodeDescription AS 'Description'
,Appointment.Grafts
,Appointment.ContractAmount
,Appointment.ContractPaidAmount
,Appointment.Balance

INTO #AppointmentData
FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment INFO
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.vwDimClient Client
		ON INFO.ClientKey = Client.ClientKey
	INNER JOIN dbo.vwAppointments_HD Appointment
		ON INFO.AppointmentSSID = Appointment.AppointmentGUID
WHERE INFO.AppointmentDate BETWEEN @StartDate AND @EndDate
AND INFO.CenterSSID like '[356]%' AND Appointment.CenterID like '[356]%'
AND Appointment.SalesCodeDescriptionShort LIKE '%' --SURPOST*
AND (@DoctorRegionDescriptionShort IS NULL
	OR @DoctorRegionDescriptionShort = ''
	OR Appointment.DoctorRegionDescriptionShort = @DoctorRegionDescriptionShort)

--AND INFO.AppointmentSubject = 'Perform Surgery'

--select * from #AppointmentData

SELECT
CASE WHEN CenterType.CenterTypeDescriptionShort = 'JV' THEN 'Franchise' ELSE CenterType.CenterTypeDescription END AS 'CenterType'
,DoctorRegion.DoctorRegionDescriptionShort 'Region'
,COUNT(Appointment.AppointmentDate) OVER(PARTITION BY CenterType.CenterTypeDescription, CenterType.CenterTypeDescriptionShort,Center.DoctorRegionKey) AS TotalRegionAppointments
,SUM(ISNULL(Appointment.Grafts,0)) OVER(PARTITION BY CenterType.CenterTypeDescription, CenterType.CenterTypeDescriptionShort,Center.DoctorRegionKey) AS TotalRegionGrafts
,Appointment.AppointmentDate
,Appointment.AppointmentStartTime
,Appointment.AppointmentEndTime
,Appointment.Appt_Center
,Appointment.ClientFullName
,Appointment.ClientCenter
,Appointment.[Description]
,Appointment.ContractAmount
,Appointment.Balance
,Appointment.Grafts
,CASE WHEN Appointment.ClientFullName IS NULL THEN 0 ELSE 1 END 'IsAppointment'
FROM HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter Center
INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[vwDimDoctorRegion] DoctorRegion
	ON Center.DoctorRegionKey= DoctorRegion.DoctorRegionKey
	AND Center.DoctorRegionKey > 0
	AND (@DoctorRegionDescriptionShort IS NULL
		OR @DoctorRegionDescriptionShort = ''
		OR DoctorRegion.DoctorRegionDescriptionShort = @DoctorRegionDescriptionShort)


INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenterType CenterType
	ON Center.CenterTypeKey = CenterType.CenterTypeKey
	AND Center.CenterTypeKey > 0
LEFT JOIN #AppointmentData Appointment
	ON Center.CenterKey = Appointment.CenterKey
WHERE Center.DoctorRegionKey > 0 and center.centerssid like '[356]%'
GROUP BY CenterType.CenterTypeDescription, CenterType.CenterTypeDescriptionShort
,DoctorRegion.DoctorRegionDescriptionShort
,Center.DoctorRegionKey
,Appointment.AppointmentDate
,Appointment.AppointmentStartTime
,Appointment.AppointmentEndTime
,Appointment.Appt_Center
,Appointment.ClientFullName
,Appointment.ClientCenter
,Appointment.[Description]
,Appointment.ContractAmount
,Appointment.Balance
,Appointment.Grafts
ORDER BY
CenterType.CenterTypeDescription, CenterType.CenterTypeDescriptionShort
,DoctorRegion.DoctorRegionDescriptionShort
,Center.DoctorRegionKey
,Appointment.AppointmentDate

DROP TABLE #AppointmentData

END
GO
