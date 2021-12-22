/* CreateDate: 07/14/2011 08:17:01.217 , ModifyDate: 10/05/2012 08:53:41.797 */
GO
CREATE FUNCTION [dbo].[DateOnly] (@Date datetime)
RETURNS varchar(12)
AS
BEGIN
	RETURN CONVERT(varchar(12), @Date, 101)
END
GO
