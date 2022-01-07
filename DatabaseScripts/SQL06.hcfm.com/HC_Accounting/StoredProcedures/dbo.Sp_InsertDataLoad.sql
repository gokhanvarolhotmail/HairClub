/* CreateDate: 01/05/2022 09:56:05.813 , ModifyDate: 01/05/2022 09:56:05.813 */
GO
--step 1 truncate and upload xls into GPConsolidatedStage.ie truncate table GPConsolidatedStage
--step 2 run dbo.Sp_InsertDataLoad @year  i.e EXEC Sp_InsertDataLoad '2020'
--setp 3 run spApp_PopulateBudgetFromLoadTable i.e. exec spApp_PopulateBudgetFromLoadTable

CREATE PROC [dbo].[Sp_InsertDataLoad]
    @year VARCHAR(4)
AS

--Remove null data
DELETE FROM [dbo].[GPConsolidatedStage]
WHERE [Period1] IS NULL AND [Period2] IS NULL AND [Period3] IS NULL AND [Period4] IS NULL AND [Period5] IS NULL AND [Period6] IS NULL AND [Period7] IS NULL AND [Period8] IS NULL AND [Period9] IS NULL AND [Period10] IS NULL AND [Period11] IS NULL AND [Period12] IS NULL ;

TRUNCATE TABLE [dbo].[DataLoad] ;

--DECLARE @year AS VARCHAR(4)
--SET   @year = '2019'
INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 1
  , '1/1/' + @year
  , [Natural]
  , [Period1]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period1] IS NOT NULL ;

INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 2
  , '2/1/' + @year
  , [Natural]
  , [Period2]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period2] IS NOT NULL ;

INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 3
  , '3/1/' + @year
  , [Natural]
  , [Period3]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period3] IS NOT NULL ;

INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 4
  , '4/1/' + @year
  , [Natural]
  , [Period4]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period4] IS NOT NULL ;

INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 5
  , '5/1/' + @year
  , [Natural]
  , [Period5]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period5] IS NOT NULL ;

INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 6
  , '6/1/' + @year
  , [Natural]
  , [Period6]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period6] IS NOT NULL ;

INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 7
  , '7/1/' + @year
  , [Natural]
  , [Period7]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period7] IS NOT NULL ;

INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 8
  , '8/1/' + @year
  , [Natural]
  , [Period8]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period8] IS NOT NULL ;

INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 9
  , '9/1/' + @year
  , [Natural]
  , [Period9]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period9] IS NOT NULL ;

INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 10
  , '10/1/' + @year
  , [Natural]
  , [Period10]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period10] IS NOT NULL ;

INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 11
  , '11/1/' + @year
  , [Natural]
  , [Period11]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period11] IS NOT NULL ;

INSERT INTO [dbo].[DataLoad]
SELECT
    [Center]
  , @year
  , 12
  , '12/1/' + @year
  , [Natural]
  , [Period12]
  , 'Budget'
  , 'Yes'
FROM [dbo].[GPConsolidatedStage]
WHERE [Period12] IS NOT NULL ;
GO
