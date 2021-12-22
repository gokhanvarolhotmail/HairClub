/* CreateDate: 09/30/2013 10:51:24.480 , ModifyDate: 09/30/2013 10:51:24.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[psoWirelessScrubDailyImport]
	@WirelessHistoryId INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CurrentDate		DATETIME
	DECLARE @ScrubDate			DATETIME

	SET		@CurrentDate		= dbo.CombineDates(GETDATE(), NULL)

	INSERT INTO cstd_wireless_scrub_history (scrub_date, scrub_type, scrub_direction, scrub_user_code)
	VALUES (@CurrentDate, 'DAILY', 'IMPORT', 'WIRELESS_SCRUB')

	SET @WirelessHistoryId = SCOPE_IDENTITY()
END
GO
