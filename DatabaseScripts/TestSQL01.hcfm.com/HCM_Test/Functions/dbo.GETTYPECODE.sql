/* CreateDate: 10/15/2007 10:40:52.643 , ModifyDate: 05/01/2010 14:48:09.017 */
GO
-- =============================================
-- Author:		Howard Abelow
-- Create date: 8/20/2007
-- Description:	returns a code based on language and gender
-- =============================================
CREATE FUNCTION [dbo].[GETTYPECODE]
(
	-- Add the parameters for the function here
	@language varchar(20), @gender varchar(20)
)
RETURNS char(2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @type char(2)

	-- combine the two fields
	SELECT @type =
		CASE
			WHEN @language = 'SPANISH' AND  @gender = 'female' THEN 'SF'
			WHEN @language <> 'SPANISH' AND  @gender = 'female' THEN 'EF'
			WHEN @language = 'SPANISH' AND  @gender = 'male' THEN 'SM'
			WHEN @language <> 'SPANISH' AND  @gender = 'male' THEN 'EM'
			ELSE 'NA'
		END

	-- Return the result of the function
	RETURN @type

END
GO
