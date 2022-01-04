-- SQL05 HC_Accounting db
TRUNCATE TABLE dbo.GPConsolidatedStage

EXEC [dbo].[Sp_InsertDataLoad] @year VARCHAR(4)

EXEC [dbo].[spApp_PopulateBudgetFromLoadTable]