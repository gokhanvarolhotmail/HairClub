CREATE VIEW [bi_mktg_dds].[vwDimActionCode]
AS
-------------------------------------------------------------------------
-- [vwDimActionCode] is used to retrieve a
-- list of ActionCode
--
--   SELECT * FROM [bi_mktg_dds].[vwDimActionCode]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	   [ActionCodeKey]
			  ,[ActionCodeSSID]
			  ,[ActionCodeDescription]
			  ,[ActionCodeDescriptionShort]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_mktg_dds].[DimActionCode]
