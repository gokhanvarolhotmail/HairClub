/* CreateDate: 05/28/2018 22:15:34.517 , ModifyDate: 02/22/2022 08:31:40.837 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
CREATE TABLE [dbo].[datSalesCodeCenterInventory](
	[SalesCodeCenterInventoryID] [int] IDENTITY(1,1) NOT NULL,
	[SalesCodeCenterID] [int] NOT NULL,
	[QuantityOnHand] [int] NOT NULL,
	[QuantityPar] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datSalesCodeCenterInventory] PRIMARY KEY CLUSTERED
(
	[SalesCodeCenterInventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_datSalesCodeCenterInventory_SalesCodeCenterID] ON [dbo].[datSalesCodeCenterInventory]
(
	[SalesCodeCenterID] ASC
)
INCLUDE([QuantityOnHand],[QuantityPar]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSalesCodeCenterInventory]  WITH CHECK ADD  CONSTRAINT [FK_datSalesCodeCenterInventory_cfgSalesCodeCenter] FOREIGN KEY([SalesCodeCenterID])
REFERENCES [dbo].[cfgSalesCodeCenter] ([SalesCodeCenterID])
GO
ALTER TABLE [dbo].[datSalesCodeCenterInventory] CHECK CONSTRAINT [FK_datSalesCodeCenterInventory_cfgSalesCodeCenter]
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
ALTER TABLE [dbo].[datSalesCodeCenterInventory] ENABLE TRIGGER [TRG_datSalesCodeCenterInventory_UPD_Log]
GO
