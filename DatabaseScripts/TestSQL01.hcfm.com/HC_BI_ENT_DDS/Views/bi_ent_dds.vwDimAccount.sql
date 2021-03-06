/* CreateDate: 11/12/2012 14:12:43.880 , ModifyDate: 09/16/2019 09:25:18.167 */
GO
CREATE VIEW [bi_ent_dds].[vwDimAccount]
AS
-------------------------------------------------------------------------
-- [vwDimAccount] is used to retrieve a
-- list of Gl Accounts
--
--   SELECT * FROM [bi_ent_dds].[vwDimAccount]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    11/12/2012  KMurdoch     Initial Creation
-------------------------------------------------------------------------
SELECT [AccountID]
      ,SUBSTRING([LedgerGroup],1,99) AS 'LedgerGroup'
      ,[AccountDescription]
      ,[EBIDA]
      ,[Level0]
      ,[Level0Sort]
      ,[Level1]
      ,[Level1Sort]
      ,[Level2]
      ,[Level2Sort]
      ,[Level3]
      ,[Level3Sort]
      ,[Level4]
      ,[Level4Sort]
      ,[Level5]
      ,[Level5Sort]
      ,[Level6]
      ,[Level6Sort]
      ,[RevenueOrExpenses]
      ,[ExpenseType]
      ,[CalculateGrossProfit]
      --,[Description]
	  ,CAST(accountid AS VARCHAR) + ' - ' + AccountDescription AS 'AcctNoDescription'
  FROM [bi_ent_dds].[DimAccount]
GO
