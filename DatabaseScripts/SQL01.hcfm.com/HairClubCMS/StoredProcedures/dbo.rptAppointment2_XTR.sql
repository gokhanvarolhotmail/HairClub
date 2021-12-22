/*===============================================================================================
 Procedure Name:            rptAppointment2_XTR
 Procedure Description:
 Created By:                RHut
 Date Created:              03/02/2017
 Destination Server:        HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
CHANGE HISTORY:
05/31/2017 - RH - Added @StrandsPlacedAtLastVisit and XTR.Strands
================================================================================================
SAMPLE EXECUTION:

EXEC [rptAppointment2_XTR] 240,'05/31/2017','05/31/2017',NULL,'93259856-FDB1-4ED6-9225-EBD759656FDF'
EXEC [rptAppointment2_XTR] 240,'02/28/2017','02/28/2017',NULL, '6C6EEF10-7601-415F-97CB-A4DBBC834912' --Vemireddy, Avinash (540849) 240 --Nolden, Heather EXT
EXEC [rptAppointment2_XTR] 240,'02/28/2017','02/28/2017',NULL, 'F3E3DA71-7AAA-4D0A-BC9D-09B8E812E2E9' --Charpenter, Claudette (539335) 240 --Nolden, Heather XTR

================================================================================================*/

CREATE PROCEDURE [dbo].[rptAppointment2_XTR]
	@CenterID INT
	,	@StartDate DATETIME
	,	@EndDate DATETIME
	,	@StylistGUID UNIQUEIDENTIFIER = NULL
	,	@ClientGUID UNIQUEIDENTIFIER = NULL

AS
BEGIN

	SET @EndDate = @EndDate + '23:59:00'

/************************** Find the Quantity of Strands Placed Last Visit ****************************************/

 DECLARE @StrandsPlacedAtLastVisit int

       SELECT TOP 1 @StrandsPlacedAtLastVisit = sod.Quantity
       FROM datSalesOrder so
              inner join datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
              inner join cfgSalesCode sc on sod.SalesCodeID = sc.SalesCodeID
       WHERE so.ClientGUID = @ClientGUID
              and sc.SalesCodeDescriptionShort = 'XTRPROD'
       ORDER BY so.OrderDate DESC

/***************************Main Select Statement******************************************************************/
SELECT
	ap.AppointmentGUID
	,	ap.ClientGUID
	,	cl.ClientFullNameCalc Client
	,	cl.ARBalance ARBalance
	,	sty.EmployeeFullNameCalc Stylist
	,	sty.EmployeeGUID AS 'StylistGUID'
	,	ce.CenterDescriptionFullCalc
	,	ce.CenterID
	,	cCenter.CenterDescriptionFullCalc as ClientHomeCenterDescriptionFullCalc
	,	m.MembershipDescription
	,	M.BusinessSegmentID
	,	stat.ClientMembershipStatusDescription
	,	cm.EndDate AS RenewalDate

	,	ap.AppointmentDate ApptDate
	,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) ApptTime
	,	ap.StartTime StartTime
	,	ap.AppointmentDurationCalc



	--COLOR
	,	cb.ColorBrandDescription
	,	TPC.ColorFormula1
	,	TPC.ColorFormula2
	,	TPC.ColorFormula3
	,	TPC.ColorProcessingTime
	,	cfs1.ColorFormulaSizeDescription ColorFormulaSize1
	,	cfs2.ColorFormulaSizeDescription ColorFormulaSize2
	,	cfs3.ColorFormulaSizeDescription ColorFormulaSize3
	,	ds.DeveloperSizeDescription
	,	dv.DeveloperVolumeDescription


	--XTRStylingProductDescription
	,	STUFF(R.XTRStylingProducts, 1, 1, '') AS 'XTRStylingProducts'
	--XTRAreaOfConcern
	,	STUFF(U.XTRAreaOfConcern, 1, 1, '') AS 'XTRAreaOfConcern'
	--XTRStrandBuilderColorDescription
	,	STUFF(W.XTRStrandBuilderColorDescription, 1, 1, '') AS 'XTRStrandBuilderColorDescription'
	--XTRHairStrandColorDescription
	,	STUFF(X.XTRHairStrandColorDescription, 1, 1, '') AS 'XTRHairStrandColorDescription'
	--XTRPlacementScalpRegionDescription
	,	STUFF(Y.XTRPlacementScalpRegionDescription, 1, 1, '') AS 'XTRPlacementScalpRegionDescription'


	-- Technical Profile Notes
	,	tp.[Notes] as TechnicalNotes
	,	CAST(tp.TechnicalProfileDate AS DATE) AS 'TechnicalProfileDate'


	--XTRANDS fields
	,	XTR.LastTrichoViewDate
	,	XTR.LastXtrandsServiceDate
	,	HSG.HairStrandGroupDescription AS 'NumberOfStrands'
	,	XTRShampoo.SalesCodeDescription AS 'XTRShampooDescription'
	,	XtrConditioner.SalesCodeDescription AS 'XTRConditionerDescription'
	,	XtrLaserDevice.SalesCodeDescription AS 'XTRLaserDeviceDescription'
	,	XTRHairHealth.HairHealthDescription	AS 'XTRHairHealthDescription'
	,	XTR.ServiceDuration AS 'XTRServiceDuration'
	,	XTR.Other AS 'XTROther'
	,	XTRMinoxidil.SalesCodeDescription AS 'XTRMinoxidilDescription'
	,	XTR.Strands
	,	@StrandsPlacedAtLastVisit AS 'StrandsPlacedAtLastVisit'


