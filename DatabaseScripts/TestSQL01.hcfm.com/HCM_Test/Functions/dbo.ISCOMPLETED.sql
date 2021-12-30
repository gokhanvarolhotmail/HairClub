/* CreateDate: 09/04/2007 09:40:45.633 , ModifyDate: 05/01/2010 14:48:08.930 */
GO
CREATE  FUNCTION [dbo].[ISCOMPLETED] (@result_code as varchar(10))
RETURNS bit AS
BEGIN
RETURN(
CASE WHEN @result_code Like '%SHOW%'
THEN 1
ELSE 0 END

)
END
GO
