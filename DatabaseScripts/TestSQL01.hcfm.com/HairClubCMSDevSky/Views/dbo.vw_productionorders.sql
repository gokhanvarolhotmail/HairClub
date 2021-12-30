/* CreateDate: 12/31/2010 13:33:54.470 , ModifyDate: 02/18/2013 19:04:02.713 */
GO
create VIEW [dbo].[vw_productionorders]
AS
SELECT     O.ClientHomeCenterID AS center, OrigClient.ClientNumber_Temp AS clientno, 0 AS newclient, O.HairSystemOrderNumber AS serialnumb, 'zz' AS cd,
                      dbo.lkpHairSystemOrderStatus.HairSystemOrderStatusDescriptionShort AS orderstcod, 'zz' AS statusdate,
                      dbo.datClientMembership.ClientMembershipStatusID AS activeprog, dbo.cfgMembership.MembershipDescriptionShort AS programcod,
                      dbo.datClientMembership.BeginDate, dbo.datClientMembership.EndDate, '??' AS helclient, '??' AS reason, O.HairSystemOrderDate AS orderdate, O.DueDate,
                      OrigHairSystemOrder.HairSystemOrderNumber AS prevserial, O.IsRepairOrderFlag AS switch, O.IsRedoOrderFlag AS redo,
                      dbo.cfgHairSystem.HairSystemDescriptionShort AS systypecod, dbo.lkpHairSystemMatrixColor.HairSystemMatrixColorDescriptionShort AS scolorcode,
                      dbo.lkpHairSystemDesignTemplate.HairSystemDesignTemplateDescriptionShort AS templcode, CAST(O.TemplateWidth AS decimal(10, 2)) AS templwidth,
                      CAST(O.TemplateWidthAdjustment AS decimal(10, 2)) AS adjwidth, CAST(O.TemplateHeight AS decimal(10, 2)) AS templength,
                      CAST(O.TemplateHeightAdjustment AS decimal(10, 2)) AS adjlength, dbo.lkpHairSystemRecession.HairSystemRecessionDescriptionShort AS recesscode,
                      dbo.lkpHairSystemHairLength.HairSystemHairLengthDescriptionShort AS hairlcode, dbo.lkpHairSystemDensity.HairSystemDensityDescriptionShort AS densecode,
                      dbo.lkpHairSystemFrontalDensity.HairSystemFrontalDensityDescriptionShort AS frontdense,
                      dbo.lkpHairSystemFrontalDesign.HairSystemFrontalDesignDescriptionShort AS frontcode, '?' AS undervent,
                      chmmain.HairSystemHairMaterialDescriptionShort AS hairhuman, cfrmain.HairSystemHairColorDescriptionShort AS haircfront,
                      ctmmain.HairSystemHairColorDescriptionShort AS hairctempl, ctomain.HairSystemHairColorDescriptionShort AS hairctop,
                      csdmain.HairSystemHairColorDescriptionShort AS haircsides, ccrmain.HairSystemHairColorDescriptionShort AS hairccrown,
                      cbkmain.HairSystemHairColorDescriptionShort AS haircback, chmh1.HairSystemHairMaterialDescriptionShort AS highhuman,
                      chlh1.HairSystemHighlightDescriptionShort AS highstreak, cfrh1.HairSystemHairColorDescriptionShort AS highcfront,
                      pfrh1.HairSystemColorPercentageDescriptionShort AS highpfront, ctmh1.HairSystemHairColorDescriptionShort AS highctempl,
                      ptmh1.HairSystemColorPercentageDescriptionShort AS highptempl, ctoh1.HairSystemHairColorDescriptionShort AS highctop,
                      ptoh1.HairSystemColorPercentageDescriptionShort AS highptop, csdh1.HairSystemHairColorDescriptionShort AS highcsides,
                      psdh1.HairSystemColorPercentageDescriptionShort AS highpsides, ccrh1.HairSystemHairColorDescriptionShort AS highccrown,
                      pcrh1.HairSystemColorPercentageDescriptionShort AS highpcrown, cbkh1.HairSystemHairColorDescriptionShort AS highcback,
                      pbkh1.HairSystemColorPercentageDescriptionShort AS highpback, chmh2.HairSystemHairMaterialDescriptionShort AS hig2human,
                      chlh2.HairSystemHighlightDescriptionShort AS hig2streak, cfrh2.HairSystemHairColorDescriptionShort AS hig2cfront,
                      pfrh2.HairSystemColorPercentageDescriptionShort AS hig2pfront, ctmh2.HairSystemHairColorDescriptionShort AS hig2ctempl,
                      ptmh2.HairSystemColorPercentageDescriptionShort AS hig2ptempl, ctoh2.HairSystemHairColorDescriptionShort AS hig2ctop,
                      ptoh2.HairSystemColorPercentageDescriptionShort AS hig2ptop, csdh2.HairSystemHairColorDescriptionShort AS hig2csides,
                      psdh2.HairSystemColorPercentageDescriptionShort AS hig2psides, ccrh2.HairSystemHairColorDescriptionShort AS hig2ccrown,
                      pcrh2.HairSystemColorPercentageDescriptionShort AS hig2pcrown, cbkh2.HairSystemHairColorDescriptionShort AS hig2cback,
                      pbkh2.HairSystemColorPercentageDescriptionShort AS hig2pback, chmgr.HairSystemHairMaterialDescriptionShort AS greyhuman,
                      cfrgr.HairSystemColorPercentageDescriptionShort AS greypfront, ctmgr.HairSystemColorPercentageDescriptionShort AS greyptempl,
                      ctogr.HairSystemColorPercentageDescriptionShort AS greyptop, csdgr.HairSystemColorPercentageDescriptionShort AS greypsides,
                      ccrgr.HairSystemColorPercentageDescriptionShort AS greypcrown, cbkgr.HairSystemColorPercentageDescriptionShort AS greypback,
                      dbo.lkpHairSystemCurl.HairSystemCurlDescriptionShort AS hairccode, dbo.lkpHairSystemStyle.HairSystemStyleDescriptionShort AS hairscode,
                      O.CenterUseFromBridgeDistance AS frombridge, O.CenterUseIsPermFlag AS permcode, o.IsRushOrderFlag as Rush, o.IsSampleOrderFlag as 'Sample',
                      o.IsStockInventoryFlag as StockInvFlag,
                      o.CostActual AS FactCost,
                      vdr.VendorDescriptionShort as factactual