FROM dbo.datAppointment ap
	INNER JOIN dbo.datAppointmentEmployee ae
		ON ae.AppointmentGUID = ap.AppointmentGUID
	INNER JOIN datEmployee sty
		ON sty.EmployeeGUID = ae.EmployeeGUID
	INNER JOIN datClient cl
		ON cl.ClientGUID = ap.ClientGUID
	INNER JOIN cfgCenter ce
		ON ce.CenterID = ap.CenterID
	INNER JOIN cfgCenter cCenter
		ON ap.ClientHomeCenterID = cCenter.CenterID
	INNER JOIN datClientMembership cm
		ON cm.ClientMembershipGUID = ap.ClientMembershipGUID
	LEFT JOIN dbo.lkpClientMembershipStatus stat
		ON cm.ClientMembershipStatusID = stat.ClientMembershipStatusID
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
	LEFT JOIN datClientMembershipAccum hcsl
		ON hcsl.ClientMembershipGUID = cm.ClientMembershipGUID AND hcsl.AccumulatorID = 41 --Hair Care and Styling Lesson
	LEFT JOIN datClientMembershipAccum sns
		ON hcsl.ClientMembershipGUID = cm.ClientMembershipGUID AND sns.AccumulatorID = 42 --S & S
	LEFT JOIN (
			SELECT *
			,ROW_NUMBER() OVER(PARTITION BY ClientGUID ORDER BY TechnicalProfileDate DESC) TPRANK
			FROM datTechnicalProfile
			) tp
				ON tp.ClientGUID = ap.ClientGUID AND TPRANK = 1


	--COLOR FORMULATION SECTION
	LEFT JOIN dbo.datTechnicalProfileColor TPC
		ON tp.TechnicalProfileID = TPC.TechnicalProfileID		---insert new table

	LEFT JOIN lkpColorBrand cb
		ON cb.ColorBrandID = TPC.ColorBrandID
	LEFT JOIN lkpColorFormulaSize cfs1
		ON cfs1.ColorFormulaSizeID = TPC.ColorFormulaSize1ID
	LEFT JOIN lkpColorFormulaSize cfs2
		ON cfs2.ColorFormulaSizeID = TPC.ColorFormulaSize2ID
	LEFT JOIN lkpColorFormulaSize cfs3
		ON cfs3.ColorFormulaSizeID = TPC.ColorFormulaSize3ID
	LEFT JOIN lkpDeveloperSize ds
		ON ds.DeveloperSizeID = TPC.DeveloperSizeID
	LEFT JOIN lkpDeveloperVolume dv
		ON dv.DeveloperVolumeID = TPC.DeveloperVolumeID



