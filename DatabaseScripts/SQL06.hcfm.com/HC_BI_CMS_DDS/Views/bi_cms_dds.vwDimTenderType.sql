/* CreateDate: 10/03/2019 23:03:43.953 , ModifyDate: 10/03/2019 23:03:43.953 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwDimTenderType]
AS
-------------------------------------------------------------------------
-- [vwDimTenderType] is used to retrieve a
-- list of Tender Types
--
--   SELECT * FROM [bi_cms_dds].[vwDimTenderType]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

		SELECT	  [TenderTypeKey]
				, [TenderTypeSSID]
				, [TenderTypeDescription]
				, [TenderTypeDescriptionShort]
				, [MaxOccurrences]
				, [RowIsCurrent]
				, [RowStartDate]
				, [RowEndDate]
		FROM [bi_cms_dds].[DimTenderType]
GO
