/* CreateDate: 05/03/2010 12:08:49.127 , ModifyDate: 10/03/2019 21:37:24.953 */
GO
CREATE VIEW [bi_ent_dds].[vwDimBusinessUnit]
AS
-------------------------------------------------------------------------
-- [vwDimBusinessUnit] is used to retrieve a
-- list of Business Units
--
--   SELECT * FROM [bi_ent_dds].[vwDimBusinessUnit]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT		  BusinessUnitKey
				, BusinessUnitSSID
				, BusinessUnitDescription
				, BusinessUnitDescriptionShort
				, BusinessUnitBrandKey
				, BusinessUnitBrandSSID
				, RowIsCurrent
				, RowStartDate
				, RowEndDate
	FROM         bi_ent_dds.DimBusinessUnit
GO
