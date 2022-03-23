/* CreateDate: 03/17/2022 11:57:12.457 , ModifyDate: 03/17/2022 11:57:12.457 */
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
