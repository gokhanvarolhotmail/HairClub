/* CreateDate: 08/21/2020 12:52:09.270 , ModifyDate: 08/21/2020 12:52:09.270 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW dbo.[vwDimCallData]
AS
-------------------------------------------------------------------------
-- [vwDimCallData] is used to retrieve a
-- list of Calls from the Noble dialer
--
--   SELECT * FROM [bi_mktg_dds].[vwDimCallData]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/14/2020  KMurdoch       Initial Creation
--
-------------------------------------------------------------------------

SELECT [CallRecordKey],
       [CallRecordSSID],
       [CenterSSID],
       [CallDate],
       [CallTime],
       [CallTypeSSID],
       [CallTypeDescription],
       [CallTypeGroup],
       [TollFreeNumber],
       [InboundSourceSSID],
       [InboundSourceDescription],
       [LeadSourceSSID],
       [LeadSourceDescription],
       [CallStatusSSID],
       [CallStatusDescription],
       [CallPhoneNo],
       [SFDC_LeadID],
       [SFDC_TaskID],
       [UsedBy],
       [AdditionalCallStatusSSID],
       [AdditionalCallStatusDescription],
       CASE WHEN [UserSSID] = '' THEN 'Unknown' ELSE ISNULL(dcd.UserSSID, 'Unknown') END AS 'UserSSID',
	   CASE WHEN [NobleUserSSID] = '' THEN 'Unknown' ELSE ISNULL(dcd.[NobleUserSSID], 'Unknown') END AS 'NobleUserSSID',
	   CASE WHEN LEFT(dcd.NobleUserSSID, 1) = 'L' THEN 'ListenTrust' ELSE 'HairClub' END AS 'CallCenter',
       IBCP.SourceCode_L__c AS 'InboundCampaign',
       LDCP.SourceCode_L__c AS 'LeadCampaign',
       TSCP.SourceCode_L__c AS 'TaskCampaign',
       [IsViableCall],
       [CallLength],
	   ISNULL([dcd].[UserFullName], 'Unknown') AS 'AgentName'
FROM HC_BI_MKTG_DDS.[bi_mktg_dds].[DimCallData] dcd
    LEFT OUTER JOIN HC_BI_SFDC.dbo.Campaign IBCP
        ON dcd.InboundCampaignID = IBCP.Id
    LEFT OUTER JOIN HC_BI_SFDC.dbo.Campaign LDCP
        ON dcd.LeadCampaignID = LDCP.SourceCode_L__c
    LEFT OUTER JOIN HC_BI_SFDC.dbo.Campaign TSCP
        ON dcd.TaskCampaignID = TSCP.SourceCode_L__c
	--LEFT OUTER JOIN HC_Marketing.[dbo].[lkpNobleTSR] tsr
	--	ON dcd.NobleUserSSID = tsr.tsrid;
GO
