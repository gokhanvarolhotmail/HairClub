/* CreateDate: 09/03/2021 09:37:08.537 , ModifyDate: 09/03/2021 09:37:08.537 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_mktg_dds].[vwFactActivity]
AS
-------------------------------------------------------------------------
-- [vwFactActivity] is used to retrieve a
-- list of FactActivity
--
--   SELECT * FROM [bi_mktg_dds].[vwFactActivity]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/12/2009  RLifke       Initial Creation
--			10/02/2020  KMurdoch     Restricted to 2017 forward
-------------------------------------------------------------------------

	SELECT	   DD.[FullDate] AS [PartitionDate]
		      ,[ActivityDateKey]
			  ,[ActivityKey]
			  ,[ActivityTimeKey]
			  ,[ActivityCompletedDateKey]
			  ,[ActivityCompletedTimeKey]
			  ,[ActivityDueDateKey]
			  ,[ActivityStartTimeKey]
			  ,FA.[GenderKey]
			  ,FA.[EthnicityKey]
			  ,FA.[OccupationKey]
			  ,FA.[MaritalStatusKey]
			  ,FA.[AgeRangeKey]
			  ,FA.[HairLossTypeKey]
			  ,FA.[CenterKey]
			  ,FA.[ContactKey]
			  ,[ActionCodeKey]
			  ,[ResultCodeKey]
			  ,FA.[SourceKey]
			  ,[ActivityTypeKey]
			  ,[CompletedByEmployeeKey]
			  ,[StartedByEmployeeKey]
			  ,[ActivityEmployeeKey]
			  ,FL.SourceKey AS 'LeadSourceKey'
	FROM [bi_mktg_dds].[FactActivity] FA
	INNER JOIN bi_mktg_dds.FactLead AS FL
				ON FA.ContactKey = FL.ContactKey
	LEFT OUTER JOIN  [HC_BI_ENT_DDS].bief_dds.DimDate DD
			ON FA.[ActivityDateKey] = DD.[DateKey]
	WHERE ActivityDateKey >= 20170101
GO
