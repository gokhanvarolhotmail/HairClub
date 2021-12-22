/***********************************************************************

PROCEDURE:				selAllocationExportForPO

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 10/27/2010

LAST REVISION DATE: 	 05/24/2011

--------------------------------------------------------------------------------------------------------
NOTES:  This script is used during the allocation process (SSIS package) to retrieve Factory Orders to create Files sent to Factories
		* 10/27/2010 MVT - Created stored proc
		* 12/29/2010 MVT - Modified to use Client Home Center
		* 03/24/2011 MVT - Fix issue with Allocation SSIS package. The 'notes' were not in the correct format.
							Modifed notes to be returned as VarChar(500)
		* 03/25/2011 MVT - Fix the notes content that is returned in 'notes' and 'factnotes' columns.
		* 05/24/2011 MVT - Modified to blank out Matrix Color, Template, Template Width/Height, Template
							Width/Height Adj., and Recession if PO Type is 'Hair Add'.  The System Type
							is replaced with Charge Decision if 'Hair Add'.
		* 06/24/2011 MVT - Modified to concatenate in-salon notes
		* 10/26/2011 MVT - Modified to use a fnGetNotesForHairSystemOrderFoxPro function that includes Lace Length.
		* 02/24/2012 MVT - Changed CostCenterWholesale to CenterPrice

--------------------------------------------------------------------------------------------------------

******************* VERY IMPORTANT *********************************
After the export, when viewing a fox pro file in a spreadsheet. The 'factnotes'
column comes up blank because it is a 'TEXT' data type.



SAMPLE EXECUTION:

EXEC selAllocationExportForPO '5B38E24A-A3E8-42D0-99D7-0AD23A8EC887'

***********************************************************************/

