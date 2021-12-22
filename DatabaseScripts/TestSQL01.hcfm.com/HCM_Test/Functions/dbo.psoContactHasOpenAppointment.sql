/* CreateDate: 01/03/2013 10:22:39.230 , ModifyDate: 01/03/2013 10:22:39.230 */
GO
-- =============================================
-- Create date: 30 October 2012
-- Description:	Determines if the Contact has an open Appointment Activity.
-- =============================================
CREATE FUNCTION [dbo].[psoContactHasOpenAppointment]
(
	@ContactId NCHAR(10)
)
RETURNS NCHAR(1)
AS
BEGIN
	DECLARE @HasOpenAppointment NCHAR(1)

	IF(	SELECT COUNT(*)
		FROM oncd_activity
		INNER JOIN oncd_activity_contact ON
			oncd_activity_contact.contact_id = @ContactId AND
			oncd_activity.activity_id = oncd_activity_contact.activity_id AND
			oncd_activity_contact.primary_flag = 'Y'
		WHERE
		oncd_activity.action_code = 'APPOINT' AND
		oncd_activity.result_code IS NULL) > 0
	BEGIN
		SET @HasOpenAppointment = 'Y'
	END
	ELSE
	BEGIN
		SET @HasOpenAppointment = 'N'
	END

	-- Return the result of the function
	RETURN @HasOpenAppointment

END
GO
