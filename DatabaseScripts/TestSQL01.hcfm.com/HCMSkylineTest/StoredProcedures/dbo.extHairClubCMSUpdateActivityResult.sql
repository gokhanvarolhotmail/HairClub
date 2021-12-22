/* CreateDate: 10/28/2015 11:20:16.083 , ModifyDate: 10/28/2015 11:20:16.083 */
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

		UPDATE OnContact_oncd_activity_Table SET
				result_code = @ResultCode,
				completed_by_user_code = @CompletedByUserCode,
				completion_date = CAST(CONVERT(varchar(11),  GETDATE(),  101) AS datetime),
				completion_time = CAST(CONVERT(TIME,GETDATE()) AS DateTime)
		WHERE activity_id = @ActivityID

END
GO
