USE [ReportServer] ;
GO
IF OBJECT_ID('[tempdb]..[#reports]') IS NULL
    SELECT
        [ct].[Name] --Just the objectd name  
      , [ct].[Path] --Path including object name
      , [ct].[Type]
      , CASE [ct].[Type] --Type, an int which can be converted using this case statement.
            WHEN 1 THEN 'Folder'
            WHEN 2 THEN 'Report'
            WHEN 3 THEN 'File'
            WHEN 4 THEN 'Linked Report'
            WHEN 5 THEN 'Data Source'
            WHEN 6 THEN 'Report Model - Rare'
            WHEN 7 THEN 'Report Part - Rare'
            WHEN 8 THEN 'Shared Data Set - Rare'
            WHEN 9 THEN 'Image'
            ELSE CAST([ct].[Type] AS VARCHAR(100))
        END AS [TypeName]
      --, content
      , [ct].[CreationDate]
      , [ct].[ModifiedDate]
      , [c].[UserName] AS [CreatedBy]
      , [m].[UserName] AS [ModifiedBy]
      , [ct].[LinkSourceID] --If a linked report then this is the ItemID of the actual report.
      , [ct].[Description] --This is the same information as can be found in the GUI
      , [ct].[Hidden] --Is the object hidden on the screen or not
      , [ct].[ItemID] -- Unique Identifier
      , [ct].[ParentID] --The ItemID of the folder in which it resides
    INTO [#reports]
    FROM [dbo].[Catalog] AS [ct]
    INNER JOIN [dbo].[Users] AS [c] ON [ct].[CreatedByID] = [c].[UserID]
    INNER JOIN [dbo].[Users] AS [m] ON [ct].[ModifiedByID] = [m].[UserID]
    ORDER BY [ct].[ModifiedDate] DESC ;

SELECT *
FROM [#reports]
WHERE [Type] = 2
ORDER BY [ModifiedDate] DESC ;

SELECT * FROM [#reports]
WHERE path LIKE '%/Flash_RecurringBusinessDetails%'

SELECT * FROM [#reports]
WHERE path LIKE '%/Flash_RecurringBusiness%'

SELECT * FROM [#reports]
WHERE path LIKE '%sharepoint%'


