/* CreateDate: 05/03/2010 12:17:24.407 , ModifyDate: 07/17/2021 18:26:54.703 */
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
CREATE VIEW bi_cms_dds.vwDimClientMembership
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
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[24] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "DimClientMembership (bi_cms_dds)"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 136
               Right = 345
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CL"
            Begin Extent =
               Top = 138
               Left = 38
               Bottom = 268
               Right = 373
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'bi_cms_dds', @level1type=N'VIEW',@level1name=N'vwDimClientMembership'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'bi_cms_dds', @level1type=N'VIEW',@level1name=N'vwDimClientMembership'
GO
