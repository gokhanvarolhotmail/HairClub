/* CreateDate: 09/30/2013 10:50:10.920 , ModifyDate: 09/30/2013 10:50:10.920 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[psoWirelessScrubProcessRow]
	@WirelessScrubHistoryId	NCHAR(10),
	@FullPhoneNumber		NCHAR(10),
	@DNC					NCHAR(3)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IsWireless NCHAR(1)
	DECLARE @UserCode	NCHAR(20)
	DECLARE @DNCCode	NCHAR(10)

	SELECT
		@IsWireless	= is_wireless,
		@DNCCode	= dnc_code
	FROM csta_dnc
	WHERE
		dnc_code = @DNC

	IF (LEN(RTRIM(ISNULL(@DNC, ''))) > 0 AND @DNCCode IS NULL)
	BEGIN
		SET @DNCCode = 'NOTFOUND'
	END

	SET @UserCode	= (SELECT scrub_user_code FROM cstd_wireless_scrub_history WHERE wireless_scrub_history_id = @WirelessScrubHistoryId)

	INSERT INTO cstd_wireless_scrub_history_detail (wireless_scrub_history_id, full_phone_number, dnc_code)
	VALUES (@WirelessScrubHistoryId, @FullPhoneNumber, @DNC)

    IF (@IsWireless = 'Y')
	BEGIN
		UPDATE oncd_contact_phone SET
			phone_type_code = 'CELL',
			updated_date = GETDATE(),
			updated_by_user_code = @UserCode,
			cst_dnc_code = @DNCCode,
			cst_last_dnc_date = GETDATE()
		WHERE
			oncd_contact_phone.cst_full_phone_number = @FullPhoneNumber
	END
	ELSE IF (@DNCCode IS NOT NULL)
	BEGIN
		UPDATE oncd_contact_phone SET
			updated_date = GETDATE(),
			updated_by_user_code = @UserCode,
			cst_dnc_code = @DNCCode,
			cst_last_dnc_date = GETDATE()
		WHERE
			oncd_contact_phone.cst_full_phone_number = @FullPhoneNumber
	END
END
GO
