/* CreateDate: 08/15/2011 13:09:24.480 , ModifyDate: 08/15/2011 13:09:24.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW vwEmployeeCertipaySurgery

AS

SELECT [LastName]
      ,[FirstName]
      ,[Address]
      ,[City]
      ,[State]
      ,[Zip]
      ,[Phone]
      ,[Gender]
      ,[JobCode]
      ,[Title]
      ,[PayGroup]
      ,[HomeDepartment]
      ,[EmployeeID]
      ,[EmployeeNumber]
      ,[Status]
      ,[HireDate]
      ,[TerminationDate]
      ,[EmployeeType]
      ,[CommissionFlag]
      , CASE WHEN [PerformerHomeCenter] like '2%' then 100 + PerformerHomeCenter
			WHEN [PerformerHomeCenter] like '[78]%' THEN PerformerHomeCenter - 200
			ELSE [PerformerHomeCenter]
			END AS [PerformerHomeCenter]
      ,[ImportDate]
      ,[GeneralLedger]
      ,[JobClassification]
  FROM [HC_BI_Reporting].[dbo].[EmployeeCertipay]
GO
