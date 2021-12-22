/* CreateDate: 10/03/2019 23:03:43.270 , ModifyDate: 10/03/2019 23:03:43.270 */
GO
CREATE VIEW [bi_cms_dds].[vwDimClientMembershipAccum]
AS
-------------------------------------------------------------------------
-- [vwDimClientMembershipAccum] is used to retrieve a
-- list of Client Membership Accumulator
--
--   SELECT * FROM [bi_cms_dds].[vwDimClientMembershipAccum]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/03/2010  RLifke       Initial Creation
-------------------------------------------------------------------------


	SELECT        [ClientMembershipAccumKey]
				, [ClientMembershipAccumSSID]
				, [ClientMembershipKey]
				, [ClientMembershipSSID]
				, [AccumulatorKey]
				, [AccumulatorSSID]
				, [AccumulatorDescription]
				, [AccumulatorDescriptionShort]
				, [UsedAccumQuantity]
				, [AccumMoney]
				, [AccumDate]
				, [TotalAccumQuantity]
				, [AccumQuantityRemaining]
				, RowIsCurrent
				, RowStartDate
				, RowEndDate
	FROM         bi_cms_dds.[DimClientMembershipAccum]
GO
