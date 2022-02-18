/* CreateDate: 01/05/2022 09:53:22.380 , ModifyDate: 01/05/2022 09:53:22.380 */
GO
--step 1 truncate and upload xls into GPConsolidatedStage.ie truncate table GPConsolidatedStage
--step 2 run dbo.Sp_InsertDataLoad @year  i.e EXEC Sp_InsertDataLoad '2020'
--setp 3 run spApp_PopulateBudgetFromLoadTable i.e. exec spApp_PopulateBudgetFromLoadTable

CREATE PROC [dbo].[Sp_InsertDataLoad_GVAROL_20220105]
    @year VARCHAR(4)
AS

--Remove null data
DELETE FROM [dbo].[GPConsolidatedStage]
WHERE ISNULL([Period1], '') = ''
  AND ISNULL([Period2], '') = ''
  AND ISNULL([Period3], '') = ''
  AND ISNULL([Period4], '') = ''
  AND ISNULL([Period5], '') = ''
  AND ISNULL([Period6], '') = ''
  AND ISNULL([Period7], '') = ''
  AND ISNULL([Period8], '') = ''
  AND ISNULL([Period9], '') = ''
  AND ISNULL([Period10], '') = ''
  AND ISNULL([Period11], '') = ''
  AND ISNULL([Period12], '') = '' ;

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
WHERE ISNULL([Period1], '') <> '' ;

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
WHERE ISNULL([Period2], '') <> '' ;

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
WHERE ISNULL([Period3], '') <> '' ;

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
WHERE ISNULL([Period4], '') <> '' ;

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
WHERE ISNULL([Period5], '') <> '' ;

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
WHERE ISNULL([Period6], '') <> '' ;

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
WHERE ISNULL([Period7], '') <> '' ;

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
WHERE ISNULL([Period8], '') <> '' ;

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
WHERE ISNULL([Period9], '') <> '' ;

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
WHERE ISNULL([Period10], '') <> '' ;

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
WHERE ISNULL([Period11], '') <> '' ;

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
WHERE ISNULL([Period12], '') <> '' ;
GO
