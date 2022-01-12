USE [master]
GO
ALTER FUNCTION [dbo].[sp_GetNumbers]( @StartVal INT, @EndVal INT )
RETURNS @Digits TABLE( [digit] INT )
AS
    BEGIN
        ;
        WITH [N0]
        AS ( SELECT [ddata].[n]
             FROM( VALUES( 1 )
                       , ( 2 )
                       , ( 3 )
                       , ( 4 )
                       , ( 5 )
                       , ( 6 )
                       , ( 7 )
                       , ( 8 )
                       , ( 9 )
                       , ( 10 )
                       , ( 11 )
                       , ( 12 )
                       , ( 13 )
                       , ( 14 )
                       , ( 15 )
                       , ( 16 )
                       , ( 17 )
                       , ( 18 )
                       , ( 19 )
                       , ( 20 )
                       , ( 21 )
                       , ( 22 )
                       , ( 23 )
                       , ( 24 )
                       , ( 25 )
                       , ( 26 )
                       , ( 27 )
                       , ( 28 )
                       , ( 29 )
                       , ( 30 )
                       , ( 31 )
                       , ( 32 )
                       , ( 33 )
                       , ( 34 )
                       , ( 35 )
                       , ( 36 )
                       , ( 37 )
                       , ( 38 )
                       , ( 39 )
                       , ( 40 )
                       , ( 41 )
                       , ( 42 )
                       , ( 43 )
                       , ( 44 )
                       , ( 45 )
                       , ( 46 )
                       , ( 47 )
                       , ( 48 )
                       , ( 49 )
                       , ( 50 )
                       , ( 51 )
                       , ( 52 )
                       , ( 53 )
                       , ( 54 )
                       , ( 55 )
                       , ( 56 )
                       , ( 57 )
                       , ( 58 )
                       , ( 59 )
                       , ( 60 )
                       , ( 61 )
                       , ( 62 )
                       , ( 63 )
                       , ( 64 )
                       , ( 65 )
                       , ( 66 )
                       , ( 67 )
                       , ( 68 )
                       , ( 69 )
                       , ( 70 )
                       , ( 71 )
                       , ( 72 )
                       , ( 73 )
                       , ( 74 )
                       , ( 75 )
                       , ( 76 )
                       , ( 77 )
                       , ( 78 )
                       , ( 79 )
                       , ( 80 )
                       , ( 81 )
                       , ( 82 )
                       , ( 83 )
                       , ( 84 )
                       , ( 85 )
                       , ( 86 )
                       , ( 87 )
                       , ( 88 )
                       , ( 89 )
                       , ( 90 )
                       , ( 91 )
                       , ( 92 )
                       , ( 93 )
                       , ( 94 )
                       , ( 95 )
                       , ( 96 )
                       , ( 97 )
                       , ( 98 )
                       , ( 99 )
                       , ( 100 )
                       , ( 101 )
                       , ( 102 )
                       , ( 103 )
                       , ( 104 )
                       , ( 105 )
                       , ( 106 )
                       , ( 107 )
                       , ( 108 )
                       , ( 109 )
                       , ( 110 )
                       , ( 111 )
                       , ( 112 )
                       , ( 113 )
                       , ( 114 )
                       , ( 115 )
                       , ( 116 )
                       , ( 117 )
                       , ( 118 )
                       , ( 119 )
                       , ( 120 )
                       , ( 121 )
                       , ( 122 )
                       , ( 123 )
                       , ( 124 )
                       , ( 125 )
                       , ( 126 )
                       , ( 127 )
                       , ( 128 )
                       , ( 129 )
                       , ( 130 )
                       , ( 131 )
                       , ( 132 )
                       , ( 133 )
                       , ( 134 )
                       , ( 135 )
                       , ( 136 )
                       , ( 137 )
                       , ( 138 )
                       , ( 139 )
                       , ( 140 )
                       , ( 141 )
                       , ( 142 )
                       , ( 143 )
                       , ( 144 )
                       , ( 145 )
                       , ( 146 )
                       , ( 147 )
                       , ( 148 )
                       , ( 149 )
                       , ( 150 )
                       , ( 151 )
                       , ( 152 )
                       , ( 153 )
                       , ( 154 )
                       , ( 155 )
                       , ( 156 )
                       , ( 157 )
                       , ( 158 )
                       , ( 159 )
                       , ( 160 )
                       , ( 161 )
                       , ( 162 )
                       , ( 163 )
                       , ( 164 )
                       , ( 165 )
                       , ( 166 )
                       , ( 167 )
                       , ( 168 )
                       , ( 169 )
                       , ( 170 )
                       , ( 171 )
                       , ( 172 )
                       , ( 173 )
                       , ( 174 )
                       , ( 175 )
                       , ( 176 )
                       , ( 177 )
                       , ( 178 )
                       , ( 179 )
                       , ( 180 )
                       , ( 181 )
                       , ( 182 )
                       , ( 183 )
                       , ( 184 )
                       , ( 185 )
                       , ( 186 )
                       , ( 187 )
                       , ( 188 )
                       , ( 189 )
                       , ( 190 )
                       , ( 191 )
                       , ( 192 )
                       , ( 193 )
                       , ( 194 )
                       , ( 195 )
                       , ( 196 )
                       , ( 197 )
                       , ( 198 )
                       , ( 199 )
                       , ( 200 )
                       , ( 201 )
                       , ( 202 )
                       , ( 203 )
                       , ( 204 )
                       , ( 205 )
                       , ( 206 )
                       , ( 207 )
                       , ( 208 )
                       , ( 209 )
                       , ( 210 )
                       , ( 211 )
                       , ( 212 )
                       , ( 213 )
                       , ( 214 )
                       , ( 215 )
                       , ( 216 )
                       , ( 217 )
                       , ( 218 )
                       , ( 219 )
                       , ( 220 )
                       , ( 221 )
                       , ( 222 )
                       , ( 223 )
                       , ( 224 )
                       , ( 225 )
                       , ( 226 )
                       , ( 227 )
                       , ( 228 )
                       , ( 229 )
                       , ( 230 )
                       , ( 231 )
                       , ( 232 )
                       , ( 233 )
                       , ( 234 )
                       , ( 235 )
                       , ( 236 )
                       , ( 237 )
                       , ( 238 )
                       , ( 239 )
                       , ( 240 )
                       , ( 241 )
                       , ( 242 )
                       , ( 243 )
                       , ( 244 )
                       , ( 245 )
                       , ( 246 )
                       , ( 247 )
                       , ( 248 )
                       , ( 249 )
                       , ( 250 )
                       , ( 251 )
                       , ( 252 )
                       , ( 253 )
                       , ( 254 )
                       , ( 255 )
                       , ( 256 )) AS [ddata]( [n] ) )
           , [N1]
        AS ( SELECT 1 AS [n] FROM [N0] AS [A] CROSS JOIN [N0] AS [B] )
           , [N2]
        AS ( SELECT 1 AS [n] FROM [N1] AS [A] CROSS JOIN [N1] AS [B] )
           , [Nums]( [n] )
        AS ( SELECT ROW_NUMBER() OVER ( ORDER BY [N2].[n] )FROM [N2] )
        INSERT @Digits( [digit] )
        SELECT [Nums].[n] + @StartVal - 1 AS [Digit]
        FROM [Nums]
        WHERE [Nums].[n] BETWEEN 1 AND ( @EndVal - @StartVal + 1 ) ;

        RETURN ;
    END ;
