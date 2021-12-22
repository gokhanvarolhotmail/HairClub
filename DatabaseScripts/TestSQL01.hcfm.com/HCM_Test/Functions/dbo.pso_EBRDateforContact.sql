/* CreateDate: 03/22/2016 11:02:44.380 , ModifyDate: 03/22/2016 11:29:10.360 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJW - Workwise, LLC
-- Create date: 2016-01-22
-- Description:	Derive EBR Date for given contact
--				Date of most recent client-initiated contact
-- =============================================
CREATE FUNCTION [dbo].[pso_EBRDateforContact]
(
	@contact_id nchar(10)
)
RETURNS datetime
AS
BEGIN
	DECLARE @EBRDate datetime

	SELECT TOP 1 @EBRDate = a.creation_date
	FROM oncd_activity a WITH (NOLOCK)
	INNER JOIN oncd_activity_contact ac WITH (NOLOCK) ON ac.activity_id = a.activity_id
		AND ((a.action_code IN ('INCALL','INHOUSE','BOSLEAD','BOSCLIENT')
			AND a.result_code IS NOT NULL
			AND a.result_code NOT IN ('WRNGNUM', 'PRANK', 'NOCALL', 'NOCONTACT', 'NOTEXT', 'MAINT'))
		OR a.result_code = 'SHOWNOSALE')
	WHERE ac.contact_id = @contact_id
	ORDER BY a.creation_date DESC

	RETURN  @EBRDate

END
GO
