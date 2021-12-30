/* CreateDate: 10/27/2011 15:23:29.467 , ModifyDate: 10/27/2011 15:24:45.470 */
GO
CREATE    FUNCTION [bi_health].[fnHC_ConvertAgentHistoryDateTimes] (@DateInt int, @TimeInt int)
-----------------------------------------------------------------------
-- [fnHC_ConvertAgentHistoryDateTimes]
--
--SELECT [bi_health].[fnHC_ConvertAgentHistoryDateTimes](20111027, 83500)
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-25-11  EKnapp       Initial Creation
-----------------------------------------------------------------------

RETURNS DateTime
BEGIN

		DECLARE	 @DT				datetime

		SET @DT  = CAST(STR(@DateInt, 8, 0) AS DATETIME) +
				CAST(STUFF(STUFF(STR(@TimeInt, 6, 0), 3, 0, ':'), 6, 0, ':') AS DATETIME)

RETURN @dt
END
GO
