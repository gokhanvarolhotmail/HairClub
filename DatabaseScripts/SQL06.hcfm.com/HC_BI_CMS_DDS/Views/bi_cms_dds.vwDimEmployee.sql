/* CreateDate: 10/03/2019 23:03:43.603 , ModifyDate: 10/03/2019 23:03:43.603 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwDimEmployee]
AS
-------------------------------------------------------------------------
-- [vwDimEmployee] is used to retrieve a
-- list of Employees
--
--   SELECT * FROM [bi_cms_dds].[vwDimEmployee]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
--			07/13/2011  KMurdoch	 Added CenterSSID
-------------------------------------------------------------------------

	SELECT	  [EmployeeKey]
			, [EmployeeSSID]
			, [CenterSSID]
			, [EmployeeFullName]
			, [EmployeeFirstName]
			, [EmployeeLastName]
			, [EmployeeInitials]
			, [SalutationSSID]
			, [EmployeeSalutationDescription]
			, [EmployeeSalutationDescriptionShort]
			, [EmployeeAddress1]
			, [EmployeeAddress2]
			, [EmployeeAddress3]
			, [CountryRegionDescription]
			, [CountryRegionDescriptionShort]
			, [StateProvinceDescription]
			, [StateProvinceDescriptionShort]
			, [City]
			, [PostalCode]
			, [UserLogin]
			, [EmployeePhoneMain]
			, [EmployeePhoneAlternate]
			, [EmployeeEmergencyContact]
			, [EmployeePayrollNumber]
			, [EmployeeTimeClockNumber]
			, [RowIsCurrent]
			, [RowStartDate]
			, [RowEndDate]
	FROM [bi_cms_dds].[DimEmployee]
GO