CREATE PROCEDURE [dbo].[selAllocationExportForPO] (
	@PurchaseOrderGUID nvarchar(100)
) AS
BEGIN
	--Note: GUID parameter is intentially passed in as an nvarchar because uniqueidentifiers cause an issue in SSIS (MVT isn't an as dumb as you think)
	SET NOCOUNT ON

	-- CONSTANTS
	DECLARE @HairAddPurchaseOrderType VarChar(3)
	SET @HairAddPurchaseOrderType = 'HKW'


	DECLARE @notes VarChar(MAX),@inSalonNoteTypeId int, @POType VarChar(10)
	SET @notes = ''
	SET @POType = (SELECT pt.PurchaseOrderTypeDescriptionShort FROM datPurchaseOrder p
							INNER JOIN lkpPurchaseOrderType pt
							ON p.PurchaseOrderTypeID = pt.PurchaseOrderTypeID
						WHERE p.PurchaseOrderGUID = @PurchaseOrderGUID)

	SET @inSalonNoteTypeId = (SELECT nt.NoteTypeID FROM lkpNoteType nt WHERE nt.NoteTypeDescriptionShort = 'IS')

	SELECT hso.ClientHomeCenterID as center
	,	CONVERT(varchar(50), c.CenterDescription) AS pcenternam
	,	CONVERT(varchar(100), ctry.CountryDescription) AS pcountry
	,	CONVERT(varchar(100),ct.CenterTypeDescription) AS pctype
	,	cl.ClientIdentifier as client_no
	,	CONVERT(varchar(50),hso.HairSystemOrderNumber) as serialnumb
	,   'A' as cd  --This is a Check Digit - used for scanning and ensuring uniqueness - use 'A'
	,	CONVERT(varchar(100),stat.HairSystemOrderStatusDescription) as Orderstcod
	,	hso.LastUpdate	as statusdate
	,	CONVERT(varchar(10),mem.MembershipDescriptionShort) as programcod   -- short description in cfgMembership
	,	CASE WHEN rg.RevenueGroupDescriptionShort = 'NB' OR rg.RevenueGroupDescriptionShort = 'NP' THEN 1 ELSE 0 END as progbig
	,	hso.DueDate as duedate
	,	CASE WHEN hso.IsRedoOrderFlag IS NULL OR hso.IsRedoOrderFlag = 0
				THEN 'N' ELSE 'Y' END AS redo
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, then display the charge decision
			THEN CONVERT(varchar(10),chrg.ChargeDecisionDescriptionShort)
			ELSE CONVERT(varchar(10),hs.HairSystemDescriptionShort) END AS systypecod
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, then display the charge decision
			THEN CONVERT(varchar(10),chrg.ChargeDecisionDescription)
			ELSE CONVERT(varchar(100),hs.HairSystemDescription) END AS systypedes
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, Matrix Color is blanked out
			THEN '' ELSE CONVERT(varchar(10),hsmc.HairSystemMatrixColorDescriptionShort) END AS scolorcode
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, Matrix Color is blanked out
			THEN '' ELSE CONVERT(varchar(100),hsmc.HairSystemMatrixColorDescription) END AS scolordesc
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, Template is blanked out
			THEN '' ELSE CONVERT(varchar(10),dt.HairSystemDesignTemplateDescriptionShort) END AS templcode
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, Template is blanked out
			THEN '' ELSE CONVERT(varchar(100),dt.HairSystemDesignTemplateDescription) END AS templdesc
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, Template width is blanked out
			THEN NULL ELSE hso.TemplateWidth END AS templwidth
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, Template width Adj. is blanked out
			THEN NULL ELSE hso.TemplateWidthAdjustment END AS adjwidth
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, Template height is blanked out
			THEN NULL ELSE hso.TemplateHeight END AS templength
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, Template height Adj. is blanked out
			THEN NULL ELSE hso.TemplateHeightAdjustment END AS adjlength
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, Recession is blanked out
			THEN '' ELSE CONVERT(varchar(10),hsr.HairSystemRecessionDescriptionShort) END AS recesscode -- HairSystemRecessionShortDesc
	,	CASE WHEN @POType = @HairAddPurchaseOrderType  -- if Hair Add, Recession is blanked out
			THEN '' ELSE CONVERT(varchar(100),hsr.HairSystemRecessionDescription) END AS recessdesc --HairSystemRecessionDesc
	,	CONVERT(varchar(10),hshl.HairSystemHairLengthDescriptionShort) as hairlcode --HairSystemHairLengthShortDesc
	,	CONVERT(varchar(100),hshl.HairSystemHairLengthDescription) as hairldesc --HairSystemHairLengthDesc
	,	CONVERT(varchar(10),hsd.HairSystemDensityDescriptionShort) as densecode -- HairSystemDensityShortDesc
	,	CONVERT(varchar(100),hsd.HairSystemDensityDescription) as densedesc --HairSystemDensityDesc
	,	CONVERT(varchar(10),hsfd.HairSystemFrontalDensityDescriptionShort) as frontdense -- HairSystemFrontalDensityShortDesc
	,	CONVERT(varchar(100),hsfd.HairSystemFrontalDensityDescription) as fdensedesc  --HairSystemFrontalDensityDesc
	,	CONVERT(varchar(10),hsfdsn.HairSystemFrontalDesignDescriptionShort) as frontcode  --HairSystemFrontalDesignShortDesc
	,	CONVERT(varchar(100),hsfdsn.HairSystemFrontalDesignDescription) as frontdesc   --HairSystemFrontalDesignDesc
	,	'N' as undervent   --- What should be the default?
	,	CONVERT(varchar(10),chm.HairSystemHairMaterialDescriptionShort) as hairhuman -- ColorHairSystemHairMaterial
	,	CONVERT(varchar(10),cfhc.HairSystemHairColorDescriptionShort) as haircfront --ColorFrontHairSystemHairColor
	,	CONVERT(varchar(10),cthc.HairSystemHairColorDescriptionShort) as hairctempl --ColorTempleHairSystemHairColor
	,	CONVERT(varchar(10),ctophc.HairSystemHairColorDescriptionShort) as hairctop  --ColorTopHairSystemHairColor
	,	CONVERT(varchar(10),cshc.HairSystemHairColorDescriptionShort) as  haircsides --ColorSidesHairSystemHairColor
	,	CONVERT(varchar(10),cchc.HairSystemHairColorDescriptionShort) as hairccrown  --ColorCrownHairSystemHairColor
	,	CONVERT(varchar(10),cbhc.HairSystemHairColorDescriptionShort) as haircback  --ColorBackHairSystemHairColor
	,	CONVERT(varchar(10),h1hm.HairSystemHairMaterialDescriptionShort) as highhuman --Highlight1HairSystemHairMaterial
	,	CONVERT(varchar(10),h1h.HairSystemHighlightDescriptionShort) as highstreak  --Highlight1HairSystemHighlight
	,	CONVERT(varchar(10),h1fhc.HairSystemHairColorDescriptionShort) as highcfront  --Highlight1FrontHairSystemHairColor
	,	CONVERT(varchar(10),h1fcp.HairSystemColorPercentageDescriptionShort) as highpfront  --Highlight1FrontHairSystemColorPercentage
	,	CONVERT(varchar(10),h1thc.HairSystemHairColorDescriptionShort) as highctempl --Highlight1TempleHairSystemHairColor
	,	CONVERT(varchar(10),h1tcp.HairSystemColorPercentageDescriptionShort) as highptempl --Highlight1TempleHairSystemColorPercentage
	,	CONVERT(varchar(10),h1tophc.HairSystemHairColorDescriptionShort) as highctop  --Highlight1TopHairSystemHairColor
	,	CONVERT(varchar(10),h1topcp.HairSystemColorPercentageDescriptionShort) as highptop  --Highlight1TopHairSystemColorPercentage
	,	CONVERT(varchar(10),h1shc.HairSystemHairColorDescriptionShort) as highcsides  --Highlight1SidesHairSystemHairColor
	,	CONVERT(varchar(10),h1scp.HairSystemColorPercentageDescriptionShort) as highpsides --Highlight1SidesHairSystemColorPercentage
	,	CONVERT(varchar(10),h1chc.HairSystemHairColorDescriptionShort) as highccrown  --Highlight1CrownHairSystemHairColor
	,	CONVERT(varchar(10),h1ccp.HairSystemColorPercentageDescriptionShort) as highpcrown  --Highlight1CrownHairSystemColorPercentage
	,	CONVERT(varchar(10),h1bhc.HairSystemHairColorDescriptionShort) as highcback --Highlight1BackHairSystemHairColor
	,	CONVERT(varchar(10),h1bcp.HairSystemColorPercentageDescriptionShort) as highpback --Highlight1BackHairSystemColorPercentage
	,	CONVERT(varchar(10),h2hm.HairSystemHairMaterialDescriptionShort) as hig2human  --Highlight2HairSystemHairMaterial
	,	CONVERT(varchar(10),h2h.HairSystemHighlightDescriptionShort) as hig2streak  --Highlight2HairSystemHighlight
	,	CONVERT(varchar(10),h2fhc.HairSystemHairColorDescriptionShort) as hig2cfront --Highlight2FrontHairSystemHairColor
	,	CONVERT(varchar(10),h2fcp.HairSystemColorPercentageDescriptionShort) as hig2pfront -- Highlight2FrontHairSystemColorPercentage
	,	CONVERT(varchar(10),h2thc.HairSystemHairColorDescriptionShort) as hig2ctempl --Highlight2TempleHairSystemHairColor
	,	CONVERT(varchar(10),h2tcp.HairSystemColorPercentageDescriptionShort) as hig2ptempl  -- Highlight2TempleHairSystemColorPercentage
	,	CONVERT(varchar(10),h2tophc.HairSystemHairColorDescriptionShort) as hig2ctop  --Highlight2TopHairSystemHairColor
	,	CONVERT(varchar(10),h2topcp.HairSystemColorPercentageDescriptionShort) as hig2ptop  --Highlight2TopHairSystemColorPercentage
	,	CONVERT(varchar(10),h2shc.HairSystemHairColorDescriptionShort) as hig2csides  --Highlight2SidesHairSystemHairColor
	,	CONVERT(varchar(10),h2scp.HairSystemColorPercentageDescriptionShort) as hig2psides  --Highlight2SidesHairSystemColorPercentage
	,	CONVERT(varchar(10),h2chc.HairSystemHairColorDescriptionShort) as hig2ccrown  --Highlight2CrownHairSystemHairColor
	,	CONVERT(varchar(10),h2ccp.HairSystemColorPercentageDescriptionShort) as hig2pcrown  --Highlight2CrownHairSystemColorPercentage
	,	CONVERT(varchar(10),h2bhc.HairSystemHairColorDescriptionShort) as hig2cback  --Highlight2BackHairSystemHairColor
	,	CONVERT(varchar(10),h2bcp.HairSystemColorPercentageDescriptionShort) as hig2pback  --Highlight2BackHairSystemColorPercentage
	,	CONVERT(varchar(10),ghm.HairSystemHairMaterialDescriptionShort) as greyhuman  --GreyHairSystemHairMaterial
	,	CONVERT(varchar(10),gfcp.HairSystemColorPercentageDescriptionShort) as greypfront --GreyFrontHairSystemColorPercentage
	,	CONVERT(varchar(10),gtcp.HairSystemColorPercentageDescriptionShort) as greyptempl  --GreyTempleHairSystemColorPercentage
	,	CONVERT(varchar(10),gtopcp.HairSystemColorPercentageDescriptionShort) as greyptop --GreyTopHairSystemColorPercentage
	,	CONVERT(varchar(10),gscp.HairSystemColorPercentageDescriptionShort) as greypsides  --GreySidesHairSystemColorPercentage
	,	CONVERT(varchar(10),gccp.HairSystemColorPercentageDescriptionShort) as greypcrown -- GreyCrownHairSystemColorPercentage
	,	CONVERT(varchar(10),gbcp.HairSystemColorPercentageDescriptionShort) as greypback  --GreyBackHairSystemColorPercentage
	,	CONVERT(varchar(10),hsc.HairSystemCurlDescriptionShort) as hairccode  --HairSystemCurlShortDesc
	,	CONVERT(varchar(100),hsc.HairSystemCurlDescription) as haircdesc --HairSystemCurlDesc
	,	CONVERT(varchar(10),hss.HairSystemStyleDescriptionShort) as hairscode --HairSystemStyleShortDesc
	,	CONVERT(varchar(100),hss.HairSystemStyleDescription) as hairsdesc --HairSystemStyleDesc
	,	hso.CenterUseFromBridgeDistance	as frombridge
	,	CASE WHEN hso.CenterUseIsPermFlag = 1 THEN 1 ELSE 0 END as permcode
	,	CASE WHEN hso.CenterUseIsPermFlag = 1 THEN 'In-House Perm' ELSE 'No In-House Perm' END as permdesc
	,	CASE WHEN hso.CenterUseIsPermFlag = 1 THEN 'P' ELSE null END as ownhaircod
	,	CONVERT(varchar(5), me.EmployeeInitials) as samplsinit
	,	hso.TemplateReceivedDate as samplsdate
	,	CONVERT(varchar(5), me.EmployeeInitials) as techninit
	,	hso.HairSystemOrderDate as techndate
	--,	CONVERT(varchar(500), nc.NotesClient) as notes  -- In-Salon Note
	,	CONVERT(varchar(500), dbo.fnGetInSalonNotesForHairSystemOrder(hso.HairSystemOrderGUID)) as notes -- In-Salon Note
	,	CASE WHEN hso.IsSampleOrderFlag = 1 THEN 'Y' ELSE 'N' END as samplesent
	,	CONVERT(text, dbo.fnGetNotesForHairSystemOrderFoxPro(hso.HairSystemOrderGUID)) as factnotes  -- Factory Notes
	,	CASE WHEN ISNULL(hso.IsRushOrderFlag, 0) = 0 THEN 'N' ELSE 'Y' END as rush
	,	'HK' as factoryid
	,	'A' as fassigned
	,	'TRUE' as didprintfo
	,	'FALSE' as didfax
	,	CONVERT(varchar(10),v.VendorDescriptionShort) as factactual
	,	po.PurchaseOrderNumber as hponumber
	,	hso.LastUpdate as statuserid
	,	null as statreq			-- ignored in ssis foxpro mapping
	,	null as statfact		-- ignored in ssis foxpro mapping
	,	null as statreply		-- ignored in ssis foxpro mapping
	,	CONVERT(varchar(50),cl.FirstName) as firstname
	,	CONVERT(varchar(50),cl.LastName) as lastname
	,	hso.CostContract as factcost
	,	hso.CostActual as costbase
	,	0 as costhuman
	,	0 as costlength
	,	0 as costarea
	,	0 as costadj
	,	CASE WHEN ct.CenterTypeDescriptionShort = 'C' THEN 'H' ELSE 'HI' END AS [group]
	,	'' AS faccode
	,	hso.CenterPrice AS price
	,	po.PurchaseOrderCount  as OrderCount
	FROM datPurchaseOrderDetail pd
		INNER JOIN datHairSystemOrder hso ON hso.HairSystemOrderGUID = pd.HairSystemOrderGUID
		INNER JOIN cfgCenter c ON c.CenterID = hso.ClientHomeCenterID
		INNER JOIN lkpCenterType ct ON ct.CenterTypeID = c.CenterTypeID
		INNER JOIN datClient cl ON cl.ClientGUID = hso.ClientGUID
		INNER JOIN datPurchaseOrder po ON pd.PurchaseOrderGUID = po.PurchaseOrderGUID
		INNER JOIN cfgVendor v ON po.VendorID = v.VendorID


		---- In-Salon Notes
		--LEFT OUTER JOIN datNotesClient nc ON nc.HairSystemOrderGUID = hso.HairSystemOrderGUID
		--								AND nc.NoteTypeID = @inSalonNoteTypeId

		LEFT OUTER JOIN lkpChargeDecision chrg ON hso.ChargeDecisionID = chrg.ChargeDecisionID
		LEFT OUTER JOIN lkpCountry ctry ON ctry.CountryID = c.CountryID
		LEFT OUTER JOIN lkpHairSystemCurl hsc ON hso.HairSystemCurlID = hsc.HairSystemCurlID
		LEFT OUTER JOIN lkpHairSystemOrderStatus stat ON hso.HairSystemOrderStatusID = stat.HairSystemOrderStatusID
		LEFT OUTER JOIN cfgHairSystem hs ON hso.HairSystemID = hs.HairSystemID
		LEFT OUTER JOIN lkpHairSystemMatrixColor hsmc ON hsmc.HairSystemMatrixColorID= hso.HairSystemMatrixColorID
		LEFT OUTER JOIN lkpHairSystemDesignTemplate dt ON dt.HairSystemDesignTemplateID = hso.HairSystemDesignTemplateID
		LEFT OUTER JOIN lkpHairSystemRecession hsr ON hsr.HairSystemRecessionID = hso.HairSystemRecessionID
		LEFT OUTER JOIN lkpHairSystemHairLength hshl ON hso.HairSystemHairLengthID = hshl.HairSystemHairLengthID
		LEFT OUTER JOIN lkpHairSystemDensity hsd ON hsd.HairSystemDensityID = hso.HairSystemDensityID
		LEFT OUTER JOIN lkpHairSystemFrontalDensity hsfd ON hsfd.HairSystemFrontalDensityID = hso.HairSystemFrontalDensityID
		LEFT OUTER JOIN lkpHairSystemStyle hss ON hso.HairSystemStyleID = hss.HairSystemStyleID
		LEFT OUTER JOIN lkpHairSystemFrontalDesign hsfdsn ON hso.HairSystemFrontalDesignID = hsfdsn.HairSystemFrontalDesignID
		LEFT OUTER JOIN datEmployee me ON hso.MeasurementEmployeeGUID = me.EmployeeGUID
		LEFT OUTER JOIN datClientMembership cmem ON hso.ClientMembershipGUID = cmem.ClientMembershipGUID
		LEFT OUTER JOIN cfgMembership mem  ON cmem.MembershipID = mem.MembershipID
		LEFT OUTER JOIN lkpRevenueGroup rg ON mem.RevenueGroupID = rg.RevenueGroupID
		-- Main Color
		LEFT OUTER JOIN lkpHairSystemHairMaterial chm ON hso.ColorHairSystemHairMaterialID = chm.HairSystemHairMaterialID
		LEFT OUTER JOIN lkpHairSystemHairColor cfhc ON hso.ColorFrontHairSystemHairColorID = cfhc.HairSystemHairColorID
		LEFT OUTER JOIN lkpHairSystemHairColor cthc ON hso.ColorTempleHairSystemHairColorID = cthc.HairSystemHairColorID
		LEFT OUTER JOIN lkpHairSystemHairColor ctophc ON hso.ColorTopHairSystemHairColorID = ctophc.HairSystemHairColorID
		LEFT OUTER JOIN lkpHairSystemHairColor cshc ON hso.ColorSidesHairSystemHairColorID = cshc.HairSystemHairColorID
		LEFT OUTER JOIN lkpHairSystemHairColor cchc ON hso.ColorCrownHairSystemHairColorID = cchc.HairSystemHairColorID
		LEFT OUTER JOIN lkpHairSystemHairColor cbhc ON hso.ColorBackHairSystemHairColorID = cbhc.HairSystemHairColorID
		--Highlight 1
		LEFT JOIN lkpHairSystemHairMaterial h1hm ON hso.Highlight1HairSystemHairMaterialID = h1hm.HairSystemHairMaterialID
		LEFT JOIN lkpHairSystemHighlight h1h ON hso.Highlight1HairSystemHighlightID = h1h.HairSystemHighlightID
		LEFT JOIN lkpHairSystemHairColor h1fhc ON hso.Highlight1FrontHairSystemHairColorID = h1fhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h1fcp ON hso.Highlight1FrontHairSystemColorPercentageID = h1fcp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemHairColor h1thc ON hso.Highlight1TempleHairSystemHairColorID = h1thc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h1tcp ON hso.Highlight1TempleHairSystemColorPercentageID = h1tcp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemHairColor h1tophc ON hso.Highlight1TopHairSystemHairColorID = h1tophc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h1topcp ON hso.Highlight1TopHairSystemColorPercentageID = h1topcp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemHairColor h1shc ON hso.Highlight1SidesHairSystemHairColorID = h1shc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h1scp ON hso.Highlight1SidesHairSystemColorPercentageID = h1scp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemHairColor h1chc ON hso.Highlight1CrownHairSystemHairColorID = h1chc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h1ccp ON hso.Highlight1CrownHairSystemColorPercentageID = h1ccp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemHairColor h1bhc ON hso.Highlight1BackHairSystemHairColorID = h1bhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h1bcp ON hso.Highlight1BackHairSystemColorPercentageID = h1bcp.HairSystemColorPercentageID
		-- Highlight 2
		LEFT JOIN lkpHairSystemHairMaterial h2hm ON hso.Highlight2HairSystemHairMaterialID = h2hm.HairSystemHairMaterialID
		LEFT JOIN lkpHairSystemHighlight h2h ON  hso.Highlight2HairSystemHighlightID = h2h.HairSystemHighlightID
		LEFT JOIN lkpHairSystemHairColor h2fhc ON hso.Highlight2FrontHairSystemHairColorID = h2fhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h2fcp ON hso.Highlight2FrontHairSystemColorPercentageID = h2fcp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemHairColor h2thc ON hso.Highlight2TempleHairSystemHairColorID = h2thc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h2tcp ON hso.Highlight2TempleHairSystemColorPercentageID = h2tcp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemHairColor h2tophc ON hso.Highlight2TopHairSystemHairColorID = h2tophc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h2topcp ON hso.Highlight2TopHairSystemColorPercentageID = h2topcp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemHairColor h2shc ON hso.Highlight2SidesHairSystemHairColorID = h2shc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h2scp ON hso.Highlight2SidesHairSystemColorPercentageID = h2scp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemHairColor h2chc ON hso.Highlight2CrownHairSystemHairColorID = h2chc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h2ccp ON hso.Highlight2CrownHairSystemColorPercentageID = h2ccp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemHairColor h2bhc ON hso.Highlight2BackHairSystemHairColorID = h2bhc.HairSystemHairColorID
		LEFT JOIN lkpHairSystemColorPercentage h2bcp ON hso.Highlight2BackHairSystemColorPercentageID = h2bcp.HairSystemColorPercentageID
		-- Grey Percentage
		LEFT JOIN lkpHairSystemHairMaterial ghm ON hso.GreyHairSystemHairMaterialID = ghm.HairSystemHairMaterialID
		LEFT JOIN lkpHairSystemColorPercentage gfcp ON hso.GreyFrontHairSystemColorPercentageID = gfcp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage gtcp ON hso.GreyTempleHairSystemColorPercentageID = gtcp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage gtopcp ON hso.GreyTopHairSystemColorPercentageID = gtopcp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage gscp ON hso.GreySidesHairSystemColorPercentageID = gscp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage gccp ON hso.GreyCrownHairSystemColorPercentageID = gccp.HairSystemColorPercentageID
		LEFT JOIN lkpHairSystemColorPercentage gbcp ON hso.GreyBackHairSystemColorPercentageID = gbcp.HairSystemColorPercentageID

	WHERE pd.PurchaseOrderGUID = @PurchaseOrderGUID
	ORDER BY hso.CenterID, cl.ClientIdentifier
END
