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
WHERE [hsib].[HairSystemInventorySnapshotID] = @HairSystemInventorySnapshotID AND [hsib].[CenterID] NOT IN (100) ;

IF OBJECT_ID('[tempdb]..[#datHairSystemInventoryBatch_100]') IS NOT NULL
    DROP TABLE [#datHairSystemInventoryBatch_100] ;

SELECT *
INTO [#datHairSystemInventoryBatch_100]
FROM [dbo].[datHairSystemInventoryBatch] AS [hsib]
WHERE [hsib].[HairSystemInventorySnapshotID] = @HairSystemInventorySnapshotID AND [hsib].[CenterID] IN (100) ;

PRINT '--START UPDATES' ;

BEGIN TRANSACTION ;

UPDATE [hsit]
SET
    [hsit].[IsExcludedFromCorrections] = 1
  , [hsit].[ExclusionReason] = 'This location should not be excluded from inventory this month.'
  , [hsit].[LastUpdate] = GETUTCDATE()
  , [hsit].[LastUpdateUser] = 'cczencz'
FROM [dbo].[datHairSystemInventoryTransaction] AS [hsit]
WHERE [hsit].[HairSystemInventoryBatchID] IN( SELECT [HairSystemInventoryBatchID] FROM [#datHairSystemInventoryBatch] ) AND [hsit].[IsExcludedFromCorrections] <> 1 ;

UPDATE [hsit]
SET
    [hsit].[IsExcludedFromCorrections] = 0

  --, [hsit].[ExclusionReason] = 'This location should not be excluded from inventory this month.'
  , [hsit].[LastUpdate] = GETUTCDATE()
  , [hsit].[LastUpdateUser] = 'cczencz'
FROM [dbo].[datHairSystemInventoryTransaction] AS [hsit]
WHERE [hsit].[HairSystemInventoryBatchID] IN( SELECT [HairSystemInventoryBatchID] FROM [#datHairSystemInventoryBatch_100] ) AND [hsit].[IsExcludedFromCorrections] <> 0 ;

PRINT '--EXEC [dbo].[mtnHairSystemInventoryCorrection] NULL, @HairSystemInventorySnapshotID ;' ;

EXEC [dbo].[mtnHairSystemInventoryCorrection] NULL, @HairSystemInventorySnapshotID ;

--ROLLBACK
--COMMIT

/*
DECLARE @HairSystemInventorySnapshotID INT ;
DECLARE @CenterID INT = 100 ;

SELECT TOP 1
       @HairSystemInventorySnapshotID = [hsis].[HairSystemInventorySnapshotID]
FROM [dbo].[datHairSystemInventorySnapshot] AS [hsis]
ORDER BY [hsis].[CreateDate] DESC ;

PRINT @HairSystemInventorySnapshotID ;

SELECT *
FROM [dbo].[datHairSystemInventoryBatch] AS [hsib]
WHERE [hsib].[HairSystemInventorySnapshotID] = @HairSystemInventorySnapshotID AND [hsib].[CenterID] = @CenterID ;

UPDATE [hsit]
SET
    [hsit].[IsExcludedFromCorrections] = 1
  , [hsit].[ExclusionReason] = 'This location is unable to perform any inventory this month.'
  , [hsit].[LastUpdate] = GETUTCDATE()
  , [hsit].[LastUpdateUser] = 'mkunchum'
FROM [dbo].[datHairSystemInventoryTransaction] AS [hsit]
WHERE [hsit].[HairSystemInventoryBatchID] = @HairSystemInventorySnapshotID ;

EXEC [dbo].[mtnHairSystemInventoryCorrection] NULL, @HairSystemInventorySnapshotID ;
*/
