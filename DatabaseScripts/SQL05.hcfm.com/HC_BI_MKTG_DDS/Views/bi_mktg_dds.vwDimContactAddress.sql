/* CreateDate: 05/03/2010 12:21:10.820 , ModifyDate: 10/03/2019 21:54:30.360 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimContactAddress]
AS
-------------------------------------------------------------------------
-- [vwDimContactAddress] is used to retrieve a
-- list of ContactAddress
--
--   SELECT * FROM [bi_mktg_dds].[vwDimContactAddress]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			08/07/2019  KMurdoch     Added SFDC Lead/LeadAddressID removed Contactssid
-------------------------------------------------------------------------

	SELECT	   [ContactAddressKey]
			  ,[ContactAddressSSID]
			  --,[ContactSSID]
			  ,[SFDC_LeadID]
			  ,[SFDC_LeadAddressID]
			  ,[AddressTypeCode]
			  ,[AddressLine1]
			  ,[AddressLine2]
			  ,[AddressLine3]
			  ,[AddressLine4]
			  ,[AddressLine1Soundex]
			  ,[AddressLine2Soundex]
			  ,[City]
			  ,[CitySoundex]
			  ,[StateCode]
			  ,[StateName]
			  ,[ZipCode]
			  ,[CountyCode]
			  ,[CountyName]
			  ,[CountryCode]
			  ,[CountryName]
			  ,[CountryPrefix]
			  ,[TimeZoneCode]
			  ,[PrimaryFlag]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_mktg_dds].[DimContactAddress]
GO
