USE [ReportServer]
GO
IF OBJECT_ID('[tempdb]..[#reports]') IS null
SELECT
    [c].[ItemID]
  , [c].[Path]
  , [c].[CreationDate]
  , [c].[ModifiedDate]
INTO [#reports]
FROM [dbo].[Catalog] AS [c] WITH( NOLOCK )
WHERE [c].[Type] = 2 ; -- Report


SELECT * FROM [#reports]
WHERE path LIKE '%/Flash_RecurringBusinessDetails%'

SELECT * FROM [#reports]
WHERE path LIKE '%/Flash_RecurringBusiness%'

SELECT * FROM [#reports]
WHERE path LIKE '%sharepoint%'


