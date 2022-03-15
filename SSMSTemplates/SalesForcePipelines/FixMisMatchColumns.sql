DROP TABLE #temptable
GO
CREATE TABLE #temptable ( [FieldNum] int, [Field] nvarchar(max) )
INSERT INTO #temptable ([FieldNum], [Field])
VALUES
( 1, N'Id' ),
( 2, N'ParentId' ),
( 3, N'ActivityId' ),
( 4, N'CreatedById' ),
( 5, N'CreatedDate' ),
( 6, N'LastModifiedDate' ),
( 7, N'LastModifiedById' ),
( 8, N'SystemModstamp' ),
( 9, N'TextBody' ),
( 10, N'HtmlBody' ),
( 11, N'Headers' ),
( 12, N'Subject' ),
( 13, N'FromName' ),
( 14, N'FromAddress' ),
( 15, N'ValidatedFromAddress' ),
( 16, N'ToAddress' ),
( 17, N'CcAddress' ),
( 18, N'BccAddress' ),
( 19, N'Incoming' ),
( 20, N'HasAttachment' ),
( 21, N'Status' ),
( 22, N'MessageDate' ),
( 23, N'IsDeleted' ),
( 24, N'ReplyToEmailMessageId' ),
( 25, N'IsExternallyVisible' ),
( 26, N'MessageIdentifier' ),
( 27, N'ThreadIdentifier' ),
( 28, N'IsClientManaged' ),
( 29, N'RelatedToId' ),
( 30, N'IsTracked' ),
( 31, N'IsOpened' ),
( 32, N'FirstOpenedDate' ),
( 33, N'LastOpenedDate' ),
( 34, N'IsBounced' ),
( 35, N'EmailTemplateId' ),
( 36, N'ContentDocumentIds' ),
( 37, N'BccIds' ),
( 38, N'CcIds' ),
( 39, N'ToIds' )




IF OBJECT_ID('[tempdb]..[#Columns]') IS NOT NULL
    DROP TABLE [#Columns] ;

SELECT
    QUOTENAME([s].[name]) + '.' + QUOTENAME([t].[name]) AS [FQN]
  , [s].[name] AS [SchemaName]
  , [t].[name] AS [ObjectName]
  , [c].[name] AS [ColumnName]
  , [c].[column_id] AS [ColumnId]
  , [y].[name] AS [DataType]
  , [t].[type] AS [ObjectType]
  , CAST(CASE WHEN [y].[name] = 'timestamp' THEN 'rowversion'
             WHEN [y].[name] IN ('char', 'varchar') THEN
                 CONCAT(
                     [y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] AS VARCHAR)END, ')'
                   , CASE WHEN [c].[collation_name] <> [d].[collation_name] THEN CONCAT(' COLLATE ', [c].[collation_name])ELSE '' END)
             WHEN [y].[name] IN ('nchar', 'nvarchar') THEN
                 CONCAT(
                     [y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] / 2 AS VARCHAR)END, ')'
                   , CASE WHEN [c].[collation_name] <> [d].[collation_name] THEN CONCAT(' COLLATE ', [c].[collation_name])ELSE '' END)
             WHEN [y].[name] IN ('binary', 'varbinary') THEN
                 CONCAT([y].[name], '(', CASE WHEN [c].[max_length] = -1 THEN 'MAX' ELSE CAST([c].[max_length] AS VARCHAR)END, ')')
             WHEN [y].[name] IN ('bigint', 'int', 'smallint', 'tinyint') THEN [y].[name]
             WHEN [y].[name] IN ('datetime2', 'time', 'datetimeoffset') THEN CONCAT([y].[name], '(', [c].[scale], ')')
             WHEN [y].[name] IN ('numeric', 'decimal') THEN CONCAT([y].[name], '(', [c].[precision], ', ', [c].[scale], ')')
             ELSE [y].[name]
         END AS [VARCHAR](256)) AS [ColumnDef]
  , [c].[is_nullable]
  , [t].[create_date] AS [ObjectCreateDate]
  , [t].[modify_date] AS [ObjectModifyDate]
INTO [#Columns]
FROM [sys].[objects] AS [t]
INNER JOIN [sys].[schemas] AS [s] ON [s].[schema_id] = [t].[schema_id]
INNER JOIN [sys].[columns] AS [c] ON [c].[object_id] = [t].[object_id]
INNER JOIN [sys].[types] AS [y] ON [y].[user_type_id] = [c].[user_type_id]
LEFT JOIN [sys].[databases] AS [d] ON [d].[name] = DB_NAME() ;


SELECT
   [c].[SchemaName]
  , [c].[ObjectName]
  , [c].[ObjectType]
  , [c].[ColumnName]
  , [c].[ColumnId]
  , [c].[DataType]
  , [c].[ColumnDef]
  , [c].[is_nullable]
  ,t.*
  ,CASE WHEN ISNULL(c.columnname,'') <> ISNULL(t.field,'') THEN 1 END AS ismatch
FROM (SELECT * FROM [#Columns] AS [c] WHERE schemaname = 'SF' AND objectname = 'EmailMessage') c FULL OUTER JOIN #temptable t ON t.[FieldNum] = c.columnid

ORDER BY t.fieldnum
