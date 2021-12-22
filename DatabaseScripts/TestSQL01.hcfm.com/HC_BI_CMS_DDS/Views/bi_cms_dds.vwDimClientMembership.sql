/* CreateDate: 05/03/2010 12:17:24.407 , ModifyDate: 09/16/2019 09:33:49.910 */
GO
CREATE VIEW [bi_cms_dds].[vwDimClientMembership]
AS
-------------------------------------------------------------------------
-- [vwDimClientMembership] is used to retrieve a
-- list of Client Memberships
--
--   SELECT * FROM [bi_cms_dds].[vwDimClientMembership]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/15/2009  RLifke       Initial Creation
-------------------------------------------------------------------------

	SELECT	  [ClientMembershipKey]
			, [ClientMembershipSSID]
			, [DimClientMembership].[ClientKey]
			, [DimClientMembership].[ClientSSID]
			, [CenterKey]
			, [DimClientMembership].[CenterSSID]
			, [DimClientMembership].[MembershipKey]
			, [DimClientMembership].[MembershipSSID]
			, [ClientMembershipStatusSSID]
			, [ClientMembershipStatusDescription]
			, [ClientMembershipStatusDescriptionShort]
			, [ClientMembershipContractPrice]
			, [ClientMembershipContractPaidAmount]
			, [ClientMembershipMonthlyFee]
			, [ClientMembershipBeginDate]
			, [ClientMembershipEndDate]
			, [ClientMembershipCancelDate]
			, [DimClientMembership].[RowIsCurrent]
			, [DimClientMembership].[RowStartDate]
			, [DimClientMembership].[RowEndDate]
			, CL.ClientLastName + ', ' + CL.ClientFirstName +
				' (' + CAST(CL.ClientIdentifier AS VARCHAR) + ')' AS 'NameAndID'
	FROM [bi_cms_dds].[DimClientMembership]
		left outer join bi_cms_dds.DimClient CL on
			DimClientMembership.ClientKey = CL.ClientKey
GO
