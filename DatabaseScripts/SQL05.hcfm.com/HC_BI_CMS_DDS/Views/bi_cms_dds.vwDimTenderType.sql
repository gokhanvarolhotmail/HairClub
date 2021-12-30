/* CreateDate: 05/03/2010 12:17:24.547 , ModifyDate: 10/03/2019 22:52:22.690 */
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
