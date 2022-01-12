/*SELECT
    GETDATE() AS [Now]
  , [database_name]
  , [schema_name]
  , [table_name]
  , [distribution_policy_name]
  , [distribution_column]
  , [index_type_desc]
  , [nbr_partitions]
  , [table_row_count]
  , [table_reserved_space_GB]
  , [table_data_space_GB]
  , [table_index_space_GB]
  , [table_unused_space_GB]
FROM [microsoft].[vw_table_space_summary]
ORDER BY [schema_name]
       , [table_name] ;
*/
USE Temporary
GO
-- DROP TABLE [dbo].[hc_eim_prod2_sql_pool_Tables]
IF OBJECT_ID('[dbo].[hc_eim_prod2_sql_pool_Tables]') IS NULL
begin
CREATE TABLE [dbo].[hc_eim_prod2_sql_pool_Tables] (
	[Now] datetime2(3) NULL,
	[database_name] varchar(128) NOT NULL,
	[schema_name] varchar(128) NOT NULL,
	[table_name] varchar(128) NOT NULL,
	[distribution_policy_name] varchar(128) NOT NULL,
	[distribution_column] varchar(128) NULL,
	[index_type_desc] varchar(128) NOT NULL,
	[nbr_partitions] int NOT NULL,
	[table_row_count] int NOT NULL,
	[table_reserved_space_GB] NUMERIC(20,12) NOT NULL,
	[table_data_space_GB] NUMERIC(20,12)  NOT NULL,
	[table_index_space_GB] NUMERIC(20,12)  NOT NULL,
	[table_unused_space_GB] NUMERIC(20,12) NOT NULL)
CREATE UNIQUE CLUSTERED INDEX indx ON [dbo].[hc_eim_prod2_sql_pool_Tables] ([table_name],[schema_name],[database_name],[Now])
end
GO
INSERT [dbo].[hc_eim_prod2_sql_pool_Tables]
SELECT
	CAST([Now] AS datetime2(3)) as [Now], [database_name], [schema_name], [table_name], [distribution_policy_name], [distribution_column], [index_type_desc], [nbr_partitions], [table_row_count], [table_reserved_space_GB], [table_data_space_GB], [table_index_space_GB], [table_unused_space_GB]
