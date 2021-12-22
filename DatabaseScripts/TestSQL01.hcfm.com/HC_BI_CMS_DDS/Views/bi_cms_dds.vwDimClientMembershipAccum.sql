/* CreateDate: 10/05/2010 13:44:26.950 , ModifyDate: 09/16/2019 09:33:49.880 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
