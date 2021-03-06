/* CreateDate: 03/17/2022 11:57:11.403 , ModifyDate: 03/17/2022 11:57:11.403 */
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
