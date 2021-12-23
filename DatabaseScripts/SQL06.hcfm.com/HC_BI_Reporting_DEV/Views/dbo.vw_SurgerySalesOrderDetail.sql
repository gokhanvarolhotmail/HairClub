/* CreateDate: 06/02/2011 15:18:46.413 , ModifyDate: 02/26/2014 09:55:32.183 */
GO
CREATE VIEW [dbo].[vw_SurgerySalesOrderDetail]
AS
select
		OrderDateKey as 'OrderDateKey'
	,	DT.FullDate as 'OrderDate'
	,	TCTR.CenterSSID as 'CenterID'
	,	TCTR.CenterDescription as 'CenterDescription'
	,	TCTR.CenterDescriptionNumber as 'CenterDescriptionFullCalc'
	,	HCTR.CenterSSID as 'ClientHomeCenterID'
	,	HCTR.CenterDescription as 'ClientHomeCenterDescription'
	,	HCTR.CenterDescriptionNumber as 'ClientHomeCenterDescriptionFullCalc'
	,	REG.RegionSSID as 'RegionID'
	,	REG.RegionDescription as 'RegionDescription'
	,	DOCREG.DoctorRegionSSID as 'DoctorRegionID'
	,	DOCREG.DoctorRegionDescription as 'DoctorRegionDescription'
	,	DOCREG.DoctorRegionDescriptionShort as 'DoctorRegionDescriptionShort'
	,	CTRTYPE.CenterTypeSSID as 'CenterTypeID'
	,	CTRTYPE.CenterTypeDescription as 'CenterTypeDescription'
	,	CTRTYPE.CenterTypeDescriptionShort as 'CenterTypeDescriptionShort'
	,	CL.ClientSSID as 'ClientGUID'
	,	CL.ClientIdentifier as 'ClientIdentifier'
	,	CL.ClientNumber_Temp as 'ClientNumber_Temp'
	,	CL.ClientFirstName as  'ClientFirstName'
	,	CL.ClientLastName as 'ClientLastName'
	,	CL.ClientFullName as 'ClientFullName'
	,	CLM.ClientMembershipSSID as 'ClientMembershipGUID'
	,	CLM.ClientMembershipBeginDate as 'BeginDate'
	,	CLM.ClientMembershipEndDate as 'EndDate'
	,	CLM.ClientMembershipCancelDate as 'CancelDate'
	,	CLM.ClientMembershipContractPrice as 'MemberContractPrice'
	,	CLM.ClientMembershipContractPaidAmount as 'MemberContractPaidAmt'
	,	CLM.ClientMembershipStatusSSID as 'ClientMembershipStatusID'
	,	CLM.ClientMembershipStatusDescription as 'ClientMembershipStatusDescription'
	,	CLM.MembershipSSID as 'MembershipID'
	,	MEM.MembershipDescription as 'MembershipDescription'
	,	MEM.MembershipDescriptionShort as 'MembershipDescriptionShort'
	,	SC.SalesCodeSSID as 'SalesCodeID'
	,	SC.SalesCodeDescription as 'SalesCodeDescription'
	,	SC.SalesCodeDescriptionShort as 'SalescodeDescriptionShort'
	,	SC.SalesCodeTypeSSID as 'SalesCodeTypeID'
	,	SC.SalesCodeTypeDescription as 'SalesCodeTypeDescription'
	,	SC.SalesCodeDepartmentSSID as 'SalesCodeDepartmentID'
	,	SCD.SalesCodeDepartmentDescription as 'SalesCodeDepartmentDescription'
	,	SCD.SalesCodeDepartmentDescriptionShort as 'SalesCodeDepartmentDescriptonShort'
	,	SCV.SalesCodeDivisionSSID as 'SalesCodeDivisionID'
	,	SCV.SalesCodeDivisionDescription as 'SalesCodeDivisionDescription'
	,	SCV.SalesCodeDivisionDescriptionShort as 'SalesCodeDivisionDescriptionShort'
	,	EMP1.EmployeeFullName as 'Consultant'
	,	EMP2.EmployeeFullName as 'Technician'
	,	EMP3.EmployeeFullName as 'Doctor'
	,	EMP4.EmployeeFullName as 'Employee4'
	,	EMP1.EmployeeInitials as 'ConsultantInitials'
	,	EMP2.EmployeeInitials as 'TechnicianInitials'
	,	EMP3.EmployeeInitials as 'DoctorInitials'
	,	EMP4.EmployeeInitials as 'Employee4Initials'
	,	EMP2.EmployeeInitials as 'Performer1'
	,	SO.InvoiceNumber as 'InvoiceNumber'
	,	SO.SalesOrderTypeSSID as 'SalesOrderTypeID'
	,	SOTYPE.SalesOrderTypeDescription as 'SalesOrderTypeDescription'
	,	SOTYPE.SalesOrderTypeDescriptionShort as 'SalesOrderTypeDescriptionShort'
	,	SURG.[SF-First_Surgery_Net_Sales] as 'FirstSurgerySales#'
	,	SURG.[SF-First_Surgery_Est_Grafts] as 'FirstSurgeryGraft#'
	,	SURG.[SF-First_Surgery_Net$] as 'FirstSurgeryCollected$'
	,	SURG.[SF-First_Surgery_Contract_Amount] as 'FirstSurgeryContract$'
	,	SURG.[SF-Addtl_Surgery_Net_Sales] as 'AddtlSurgerySales#'
	,	SURG.[SF-Addtl_Surgery_Est_Grafts] as 'AddtlSurgeryGrafts#'
	,	SURG.[SF-Addtl_Surgery_Net$] as 'AddtlSurgeryCollected$'
	,	SURG.[SF-Addtl_Surgery_Contract_Amount] as 'AddtlSurgeryContract$'
	,	SURG.[SF-Total_POSTEXTPMT_Count] as 'PostEXT#'
	,	SURG.[SF-Total_POSTEXTPMT] as 'PostEXT$'
	,	SURG.[SF-DepositsTaken] as 'Deposit#'
	,	SURG.[SF-DepositsTaken$] as 'Deposit$'
	,	SURG.[SF-Total_Surgery_Performed] as 'SurgeryPerformed#'
	,	SURG.[SF-Total_Grafts] as 'SurgeryPerformedGrafts#'
	,	SURG.[SF-Total_Net$] as 'SurgeryPerformed$'
	,	SURG.[SF-Quantity] as 'SalesOrderDetailQty'
	,	SURG.[SF-Price] as 'SalesOrderDetailPrice'
	,	SURG.[SF-Discount] as 'SalesOrderDetailDiscount'
	,	SURG.[SF-Tax1] as 'SalesOrderDetailTax1'
	,	SURG.[SF-Tax2] as 'SalesOrderDetailTax2'
	,	SURG.[SF-ExtendedPrice] as 'SalesOrderDetailExtendedPrice'
	,	SURG.[SF-ExtendedPricePlusTax] as 'SalesOrderDetailExtendedPriceTax'
	,	SOD.RefundedTotalPrice as 'SalesOrderDetailRefundedTotalPrice'
	,	SOD.RefundedTotalQuantity as 'SalesOrderDetailRefundedTotalQuantity'
	,	SOD.IsRefundedFlag as 'SalesOrderDetailIsRefundedFlag'
	,	SOD.RefundedSalesOrderDetailSSID as 'SalesOrderDetailRefundedSODGUID'
	,	SOD.PreviousClientMembershipSSID as 'SalesOrderDetailPrevCLMGUID'
	,	SO.IsVoidedFlag as 'SalesOrderVoidedFlag'
	,	SO.IsClosedFlag as 'SalesOrderClosedFlag'
	,	CASHIER.EmployeeFullName as 'Cashier'
	,	CASHIER.EmployeeInitials as 'CashierInitials'
	,	SOD.SalesOrderDetailSSID as 'SalesOrderDetailGUID'
	,   SURG.AccumulatorKey as 'AccumulatorKey'

