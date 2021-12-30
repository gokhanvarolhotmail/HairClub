/* CreateDate: 05/03/2010 12:08:49.170 , ModifyDate: 10/03/2019 21:37:24.993 */
GO
CREATE VIEW [bi_ent_dds].[vwDimCenterOwnership]
AS
-------------------------------------------------------------------------
-- [vwDimCenter] is used to retrieve a
-- list of Center Ownerships
--
--   SELECT * FROM [bi_ent_dds].[vwDimCenterOwnership]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	  [CenterOwnershipKey]
			, [CenterOwnershipSSID]
			, [CenterOwnershipDescription]
			, [CenterOwnershipDescriptionShort]
			, [OwnerLastName]
			, [OwnerFirstName]
			, [CorporateName]
			, [CenterAddress1]
			, [CenterAddress2]
			, [CountryRegionDescription]
			, [CountryRegionDescriptionShort]
			, [StateProvinceDescription]
			, [StateProvinceDescriptionShort]
			, [City]
			, [PostalCode]
			, [RowIsCurrent]
			, [RowStartDate]
			, [RowEndDate]
	FROM [bi_ent_dds].[DimCenterOwnership]
GO
