/* CreateDate: 07/30/2015 15:51:14.867 , ModifyDate: 07/30/2015 15:51:14.867 */
GO
CREATE FUNCTION [dbo].[DateOnly] (@Date datetime)
RETURNS varchar(12)
AS
BEGIN
	RETURN CONVERT(varchar(12), @Date, 101)
END
GO
