/* CreateDate: 03/02/2017 15:45:37.320 , ModifyDate: 06/26/2017 07:54:19.170 */
GO
/*===============================================================================================
 Procedure Name:            [rptAppointment2_EXT]
 Procedure Description:
 Created By:                Hdu
 Implemented By:            Hdu
 Date Created:              11/15/2012
 Destination Server:        HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
CHANGE HISTORY:
05/30/2017 - RH - (#139634) Added EXT.IsSurgeryClient, EXT.LastSurgeryDate and EXT.GraftCount
06/26/2017 - RH - Added (SH.ScalpHealthDescriptionShort + ' - ' + SH.ScalpHealthDescription) AS 'ScalpHealthDescription'
================================================================================================
SAMPLE EXECUTION:

EXEC [rptAppointment2_EXT]  240,'02/28/2017','02/28/2017',NULL, '6C6EEF10-7601-415F-97CB-A4DBBC834912' --Vemireddy, Avinash (540849) 240 --Nolden, Heather EXT

================================================================================================*/

CREATE PROCEDURE [dbo].[rptAppointment2_EXT]
	@CenterID INT
	,	@StartDate DATETIME
	,	@EndDate DATETIME
	,	@StylistGUID UNIQUEIDENTIFIER = NULL
	,	@ClientGUID UNIQUEIDENTIFIER = NULL

AS
BEGIN

	SET @EndDate = @EndDate + '23:59:00'



/***************************Main Select Statement******************************************************************/
SELECT
	ap.AppointmentGUID
	,	ap.ClientGUID
	,	cl.ClientFullNameCalc Client
	,	sty.EmployeeFullNameCalc Stylist
	,	sty.EmployeeGUID AS 'StylistGUID'
	,	ce.CenterDescriptionFullCalc
	,	ce.CenterID
	,	m.MembershipDescription
	,	M.BusinessSegmentID
	,	cm.EndDate

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

	--Appointment Notes
	,	STUFF(P.Notes, 1, 1, '') AS 'NotesClient'
	--EXTStylingProductDescription
	,	STUFF(Q.EXTStylingProducts, 1, 1, '') AS 'EXTStylingProducts'
	--ScalpPreparation
	,	STUFF(S.ScalpPreparation, 1, 1, '') AS 'ScalpPreparation'
	--EXTAreaOfConcern
	,	STUFF(T.EXTAreaOfConcern, 1, 1, '') AS 'EXTAreaOfConcern'
	--EXTStrandBuilderColorDescription
	,	STUFF(V.EXTStrandBuilderColorDescription, 1, 1, '') AS 'EXTStrandBuilderColorDescription'

	-- Technical Profile Notes
	,	tp.[Notes] as TechnicalNotes


	--EXT fields
	,	EXT.LastTrichoViewDate AS 'LastTrichoViewDate'
	,	EXT.LastExtServiceDate
	,	HairHealth.HairHealthDescription
	,	(SH.ScalpHealthDescriptionShort + ' - ' + SH.ScalpHealthDescription) AS 'ScalpHealthDescription'
	,	CleanserUsed.SalesCodeDescription AS 'CleanserUsedDescription'
	,	EXT.ElixirFormulation
	,	MP.MassagePressureDescription
	,	EXTCleanser.SalesCodeDescription AS 'EXTCleanserDescription'
	,	EXTConditioner.SalesCodeDescription AS 'ConditionerDescription'
	,	EXTMinoxidil.SalesCodeDescription AS 'EXTMinoxidilDescription'
	,	EXTLaserDevice.SalesCodeDescription AS 'EXTLaserDeviceDescription'
	,	EXT.ServiceDuration AS 'EXTServiceDuration'
	,	CASE WHEN EXT.IsScalpEnzymeCleanserUsed = 1 THEN 'Yes' ELSE 'No' END AS 'EXTIsScalpEnzymeCleanserUsed'
	,	EXT.Other AS 'EXTOther'

	--Surgery fields
	,	EXT.IsSurgeryClient
	,	EXT.LastSurgeryDate
	,	EXT.GraftCount



FROM dbo.datAppointment ap
	INNER JOIN dbo.datAppointmentEmployee ae
		ON ae.AppointmentGUID = ap.AppointmentGUID
	INNER JOIN datEmployee sty
		ON sty.EmployeeGUID = ae.EmployeeGUID
	INNER JOIN datClient cl
		ON cl.ClientGUID = ap.ClientGUID
	INNER JOIN cfgCenter ce
		ON ce.CenterID = ap.CenterID
	INNER JOIN datClientMembership cm
		ON cm.ClientMembershipGUID = ap.ClientMembershipGUID
	INNER JOIN cfgMembership m
		ON m.MembershipID = cm.MembershipID
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

/**************** EXT Tables *************************************************************************/

LEFT JOIN dbo.datTechnicalProfileExt EXT
	ON EXT.TechnicalProfileID = tp.TechnicalProfileID
LEFT JOIN dbo.lkpHairHealth HairHealth
	ON	HairHealth.HairHealthID = EXT.HairHealthID
LEFT JOIN lkpScalpHealth SH
	ON SH.ScalpHealthID = EXT.ScalpHealthID
LEFT JOIN cfgSalesCode CleanserUsed
	ON CleanserUsed.SalesCodeID = EXT.CleanserUsedSalesCodeID
LEFT JOIN dbo.lkpMassagePressure MP
	ON MP.MassagePressureID = EXT.MassagePressureID
LEFT JOIN dbo.cfgSalesCode EXTCleanser
	ON EXTCleanser.SalesCodeID = EXT.CleanserSalesCodeID
