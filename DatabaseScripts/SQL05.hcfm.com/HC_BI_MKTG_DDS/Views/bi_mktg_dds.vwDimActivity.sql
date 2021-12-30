/* CreateDate: 05/03/2010 12:21:10.723 , ModifyDate: 10/03/2019 21:54:30.287 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimActivity]
AS
-------------------------------------------------------------------------
-- [vwDimActivity] is used to retrieve a
-- list of Activity
--
--   SELECT * FROM [bi_mktg_dds].[vwDimActivity]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			08/07/2019  KMurdoch     Removed Activity & Contact SSID
-------------------------------------------------------------------------

	SELECT	   [ActivityKey]
			--,[ActivitySSID]
			,[ActivityDueDate]
			,[ActivityStartTime]
			,[ActivityCompletionDate]
			,[ActivityCompletionTime]
			,[ActionCodeSSID]
			,[ActionCodeDescription]
			,[ResultCodeSSID]
			,[ResultCodeDescription]
			,[SourceSSID]
			,[SourceDescription]
			,[CenterSSID]
			--,[ContactSSID]
			,[SalesTypeSSID]
			,[SalesTypeDescription]
			,[ActivityTypeSSID]
			,[ActivityTypeDescription]
			,[TimeZoneSSID]
			,[TimeZoneDescription]
			,[GreenwichOffset]
			,[PromotionCodeSSID]
			,[PromotionCodeDescription]
			,[IsAppointment]
			,[IsShow]
			,[IsNoShow]
			,[IsSale]
			,[IsNoSale]
			,[IsConsultation]
			,[IsBeBack]
			,[RowIsCurrent]
			,[RowStartDate]
			,[RowEndDate]
			,[SFDC_TaskID]
			,[SFDC_LeadID]
	FROM [bi_mktg_dds].[DimActivity]
GO
