CREATE VIEW [bi_mktg_dds].[vwDimResultCode]
AS
-------------------------------------------------------------------------
-- [vwDimResultCode] is used to retrieve a
-- list of ResultCode
--
--   SELECT * FROM [bi_mktg_dds].[vwDimResultCode]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	   [ResultCodeKey]
			  ,[ResultCodeSSID]
			  ,[ResultCodeDescription]
			  ,[ResultCodeDescriptionShort]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_mktg_dds].[DimResultCode]
