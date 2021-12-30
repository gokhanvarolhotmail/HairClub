/* CreateDate: 09/04/2007 09:40:45.620 , ModifyDate: 05/01/2010 14:48:08.807 */
GO
CREATE FUNCTION [dbo].[ISSHOW] (@result_code varchar(10))
RETURNS bit AS
BEGIN
RETURN(
CASE WHEN @result_code IN ('SHOWSALE','SHOWNOSALE')
THEN 1
ELSE 0 END
)
END
GO
