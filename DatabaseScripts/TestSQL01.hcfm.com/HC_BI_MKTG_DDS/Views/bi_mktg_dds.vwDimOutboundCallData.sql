/* CreateDate: 04/14/2020 13:49:12.640 , ModifyDate: 04/14/2020 13:49:12.640 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimOutboundCallData]
AS
-------------------------------------------------------------------------
-- [vwDimOutboundCallData] is used to retrieve a
-- list of Calls from the Noble dialer
--
--   SELECT * FROM [bi_mktg_dds].[vwDimOutboundCallData]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/14/2020  KMurdoch       Initial Creation
--
-------------------------------------------------------------------------

		SELECT [CallRecordKey]
			  ,[CallRecordSSID]
			  ,[CenterSSID]
			  ,[CallDate]
			  ,[CallTime]
			  ,[CallTypeSSID]
			  ,[CallTypeDescription]
			  ,[CallTypeGroup]
			  ,[InboundSourceSSID]
			  ,[InboundSourceDescription]
			  ,[LeadSourceSSID]
			  ,[LeadSourceDescription]
			  ,[CallStatusSSID]
			  ,[CallStatusDescription]
			  ,[CallPhoneNo]
			  ,[SFDC_LeadID]
			  ,[SFDC_TaskID]
			  ,[UsedBy]
			  ,[AdditionalCallStatusSSID]
			  ,[AdditionalCallStatusDescription]
			  ,[UserSSID]
			  ,[NobleUserSSID]
			  ,[IsViableCall]
			  ,[CallLength]
			  ,[RowTimeStamp]
		  FROM [bi_mktg_dds].[DimCallData]
		  WHERE CallTypeGroup = 'Outbound'
GO
