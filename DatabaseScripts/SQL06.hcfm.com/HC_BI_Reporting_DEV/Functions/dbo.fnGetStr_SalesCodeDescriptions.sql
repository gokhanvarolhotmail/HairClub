/* CreateDate: 02/27/2015 15:24:38.733 , ModifyDate: 02/27/2015 15:51:50.917 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetStr_SalesCodeDescriptions]
(@AppointmentSSID UNIQUEIDENTIFIER)
RETURNS VARCHAR(MAX)
AS

BEGIN
	DECLARE @p_str VARCHAR(1000)
	SET @p_str = ''
	SELECT @p_str = @p_str + ', ' + CAST(scode.SalesCodeDescription AS VARCHAR(100))
		FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment ap
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail ad
			ON ap.AppointmentKey = ad.AppointmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode scode
			ON scode.SalesCodeKey = ad.SalesCodeKey
	WHERE AppointmentSSID = @AppointmentSSID

	RETURN RIGHT(@p_str,LEN(@p_str)-2)  --remove the first comma

END
GO
