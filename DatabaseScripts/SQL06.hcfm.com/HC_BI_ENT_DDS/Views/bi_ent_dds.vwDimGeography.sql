/* CreateDate: 01/08/2021 15:21:54.397 , ModifyDate: 01/08/2021 15:21:54.397 */
GO
CREATE VIEW [bi_ent_dds].[vwDimGeography]
AS
-------------------------------------------------------------------------
-- [vwDimGeography] is used to retrieve a
-- list of Geographys
--
--   SELECT * FROM [bi_ent_dds].[vwDimGeography]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

		SELECT	  [GeographyKey]
				, [PostalCode]
				, [CountryRegionDescription]
				, [CountryRegionDescriptionShort]
				, [StateProvinceDescription]
				, [StateProvinceDescriptionShort]
				, [City]
				, [RowIsCurrent]
				, [RowStartDate]
				, [RowEndDate]
		FROM [bi_ent_dds].[DimGeography]
		WHERE [GeographyKey] < 0	-- Don't return any records
GO
