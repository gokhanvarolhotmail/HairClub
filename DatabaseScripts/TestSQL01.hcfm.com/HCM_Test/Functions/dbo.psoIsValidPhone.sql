/* CreateDate: 06/11/2015 09:29:34.627 , ModifyDate: 06/11/2015 09:29:34.627 */
GO
-- =============================================
-- Author:		MJW Workwise, LLC
-- Create date: 2015-06-04
-- Description:	Use HC Business Rules to determine if Phone is valid
-- =============================================
CREATE FUNCTION [dbo].[psoIsValidPhone]
(
	-- Add the parameters for the function here
	@area_code nvarchar(10), @phone_number nvarchar(20)
)
RETURNS nchar(1)
AS
BEGIN
		DECLARE @valid_flag nchar(1)
		SET @valid_flag = 'Y'

		SET @area_code    = dbo.RegexReplace(ISNULL(@area_code, ''), '[^0-9]', '')
		SET @phone_number = dbo.RegexReplace(ISNULL(@phone_number, ''), '[^0-9]', '')

		IF (LEN(@area_code) < 3 OR @area_code = '555' OR @area_code = '999')
			SET @valid_flag = 'N'

		IF ISNUMERIC(@area_code) = 1
		BEGIN
			IF CONVERT(int, LEFT(@area_code,3)) < 200
				SET @valid_flag = 'N'
		END
		ELSE
			SET @valid_flag = 'N'

		IF ISNUMERIC(LEFT(@phone_number,7)) = 0
			SET @valid_flag = 'N'

		IF  (@phone_number = '0000000' OR
			@phone_number = '1111111' OR
			@phone_number = '2222222' OR
			@phone_number = '3333333' OR
			@phone_number = '4444444' OR
			@phone_number = '5555555' OR
			@phone_number = '6666666' OR
			@phone_number = '7777777' OR
			@phone_number = '8888888' OR
			@phone_number = '9999999')
				SET @valid_flag = 'N'

	RETURN @valid_flag

END
GO