GO
ALTER PROCEDURE [dbo].[sp_Values]
    @Input           NVARCHAR(MAX) = NULL
  , @Chunk           INT           = NULL
  , @ColumnDelimiter NVARCHAR(1) = NULL
  , @RowDelimiter    NVARCHAR(MAX) = NULL
  , @Output          NVARCHAR(MAX) = NULL OUTPUT
AS
SET NOCOUNT ON ;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;

DECLARE
    @AzureDatabase    BIT = CASE WHEN SERVERPROPERTY('EngineEdition') IN (5 /*SQL Database*/, 6 /*Microsoft Azure Synapse Analytics*/) THEN 1 ELSE 0 END
  , @QuotedIdentifier BIT = 1
  

IF NULLIF(@Input, '') IS NULL
    BEGIN
        PRINT 'EXEC [sp_Values]
	@Input = NULL
	,@Chunk = NULL
	,@ColumnDelimiter = NULL
	,@RowDelimiter = NULL
	,@Output = NULL /*OUTPUT*/
'       ;
    END ;

IF @ColumnDelimiter = CHAR(9) AND CHARINDEX(CHAR(9), @Input) = 0 AND CHARINDEX(',', @Input) > 0
    SET @ColumnDelimiter = ',' ;

DECLARE
    @NewLine         NVARCHAR(MAX) = CHAR(13) + CHAR(10)
  , @CommaAndNewLine NVARCHAR(400) = N',' + CHAR(13) + CHAR(10)
  , @NVarcharMAX     NVARCHAR(MAX) = N'' ;


