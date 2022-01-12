USE [HairClubCMS] ;

DECLARE @HairSystemInventorySnapshotID INT ;

SELECT TOP 1
       @HairSystemInventorySnapshotID = [hsis].[HairSystemInventorySnapshotID]
FROM [dbo].[datHairSystemInventorySnapshot] AS [hsis]
ORDER BY [hsis].[CreateDate] DESC ;

IF OBJECT_ID('[tempdb]..[#datHairSystemInventoryBatch]') IS NOT NULL
    DROP TABLE [#datHairSystemInventoryBatch] ;

SELECT *
INTO [#datHairSystemInventoryBatch]
FROM [dbo].[datHairSystemInventoryBatch] AS [hsib]
WHERE [hsib].[HairSystemInventorySnapshotID] = @HairSystemInventorySnapshotID AND [hsib].[CenterID] IN (270, 271) ;

DECLARE @datHairSystemInventoryBatchCnt INT = @@ROWCOUNT ;

IF OBJECT_ID('[tempdb]..[#datHairSystemInventoryTransaction]') IS NOT NULL
    DROP TABLE [#datHairSystemInventoryTransaction] ;

SELECT *
INTO [#datHairSystemInventoryTransaction]
FROM [dbo].[datHairSystemInventoryTransaction] AS [hsit]
WHERE EXISTS ( SELECT 1 FROM [#datHairSystemInventoryBatch] AS [b] WHERE [hsit].[HairSystemInventoryBatchID] = [b].[HairSystemInventoryBatchID] ) AND ISNULL([hsit].[IsExcludedFromCorrections], 0) <> 1 ;

DECLARE @datHairSystemInventoryTransactionCnt INT = @@ROWCOUNT ;

SELECT *
FROM [#datHairSystemInventoryTransaction] ;

IF @datHairSystemInventoryBatchCnt = 0
    THROW 50000, 'No record in [dbo].[datHairSystemInventoryBatch] table !', 1 ;

IF @datHairSystemInventoryTransactionCnt = 0
    THROW 50000, 'No record in [dbo].[datHairSystemInventoryTransaction] table !', 1 ;

UPDATE [hsit]
SET
    [hsit].[IsExcludedFromCorrections] = 1
  --, hsit.ExclusionReason = 'These two locations are unable to perform any inventory this month.' 
  , [hsit].[ExclusionReason] = 'This location is unable to perform any inventory this month.'
  , [hsit].[LastUpdate] = GETUTCDATE()
  , [hsit].[LastUpdateUser] = 'NChavez'
FROM [dbo].[datHairSystemInventoryTransaction] AS [hsit]
WHERE EXISTS ( SELECT 1 FROM [#datHairSystemInventoryBatch] AS [b] WHERE [hsit].[HairSystemInventoryBatchID] = [b].[HairSystemInventoryBatchID] ) AND ISNULL([hsit].[IsExcludedFromCorrections], 0) <> 1 ;

EXEC [dbo].[mtnHairSystemInventoryCorrection] NULL, @HairSystemInventorySnapshotID ;