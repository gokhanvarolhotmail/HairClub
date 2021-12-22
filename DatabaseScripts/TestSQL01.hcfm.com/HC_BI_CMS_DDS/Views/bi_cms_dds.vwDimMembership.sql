/* CreateDate: 05/03/2010 12:17:24.450 , ModifyDate: 09/16/2019 09:33:49.913 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwDimMembership]
AS
-------------------------------------------------------------------------
-- [vwDimMembership] is used to retrieve a
-- list of Memberships
--
--   SELECT * FROM [bi_cms_dds].[vwDimMembership]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
--			12/04/2012  KMurdoch     Added Business SegmentDescription
-------------------------------------------------------------------------

		SELECT	  [MembershipKey]
				, [MembershipSSID]
				, [MembershipDescription]
				, [MembershipDescriptionShort]
				, [BusinessSegmentKey]
				, [BusinessSegmentSSID]
				, [BusinessSegmentDescription]
				, [BusinessSegmentDescriptionShort]
				, [RevenueGroupSSID]
				, [RevenueGroupDescription]
				, [RevenueGroupDescriptionShort]
				, [GenderSSID]
				, [GenderDescription]
				, [GenderDescriptionShort]
				, [MembershipDurationMonths]
				, [MembershipContractPrice]
				, [MembershipMonthlyFee]
				, [RowIsCurrent]
				, [RowStartDate]
				, [RowEndDate]
		FROM [bi_cms_dds].[DimMembership]
GO
