/* CreateDate: 01/03/2008 13:49:54.717 , ModifyDate: 05/01/2010 14:48:08.867 */
GO
CREATE FUNCTION [dbo].[ISNOSHOW] (@result_code varchar(10))
RETURNS bit AS
BEGIN
RETURN(
CASE WHEN @result_code IN ('NOSHOW')
THEN 1
ELSE 0 END
)
END
GO
