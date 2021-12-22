/* CreateDate: 12/31/2010 13:21:06.903 , ModifyDate: 05/04/2020 15:30:46.260 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				rptHairSystemOrder

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		2/26/10

LAST REVISION DATE: 	02/05/2015

--------------------------------------------------------------------------------------------------------
NOTES: 	Return data to populate Factory Order report for either a single Hair System Order or all
		Hair Systems associated with a Purchase Order

		This stored proc was originally created in the Chinese Factory application and allowed for
		both an English & Chinese version, currently we only allow this report to be run in English

	* 3/16/2010 MLM - Added Center Use fields
	* 11/16/2010 MVT -	Modified to accept a HairSystemAllocationGUID as an
	*					optional parameter. Added Hair System Order Measurement
	*					detail if exists.
	* 11/18/2010 MLM - Added the abillity to return a 'blank record'. This is used to create blank reports
	* 12/10/2010 MLM - Added IsMeasurementFlag
	* 12/20/2010 MLM - Added a call to fnGetNotesForHairSystemOrder to get Factory Notes.
	* 12/27/2010 PRM - Changed center over to ClientHomeCenter
	* 01/20/2011 MLM - Changed the Format of the ClientFullNameAltCalc per spec
	* 01/20/2011 MLM - Changed HairSystemOrderStatusDescription to HairSystemOrderStatusDescriptionShort per spec
	* 01/20/2011 MLM - Added the column CenterTypeDescriptionShort to the results, Needed to print Corp or Fran on Report
	* 01/20/2011 MLM - Changed the Hair,Highlight, And Grey Material fields from DescriptionShort to Description
	* 01/20/2011 MLM - Convert HairSystemOrderDate & DueDate to UTC Date
	* 01/25/2011 MLM - Removed UTC Date Conversion
	* 02/03/2011 MLM - Added Salon Notes
	* 02/03/2011 MLM - Added IsRepairOrder Flag to the ResultSet
	* 02/03/2011 MLM - Added Credit Decision
	* 06/17/2011 MLM - Added HairSystem Location Information
	* 10/27/2011 HDu - Added IsBleachOrderFlag to report
	* 10/31/2011 HDu - Added FrontalLace to report
	* 12/15/2011 MVT - Modified to use 'fnGetNotesForHairSystemOrderFoxPro' to set factory notes so that
						Lace Length is returned in the notes.  When Factory App goes live, need to switch to
						use 'fnGetNotesForHairSystemOrder' since the lace length is returned as a separate
						piece of data and is no longer needed in the notes.
	* 03/12/2012 HDu - Change Client name format to clientnumber lastname comma firstname
	* 03/12/2012 HDu - Change Membership Description to full description
	* 06/12/2012 HDu - Added FHH
	* 02/05/2015 RH  - Added AllocationDate, VendorDescription, VendorAddress2 and CenterDescriptionNumber;
						Use 'fnGetNotesForHairSystemOrder' to set factory notes so that Lace Length is not returned.
	* 06/15/2016 RH	 - Added code to list salon notes in a comma separated list; show In-Salon notes only
	* 04/14/2017 RH  - Changed the parameter @ShowMEAOrdersOnly to pull for MANUAL orders only, the name change would break the application; added IsManualTemplateFlag; changed to ORDER BY CenterDescription
	* 03/27/2019 RH  - Added IsSignatureHairlineAddOn from datHairSystemOrder; commented out IsBleachOrderFlag
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC rptHairSystemOrder NULL, '2A7114E7-8FE6-49E0-843B-14B30CDAEADF', NULL, 0
EXEC rptHairSystemOrder '14AFCAB7-623E-42A4-8692-358E69C40643', NULL, NULL, 1
***********************************************************************/
CREATE PROCEDURE [dbo].[rptHairSystemOrder]
	@PurchaseOrderGUID as uniqueidentifier = NULL,
	@HairSystemOrderGUID as uniqueidentifier = NULL,
	@HairSystemAllocationGUID as uniqueidentifier = NULL,
	@ShowMEAOrdersOnly as bit
AS
BEGIN
SET NOCOUNT ON;

/************* Find NotesClient and join multiple notes together **********************************/
DECLARE @NotesClient NVARCHAR(MAX)

--Show In-Salon notes only
SELECT @NotesClient = COALESCE(@NotesClient + ', ', '') +  nc.NotesClient
FROM datNotesClient nc
LEFT JOIN lkpNoteType nt ON nc.NoteTypeID = nt.NoteTypeID
WHERE CAST(nc.HairSystemOrderGUID AS VARCHAR(50))= @HairSystemOrderGUID
AND nt.NoteTypeDescriptionShort NOT IN ('SI','FN')
AND nt.NoteTypeDescriptionShort IN ('IS')
GROUP BY nc.NotesClient

