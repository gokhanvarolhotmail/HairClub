/* CreateDate: 03/08/2022 12:24:03.210 , ModifyDate: 03/08/2022 12:30:15.613 */
GO
CREATE VIEW dbo.vw_ClientDetails
AS
SELECT        dbo.cfgCenter.RegionID, dbo.cfgCenter.CountryID, dbo.cfgCenter.CenterID, dbo.cfgCenter.CenterDescription, dbo.cfgCenter.CenterTypeID, dbo.cfgCenter.CenterOwnershipID, dbo.datClient.StateID, dbo.datClient.City,
                         dbo.datClient.LastName, dbo.datClient.FirstName, dbo.datClient.ClientIdentifier, dbo.cfgMembership.MembershipDescription, dbo.datAppointment.AppointmentDate, dbo.datAppointment.IsNonAppointmentFlag,
                         dbo.datAppointment.AppointmentStatusID, dbo.cfgCenter.IsActiveFlag, dbo.datClientMembership.IsActiveFlag AS Expr1, dbo.cfgMembership.IsActiveFlag AS Expr2, dbo.datAppointment.IsDeletedFlag,
                         dbo.datAppointment.AppointmentSubject, dbo.datClient.ARBalance, dbo.datClient.GenderID, dbo.datClient.PostalCode, dbo.datClient.DateOfBirth, dbo.datClient.EMailAddress, dbo.datClient.Phone1,
                         dbo.datClient.ClientMembershipCounter, dbo.datClient.LanguageID, dbo.datClient.ClientFullNameCalc, dbo.datClient.AgeCalc, dbo.datClient.LeadCreateDate
FROM            dbo.datClient INNER JOIN
                         dbo.datClientMembership ON dbo.datClient.CurrentMDPClientMembershipGUID = dbo.datClientMembership.ClientMembershipGUID LEFT OUTER JOIN
                         dbo.cfgCenter ON dbo.datClient.CenterID = dbo.cfgCenter.CenterID AND dbo.datClientMembership.CenterID = dbo.cfgCenter.CenterID LEFT OUTER JOIN
                         dbo.cfgMembership ON dbo.datClientMembership.MembershipID = dbo.cfgMembership.MembershipID LEFT OUTER JOIN
                         dbo.datAppointment ON dbo.datClient.ClientGUID = dbo.datAppointment.ClientGUID
WHERE        (dbo.datAppointment.IsNonAppointmentFlag = 0) AND (dbo.cfgCenter.IsActiveFlag = 1) AND (dbo.datClientMembership.IsActiveFlag = 1) AND (dbo.cfgMembership.IsActiveFlag = 1) AND (dbo.datAppointment.IsDeletedFlag = 0)
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
         Begin Table = "datClient"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 136
               Right = 377
            End
            DisplayFlags = 280
            TopColumn = 78
         End
         Begin Table = "datClientMembership"
            Begin Extent =
               Top = 6
               Left = 415
               Bottom = 136
               Right = 705
            End
            DisplayFlags = 280
            TopColumn = 17
         End
         Begin Table = "cfgCenter"
            Begin Extent =
               Top = 6
               Left = 743
               Bottom = 136
               Right = 1025
            End
            DisplayFlags = 280
            TopColumn = 27
         End
         Begin Table = "cfgMembership"
            Begin Extent =
               Top = 138
               Left = 38
               Bottom = 268
               Right = 357
            End
            DisplayFlags = 280
            TopColumn = 12
         End
         Begin Table = "datAppointment"
            Begin Extent =
               Top = 138
               Left = 395
               Bottom = 268
               Right = 685
            End
            DisplayFlags = 280
            TopColumn = 8
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 32
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
     ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ClientDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ClientDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ClientDetails'
GO
