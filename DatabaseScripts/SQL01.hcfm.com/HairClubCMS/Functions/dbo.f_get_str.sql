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
