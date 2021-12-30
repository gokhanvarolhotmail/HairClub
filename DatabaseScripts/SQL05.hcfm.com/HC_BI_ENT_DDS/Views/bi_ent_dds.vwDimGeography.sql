/* CreateDate: 05/03/2010 12:08:49.263 , ModifyDate: 10/03/2019 21:37:25.067 */
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
