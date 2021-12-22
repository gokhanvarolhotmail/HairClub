/* CreateDate: 09/26/2013 14:54:16.010 , ModifyDate: 09/26/2013 14:54:16.010 */
GO
-- =============================================
-- Create date: 17 January 2013
-- Description:	Determines if the provided phone number is valid.
-- =============================================
CREATE FUNCTION [dbo].[psoIsValidPhoneNumber]
(
	@AreaCode NCHAR(10), @PhoneNumber NCHAR(20)
)
RETURNS NCHAR(1)
AS
BEGIN
	DECLARE @IsValid NCHAR(1)
	DECLARE @NewAreaCode NCHAR(10)
	DECLARE @NewPhoneNumber NCHAR(20)

	SET @IsValid = 'Y'

	SET @NewAreaCode    = dbo.RegexReplace(ISNULL(@AreaCode, ''), '[^0-9]', '')
	SET @NewPhoneNumber = dbo.RegexReplace(ISNULL(@PhoneNumber, ''), '[^0-9]', '')

	IF (RTRIM(@NewAreaCode) <> RTRIM(@AreaCode) OR
		RTRIM(@NewPhoneNumber) <> RTRIM(@PhoneNumber) OR
		RTRIM(@NewAreaCode) < '200' OR
		RTRIM(@NewAreaCode) = '222' OR
		RTRIM(@NewAreaCode) = '333' OR
		RTRIM(@NewAreaCode) = '444' OR
		RTRIM(@NewAreaCode) = '555' OR
		RTRIM(@NewAreaCode) = '666' OR
		RTRIM(@NewAreaCode) = '777' OR
		RTRIM(@NewAreaCode) = '888' OR
		RTRIM(@NewAreaCode) = '999' OR
		LEN(RTRIM(@NewAreaCode)) <> 3 OR
		LEN(RTRIM(@NewPhoneNumber)) <> 7 OR
		(RTRIM(@NewAreaCode) = '123' AND RTRIM(@NewPhoneNumber) = '4567890') OR
		(RTRIM(@NewAreaCode) = '987' AND RTRIM(@NewPhoneNumber) = '6543210'))
	BEGIN
		SET @IsValid = 'N'
	END

	RETURN @IsValid
END
GO
