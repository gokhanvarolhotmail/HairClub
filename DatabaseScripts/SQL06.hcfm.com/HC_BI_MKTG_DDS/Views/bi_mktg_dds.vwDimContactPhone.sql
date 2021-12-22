CREATE VIEW [bi_mktg_dds].[vwDimContactPhone]
AS
-------------------------------------------------------------------------
-- [vwDimContactPhone] is used to retrieve a
-- list of ContactPhone
--
--   SELECT * FROM [bi_mktg_dds].[vwDimContactPhone]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			08/07/2019  KMurdoch     Added SFDC Lead/LeadPhoneID removed Contactssid
-------------------------------------------------------------------------

	SELECT	   [ContactPhoneKey]
			  ,[ContactPhoneSSID]
			  --,[ContactSSID]
			  ,[SFDC_LeadID]
			  ,[SFDC_LeadPhoneID]
			  ,[PhoneTypeCode]
			  ,[CountryCodePrefix]
			  ,[AreaCode]
			  ,[PhoneNumber]
			  ,[Extension]
			  ,[Description]
			  ,[PrimaryFlag]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_mktg_dds].[DimContactPhone]
