CREATE VIEW [bi_mktg_dds].[vwDimEmployee]
AS
-------------------------------------------------------------------------
-- [vwDimEmployee] is used to retrieve a
-- list of Employee
--
--   SELECT * FROM [bi_mktg_dds].[vwDimEmployee]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	   [EmployeeKey]
			  ,[EmployeeSSID]
			  ,[EmployeeFullName]
			  ,[EmployeeFirstName]
			  ,[EmployeeLastName]
			  ,[EmployeeDescription]
			  ,[EmployeeTitle]
			  ,[ActionSetCode]
			  ,[EmployeeDepartmentSSID]
			  ,[EmployeeDepartmentDescription]
			  ,[EmployeeJobFunctionSSID]
			  ,[EmployeeJobFunctionDescription]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_mktg_dds].[DimEmployee]
