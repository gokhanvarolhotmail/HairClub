/* CreateDate: 01/03/2013 10:22:39.293 , ModifyDate: 01/03/2013 10:22:39.293 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 30 October 2012
-- Description:	Implements the business rules associated with a Prank Result.
-- =============================================
CREATE PROCEDURE [dbo].[psoProcessPrankResult]
	@ContactId	NCHAR(10),	-- The Contact assigned to the Activity.
	@UserCode	NCHAR(20)	-- The User who completed the Activity.
AS
BEGIN
	SET NOCOUNT ON;

	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'OUTCALL', 'PRANK'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'BROCHCALL', 'PRANK'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'CANCELCALL', 'PRANK'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'NOSHOWCALL', 'PRANK'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'APPOINT', 'PRANK'
	EXEC psoCompleteContactActivities @ContactId, @UserCode, 'OUTSELECT', 'PRANK'

END
GO
