/* CreateDate: 09/03/2021 09:37:08.020 , ModifyDate: 09/03/2021 09:37:08.020 */
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
