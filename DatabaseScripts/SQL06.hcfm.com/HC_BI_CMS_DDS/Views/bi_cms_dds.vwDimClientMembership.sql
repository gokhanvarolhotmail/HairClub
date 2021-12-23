/* CreateDate: 10/03/2019 23:03:43.250 , ModifyDate: 07/17/2021 18:26:59.210 */
GO
CREATE VIEW [bi_cms_dds].[vwDimClientMembership] AS
SELECT        bi_cms_dds.DimClientMembership.ClientMembershipKey, bi_cms_dds.DimClientMembership.ClientMembershipSSID, bi_cms_dds.DimClientMembership.ClientKey, bi_cms_dds.DimClientMembership.ClientSSID,
                         bi_cms_dds.DimClientMembership.CenterKey, bi_cms_dds.DimClientMembership.CenterSSID, bi_cms_dds.DimClientMembership.MembershipKey, bi_cms_dds.DimClientMembership.MembershipSSID,
                         bi_cms_dds.DimClientMembership.ClientMembershipStatusSSID, bi_cms_dds.DimClientMembership.ClientMembershipStatusDescription, bi_cms_dds.DimClientMembership.ClientMembershipStatusDescriptionShort,
                         bi_cms_dds.DimClientMembership.ClientMembershipContractPrice, bi_cms_dds.DimClientMembership.ClientMembershipContractPaidAmount, bi_cms_dds.DimClientMembership.ClientMembershipMonthlyFee,
                         bi_cms_dds.DimClientMembership.ClientMembershipBeginDate, bi_cms_dds.DimClientMembership.ClientMembershipEndDate, bi_cms_dds.DimClientMembership.ClientMembershipCancelDate,
                         bi_cms_dds.DimClientMembership.RowIsCurrent, bi_cms_dds.DimClientMembership.RowStartDate, bi_cms_dds.DimClientMembership.RowEndDate,
                         CL.ClientLastName + ', ' + CL.ClientFirstName + ' (' + CAST(CL.ClientIdentifier AS VARCHAR) + ')' AS NameAndID
FROM            bi_cms_dds.DimClientMembership LEFT OUTER JOIN
                         bi_cms_dds.DimClient AS CL ON bi_cms_dds.DimClientMembership.ClientKey = CL.ClientKey
GO