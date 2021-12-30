/* CreateDate: 06/06/2007 11:22:04.500 , ModifyDate: 11/09/2015 09:03:53.750 */
GO
CREATE VIEW [dbo].[lead_info]
AS
SELECT  c.contact_id,
            c.first_name,
            c.last_name,
            c.creation_date,
            c.created_by_user_code,
            cp.area_code,
            cp.phone_number,
            RTRIM(ca.address_line_1) AS 'address_line_1',
            RTRIM(ca.address_line_2) AS 'address_line_2',
            ca.city,
            ca.state_code,
            ca.zip_code,
            cz.adi_flag,
            ce.email,
            CASE WHEN co.cst_center_number IS NULL THEN coa.cst_center_number ELSE co.cst_center_number END AS territory,
            CASE WHEN co.cst_center_number IS NOT NULL THEN coa.cst_center_number ELSE NULL END AS alt_center,
            c.cst_gender_code,
            pc.description AS cst_promotion_code,
            c.cst_complete_sale,
            c.cst_language_code,
            c.contact_status_code,
                     cs.source_code AS 'leadSourceCode'
    FROM    dbo.oncd_contact AS c
            LEFT OUTER JOIN dbo.oncd_contact_phone AS cp ON cp.contact_id = c.contact_id
                                                            AND cp.primary_flag = 'Y'
            LEFT OUTER JOIN dbo.oncd_contact_address AS ca ON ca.contact_id = c.contact_id
                                                              AND ca.primary_flag = 'Y'
            LEFT OUTER JOIN dbo.oncd_contact_email AS ce ON ce.contact_id = c.contact_id
                                                            AND ce.primary_flag = 'Y'

                     LEFT OUTER JOIN dbo.oncd_contact_source AS cs ON cs.contact_id = c.contact_id
                                              AND cs.primary_flag = 'Y'
                     LEFT OUTER JOIN dbo.csta_promotion_code AS pc ON pc.promotion_code = c.cst_promotion_code

            LEFT OUTER JOIN --mod
            dbo.oncd_contact_company AS cc ON cc.contact_id = c.contact_id
                                              AND cc.primary_flag <> 'Y'
            LEFT OUTER JOIN dbo.oncd_contact_company AS cca ON c.contact_id = cca.contact_id
                                                               and cca.contact_company_id = ( SELECT TOP ( 1 )
                                                                                                        contact_company_id
                                                                                              FROM      dbo.oncd_contact_company
                                                                                              WHERE     ( contact_id = c.contact_id )
                                                                                                        AND ( primary_flag = 'Y' )
                                                                                            )
            LEFT OUTER JOIN --mod
            dbo.oncd_company AS co ON co.company_id = cc.company_id
            LEFT OUTER JOIN dbo.oncd_company AS coa ON coa.company_id = cca.company_id
            LEFT OUTER JOIN --mod
            dbo.cstd_company_zip_code AS cz ON coa.company_id = cz.company_id
                                               AND cz.zip_from = ca.zip_code
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
         Configuration = "(H (1[50] 2[25] 3) )"
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
         Configuration = "(H (1 [56] 4 [18] 2))"
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
         Begin Table = "c"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 121
               Right = 269
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cp"
            Begin Extent =
               Top = 6
               Left = 307
               Bottom = 121
               Right = 502
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ca"
            Begin Extent =
               Top = 6
               Left = 540
               Bottom = 121
               Right = 740
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cc"
            Begin Extent =
               Top = 126
               Left = 38
               Bottom = 241
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "co"
            Begin Extent =
               Top = 126
               Left = 271
               Bottom = 241
               Right = 502
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ce"
            Begin Extent =
               Top = 126
               Left = 540
               Bottom = 241
               Right = 735
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cca"
            Begin Extent =
               Top = 246
               Left = 38
               Bottom = 361
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 0
         ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'lead_info'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'End
         Begin Table = "coa"
            Begin Extent =
               Top = 246
               Left = 271
               Bottom = 361
               Right = 502
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cz"
            Begin Extent =
               Top = 246
               Left = 540
               Bottom = 361
               Right = 735
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
      RowHeights = 220
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'lead_info'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'lead_info'
GO
