/* CreateDate: 03/17/2022 11:57:10.827 , ModifyDate: 03/17/2022 11:57:10.827 */
GO
/*-----------------------------------------------------------------------
 [vwDimClientMembership] is used to retrieve a
 list of Client Memberships

   SELECT * FROM [bi_cms_dds].[vwDimClientMembership]

-----------------------------------------------------------------------
 Change History
-----------------------------------------------------------------------
 Version  Date        Author       Description
 -------  ----------  -----------  ------------------------------------
  v1.0    04/15/2009  RLifke       Initial Creation*/
CREATE VIEW [bi_cms_dds].[vwDimClientMembership]
AS
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
