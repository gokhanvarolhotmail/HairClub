/* CreateDate: 01/08/2021 15:21:54.330 , ModifyDate: 01/08/2021 15:21:54.330 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_ent_dds].[vwDimCenterType]
AS
-------------------------------------------------------------------------
-- [vwDimCenterType] is used to retrieve a
-- list of Center Types
--
--   SELECT * FROM [bi_ent_dds].[vwDimCenterType]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	  [CenterTypeKey]
			, [CenterTypeSSID]
			, [CenterTypeDescription]
			, [CenterTypeDescriptionShort]
			, [RowIsCurrent]
			, [RowStartDate]
			, [RowEndDate]
	FROM [bi_ent_dds].[DimCenterType]
GO
