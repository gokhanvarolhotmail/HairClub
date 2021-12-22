/****** Object:  StoredProcedure [dbo].[rptClientOverview_DigitalFile]    Script Date: 12/11/2013 9:40:56 AM ******/


/*===============================================================================================
-- Procedure Name:              rptClientOverview_DigitalFile
-- Procedure Description:		This version of the stored procedure is used in the rptClientDigitalFile.rdl and uses ClientIdentifier as the parameter.
--
-- Created By:                  Rachelen Hut
-- Date Created:				12/18/2015
================================================================================================
CHANGE HISTORY:
02/02/2017 - RH - (#134857) Rewrote this stored procedure using the new tables for Technical Profiles for XTR+, EXT and XTR
================================================================================================
SAMPLE EXECUTION:

EXEC rptClientOverview_DigitalFile 'D0129A1B-F0EA-47B5-91AD-1324CE603276'

EXEC rptClientOverview_DigitalFile '3C7319C7-FCF2-42F0-9048-659B4BF176B1'  --Arthur Whalen  283 - Cincinnati
================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientOverview_DigitalFile]
	@ClientIdentifier INT
AS
BEGIN


/**************************Find the list of scalp preparations and place them into a comma separated list***********/

DECLARE @ClientGUID UNIQUEIDENTIFIER

--Find the ClientGUID using the @ClientIdentifier

SET @ClientGUID = (SELECT TOP 1 ClientGUID FROM datClient WHERE ClientIdentifier = @ClientIdentifier)

DECLARE @ScalpPreparationDescriptions VARCHAR(MAX)

SELECT @ScalpPreparationDescriptions = COALESCE(@ScalpPreparationDescriptions + ', ', '') +  CONVERT(nvarchar,ScalpPreparationDescription)
FROM datTechnicalProfile TPH
	LEFT JOIN [dbo].[datTechnicalProfileScalpPreparation] TPSP
		ON TPH.TechnicalProfileID = TPSP.TechnicalProfileID
	LEFT JOIN [dbo].[lkpScalpPreparation] SP
		ON TPSP.ScalpPreparationID = SP.ScalpPreparationID
WHERE ClientGUID = @ClientGUID
AND TechnicalProfileDate IN (
								SELECT TechnicalProfileDate FROM (SELECT TechnicalProfileDate
									,ROW_NUMBER() OVER(PARTITION BY ClientGUID ORDER BY TechnicalProfileDate DESC) TPRANK
									FROM datTechnicalProfile
									WHERE ClientGUID = @ClientGUID) q
								WHERE TPRANK = 1)

