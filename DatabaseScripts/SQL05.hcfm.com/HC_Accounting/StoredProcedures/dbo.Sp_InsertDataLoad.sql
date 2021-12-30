/* CreateDate: 12/13/2018 11:59:47.203 , ModifyDate: 02/28/2020 10:38:19.457 */
GO
--step 1 truncate and upload xls into GPConsolidatedStage.ie truncate table GPConsolidatedStage
--step 2 run dbo.Sp_InsertDataLoad @year  i.e EXEC Sp_InsertDataLoad '2020'
--setp 3 run spApp_PopulateBudgetFromLoadTable i.e. exec spApp_PopulateBudgetFromLoadTable


CREATE PROC [dbo].[Sp_InsertDataLoad] @year VARCHAR(4)
AS

--Remove null data
			DELETE
			FROM   [dbo].[GPConsolidatedStage]
			WHERE   ISNULL(Period1, '')   = '' AND
					ISNULL(Period2, '')   = '' AND
					ISNULL(Period3, '')   = '' AND
					ISNULL(Period4, '')   = '' AND
					ISNULL(Period5, '')   = '' AND
					ISNULL(Period6, '')   = '' AND
					ISNULL(Period7, '')   = '' AND
					ISNULL(Period8, '')   = '' AND
					ISNULL(Period9, '')	  = '' AND
					ISNULL(Period10, '')  = '' AND
					ISNULL(Period11, '')  = '' AND
					ISNULL(Period12, '')  = ''

			TRUNCATE TABLE dbo.DataLoad

			--DECLARE @year AS VARCHAR(4)
			--SET   @year = '2019'


			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  1,
				  '1/1/' + @year,
				  natural,
				  Period1,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period1, '') <> ''


			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  2,
				  '2/1/' + @year,
				  natural,
				  Period2,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period2, '') <> ''

			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  3,
				  '3/1/' + @year,
				  natural,
				  Period3,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period3, '') <> ''

			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  4,
				  '4/1/' + @year,
				  natural,
				  Period4,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period4, '') <> ''


			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  5,
				  '5/1/' + @year,
				  natural,
				  Period5,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period5, '') <> ''


			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  6,
				  '6/1/' + @year,
				  natural,
				  Period6,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period6, '') <> ''


			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  7,
				  '7/1/' + @year,
				  natural,
				  Period7,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period7, '') <> ''

			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  8,
				  '8/1/' + @year,
				  natural,
				  Period8,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period8, '') <> ''

			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  9,
				  '9/1/' + @year,
				  natural,
				  Period9,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period9, '') <> ''

			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  10,
				  '10/1/' + @year,
				  natural,
				  Period10,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period10, '') <> ''

			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  11,
				  '11/1/' + @year,
				  natural,
				  Period11,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period11, '') <> ''


			INSERT INTO DataLoad
			SELECT Center,
				  @year,
				  12,
				  '12/1/' + @year,
				  natural,
				  Period12,
				  'Budget',
				  'Yes'
			FROM  GPConsolidatedStage
			WHERE ISNULL(Period12, '') <> ''
GO
