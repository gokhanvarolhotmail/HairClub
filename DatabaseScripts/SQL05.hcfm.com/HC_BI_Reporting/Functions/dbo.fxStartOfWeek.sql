/* CreateDate: 07/12/2011 09:35:47.937 , ModifyDate: 07/12/2011 09:35:47.937 */
GO
CREATE FUNCTION [dbo].[fxStartOfWeek]
(
	@DATE DATETIME,
	@WEEK_START_DAY	INT	= 1
)
RETURNS	DATETIME
AS
BEGIN
	-- SUN = 1, MON = 2, TUE = 3, WED = 4
	-- THU = 5, FRI = 6, SAT = 7
	-- DEFAULT TO SUNDAY

	DECLARE	 @START_OF_WEEK_DATE DATETIME
	DECLARE	 @FIRST_BOW DATETIME

	-- CHECK FOR VALID DAY OF WEEK
	IF @WEEK_START_DAY BETWEEN 1 AND 7
		BEGIN
			-- FIND FIRST DAY ON OR AFTER 1753/1/1 (-53690)
			-- MATCHING DAY OF WEEK OF @WEEK_START_DAY
			-- 1753/1/1 IS EARLIEST POSSIBLE SQL SERVER DATE.
			SELECT @FIRST_BOW = CONVERT(DATETIME,-53690 + ((@WEEK_START_DAY + 5) %7))

			-- VERIFY BEGINNING OF WEEK NOT BEFORE 1753/1/1
			IF @DATE >= @FIRST_BOW
				BEGIN
					SELECT @START_OF_WEEK_DATE =
						DATEADD(DD,(DATEDIFF(DD,@FIRST_BOW,@DATE)/7)*7,@FIRST_BOW)
				END
		END

	RETURN @START_OF_WEEK_DATE
END
GO