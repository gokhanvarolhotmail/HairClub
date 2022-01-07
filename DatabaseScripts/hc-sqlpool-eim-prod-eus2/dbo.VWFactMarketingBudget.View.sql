/****** Object:  View [dbo].[VWFactMarketingBudget]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWFactMarketingBudget]
AS SELECT  [FactDate]
      ,[Month]
      ,[BudgetType]
      ,Case when Agency='Non Agency' then 'Other'
	        When Agency like 'KingStar%' then 'Kingstar Media'
			When Agency like 'In%house%' then 'In-house'
	   else agency end Agency
	   ,Case when Agency in ('Non Agency','Other') then 'Non Paid Media'
	     else 'PaidMedia' end PaidMedia
      ,Case 
	  When Agency='In-house' and channel='Sweepstakes' then 'Paid Social'
	  else [Channel] end Channel
	  ,Case 
	  When Agency='Launch' and Channel in ('Paid Social','Display') Then 'Paid Social & Display'
	  When Agency='Pure Digital' and Channel in ('Paid Search','Display') Then 'Paid Search & Display'
	  When Agency='In-House' and Channel in ('Paid Search','Paid Social','Local Search','Sweepstakes') Then 'Multiple'
	  when Agency='Other' Then 'Multiple'
	  else Channel end ChannelGroup  
      ,[Medium]
      ,[Source]
      , [Budget]
      ,[Location]
      ,[BudgetAmount]
      ,[TaregetLeads]
      ,[CurrencyConversion]
      ,[DWH_LoadDate]
      ,[DWH_UpdatedDate]
  FROM [dbo].[FactMarketingBudget];
GO
