/* CreateDate: 09/29/2020 17:09:24.167 , ModifyDate: 09/29/2020 17:09:24.167 */
GO
CREATE	FUNCTION fnIsNoShow (@ActionCode NVARCHAR(50), @ResultCode NVARCHAR(50))
RETURNS BIT
AS
BEGIN
	RETURN (CASE WHEN @ResultCode IN ( 'No Show' ) THEN 1 ELSE 0 END)
END
GO