/**************** set NULLs **********************************************/

	IF ( @PurchaseOrderGUID IS NULL AND @HairSystemOrderGUID IS NULL AND @HairSystemAllocationGUID IS NULL )
	BEGIN
		SELECT  NULL AS PurchaseOrderNumber,
				NULL AS HairSystemOrderNumber,
				NULL AS HairSystemOrderGUID,
				NULL AS VendorDescriptionShort, --aka factory
				NULL AS VendorDescription,
				NULL AS VendorAddress2,
				NULL AS CenterID,
				NULL AS CenterDescription,
				NULL AS CenterDescriptionFullCalc,
				NULL AS CenterTypeDescriptionShort,
				NULL AS ClientFullName,
				NULL AS MembershipDescriptionShort,
				NULL AS HairSystemOrderDate,
				NULL AS DueDate,
				NULL AS IsRedoOrderFlag,
				CONVERT(BIT,0) AS IsRepairOrderFlag,
				CONVERT(BIT,0) AS HasSampleOrTemplate,
				CONVERT(BIT,0) as IsMeasurementFlag,
				CONVERT(BIT,0) as IsManualTemplateFlag,
				NULL AS HairSystemOrderStatusDescriptionShort,
				NULL AS HairSystemDescriptionShort,
				NULL AS HairSystemDescription,
				NULL AS HairSystemMatrixColorDescriptionShort,
				NULL AS HairSystemMatrixColorDescription,
				NULL AS HairSystemDesignTemplateDescriptionShort,
				NULL AS HairSystemDesignTemplateDescription,
				NULL AS TemplateAreaActualCalc,
				NULL AS TemplateWidth,
				NULL AS TemplateWidthAdjustment,
				NULL AS TemplateHeight,
				NULL AS TemplateHeightAdjustment,
				NULL AS HairSystemRecessionDescriptionShort,
				NULL AS HairSystemRecessionDescription,
				NULL AS HairSystemHairLengthDescriptionShort,
				NULL AS HairSystemHairLengthDescription,
				NULL AS HairSystemDensityDescriptionShort,
				NULL AS HairSystemDensityDescription,
				NULL AS HairSystemFrontalDensityDescriptionShort,
				NULL AS HairSystemFrontalDensityDescription,
				NULL AS HairSystemFrontalDesignDescriptionShort,
				NULL AS HairSystemFrontalDesignDescription,
				NULL AS HairSystemCurlDescriptionShort,
				NULL AS HairSystemCurlDescription,
				NULL AS HairSystemStyleDescriptionShort,
				NULL AS HairSystemStyleDescription,
				--color
				NULL AS  ColorHairSystemHairMaterialDescription,
				NULL AS ColorFrontHairSystemHairColorDescription,
				NULL AS ColorTempleHairSystemHairColorDescription,
				NULL AS ColorTopHairSystemHairColorDescription,
				NULL AS ColorSidesHairSystemHairColorDescription,
				NULL AS ColorCrownHairSystemHairColorDescription,
				NULL AS ColorBackHairSystemHairColorDescription,
				--highlight1
				NULL AS Highlight1HairSystemHairMaterialDescription,
				NULL AS Highlight1FrontHairSystemHairColorDescription,
				NULL AS Highlight1TempleHairSystemHairColorDescription,
				NULL AS Highlight1TopHairSystemHairColorDescription,
				NULL AS Highlight1SidesHairSystemHairColorDescription,
				NULL AS Highlight1CrownHairSystemHairColorDescription,
				NULL AS Highlight1BackHairSystemHairColorDescription,
				--highlight1 color percentage
				NULL AS Highlight1HairSystemHighlightDescription,
				NULL AS Highlight1FrontHairSystemColorPercentageDescription,
				NULL AS Highlight1TempleHairSystemColorPercentageDescription,
				NULL AS  Highlight1TopHairSystemColorPercentageDescription,
				NULL AS Highlight1SidesHairSystemColorPercentageDescription,
				NULL AS Highlight1CrownHairSystemColorPercentageDescription,
				NULL AS Highlight1BackHairSystemColorPercentageDescription,
				--highlight2
				NULL AS  Highlight2HairSystemHairMaterialDescription,
				NULL AS Highlight2FrontHairSystemHairColorDescription,
				NULL AS Highlight2TempleHairSystemHairColorDescription,
				NULL AS Highlight2TopHairSystemHairColorDescription,
				NULL AS Highlight2SidesHairSystemHairColorDescription,
				NULL AS Highlight2CrownHairSystemHairColorDescription,
				NULL AS Highlight2BackHairSystemHairColorDescription,
				--highlight2 color percentage
				NULL AS Highlight2HairSystemHighlightDescription,
				NULL AS Highlight2FrontHairSystemColorPercentageDescription,
				NULL AS Highlight2TempleHairSystemColorPercentageDescription,
				NULL AS Highlight2TopHairSystemColorPercentageDescription,
				NULL AS Highlight2SidesHairSystemColorPercentageDescription,
				NULL AS Highlight2CrownHairSystemColorPercentageDescription,
				NULL AS Highlight2BackHairSystemColorPercentageDescription,
				--grey
				NULL AS GreyHairSystemHairMaterialDescription,
				NULL AS GreyFrontHairSystemColorPercentageDescription,
				NULL AS GreyTempleHairSystemColorPercentageDescription,
				NULL AS GreyTopHairSystemColorPercentageDescription,
				NULL AS GreySidesHairSystemColorPercentageDescription,
				NULL AS GreyCrownHairSystemColorPercentageDescription,
				NULL AS GreyBackHairSystemColorPercentageDescription,

				--MEA
				NULL AS HairSystemOrderMeasurementGUID,
				NULL AS StartingPointMeasurement,
				NULL AS CircumferenceMeasurement,
				NULL AS FrontToBackMeasurement,
				NULL AS EarToEarOverFrontMeasurement,
				NULL AS EarToEarOverTopMeasurement,
				NULL AS SideburnToSideburnMeasurement,
				NULL AS TempleToTempleMeasurement,
				NULL AS NapeAreaMeasurement,
				NULL AS MEAHairSystemRecessionDescription,
				NULL AS AreSideburnsAndTemplesLaceFlag,
				NULL AS FrontLaceMeasurement,
				0 AS SideburnTemplateDiagram,
				NULL AS MeasurementsBy,

				NULL AS FactoryNote,
				NULL AS CenterUseFromBridgeDistance,
				NULL AS CenterUseIsPermFlag,
				NULL as SalonNote,
				NULL AS CreditDecisionDescription,
				NULL AS CreditDecisionDescriptionShort,

				NULL AS CabinetNumber,
				NULL AS BinNumber,
				NULL AS DrawerNumber,
				CONVERT(BIT,0) AS IsBleachOrderFlag,
				NULL AS HairSystemFrontalLaceLengthDescription,
				NULL AS HairSystemFrontalLaceLengthDescriptionShort,
				NULL AS IsFashionHairlineHighlightsFlag,
				NULL AS AllocationDate,
				NULL AS IsSignatureHairlineAddOn,
				NULL AS RootShadowingRootColorDescription,
				NULL AS RootShadowingRootColorLengthDescription
	END
	ELSE
	BEGIN
		SELECT  po.PurchaseOrderNumber, hso.HairSystemOrderNumber,
				hso.HairSystemOrderGUID,
				v.VendorDescriptionShort, --aka factory
				VendorDescription,
				VendorAddress2,
				hso.ClientHomeCenterID AS CenterID,
				ctr.CenterDescription,
				ctr.CenterDescriptionFullCalc,
				ct.CenterTypeDescriptionShort,
				COALESCE(CONVERT(nvarchar,c.ClientIdentifier) + '  ','  ') + c.ClientFullNameAlt2Calc AS ClientFullName,
				m.MembershipDescription AS 'MembershipDescriptionShort', --m.MembershipDescriptionShort,
				--DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, hso.HairSystemOrderDate) <= 10
				--	OR DATEPART(WK, hso.HairSystemOrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, hso.HairSystemOrderDate) AS HairSystemOrderDate,
				--DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, hso.DueDate) <= 10
				--	OR DATEPART(WK, hso.DueDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, hso.DueDate) AS DueDate,
				hso.HairSystemOrderDate,
				hso.DueDate,
				hso.IsRedoOrderFlag,
				hso.IsRepairOrderFlag,
				CASE WHEN ISNULL(hsdt.IsManualTemplateFlag,0) = 1 OR ISNULL(hsdt.IsMeasurementFlag,0) = 1  THEN 1 ELSE 0 END AS HasSampleOrTemplate,
				hsdt.IsMeasurementFlag,
				hsdt.IsManualTemplateFlag,
				hsos.HairSystemOrderStatusDescriptionShort,
				hs.HairSystemDescriptionShort, hs.HairSystemDescription,
				hsmc.HairSystemMatrixColorDescriptionShort, hsmc.HairSystemMatrixColorDescription,
				hsdt.HairSystemDesignTemplateDescriptionShort, hsdt.HairSystemDesignTemplateDescription,
				hso.TemplateAreaActualCalc, hso.TemplateWidth, hso.TemplateWidthAdjustment, hso.TemplateHeight,  hso.TemplateHeightAdjustment,
				hsr.HairSystemRecessionDescriptionShort, hsr.HairSystemRecessionDescription,
				hshl.HairSystemHairLengthDescriptionShort, hshl.HairSystemHairLengthDescription,
				hsd.HairSystemDensityDescriptionShort, hsd.HairSystemDensityDescription,
				hsfdn.HairSystemFrontalDensityDescriptionShort, hsfdn.HairSystemFrontalDensityDescription,
				hsfds.HairSystemFrontalDesignDescriptionShort, hsfds.HairSystemFrontalDesignDescription,
				hsc.HairSystemCurlDescriptionShort, hsc.HairSystemCurlDescription,
				hss.HairSystemStyleDescriptionShort, hss.HairSystemStyleDescription,
				--color
				chshm.HairSystemHairMaterialDescription AS ColorHairSystemHairMaterialDescription,
				cfhshhc.HairSystemHairColorDescription AS ColorFrontHairSystemHairColorDescription,
				cthshhc.HairSystemHairColorDescription AS ColorTempleHairSystemHairColorDescription,
				ctphshhc.HairSystemHairColorDescription AS ColorTopHairSystemHairColorDescription,
				cshshhc.HairSystemHairColorDescription AS ColorSidesHairSystemHairColorDescription,
				cchshhc.HairSystemHairColorDescription AS ColorCrownHairSystemHairColorDescription,
				cbhshhc.HairSystemHairColorDescription AS ColorBackHairSystemHairColorDescription,
				--highlight1
				h1hshm.HairSystemHairMaterialDescription AS Highlight1HairSystemHairMaterialDescription,
				h1fhshhc.HairSystemHairColorDescription AS Highlight1FrontHairSystemHairColorDescription,
				h1thshhc.HairSystemHairColorDescription AS Highlight1TempleHairSystemHairColorDescription,
				h1tphshhc.HairSystemHairColorDescription AS Highlight1TopHairSystemHairColorDescription,
				h1shshhc.HairSystemHairColorDescription AS Highlight1SidesHairSystemHairColorDescription,
				h1hshhc.HairSystemHairColorDescription AS Highlight1CrownHairSystemHairColorDescription,
				h1bhshhc.HairSystemHairColorDescription AS Highlight1BackHairSystemHairColorDescription,
				--highlight1 color percentage
				h1hsh.HairSystemHighlightDescription AS Highlight1HairSystemHighlightDescription,
				h1fhscp.HairSystemColorPercentageDescription AS Highlight1FrontHairSystemColorPercentageDescription,
				h1thscp.HairSystemColorPercentageDescription AS Highlight1TempleHairSystemColorPercentageDescription,
				h1tphscp.HairSystemColorPercentageDescription AS Highlight1TopHairSystemColorPercentageDescription,
				h1shscp.HairSystemColorPercentageDescription AS Highlight1SidesHairSystemColorPercentageDescription,
				h1hscp.HairSystemColorPercentageDescription AS Highlight1CrownHairSystemColorPercentageDescription,
				h1bhscp.HairSystemColorPercentageDescription AS Highlight1BackHairSystemColorPercentageDescription,
				--highlight2
				h2hshm.HairSystemHairMaterialDescription AS Highlight2HairSystemHairMaterialDescription,
				h2fhshhc.HairSystemHairColorDescription AS Highlight2FrontHairSystemHairColorDescription,
				h2thshhc.HairSystemHairColorDescription AS Highlight2TempleHairSystemHairColorDescription,
				h2tphshhc.HairSystemHairColorDescription AS Highlight2TopHairSystemHairColorDescription,
				h2shshhc.HairSystemHairColorDescription AS Highlight2SidesHairSystemHairColorDescription,
				h2hshhc.HairSystemHairColorDescription AS Highlight2CrownHairSystemHairColorDescription,
				h2bhshhc.HairSystemHairColorDescription AS Highlight2BackHairSystemHairColorDescription,
				--highlight2 color percentage
				h2hsh.HairSystemHighlightDescription AS Highlight2HairSystemHighlightDescription,
				h2fhscp.HairSystemColorPercentageDescription AS Highlight2FrontHairSystemColorPercentageDescription,
				h2thscp.HairSystemColorPercentageDescription AS Highlight2TempleHairSystemColorPercentageDescription,
				h2tphscp.HairSystemColorPercentageDescription AS Highlight2TopHairSystemColorPercentageDescription,
				h2shscp.HairSystemColorPercentageDescription AS Highlight2SidesHairSystemColorPercentageDescription,
				h2hscp.HairSystemColorPercentageDescription AS Highlight2CrownHairSystemColorPercentageDescription,
				h2bhscp.HairSystemColorPercentageDescription AS Highlight2BackHairSystemColorPercentageDescription,
				--grey
				ghshm.HairSystemHairMaterialDescription AS GreyHairSystemHairMaterialDescription,
				gfhscp.HairSystemColorPercentageDescription AS GreyFrontHairSystemColorPercentageDescription,
				gthscp.HairSystemColorPercentageDescription AS GreyTempleHairSystemColorPercentageDescription,
				gtphscp.HairSystemColorPercentageDescription AS GreyTopHairSystemColorPercentageDescription,
				gshscp.HairSystemColorPercentageDescription AS GreySidesHairSystemColorPercentageDescription,
				ghscp.HairSystemColorPercentageDescription AS GreyCrownHairSystemColorPercentageDescription,
				gbhscp.HairSystemColorPercentageDescription AS GreyBackHairSystemColorPercentageDescription,

				--MEA
				hsom.HairSystemOrderMeasurementGUID,
				hsom.StartingPointMeasurement,
				hsom.CircumferenceMeasurement,
				hsom.FrontToBackMeasurement,
				hsom.EarToEarOverFrontMeasurement,
				hsom.EarToEarOverTopMeasurement,
				hsom.SideburnToSideburnMeasurement,
				hsom.TempleToTempleMeasurement,
				hsom.NapeAreaMeasurement,
				hsr2.HairSystemRecessionDescriptionShort AS MEAHairSystemRecessionDescription,
				hsom.AreSideburnsAndTemplesLaceFlag,
				hsom.FrontLaceMeasurement,
				ISNULL(hsom.SideburnTemplateDiagram,0) AS SideburnTemplateDiagram,
				emp.EmployeeInitials AS MeasurementsBy,

				[dbo].[fnGetNotesForHairSystemOrder] (hso.HairSystemOrderGUID) as FactoryNote,
				hso.CenterUseFromBridgeDistance,
				hso.CenterUseIsPermFlag,

				@NotesClient as SalonNote,

				cd.ChargeDecisionDescription As CreditDecisionDescription,
				cd.ChargeDecisionDescriptionShort As CreditDecisionDescriptionShort,

				--HairSystem Location Information
				hsl.CabinetNumber,
				hsl.BinNumber,
				hsl.DrawerNumber,
				--hso.IsBleachOrderFlag,
				-- lace length
			fll.HairSystemFrontalLaceLengthDescription,
			fll.HairSystemFrontalLaceLengthDescriptionShort,
			hso.IsFashionHairlineHighlightsFlag,
			hso.AllocationDate,
			hso.IsSignatureHairlineAddOn,
			rootc.HairSystemHairColorDescription AS RootShadowingRootColorDescription,
			rsrcl.RootShadowingRootColorLengthDescription

		FROM datHairSystemOrder hso
			LEFT JOIN datPurchaseOrderDetail pod ON hso.HairSystemOrderGUID = pod.HairSystemOrderGUID
			LEFT JOIN datPurchaseOrder po ON pod.PurchaseOrderGUID = po.PurchaseOrderGUID
			LEFT JOIN cfgVendor v ON po.VendorID = v.VendorID
			LEFT JOIN cfgCenter ctr ON hso.ClientHomeCenterID = ctr.CenterID
			LEFT JOIN lkpCenterType ct ON ctr.CenterTypeID = ct.CenterTypeID
			LEFT JOIN datClient c ON hso.ClientGUID = c.ClientGUID
			LEFT JOIN datClientMembership cm ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
			LEFT JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
			LEFT JOIN lkpHairSystemOrderStatus hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
			LEFT JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
			LEFT JOIN lkpHairSystemMatrixColor hsmc ON hso.HairSystemMatrixColorID = hsmc.HairSystemMatrixColorID
			LEFT JOIN lkpHairSystemDesignTemplate hsdt ON hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID
			LEFT JOIN lkpHairSystemRecession hsr ON hso.HairSystemRecessionID = hsr.HairSystemRecessionID
			LEFT JOIN lkpHairSystemHairLength hshl ON hso.HairSystemHairLengthID = hshl.HairSystemHairLengthID
			LEFT JOIN lkpHairSystemDensity hsd ON hso.HairSystemDensityID = hsd.HairSystemDensityID
			LEFT JOIN lkpHairSystemFrontalDensity hsfdn ON hso.HairSystemFrontalDensityID = hsfdn.HairSystemFrontalDensityID
			LEFT JOIN lkpHairSystemFrontalDesign hsfds ON hso.HairSystemFrontalDesignID = hsfds.HairSystemFrontalDesignID
			LEFT JOIN lkpHairSystemCurl hsc ON hso.HairSystemCurlID = hsc.HairSystemCurlID
			LEFT JOIN lkpHairSystemStyle hss ON hso.HairSystemStyleID = hss.HairSystemStyleID
			LEFT JOIN datHairSystemOrderMeasurement hsom ON hso.HairSystemOrderGUID = hsom.HairSystemOrderGUID
			LEFT JOIN lkpHairSystemRecession hsr2 on hsom.HairSystemRecessionID = hsr2.HairSystemRecessionID
			LEFT JOIN datEmployee emp on hso.MeasurementEmployeeGUID = emp.EmployeeGUID

			--color
			LEFT JOIN lkpHairSystemHairMaterial chshm ON hso.ColorHairSystemHairMaterialID = chshm.HairSystemHairMaterialID
			LEFT JOIN lkpHairSystemHairColor cfhshhc ON hso.ColorFrontHairSystemHairColorID = cfhshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor cthshhc ON hso.ColorTempleHairSystemHairColorID = cthshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor ctphshhc ON hso.ColorTopHairSystemHairColorID = ctphshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor cshshhc ON hso.ColorSidesHairSystemHairColorID = cshshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor cchshhc ON hso.ColorCrownHairSystemHairColorID = cchshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor cbhshhc ON hso.ColorBackHairSystemHairColorID = cbhshhc.HairSystemHairColorID
			--highlight1
			LEFT JOIN lkpHairSystemHairMaterial h1hshm ON hso.Highlight1HairSystemHairMaterialID = h1hshm.HairSystemHairMaterialID
			LEFT JOIN lkpHairSystemHairColor h1fhshhc ON hso.Highlight1FrontHairSystemHairColorID = h1fhshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor h1thshhc ON hso.Highlight1TempleHairSystemHairColorID = h1thshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor h1tphshhc ON hso.Highlight1TopHairSystemHairColorID = h1tphshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor h1shshhc ON hso.Highlight1SidesHairSystemHairColorID = h1shshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor h1hshhc ON hso.Highlight1CrownHairSystemHairColorID = h1hshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor h1bhshhc ON hso.Highlight1BackHairSystemHairColorID = h1bhshhc.HairSystemHairColorID
			--highlight1 color percentage
			LEFT JOIN lkpHairSystemHighlight h1hsh ON hso.Highlight1HairSystemHighlightID = h1hsh.HairSystemHighlightID
			LEFT JOIN lkpHairSystemColorPercentage h1fhscp ON hso.Highlight1FrontHairSystemColorPercentageID = h1fhscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage h1thscp ON hso.Highlight1TempleHairSystemColorPercentageID = h1thscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage h1tphscp ON hso.Highlight1TopHairSystemColorPercentageID = h1tphscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage h1shscp ON hso.Highlight1SidesHairSystemColorPercentageID = h1shscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage h1hscp ON hso.Highlight1CrownHairSystemColorPercentageID = h1hscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage h1bhscp ON hso.Highlight1BackHairSystemColorPercentageID = h1bhscp.HairSystemColorPercentageID
			--highlight2
			LEFT JOIN lkpHairSystemHairMaterial h2hshm ON hso.Highlight2HairSystemHairMaterialID = h2hshm.HairSystemHairMaterialID
			LEFT JOIN lkpHairSystemHairColor h2fhshhc ON hso.Highlight2FrontHairSystemHairColorID = h2fhshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor h2thshhc ON hso.Highlight2TempleHairSystemHairColorID = h2thshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor h2tphshhc ON hso.Highlight2TopHairSystemHairColorID = h2tphshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor h2shshhc ON hso.Highlight2SidesHairSystemHairColorID = h2shshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor h2hshhc ON hso.Highlight2CrownHairSystemHairColorID = h2hshhc.HairSystemHairColorID
			LEFT JOIN lkpHairSystemHairColor h2bhshhc ON hso.Highlight2BackHairSystemHairColorID = h2bhshhc.HairSystemHairColorID
			--highlight2 color percentage
			LEFT JOIN lkpHairSystemHighlight h2hsh ON hso.Highlight2HairSystemHighlightID = h2hsh.HairSystemHighlightID
			LEFT JOIN lkpHairSystemColorPercentage h2fhscp ON hso.Highlight2FrontHairSystemColorPercentageID = h2fhscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage h2thscp ON hso.Highlight2TempleHairSystemColorPercentageID = h2thscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage h2tphscp ON hso.Highlight2TopHairSystemColorPercentageID = h2tphscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage h2shscp ON hso.Highlight2SidesHairSystemColorPercentageID = h2shscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage h2hscp ON hso.Highlight2CrownHairSystemColorPercentageID = h2hscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage h2bhscp ON hso.Highlight2BackHairSystemColorPercentageID = h2bhscp.HairSystemColorPercentageID
			--grey
			LEFT JOIN lkpHairSystemHairMaterial ghshm ON hso.GreyHairSystemHairMaterialID = ghshm.HairSystemHairMaterialID
			LEFT JOIN lkpHairSystemColorPercentage gfhscp ON hso.GreyFrontHairSystemColorPercentageID = gfhscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage gthscp ON hso.GreyTempleHairSystemColorPercentageID = gthscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage gtphscp ON hso.GreyTopHairSystemColorPercentageID = gtphscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage gshscp ON hso.GreySidesHairSystemColorPercentageID = gshscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage ghscp ON hso.GreyCrownHairSystemColorPercentageID = ghscp.HairSystemColorPercentageID
			LEFT JOIN lkpHairSystemColorPercentage gbhscp ON hso.GreyBackHairSystemColorPercentageID = gbhscp.HairSystemColorPercentageID

			-- Salon Note
			LEFT JOIN lkpNoteType nt ON nt.NoteTypeDescriptionShort <>'FN'
			LEFT JOIN datNotesClient nc ON nc.NoteTypeID = nt.NoteTypeID AND hso.HairSystemOrderGUID = nc.HairSystemOrderGUID

			-- Credit Decision
			LEFT JOIN lkpChargeDecision cd on hso.ChargeDecisionID = cd.ChargeDecisionID

			-- HairSystem Location
			LEFT JOIN cfgHairSystemLocation hsl on hso.HairSystemLocationID = hsl.HairSystemLocationID

			--TimeZone Conversion to UTC
			--INNER JOIN cfgCenter ctrTimeZone ON ctrTimeZone.IsCorporateHeadquartersFlag = 1
   --         INNER JOIN lkpTimeZone tz ON ctrTimeZone.TimeZoneID = tz.TimeZoneID
   			--Lace Length
			LEFT JOIN lkpHairSystemFrontalLaceLength fll ON hso.HairSystemFrontalLaceLengthID = fll.HairSystemFrontalLaceLengthID
			LEFT JOIN lkpRootShadowingRootColorLength rsrcl ON rsrcl.RootShadowingRootColorLengthID = hso.RootShadowingRootColorLengthID
			LEFT JOIN lkpHairSystemHairColor rootc ON rootc.HairSystemHairColorID = hso.RootShadowingRootColorID

		WHERE (@PurchaseOrderGUID IS NULL OR po.PurchaseOrderGUID = @PurchaseOrderGUID) AND
			 (@HairSystemOrderGUID IS NULL OR hso.HairSystemOrderGUID = @HairSystemOrderGUID) AND
			 (@HairSystemAllocationGUID IS NULL OR po.HairSystemAllocationGUID = @HairSystemAllocationGUID) AND
			 --(@ShowMEAOrdersOnly = 0 OR (@ShowMEAOrdersOnly =1 AND hsdt.IsMeasurementFlag = 1))
			 (@ShowMEAOrdersOnly = 0 OR (@ShowMEAOrdersOnly = 1 AND hsdt.IsManualTemplateFlag = 1))
		GROUP BY po.PurchaseOrderNumber, hso.HairSystemOrderNumber,
				hso.HairSystemOrderGUID,
				v.VendorDescriptionShort,
				VendorDescription,
				VendorAddress2,
				hso.ClientHomeCenterID,
				ctr.CenterDescription,
				ctr.CenterDescriptionFullCalc,
				ct.CenterTypeDescriptionShort,
				COALESCE(CONVERT(nvarchar,c.ClientIdentifier) + '  ','  ') + c.ClientFullNameAlt2Calc,
				m.MembershipDescription,
				--DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, hso.HairSystemOrderDate) <= 10
				--	OR DATEPART(WK, hso.HairSystemOrderDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, hso.HairSystemOrderDate) AS HairSystemOrderDate,
				--DATEADD(Hour, CASE WHEN tz.UsesDayLightSavingsFlag = 0 THEN (tz.UTCOffset) WHEN DATEPART(WK, hso.DueDate) <= 10
				--	OR DATEPART(WK, hso.DueDate) >= 45 THEN (tz.UTCOffset) ELSE ((tz.UTCOffset) + 1) END, hso.DueDate) AS DueDate,
				hso.HairSystemOrderDate,
				hso.DueDate,
				hso.IsRedoOrderFlag,
				hso.IsRepairOrderFlag,
				CASE WHEN ISNULL(hsdt.IsManualTemplateFlag,0) = 1 OR ISNULL(hsdt.IsMeasurementFlag,0) = 1  THEN 1 ELSE 0 END,
				hsdt.IsMeasurementFlag,
				hsdt.IsManualTemplateFlag,
				hsos.HairSystemOrderStatusDescriptionShort,
				hs.HairSystemDescriptionShort, hs.HairSystemDescription,
				hsmc.HairSystemMatrixColorDescriptionShort, hsmc.HairSystemMatrixColorDescription,
				hsdt.HairSystemDesignTemplateDescriptionShort, hsdt.HairSystemDesignTemplateDescription,
				hso.TemplateAreaActualCalc, hso.TemplateWidth, hso.TemplateWidthAdjustment, hso.TemplateHeight,  hso.TemplateHeightAdjustment,
				hsr.HairSystemRecessionDescriptionShort, hsr.HairSystemRecessionDescription,
				hshl.HairSystemHairLengthDescriptionShort, hshl.HairSystemHairLengthDescription,
				hsd.HairSystemDensityDescriptionShort, hsd.HairSystemDensityDescription,
				hsfdn.HairSystemFrontalDensityDescriptionShort, hsfdn.HairSystemFrontalDensityDescription,
				hsfds.HairSystemFrontalDesignDescriptionShort, hsfds.HairSystemFrontalDesignDescription,
				hsc.HairSystemCurlDescriptionShort, hsc.HairSystemCurlDescription,
				hss.HairSystemStyleDescriptionShort, hss.HairSystemStyleDescription,
				--color
				chshm.HairSystemHairMaterialDescription,
				cfhshhc.HairSystemHairColorDescription,
				cthshhc.HairSystemHairColorDescription,
				ctphshhc.HairSystemHairColorDescription,
				cshshhc.HairSystemHairColorDescription,
				cchshhc.HairSystemHairColorDescription,
				cbhshhc.HairSystemHairColorDescription,
				--highlight1
				h1hshm.HairSystemHairMaterialDescription,
				h1fhshhc.HairSystemHairColorDescription,
				h1thshhc.HairSystemHairColorDescription,
				h1tphshhc.HairSystemHairColorDescription,
				h1shshhc.HairSystemHairColorDescription,
				h1hshhc.HairSystemHairColorDescription,
				h1bhshhc.HairSystemHairColorDescription,
				--highlight1 color percentage
				h1hsh.HairSystemHighlightDescription,
				h1fhscp.HairSystemColorPercentageDescription,
				h1thscp.HairSystemColorPercentageDescription,
				h1tphscp.HairSystemColorPercentageDescription,
				h1shscp.HairSystemColorPercentageDescription,
				h1hscp.HairSystemColorPercentageDescription,
				h1bhscp.HairSystemColorPercentageDescription,
				--highlight2
				h2hshm.HairSystemHairMaterialDescription,
				h2fhshhc.HairSystemHairColorDescription,
				h2thshhc.HairSystemHairColorDescription,
				h2tphshhc.HairSystemHairColorDescription,
				h2shshhc.HairSystemHairColorDescription,
				h2hshhc.HairSystemHairColorDescription,
				h2bhshhc.HairSystemHairColorDescription,
				--highlight2 color percentage
				h2hsh.HairSystemHighlightDescription,
				h2fhscp.HairSystemColorPercentageDescription,
				h2thscp.HairSystemColorPercentageDescription,
				h2tphscp.HairSystemColorPercentageDescription,
				h2shscp.HairSystemColorPercentageDescription,
				h2hscp.HairSystemColorPercentageDescription,
				h2bhscp.HairSystemColorPercentageDescription,
				--grey
				ghshm.HairSystemHairMaterialDescription,
				gfhscp.HairSystemColorPercentageDescription,
				gthscp.HairSystemColorPercentageDescription,
				gtphscp.HairSystemColorPercentageDescription,
				gshscp.HairSystemColorPercentageDescription,
				ghscp.HairSystemColorPercentageDescription,
				gbhscp.HairSystemColorPercentageDescription,

				--MEA
				hsom.HairSystemOrderMeasurementGUID,
				hsom.StartingPointMeasurement,
				hsom.CircumferenceMeasurement,
				hsom.FrontToBackMeasurement,
				hsom.EarToEarOverFrontMeasurement,
				hsom.EarToEarOverTopMeasurement,
				hsom.SideburnToSideburnMeasurement,
				hsom.TempleToTempleMeasurement,
				hsom.NapeAreaMeasurement,
				hsr2.HairSystemRecessionDescriptionShort,
				hsom.AreSideburnsAndTemplesLaceFlag,
				hsom.FrontLaceMeasurement,
				ISNULL(hsom.SideburnTemplateDiagram,0),
				emp.EmployeeInitials,

				[dbo].[fnGetNotesForHairSystemOrder] (hso.HairSystemOrderGUID),
				hso.CenterUseFromBridgeDistance,
				hso.CenterUseIsPermFlag,

				cd.ChargeDecisionDescription,
				cd.ChargeDecisionDescriptionShort,

				--HairSystem Location Information
				hsl.CabinetNumber,
				hsl.BinNumber,
				hsl.DrawerNumber,
				--hso.IsBleachOrderFlag,
				-- lace length
			fll.HairSystemFrontalLaceLengthDescription,
			fll.HairSystemFrontalLaceLengthDescriptionShort,
			hso.IsFashionHairlineHighlightsFlag,
			hso.AllocationDate,
			hso.IsSignatureHairlineAddOn,
			rootc.HairSystemHairColorDescription,
			rsrcl.RootShadowingRootColorLengthDescription
		--ORDER BY v.VendorDescriptionShort, po.PurchaseOrderNumber, hso.HairSystemOrderNumber DESC
		ORDER BY ctr.CenterDescription
	END
END
GO
