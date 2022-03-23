/* CreateDate: 03/16/2022 17:44:39.307 , ModifyDate: 03/16/2022 17:44:39.307 */
GO
CREATE FUNCTION [dbo].[GetLocalFromUTCInline]( @MyDate DATETIME, @UTCOffSet INT, @UseDayLightSavings BIT )
RETURNS TABLE
AS
RETURN

SELECT CAST(CASE WHEN @UseDayLightSavings = 1 AND [k].[Local] >= [k].[DSTStart] AND [k].[Local] < [k].[DSTEnd] THEN DATEADD(HOUR, 1, [k].[Local])ELSE [k].[Local] END AS DATETIME) AS [OutVal]
FROM( SELECT
          [DS].[DSTStartDate] AS [DSTStart]
        , [DS].[DSTEndDate] AS [DSTEnd]
        , DATEADD(HOUR, @UTCOffSet, @MyDate) AS [Local]
      FROM [dbo].[lkpDaylightSavings] AS [DS]
      WHERE [DS].[Year] = DATEPART(YEAR, @MyDate)) AS [k] ;
GO
