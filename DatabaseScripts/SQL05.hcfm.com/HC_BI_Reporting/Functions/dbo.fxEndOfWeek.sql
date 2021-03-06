/* CreateDate: 07/12/2011 09:36:11.250 , ModifyDate: 07/12/2011 09:36:11.250 */
GO
CREATE FUNCTION [dbo].[fxEndOfWeek]
(
	@DATE DATETIME,
	@WEEK_START_DAY	INT	= 1
)
RETURNS	DATETIME
AS
BEGIN
	-- SUN = 2, MON = 3, TUE = 4, WED = 5
	-- THU = 6, FRI = 7
	-- DEFAULT TO SATURDAY

	DECLARE	 @END_OF_WEEK_DATE DATETIME
	DECLARE	 @FIRST_BOW	DATETIME
	DECLARE	 @LAST_EOW DATETIME

	-- CHECK FOR VALID DAY OF WEEK, AND RETURN NULL IF INVALID
	IF NOT @WEEK_START_DAY BETWEEN 1 AND 7 RETURN NULL

	-- FIND THE LAST END OF WEEK FOR THE PASSED DAY OF WEEK
	SELECT @LAST_EOW =CONVERT(DATETIME,2958457+((@WEEK_START_DAY+6)%7))

	-- RETURN NULL IF END OF WEEK FOR DATE PASSED IS AFTER 9999-12-31
	IF @DATE > @LAST_EOW RETURN NULL

	-- FIND THE FIRST VALID BEGINNING OF WEEK FOR THE DATE PASSED.
	SELECT @FIRST_BOW = CONVERT(DATETIME,-53690+((@WEEK_START_DAY+5)%7))

	-- IF DATE IS BEFORE THE FIRST BEGINNING OF WEEK FOR THE PASSED DAY OF WEEK
	-- RETURN THE DAY BEFORE THE FIRST BEGINNING OF WEEK
	IF @DATE < @FIRST_BOW
		BEGIN
			SET @END_OF_WEEK_DATE = DATEADD(DD,-1,@FIRST_BOW)
			RETURN @END_OF_WEEK_DATE
		END

	-- FIND END OF WEEK FOR THE NORMAL CASE AS 6 DAYS AFTER THE BEGINNING OF WEEK
	SELECT @END_OF_WEEK_DATE =
		DATEADD(DD,((DATEDIFF(DD,@FIRST_BOW,@DATE)/7)*7)+6,@FIRST_BOW)

	RETURN @END_OF_WEEK_DATE
END
GO
