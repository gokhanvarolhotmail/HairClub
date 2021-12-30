/* CreateDate: 10/27/2014 10:02:30.963 , ModifyDate: 11/06/2014 16:52:59.847 */
GO
CREATE VIEW [dbo].[cstv_queue_report_by_date]
AS
SELECT queue_id, CONVERT(datetime,CONVERT(nchar(10),start_date, 121))  AS start_date,
	COUNT(DISTINCT user_code) AS total_users,
   (SELECT COUNT(DISTINCT dbo.oncd_activity_contact.contact_id) AS Expr1
    FROM dbo.psoActivitiesInQueueForDates(csta_queue_user_history.queue_id, CONVERT(datetime,CONVERT(nchar(10),csta_queue_user_history.start_date,121)), DATEADD(day,1,CONVERT(datetime,CONVERT(nchar(10),csta_queue_user_history.start_date,121)))) qa
		INNER JOIN dbo.oncd_activity WITH (NOLOCK) ON qa.activity_id = dbo.oncd_activity.activity_id
		INNER JOIN dbo.oncd_activity_contact WITH (NOLOCK) ON dbo.oncd_activity.activity_id = dbo.oncd_activity_contact.activity_id
    WHERE   (dbo.oncd_activity.result_code IS NOT NULL)) AS total_leads,
    (SELECT COUNT(DISTINCT activity_id) AS Expr1
    FROM      dbo.oncd_activity AS oncd_activity_3 WITH (NOLOCK)
    WHERE   (completion_date = CONVERT(datetime,CONVERT(nchar(10),csta_queue_user_history.start_date,121))) AND (cst_queue_id = csta_queue_user_history.queue_id)) AS completed_activities,
    (SELECT COUNT(DISTINCT activity_id) AS Expr1
    FROM      dbo.oncd_activity AS oncd_activity_2 WITH (NOLOCK)
    WHERE   (result_code = 'APPOINT') AND (completion_date = CONVERT(datetime,CONVERT(nchar(10), csta_queue_user_history.start_date, 121))) AND (cst_queue_id = csta_queue_user_history.queue_id)) AS appointment_activities,
    (SELECT COUNT(DISTINCT activity_id) AS Expr1
    FROM      dbo.oncd_activity AS oncd_activity_1 WITH (NOLOCK)
    WHERE   (result_code = 'BROCHURE') AND (completion_date = CONVERT(datetime,CONVERT(nchar(10), csta_queue_user_history.start_date, 121)) AND (cst_queue_id = csta_queue_user_history.queue_id))) AS brochure_activities,
	SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) AS total_seconds,
	SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) / 3600 AS hours,
	SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) % 3600 / 60 AS minutes,
	SUM(DATEDIFF(s, start_date, ISNULL(end_date, GETDATE()))) % 3600 % 60 AS seconds
FROM     dbo.csta_queue_user_history WITH (NOLOCK)
GROUP BY queue_id, CONVERT(datetime,CONVERT(nchar(10),start_date, 121))
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
         Begin Table = "cstv_user_queue_history"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 114
               Right = 205
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
      Begin ColumnWidths = 9
         Width = 284
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
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'cstv_queue_report_by_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'cstv_queue_report_by_date'
GO
