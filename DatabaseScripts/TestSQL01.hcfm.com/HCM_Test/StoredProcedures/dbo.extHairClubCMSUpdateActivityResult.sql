/* CreateDate: 10/28/2015 11:29:03.410 , ModifyDate: 10/28/2015 11:29:03.410 */
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSUpdateActivityResult
DESTINATION SERVER:		SQL03
DESTINATION DATABASE:	HCM
AUTHOR:					Mike Tovbin
IMPLEMENTOR:			Mike Tovbin
DATE IMPLEMENTED:		10/28/2015
------------------------------------------------------------------------
NOTES:

10/28/2015 - MT - Created
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHairClubCMSUpdateActivityResult
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSUpdateActivityResult]
(
	@ActivityID varchar(25),
    @ResultCode varchar(50),
	@CompletedByUserCode varchar(25)
)
AS
BEGIN

		UPDATE oncd_activity SET
				result_code = @ResultCode,
				completed_by_user_code = @CompletedByUserCode,
				completion_date = CAST(CONVERT(varchar(11),  GETDATE(),  101) AS datetime),
				completion_time = CAST(CONVERT(TIME,GETDATE()) AS DateTime)
		WHERE activity_id = @ActivityID

END
GO
