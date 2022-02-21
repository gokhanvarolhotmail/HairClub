CREATE SCHEMA [Audit] ;
GO
--DROP TRIGGER [dbo].[TRG_datSalesCodeCenterInventory_UPD_Log]
-- DROP TABLE [Audit].[dbo_datSalesCodeCenterInventory]

CREATE TABLE [Audit].[dbo_datSalesCodeCenterInventory]
(
    [LogId]                      INT            NOT NULL
  , [LogUser]                    VARCHAR(256)   NOT NULL
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
  , [UpdateStamp]                BINARY(8)    NOT NULL
) ;
GO
CREATE UNIQUE CLUSTERED INDEX [dbo_datSalesCodeCenterInventory_PKC] ON [Audit].[dbo_datSalesCodeCenterInventory]
( [LogId], [SalesCodeCenterInventoryID], [Action] ) ;
GO
CREATE TRIGGER [dbo].[TRG_datSalesCodeCenterInventory_UPD_Log]
ON [dbo].[datSalesCodeCenterInventory]
FOR UPDATE
AS
SET NOCOUNT ON ;

DECLARE @LogId INT = ISNULL(( SELECT TOP 1 [LogId] + 1 FROM [Audit].[dbo_datSalesCodeCenterInventory] ORDER BY [LogId] DESC ), 1) ;

INSERT [Audit].[dbo_datSalesCodeCenterInventory]( [LogId]
                                                , [LogUser]
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
    @LogId AS [LogId]
  , SUSER_SNAME() AS [LogUser]
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