/***************************Main Select Statement******************************************************************/

	SELECT
		cl.ClientGUID
		,	cl.ClientFullNameCalc
		,	ce.CenterDescriptionFullCalc
		,	m.MembershipID
		,	m.MembershipDescription
		,	cm.EndDate RenewalDate

		,	eftat.EFTAccountTypeDescription
		,	pc.FeePayCycleDescription
		,	cm.MonthlyFee
		,	cm.ContractPrice
		,	ar.AccumMoney AR

		,	ahs.TotalAccumQuantity HairSystemTotal
		,	ahs.UsedAccumQuantity HairSystemUsed
		,	ahs.AccumQuantityRemainingCalc HairSystemRemaining
		,	dbo.[fn_GetClientAccumLastUsedDate](cl.ClientGUID, 13)   HairSystemDate

		,	asv.TotalAccumQuantity ServicesTotal
		,	asv.UsedAccumQuantity ServicesUsed
		,	asv.AccumQuantityRemainingCalc ServicesRemaining
		,	dbo.[fn_GetClientAccumLastUsedDate](cl.ClientGUID, 16)  ServicesDate

		,	asl.TotalAccumQuantity SolutionsTotal
		,	asl.UsedAccumQuantity SolutionsUsed
		,	asl.AccumQuantityRemainingCalc SolutionsRemaining
		,	dbo.[fn_GetClientAccumLastUsedDate](cl.ClientGUID, 36)  SolutionsDate

		,	apk.TotalAccumQuantity ProdKitTotal
		,	apk.UsedAccumQuantity ProdKitUsed
		,	apk.AccumQuantityRemainingCalc ProdKitRemaining
		,	dbo.[fn_GetClientAccumLastUsedDate](cl.ClientGUID, 37)  ProdKitDate

		--RELAXER
		,	rb.RelaxerBrandDescription
		,	rs.RelaxerStrengthDescription
		,	TPPR.RelaxerProcessingTime
		,	rp.RemovalProcessDescription
		,	ads.AdhesiveSolventDescription

		--Scalp Prep
		,	@ScalpPreparationDescriptions AS 'ScalpPreparation'

		,	CASE TPB.IsClientUsingOwnHairline WHEN 1 THEN 'Yes' ELSE 'No' END AS OwnHair

		,	TPB.DistanceHairlineToNose BridgeToHairline
		,	adf1.AdhesiveFrontDescription AdhesiveFront1
		,	adf2.AdhesiveFrontDescription AdhesiveFront2
		,	adp.AdhesivePerimeterDescription AdhesivePerim
		,	adp1.AdhesivePerimeterDescription AdhesivePerim1
		,	adp2.AdhesivePerimeterDescription AdhesivePerim2
		,	TPB.ApplicationDuration
		,	TPB.FullServiceDuration
		,	TPB.OtherServiceDuration

		--COLOR
		,	cb.ColorBrandDescription
		,	TPC.ColorFormula1
		,	TPC.ColorFormula2
		,	TPC.ColorFormula3
		,	TPC.ColorProcessingTime
		,	cfs.ColorFormulaSizeDescription ColorFormulaSize1
		,	cfs1.ColorFormulaSizeDescription ColorFormulaSize2
		,	cfs2.ColorFormulaSizeDescription ColorFormulaSize3
		,	ds.DeveloperSizeDescription
		,	dv.DeveloperVolumeDescription

		--PERM
		,	pb.PermBrandDescription
		--,	ISNULL(prc1.PermRodColorDescription,own.PermOwnHairRodsDescription) AS 'PermRodColor1'
		--,	ISNULL(prc2.PermRodColorDescription, own2.PermOwnHairRodsDescription) AS 'PermRodColor2'
		,	ptq.PermTechniqueDescription
		,	ISNULL(TPPR.PermSystemProcessingTime,TPPR.PermOwnProcessingTime) AS 'PermProcessingTime'
		--,	tp.PermProcessingTimeSystem  ???

		-- Technical Profile Notes
		,	tp.[Notes] as TechnicalNotes
		,	CAST(tp.TechnicalProfileDate AS DATE) AS 'TechnicalProfileDate'

		--HairSystem
		,	hs.HairSystemDescriptionShort AS 'SystemType'
		,	hs.HairSystemDescription AS HairSystemDescription
		,	ISNULL(CAST(TPB.LastTemplateDate AS DATE),CAST(tp.TechnicalProfileDate AS DATE)) AS 'LastTemplateDate'
		,	TP.TechnicalProfileID

	FROM datClient cl
		INNER JOIN cfgCenter ce
			ON ce.CenterID = cl.CenterID
		LEFT JOIN datClientEFT ceft
			ON ceft.ClientGUID = cl.ClientGUID
		LEFT JOIN lkpFeePayCycle pc
			ON pc.FeePayCycleID = ceft.FeePayCycleID
		LEFT JOIN lkpEFTAccountType eftat
			ON eftat.EFTAccountTypeID = ceft.EFTAccountTypeID
		INNER JOIN datClientMembership cm
			ON cm.ClientMembershipGUID = COALESCE(cl.CurrentBioMatrixClientMembershipGUID,cl.CurrentSurgeryClientMembershipGUID,cl.CurrentExtremeTherapyClientMembershipGUID,cl.CurrentXtrandsClientMembershipGUID)
		INNER JOIN cfgMembership m
			ON m.MembershipID = cm.MembershipID
		--Accumulators!
		LEFT JOIN datClientMembershipAccum ahs
			ON ahs.ClientMembershipGUID = cm.ClientMembershipGUID AND ahs.AccumulatorID = 8 --Hair Systems
		LEFT JOIN datClientMembershipAccum asv
			ON asv.ClientMembershipGUID = cm.ClientMembershipGUID AND asv.AccumulatorID = 9 --Services
		LEFT JOIN datClientMembershipAccum asl
			ON asl.ClientMembershipGUID = cm.ClientMembershipGUID AND asl.AccumulatorID = 10 --Solutions
		LEFT JOIN datClientMembershipAccum apk
			ON apk.ClientMembershipGUID = cm.ClientMembershipGUID AND apk.AccumulatorID = 11 --Product Kits
		LEFT JOIN datClientMembershipAccum ar
			ON ar.ClientMembershipGUID = cm.ClientMembershipGUID AND ar.AccumulatorID = 3 --A/R Balance
		--TECH PROFILE
		LEFT JOIN (
					SELECT *
					,ROW_NUMBER() OVER(PARTITION BY ClientGUID ORDER BY TechnicalProfileDate DESC) TPRANK
					FROM datTechnicalProfile
					) tp
						ON tp.ClientGUID = cl.ClientGUID AND TPRANK = 1
		LEFT JOIN dbo.datTechnicalProfileBio TPB					---insert new table
			ON tp.TechnicalProfileID = TPB.TechnicalProfileID

		LEFT JOIN lkpAdhesiveFront adf1
			ON adf1.AdhesiveFrontID = TPB.AdhesiveFront1ID
		LEFT JOIN lkpAdhesiveFront adf2
			ON adf2.AdhesiveFrontID = TPB.AdhesiveFront2ID
		LEFT JOIN lkpAdhesivePerimeter adp
			ON adp.AdhesivePerimeterID = TPB.AdhesivePerimeter1ID
		LEFT JOIN lkpAdhesivePerimeter adp1
			ON adp1.AdhesivePerimeterID = TPB.AdhesivePerimeter2ID
		LEFT JOIN lkpAdhesivePerimeter adp2
			ON adp2.AdhesivePerimeterID = TPB.AdhesivePerimeter3ID

		LEFT JOIN lkpRemovalProcess rp
			ON rp.RemovalProcessID = TPB.RemovalProcessID
		LEFT JOIN lkpAdhesiveSolvent ads
			ON ads.AdhesiveSolventID = TPB.AdhesiveSolventID

		LEFT JOIN dbo.datTechnicalProfilePermRelaxer TPPR			---insert new table
			ON tp.TechnicalProfileID = TPPR.TechnicalProfileID

		LEFT JOIN lkpRelaxerBrand rb
			ON rb.RelaxerBrandID = TPPR.RelaxerBrandID
		LEFT JOIN lkpRelaxerStrength rs
			ON rs.RelaxerStrengthID = TPPR.RelaxerStrengthID

		LEFT JOIN cfgHairSystem hs
			ON hs.HairSystemID = TPB.HairSystemID

		--COLOR FORMULATION SECTION

		LEFT JOIN dbo.datTechnicalProfileColor TPC
			ON tp.TechnicalProfileID = TPC.TechnicalProfileID		---insert new table

		LEFT JOIN lkpColorBrand cb
			ON cb.ColorBrandID = TPC.ColorBrandID
		LEFT JOIN lkpColorFormulaSize cfs
			ON cfs.ColorFormulaSizeID = TPC.ColorFormulaSize1ID
		LEFT JOIN lkpColorFormulaSize cfs1
			ON cfs1.ColorFormulaSizeID = TPC.ColorFormulaSize2ID
		LEFT JOIN lkpColorFormulaSize cfs2
			ON cfs2.ColorFormulaSizeID = TPC.ColorFormulaSize3ID
		LEFT JOIN lkpDeveloperSize ds
			ON ds.DeveloperSizeID = TPC.DeveloperSizeID
		LEFT JOIN lkpDeveloperVolume dv
			ON dv.DeveloperVolumeID = TPC.DeveloperVolumeID
		LEFT JOIN lkpPermBrand pb
			ON pb.PermBrandID = ISNULL(TPPR.PermOwnPermBrandID,TPPR.PermSystemPermBrandID)

		--LEFT JOIN lkpPermRodColor prc1
		--	ON prc1.PermRodColorID = tp.PermRodColorID
		--LEFT JOIN lkpPermRodColor prc2
		--	ON prc2.PermRodColorID = tp.PermRodColor2ID

		/**************** add these two "tables" *****************/

		LEFT JOIN lkpPermOwnHairRods own
			ON own.PermOwnHairRodsID = TPPR.PermSystemPermOwnHairRods1ID OR own.PermOwnHairRodsID = TPPR.PermOwnPermOwnHairRods1ID
		LEFT JOIN lkpPermOwnHairRods own2
			ON own2.PermOwnHairRodsID = TPPR.PermSystemPermOwnHairRods2ID  	OR 	own2.PermOwnHairRodsID = TPPR.PermOwnPermOwnHairRods2ID

		LEFT JOIN lkpPermTechnique ptq
			ON ptq.PermTechniqueID = TPPR.PermOwnPermTechniqueID OR ptq.PermTechniqueID = TPPR.PermSystemPermTechniqueID

	WHERE cl.ClientGUID = @ClientGUID
END
