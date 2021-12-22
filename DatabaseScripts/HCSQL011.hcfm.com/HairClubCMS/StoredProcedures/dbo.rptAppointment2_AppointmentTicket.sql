/* CreateDate: 03/02/2017 16:50:04.267 , ModifyDate: 03/15/2017 15:35:21.287 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
 Procedure Name:            rptAppointment2_AppointmentTicket
 Procedure Description:
 Created By:                Hdu
 Implemented By:            Hdu
 Date Created:              11/15/2012
 Destination Server:        HairclubCMS
 Related Application:       Hairclub CMS
================================================================================================
**NOTES**
Not to be confused with the rptAppointment this one is for the stylist appoinment printout

02/21/13	MLM		Filter Deleted Appointments.  Only show NON-Deleted Appointments
03/07/13	MLM		Use CenterID on Appointment to filter appointments
03/07/13	MLM		Modified to used the Accumulators for Last Used Dates
03/11/13	MLM		Changed the Used New Function to the Last Used
03/15/13	MLM		Return ClientHomeCenterDescriptionFullCalc in addition to Appointment Center
03/28/13	MLM		Added ClientGUID parameter.
06/13/13	MLM		Added TechnicalNotes to the Results
11/25/13	RMH		Added TechnicalProfileDate and HairSystemDescriptionShort to the Results.
11/26/2013	RMH		Added ISNULL(CAST(tp.LastTemplateDate AS DATE),CAST(tp.TechnicalProfileDate AS DATE)) AS LastTemplateDate
12/02/2013	RMH		Edited the function [fn_GetClientAccumLastUsedDate] to find the maximium Accumulator Date for all memberships.
12/06/2013	RMH		Added hs.HairSystemDescriptionShort AS 'SystemType'and SP.ScalpPreparationDescription AS 'ScalpPreparation'
12/11/2013	RMH		Added variable @ScalpPreparationDescriptions to find a comma-separated list of Scalp Preparations.
12/20/2013	RMH		Added ORDER BY sty.EmployeeFullNameCalc, ap.StartTime
5/30/2014	RMH		Added new accumulator Last Service Date for any service.
06/17/2014	RMH		Added cfs1.ColorFormulaSizeDescription, cfs2.ColorFormulaSizeDescription, cfs3.ColorFormulaSizeDescription,
						ds.DeveloperSizeDescription, dv.DeveloperVolumeDescription.
01/13/2015	RMH		Added ClientMembershipStatusDescription
10/07/2015	RMH		(#119280) Added HCSL accumulators for "Hair Care and Styling Lesson"
02/22/2016  RMH		(#122767) Added joins to lkpPermOwnHairRods for Perm Rod Color 1 and 2
08/10/2016  RMH		(#128930) Added a CROSS APPLY statement to join multiple appointment notes
02/07/2017	RMH		(#134857) Altered fields for the Technical Profile for additional EXT and Xtrands versions\
02/22/2017	RMH		(#134857) Added LastTrimDate, several multi-items, EXT and XTR Service Duration; Added S & S accumulator information
03/02/2017  RMH		(#134857) Created this version as rptAppointment2_AppointmentTicket
================================================================================================
SAMPLE EXECUTION:

EXEC rptAppointment2_AppointmentTicket 232,'01/06/2017','01/08/2017','549E4F5D-4985-4F13-A5D8-1989CFDEC840','4C6E44A3-3688-4787-8EC2-D12D30B9F174'
EXEC rptAppointment2_AppointmentTicket 270,'03/15/2017','03/15/2017',NULL,NULL
EXEC rptAppointment2_AppointmentTicket 240,'02/28/2017','02/28/2017',NULL, '6C6EEF10-7601-415F-97CB-A4DBBC834912' --Vemireddy, Avinash (540849) 240 --Nolden, Heather EXT
EXEC rptAppointment2_AppointmentTicket 240,'02/28/2017','02/28/2017',NULL, 'F3E3DA71-7AAA-4D0A-BC9D-09B8E812E2E9' --Charpenter, Claudette (539335) 240 --Nolden, Heather XTR
EXEC rptAppointment2_AppointmentTicket 201,'1/19/2017','1/19/2017','6C43ABEF-96FE-42DA-A7D7-D58709E1109C',NULL

EXEC rptAppointment2_AppointmentTicket 201,'12/14/2016','12/14/2016',NULL,'6477A897-9050-47A6-B8C2-C9A71E9F12F5'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptAppointment2_AppointmentTicket]
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

	,	ahs.TotalAccumQuantity HairSystemTotal
	,	ahs.UsedAccumQuantity HairSystemUsed
	,	ahs.AccumQuantityRemainingCalc HairSystemRemaining
	,	dbo.[fn_GetClientAccumLastUsedDate](ap.ClientGUID, 13)   HairSystemDate

	,	asv.TotalAccumQuantity ServicesTotal
	,	asv.UsedAccumQuantity ServicesUsed
	,	asv.AccumQuantityRemainingCalc ServicesRemaining
	,	dbo.[fn_GetClientAccumLastUsedDate](ap.ClientGUID, 16)  ServicesDate
	,	dbo.[fn_GetClientAccumLastUsedDate](ap.ClientGUID, 39)  LastAnySvc

	,	asl.TotalAccumQuantity SolutionsTotal
	,	asl.UsedAccumQuantity SolutionsUsed
	,	asl.AccumQuantityRemainingCalc SolutionsRemaining
	,	dbo.[fn_GetClientAccumLastUsedDate](ap.ClientGUID, 36)  SolutionsDate

	,	apk.TotalAccumQuantity ProdKitTotal
	,	apk.UsedAccumQuantity ProdKitUsed
	,	apk.AccumQuantityRemainingCalc ProdKitRemaining
	,	dbo.[fn_GetClientAccumLastUsedDate](ap.ClientGUID, 37)  ProdKitDate

	,	hcsl.TotalAccumQuantity HCSLTotal
	,	hcsl.UsedAccumQuantity HCSLUsed
	,	hcsl.AccumQuantityRemainingCalc HCSLRemaining
	,	dbo.[fn_GetClientAccumLastUsedDate](ap.ClientGUID, 41)  HCSLDate

	,	MAX(sns.TotalAccumQuantity) SNSTotal
	,	MAX(sns.UsedAccumQuantity) SNSUsed
	,	MIN(sns.AccumQuantityRemainingCalc) SNSRemaining
	,	dbo.[fn_GetClientAccumLastUsedDate](ap.ClientGUID, 42)  SNSDate


	--RELAXER
	,	rb.RelaxerBrandDescription
	,	rs.RelaxerStrengthDescription
	,	TPPR.RelaxerProcessingTime

	,	rp.RemovalProcessDescription
	,	ads.AdhesiveSolventDescription

	,	CASE TPB.IsClientUsingOwnHairline WHEN 1 THEN 'Yes' ELSE 'No' END AS OwnHair

	,	TPB.LastTrimDate

	,	TPB.DistanceHairlineToNose BridgeToHairline
	,	adf1.AdhesiveFrontDescription AdhesiveFront1
	,	adf2.AdhesiveFrontDescription AdhesiveFront2
	,	adp1.AdhesivePerimeterDescription AdhesivePerim1
	,	adp2.AdhesivePerimeterDescription AdhesivePerim2
	,	adp3.AdhesivePerimeterDescription AdhesivePerim3
	,	TPB.ApplicationDuration
	,	TPB.FullServiceDuration
	,	TPB.OtherServiceDuration

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

	--PERM
	,	pb.PermBrandDescription
	,	own.PermOwnHairRodsDescription AS 'PermRodColor1'
	,	own2.PermOwnHairRodsDescription AS 'PermRodColor2'
	,	ptq.PermTechniqueDescription
	,	ISNULL(TPPR.PermSystemProcessingTime,TPPR.PermOwnProcessingTime) AS 'PermProcessingTime'

	--Previous Appointment
	,	[dbo].[fn_GetPreviousAppointmentDate] (ap.ClientMembershipGUID) LastAppointmentDate

	--Appointment Notes
	,	STUFF(P.Notes, 1, 1, '') AS 'NotesClient'


	-- Technical Profile Notes
	,	tp.[Notes] as TechnicalNotes
	,	CAST(tp.TechnicalProfileDate AS DATE) AS 'TechnicalProfileDate'

	--HairSystem
	,	hs.HairSystemDescriptionShort AS 'SystemType'
	,	hs.HairSystemDescription AS HairSystemDescription
	,	ISNULL(CAST(TPB.LastTemplateDate AS DATE),CAST(tp.TechnicalProfileDate AS DATE)) AS 'LastTemplateDate'
	,	TP.TechnicalProfileID

	--ScalpPreparation
	,	STUFF(S.ScalpPreparation, 1, 1, '') AS 'ScalpPreparation'

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
		ON sns.ClientMembershipGUID = cm.ClientMembershipGUID AND sns.AccumulatorID = 42 --S & S
	LEFT JOIN (
			SELECT *
			,ROW_NUMBER() OVER(PARTITION BY ClientGUID ORDER BY TechnicalProfileDate DESC) TPRANK
			FROM datTechnicalProfile
			) tp
				ON tp.ClientGUID = ap.ClientGUID AND TPRANK = 1
	LEFT JOIN dbo.datTechnicalProfileBio TPB					---insert new table
		ON tp.TechnicalProfileID = TPB.TechnicalProfileID

	LEFT JOIN lkpAdhesiveFront adf1
		ON adf1.AdhesiveFrontID = TPB.AdhesiveFront1ID
	LEFT JOIN lkpAdhesiveFront adf2
		ON adf2.AdhesiveFrontID = TPB.AdhesiveFront2ID
	LEFT JOIN lkpAdhesivePerimeter adp1
		ON adp1.AdhesivePerimeterID = TPB.AdhesivePerimeter1ID
	LEFT JOIN lkpAdhesivePerimeter adp2
		ON adp2.AdhesivePerimeterID = TPB.AdhesivePerimeter2ID
	LEFT JOIN lkpAdhesivePerimeter adp3
		ON adp3.AdhesivePerimeterID = TPB.AdhesivePerimeter3ID

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
	LEFT JOIN lkpPermBrand pb
		ON pb.PermBrandID = ISNULL(TPPR.PermOwnPermBrandID,TPPR.PermSystemPermBrandID)

	/**************** add these two "tables" (#122767)************************************************/

	LEFT JOIN lkpPermOwnHairRods own
		ON (own.PermOwnHairRodsID = TPPR.PermSystemPermOwnHairRods1ID OR own.PermOwnHairRodsID = TPPR.PermOwnPermOwnHairRods1ID)
	LEFT JOIN lkpPermOwnHairRods own2
		ON (own2.PermOwnHairRodsID = TPPR.PermSystemPermOwnHairRods2ID OR own2.PermOwnHairRodsID = TPPR.PermOwnPermOwnHairRods2ID)

	LEFT JOIN lkpPermTechnique ptq
		ON (ptq.PermTechniqueID = TPPR.PermOwnPermTechniqueID OR ptq.PermTechniqueID = TPPR.PermSystemPermTechniqueID)



