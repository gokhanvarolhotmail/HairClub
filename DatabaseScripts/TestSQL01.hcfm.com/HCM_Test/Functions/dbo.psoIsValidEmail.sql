/* CreateDate: 06/11/2015 09:29:34.540 , ModifyDate: 07/16/2015 10:00:33.427 */
GO
-- =============================================
-- Author:		MJW Workwise, LLC
-- Create date: 2015-06-04
-- Description:	Use HC Business Rules to determine if Phone is valid
--
--				2015-07-09 MJW	Modify to allow domain names > 3 characters
-- =============================================
CREATE FUNCTION [dbo].[psoIsValidEmail]
(
	-- Add the parameters for the function here
	@email nvarchar(100)
)
RETURNS nchar(1)
AS
BEGIN
	DECLARE @valid_flag nchar(1)

	SET @valid_flag = 'Y'
	SET @email = LTRIM(RTRIM(@email))

	IF ISNULL(@email,'') <> ''
	BEGIN
		IF CHARINDEX(N'@',@email) = 0 --email must have '@'
			SET @valid_flag = 'N'
		IF CHARINDEX(N'@',@email) = 1 --email cannot start with '@'
			SET @valid_flag = 'N'
		IF CHARINDEX(N'@',@email) = LEN(@email) --email cannot end with '@'
			SET @valid_flag = 'N'
		IF CHARINDEX(N'@',@email,CHARINDEX(N'@',@email)+1) > 0 --email cannot have more than 1 '@'
			SET @valid_flag = 'N'
		IF CHARINDEX(N' ',@email) > 0 --email cannot have spaces
			SET @valid_flag = 'N'
		IF CHARINDEX(N';',@email) > 0 --email cannot contain ';'
			SET @valid_flag = 'N'
		IF CHARINDEX(N',',@email) > 0 --email cannot contain ','
			SET @valid_flag = 'N'
		IF CHARINDEX(N'@SPAM.COM',UPPER(@email)) > 0 --email cannot end in '@SPAM.COM'
			SET @valid_flag = 'N'

		IF CHARINDEX(N'.',@email) > 0
		BEGIN
			DECLARE @lastdotposition int
			DECLARE @lastatposition int
			DECLARE @domain nvarchar(10)
			SET @lastdotposition = CHARINDEX(N'.',@email)
			SET @lastatposition = CHARINDEX(N'@',@email)
			WHILE CHARINDEX(N'.',@email, @lastdotposition + 1) > 0
			BEGIN
				SET @lastdotposition = CHARINDEX(N'.',@email, @lastdotposition + 1)
			END
			WHILE CHARINDEX(N'@',@email, @lastatposition + 1) > 0
			BEGIN
				SET @lastatposition = CHARINDEX(N'@',@email, @lastatposition + 1)
			END

			SET @domain = SUBSTRING(@email, @lastdotposition+1, LEN(@email))

			--IF (LEN(@domain) < 2 OR LEN(@domain) > 3) -- domain must be 2 or 3 chars
			IF (LEN(@domain) < 2) -- domain must be 2 or more chars
				SET @valid_flag = 'N'
			ELSE
			BEGIN
				IF ASCII(SUBSTRING(@domain,1,1)) < 65 OR ASCII(SUBSTRING(@domain,1,1)) > 122
					SET @valid_flag = 'N'
				IF ASCII(SUBSTRING(@domain,2,1)) < 65 OR ASCII(SUBSTRING(@domain,2,1)) > 122
					SET @valid_flag = 'N'
				IF LEN(@domain) = 3
				BEGIN
					IF ASCII(SUBSTRING(@domain,3,1)) < 65 OR ASCII(SUBSTRING(@domain,3,1)) > 122
						SET @valid_flag = 'N'
				END

				IF @lastatposition >= @lastdotposition - 1
					SET @valid_flag = 'N'
			END
		END
		ELSE
			SET @valid_flag = 'N' --email must have a '.'
	END
	ELSE
		SET @valid_flag = 'N' --email cannot be empty

	RETURN @valid_flag
END
GO
