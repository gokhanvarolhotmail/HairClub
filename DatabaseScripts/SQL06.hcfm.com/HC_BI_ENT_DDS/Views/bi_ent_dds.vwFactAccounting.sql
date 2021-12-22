/* CreateDate: 01/08/2021 15:21:54.533 , ModifyDate: 01/08/2021 15:21:54.533 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_ent_dds].[vwFactAccounting]
AS
-------------------------------------------------------------------------
-- [vwFactAccounting] is used to retrieve a
-- list of Gl Accounts
--
--   SELECT * FROM [bi_ent_dds].[vwFactAccounting]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    11/12/2012  KMurdoch     Initial Creation
--			04/10/2013  KMurdoch	 Repointed to HC_Accounting
--			02/06/2018  KMurdoch     Changed CenterSSID to CenterNumber
-------------------------------------------------------------------------

SELECT [CenterID]
	  ,[CenterKey]
      ,[HC_Accounting].[dbo].[FactAccounting].[DateKey]
      ,[PartitionDate]
      ,[HC_Accounting].[dbo].[FactAccounting].[AccountID]
      ,CONVERT(MONEY, [Budget]) AS 'Budget'
      ,CONVERT(MONEY, [Actual]) AS 'Actual'
      ,CONVERT(MONEY, [Forecast]) AS 'Forecast'
      ,CONVERT(MONEY,[Flash]) AS 'Flash'
      ,CONVERT(MONEY,[FlashReporting]) AS 'FlashReporting'
      ,CONVERT(MONEY,[Drivers]) AS 'Drivers'
      ,[Timestamp]
      ,[DoctorEntityID]
  FROM [HC_Accounting].[dbo].[FactAccounting]
	INNER JOIN [bi_ent_dds].[DimCenter]
		ON [HC_Accounting].[dbo].[FactAccounting].CenterID = [bi_ent_dds].[DimCenter].CenterNumber
	INNER JOIN [bi_ent_dds].[vwDimDate]
		ON [HC_Accounting].[dbo].[FactAccounting].DateKey = [bi_ent_dds].[vwDimDate].DateKey
	INNER JOIN [bi_ent_dds].[vwDimAccount]
		ON [HC_Accounting].[dbo].[FactAccounting].AccountID = [bi_ent_dds].[vwDimAccount].AccountID
GO
