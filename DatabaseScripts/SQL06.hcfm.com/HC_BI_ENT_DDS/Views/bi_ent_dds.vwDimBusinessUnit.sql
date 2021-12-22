/* CreateDate: 01/08/2021 15:21:54.273 , ModifyDate: 01/08/2021 15:21:54.273 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