SELECT
    @ColumnDelimiter = ISNULL(NULLIF(@ColumnDelimiter, ''), CHAR(9))
  , @RowDelimiter = ISNULL(NULLIF(@RowDelimiter, ''), @NewLine)
  , @Chunk = CASE WHEN @Chunk > 0 THEN @Chunk END
  , @Output = '' ;

DECLARE @RowDelimiter_2 NVARCHAR(1) = CASE WHEN @RowDelimiter = @NewLine THEN CHAR(10) ELSE @RowDelimiter END
  
SET @RowDelimiter = CASE WHEN @RowDelimiter = @NewLine AND CHARINDEX(@RowDelimiter, @Input) = 0 THEN CHAR(10)ELSE @RowDelimiter END ;

IF @RowDelimiter = @NewLine
SET @Input = REPLACE(@Input,@NewLine,CHAR(10))

IF OBJECT_ID('tempdb..#Rows') IS NOT NULL
    DROP TABLE [#Rows] ;

SELECT
    [k].[RowNum]
  , CASE WHEN @Chunk IS NULL THEN 1 ELSE [k].[RowNum] / @Chunk + 1 END AS [Chunk]
  , [k].[Field]
INTO [#Rows]
FROM( SELECT ROW_NUMBER() OVER ( ORDER BY (SELECT 0) ) AS [RowNum], [Value] AS [Field] FROM STRING_SPLIT(@Input, @RowDelimiter_2) WHERE [Value] <> '' ) AS [k] ;

DECLARE @RowCount INT = @@ROWCOUNT - 1 ;

CREATE UNIQUE CLUSTERED INDEX [RowNum] ON [#Rows]( [RowNum] ) ;

DECLARE @ColCnt INT ;

SELECT @ColCnt = LEN([Field] + ']') - LEN(REPLACE([Field] + ']', @ColumnDelimiter, '')) + 1
FROM [#Rows]
WHERE [RowNum] = 1 ;

-- Column names can contain any valid characters (for example, spaces). If column names contain any characters except letters, numbers, and underscores, the name must be delimited by enclosing it in back quotes (`).
IF OBJECT_ID('tempdb..#FieldLimit') IS NOT NULL
    DROP TABLE [#FieldLimit] ;

SELECT [digit] AS [FieldNum]
INTO [#FieldLimit]
FROM [master].[dbo].[sp_GetNumbers](1, @ColCnt) ;

CREATE UNIQUE CLUSTERED INDEX [FieldNum] ON [#FieldLimit]( [FieldNum] ) ;

IF OBJECT_ID('tempdb..#Data') IS NOT NULL
    DROP TABLE [#Data] ;

SELECT
    [t].[RowNum]
  , [t].[Chunk]
  , [b].[FieldNum] AS [ColumnId]
  , [b].[Field]
INTO [#Data]
FROM [#Rows] AS [t]
CROSS APPLY( SELECT
                 [a].[FieldNum]
               , [b].[Field]
             FROM [#FieldLimit] AS [a]
             LEFT JOIN ( SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 0)) AS [FieldNum], [Value] AS [Field] FROM STRING_SPLIT([t].[Field], @ColumnDelimiter)) AS [b] ON [a].[FieldNum] = [b].[FieldNum] ) AS [b] ;

CREATE UNIQUE CLUSTERED INDEX [Cls] ON [#Data]( [RowNum], [ColumnId] ) ;

IF OBJECT_ID('tempdb..#Types') IS NOT NULL
    DROP TABLE [#Types] ;

SELECT
    [b].[ColumnId]
  , CASE WHEN @RowCount = SUM(CASE WHEN [b].[Field] IN (N'[NULL]', N'NULL') THEN 1 WHEN LEN([b].[Field]) < 60 AND CAST(TRY_CAST(NULLIF([b].[Field], N'') AS BIGINT) AS VARCHAR) = [b].[Field] THEN 1 ELSE 0 END) THEN 1 ELSE 0 END AS [IsInt]
  , CASE WHEN @RowCount = SUM(CASE WHEN [b].[Field] IN (N'[NULL]', N'NULL') THEN 1 WHEN LEN([b].[Field]) < 60 AND CAST(TRY_CAST(NULLIF([b].[Field], N'') AS DATETIME2(3)) AS VARCHAR) = [b].[Field] THEN 1 ELSE 0 END) THEN 1 ELSE 0 END AS [IsDateTime]
  , CASE WHEN @RowCount = SUM(CASE WHEN [b].[Field] IN (N'[NULL]', N'NULL') THEN 1 WHEN LEN([b].[Field]) < 60 AND CAST(TRY_CAST(NULLIF([b].[Field], N'') AS DATE) AS VARCHAR) = [b].[Field] THEN 1 ELSE 0 END) THEN 1 ELSE 0 END AS [IsDate]
  , CASE WHEN SUM(CASE WHEN [b].[Field] IN (N'[NULL]', N'NULL') THEN 0 WHEN CAST([b].[Field] AS VARCHAR(MAX)) <> [b].[Field] THEN 1 ELSE 0 END) > 0 THEN 1 ELSE 0 END AS [IsUniCode]
INTO [#Types]
FROM [#Data] AS [b]
WHERE [b].[RowNum] > 1
GROUP BY [b].[ColumnId] ;

CREATE UNIQUE CLUSTERED INDEX [ColumnId] ON [#Types]( [ColumnId] ) ;

DECLARE
    @MaxChunk INT = ( SELECT MAX([Chunk])FROM [#Rows] )
  , @I        INT = 0 ;

WHILE @I < @MaxChunk
    BEGIN
        SET @I = @I + 1 ;

        SELECT @Output = @Output + CASE WHEN @I > 1 THEN '

' ELSE '' END            + 'SELECT
	'                    + STRING_AGG(@NVarcharMAX + [k].[TopHeader], '') + '
FROM (VALUES
'                        + STRING_AGG(@NVarcharMAX + [k].[Row], @CommaAndNewLine) + ')
[vdata] ('               + STRING_AGG(@NVarcharMAX + [k].[BottomHeader], '') + ')'
        FROM( SELECT TOP 999999999
                     STRING_AGG(
                         @NVarcharMAX
                         + CASE WHEN [k].[RowNum] = 1 THEN
                                    CASE WHEN @QuotedIdentifier = 1 OR [k].[Field] LIKE '%[^0-9A-Z_]%' OR [k].[Field] NOT LIKE '[a-z]%' THEN CASE WHEN [k].[IsDateTime] = 1 AND [k].[IsInt] = 0 THEN 'CAST(' + QUOTENAME([k].[Field]) + ' AS datetime2(3)) as ' + QUOTENAME([k].[Field])
                                                                                                                                                 WHEN [k].[IsDate] = 1 AND [k].[IsInt] = 0 THEN 'CAST(' + QUOTENAME([k].[Field]) + ' AS date) as ' + QUOTENAME([k].[Field])
                                                                                                                                                 ELSE QUOTENAME([k].[Field])
                                                                                                                                             END
                                        ELSE CASE WHEN [k].[IsDateTime] = 1 AND [k].[IsInt] = 0 THEN 'CAST(' + [k].[Field] + ' AS datetime2(3)) as ' + [k].[Field] WHEN [k].[IsDate] = 1 AND [k].[IsInt] = 0 THEN 'CAST(' + [k].[Field] + ' AS date) as ' + [k].[Field] ELSE [k].[Field] END
                                    END
                           END, ', ') AS [TopHeader]
                   , STRING_AGG(@NVarcharMAX + CASE WHEN [k].[RowNum] = 1 THEN CASE WHEN @QuotedIdentifier = 1 OR [k].[Field] LIKE '%[^0-9A-Z_]%' OR [k].[Field] NOT LIKE '[a-z]%' THEN QUOTENAME([k].[Field])ELSE [k].[Field] END END, ', ') AS [BottomHeader]
                   , '('
                     + STRING_AGG(
                           @NVarcharMAX + CASE WHEN [k].[RowNum] > 1 THEN CASE WHEN [k].[Field] IS NULL OR [k].[Field] IN ('[NULL]', 'NULL') THEN 'NULL' WHEN [k].[IsInt] = 1 THEN [k].[Field] ELSE CASE WHEN [k].[IsUniCode] = 1 THEN 'N''' ELSE '''' END + REPLACE([k].[Field], '''', '''''') + '''' END
                                          END, ', ') + ')' AS [Row]
              FROM( SELECT TOP 999999999
                           [d].[RowNum]
                         , [d].[Field]
                         , [d].[ColumnId]
                         , [t].[IsInt]
                         , [t].[IsDate]
                         , [t].[IsDateTime]
                         , [t].[IsUniCode]
                    FROM [#Data] AS [d]
                    INNER JOIN [#Types] AS [t] WITH( NOLOCK, FORCESEEK )ON [d].[ColumnId] = [t].[ColumnId]
                    WHERE( [d].[RowNum] = 1 OR [d].[Chunk] = @I )
                    ORDER BY [d].[RowNum]
                           , [d].[ColumnId] ) AS [k]
              GROUP BY [k].[RowNum]
              ORDER BY [RowNum] ) AS [k]
        OPTION( MAXDOP 1 ) ;
    END ;

SELECT @Output ;
GO
EXEC sys.sp_MS_marksystemobject
    sp_Values
GO
