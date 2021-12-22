/* CreateDate: 05/03/2010 12:17:24.380 , ModifyDate: 09/16/2019 09:33:49.910 */
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
