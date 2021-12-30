/* CreateDate: 05/03/2010 12:21:10.870 , ModifyDate: 10/03/2019 21:54:30.400 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimContactSource]
AS
-------------------------------------------------------------------------
-- [vwDimContactSource] is used to retrieve a
-- list of ContactSource
--
--   SELECT * FROM [bi_mktg_dds].[vwDimContactSource]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			08/07/2019  KMurdoch     Added SFDC LeadID; removed Contactssid
-------------------------------------------------------------------------

	SELECT	   [ContactSourceKey]
			  ,[ContactSourceSSID]
			  --,[ContactSSID]
			  ,[SFDC_LeadID]
			  ,[SourceCode]
			  ,[MediaCode]
			  ,[AssignmentDate]
			  ,[AssignmentTime]
			  ,[PrimaryFlag]
			  ,[DNIS_Number]
			  ,[SubSourceCode]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_mktg_dds].[DimContactSource]
GO
