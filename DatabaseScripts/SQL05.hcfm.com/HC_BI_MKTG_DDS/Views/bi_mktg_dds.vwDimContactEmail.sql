/* CreateDate: 05/03/2010 12:21:10.833 , ModifyDate: 10/03/2019 21:54:30.373 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimContactEmail]
AS
-------------------------------------------------------------------------
-- [vwDimContactEmail] is used to retrieve a
-- list of ContactEmail
--
--   SELECT * FROM [bi_mktg_dds].[vwDimContactEmail]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			08/07/2019  KMurdoch     Added SFDC Lead/LeadEmailID;removed Contactssid
-------------------------------------------------------------------------

	SELECT	   [ContactEmailKey]
			  ,[ContactEmailSSID]
			  --,[ContactSSID]
			  ,[SFDC_LeadID]
			  ,[SFDC_LeadEmailID]
			  ,[EmailTypeCode]
			  ,[Email]
			  ,[Description]
			  ,[PrimaryFlag]
			  ,[RowIsCurrent]
			  ,[RowStartDate]
			  ,[RowEndDate]
	FROM [bi_mktg_dds].[DimContactEmail]
GO
