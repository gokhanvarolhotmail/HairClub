/* CreateDate: 10/05/2021 17:03:54.567 , ModifyDate: 10/05/2021 17:03:54.567 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		rrojas
-- Create date: 27/09/2021
-- Description:	Signature Hairline orders by factory report
-- =============================================
CREATE PROCEDURE spGetSignatureHairlineOrdersByFactory
	-- Add the parameters for the stored procedure here
	@startOrderDate date,
	@endOrderDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT	hso.HairSystemOrderNumber
,		po.PurchaseOrderNumber
,		ISNULL(v.VendorDescriptionShort, 'NA') AS 'FactoryCode'
,		ISNULL(v.VendorDescription, 'NA') AS 'Factory'
,		ISNULL(VendorAddress2, '') AS 'VendorAddress2'
,		hso.ClientHomeCenterID AS 'CenterID'
,		ctr.CenterDescription
,		ctr.CenterDescriptionFullCalc AS 'CenterDescriptionNumber'
,		ct.CenterTypeDescriptionShort
,		COALESCE(CONVERT(NVARCHAR, c.ClientIdentifier) + '  ', '  ') + c.ClientFullNameAlt2Calc AS 'ClientFullName'
,		m.MembershipDescription
,		hso.HairSystemOrderDate
,		hso.DueDate
,		hso.IsRedoOrderFlag
,		hso.IsRepairOrderFlag
,		CASE WHEN ISNULL(hsdt.IsManualTemplateFlag, 0) = 1 OR ISNULL(hsdt.IsMeasurementFlag, 0) = 1 THEN 1 ELSE 0 END AS 'HasSampleOrTemplate'
,		hsdt.IsMeasurementFlag
,		hsdt.IsManualTemplateFlag
,		hsos.HairSystemOrderStatusDescriptionShort
,		hs.HairSystemDescriptionShort
,		hs.HairSystemDescription
,		hsmc.HairSystemMatrixColorDescriptionShort
,		hsmc.HairSystemMatrixColorDescription
,		hsdt.HairSystemDesignTemplateDescriptionShort
,		hsdt.HairSystemDesignTemplateDescription
,		hso.TemplateAreaActualCalc
,		hso.TemplateWidth
,		hso.TemplateWidthAdjustment
,		hso.TemplateHeight
,		hso.TemplateHeightAdjustment
,		hsr.HairSystemRecessionDescriptionShort
,		hsr.HairSystemRecessionDescription
,		hshl.HairSystemHairLengthDescriptionShort
,		hshl.HairSystemHairLengthDescription
,		hsd.HairSystemDensityDescriptionShort
,		hsd.HairSystemDensityDescription
,		hsfdn.HairSystemFrontalDensityDescriptionShort
,		hsfdn.HairSystemFrontalDensityDescription
,		hsfds.HairSystemFrontalDesignDescriptionShort
,		hsfds.HairSystemFrontalDesignDescription
,		hsc.HairSystemCurlDescriptionShort
,		hsc.HairSystemCurlDescription
,		hss.HairSystemStyleDescriptionShort
,		hss.HairSystemStyleDescription

/* color */
,		chshm.HairSystemHairMaterialDescription AS 'ColorHairSystemHairMaterialDescription'
,		cfhshhc.HairSystemHairColorDescription AS 'ColorFrontHairSystemHairColorDescription'
,		cthshhc.HairSystemHairColorDescription AS 'ColorTempleHairSystemHairColorDescription'
,		ctphshhc.HairSystemHairColorDescription AS 'ColorTopHairSystemHairColorDescription'
,		cshshhc.HairSystemHairColorDescription AS 'ColorSidesHairSystemHairColorDescription'
,		cchshhc.HairSystemHairColorDescription AS 'ColorCrownHairSystemHairColorDescription'
,		cbhshhc.HairSystemHairColorDescription AS 'ColorBackHairSystemHairColorDescription'

/* highlight1 */
,		h1hshm.HairSystemHairMaterialDescription AS 'Highlight1HairSystemHairMaterialDescription'
,		h1fhshhc.HairSystemHairColorDescription AS 'Highlight1FrontHairSystemHairColorDescription'
,		h1thshhc.HairSystemHairColorDescription AS 'Highlight1TempleHairSystemHairColorDescription'
,		h1tphshhc.HairSystemHairColorDescription AS 'Highlight1TopHairSystemHairColorDescription'
,		h1shshhc.HairSystemHairColorDescription AS 'Highlight1SidesHairSystemHairColorDescription'
,		h1hshhc.HairSystemHairColorDescription AS 'Highlight1CrownHairSystemHairColorDescription'
,		h1bhshhc.HairSystemHairColorDescription AS 'Highlight1BackHairSystemHairColorDescription'