LEFT JOIN dbo.cfgSalesCode EXTConditioner
	ON EXTConditioner.SalesCodeID = EXT.ConditionerSalesCodeID
LEFT JOIN dbo.cfgSalesCode EXTMinoxidil
	ON EXTMinoxidil.SalesCodeID = EXT.MinoxidilSalesCodeID
LEFT JOIN dbo.cfgSalesCode EXTLaserDevice
	ON EXTLaserDevice.SalesCodeID = EXT.LaserDeviceSalesCodeID


/******************* Appointment Notes **************************************************************/

LEFT OUTER JOIN datNotesClient nc
	ON ap.AppointmentGUID = nc.AppointmentGUID
CROSS APPLY (SELECT ', ' + DN.NotesClient
			FROM datNotesClient AS DN
			WHERE NC.ClientGUID = DN.ClientGUID
			AND NC.AppointmentGUID = DN.AppointmentGUID
			ORDER BY DN.NotesClientDate
			FOR XML PATH('') ) AS P (Notes)

/******************* EXT Styling Products ************************************************************/

CROSS APPLY (SELECT ', ' + StylingProduct.SalesCodeDescription
			FROM dbo.datTechnicalProfileStylingProduct STYLE
			LEFT JOIN dbo.cfgSalesCode StylingProduct
				ON StylingProduct.SalesCodeID = STYLE.SalesCodeID
			WHERE EXT.TechnicalProfileID = STYLE.TechnicalProfileID
						FOR XML PATH('') ) AS Q (EXTStylingProducts)

/******************* Scalp Preparation **************************************************************/

CROSS APPLY (SELECT ', ' + SP.ScalpPreparationDescription
			FROM [dbo].[datTechnicalProfileScalpPreparation] TPSP
			LEFT JOIN [dbo].[lkpScalpPreparation] SP
				ON TPSP.ScalpPreparationID = SP.ScalpPreparationID
			WHERE TP.TechnicalProfileID = TPSP.TechnicalProfileID
						FOR XML PATH('') ) AS S (ScalpPreparation)


/******************* EXT Area of Concern ************************************************************/

CROSS APPLY (SELECT ', ' + AOCRegion.ScalpRegionDescription
			FROM dbo.datTechnicalProfileAreaOfConcern AOC
			LEFT JOIN dbo.lkpScalpRegion AOCRegion
				ON AOCRegion.ScalpRegionID = AOC.ScalpRegionID
			WHERE EXT.TechnicalProfileID = AOC.TechnicalProfileID
						FOR XML PATH('') ) AS T (EXTAreaOfConcern)


/******************* EXT StrandBuilderColorDescription **********************************************/

CROSS APPLY (SELECT ', ' + SBC.StrandBuilderColorDescription
			FROM dbo.datTechnicalProfileStrandBuilderColor COLOR
			LEFT JOIN dbo.lkpStrandBuilderColor SBC
				ON SBC.StrandBuilderColorID = COLOR.StrandBuilderColorID
			WHERE EXT.TechnicalProfileID = COLOR.TechnicalProfileID
						FOR XML PATH('') ) AS V (EXTStrandBuilderColorDescription)



WHERE ap.CenterID = @CenterID
	AND ap.AppointmentDate BETWEEN @StartDate AND @EndDate
	AND (sty.EmployeeGUID = @StylistGUID OR @StylistGUID IS NULL)
	AND (cl.ClientGUID = @ClientGUID OR @ClientGUID IS NULL)
	AND ISNULL(ap.IsDeletedFlag,0) = 0
	AND M.BusinessSegmentID = 2
GROUP BY ap.AppointmentGUID
	,	ap.ClientGUID
	,	cl.ClientFullNameCalc
	,	sty.EmployeeFullNameCalc
	,	sty.EmployeeGUID
	,	ce.CenterDescriptionFullCalc
	,	ce.CenterID
	,	m.MembershipDescription
	,	M.BusinessSegmentID
	,	ap.ClientMembershipGUID
	,	cm.EndDate

	,	ap.AppointmentDate
	,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7))
	,	ap.StartTime
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


	--Appointment Notes
	,	STUFF(P.Notes, 1, 1, '')
	--EXTStylingProductDescription
	,	STUFF(Q.EXTStylingProducts, 1, 1, '')
	--ScalpPreparation
	,	STUFF(S.ScalpPreparation, 1, 1, '')
	--EXTAreaOfConcern
	,	STUFF(T.EXTAreaOfConcern, 1, 1, '')
	--EXTStrandBuilderColorDescription
	,	STUFF(V.EXTStrandBuilderColorDescription, 1, 1, '')


	-- Technical Profile Notes
	,	tp.[Notes]

	--EXT fields
	,	EXT.LastTrichoViewDate
	,	EXT.LastExtServiceDate
	,	HairHealth.HairHealthDescription
	,	SH.ScalpHealthDescription
	,	SH.ScalpHealthDescriptionShort
	,	CleanserUsed.SalesCodeDescription
	,	EXT.ElixirFormulation
	,	MP.MassagePressureDescription
	,	EXTCleanser.SalesCodeDescription
	,	EXTConditioner.SalesCodeDescription
	,	EXTMinoxidil.SalesCodeDescription
	,	EXTLaserDevice.SalesCodeDescription
	,	EXT.ServiceDuration
	,	EXT.Other
	,	EXT.IsScalpEnzymeCleanserUsed

	--Surgery fields
	,	EXT.IsSurgeryClient
	,	EXT.LastSurgeryDate
	,	EXT.GraftCount

END
GO
