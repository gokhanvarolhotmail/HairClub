/* CreateDate: 03/23/2011 08:38:18.837 , ModifyDate: 09/16/2019 09:33:49.873 */
GO
/*-----------------------------------------------------------------------
 [vwFactSalesTransaction_FLASH] is used to retrieve a
 list of Sales Transactions that is brought into the Surgery Flash

   SELECT * FROM [bi_cms_dds].[vwFactSalesTransaction_Flash]

-----------------------------------------------------------------------
 Change History
-----------------------------------------------------------------------
 Version  Date        Author       Description
 -------  ----------  -----------  ------------------------------------
  v1.0    03/23/2011  CFleming     Initial Creation
  v1.1    10/11/2012  KMurdoch	   Changed left outer Joins to Inner Joins

  */
CREATE VIEW [bi_cms_dds].[vwFactSalesTransaction_Flash]
AS
SELECT
			DD.FullDate AS PartitionDate,
			fst.OrderDateKey,
			fst.SalesOrderKey,
			fst.SalesOrderDetailKey,
			fst.SalesOrderTypeKey,
			fst.CenterKey,
			fs.ClientHomeCenterKey,
            fst.ClientKey,
			fst.MembershipKey,
			fst.ClientMembershipKey,
			fst.SalesCodeKey,
			fst.Employee1Key,
			fst.Employee2Key,
			fst.Employee3Key,
			fst.Employee4Key,
            fst.Quantity,
			fst.Price,
			fst.Discount,
			fst.ExtendedPrice,
			fst.Tax1,
			fst.Tax2,
			fst.TaxRate1,
			fst.TaxRate2,
			fst.ExtendedPricePlusTax,
			fst.TotalTaxAmount,
            COALESCE (SUM(DAA.MoneyChange), 0) AS MoneyChange,
			COALESCE (SUM(DAA.QuantityTotalChange), 0) AS QuantityTotalChange,
            COALESCE (SUM(DAA.QuantityUsedChange), 0) AS QuantityUsedChange,
			DAA.AccumulatorKey,
			DAA.AccumulatorSSID,
			sc.SalesCodeDepartmentSSID,
			fst.S1_SaleCnt,
            fst.S_CancelCnt,
			fst.S1_NetSalesCnt,
			fst.S1_NetSalesAmt,
			fst.S1_ContractAmountAmt,
			fst.S1_EstGraftsCnt,
			fst.S1_EstPerGraftsAmt,
			fst.SA_NetSalesCnt,
            fst.SA_NetSalesAmt,
			fst.SA_ContractAmountAmt,
			fst.SA_EstGraftsCnt,
			fst.SA_EstPerGraftAmt,
			fst.S_PostExtCnt,
			fst.S_PostExtAmt,
			fst.S_SurgeryPerformedCnt,
            fst.S_SurgeryPerformedAmt,
			fst.S_SurgeryGraftsCnt,
			fst.S1_DepositsTakenCnt,
			fst.S1_DepositsTakenAmt,
			fst.NB_GrossNB1Cnt,
			fst.NB_TradCnt,
			fst.NB_TradAmt,
            fst.NB_GradCnt,
			fst.NB_GradAmt,
			fst.NB_ExtCnt,
			fst.NB_ExtAmt,
			fst.NB_AppsCnt,
			fst.NB_BIOConvCnt,
			fst.NB_EXTConvCnt,
			fst.PCP_NB2Amt,
			fst.PCP_PCPAmt,
            fst.PCP_BioAmt,
			fst.PCP_ExtMemAmt,
			fst.PCPNonPgmAmt,
			fst.ServiceAmt,
			fst.RetailAmt,
			fst.ClientServicedCnt,
			fst.NetMembershipAmt,
			fst.S_GrossSurCnt,
            fst.S_SurCnt,
			fst.S_SurAmt
