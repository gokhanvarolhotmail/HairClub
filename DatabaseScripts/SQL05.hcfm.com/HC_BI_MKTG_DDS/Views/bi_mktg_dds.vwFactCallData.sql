/* CreateDate: 05/19/2020 13:55:41.150 , ModifyDate: 09/29/2020 11:17:33.540 */
GO
CREATE VIEW [bi_mktg_dds].[vwFactCallData]
AS
-------------------------------------------------------------------------
-- [vwFactCallData] is used to retrieve a
-- list of Calls from the Noble dialer
--
--   SELECT * FROM [bi_mktg_dds].[vwDimCallData]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    05/19/2020  KMurdoch       Initial Creation
--			09/14/2020	KMurdoch       Modified to use Bright Pattern
--			09/23/2020  KMurdoch       Added new Measures to break down calls
--			09/29/2020  KMurdoch	   Modified view for Abandons and System Disconnect
-------------------------------------------------------------------------

SELECT fcd.[Call_RecordKey],
       [Call_DateKey],
       [Call_TimeKey],
       [InboundSourceKey],
       [ContactKey],
       [ActivityKey],
       ISNULL(ds.SourceKey, -1) AS 'LeadSourceKey',
       fcd.[Is_Viable_Call],
       fcd.[Is_Productive_Call],
       fcd.[Call_Length],
       fcd.[IVR_Time],
       fcd.[Queue_Time],
       fcd.[Pending_Time],
       fcd.[Talk_Time],
       fcd.[Hold_Time],
	   CASE WHEN dcd.System_Disposition IN ( 'Abandoned_Queue','Abandoned_Ringing') THEN 1 ELSE 0 END AS 'IsAbandoned',
	   CASE WHEN dcd.System_Disposition IN ('System_Disconnected','Abandoned') THEN 1 ELSE 0 END AS 'IsNonResponsiveCaller',
	   CASE WHEN (dcd.System_Disposition NOT LIKE 'Abandon%' AND dcd.System_Disposition NOT LIKE 'System_Disconn%') AND dcd.Talk_Time > 60 THEN 1 ELSE 0 END AS 'IsQualified',
	   CASE WHEN (dcd.System_Disposition NOT LIKE 'Abandon%' AND dcd.System_Disposition NOT LIKE 'System_Disconn%') AND dcd.Talk_Time < 60 THEN 1 ELSE 0 END AS 'IsNonQualified',
       1 AS 'CallCount'
FROM [bi_mktg_dds].[FactCallDataBP] fcd
    INNER JOIN bi_mktg_dds.vwDimCallData dcd
        ON dcd.Call_RecordKey = fcd.Call_RecordKey
    LEFT OUTER JOIN bi_mktg_dds.DimSource ds
        ON dcd.LeadSourceSSID = ds.SourceSSID;
GO
