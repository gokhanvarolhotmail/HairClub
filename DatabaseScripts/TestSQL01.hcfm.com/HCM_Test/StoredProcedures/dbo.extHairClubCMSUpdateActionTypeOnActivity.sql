/* CreateDate: 07/15/2015 19:27:06.047 , ModifyDate: 08/03/2015 18:33:21.987 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSUpdateActionTypeOnActivity
DESTINATION SERVER:		SQL03
DESTINATION DATABASE:	HCM
AUTHOR:					Mike Tovbin
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/15/2015
------------------------------------------------------------------------
NOTES:

07/15/2015 - MT - Created
07/28/2015 - MT - Added logic to also update Description
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHairClubCMSUpdateActionTypeOnActivity
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSUpdateActionTypeOnActivity]
(
	@ActivityID varchar(25),
    @ActionCode varchar(50)
)
AS
BEGIN

	UPDATE a SET
		action_code = @ActionCode,
		[description] = act.[description]
	FROM [dbo].[oncd_activity] a
			INNER JOIN onca_action act ON LTRIM(RTRIM(act.action_code)) = LTRIM(RTRIM(@ActionCode))
	WHERE activity_id = @ActivityID

END
GO
