/* CreateDate: 09/30/2013 10:51:11.330 , ModifyDate: 09/21/2015 09:17:52.877 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[psoWirelessScrubDailyExport]
	@WirelessHistoryId INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CurrentDate		DATETIME
	DECLARE @ScrubDate			DATETIME

	SET		@CurrentDate		= dbo.CombineDates(GETDATE(), NULL)
	SET		@ScrubDate			= DATEADD(DAY, -1, @CurrentDate)

	INSERT INTO cstd_wireless_scrub_history (scrub_date, scrub_type, scrub_direction, scrub_user_code)
	VALUES (@CurrentDate, 'DAILY', 'EXPORT', 'WIRELESS_SCRUB')

	SET @WirelessHistoryId = SCOPE_IDENTITY()

	INSERT INTO cstd_wireless_scrub_history_detail (wireless_scrub_history_id, full_phone_number)
	SELECT DISTINCT
		@WirelessHistoryId,
		oncd_contact_phone.cst_full_phone_number
	FROM oncd_contact_phone WITH (NOLOCK)
	INNER JOIN onca_phone_type WITH (NOLOCK) ON
		oncd_contact_phone.phone_type_code = onca_phone_type.phone_type_code
	WHERE
	(oncd_contact_phone.creation_date >= @ScrubDate OR oncd_contact_phone.updated_date >= @ScrubDate) AND
	oncd_contact_phone.cst_valid_flag = 'Y' AND
	onca_phone_type.cst_is_cell_phone = 'N' AND
	oncd_contact_phone.updated_by_user_code NOT IN ('WIRELESS_SCRUB')
END
GO
