CREATE SCHEMA [Audit] ;
GO
-- DROP TRIGGER [dbo].[TRG_datSalesCodeCenterInventory_UPD_Log]
-- DROP TABLE [Audit].[dbo_datSalesCodeCenterInventory]

CREATE TABLE [Audit].[dbo_datSalesCodeCenterInventory]
(
    [LogId]                      INT            NOT NULL
  , [LogUser]                    VARCHAR(256)   NOT NULL
  , [LogAppName]                 VARCHAR(256)   NOT NULL
  , [LogDate]                    DATETIME2(7)   NOT NULL
  , [Action]                     CHAR(1)        NOT NULL
  , [SalesCodeCenterInventoryID] [INT]          NOT NULL
  , [SalesCodeCenterID]          [INT]          NOT NULL
  , [QuantityOnHand]             [INT]          NOT NULL
  , [QuantityPar]                [INT]          NOT NULL
  , [IsActive]                   [BIT]          NOT NULL
  , [CreateDate]                 [DATETIME]     NOT NULL
  , [CreateUser]                 [NVARCHAR](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
  , [LastUpdate]                 [DATETIME]     NOT NULL
  , [LastUpdateUser]             [NVARCHAR](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
  , [UpdateStamp]                BINARY(8)      NOT NULL
) ;
GO
CREATE UNIQUE CLUSTERED INDEX [dbo_datSalesCodeCenterInventory_PKC] ON [Audit].[dbo_datSalesCodeCenterInventory]
( [LogId], [SalesCodeCenterInventoryID], [Action] ) ;
GO
CREATE TRIGGER [dbo].[TRG_datSalesCodeCenterInventory_UPD_Log]
ON [dbo].[datSalesCodeCenterInventory]
FOR INSERT, DELETE, UPDATE
AS
SET NOCOUNT ON ;

INSERT [Audit].[dbo_datSalesCodeCenterInventory]( [LogId]
                                                , [LogUser]
                                                , [LogAppName]
                                                , [LogDate]
                                                , [Action]
                                                , [SalesCodeCenterInventoryID]
                                                , [SalesCodeCenterID]
                                                , [QuantityOnHand]
                                                , [QuantityPar]
                                                , [IsActive]
                                                , [CreateDate]
                                                , [CreateUser]
                                                , [LastUpdate]
                                                , [LastUpdateUser]
                                                , [UpdateStamp] )
SELECT
    ISNULL(( SELECT TOP 1 [LogId] + 1 FROM [Audit].[dbo_datSalesCodeCenterInventory] ORDER BY [LogId] DESC ), 1) AS [LogId]
  , SUSER_SNAME() AS [LogUser]
  , APP_NAME() AS [LogAppName]
  , GETDATE() AS [LogDate]
  , [k].[Action]
  , [k].[SalesCodeCenterInventoryID]
  , [k].[SalesCodeCenterID]
  , [k].[QuantityOnHand]
  , [k].[QuantityPar]
  , [k].[IsActive]
  , [k].[CreateDate]
  , [k].[CreateUser]
  , [k].[LastUpdate]
  , [k].[LastUpdateUser]
  , [k].[UpdateStamp]
FROM( SELECT
          'D' AS [Action]
        , [d].[SalesCodeCenterInventoryID]
        , [d].[SalesCodeCenterID]
        , [d].[QuantityOnHand]
        , [d].[QuantityPar]
        , [d].[IsActive]
        , [d].[CreateDate]
        , [d].[CreateUser]
        , [d].[LastUpdate]
        , [d].[LastUpdateUser]
        , [d].[UpdateStamp]
      FROM [Deleted] AS [d]
      UNION ALL
      SELECT
          'I' AS [Action]
        , [i].[SalesCodeCenterInventoryID]
        , [i].[SalesCodeCenterID]
        , [i].[QuantityOnHand]
        , [i].[QuantityPar]
        , [i].[IsActive]
        , [i].[CreateDate]
        , [i].[CreateUser]
        , [i].[LastUpdate]
        , [i].[LastUpdateUser]
        , [i].[UpdateStamp]
      FROM [Inserted] AS [i] ) AS [k] ;
GO
DISABLE TRIGGER [dbo].[TRG_datSalesCodeCenterInventory_UPD_Log] ON [dbo].[datSalesCodeCenterInventory] ;
GO
ENABLE TRIGGER [dbo].[TRG_datSalesCodeCenterInventory_UPD_Log] ON [dbo].[datSalesCodeCenterInventory] ;
GO

--DROP TRIGGER [dbo].[TRG_datSalesCodeCenterInventory_UPD_Log]
GO
/*
BEGIN TRANSACTION ;

UPDATE [k]
SET [k].[QuantityOnHand] = [QuantityOnHand] + 2
FROM( SELECT TOP 10 * FROM [dbo].[datSalesCodeCenterInventory] AS [k] ) AS [k] ;

SELECT *
FROM [Audit].[dbo_datSalesCodeCenterInventory] ;

ROLLBACK ;
*/
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
SELECT
    [v].[LogId]
  , [v].[LogUser]
  , [v].[LogAppName]
  , [v].[LogDate]
  , [v].[SalesCodeCenterInventoryID]
  , [v].[Action]
  , [v].[SalesCodeCenterID]
  , [v].[BeforeQuantityOnHand]
  , [v].[AfterQuantityOnHand]
  , [v].[DiffQuantityOnHand]
  , [v].[BeforeQuantityPar]
  , [v].[AfterQuantityPar]
  , [v].[BeforeIsActive]
  , [v].[AfterIsActive]
  , [v].[BeforeCreateDate]
  , [v].[AfterCreateDate]
  , [v].[BeforeCreateUser]
  , [v].[AfterCreateUser]
  , [v].[BeforeLastUpdate]
  , [v].[AfterLastUpdate]
  , [v].[BeforeLastUpdateUser]
  , [v].[AfterLastUpdateUser]
  , [v].[BeforeUpdateStamp]
  , [v].[AfterUpdateStamp]
FROM [Audit].[vdbo_datSalesCodeCenterInventory] AS [v]
WHERE [v].[DiffQuantityOnHand] < -1 OR [v].[DiffQuantityOnHand] > 1 ;
GO
SELECT
    [v].[LogId]
  , [v].[LogUser]
  , [v].[LogAppName]
  , [v].[LogDate]
  , [v].[SalesCodeCenterInventoryID]
  , [v].[Action]
  , [v].[SalesCodeCenterID]
  , [v].[BeforeQuantityOnHand]
  , [v].[AfterQuantityOnHand]
  , [v].[DiffQuantityOnHand]
  , [v].[BeforeQuantityPar]
  , [v].[AfterQuantityPar]
  , [v].[BeforeIsActive]
  , [v].[AfterIsActive]
  , [v].[BeforeCreateDate]
  , [v].[AfterCreateDate]
  , [v].[BeforeCreateUser]
  , [v].[AfterCreateUser]
  , [v].[BeforeLastUpdate]
  , [v].[AfterLastUpdate]
  , [v].[BeforeLastUpdateUser]
  , [v].[AfterLastUpdateUser]
  , [v].[BeforeUpdateStamp]
  , [v].[AfterUpdateStamp]
FROM [Audit].[vdbo_datSalesCodeCenterInventory] AS [v]
WHERE 1 = 1
AND [v].[AfterQuantityOnHand] <0
ORDER BY [v].[DiffQuantityOnHand] ASC, [v].[AfterQuantityOnHand]
