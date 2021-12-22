/* CreateDate: 09/30/2013 10:50:18.520 , ModifyDate: 09/30/2013 10:50:18.520 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[psoWirelessScrubManual]
	@ScrubDirection	NCHAR(6),
	@UserCode		NCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CurrentDate		DATETIME
	SET		@CurrentDate		= dbo.CombineDates(GETDATE(), NULL)

	INSERT INTO cstd_wireless_scrub_history (scrub_date, scrub_type, scrub_direction, scrub_user_code)
	VALUES (@CurrentDate, 'MANUAL', @ScrubDirection, @UserCode)

	SELECT SCOPE_IDENTITY()
END
GO