/**************** XTRANDS Tables **********************************************************************/

LEFT JOIN dbo.datTechnicalProfileXtrands XTR
	ON XTR.TechnicalProfileID = tp.TechnicalProfileID
LEFT JOIN dbo.lkpHairStrandGroup HSG
	ON HSG.HairStrandGroupID = XTR.HairStrandGroupID
LEFT JOIN dbo.cfgSalesCode XTRShampoo
	ON XTRShampoo.SalesCodeID = XTR.ShampooSalesCodeID
LEFT JOIN dbo.cfgSalesCode XtrConditioner
	ON XtrConditioner.SalesCodeID = XTR.ConditionerSalesCodeID
LEFT JOIN dbo.cfgSalesCode XtrLaserDevice
	ON XtrLaserDevice.SalesCodeID = XTR.LaserDeviceSalesCodeID
LEFT JOIN lkpHairHealth XTRHairHealth
	ON XTRHairHealth.HairHealthID = XTR.HairHealthID
LEFT JOIN dbo.cfgSalesCode XTRMinoxidil
	ON XTRMinoxidil.SalesCodeID = XTR.MinoxidilSalesCodeID


/******************* Appointment Notes **************************************************************/

LEFT OUTER JOIN datNotesClient nc
	ON ap.AppointmentGUID = nc.AppointmentGUID
CROSS APPLY (SELECT ', ' + DN.NotesClient
			FROM datNotesClient AS DN
			WHERE NC.ClientGUID = DN.ClientGUID
			AND NC.AppointmentGUID = DN.AppointmentGUID
			ORDER BY DN.NotesClientDate
			FOR XML PATH('') ) AS P (Notes)


/******************* XTR Styling Products ************************************************************/

CROSS APPLY (SELECT ', ' + StylingProduct.SalesCodeDescription
			FROM dbo.datTechnicalProfileStylingProduct STYLE
			LEFT JOIN dbo.cfgSalesCode StylingProduct
				ON StylingProduct.SalesCodeID = STYLE.SalesCodeID
			WHERE XTR.TechnicalProfileID = STYLE.TechnicalProfileID
						FOR XML PATH('') ) AS R (XTRStylingProducts)

/******************* XTR+ Scalp Preparations ************************************************************/

CROSS APPLY (SELECT ', ' + SP.ScalpPreparationDescription
			FROM [dbo].[datTechnicalProfileScalpPreparation] TPSP
			LEFT JOIN [dbo].[lkpScalpPreparation] SP
				ON TPSP.ScalpPreparationID = SP.ScalpPreparationID
			WHERE TP.TechnicalProfileID = TPSP.TechnicalProfileID
						FOR XML PATH('') ) AS S (ScalpPreparation)


/******************* XTR Area of Concern ************************************************************/

CROSS APPLY (SELECT ', ' + AOCRegion.ScalpRegionDescription
			FROM dbo.datTechnicalProfileAreaOfConcern AOC
			LEFT JOIN dbo.lkpScalpRegion AOCRegion
				ON AOCRegion.ScalpRegionID = AOC.ScalpRegionID
			WHERE XTR.TechnicalProfileID = AOC.TechnicalProfileID
						FOR XML PATH('') ) AS U (XTRAreaOfConcern)


/******************* XTR StrandBuilderColorDescription **********************************************/

CROSS APPLY (SELECT ', ' + SBC.StrandBuilderColorDescription
			FROM dbo.datTechnicalProfileStrandBuilderColor COLOR
			LEFT JOIN dbo.lkpStrandBuilderColor SBC
				ON SBC.StrandBuilderColorID = COLOR.StrandBuilderColorID
			WHERE XTR.TechnicalProfileID = COLOR.TechnicalProfileID
						FOR XML PATH('') ) AS W (XTRStrandBuilderColorDescription)