/* highlight1 color percentage */
,		h1hsh.HairSystemHighlightDescription AS 'Highlight1HairSystemHighlightDescription'
,		h1fhscp.HairSystemColorPercentageDescription AS 'Highlight1FrontHairSystemColorPercentageDescription'
,		h1thscp.HairSystemColorPercentageDescription AS 'Highlight1TempleHairSystemColorPercentageDescription'
,		h1tphscp.HairSystemColorPercentageDescription AS 'Highlight1TopHairSystemColorPercentageDescription'
,		h1shscp.HairSystemColorPercentageDescription AS 'Highlight1SidesHairSystemColorPercentageDescription'
,		h1hscp.HairSystemColorPercentageDescription AS 'Highlight1CrownHairSystemColorPercentageDescription'
,		h1bhscp.HairSystemColorPercentageDescription AS 'Highlight1BackHairSystemColorPercentageDescription'

/* highlight2 */
,		h2hshm.HairSystemHairMaterialDescription AS 'Highlight2HairSystemHairMaterialDescription'
,		h2fhshhc.HairSystemHairColorDescription AS 'Highlight2FrontHairSystemHairColorDescription'
,		h2thshhc.HairSystemHairColorDescription AS 'Highlight2TempleHairSystemHairColorDescription'
,		h2tphshhc.HairSystemHairColorDescription AS 'Highlight2TopHairSystemHairColorDescription'
,		h2shshhc.HairSystemHairColorDescription AS 'Highlight2SidesHairSystemHairColorDescription'
,		h2hshhc.HairSystemHairColorDescription AS 'Highlight2CrownHairSystemHairColorDescription'
,		h2bhshhc.HairSystemHairColorDescription AS 'Highlight2BackHairSystemHairColorDescription'

/* highlight2 color percentage */
,		h2hsh.HairSystemHighlightDescription AS 'Highlight2HairSystemHighlightDescription'
,		h2fhscp.HairSystemColorPercentageDescription AS 'Highlight2FrontHairSystemColorPercentageDescription'
,		h2thscp.HairSystemColorPercentageDescription AS 'Highlight2TempleHairSystemColorPercentageDescription'
,		h2tphscp.HairSystemColorPercentageDescription AS 'Highlight2TopHairSystemColorPercentageDescription'
,		h2shscp.HairSystemColorPercentageDescription AS 'Highlight2SidesHairSystemColorPercentageDescription'
,		h2hscp.HairSystemColorPercentageDescription AS 'Highlight2CrownHairSystemColorPercentageDescription'
,		h2bhscp.HairSystemColorPercentageDescription AS 'Highlight2BackHairSystemColorPercentageDescription'

/* grey */
,		ghshm.HairSystemHairMaterialDescription AS 'GreyHairSystemHairMaterialDescription'
,		gfhscp.HairSystemColorPercentageDescription AS 'GreyFrontHairSystemColorPercentageDescription'
,		gthscp.HairSystemColorPercentageDescription AS 'GreyTempleHairSystemColorPercentageDescription'
,		gtphscp.HairSystemColorPercentageDescription AS 'GreyTopHairSystemColorPercentageDescription'
,		gshscp.HairSystemColorPercentageDescription AS 'GreySidesHairSystemColorPercentageDescription'
,		ghscp.HairSystemColorPercentageDescription AS 'GreyCrownHairSystemColorPercentageDescription'
,		gbhscp.HairSystemColorPercentageDescription AS 'GreyBackHairSystemColorPercentageDescription'

/* MEA */
,		hsom.StartingPointMeasurement
,		hsom.CircumferenceMeasurement
,		hsom.FrontToBackMeasurement
,		hsom.EarToEarOverFrontMeasurement
,		hsom.EarToEarOverTopMeasurement
,		hsom.SideburnToSideburnMeasurement
,		hsom.TempleToTempleMeasurement
,		hsom.NapeAreaMeasurement
,		hsr2.HairSystemRecessionDescriptionShort AS 'MEAHairSystemRecessionDescription'
,		hsom.AreSideburnsAndTemplesLaceFlag
,		hsom.FrontLaceMeasurement
,		ISNULL(hsom.SideburnTemplateDiagram, 0) AS 'SideburnTemplateDiagram'
,		emp.EmployeeInitials AS 'MeasurementsBy'
,		dbo.fnGetNotesForHairSystemOrder(hso.HairSystemOrderGUID) AS 'FactoryNote'
,		hso.CenterUseFromBridgeDistance
,		hso.CenterUseIsPermFlag
,		cd.ChargeDecisionDescription AS 'CreditDecisionDescription'
,		cd.ChargeDecisionDescriptionShort AS 'CreditDecisionDescriptionShort'

