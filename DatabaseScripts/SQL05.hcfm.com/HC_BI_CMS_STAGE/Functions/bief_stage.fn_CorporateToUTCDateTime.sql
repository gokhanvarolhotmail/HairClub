/* CreateDate: 12/18/2012 13:05:35.267 , ModifyDate: 11/09/2016 11:58:35.123 */
GO
CREATE FUNCTION [bief_stage].[fn_CorporateToUTCDateTime] (@LocalDateTime AS DATETIME)
-----------------------------------------------------------------------
-- [fn_CorporateToUTCDateTime] Takes in a corporate (ET) date and returns it as UTC Date and Time
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  EKnapp     Initial Creation
-- DayLightSavings Rules:
-- Currently begins at 2:00 a.m. on the second Sunday of March and
-- ends at 2:00 a.m. on the first Sunday of November
--
-----------------------------------------------------------------------
RETURNS DATETIME AS
BEGIN
	DECLARE @LocalToUTCDate DATETIME

    SELECT @LocalToUTCDate = bief_stage.GetUTCFromLocal(@LocalDateTime, -5, 1)

	RETURN @LocalToUTCDate
END
GO
