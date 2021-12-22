/* CreateDate: 02/18/2013 06:45:39.417 , ModifyDate: 02/27/2017 09:49:36.893 */
GO
create function f_get_str
(@apptguid uniqueidentifier)
RETURNS varchar(1000)
as
BEGIN
	DECLARE @p_str VARCHAR(1000)
	SET @p_str = ''
	SELECT @p_str = @p_str + ',' + CAST(SALESCODEID AS VARCHAR(6))
		FROM datAppointmentDetail
	where appointmentguid = @APPTGUID

	RETURN @p_str

end
GO
