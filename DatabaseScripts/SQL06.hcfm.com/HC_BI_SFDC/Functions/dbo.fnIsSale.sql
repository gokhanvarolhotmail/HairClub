/* CreateDate: 09/29/2020 17:09:24.230 , ModifyDate: 09/29/2020 17:09:24.230 */
GO
CREATE	FUNCTION fnIsSale (@ActionCode NVARCHAR(50), @ResultCode NVARCHAR(50))
RETURNS BIT
AS
BEGIN
	RETURN (CASE WHEN @ResultCode IN ( 'Show Sale' ) THEN 1 ELSE 0 END)
END
GO