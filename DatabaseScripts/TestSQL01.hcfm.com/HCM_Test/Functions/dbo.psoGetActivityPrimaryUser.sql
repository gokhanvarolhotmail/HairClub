/* CreateDate: 01/03/2013 10:22:38.787 , ModifyDate: 01/03/2013 10:22:38.787 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[psoGetActivityPrimaryUser]
(
@ActivityId NCHAR(10)
)
RETURNS NCHAR(10)
AS
BEGIN
	DECLARE @UserCode NCHAR(10)

	SELECT TOP 1
	@UserCode = user_code
	FROM oncd_activity_user
	WHERE
	activity_id = @ActivityId AND
	primary_flag = 'Y'

	RETURN @UserCode
END
GO
