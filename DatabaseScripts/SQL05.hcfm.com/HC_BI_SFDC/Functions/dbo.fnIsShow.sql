/* CreateDate: 09/29/2020 16:43:18.213 , ModifyDate: 09/29/2020 16:43:18.213 */
GO
CREATE	FUNCTION fnIsShow (@ActionCode NVARCHAR(50), @ResultCode NVARCHAR(50))
RETURNS BIT
AS
BEGIN
	RETURN (CASE WHEN @ResultCode IN ( 'Show No Sale', 'Show Sale' ) THEN 1 ELSE 0 END)
END
GO
