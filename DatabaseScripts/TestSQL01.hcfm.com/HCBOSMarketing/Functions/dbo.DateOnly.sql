/* CreateDate: 06/05/2008 16:25:53.577 , ModifyDate: 06/05/2008 16:25:53.577 */
GO
CREATE FUNCTION dbo.DateOnly (@Date datetime)
RETURNS varchar(12)
AS
BEGIN
	RETURN CONVERT(varchar(12), @Date, 101)
END
GO
