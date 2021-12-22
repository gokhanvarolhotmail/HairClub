CREATE	FUNCTION fnIsAppointment (@ActionCode NVARCHAR(50), @ResultCode NVARCHAR(50))
RETURNS BIT
AS
BEGIN
	RETURN	(CASE WHEN @ActionCode IN ( 'Appointment', 'In House' )
					AND (
							@ResultCode NOT IN ( 'Reschedule', 'Cancel', 'Center Exception', 'Void', 'Manual Credit' )
							OR @ResultCode IS NULL
							OR @ResultCode = ''
						) THEN 1
				ELSE 0
			END
		)
END
