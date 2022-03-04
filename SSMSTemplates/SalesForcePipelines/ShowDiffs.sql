
--IF OBJECT_ID('tempdb..#temp1') IS NOT NULL DROP TABLE #temp1
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL
    DROP TABLE [#temp2] ;

SELECT
    QUOTENAME([s].[name]) + '.' + QUOTENAME([t].[name]) AS [FQN]
  , [p].[rows]
INTO [#temp2]
FROM [sys].[tables] AS [t]
INNER JOIN [sys].[schemas] AS [s] ON [s].[schema_id] = [t].[schema_id]
INNER JOIN [sys].[partitions] AS [p] ON [p].[object_id] = [t].[object_id] AND [p].[index_id] <= 1
WHERE [s].[name] IN ('sf', 'sfstaging')
ORDER BY 1 ;

IF OBJECT_ID('tempdb..#temp1') IS NULL
    BEGIN
        SELECT *
        INTO [#temp1]
        FROM [#temp2] ;
    END ;
ELSE
    BEGIN
        SELECT
            DATEDIFF(SECOND, [tb].[create_date], GETDATE()) AS [DurationSec]
          , ISNULL([a].[FQN], [b].[FQN]) AS [name]
          , [a].[rows] AS [PreviousRows]
          , [b].[rows] AS [CurrentRows]
          , ISNULL([b].[rows], 0) - ISNULL([a].[rows], 0) AS [RowsDiff]
        FROM [#temp1] AS [a]
        INNER JOIN [tempdb].[sys].[tables] AS [tb] ON [tb].[object_id] = OBJECT_ID('[tempdb]..[#temp1]')
        FULL OUTER JOIN [#temp2] AS [b] ON [a].[FQN] = [b].[FQN]
        ORDER BY ABS(ISNULL([b].[rows], 0) - ISNULL([a].[rows], 0)) DESC
               , ISNULL([a].[FQN], [b].[FQN]) ;
    END ;