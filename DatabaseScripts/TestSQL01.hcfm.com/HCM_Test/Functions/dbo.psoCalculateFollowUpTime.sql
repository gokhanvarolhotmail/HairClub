/* CreateDate: 01/03/2013 10:22:38.800 , ModifyDate: 01/03/2013 10:22:38.800 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 30 October 2012
-- Description:	Calculates the follow up time based on the type and amount to add to the time.
-- =============================================
CREATE FUNCTION [dbo].[psoCalculateFollowUpTime]
(
	@Type NCHAR(10),	-- The type of time to add.
	@Amount INT,		-- The amount of time to add.
	@Time DATETIME		-- The time that is being increased.
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @FollowUpTime DATETIME

	IF (@Type = 'mi')
		SET @FollowUpTime = DATEADD(mi, @Amount, @Time)
	ELSE IF @Type = 'hh'
		SET @FollowUpTime = DATEADD(hh, @Amount, @Time)
	ELSE IF @Type = 'dd'
		SET @FollowUpTime = DATEADD(dd, @Amount, @Time)
	ELSE IF @Type = 'wk'
		SET @FollowUpTime = DATEADD(wk, @Amount, @Time)
	ELSE IF @Type = 'mm'
		SET @FollowUpTime = DATEADD(mm, @Amount, @Time)
	ELSE IF @Type = 'yy'
		SET @FollowUpTime = DATEADD(yy, @Amount, @Time)

	RETURN @FollowUpTime

END
GO
