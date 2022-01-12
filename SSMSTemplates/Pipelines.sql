RETURN ;

DROP TABLE IF EXISTS [#PipelineLines] ;
DROP TABLE IF EXISTS [PipelineLines] ;
DROP TABLE IF EXISTS [Pipelines] ;

SELECT [Util].[FS].[ReadAllTextFromFile]('C:\Temp\arm_template.json') AS [JSONVal]
INTO [Pipelines] ;

DECLARE @Json NVARCHAR(MAX) = ( SELECT [JSONVal] FROM [Pipelines] ) ;
DECLARE @SearchForFactoryName VARCHAR(MAX) = '"name": "[concat(parameters(''factoryName''), ''/' ;

SET @Json = REPLACE(@Json, CHAR(13) + CHAR(10), CHAR(10)) ;

SELECT
    [b].[FieldNum]
  , CASE WHEN CHARINDEX(@SearchForFactoryName, [b].[Field]) > 0 THEN TRIM(REPLACE(REPLACE([b].[Field], @SearchForFactoryName, ''), ''')]",', ''))END AS [PipelineName]
  , [b].[Field]
INTO [#PipelineLines]
FROM [Util].[dbo].ParseDelimited(@Json, CHAR(10)) AS [b] ;

CREATE UNIQUE CLUSTERED INDEX [FieldNum] ON [#PipelineLines]( [FieldNum] DESC ) ;

SELECT
    [a].[FieldNum]
  , [b].[PipelineName]
  , TRIM(REPLACE(REPLACE([c].[Field], '"type": "Microsoft.DataFactory/factories/', ''), '",', '')) AS [Type]
  , [a].[Field]
INTO [PipelineLines]
FROM [#PipelineLines] AS [a]
CROSS APPLY( SELECT TOP 1 * FROM [#PipelineLines] AS [b] WHERE [b].[FieldNum] <= [a].[FieldNum] AND [b].[PipelineName] <> '' ORDER BY [b].[FieldNum] DESC ) AS [b]
CROSS APPLY( SELECT * FROM [#PipelineLines] AS [c] WHERE [c].[FieldNum] = [b].[FieldNum] + 1 ) AS [c] ;

CREATE UNIQUE CLUSTERED INDEX [FieldNum] ON [PipelineLines]( [FieldNum] ) ;
GO

SELECT *
FROM [PipelineLines]
WHERE CHARINDEX('ASA_FactLeadTracking', [Field]) > 0
ORDER BY [FieldNum] ;

SELECT *
FROM [PipelineLines]
WHERE CHARINDEX('FactAppointment', [Field]) > 0
ORDER BY [FieldNum] ;
