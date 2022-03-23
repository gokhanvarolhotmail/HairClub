/* CreateDate: 03/18/2022 13:53:19.653 , ModifyDate: 03/18/2022 13:53:19.653 */
GO
CREATE FUNCTION [GetUTCFromLocalInline]( @MyDate DATETIME, @UTCOffSet INT, @UseDayLightSavings BIT )
RETURNS TABLE
AS
RETURN SELECT CAST(DATEADD(HOUR, CASE WHEN @UseDayLightSavings = 1 AND @MyDate >= [k].[DSTStart] AND @MyDate < [k].[DSTEnd] THEN @UTCOffSet + 1 ELSE @UTCOffSet END * -1, @MyDate) AS DATETIME) AS [OutVal]
       FROM( SELECT [DS].[DSTStartDate] AS [DSTStart], [DS].[DSTEndDate] AS [DSTEnd] FROM [dbo].[lkpDaylightSavings] AS [DS] WHERE [DS].[Year] = DATEPART(YEAR, @MyDate)) AS [k] ;
GO
