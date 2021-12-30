/* CreateDate: 05/03/2010 12:21:10.903 , ModifyDate: 10/03/2019 21:54:30.443 */
GO
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
GO
