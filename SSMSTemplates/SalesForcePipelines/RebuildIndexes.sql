SELECT CONCAT('ALTER INDEX ', QUOTENAME([i].[name]), ' ON ', QUOTENAME([s].[name]), '.', QUOTENAME([t].[name]), ' REBUILD', CASE WHEN [s].[name] = 'SF' THEN ' WITH (DATA_COMPRESSION = ROW)' END, '
GO
')  AS [RebuildIndexes]
FROM [sys].[indexes] AS [i]
INNER JOIN [sys].[tables] AS [t] ON [t].[object_id] = [i].[object_id]
INNER JOIN [sys].[schemas] AS [s] ON [s].[schema_id] = [t].[schema_id]
WHERE [i].[index_id] = 1 ;