FROM        bi_cms_dds.FactSalesTransaction AS fst
			INNER JOIN bi_cms_dds.synHC_ENT_DDS_DimDate AS DD
				ON fst.OrderDateKey = DD.DateKey
			INNER JOIN bi_cms_dds.vwFactSales AS fs
				ON fs.SalesOrderKey = fst.SalesOrderKey
			LEFT OUTER JOIN bi_cms_dds.vwDimAccumulatorAdjustment AS DAA
				ON fst.SalesOrderDetailKey = DAA.SalesOrderDetailKey AND DAA.AccumulatorSSID IN (1, 12)
			INNER JOIN bi_cms_dds.vwDimSalesCode AS sc
				ON fst.SalesCodeKey = sc.SalesCodeKey
WHERE     (ISNULL(fs.ISSURGERYREVERSALFLAG, 0) <> 1)
GROUP BY DD.FullDate, fst.OrderDateKey, fst.SalesOrderKey, fst.SalesOrderDetailKey, fst.SalesOrderTypeKey, fst.CenterKey, fs.ClientHomeCenterKey, fst.ClientKey,
                      fst.MembershipKey, fst.ClientMembershipKey, fst.SalesCodeKey, fst.Employee1Key, fst.Employee2Key, fst.Employee3Key, fst.Employee4Key, fst.Quantity, fst.Price,
                      fst.Discount, fst.ExtendedPrice, fst.Tax1, fst.Tax2, fst.TaxRate1, fst.TaxRate2, fst.ExtendedPricePlusTax, fst.TotalTaxAmount, fst.SalesOrderDetailKey,
                      DAA.AccumulatorKey, DAA.AccumulatorSSID, sc.SalesCodeDepartmentSSID, fst.S1_SaleCnt, fst.S_CancelCnt, fst.S1_NetSalesCnt, fst.S1_NetSalesAmt,
                      fst.S1_ContractAmountAmt, fst.S1_EstGraftsCnt, fst.S1_EstPerGraftsAmt, fst.SA_NetSalesCnt, fst.SA_NetSalesAmt, fst.SA_ContractAmountAmt, fst.SA_EstGraftsCnt,
                      fst.SA_EstPerGraftAmt, fst.S_PostExtCnt, fst.S_PostExtAmt, fst.S_SurgeryPerformedCnt, fst.S_SurgeryPerformedAmt, fst.S_SurgeryGraftsCnt, fst.S1_DepositsTakenCnt,
                      fst.S1_DepositsTakenAmt, fst.NB_GrossNB1Cnt, fst.NB_TradCnt, fst.NB_TradAmt, fst.NB_GradCnt, fst.NB_GradAmt, fst.NB_ExtCnt, fst.NB_ExtAmt, fst.NB_AppsCnt,
                      fst.NB_BIOConvCnt, fst.NB_EXTConvCnt, fst.PCP_NB2Amt, fst.PCP_PCPAmt, fst.PCP_BioAmt, fst.PCP_ExtMemAmt, fst.PCPNonPgmAmt, fst.ServiceAmt, fst.RetailAmt,
                      fst.ClientServicedCnt, fst.NetMembershipAmt, fst.S_GrossSurCnt, fst.S_SurCnt, fst.S_SurAmt
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
         Begin Table = "fst"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 125
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 75
         End
         Begin Table = "DD"
            Begin Extent =
               Top = 126
               Left = 38
               Bottom = 245
               Right = 339
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fs"
            Begin Extent =
               Top = 246
               Left = 38
               Bottom = 365
               Right = 274
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DAA"
            Begin Extent =
               Top = 366
               Left = 38
               Bottom = 485
               Right = 281
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "sc"
            Begin Extent =
               Top = 486
               Left = 38
               Bottom = 605
               Right = 296
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
      Begin ColumnWidths = 12
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
E' , @level0type=N'SCHEMA',@level0name=N'bi_cms_dds', @level1type=N'VIEW',@level1name=N'vwFactSalesTransaction_Flash'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'nd
' , @level0type=N'SCHEMA',@level0name=N'bi_cms_dds', @level1type=N'VIEW',@level1name=N'vwFactSalesTransaction_Flash'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'bi_cms_dds', @level1type=N'VIEW',@level1name=N'vwFactSalesTransaction_Flash'
GO
