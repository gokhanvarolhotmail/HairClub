/* CreateDate: 06/07/2011 13:15:26.210 , ModifyDate: 06/07/2011 13:15:26.210 */
GO
CREATE VIEW dbo.vw_SurgerySalesOrderTender
AS
SELECT     SO.OrderDate AS 'Date', SO.CenterSSID AS 'TrxCenterID', CTR.CenterDescription AS 'TrxCenterDescription',
                      CTR.CenterDescriptionNumber AS 'TrxCenterDescriptionFullCalc', CLM.CenterSSID AS 'ClientHomeCenterID',
                      CLHMCTR.CenterDescription AS 'ClientHomeCenterDescription', CLHMCTR.CenterDescriptionNumber AS 'ClientHomeCenterDescriptionFullCalc',
                      CTRREG.RegionSSID AS 'RegionID', CTRREG.RegionDescription, DOCREG.DoctorRegionSSID AS 'DoctorRegionID', DOCREG.DoctorRegionDescription,
                      DOCREG.DoctorRegionDescriptionShort, CTRTYPE.CenterTypeSSID AS 'TrxCenterTypeID', CTRTYPE.CenterTypeDescription AS 'TrxCenterTypeDescription',
                      CTRTYPE.CenterTypeDescriptionShort AS 'TrxCenterTypeDescriptionShort', CL.ClientSSID AS 'ClientGUID', CL.ClientIdentifier, CL.ClientNumber_Temp,
                      CL.ClientFirstName, CL.ClientLastName, CL.ClientFullName, CLM.ClientMembershipSSID AS 'ClientMembershipGUID',
                      CLM.ClientMembershipBeginDate AS 'BeginDate', CLM.ClientMembershipEndDate AS 'EndDate', CLM.ClientMembershipCancelDate AS 'CancelDate',
                      CLM.ClientMembershipContractPrice AS 'ContractPrice', CLM.ClientMembershipContractPaidAmount AS 'ContractPaidAmount',
                      CLM.ClientMembershipMonthlyFee AS 'MonthlyFee', CLM.ClientMembershipStatusSSID AS 'ClientMembershipStatusID', CLM.ClientMembershipStatusDescription,
                      MEM.MembershipSSID AS 'MembershipID', MEM.MembershipDescription, ISNULL(EMP.EmployeeInitials, 'XX') AS 'CashierInitials', ISNULL(EMP.EmployeeFullName,
                      'Unknown, Unknown') AS 'Cashier', SO.SalesOrderSSID AS 'SalesOrderGUID', SO.InvoiceNumber, SO.TicketNumber_Temp, SO.FulfillmentNumber, SO.IsVoidedFlag,
                      SO.IsClosedFlag, SO.IsWrittenOffFlag, SOT.SalesOrderTenderSSID AS 'SalesOrderTenderGUID', SOT.TenderTypeSSID AS 'TenderTypeID',
                      SOT.TenderTypeDescription, SOT.TenderTypeDescriptionShort, SOT.Amount, SOT.CheckNumber, SOT.CreditCardLast4Digits, SOT.ApprovalCode,
                      SOT.CreditCardTypeSSID AS 'CreditCardTypeID', SOT.CreditCardTypeDescription AS 'CreditCardTypeDesription', SOT.CreditCardTypeDescriptionShort,
                      SOT.FinanceCompanySSID AS 'FinanceCompanyID', SOT.FinanceCompanyDescription, SOT.FinanceCompanyDescriptionShort,
                      SOT.InterCompanyReasonSSID AS 'IntercompanyReasonID', SOT.InterCompanyReasonDescription AS 'IntercompanyReasonDescription',
                      SOT.InterCompanyReasonDescriptionShort AS 'IntercompanyReasonDescriptionShort'
FROM         dbo.synHC_CMS_DDS_vwDimSalesOrderTender AS SOT INNER JOIN
                      dbo.synHC_CMS_DDS_vwDimSalesOrder AS SO ON SOT.SalesOrderKey = SO.SalesOrderKey LEFT OUTER JOIN
                      dbo.synHC_CMS_DDS_vwDimEmployee AS EMP ON SO.EmployeeKey = EMP.EmployeeKey INNER JOIN
                      dbo.synHC_ENT_DDS_vwDimCenter AS CTR ON SO.CenterKey = CTR.CenterKey INNER JOIN
                      dbo.synHC_ENT_DDS_vwDimRegion AS CTRREG ON CTR.RegionKey = CTRREG.RegionKey INNER JOIN
                      dbo.synHC_ENT_DDS_vwDimCenterType AS CTRTYPE ON CTR.CenterTypeKey = CTRTYPE.CenterTypeKey INNER JOIN
                      dbo.synHC_ENT_DDS_vwDimDoctorRegion AS DOCREG ON CTR.DoctorRegionKey = DOCREG.DoctorRegionKey INNER JOIN
                      dbo.synHC_CMS_DDS_vwDimClient AS CL ON SO.ClientKey = CL.ClientKey INNER JOIN
                      dbo.synHC_CMS_DDS_vwDimClientMembership AS CLM ON SO.ClientMembershipKey = CLM.ClientMembershipKey INNER JOIN
                      dbo.synHC_CMS_DDS_vwDimMembership AS MEM ON CLM.MembershipKey = MEM.MembershipKey INNER JOIN
                      dbo.synHC_ENT_DDS_vwDimCenter AS CLHMCTR ON CLM.CenterKey = CLHMCTR.CenterKey
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "SOT"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 125
               Right = 311
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO"
            Begin Extent =
               Top = 6
               Left = 349
               Bottom = 125
               Right = 597
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EMP"
            Begin Extent =
               Top = 126
               Left = 38
               Bottom = 245
               Right = 300
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CTR"
            Begin Extent =
               Top = 126
               Left = 338
               Bottom = 245
               Right = 599
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CTRREG"
            Begin Extent =
               Top = 6
               Left = 635
               Bottom = 125
               Right = 836
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CTRTYPE"
            Begin Extent =
               Top = 246
               Left = 38
               Bottom = 365
               Right = 263
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DOCREG"
            Begin Extent =
               Top = 246
               Left = 301
               Bottom = 365
               Right = 534
            End
            DisplayFlags = 280
            TopColum' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SurgerySalesOrderTender'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'n = 0
         End
         Begin Table = "CL"
            Begin Extent =
               Top = 246
               Left = 572
               Bottom = 365
               Right = 830
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CLM"
            Begin Extent =
               Top = 366
               Left = 38
               Bottom = 485
               Right = 321
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MEM"
            Begin Extent =
               Top = 366
               Left = 359
               Bottom = 485
               Right = 599
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CLHMCTR"
            Begin Extent =
               Top = 486
               Left = 38
               Bottom = 605
               Right = 299
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SurgerySalesOrderTender'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SurgerySalesOrderTender'
GO
