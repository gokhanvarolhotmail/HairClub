/* CreateDate: 05/03/2010 12:08:49.140 , ModifyDate: 10/03/2019 21:37:24.963 */
GO
CREATE VIEW [bi_ent_dds].[vwDimBusinessUnitBrand]
AS
-------------------------------------------------------------------------
-- [vwDimBusinessUnitBrand] is used to retrieve a
-- list of Business Unit Brands
--
--   SELECT * FROM [bi_ent_dds].[vwDimBusinessUnitBrand]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT		  BusinessUnitBrandKey
				, BusinessUnitBrandSSID
				, BusinessUnitBrandDescription
				, BusinessUnitBrandDescriptionShort
				, RowIsCurrent
				, RowStartDate
				, RowEndDate
	FROM         bi_ent_dds.DimBusinessUnitBrand
GO