/******************* Appointment Notes **************************************************************/

LEFT OUTER JOIN datNotesClient nc
	ON ap.AppointmentGUID = nc.AppointmentGUID
CROSS APPLY (SELECT ', ' + DN.NotesClient
			FROM datNotesClient AS DN
			WHERE NC.ClientGUID = DN.ClientGUID
			AND NC.AppointmentGUID = DN.AppointmentGUID
			ORDER BY DN.NotesClientDate
			FOR XML PATH('') ) AS P (Notes)

/******************* XTR+ Scalp Preparations ************************************************************/

CROSS APPLY (SELECT ', ' + SP.ScalpPreparationDescription
			FROM [dbo].[datTechnicalProfileScalpPreparation] TPSP
			LEFT JOIN [dbo].[lkpScalpPreparation] SP
				ON TPSP.ScalpPreparationID = SP.ScalpPreparationID
			WHERE TP.TechnicalProfileID = TPSP.TechnicalProfileID
						FOR XML PATH('') ) AS S (ScalpPreparation)


WHERE ap.CenterID = @CenterID
	AND ap.AppointmentDate BETWEEN @StartDate AND @EndDate
	AND (sty.EmployeeGUID = @StylistGUID OR @StylistGUID IS NULL)
	AND (cl.ClientGUID = @ClientGUID OR @ClientGUID IS NULL)
	AND ISNULL(ap.IsDeletedFlag,0) = 0

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

	,	ahs.TotalAccumQuantity
	,	ahs.UsedAccumQuantity
	,	ahs.AccumQuantityRemainingCalc

	,	asv.TotalAccumQuantity
	,	asv.UsedAccumQuantity
	,	asv.AccumQuantityRemainingCalc

	,	asl.TotalAccumQuantity
	,	asl.UsedAccumQuantity
	,	asl.AccumQuantityRemainingCalc

	,	apk.TotalAccumQuantity
	,	apk.UsedAccumQuantity
	,	apk.AccumQuantityRemainingCalc

	,	hcsl.TotalAccumQuantity
	,	hcsl.UsedAccumQuantity
	,	hcsl.AccumQuantityRemainingCalc

	--,	sns.TotalAccumQuantity  --Find MAX or MIN
	--,	sns.UsedAccumQuantity
	--,	sns.AccumQuantityRemainingCalc

	--RELAXER
	,	rb.RelaxerBrandDescription
	,	rs.RelaxerStrengthDescription
	,	TPPR.RelaxerProcessingTime

	,	rp.RemovalProcessDescription
	,	ads.AdhesiveSolventDescription

	--Multi item lists
	,	STUFF(P.Notes ,1 ,1 ,'')
	,	STUFF(S.ScalpPreparation, 1, 1, '')

	,	CASE TPB.IsClientUsingOwnHairline WHEN 1 THEN 'Yes' ELSE 'No' END
	,	TPB.LastTrimDate
	,	TPB.DistanceHairlineToNose
	,	adf1.AdhesiveFrontDescription
	,	adf2.AdhesiveFrontDescription
	,	adp1.AdhesivePerimeterDescription
	,	adp2.AdhesivePerimeterDescription
	,	adp3.AdhesivePerimeterDescription
	,	TPB.ApplicationDuration
	,	TPB.FullServiceDuration
	,	TPB.OtherServiceDuration

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

	--PERM
	,	pb.PermBrandDescription
	,	own.PermOwnHairRodsDescription
	,	own2.PermOwnHairRodsDescription
	,	ptq.PermTechniqueDescription
	,	ISNULL(TPPR.PermSystemProcessingTime,TPPR.PermOwnProcessingTime)


	--Previous Appointment
	,	ap.ClientMembershipGUID

	--Appointment Notes and Multi item lists
	,	STUFF(P.Notes ,1 ,1 ,'')
	,	STUFF(S.ScalpPreparation, 1, 1, '')


	-- Technical Profile Notes
	,	tp.[Notes]
	,	CAST(tp.TechnicalProfileDate AS DATE)

	--HairSystem
	,	hs.HairSystemDescriptionShort
	,	hs.HairSystemDescription
	,	ISNULL(CAST(TPB.LastTemplateDate AS DATE),CAST(tp.TechnicalProfileDate AS DATE))
	,	TP.TechnicalProfileID

END
GO
