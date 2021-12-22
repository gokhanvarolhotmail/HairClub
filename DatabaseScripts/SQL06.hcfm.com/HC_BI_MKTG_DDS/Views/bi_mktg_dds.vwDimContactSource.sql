/* CreateDate: 09/03/2021 09:37:08.110 , ModifyDate: 09/03/2021 09:37:08.110 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
