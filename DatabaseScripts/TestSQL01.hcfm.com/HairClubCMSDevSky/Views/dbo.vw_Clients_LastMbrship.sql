/* CreateDate: 03/28/2011 11:18:39.670 , ModifyDate: 02/18/2013 19:04:02.583 */
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vw_Clients_LastMbrship]
AS
SELECT
	vw_Clients_Abbreviated.CenterID
	, CenterDescription
	, CenterName
	, ClientIdentifier
	, ClientNumber_Temp
	, vw_Clients_Abbreviated.ClientGUID
	, FirstName
	, LastName
	, ClientName
	, vw_Clients_Abbreviated.GenderID
	, Gender
	, GenderDescriptionShort
	, DateOfBirth
	, Age
	, Address
	, City
	, State
	, Zip
	, CountryID
	, Country
	, CountryDescriptionShort
	, HomePhone
	, WorkPhone
	, HomePhoneUnformatted
	, WorkPhoneUnformatted
	, HphoneAC
	, EMailAddress
	, TextMessageAddress
	, DoNotCallFlag
	, DoNotContactFlag
	, IsTaxExemptFlag
	, ContactID
	, vw_Clients_Abbreviated.CreateUser
	, vw_Clients_Abbreviated.CreateDate
	, ARBalance
        --                  (SELECT  cfgmembership_1.MembershipDescriptionShort
        --                    FROM          SQL05.HairclubCMS.dbo.datClientmembership AS datClientmembership_1
								--INNER JOIN SQL05.HairclubCMS.dbo.datClient AS datClient_1 ON
								--	datClient_1.ClientGUID = datClientmembership_1.ClientGUID INNER JOIN
        --                                           SQL05.HairclubCMS.dbo.cfgmembership AS cfgmembership_1 ON
        --                                           cfgmembership_1.MembershipID = datClientmembership_1.MembershipID
        --                    WHERE      (datClientmembership_1.ClientGUID = dbo.vw_Clients_Abbreviated.ClientGUID)
        --                    ORDER BY datClientmembership_1.EndDate DESC)
     , cfgmembership_1.MembershipDescriptionShort AS Membership
     , datClientMembership.BeginDate
     , datClientMembership.EndDate

FROM         dbo.vw_Clients_Abbreviated
			INNER JOIN datClientmembership AS datClientmembership ON
				datClientmembership.ClientmembershipGUID = vw_Clients_Abbreviated.CurrentSurgeryClientMembershipGUID
			INNER JOIN cfgmembership AS cfgmembership_1 ON
                cfgmembership_1.MembershipID = datClientmembership.MembershipID
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
         Begin Table = "vw_Clients_Abbreviated"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 121
               Right = 237
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Clients_LastMbrship'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_Clients_LastMbrship'
GO
