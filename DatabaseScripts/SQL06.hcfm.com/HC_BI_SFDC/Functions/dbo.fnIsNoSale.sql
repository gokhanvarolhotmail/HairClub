/* CreateDate: 09/29/2020 17:09:24.100 , ModifyDate: 09/29/2020 17:09:24.100 */
GO
CREATE	FUNCTION fnIsNoSale (@ActionCode NVARCHAR(50), @ResultCode NVARCHAR(50))
RETURNS BIT
AS
BEGIN
	RETURN (CASE WHEN @ResultCode IN ( 'Show No Sale' ) THEN 1 ELSE 0 END)
END
GO
