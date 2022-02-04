RETURN
DROP TABLE IF EXISTS [dbo].[HairClubObjects] ;

SELECT
    CAST([b].[ServerName] AS VARCHAR(128)) AS [ServerName]
  , CAST([b].[DatabaseName] AS VARCHAR(128)) AS [DatabaseName]
  , CAST([b].[ObjectType] AS VARCHAR(128)) AS [ObjectType]
  , CAST(REPLACE([a].[FileName], '.sql', '') AS NVARCHAR(256)) AS [ObjectName]
  , [Util].[FS].[ReadAllTextFromFile]([a].[Directory] + '\' + [a].[FileName]) AS [Definition]
INTO [dbo].[HairClubObjects]
FROM [Util].[FS].[GetDirectoryInfoRecursive]('C:\Temp\Databases', '*.*') AS [a]
CROSS APPLY( SELECT
                 MAX(CASE WHEN [b].[Id] = 4 THEN [b].[value] END) AS [ServerName]
               , MAX(CASE WHEN [b].[Id] = 5 THEN [b].[value] END) AS [DatabaseName]
               , MAX(CASE WHEN [b].[Id] = 6 THEN [b].[value] END) AS [ObjectType]
             FROM( SELECT ROW_NUMBER() OVER ( ORDER BY( SELECT 0 )) AS [Id], [b].[value] FROM STRING_SPLIT([directory], '\') AS [b] ) AS [b] ) AS [b]
WHERE [a].[FileName] <> '' ;

CREATE UNIQUE CLUSTERED INDEX HC ON [dbo].[HairClubObjects] ([ObjectName],[DatabaseName],[ServerName])
GO
SELECT *
FROM [HairClubObjects]
WHERE [Definition] LIKE REPLACE('Last Application Date', ' ', '%')
   OR [Definition] LIKE REPLACE('Scheduled Next App Date', ' ', '%')
   OR [Definition] LIKE REPLACE('Order Avail for Next App', ' ', '%')
   OR [Definition] LIKE REPLACE('Oldest Order Placed Date', ' ', '%')
   OR [Definition] LIKE REPLACE('Oldest Order Placed Due Date', ' ', '%')
   OR [Definition] LIKE REPLACE('Newest Order System Type', ' ', '%')
   OR [Definition] LIKE REPLACE('Remaining Qty to Order', ' ', '%')
   OR [Definition] LIKE REPLACE('Priority Hair Needed', ' ', '%')
   OR [Definition] LIKE REPLACE('Last%App%Date', ' ', '%') ;
GO