FROM         dbo.datHairSystemOrder AS O LEFT OUTER JOIN
                      dbo.lkpHairSystemOrderStatus ON O.HairSystemOrderStatusID = dbo.lkpHairSystemOrderStatus.HairSystemOrderStatusID INNER JOIN
                      dbo.datClient AS Client ON O.ClientGUID = Client.ClientGUID INNER JOIN
                      dbo.datClient AS OrigClient ON O.OriginalClientGUID = OrigClient.ClientGUID INNER JOIN
                      dbo.datClientMembership ON O.ClientMembershipGUID = dbo.datClientMembership.ClientMembershipGUID INNER JOIN
                      dbo.cfgMembership ON dbo.datClientMembership.MembershipID = dbo.cfgMembership.MembershipID LEFT OUTER JOIN
                      dbo.cfgHairSystem ON O.HairSystemID = dbo.cfgHairSystem.HairSystemID LEFT OUTER JOIN
                      dbo.datHairSystemOrder AS OrigHairSystemOrder ON O.OriginalHairSystemOrderGUID = OrigHairSystemOrder.HairSystemOrderGUID LEFT OUTER JOIN
                      dbo.lkpHairSystemMatrixColor ON O.HairSystemMatrixColorID = dbo.lkpHairSystemMatrixColor.HairSystemMatrixColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemDesignTemplate ON O.HairSystemDesignTemplateID = dbo.lkpHairSystemDesignTemplate.HairSystemDesignTemplateID LEFT OUTER JOIN
                      dbo.lkpHairSystemRecession ON O.HairSystemRecessionID = dbo.lkpHairSystemRecession.HairSystemRecessionID LEFT OUTER JOIN
                      dbo.lkpHairSystemDensity ON O.HairSystemDensityID = dbo.lkpHairSystemDensity.HairSystemDensityID LEFT OUTER JOIN
                      dbo.lkpHairSystemFrontalDensity ON O.HairSystemFrontalDensityID = dbo.lkpHairSystemFrontalDensity.HairSystemFrontalDensityID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairLength ON O.HairSystemHairLengthID = dbo.lkpHairSystemHairLength.HairSystemHairLengthID LEFT OUTER JOIN
                      dbo.lkpHairSystemFrontalDesign ON O.HairSystemFrontalDesignID = dbo.lkpHairSystemFrontalDesign.HairSystemFrontalDesignID LEFT OUTER JOIN
                      dbo.lkpHairSystemCurl ON O.HairSystemCurlID = dbo.lkpHairSystemCurl.HairSystemCurlID LEFT OUTER JOIN
                      dbo.lkpHairSystemStyle ON O.HairSystemStyleID = dbo.lkpHairSystemStyle.HairSystemStyleID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairMaterial AS chmmain ON O.ColorHairSystemHairMaterialID = chmmain.HairSystemHairMaterialID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS cfrmain ON O.ColorFrontHairSystemHairColorID = cfrmain.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS ctmmain ON O.ColorTempleHairSystemHairColorID = ctmmain.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS ctomain ON O.ColorTopHairSystemHairColorID = ctomain.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS csdmain ON O.ColorSidesHairSystemHairColorID = csdmain.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS ccrmain ON O.ColorCrownHairSystemHairColorID = ccrmain.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS cbkmain ON O.ColorBackHairSystemHairColorID = cbkmain.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairMaterial AS chmh1 ON O.Highlight1HairSystemHairMaterialID = chmh1.HairSystemHairMaterialID LEFT OUTER JOIN
                      dbo.lkpHairSystemHighlight AS chlh1 ON O.Highlight1HairSystemHighlightID = chlh1.HairSystemHighlightID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS cfrh1 ON O.Highlight1FrontHairSystemHairColorID = cfrh1.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS pfrh1 ON O.Highlight1FrontHairSystemColorPercentageID = pfrh1.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS ctmh1 ON O.Highlight1TempleHairSystemHairColorID = ctmh1.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS ptmh1 ON O.Highlight1TempleHairSystemColorPercentageID = ptmh1.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS ctoh1 ON O.Highlight1TopHairSystemHairColorID = ctoh1.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS ptoh1 ON O.Highlight1TopHairSystemColorPercentageID = ptoh1.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS csdh1 ON O.Highlight1SidesHairSystemHairColorID = csdh1.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS psdh1 ON O.Highlight1SidesHairSystemColorPercentageID = psdh1.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS ccrh1 ON O.Highlight1CrownHairSystemHairColorID = ccrh1.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS pcrh1 ON O.Highlight1CrownHairSystemColorPercentageID = pcrh1.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS cbkh1 ON O.Highlight1BackHairSystemHairColorID = cbkh1.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS pbkh1 ON O.Highlight1BackHairSystemColorPercentageID = pbkh1.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairMaterial AS chmh2 ON O.Highlight2HairSystemHairMaterialID = chmh2.HairSystemHairMaterialID LEFT OUTER JOIN
                      dbo.lkpHairSystemHighlight AS chlh2 ON O.Highlight2HairSystemHighlightID = chlh2.HairSystemHighlightID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS cfrh2 ON O.Highlight2FrontHairSystemHairColorID = cfrh2.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS pfrh2 ON O.Highlight2FrontHairSystemColorPercentageID = pfrh2.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS ctmh2 ON O.Highlight2TempleHairSystemHairColorID = ctmh2.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS ptmh2 ON O.Highlight2TempleHairSystemColorPercentageID = ptmh2.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS ctoh2 ON O.Highlight2TopHairSystemHairColorID = ctoh2.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS ptoh2 ON O.Highlight2TopHairSystemColorPercentageID = ptoh2.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS csdh2 ON O.Highlight2SidesHairSystemHairColorID = csdh2.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS psdh2 ON O.Highlight2SidesHairSystemColorPercentageID = psdh2.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS ccrh2 ON O.Highlight2CrownHairSystemHairColorID = ccrh2.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS pcrh2 ON O.Highlight2CrownHairSystemColorPercentageID = pcrh2.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairColor AS cbkh2 ON O.Highlight2BackHairSystemHairColorID = cbkh2.HairSystemHairColorID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS pbkh2 ON O.Highlight2BackHairSystemColorPercentageID = pbkh2.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemHairMaterial AS chmgr ON O.GreyHairSystemHairMaterialID = chmgr.HairSystemHairMaterialID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS cfrgr ON O.GreyFrontHairSystemColorPercentageID = cfrgr.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS ctmgr ON O.GreyTempleHairSystemColorPercentageID = ctmgr.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS ctogr ON O.GreyTopHairSystemColorPercentageID = ctogr.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS csdgr ON O.GreySidesHairSystemColorPercentageID = csdgr.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS ccrgr ON O.GreyCrownHairSystemColorPercentageID = ccrgr.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.lkpHairSystemColorPercentage AS cbkgr ON O.GreyBackHairSystemColorPercentageID = cbkgr.HairSystemColorPercentageID LEFT OUTER JOIN
                      dbo.datPurchaseOrderDetail as pod on o.HairSystemOrderGUID = pod.HairSystemOrderGUID left outer join
                      dbo.datPurchaseOrder as po on pod.PurchaseOrderGUID = po.PurchaseOrderGUID left outer join
                      dbo.cfgVendor vdr on po.VendorID = vdr.VendorID
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
         Begin Table = "O"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 125
               Right = 353
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lkpHairSystemOrderStatus"
            Begin Extent =
               Top = 6
               Left = 391
               Bottom = 125
               Right = 672
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Client"
            Begin Extent =
               Top = 126
               Left = 38
               Bottom = 245
               Right = 353
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrigClient"
            Begin Extent =
               Top = 126
               Left = 391
               Bottom = 245
               Right = 706
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "datClientMembership"
            Begin Extent =
               Top = 246
               Left = 38
               Bottom = 365
               Right = 263
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cfgMembership"
            Begin Extent =
               Top = 246
               Left = 301
               Bottom = 365
               Right = 526
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cfgHairSystem"
            Begin Extent =
               Top = 246
               Left = 564
               Bottom = 365
               Right = 786
           ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_productionorders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrigHairSystemOrder"
            Begin Extent =
               Top = 366
               Left = 38
               Bottom = 485
               Right = 353
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lkpHairSystemMatrixColor"
            Begin Extent =
               Top = 366
               Left = 391
               Bottom = 485
               Right = 668
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lkpHairSystemDesignTemplate"
            Begin Extent =
               Top = 486
               Left = 38
               Bottom = 605
               Right = 336
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lkpHairSystemRecession"
            Begin Extent =
               Top = 486
               Left = 374
               Bottom = 605
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lkpHairSystemDensity"
            Begin Extent =
               Top = 606
               Left = 38
               Bottom = 725
               Right = 296
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lkpHairSystemFrontalDensity"
            Begin Extent =
               Top = 606
               Left = 334
               Bottom = 725
               Right = 626
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lkpHairSystemHairLength"
            Begin Extent =
               Top = 726
               Left = 38
               Bottom = 845
               Right = 312
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lkpHairSystemFrontalDesign"
            Begin Extent =
               Top = 726
               Left = 350
               Bottom = 845
               Right = 638
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lkpHairSystemCurl"
            Begin Extent =
               Top = 846
               Left = 38
               Bottom = 965
               Right = 279
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "lkpHairSystemStyle"
            Begin Extent =
               Top = 846
               Left = 317
               Bottom = 965
               Right = 563
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "chmmain"
            Begin Extent =
               Top = 966
               Left = 38
               Bottom = 1085
               Right = 317
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cfrmain"
            Begin Extent =
               Top = 966
               Left = 355
               Bottom = 1085
               Right = 621
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ctmmain"
            Begin Extent =
               Top = 1086
               Left = 38
               Bottom = 1205
               Right = 304
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ctomain"
            Begin Extent =
               Top = 1086
           ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_productionorders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane3', @value=N'    Left = 342
               Bottom = 1205
               Right = 608
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "csdmain"
            Begin Extent =
               Top = 1206
               Left = 38
               Bottom = 1325
               Right = 304
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ccrmain"
            Begin Extent =
               Top = 1206
               Left = 342
               Bottom = 1325
               Right = 608
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cbkmain"
            Begin Extent =
               Top = 1326
               Left = 38
               Bottom = 1445
               Right = 304
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "chmh1"
            Begin Extent =
               Top = 1326
               Left = 342
               Bottom = 1445
               Right = 621
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "chlh1"
            Begin Extent =
               Top = 1446
               Left = 38
               Bottom = 1565
               Right = 301
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cfrh1"
            Begin Extent =
               Top = 1446
               Left = 339
               Bottom = 1565
               Right = 605
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pfrh1"
            Begin Extent =
               Top = 1566
               Left = 38
               Bottom = 1685
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ctmh1"
            Begin Extent =
               Top = 1566
               Left = 378
               Bottom = 1685
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ptmh1"
            Begin Extent =
               Top = 1686
               Left = 38
               Bottom = 1805
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ctoh1"
            Begin Extent =
               Top = 1686
               Left = 378
               Bottom = 1805
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ptoh1"
            Begin Extent =
               Top = 1806
               Left = 38
               Bottom = 1925
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "csdh1"
            Begin Extent =
               Top = 1806
               Left = 378
               Bottom = 1925
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "psdh1"
            Begin Extent =
               Top = 1926
               Left = 38
               Bottom = 2045
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ccrh1"
            Begin Extent =
               Top = 1926
               Left = 378
               Bottom = 2045
               Right =' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_productionorders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane4', @value=N' 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pcrh1"
            Begin Extent =
               Top = 2046
               Left = 38
               Bottom = 2165
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cbkh1"
            Begin Extent =
               Top = 2046
               Left = 378
               Bottom = 2165
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pbkh1"
            Begin Extent =
               Top = 2166
               Left = 38
               Bottom = 2285
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "chmh2"
            Begin Extent =
               Top = 2166
               Left = 378
               Bottom = 2285
               Right = 657
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "chlh2"
            Begin Extent =
               Top = 2286
               Left = 38
               Bottom = 2405
               Right = 301
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cfrh2"
            Begin Extent =
               Top = 2286
               Left = 339
               Bottom = 2405
               Right = 605
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pfrh2"
            Begin Extent =
               Top = 2406
               Left = 38
               Bottom = 2525
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ctmh2"
            Begin Extent =
               Top = 2406
               Left = 378
               Bottom = 2525
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ptmh2"
            Begin Extent =
               Top = 2526
               Left = 38
               Bottom = 2645
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ctoh2"
            Begin Extent =
               Top = 2526
               Left = 378
               Bottom = 2645
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ptoh2"
            Begin Extent =
               Top = 2646
               Left = 38
               Bottom = 2765
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "csdh2"
            Begin Extent =
               Top = 2646
               Left = 378
               Bottom = 2765
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "psdh2"
            Begin Extent =
               Top = 2766
               Left = 38
               Bottom = 2885
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ccrh2"
            Begin Extent =
               Top = 2766
               Left = 378
               Bottom = 2885
               Right = 644
            End
            DisplayFlags = 280
            TopColu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_productionorders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane5', @value=N'mn = 0
         End
         Begin Table = "pcrh2"
            Begin Extent =
               Top = 2886
               Left = 38
               Bottom = 3005
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cbkh2"
            Begin Extent =
               Top = 2886
               Left = 378
               Bottom = 3005
               Right = 644
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pbkh2"
            Begin Extent =
               Top = 3006
               Left = 38
               Bottom = 3125
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "chmgr"
            Begin Extent =
               Top = 3006
               Left = 378
               Bottom = 3125
               Right = 657
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cfrgr"
            Begin Extent =
               Top = 3126
               Left = 38
               Bottom = 3245
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ctmgr"
            Begin Extent =
               Top = 3126
               Left = 378
               Bottom = 3245
               Right = 680
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ctogr"
            Begin Extent =
               Top = 3246
               Left = 38
               Bottom = 3365
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "csdgr"
            Begin Extent =
               Top = 3246
               Left = 378
               Bottom = 3365
               Right = 680
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ccrgr"
            Begin Extent =
               Top = 3366
               Left = 38
               Bottom = 3485
               Right = 340
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cbkgr"
            Begin Extent =
               Top = 3366
               Left = 378
               Bottom = 3485
               Right = 680
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
         Alias = 1650
         Table = 1635
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_productionorders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=5 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_productionorders'
GO