from dbo.synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo SURG
	INNER JOIN dbo.synHC_CMS_DDS_vwDimSalesOrder SO on
		SURG.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimSalesOrderDetail SOD on
		SURG.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN dbo.syn_HC_ENT_DDS_vwDimDate DT on
		SURG.OrderDateKey = DT.DateKey
	INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter TCTR on
		SURG.CenterKey = TCTR.CenterKey
	INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter HCTR on
		SURG.ClientHomeCenterKey = HCTR.CenterKey
	INNER JOIN dbo.synHC_ENT_DDS_vwDimRegion REG on
		HCTR.RegionKey = REG.RegionKey
	INNER JOIN dbo.synHC_ENT_DDS_vwDimDoctorRegion DOCREG on
		HCTR.DoctorRegionKey = DOCREG.DoctorRegionKey
	INNER JOIN dbo.synHC_ENT_DDS_vwDimCenterType CTRTYPE on
		HCTR.CenterTypeKey = CTRTYPE.CenterTypeKey
	INNER JOIN dbo.synHC_CMS_DDS_DimClient CL on
		SURG.ClientKey = CL.ClientKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimClientMembership CLM on
		SO.ClientMembershipKey = CLM.ClientMembershipKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimMembership MEM on
		CLM.MembershipKey = MEM.MembershipKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimSalesCode SC on
		SURG.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimSalesCodeDepartment SCD on
		SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimSalesCodeDivision SCV on
		SCD.SalesCodeDivisionKey = SCV.SalesCodeDivisionKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimEmployee CASHIER on
		SO.EMPLOYEEKEY = CASHIER.EMPLOYEEKEY
	INNER JOIN dbo.synHC_CMS_DDS_vwDimEmployee EMP1 on
		SURG.Employee1Key = EMP1.EmployeeKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimEmployee EMP2 on
		SURG.Employee2Key = EMP2.EmployeeKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimEmployee EMP3 on
		SURG.Employee3Key = EMP3.EmployeeKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimEmployee EMP4 on
		SURG.Employee4Key = EMP4.EmployeeKey
	INNER JOIN dbo.synHC_CMS_DDS_vw_DimSalesOrderType SOTYPE on
		SURG.SalesOrderTypeKey = SOTYPE.SalesOrderTypeKey
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
         Begin Table = "SURG"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 125
               Right = 303
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SO"
            Begin Extent =
               Top = 6
               Left = 341
               Bottom = 125
               Right = 589
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DT"
            Begin Extent =
               Top = 126
               Left = 38
               Bottom = 245
               Right = 323
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TCTR"
            Begin Extent =
               Top = 126
               Left = 361
               Bottom = 245
               Right = 622
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "HCTR"
            Begin Extent =
               Top = 246
               Left = 38
               Bottom = 365
               Right = 299
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "REG"
            Begin Extent =
               Top = 246
               Left = 337
               Bottom = 365
               Right = 538
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DOCREG"
            Begin Extent =
               Top = 246
               Left = 576
               Bottom = 365
               Right = 809
            End
            DisplayFlags = 280
            TopColumn =' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SurgerySalesOrderDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' 0
         End
         Begin Table = "CTRTYPE"
            Begin Extent =
               Top = 366
               Left = 38
               Bottom = 485
               Right = 263
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CL"
            Begin Extent =
               Top = 366
               Left = 301
               Bottom = 485
               Right = 559
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CLM"
            Begin Extent =
               Top = 486
               Left = 38
               Bottom = 605
               Right = 321
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MEM"
            Begin Extent =
               Top = 486
               Left = 359
               Bottom = 605
               Right = 599
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SC"
            Begin Extent =
               Top = 606
               Left = 38
               Bottom = 725
               Right = 280
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SCD"
            Begin Extent =
               Top = 606
               Left = 318
               Bottom = 725
               Right = 593
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SCV"
            Begin Extent =
               Top = 726
               Left = 38
               Bottom = 845
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EMP1"
            Begin Extent =
               Top = 726
               Left = 330
               Bottom = 845
               Right = 592
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EMP2"
            Begin Extent =
               Top = 846
               Left = 38
               Bottom = 965
               Right = 300
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EMP3"
            Begin Extent =
               Top = 846
               Left = 338
               Bottom = 965
               Right = 600
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "EMP4"
            Begin Extent =
               Top = 966
               Left = 38
               Bottom = 1085
               Right = 300
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SOTYPE"
            Begin Extent =
               Top = 966
               Left = 338
               Bottom = 1085
               Right = 583
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SurgerySalesOrderDetail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SurgerySalesOrderDetail'
GO
