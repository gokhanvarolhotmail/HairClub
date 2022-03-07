/* CreateDate: 02/22/2022 09:32:01.477 , ModifyDate: 02/22/2022 09:33:48.343 */
GO
CREATE VIEW [Audit].[vdbo_datSalesCodeCenterInventory]
AS
SELECT
    ISNULL([a].[LogId], [b].[LogId]) AS [LogId]
  , ISNULL([a].[LogUser], [b].[LogUser]) AS [LogUser]
  , ISNULL([a].[LogAppName], [b].[LogAppName]) AS [LogAppName]
  , ISNULL([a].[LogDate], [b].[LogDate]) AS [LogDate]
  , ISNULL([a].[SalesCodeCenterInventoryID], [b].[SalesCodeCenterInventoryID]) AS [SalesCodeCenterInventoryID]
  , CASE WHEN [a].[Action] = 'D' AND [b].[Action] = 'I' THEN 'Update' WHEN [a].[Action] = 'D' THEN 'Delete' WHEN [b].[Action] = 'I' THEN 'Insert' END AS [Action]
  , [a].[SalesCodeCenterID]
  , [a].[QuantityOnHand] AS [BeforeQuantityOnHand]
  , [b].[QuantityOnHand] AS [AfterQuantityOnHand]
  , ISNULL([b].[QuantityOnHand], 0) - ISNULL([a].[QuantityOnHand], 0) AS [DiffQuantityOnHand]
  , [a].[QuantityPar] AS [BeforeQuantityPar]
  , [b].[QuantityPar] AS [AfterQuantityPar]
  , [a].[IsActive] AS [BeforeIsActive]
  , [b].[IsActive] AS [AfterIsActive]
  , [a].[CreateDate] AS [BeforeCreateDate]
  , [b].[CreateDate] AS [AfterCreateDate]
  , [a].[CreateUser] AS [BeforeCreateUser]
  , [b].[CreateUser] AS [AfterCreateUser]
  , [a].[LastUpdate] AS [BeforeLastUpdate]
  , [b].[LastUpdate] AS [AfterLastUpdate]
  , [a].[LastUpdateUser] AS [BeforeLastUpdateUser]
  , [b].[LastUpdateUser] AS [AfterLastUpdateUser]
  , [a].[UpdateStamp] AS [BeforeUpdateStamp]
  , [b].[UpdateStamp] AS [AfterUpdateStamp]
FROM( SELECT * FROM [Audit].[dbo_datSalesCodeCenterInventory] AS [a] WITH( NOLOCK )WHERE [a].[Action] = 'D' ) AS [a]
FULL OUTER JOIN( SELECT * FROM [Audit].[dbo_datSalesCodeCenterInventory] AS [b] WITH( NOLOCK )WHERE [b].[Action] = 'I' ) AS [b] ON [a].[LogId] = [b].[LogId]
                                                                                                                               AND [a].[SalesCodeCenterInventoryID] = [b].[SalesCodeCenterInventoryID] ;
GO
