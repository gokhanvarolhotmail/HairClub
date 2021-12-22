/* CreateDate: 10/03/2019 23:03:43.567 , ModifyDate: 10/03/2019 23:03:43.567 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