/******************* XTR StrandBuilderColorDescription **********************************************/

CROSS APPLY (SELECT ', ' + HairStrand.HairStrandColorDescription
			FROM dbo.datTechnicalProfileHairStrandColor TPHSC
			LEFT JOIN dbo.lkpHairStrandColor HairStrand
				ON TPHSC.HairStrandColorID = HairStrand.HairStrandColorID
			WHERE XTR.TechnicalProfileID = TPHSC.TechnicalProfileID
						FOR XML PATH('') ) AS X (XTRHairStrandColorDescription)

/******************* XTR PlacementScalpRegionDescription **********************************************/

CROSS APPLY (SELECT ', ' + SR.ScalpRegionDescription
			FROM dbo.datTechnicalProfilePlacement TPP
			LEFT JOIN dbo.lkpScalpRegion SR
				ON	SR.ScalpRegionID = TPP.ScalpRegionID
			WHERE XTR.TechnicalProfileID = TPP.TechnicalProfileID
						FOR XML PATH('') ) AS Y (XTRPlacementScalpRegionDescription)



WHERE ap.CenterID = @CenterID
	AND ap.AppointmentDate BETWEEN @StartDate AND @EndDate
	AND (sty.EmployeeGUID = @StylistGUID OR @StylistGUID IS NULL)
	AND (cl.ClientGUID = @ClientGUID OR @ClientGUID IS NULL)
	AND ISNULL(ap.IsDeletedFlag,0) = 0
	AND M.BusinessSegmentID = 6
GROUP BY ap.AppointmentGUID
	,	ap.ClientGUID
	,	cl.ClientFullNameCalc
	,	cl.ARBalance
	,	sty.EmployeeFullNameCalc
	,	sty.EmployeeGUID
	,	ce.CenterDescriptionFullCalc
	,	ce.CenterID
	,	cCenter.CenterDescriptionFullCalc
	,	m.MembershipDescription
	,	M.BusinessSegmentID
	,	stat.ClientMembershipStatusDescription
	,	cm.EndDate

	,	ap.AppointmentDate
	,	ap.StartTime
	,	ap.EndTime
	,	ap.AppointmentDurationCalc



	--COLOR
	,	cb.ColorBrandDescription
	,	TPC.ColorFormula1
	,	TPC.ColorFormula2
	,	TPC.ColorFormula3
	,	TPC.ColorProcessingTime
	,	cfs1.ColorFormulaSizeDescription
	,	cfs2.ColorFormulaSizeDescription
	,	cfs3.ColorFormulaSizeDescription
	,	ds.DeveloperSizeDescription
	,	dv.DeveloperVolumeDescription



	--Multi item lists

	,	STUFF(R.XTRStylingProducts ,1 ,1 ,'')
	,	STUFF(U.XTRAreaOfConcern, 1, 1, '')
	,	STUFF(W.XTRStrandBuilderColorDescription, 1, 1, '')
	,	STUFF(X.XTRHairStrandColorDescription, 1, 1, '')
	,	STUFF(Y.XTRPlacementScalpRegionDescription, 1, 1, '')

	-- Technical Profile Notes
	,	tp.[Notes]
	,	CAST(tp.TechnicalProfileDate AS DATE)



	--XTRANDS fields
	,	XTR.LastTrichoViewDate
	,	XTR.LastTrichoViewDate
	,	XTR.LastXtrandsServiceDate
	,	HSG.HairStrandGroupDescription
	,	XTRShampoo.SalesCodeDescription
	,	XtrConditioner.SalesCodeDescription
	,	XtrLaserDevice.SalesCodeDescription
	,	XTRHairHealth.HairHealthDescription
	,	XTR.ServiceDuration
	,	XTRMinoxidil.SalesCodeDescription
	,	XTR.Other
	,	XTR.Strands

END
