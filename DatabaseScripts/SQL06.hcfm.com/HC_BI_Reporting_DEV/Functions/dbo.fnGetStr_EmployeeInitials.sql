CREATE FUNCTION dbo.[fnGetStr_EmployeeInitials]
(@AppointmentSSID UNIQUEIDENTIFIER)
RETURNS VARCHAR(MAX)
AS

BEGIN
	DECLARE @e_str VARCHAR(1000)
	SET @e_str = ''
	SELECT @e_str = @e_str + ', ' + CAST(e.EmployeeInitials AS VARCHAR(100))
		FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail ad
			ON ap.AppointmentKey = ad.AppointmentKey
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].FactAppointmentEmployee fae
			ON ad.AppointmentKey = fae.AppointmentKey
		INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].DimEmployee e
			ON fae.EmployeeKey = e.EmployeeKey
	WHERE AppointmentSSID = @AppointmentSSID

	RETURN RIGHT(@e_str,LEN(@e_str)-1)  --remove the first comma

END
