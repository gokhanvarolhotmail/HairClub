/* CreateDate: 03/17/2022 11:57:11.310 , ModifyDate: 03/17/2022 11:57:11.310 */
GO
CREATE VIEW [bi_cms_dds].[vwDimAccumulator]
AS
-------------------------------------------------------------------------
-- [vwDimAccumulator] is used to retrieve a
-- list of Accumulators
--
--   SELECT * FROM [bi_cms_dds].[vwDimAccumulator]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------


	SELECT        AccumulatorKey
				, AccumulatorSSID
				, AccumulatorDescription
				, AccumulatorDescriptionShort
				, AccumulatorDataTypeSSID
				, AccumulatorDataTypeDescription
				, AccumulatorDataTypeDescriptionShort
				, SchedulerActionTypeSSID
				, SchedulerActionTypeDescription
				, SchedulerActionTypeDescriptionShort
				, SchedulerAdjustmentTypeSSID
				, SchedulerAdjustmentTypeDescription
				, SchedulerAdjustmentTypeDescriptionShort
				, RowIsCurrent
				, RowStartDate
				, RowEndDate
	FROM         bi_cms_dds.DimAccumulator
GO
