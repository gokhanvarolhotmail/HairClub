/* CreateDate: 10/15/2007 16:13:55.360 , ModifyDate: 05/01/2010 14:48:08.837 */
GO
CREATE FUNCTION [dbo].[ISSALE] (@result_code varchar(10))
RETURNS bit AS
BEGIN
RETURN(
CASE WHEN @result_code IN ('SHOWSALE')
THEN 1
ELSE 0 END
)
END
GO