/* HairSystem Location Information */
,		hsl.CabinetNumber
,		hsl.BinNumber
,		hsl.DrawerNumber

/*  lace length */
,		fll.HairSystemFrontalLaceLengthDescription
,		fll.HairSystemFrontalLaceLengthDescriptionShort
,		hso.IsFashionHairlineHighlightsFlag
,		hso.AllocationDate
FROM	datHairSystemOrder hso
		LEFT JOIN datPurchaseOrderDetail pod
			ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID
		LEFT JOIN datPurchaseOrder po
			ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
		LEFT JOIN cfgVendor v
			ON po.VendorID = v.VendorID
		LEFT JOIN cfgCenter ctr
			ON hso.ClientHomeCenterID = ctr.CenterID
		LEFT JOIN lkpCenterType ct
			ON ctr.CenterTypeID = ct.CenterTypeID
		LEFT JOIN datClient c
			ON hso.ClientGUID = c.ClientGUID
		LEFT JOIN datClientMembership cm
			ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
		LEFT JOIN cfgMembership m
			ON cm.MembershipID = m.MembershipID
		LEFT JOIN lkpHairSystemOrderStatus hsos
			ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
		LEFT JOIN cfgHairSystem hs
			ON hso.HairSystemID = hs.HairSystemID

		LEFT JOIN lkpHairSystemMatrixColor hsmc
			ON hso.HairSystemMatrixColorID = hsmc.HairSystemMatrixColorID
		LEFT JOIN lkpHairSystemDesignTemplate hsdt
			ON hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID
		LEFT JOIN lkpHairSystemRecession hsr
			ON hso.HairSystemRecessionID = hsr.HairSystemRecessionID
		LEFT JOIN lkpHairSystemHairLength hshl
			ON hso.HairSystemHairLengthID = hshl.HairSystemHairLengthID
		LEFT JOIN lkpHairSystemDensity hsd
			ON hso.HairSystemDensityID = hsd.HairSystemDensityID
		LEFT JOIN lkpHairSystemFrontalDensity hsfdn
			ON hso.HairSystemFrontalDensityID = hsfdn.HairSystemFrontalDensityID
		LEFT JOIN lkpHairSystemFrontalDesign hsfds
			ON hso.HairSystemFrontalDesignID = hsfds.HairSystemFrontalDesignID
		LEFT JOIN lkpHairSystemCurl hsc
			ON hso.HairSystemCurlID = hsc.HairSystemCurlID
		LEFT JOIN lkpHairSystemStyle hss
			ON hso.HairSystemStyleID = hss.HairSystemStyleID
		LEFT JOIN datHairSystemOrderMeasurement hsom
			ON hso.HairSystemOrderGUID = hsom.HairSystemOrderGUID
		LEFT JOIN lkpHairSystemRecession hsr2
			ON hsom.HairSystemRecessionID = hsr2.HairSystemRecessionID
		LEFT JOIN datEmployee emp
			ON hso.MeasurementEmployeeGUID = emp.EmployeeGUID

		/* color */
		LEFT JOIN lkpHairSystemHairMaterial chshm
			ON hso.ColorHairSystemHairMaterialID = chshm.HairSystemHairMaterialID
		LEFT JOIN lkpHairSystemHairColor cfhshhc
			ON hso.ColorFrontHairSystemHairColorID = cfhshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor cthshhc
			ON hso.ColorTempleHairSystemHairColorID = cthshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor ctphshhc
			ON hso.ColorTopHairSystemHairColorID = ctphshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor cshshhc
			ON hso.ColorSidesHairSystemHairColorID = cshshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor cchshhc
			ON hso.ColorCrownHairSystemHairColorID = cchshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor cbhshhc
			ON hso.ColorBackHairSystemHairColorID = cbhshhc.HairSystemHairColorID

		/* highlight1 */
		LEFT JOIN lkpHairSystemHairMaterial h1hshm
			ON hso.Highlight1HairSystemHairMaterialID = h1hshm.HairSystemHairMaterialID
		LEFT JOIN lkpHairSystemHairColor h1fhshhc
			ON hso.Highlight1FrontHairSystemHairColorID = h1fhshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor h1thshhc
			ON hso.Highlight1TempleHairSystemHairColorID = h1thshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor h1tphshhc
			ON hso.Highlight1TopHairSystemHairColorID = h1tphshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor h1shshhc
			ON hso.Highlight1SidesHairSystemHairColorID = h1shshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor h1hshhc
			ON hso.Highlight1CrownHairSystemHairColorID = h1hshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor h1bhshhc
			ON hso.Highlight1BackHairSystemHairColorID = h1bhshhc.HairSystemHairColorID

		/* highlight1 color percentage */
		LEFT JOIN lkpHairSystemHighlight h1hsh
			ON hso.Highlight1HairSystemHighlightID = h1hsh.HairSystemHighlightID
		LEFT JOIN lkpHairSystemColorPercentage h1fhscp
			ON hso.Highlight1FrontHairSystemColorPercentageID = h1fhscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage h1thscp
			ON hso.Highlight1TempleHairSystemColorPercentageID = h1thscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage h1tphscp
			ON hso.Highlight1TopHairSystemColorPercentageID = h1tphscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage h1shscp
			ON hso.Highlight1SidesHairSystemColorPercentageID = h1shscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage h1hscp
			ON hso.Highlight1CrownHairSystemColorPercentageID = h1hscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage h1bhscp
			ON hso.Highlight1BackHairSystemColorPercentageID = h1bhscp.HairSystemColorPercentageID

		/* highlight2 */
		LEFT JOIN lkpHairSystemHairMaterial h2hshm
			ON hso.Highlight2HairSystemHairMaterialID = h2hshm.HairSystemHairMaterialID
		LEFT JOIN lkpHairSystemHairColor h2fhshhc
			ON hso.Highlight2FrontHairSystemHairColorID = h2fhshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor h2thshhc
			ON hso.Highlight2TempleHairSystemHairColorID = h2thshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor h2tphshhc
			ON hso.Highlight2TopHairSystemHairColorID = h2tphshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor h2shshhc
			ON hso.Highlight2SidesHairSystemHairColorID = h2shshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor h2hshhc
			ON hso.Highlight2CrownHairSystemHairColorID = h2hshhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemHairColor h2bhshhc
			ON hso.Highlight2BackHairSystemHairColorID = h2bhshhc.HairSystemHairColorID

		/* highlight2 color percentage */
		LEFT JOIN lkpHairSystemHighlight h2hsh
			ON hso.Highlight2HairSystemHighlightID = h2hsh.HairSystemHighlightID
		LEFT JOIN lkpHairSystemColorPercentage h2fhscp
			ON hso.Highlight2FrontHairSystemColorPercentageID = h2fhscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage h2thscp
			ON hso.Highlight2TempleHairSystemColorPercentageID = h2thscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage h2tphscp
			ON hso.Highlight2TopHairSystemColorPercentageID = h2tphscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage h2shscp
			ON hso.Highlight2SidesHairSystemColorPercentageID = h2shscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage h2hscp
			ON hso.Highlight2CrownHairSystemColorPercentageID = h2hscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage h2bhscp
			ON hso.Highlight2BackHairSystemColorPercentageID = h2bhscp.HairSystemColorPercentageID

		/* grey */
		LEFT JOIN lkpHairSystemHairMaterial ghshm
			ON hso.GreyHairSystemHairMaterialID = ghshm.HairSystemHairMaterialID
		LEFT JOIN lkpHairSystemColorPercentage gfhscp
			ON hso.GreyFrontHairSystemColorPercentageID = gfhscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage gthscp
			ON hso.GreyTempleHairSystemColorPercentageID = gthscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage gtphscp
			ON hso.GreyTopHairSystemColorPercentageID = gtphscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage gshscp
			ON hso.GreySidesHairSystemColorPercentageID = gshscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage ghscp
			ON hso.GreyCrownHairSystemColorPercentageID = ghscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage gbhscp
			ON hso.GreyBackHairSystemColorPercentageID = gbhscp.HairSystemColorPercentageID

		/*  Credit Decision */
		LEFT JOIN lkpChargeDecision cd
			ON hso.ChargeDecisionID = cd.ChargeDecisionID

		/*  HairSystem Location */
		LEFT JOIN cfgHairSystemLocation hsl
			ON hso.HairSystemLocationID = hsl.HairSystemLocationID

		/* Lace Length */
		LEFT JOIN lkpHairSystemFrontalLaceLength fll
			ON hso.HairSystemFrontalLaceLengthID = fll.HairSystemFrontalLaceLengthID
WHERE	hso.IsSignatureHairlineAddOn = 1
		AND hs.HairSystemDescriptionShort NOT IN ( 'HA', 'SW' )
		and hso.HairSystemOrderDate >= @startOrderDate and hso.HairSystemOrderDate<=@endOrderDate
ORDER BY v.VendorDescriptionShort
,		hso.HairSystemOrderNumber
END
GO
