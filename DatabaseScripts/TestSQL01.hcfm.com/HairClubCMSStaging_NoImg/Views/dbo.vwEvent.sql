/* CreateDate: 02/25/2009 12:08:21.830 , ModifyDate: 10/11/2012 10:31:19.183 */
GO
CREATE VIEW [dbo].[vwEvent]
AS
SELECT dr.ExternalSchedulerResourceID AS ResourceID,
	ISNULL(c.LastName, '') + ', ' + ISNULL(c.FirstName, '')
			+ '<BR>' + 'FROM:' + CAST(c.CenterID AS varchar) + '<BR>' + 'TO:' + CAST(a.CenterID AS varchar)
			+ '<BR>' + REPLACE('GRF:' + LTRIM(CAST(ISNULL(cma.TotalAccumQuantity, 0) AS varchar)), 'GRF:0', 'GRF:0000')
			+ '<BR>' + REPLACE(dbo.APPT_DETAILS(a.CenterID, a.AppointmentGUID), 'SURPOST', 'SURAPPT') AS Description,
	'CLEAR THIS' AS Notes,
	a.StartDateTimeCalc AS SchFrom, a.EndDateTimeCalc AS SchTo, 1 AS LoginID, a.AppointmentDate AS Created, 'kmurdoch@hcfm.com' AS Email,
	CASE				--	1		3		4		16		7		8		9		10		11		12		13		14		15
		WHEN a.CenterID IN (313,			305,	311,	361,	332,	301,	330,	691,	307,	364,	545,	328) THEN 'darkgreen'
		WHEN a.CenterID IN (349,	370,	306,	314,	379,	333,	303,	335,			308,	386,			329) THEN 'indigo'
		WHEN a.CenterID IN (350,	371,	310,	375,	380,	340,	304,	337,			309,	387,			365) THEN 'navy'
		WHEN a.CenterID IN (390,	374,	312,	376,	381,	355,	316,	358,			382						   ) THEN 'royalblue'
		WHEN a.CenterID IN (394,	378,	320,	395,	388,	360,	325,	363										   ) THEN 'deepskyblue'
		WHEN a.CenterID IN (396,			359, 	315,	391,			326,	383,							546		   ) THEN 'darkred'
		WHEN a.CenterID IN (				368,			392,			367,	384,							547		   ) THEN 'brown'
		WHEN a.CenterID IN (																385,					548		   ) THEN 'darkolivegreen'
		ELSE 'grey' END AS Color,
	'|||||||||' AS Misc, 0 AS RepeatID, 0 AS EmailSent, 60 AS Remind, 0 AS AllDay
FROM datAppointment AS a
	INNER JOIN datClient AS c ON a.ClientGUID = c.ClientGUID
	INNER JOIN datClientMembership AS cm ON a.ClientMembershipGUID = cm.ClientMembershipGUID
	INNER JOIN cfgCenter AS ctr ON a.CenterID = ctr.CenterID
	INNER JOIN datAppointmentEmployee AS ae ON a.AppointmentGUID = ae.AppointmentGUID
	INNER JOIN datEmployee AS e ON ae.EmployeeGUID = e.EmployeeGUID
	INNER JOIN cfgEmployeePositionJoin AS epj ON e.EmployeeGUID = epj.EmployeeGUID
	INNER JOIN lkpEmployeePosition AS ep ON epj.EmployeePositionID = ep.EmployeePositionID
	LEFT JOIN lkpDoctorRegion AS dr ON ctr.DoctorRegionID = dr.DoctorRegionID
	LEFT JOIN datClientMembershipAccum AS cma ON cm.ClientMembershipGUID = cma.ClientMembershipGUID AND cma.AccumulatorID = 12
WHERE (NOT (ctr.SurgeryHubCenterID IS NULL))
	AND (ep.EmployeePositionDescriptionShort = 'Doctor')
	AND (a.IsNonAppointmentFlag IS NULL OR a.IsNonAppointmentFlag = 0)
	AND (a.IsDeletedFlag IS NULL OR a.IsDeletedFlag <> 1)
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
         Begin Table = "a"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 121
               Right = 241
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent =
               Top = 6
               Left = 279
               Bottom = 121
               Right = 463
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ae"
            Begin Extent =
               Top = 6
               Left = 501
               Bottom = 121
               Right = 714
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent =
               Top = 6
               Left = 752
               Bottom = 121
               Right = 953
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwEvent'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwEvent'
GO
