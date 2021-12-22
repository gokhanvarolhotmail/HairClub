/* CreateDate: 02/18/2013 06:45:39.427 , ModifyDate: 02/27/2017 09:49:37.207 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function fnGetAppointmentServiceList
(@apptguid uniqueidentifier)
RETURNS varchar(1000)
AS
BEGIN
	DECLARE @p_str VARCHAR(1000)
	SET @p_str = ''
	SELECT @p_str = @p_str + ',' + CAST(sc.SalesCodeDescription AS VARCHAR(30))
		FROM datAppointmentDetail apptdet
			left outer join cfgSalesCode sc
				ON apptdet.SalesCodeID = sc.SalesCodeID
	WHERE appointmentguid = @APPTGUID

	RETURN @p_str

END
GO
