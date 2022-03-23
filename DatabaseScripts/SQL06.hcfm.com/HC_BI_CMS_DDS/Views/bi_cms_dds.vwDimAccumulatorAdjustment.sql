/* CreateDate: 03/17/2022 11:57:10.743 , ModifyDate: 03/17/2022 11:57:10.743 */
GO
CREATE VIEW [bi_cms_dds].[vwDimAccumulatorAdjustment]
AS
-------------------------------------------------------------------------
-- [vwDimAccumulatorAdjustment] is used to retrieve a
-- list of Accumulator Adjustments
--
--   SELECT * FROM [bi_cms_dds].[vwDimAccumulatorAdjustment]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/03/2010  RLifke       Initial Creation
-------------------------------------------------------------------------


	SELECT        [AccumulatorAdjustmentKey]
				, [AccumulatorAdjustmentSSID]
				, [ClientMembershipKey]
				, [ClientMembershipSSID]
				, [SalesOrderDetailKey]
				, [SalesOrderDetailSSID]
				, [AppointmentKey]
				, [AppointmentSSID]
				, [AccumulatorKey]
				, [AccumulatorSSID]
				, [AccumulatorDescription]
				, [AccumulatorDescriptionShort]
				, [QuantityUsedOriginal]
				, [QuantityUsedAdjustment]
				, [QuantityTotalOriginal]
				, [QuantityTotalAdjustment]
				, [MoneyOriginal]
				, [MoneyAdjustment]
				, [DateOriginal]
				, [DateAdjustment]
				, [QuantityUsedNew]
				, [QuantityUsedChange]
				, [QuantityTotalNew]
				, [QuantityTotalChange]
				, [MoneyNew]
				, [MoneyChange]
				, RowIsCurrent
				, RowStartDate
				, RowEndDate
	FROM         bi_cms_dds.DimAccumulatorAdjustment
GO
