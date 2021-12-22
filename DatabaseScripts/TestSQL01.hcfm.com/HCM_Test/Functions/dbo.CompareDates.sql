/* CreateDate: 08/18/2010 10:01:55.340 , ModifyDate: 08/18/2010 10:01:55.340 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2 August 2010
-- Description:	Returns -1 if the Left Date is after the Right Date.
--				Returns  0 if the Left Date is equal to the Right Date.
--				Returns  1 if the Left Date is before to the Right Date.
-- =============================================
CREATE FUNCTION dbo.CompareDates
(
	@LDate	DATETIME,
	@LTime	DATETIME,
	@LTimeZoneOffSet INT,
	@RDate	DATETIME,
	@RTime	DATETIME,
	@RTimeZoneOffSet INT
)
RETURNS INT
AS
BEGIN
	DECLARE @LDateTime DATETIME
	DECLARE @RDateTime DATETIME

	SET @LDateTime = dbo.CombineDates(@LDate, @LTime)

	IF (@LTime IS NOT NULL AND @LTimeZoneOffSet IS NOT NULL)
	BEGIN
		SET @LDateTime = DATEADD(HOUR, -@LTimeZoneOffSet, @LDateTime)
	END

	SET @RDateTime = dbo.CombineDates(@RDate, @RTime)

	IF (@RTime IS NOT NULL AND @RTimeZoneOffSet IS NOT NULL)
	BEGIN
		SET @RDateTime = DATEADD(HOUR, -@RTimeZoneOffSet, @RDateTime)
	END

	IF @LDateTime > @RDateTime
		RETURN -1

	IF @LDateTime < @RDateTime
		RETURN 1

	RETURN 0
END
GO
