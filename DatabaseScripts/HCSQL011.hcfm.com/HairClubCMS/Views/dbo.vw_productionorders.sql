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
