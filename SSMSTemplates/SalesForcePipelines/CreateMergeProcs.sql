SELECT
    [k].*
  , CONCAT(CAST(NULL AS VARCHAR(MAX)), 'IF OBJECT_ID(''', [k].[ProcedureName], ''') IS NOT NULL DROP PROCEDURE ', [k].[ProcedureName], '
GO
CREATE PROCEDURE ', [k].[ProcedureName], '
	@ROWCOUNT BIGINT = NULL OUTPUT
AS
SET NOCOUNT ON

SET @ROWCOUNT = 0

IF NOT EXISTS(SELECT 1 FROM ', QUOTENAME([k].[SchemaName] + 'Staging'), '.', QUOTENAME([k].[TableName]), ')
RETURN ;

SET XACT_ABORT ON

BEGIN TRANSACTION

;MERGE ', QUOTENAME([k].[SchemaName]), '.', QUOTENAME([k].[TableName]), ' AS [t]
USING ', QUOTENAME([k].[SchemaName] + 'Staging'), '.', QUOTENAME([k].[TableName]), ' AS [s]
	ON [t].', QUOTENAME([k].[PrimaryKeyName]), ' = [s].', QUOTENAME([k].[PrimaryKeyName]), '
WHEN MATCHED THEN
	UPDATE SET
	', [k].[UpdateCols], '
WHEN NOT MATCHED THEN
	INSERT(
	', [k].[InsertTop], '
	)
	VALUES(
	', [k].[InsertBottom], '
	)
OPTION(RECOMPILE) ;

SET @ROWCOUNT = @@ROWCOUNT ;

TRUNCATE TABLE [', [k].[SchemaName], 'Staging].', QUOTENAME([k].[TableName]), ' ;

COMMIT ;
GO
') AS [MergeProcedure]
FROM( SELECT
          [s].[name] AS [SchemaName]
        , [t].[name] AS [TableName]
        , [ic].[name] AS [PrimaryKeyName]
        , [mc].[UpdateCols]
        , [mc].[InsertTop]
        , [mc].[InsertBottom]
        , QUOTENAME([s].[name]) + '.' + QUOTENAME('sp_' + [t].[name] + '_Merge') AS [ProcedureName]
      FROM [sys].[tables] AS [t]
      INNER JOIN [sys].[schemas] AS [s] ON [t].[schema_id] = [s].[schema_id]
      OUTER APPLY( SELECT
                       [c].[name]
                     , [c].[column_id]
                   FROM [sys].[indexes] AS [i]
                   INNER JOIN [sys].[index_columns] AS [ic] ON [ic].[object_id] = [i].[object_id] AND [ic].[index_id] = [i].[index_id]
                   INNER JOIN [sys].[columns] AS [c] ON [c].[object_id] = [t].[object_id] AND [c].[column_id] = [ic].[column_id]
                   WHERE [i].[object_id] = [t].[object_id] AND [ic].[key_ordinal] = 1 AND [i].[is_primary_key] = 1 ) AS [ic]
      OUTER APPLY( SELECT
                       STUFF(( SELECT CONCAT('
	, [t].', QUOTENAME([c].[name]), ' = [t].', QUOTENAME([c].[name]))
                               FROM [sys].[columns] AS [c]
                               WHERE [c].[object_id] = [t].[object_id] AND [c].[column_id] <> [ic].[column_id]
                               ORDER BY [c].[column_id]
                             FOR XML PATH(N''), TYPE ).[value](N'.', N'NVARCHAR(MAX)'), 1, 5, '') AS [UpdateCols]
                     , STUFF(( SELECT CONCAT('
	, ', QUOTENAME([c].[name]))
                               FROM [sys].[columns] AS [c]
                               WHERE [c].[object_id] = [t].[object_id] AND [c].[column_id] <> [ic].[column_id]
                               ORDER BY [c].[column_id]
                             FOR XML PATH(N''), TYPE ).[value](N'.', N'NVARCHAR(MAX)'), 1, 5, '') AS [InsertTop]
                     , STUFF(( SELECT CONCAT('
	, [s].', QUOTENAME([c].[name]))
                               FROM [sys].[columns] AS [c]
                               WHERE [c].[object_id] = [t].[object_id] AND [c].[column_id] <> [ic].[column_id]
                               ORDER BY [c].[column_id]
                             FOR XML PATH(N''), TYPE ).[value](N'.', N'NVARCHAR(MAX)'), 1, 5, '') AS [InsertBottom] ) AS [mc]
      WHERE [s].[name] = 'SF' ) AS [k] ;
GO
