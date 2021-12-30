/* CreateDate: 04/14/2020 13:44:50.930 , ModifyDate: 04/14/2020 16:25:51.063 */
GO
CREATE VIEW [bi_mktg_dds].[vwDimInboundCallData]
AS
-------------------------------------------------------------------------
-- [vwDimInboundCallData] is used to retrieve a
-- list of Calls from the Noble dialer
--
--   SELECT * FROM [bi_mktg_dds].[vwDimInboundCallData]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/14/2020  KMurdoch       Initial Creation
--
-------------------------------------------------------------------------

		SELECT DCD.[CallRecordKey]
			  ,DCD.[CallRecordSSID]
			  ,DCD.[CenterSSID]
			  ,DCD.[CallDate]
			  ,ISNULL(DCD.[CallTime],'00:00:00') AS 'CallTime'
			  ,[CallTypeSSID]
			  ,[CallTypeDescription]
			  ,[CallTypeGroup]
			  ,ISNULL(DCD.[InboundSourceSSID],'Unknown') AS 'InboundSourceSSID'
			  ,ISNULL(DCD.[InboundSourceDescription], 'Unknown') AS 'InboundSourceDescription'
			  ,ISNULL(DS.Media,'Unknown') AS 'InbCallSource_Media'
			  ,ISNULL(DS.Level02Location, 'Unknown') AS 'IBSource_Location'
			  ,ISNULL(DS.Level03Language, 'Unknown') AS 'IBSource_Language'
			  ,ISNULL(DS.Level04Format, 'Unknown') AS 'IBSource_Format'
			  ,ISNULL(DS.Level05Creative, 'Unknown') AS 'IBSource_Creative'
			  ,ISNULL(DS.OwnerType, 'Unknown') AS 'IBSource_OwnerType'
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

		  FROM [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimCallData] DCD
		  LEFT OUTER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].DimSource DS
			 ON DCD.InboundSourceSSID = DS.SourceSSID
		  WHERE CallTypeGroup = 'Inbound'
GO
