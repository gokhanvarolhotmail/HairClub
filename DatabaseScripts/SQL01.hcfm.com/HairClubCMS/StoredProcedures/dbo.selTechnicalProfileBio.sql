/***********************************************************************
	PROCEDURE:				[selTechnicalProfileBio]
	DESTINATION SERVER:		SQL01
	DESTINATION DATABASE: 	HairClubCMS
	RELATED APPLICATION:  	CMS
	AUTHOR: 				PRM
	IMPLEMENTOR: 			PRM
	DATE IMPLEMENTED: 		02/06/2017
	LAST REVISION DATE: 	07/17/2019
	--------------------------------------------------------------------------------------------------------
	NOTES: 	Return a single BIO Technical Profile - does NOT include Scalp Prep records

			02/06/2017 - PRM Created Stored Proc
			02/09/2017 - SAL Modified to return tp.LastUpdateUser
			07/17/2019 - JLM Modified to select stylist app technical profile fields. (TFS #12564)
			06/25/2020 - AP Include LastUpdate (TFS# 14550)

	--------------------------------------------------------------------------------------------------------
	SAMPLE EXECUTION:
	EXEC [selTechnicalProfileBio] '7BE39604-BD0F-45E0-B5FF-00000EB1EEC4'
***********************************************************************/
CREATE PROCEDURE [dbo].[selTechnicalProfileBio]
	@ClientGuid uniqueidentifier

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TOP 1
        tp.TechnicalProfileID, tp.TechnicalProfileDate,tp.LastUpdate, tp.ClientGUID, tp.Notes, tp.LastUpdateUser,
			tp.EmployeeGUID, e.UserLogin,
			tp.SalesOrderGUID, so.InvoiceNumber, soe.EmployeeInitials,
        color.TechnicalProfileColorID,
			color.ColorBrandID, cb.ColorBrandDescription, cb.ColorBrandDescriptionShort,
			color.ColorFormula1, color.ColorFormulaSize1ID, cfs1.ColorFormulaSizeDescription AS ColorFormulaSize1Description, cfs1.ColorFormulaSizeDescriptionShort AS ColorFormulaSize1DescriptionShort,
			color.ColorFormula2, color.ColorFormulaSize2ID, cfs2.ColorFormulaSizeDescription AS ColorFormulaSize2Description, cfs2.ColorFormulaSizeDescriptionShort AS ColorFormulaSize2DescriptionShort,
			color.ColorFormula3, color.ColorFormulaSize3ID, cfs3.ColorFormulaSizeDescription AS ColorFormulaSize3Description, cfs3.ColorFormulaSizeDescriptionShort AS ColorFormulaSize3DescriptionShort,
			color.DeveloperSizeID, ds.DeveloperSizeDescription, ds.DeveloperSizeDescriptionShort,
			color.DeveloperVolumeID, dv.DeveloperVolumeDescription, dv.DeveloperVolumeDescriptionShort,
			color.ColorProcessingTime, color.ColorProcessingTimeUnitID, cptu.TimeUnitDescription AS ColorProcessingTimeUnitDescription, cptu.TimeUnitDescriptionShort AS ColorProcessingTimeUnitDescriptionShort,
        bio.TechnicalProfileBioID,
			bio.IsClientUsingOwnHairline, bio.DistanceHairlineToNose, bio.LastTemplateDate, bio.LastTrimDate,
			bio.HairSystemID, hs.HairSystemDescription, hs.HairSystemDescriptionShort,
			bio.AdhesiveFront1ID, af1.AdhesiveFrontDescription AS AdhesiveFront1Description, af1.AdhesiveFrontDescriptionShort AS AdhesiveFront1DescriptionShort,
			bio.AdhesiveFront2ID, af2.AdhesiveFrontDescription AS AdhesiveFront2Description, af2.AdhesiveFrontDescriptionShort AS AdhesiveFront2DescriptionShort,
			bio.AdhesivePerimeter1ID, ap1.AdhesivePerimeterDescription AS AdhesivePerimeter1Description, ap1.AdhesivePerimeterDescriptionShort AS AdhesivePerimeter1DescriptionShort,
			bio.AdhesivePerimeter2ID, ap2.AdhesivePerimeterDescription AS AdhesivePerimeter2Description, ap2.AdhesivePerimeterDescriptionShort AS AdhesivePerimeter2DescriptionShort,
			bio.AdhesivePerimeter3ID, ap3.AdhesivePerimeterDescription AS AdhesivePerimeter3Description, ap3.AdhesivePerimeterDescriptionShort AS AdhesivePerimeter3DescriptionShort,
			bio.RemovalProcessID, rp.RemovalProcessDescription, rp.RemovalProcessDescriptionShort,
			bio.AdhesiveSolventID, aso.AdhesiveSolventDescription, aso.AdhesiveSolventDescriptionShort,
			bio.ApplicationDuration, bio.ApplicationTimeUnitID, apptu.TimeUnitDescription AS ApplicationTimeUnitDescription, apptu.TimeUnitDescriptionShort AS ApplicationTimeUnitDescriptionShort,
			bio.FullServiceDuration, bio.FullServiceTimeUnitID, fstu.TimeUnitDescription AS FullServiceTimeUnitDescription, fstu.TimeUnitDescriptionShort AS FullServiceTimeUnitDescriptionShort,
			bio.OtherServiceDuration, bio.OtherServiceTimeUnitID, ostu.TimeUnitDescription AS OtherServiceTimeUnitDescription, ostu.TimeUnitDescriptionShort AS OtherServiceTimeUnitDescriptionShort,
			bio.OtherServiceSalesCodeID, sc.SalesCodeDescription AS OtherServiceSalesCodeDescription, sc.SalesCodeDescriptionShort AS OtherServiceSalesCodeDescriptionShort,
			bio.IsHairOrderReviewRequired, bio.IsHairSystemColorRequired, bio.IsHairSystemHighlightRequired,
		--Scalp Prep has multiple records returned, perform a second query to return this list of data
		--scalp.TechnicalProfileScalpPreparationID,
		--	scalp.ScalpPreparationID, sp.ScalpPreparationDescription, sp.ScalpPreparationDescriptionShort,
		relax.TechnicalProfilePermRelaxerID,
			relax.PermOwnPermBrandID, popb.PermBrandDescription AS PermOwnPermBrandDescription, popb.PermBrandDescriptionShort AS PermOwnPermBrandDescriptionShort,
			relax.PermOwnPermOwnHairRods1ID, pohr1.PermOwnHairRodsDescription AS PermOwnPermOwnHairRods1Description, pohr1.PermOwnHairRodsDescriptionShort AS PermOwnPermOwnHairRods1DescriptionShort,
			relax.PermOwnPermOwnHairRods2ID, pohr2.PermOwnHairRodsDescription AS PermOwnPermOwnHairRods2Description, pohr2.PermOwnHairRodsDescriptionShort AS PermOwnPermOwnHairRods2DescriptionShort,
			relax.PermOwnProcessingTime, relax.PermOwnProcessingTimeUnitID, poptu.TimeUnitDescription AS PermOwnProcessingTimeUnitDescription, poptu.TimeUnitDescriptionShort AS PermOwnProcessingTimeUnitDescriptionShort,
			relax.PermOwnPermTechniqueID, popt.PermTechniqueDescription AS PermOwnPermTechniqueDescription, popt.PermTechniqueDescriptionShort AS PermOwnPermTechniqueDescriptionShort,
			relax.PermSystemPermBrandID, pspb.PermBrandDescription AS PermSystemPermBrandDescription, pspb.PermBrandDescriptionShort AS PermSystemPermBrandDescriptionShort,
			relax.PermSystemPermOwnHairRods1ID, pshr1.PermOwnHairRodsDescription AS PermSystemPermOwnHairRods1Description, pshr1.PermOwnHairRodsDescriptionShort AS PermSystemPermOwnHairRods1DescriptionShort,
			relax.PermSystemPermOwnHairRods2ID, pshr2.PermOwnHairRodsDescription AS PermSystemPermOwnHairRods2Description, pshr2.PermOwnHairRodsDescriptionShort AS PermSystemPermOwnHairRods2DescriptionShort,
			relax.PermSystemProcessingTime, relax.PermSystemProcessingTimeUnitID, psptu.TimeUnitDescription AS PermSystemProcessingTimeUnitDescription, psptu.TimeUnitDescriptionShort AS PermSystemProcessingTimeUnitDescriptionShort,
			relax.PermSystemPermTechniqueID, pspt.PermTechniqueDescription AS PermSystemPermTechniqueDescription, pspt.PermTechniqueDescriptionShort AS PermSystemPermTechniqueDescriptionShort,
			relax.RelaxerBrandID, rb.RelaxerBrandDescription AS RelaxerBrandDescription, rb.RelaxerBrandDescriptionShort AS RelaxerBrandDescriptionShort,
			relax.RelaxerStrengthID, rs.RelaxerStrengthDescription AS RelaxerStrengthDescription, rs.RelaxerStrengthDescriptionShort AS RelaxerStrengthDescriptionShort,
			relax.RelaxerProcessingTime, relax.RelaxerProcessingTimeUnitID, rptu.TimeUnitDescription AS RelaxerProcessingTimeUnitDescription, rptu.TimeUnitDescriptionShort AS RelaxerProcessingTimeUnitDescriptionShort

    FROM datTechnicalProfile tp
		INNER JOIN datClient c ON tp.ClientGUID = c.ClientGUID
		LEFT JOIN datEmployee e ON tp.EmployeeGUID = e.EmployeeGUID
		LEFT JOIN datSalesOrder so ON tp.SalesOrderGUID = so.SalesOrderGUID
		LEFT JOIN datEmployee soe ON so.EmployeeGUID = soe.EmployeeGUID
		LEFT JOIN datTechnicalProfileColor color ON tp.TechnicalProfileID = color.TechnicalProfileID
			LEFT JOIN lkpColorBrand cb ON color.ColorBrandID = cb.ColorBrandID
			LEFT JOIN lkpColorFormulaSize cfs1 ON color.ColorFormulaSize1ID = cfs1.ColorFormulaSizeID
			LEFT JOIN lkpColorFormulaSize cfs2 ON color.ColorFormulaSize2ID = cfs2.ColorFormulaSizeID
			LEFT JOIN lkpColorFormulaSize cfs3 ON color.ColorFormulaSize3ID = cfs3.ColorFormulaSizeID
			LEFT JOIN lkpDeveloperSize ds ON color.DeveloperSizeID = ds.DeveloperSizeID
			LEFT JOIN lkpDeveloperVolume dv ON color.DeveloperVolumeID = dv.DeveloperVolumeID
			LEFT JOIN lkpTimeUnit cptu ON color.ColorProcessingTimeUnitID = cptu.TimeUnitID
		INNER JOIN datTechnicalProfileBio bio ON tp.TechnicalProfileID = bio.TechnicalProfileID
			LEFT JOIN cfgHairSystem hs ON bio.HairSystemID = hs.HairSystemID
			LEFT JOIN lkpAdhesiveFront af1 ON bio.AdhesiveFront1ID = af1.AdhesiveFrontID
			LEFT JOIN lkpAdhesiveFront af2 ON bio.AdhesiveFront2ID = af2.AdhesiveFrontID
			LEFT JOIN lkpAdhesivePerimeter ap1 ON bio.AdhesivePerimeter1ID = ap1.AdhesivePerimeterID
			LEFT JOIN lkpAdhesivePerimeter ap2 ON bio.AdhesivePerimeter2ID = ap2.AdhesivePerimeterID
			LEFT JOIN lkpAdhesivePerimeter ap3 ON bio.AdhesivePerimeter3ID = ap3.AdhesivePerimeterID
			LEFT JOIN lkpRemovalProcess rp ON bio.RemovalProcessID = rp.RemovalProcessID
			LEFT JOIN lkpAdhesiveSolvent aso ON bio.AdhesiveSolventID = aso.AdhesiveSolventID
			LEFT JOIN lkpTimeUnit apptu ON bio.ApplicationTimeUnitID = apptu.TimeUnitID
			LEFT JOIN lkpTimeUnit fstu ON bio.FullServiceTimeUnitID = fstu.TimeUnitID
			LEFT JOIN lkpTimeUnit ostu ON bio.OtherServiceTimeUnitID = ostu.TimeUnitID
			LEFT JOIN cfgSalesCode sc ON bio.OtherServiceSalesCodeID = sc.SalesCodeID
		--LEFT JOIN datTechnicalProfileScalpPreparation scalp ON tp.TechnicalProfileID = scalp.TechnicalProfileID
		--	LEFT JOIN lkpScalpPreparation sp ON scalp.ScalpPreparationID = sp.ScalpPreparationID
		LEFT JOIN datTechnicalProfilePermRelaxer relax ON tp.TechnicalProfileID = relax.TechnicalProfileID
			LEFT JOIN lkpPermBrand popb ON relax.PermOwnPermBrandID = popb.PermBrandID
			LEFT JOIN lkpPermOwnHairRods pohr1 ON relax.PermOwnPermOwnHairRods1ID = pohr1.PermOwnHairRodsID
			LEFT JOIN lkpPermOwnHairRods pohr2 ON relax.PermOwnPermOwnHairRods2ID = pohr2.PermOwnHairRodsID
			LEFT JOIN lkpTimeUnit poptu ON relax.PermOwnProcessingTimeUnitID = poptu.TimeUnitID
			LEFT JOIN lkpPermTechnique popt ON relax.PermOwnPermTechniqueID = popt.PermTechniqueID
			LEFT JOIN lkpPermBrand pspb ON relax.PermSystemPermBrandID = pspb.PermBrandID
			LEFT JOIN lkpPermOwnHairRods pshr1 ON relax.PermSystemPermOwnHairRods1ID = pshr1.PermOwnHairRodsID
			LEFT JOIN lkpPermOwnHairRods pshr2 ON relax.PermSystemPermOwnHairRods2ID = pshr2.PermOwnHairRodsID
			LEFT JOIN lkpTimeUnit psptu ON relax.PermSystemProcessingTimeUnitID = psptu.TimeUnitID
			LEFT JOIN lkpPermTechnique pspt ON relax.PermSystemPermTechniqueID = pspt.PermTechniqueID
			LEFT JOIN lkpRelaxerBrand rb ON relax.RelaxerBrandID = rb.RelaxerBrandID
			LEFT JOIN lkpRelaxerStrength rs ON relax.RelaxerStrengthID = rs.RelaxerStrengthID
			LEFT JOIN lkpTimeUnit rptu ON relax.RelaxerProcessingTimeUnitID = rptu.TimeUnitID

    WHERE tp.ClientGUID = @ClientGUID
	ORDER BY tp.TechnicalProfileDate DESC

  END
