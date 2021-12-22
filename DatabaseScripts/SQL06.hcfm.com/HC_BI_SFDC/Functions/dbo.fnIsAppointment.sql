/* CreateDate: 09/29/2020 17:09:23.873 , ModifyDate: 09/29/2020 17:09:23.873 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