FROM (VALUES
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'Dim', 'REPLICATE', NULL, 'CLUSTERED', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimAccount', 'REPLICATE', NULL, 'CLUSTERED', 1, 797318, '0.395040000', '0.335200000', '0.004448000', '0.055392000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimAgency', 'REPLICATE', NULL, 'CLUSTERED', 1, 80, '0.004608000', '0.000512000', '0.000512000', '0.003584000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimAgentDisposition', 'REPLICATE', NULL, 'CLUSTERED', 1, 122, '0.005904000', '0.000656000', '0.000656000', '0.004592000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimAppointmentType', 'REPLICATE', NULL, 'CLUSTERED', 1, 10, '0.000720000', '0.000080000', '0.000080000', '0.000560000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimAudience', 'REPLICATE', NULL, 'CLUSTERED', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimBudget', 'REPLICATE', NULL, 'CLUSTERED', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimCallType', 'REPLICATE', NULL, 'CLUSTERED', 1, 8, '0.000576000', '0.000064000', '0.000064000', '0.000448000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimCampaign', 'REPLICATE', NULL, 'CLUSTERED', 1, 43680, '0.027120000', '0.014880000', '0.002864000', '0.009376000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimCenter', 'REPLICATE', NULL, 'CLUSTERED', 1, 604, '0.003456000', '0.000384000', '0.000384000', '0.002688000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimCenter_copy', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 600, '0.017280000', '0.002880000', '0.000960000', '0.013440000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimCenterServiceTerritory', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 252, '0.003024000', '0.000336000', '0.000336000', '0.002352000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimChannel', 'REPLICATE', NULL, 'CLUSTERED', 1, 16, '0.002016000', '0.000224000', '0.000224000', '0.001568000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimCompany', 'REPLICATE', NULL, 'CLUSTERED', 1, 20, '0.001296000', '0.000144000', '0.000144000', '0.001008000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimCurrency', 'REPLICATE', NULL, 'CLUSTERED', 1, 4, '0.000288000', '0.000032000', '0.000032000', '0.000224000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimCustomer', 'REPLICATE', NULL, 'CLUSTERED', 1, 1404664, '0.298784000', '0.263456000', '0.004064000', '0.031264000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimCustomerMembership', 'REPLICATE', NULL, 'CLUSTERED', 1, 3213260, '1.023808000', '0.947168000', '0.007616000', '0.069024000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimDate', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 16086, '0.033600000', '0.016560000', '0.001920000', '0.015120000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimDimMeetingPlatform', 'REPLICATE', NULL, 'CLUSTERED', 1, 2, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimEthnicity', 'REPLICATE', NULL, 'CLUSTERED', 1, 38, '0.002448000', '0.000272000', '0.000272000', '0.001904000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimFormat', 'REPLICATE', NULL, 'CLUSTERED', 1, 184, '0.007488000', '0.000832000', '0.000832000', '0.005824000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimFunnelStep', 'REPLICATE', NULL, 'CLUSTERED', 1, 26, '0.000288000', '0.000032000', '0.000032000', '0.000224000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimGender', 'REPLICATE', NULL, 'CLUSTERED', 1, 10, '0.000432000', '0.000048000', '0.000048000', '0.000336000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimGeography', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 84464, '0.041424000', '0.023200000', '0.001936000', '0.016288000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimGeography_copy', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 84462, '0.051088000', '0.025024000', '0.002576000', '0.023488000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimHairLossScale', 'REPLICATE', NULL, 'CLUSTERED', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimLanguage', 'REPLICATE', NULL, 'CLUSTERED', 1, 10, '0.000576000', '0.000064000', '0.000064000', '0.000448000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimLead', 'REPLICATE', NULL, 'CLUSTERED', 1, 1428396, '0.907520000', '0.665760000', '0.009600000', '0.232160000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimLeadCopy', 'REPLICATE', NULL, 'CLUSTERED', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimLeadCopy_10012021', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 1246350, '0.856032000', '0.820192000', '0.005600000', '0.030240000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimLeadCopyNick', 'REPLICATE', NULL, 'CLUSTERED', 1, 977202, '0.270992000', '0.260816000', '0.004816000', '0.005360000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimLocation', 'REPLICATE', NULL, 'CLUSTERED', 1, 42, '0.002880000', '0.000320000', '0.000320000', '0.002240000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimLossReason', 'REPLICATE', NULL, 'CLUSTERED', 1, 10, '0.000720000', '0.000080000', '0.000080000', '0.000560000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimMaritalStatus', 'REPLICATE', NULL, 'CLUSTERED', 1, 12, '0.000864000', '0.000096000', '0.000096000', '0.000672000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimMarketingFee', 'REPLICATE', NULL, 'CLUSTERED', 1, 352, '0.003312000', '0.000368000', '0.000368000', '0.002576000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimMedia', 'REPLICATE', NULL, 'CLUSTERED', 1, 60, '0.001296000', '0.000144000', '0.000144000', '0.001008000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimMedium', 'REPLICATE', NULL, 'CLUSTERED', 1, 10, '0.000720000', '0.000080000', '0.000080000', '0.000560000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimMeetingPlatform', 'REPLICATE', NULL, 'CLUSTERED', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimMembership', 'REPLICATE', NULL, 'CLUSTERED', 1, 438, '0.001872000', '0.000208000', '0.000208000', '0.001456000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimMethod', 'REPLICATE', NULL, 'CLUSTERED', 1, 6, '0.000432000', '0.000048000', '0.000048000', '0.000336000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimOccupation', 'REPLICATE', NULL, 'CLUSTERED', 1, 40, '0.006768000', '0.000752000', '0.000752000', '0.005264000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimPromotion', 'REPLICATE', NULL, 'CLUSTERED', 1, 502, '0.002592000', '0.000288000', '0.000288000', '0.002016000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimPurpose', 'REPLICATE', NULL, 'CLUSTERED', 1, 12, '0.000864000', '0.000096000', '0.000096000', '0.000672000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimResult', 'REPLICATE', NULL, 'CLUSTERED', 1, 3434934, '0.224656000', '0.219776000', '0.002896000', '0.001984000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimSalesCode', 'REPLICATE', NULL, 'CLUSTERED', 1, 4038, '0.006336000', '0.000768000', '0.000768000', '0.004800000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimSalesCodeDepartment', 'REPLICATE', NULL, 'CLUSTERED', 1, 114, '0.000720000', '0.000080000', '0.000080000', '0.000560000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimSalesOrderType', 'REPLICATE', NULL, 'CLUSTERED', 1, 12, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimScenario', 'REPLICATE', NULL, 'CLUSTERED', 1, 40, '0.002160000', '0.000240000', '0.000240000', '0.001680000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimService', 'REPLICATE', NULL, 'CLUSTERED', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimSource', 'REPLICATE', NULL, 'CLUSTERED', 1, 36, '0.001872000', '0.000208000', '0.000208000', '0.001456000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimStatus', 'REPLICATE', NULL, 'CLUSTERED', 1, 62, '0.002304000', '0.000256000', '0.000256000', '0.001792000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimSystemUser', 'REPLICATE', NULL, 'CLUSTERED', 1, 15774, '0.009456000', '0.004736000', '0.001968000', '0.002752000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimSystemUserBackUp', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 15416, '0.032688000', '0.005760000', '0.001968000', '0.024960000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimTactic', 'REPLICATE', NULL, 'CLUSTERED', 1, 14, '0.001008000', '0.000112000', '0.000112000', '0.000784000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimTemplate', 'REPLICATE', NULL, 'CLUSTERED', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimTimeOfDay', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 172800, '0.045312000', '0.023888000', '0.002880000', '0.018544000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'DimWorkType', 'REPLICATE', NULL, 'CLUSTERED', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactAppointment', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 3799862, '1.777600000', '1.468272000', '0.017584000', '0.291744000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactAppointmentCopy_10012021', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 3748656, '1.495536000', '1.461632000', '0.008880000', '0.025024000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactAppointmentTest', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 262296, '0.132480000', '0.112160000', '0.002880000', '0.017440000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactAppointmentTestDups', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 262276, '0.132480000', '0.111568000', '0.002880000', '0.018032000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactAppointmentTracking', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 3813802, '1.697536000', '1.545184000', '0.016224000', '0.136128000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactAppointmentTrackingCopy_10012021', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 3720414, '1.489648000', '1.454832000', '0.009008000', '0.025808000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'factAppointmentTrakingBackUp', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 3720414, '1.488128000', '1.454048000', '0.008768000', '0.025312000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactCallDetail', 'ROUND_ROBIN', NULL, 'HEAP', 1, 3864652, '0.819200000', '0.605872000', '0.003840000', '0.209488000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactCampaignHistory', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 1933966, '1.202160000', '0.890000000', '0.009856000', '0.302304000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactCancellations', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 5286, '0.008640000', '0.001984000', '0.001920000', '0.004736000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactFunnel', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 9250156, '0.440384000', '0.440384000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactLeadTracking', 'REPLICATE', NULL, 'CLUSTERED', 1, 7224632, '3.295360000', '3.254960000', '0.027840000', '0.012560000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactLeadTracking12072021', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 7183118, '1.413184000', '1.406464000', '0.000000000', '0.006720000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactLeadTrackingBU', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 6969698, '1.213120000', '1.206400000', '0.000000000', '0.006720000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactLeadTrackingCopy_10012021', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 6972900, '1.213632000', '1.206912000', '0.000000000', '0.006720000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactLeadTrackingCopy12072021', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 0, '0.008640000', '0.001920000', '0.000000000', '0.006720000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactLeadTrackingtemp', 'REPLICATE', NULL, 'CLUSTERED', 1, 6713048, '1.539296000', '1.516240000', '0.011936000', '0.011120000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactMarketingActivity', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 151086, '0.264192000', '0.144000000', '0.004960000', '0.115232000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactMarketingBudget', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 624, '0.004608000', '0.000512000', '0.000512000', '0.003584000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactOpportunity', 'HASH', 'OpportunityId', 'CLUSTERED COLUMNSTORE', 1, 442564, '0.268992000', '0.167280000', '0.004800000', '0.096912000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactOpportunityCopy_10012021', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 424882, '0.141136000', '0.115712000', '0.002896000', '0.022528000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactOpportunityTracking', 'HASH', 'OpportunityId', 'CLUSTERED COLUMNSTORE', 1, 440970, '0.157040000', '0.119136000', '0.003760000', '0.034144000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactOpportunityTrackingCopy_10012021', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 418462, '0.141104000', '0.113888000', '0.002864000', '0.024352000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactSalesTransaction', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 71088048, '11.124464000', '10.647600000', '0.014416000', '0.462448000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactTrackingAppt20210819', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 3716770, '1.469568000', '1.432960000', '0.008640000', '0.027968000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'FactTrackingLead20210819', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 6866578, '1.204720000', '1.198000000', '0.000000000', '0.006720000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'LeadCopyBB', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 1298092, '0.887024000', '0.853072000', '0.005744000', '0.028208000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'LeadsWithoutCampaign', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 32040, '0.023488000', '0.004080000', '0.001920000', '0.017488000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2064_c7f9828591d44547923504ce05853300', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2065_255c5c44786e4d0b8941a6e740c89894', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2066_e8a03cc8186c45428cb97090406af123', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2067_32d034052c28423eb4399515190ef452', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2067_b291687ae88342c399f51cc603e16ed8', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2090_f74b610a1eca471a852dca5ae61570b0', 'ROUND_ROBIN', NULL, 'HEAP', 1, 69888854, '20.730880000', '20.720144000', '0.003840000', '0.006896000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2093_4b4eac2a7d2f4972ae489834b09e64b7', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2099_e4a753cc1d1341a58533a2395d43f0e0', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2102_3f7135a689b14bbe81810ff0c6581a22', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2102_75021cc182cc4dc8a5966aee51760dea', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2103_6875adb2bf304bca9a6f24c2090254e5', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2103_e3c2ccdb744740aaa37d843d6d05e42f', 'ROUND_ROBIN', NULL, 'HEAP', 1, 69906678, '35.678848000', '35.668192000', '0.003840000', '0.006816000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2104_15e144674ed24f1db93c603d198a7a30', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_2351_af06704bbeed487eb52086cef001250e', 'ROUND_ROBIN', NULL, 'HEAP', 1, 3690366, '0.832368000', '0.827776000', '0.002416000', '0.002176000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'dbo', 'T_5184_38e46005aaa9412fa0bdc6d5a1c0e02c', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'AssignedResource', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 250242, '0.146752000', '0.080624000', '0.004960000', '0.061168000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'BP_Agents', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 632, '0.009040000', '0.001984000', '0.000032000', '0.007024000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'BP_AgentsActivity', 'ROUND_ROBIN', NULL, 'HEAP', 1, 9358518, '2.555648000', '1.910080000', '0.003840000', '0.641728000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'BP_AgentsDisposition', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 122, '0.010944000', '0.002176000', '0.000256000', '0.008512000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'BP_CallDetail', 'ROUND_ROBIN', NULL, 'HEAP', 1, 3864652, '2.913552000', '2.236720000', '0.003840000', '0.672992000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_Center', 'ROUND_ROBIN', NULL, 'HEAP', 1, 602, '0.001296000', '0.000288000', '0.000144000', '0.000864000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_CenterOwnership', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 32, '0.008784000', '0.001936000', '0.000016000', '0.006832000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_CenterType', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 20, '0.008784000', '0.001936000', '0.000016000', '0.006832000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_cfgAccumulator', 'ROUND_ROBIN', NULL, 'HEAP', 1, 108, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_cfgCenterManagementArea', 'ROUND_ROBIN', NULL, 'HEAP', 1, 62, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_cfgConfigurationCenter', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 594, '0.001152000', '0.000320000', '0.000224000', '0.000608000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_cfgMembership', 'ROUND_ROBIN', NULL, 'HEAP', 1, 444, '0.000720000', '0.000112000', '0.000080000', '0.000528000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_cfgMembershipPromotion', 'ROUND_ROBIN', NULL, 'HEAP', 1, 452, '0.000560000', '0.000272000', '0.000048000', '0.000240000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_cfgSalesCode', 'ROUND_ROBIN', NULL, 'HEAP', 1, 4044, '0.003888000', '0.001024000', '0.000432000', '0.002432000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_cfgVendor', 'ROUND_ROBIN', NULL, 'HEAP', 1, 56, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_ConnectLogs', 'ROUND_ROBIN', NULL, 'HEAP', 1, 271724, '0.198768000', '0.139408000', '0.003824000', '0.055536000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_datAccumulatorAdjustment', 'ROUND_ROBIN', NULL, 'HEAP', 1, 101185756, '18.152960000', '17.653232000', '0.003840000', '0.495888000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_datAppointment', 'HASH', 'SalesforceTaskID', 'CLUSTERED COLUMNSTORE', 1, 23257184, '3.330672000', '3.136240000', '0.008240000', '0.186192000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_datAppointmentDetail', 'HASH', 'AppointmentGUID', 'CLUSTERED COLUMNSTORE', 1, 26685278, '1.616800000', '1.509120000', '0.009728000', '0.097952000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_datAppointmentEmployee', 'HASH', 'AppointmentGUID', 'CLUSTERED COLUMNSTORE', 1, 22060098, '1.108976000', '1.093968000', '0.002032000', '0.012976000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_datClient', 'ROUND_ROBIN', NULL, 'HEAP', 1, 1406988, '0.617408000', '0.519296000', '0.003776000', '0.094336000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_datClientMembership', 'ROUND_ROBIN', NULL, 'HEAP', 1, 3216418, '0.696256000', '0.587328000', '0.003776000', '0.105152000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_DatEmployee', 'ROUND_ROBIN', NULL, 'HEAP', 1, 13078, '0.012224000', '0.005056000', '0.001216000', '0.005952000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_datSalesOrder', 'ROUND_ROBIN', NULL, 'HEAP', 1, 47469976, '13.647232000', '13.518208000', '0.003840000', '0.125184000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_datSalesOrderDetail', 'ROUND_ROBIN', NULL, 'HEAP', 1, 71746386, '23.392896000', '23.112496000', '0.003840000', '0.276560000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_Gender', 'ROUND_ROBIN', NULL, 'HEAP', 1, 4, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpAccumulatorActionType', 'ROUND_ROBIN', NULL, 'HEAP', 1, 6, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpAccumulatorAdjustmentType', 'ROUND_ROBIN', NULL, 'HEAP', 1, 16, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpAccumulatorDataType', 'ROUND_ROBIN', NULL, 'HEAP', 1, 10, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpBusinessSegment', 'ROUND_ROBIN', NULL, 'HEAP', 1, 14, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpClientMembershipStatus', 'ROUND_ROBIN', NULL, 'HEAP', 1, 20, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpCountry', 'ROUND_ROBIN', NULL, 'HEAP', 1, 16, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpEthnicity', 'ROUND_ROBIN', NULL, 'HEAP', 1, 14, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpGeneralLedger', 'ROUND_ROBIN', NULL, 'HEAP', 1, 82, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpLanguage', 'ROUND_ROBIN', NULL, 'HEAP', 1, 6, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpMaritalStatus', 'ROUND_ROBIN', NULL, 'HEAP', 1, 12, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpMembershipOrderReason', 'ROUND_ROBIN', NULL, 'HEAP', 1, 112, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpOccupation', 'ROUND_ROBIN', NULL, 'HEAP', 1, 38, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpPhoneType', 'ROUND_ROBIN', NULL, 'HEAP', 1, 12, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpSalesCodeDepartment', 'ROUND_ROBIN', NULL, 'HEAP', 1, 114, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpSalesCodeDivision', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 12, '0.008784000', '0.001936000', '0.000016000', '0.006832000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpSalesCodeType', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 12, '0.008784000', '0.001936000', '0.000016000', '0.006832000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpSalesOrderType', 'ROUND_ROBIN', NULL, 'HEAP', 1, 12, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpSalutation', 'ROUND_ROBIN', NULL, 'HEAP', 1, 8, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpState', 'ROUND_ROBIN', NULL, 'HEAP', 1, 142, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_lkpTimeZone', 'ROUND_ROBIN', NULL, 'HEAP', 1, 24, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_PaymentSalesCode', 'ROUND_ROBIN', NULL, 'HEAP', 1, 3576, '0.002880000', '0.000752000', '0.000320000', '0.001808000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_RevenueGroup', 'ROUND_ROBIN', NULL, 'HEAP', 1, 14, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'CNCT_SalesType', 'ROUND_ROBIN', NULL, 'HEAP', 1, 12, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'Datorama_SocialMedia', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 2258256, '0.954496000', '0.701936000', '0.006720000', '0.245840000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'ExcelDim_Performer', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 2158, '0.011808000', '0.002272000', '0.000352000', '0.009184000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'MA_Targets', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 690, '0.007632000', '0.000848000', '0.000848000', '0.005936000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'MA_Television', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 9495334, '2.443056000', '2.074768000', '0.010752000', '0.357536000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'NBSalesAugustValidationm', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 314672, '0.095456000', '0.067952000', '0.002912000', '0.024592000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'OLD_Prod_SFDC_Lead', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 6742934, '7.027584000', '6.975952000', '0.020736000', '0.030896000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'ServiceResource', 'ROUND_ROBIN', NULL, 'HEAP', 1, 542, '0.006032000', '0.000880000', '0.000656000', '0.004496000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_Account', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 797536, '1.022448000', '0.747392000', '0.010832000', '0.264224000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_AccountHistory', 'ROUND_ROBIN', NULL, 'HEAP', 1, 2934932, '0.434944000', '0.275200000', '0.003840000', '0.155904000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_Campaign', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 44378, '0.064352000', '0.038560000', '0.003872000', '0.021920000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_CampaignMember', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 1957436, '1.089408000', '0.803824000', '0.009872000', '0.275712000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_Event', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 754176, '0.764992000', '0.605680000', '0.007440000', '0.151872000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_Lead', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 1413570, '1.410880000', '1.035216000', '0.021152000', '0.354512000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_LeadHistory', 'ROUND_ROBIN', NULL, 'HEAP', 1, 1258354, '0.331904000', '0.239408000', '0.003840000', '0.088656000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_Opportunity', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 442484, '0.361344000', '0.271920000', '0.004800000', '0.084624000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_OpportunityHistory', 'ROUND_ROBIN', NULL, 'HEAP', 1, 71682, '0.034832000', '0.019440000', '0.002576000', '0.012816000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_Order', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 0, '0.008640000', '0.001920000', '0.000000000', '0.006720000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_Product', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 0, '0.008640000', '0.001920000', '0.000000000', '0.006720000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_PromoCode', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 262, '0.000864000', '0.000208000', '0.000128000', '0.000528000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_ServiceAppointment', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 302438, '0.330432000', '0.231072000', '0.004880000', '0.094480000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_ServiceAppointmentHistory', 'ROUND_ROBIN', NULL, 'HEAP', 1, 459324, '0.098960000', '0.065008000', '0.003600000', '0.030352000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_ServiceTerritory', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 252, '0.001008000', '0.000368000', '0.000224000', '0.000416000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_Task', 'ROUND_ROBIN', NULL, 'HEAP', 1, 8276394, '3.795008000', '2.949072000', '0.003840000', '0.842096000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_TollFree', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 5482, '0.021264000', '0.006160000', '0.002144000', '0.012960000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_User', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 2702, '0.017152000', '0.005776000', '0.001360000', '0.010016000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SF_WorkType', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 4, '0.008784000', '0.001936000', '0.000016000', '0.006832000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SFDC_Campaign_Old_Prod', 'HASH', 'Id', 'CLUSTERED COLUMNSTORE', 1, 32042, '0.063616000', '0.037744000', '0.002176000', '0.023696000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SQL06_FactSalesTransaction', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 68094462, '7.656528000', '6.938960000', '0.013584000', '0.703984000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SQL06_SFDC_Lead', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 620890, '0.440064000', '0.433648000', '0.002752000', '0.003664000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'SQL06_SFDC_Task', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 2161402, '1.147264000', '1.117488000', '0.008048000', '0.021728000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'T_2066_62c75eb5e9914f3ab290617b8920500e', 'ROUND_ROBIN', NULL, 'HEAP', 1, 44, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'T_2067_a130c9caab694b17ba27e88b2120c7bf', 'ROUND_ROBIN', NULL, 'HEAP', 1, 2, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'T_2093_86a5a7a8e556453fb6508857be3ffcd1', 'ROUND_ROBIN', NULL, 'HEAP', 1, 2, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'T_2099_1fb8fea8d0214a35b7ec645b61070e2e', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'T_2100_bfbdf39e8f354f3dae63d366a7c9c14f', 'ROUND_ROBIN', NULL, 'HEAP', 1, 2, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'T_2101_066bc1aa2c674dbd837bd2875cb36067', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'T_2101_43a1d77cf40b48d4a5fb7315960dc12a', 'ROUND_ROBIN', NULL, 'HEAP', 1, 2, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'T_2101_c63a81785f6d4b9c99f0254be3d578a5', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'T_2101_e79c70ea00444d728654f2ad8c6a83c0', 'ROUND_ROBIN', NULL, 'HEAP', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'T_2355_2c44a24d64d64fd6b9af3d1c89c88a05', 'ROUND_ROBIN', NULL, 'HEAP', 1, 4, '0.000144000', '0.000016000', '0.000016000', '0.000112000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'vwLeadOld', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 641640, '0.289488000', '0.264224000', '0.002896000', '0.022368000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'ODS', 'VWTaskOld', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 340416, '0.098768000', '0.072704000', '0.002896000', '0.023168000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'Reports', 'Contact', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 3710410, '1.936256000', '1.907824000', '0.011136000', '0.017296000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'Reports', 'Funnel', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 0, '0.000000000', '0.000000000', '0.000000000', '0.000000000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'Reports', 'FunnelRefactored', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 0, '0.008640000', '0.001920000', '0.000000000', '0.006720000'),
('2022-01-12 22:58:40.180', 'hc_eim_prod2_sql_pool', 'Reports', 'Google', 'ROUND_ROBIN', NULL, 'CLUSTERED COLUMNSTORE', 1, 336466, '0.070928000', '0.053888000', '0.002768000', '0.014272000'))
[vdata] ([Now], [database_name], [schema_name], [table_name], [distribution_policy_name], [distribution_column], [index_type_desc], [nbr_partitions], [table_row_count], [table_reserved_space_GB], [table_data_space_GB], [table_index_space_GB], [table_unused_space_GB])