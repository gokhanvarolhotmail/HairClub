/* CreateDate: 02/09/2022 11:04:44.500 , ModifyDate: 02/09/2022 11:04:44.500 */
GO
CREATE FUNCTION [dbo].[GetDates]( @low AS DATE, @high AS DATE )
RETURNS TABLE
AS
RETURN
SELECT TOP( DATEDIFF(DAY, @low, @high) + 1 )
       [Nums].[RowNum]
     , DATEADD(DAY, [Nums].[RowNum] - 1, @low) AS [dt]
     , DATEADD(DAY, [Nums].[RowNum], @low) AS [dt2]
FROM( SELECT ROW_NUMBER() OVER ( ORDER BY( SELECT 0 )) AS [RowNum]
      FROM( SELECT 1 AS [Num]
            UNION ALL
            SELECT 2
            UNION ALL
            SELECT 3
            UNION ALL
            SELECT 4
            UNION ALL
            SELECT 5
            UNION ALL
            SELECT 6
            UNION ALL
            SELECT 7
            UNION ALL
            SELECT 8
            UNION ALL
            SELECT 9
            UNION ALL
            SELECT 10
            UNION ALL
            SELECT 11
            UNION ALL
            SELECT 12
            UNION ALL
            SELECT 13
            UNION ALL
            SELECT 14
            UNION ALL
            SELECT 15
            UNION ALL
            SELECT 16 ) AS [a]
      CROSS JOIN( SELECT 1 AS [Num]
                  UNION ALL
                  SELECT 2
                  UNION ALL
                  SELECT 3
                  UNION ALL
                  SELECT 4
                  UNION ALL
                  SELECT 5
                  UNION ALL
                  SELECT 6
                  UNION ALL
                  SELECT 7
                  UNION ALL
                  SELECT 8
                  UNION ALL
                  SELECT 9
                  UNION ALL
                  SELECT 10
                  UNION ALL
                  SELECT 11
                  UNION ALL
                  SELECT 12
                  UNION ALL
                  SELECT 13
                  UNION ALL
                  SELECT 14
                  UNION ALL
                  SELECT 15
                  UNION ALL
                  SELECT 16 ) AS [b]
      CROSS JOIN( SELECT 1 AS [Num]
                  UNION ALL
                  SELECT 2
                  UNION ALL
                  SELECT 3
                  UNION ALL
                  SELECT 4
                  UNION ALL
                  SELECT 5
                  UNION ALL
                  SELECT 6
                  UNION ALL
                  SELECT 7
                  UNION ALL
                  SELECT 8
                  UNION ALL
                  SELECT 9
                  UNION ALL
                  SELECT 10
                  UNION ALL
                  SELECT 11
                  UNION ALL
                  SELECT 12
                  UNION ALL
                  SELECT 13
                  UNION ALL
                  SELECT 14
                  UNION ALL
                  SELECT 15
                  UNION ALL
                  SELECT 16 ) AS [d]
      CROSS JOIN( SELECT 1 AS [Num]
                  UNION ALL
                  SELECT 2
                  UNION ALL
                  SELECT 3
                  UNION ALL
                  SELECT 4
                  UNION ALL
                  SELECT 5
                  UNION ALL
                  SELECT 6
                  UNION ALL
                  SELECT 7
                  UNION ALL
                  SELECT 8
                  UNION ALL
                  SELECT 9
                  UNION ALL
                  SELECT 10
                  UNION ALL
                  SELECT 11
                  UNION ALL
                  SELECT 12
                  UNION ALL
                  SELECT 13
                  UNION ALL
                  SELECT 14
                  UNION ALL
                  SELECT 15
                  UNION ALL
                  SELECT 16 ) AS [e]
      CROSS JOIN( SELECT 1 AS [Num]
                  UNION ALL
                  SELECT 2
                  UNION ALL
                  SELECT 3
                  UNION ALL
                  SELECT 4
                  UNION ALL
                  SELECT 5
                  UNION ALL
                  SELECT 6
                  UNION ALL
                  SELECT 7
                  UNION ALL
                  SELECT 8
                  UNION ALL
                  SELECT 9
                  UNION ALL
                  SELECT 10
                  UNION ALL
                  SELECT 11
                  UNION ALL
                  SELECT 12
                  UNION ALL
                  SELECT 13
                  UNION ALL
                  SELECT 14
                  UNION ALL
                  SELECT 15
                  UNION ALL
                  SELECT 16 ) AS [f] ) AS [Nums]
ORDER BY [Nums].[RowNum] ;
GO
