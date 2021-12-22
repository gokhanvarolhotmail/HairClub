/*===============================================================================================
 Procedure Name:            rptDailyStylistSchedule
 Procedure Description:

 Created By:                Hdu
 Implemented By:            Hdu
 Last Modified By:          RMH

 Date Created:              11/30/2012
 Date Implemented:
 Date Last Modified:        01/26/2015

 Destination Server:        HairclubCMS
 Destination Database:
 Related Application:       Hairclub CMS
================================================================================================
**NOTES**
	01/28/13	MLM		Fixed the StylistGUID Parameter.
	02/21/13	MLM		Filter Deleted Appointments.  Only show NON-Deleted Appointments
	03/07/13	MLM		Use CenterID on Appointment to filter appointments
	03/24/13	MLM		Added EFT Status to Results
	12/01/13	RMH		Added @EndDate and @ServiceType as parameters; If statement for @ServiceType = Applications Only
						or @ServiceType = All.
	12/19/2013	RMH		Changed the where clause to: "AND SalesCodeDescriptionShort IN('APP','NB1A')" to include Initial Applications also.
	06/20/2014	RMH		(#102601) Changed the @ServiceType to a multi-select with additional service types.
	01/14/2015	RMH		(#107326) Changed to pull the client membership from datClient
	01/26/2015	RMH		(#111071) Changed to pull the client membership from the appointment to match the Appointment2.rdl
	10/07/2015	RMH		(#119280) Added HCSL accumulators for "Hair Care and Styling Lesson"
	10/07/2015	RMH		(#121292) Added "Hair Care and Styling Lesson" to the drop-down in the report
	09/26/2016	RMH		(#127006) Changed EmployeeFullNameCalc to (FirstName and LastName) so the report could be ordered by the FirstName
	10/28/2016	RMH		(#129711) Added Suggested HSO to application services; Added temp table #Daily; Added sc.SalesCodeDepartmentID BETWEEN 5010 AND 5061
	03/06/2017	RMH		(#136471) Added S&S Remaining
	05/15/2017	RMH		(#95431)  Added Anniversary Date
	08/22/2017	RMH		(#142426) Added UCE NotesClient from datNotesClient
	01/18/2018  RMH		(#146636) Changed CenterID to CenterNumber for Colorado Springs


@ServiceType
	value	description
	389		Checkup - New Member
	647		Application
	648		Initial Application
	727		Checkup - 24 Hour
	728		Checkup - Pre Check
	849		Hair Care & Style Lesson – 24 Hour
	850		Hair Care & Style Lesson – 3 Day
	847		Hair Care & Style Lesson – New Member
	848		Hair Care & Style Lesson – Pre Conditioning

================================================================================================
Sample Execution:

EXEC rptDailyStylistSchedule 238, NULL,  '01/01/2018', '03/31/2018', '9999'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptDailyStylistSchedule]
	@CenterID INT
	,	@StylistGUID UNIQUEIDENTIFIER = NULL -- NULL All for center
	,	@StartDate DATETIME
	,	@EndDate DATETIME
	,	@ServiceType NVARCHAR(MAX)
AS
BEGIN

SELECT @EndDate = DATEADD(DAY,1, @EndDate)

/************** Create temp tables *********************************************************/

CREATE TABLE #service(SalesCodeID INT)


CREATE TABLE #Daily(AppointmentGUID UNIQUEIDENTIFIER
,	ClientGUID  UNIQUEIDENTIFIER
,	Client NVARCHAR(104)
,	EmployeeGUID UNIQUEIDENTIFIER
,	Stylist  NVARCHAR(104)
,	CenterDescriptionFullCalc NVARCHAR(50)
,	MembershipDescription NVARCHAR(50)
,	RenewalDate DATETIME
,	AnniversaryDate DATETIME
,	ApptDate DATETIME
,	ApptTime  NVARCHAR(50)
,	AppointmentDurationCalc INT
,	StartTime NVARCHAR(10)
,	EndTime  NVARCHAR(10)
,	SalesCodeDescription NVARCHAR(50)
,	AppointmentDetailDuration INT
,	AR MONEY
,	EFTAccountTypeDescription NVARCHAR(50)
,	EFTStatusDescription NVARCHAR(50)
,	HairSystemTotal INT
,	HairSystemUsed INT
,	HairSystemRemaining INT
,	HairSystemDate DATETIME
,	ServicesTotal INT
,	ServicesUsed INT
,	ServicesRemaining INT
,	ServicesDate DATETIME
,	SolutionsTotal INT
,	SolutionsUsed INT
,	SolutionsRemaining INT
,	SolutionsDate DATETIME
,	ProdKitTotal INT
,	ProdKitUsed INT
,	ProdKitRemaining INT
,	ProdKitDate DATETIME
,	HCSLTotal INT
,	HCSLUsed INT
,	HCSLRemaining INT
,	HCSLDate DATETIME
,	SNSRemaining INT
,	FeePayCycleDescription  NVARCHAR(50)
,	HairSystemOrderNumber  NVARCHAR(50)
,	UCENotesClient NVARCHAR(4000)
)

/************** Populate #service *********************************************************/

INSERT INTO #service
SELECT Item AS SalesCodeID
FROM dbo.fnSplit(@ServiceType,',')
ORDER BY SalesCodeID DESC  --Leave in this ORDER BY it is necessary for 9999 multi-selection

/************** Populate #Daily ***********************************************************/

IF(SELECT COUNT(SalesCodeID) FROM #service) = 1 AND (SELECT TOP 1 SalesCodeID FROM #service) = '9999'--ALL
BEGIN
INSERT INTO #Daily
SELECT
ap.AppointmentGUID
,	ap.ClientGUID
,	cl.ClientFullNameCalc Client
,	sty.EmployeeGUID
,	sty.FirstName + ' ' + sty.LastName Stylist
,	ce.CenterDescriptionFullCalc
,	m.MembershipDescription
,	cm.EndDate AS RenewalDate
,	cl.AnniversaryDate AS AnniversaryDate
,	ap.AppointmentDate ApptDate
	,LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) ApptTime
,	ap.AppointmentDurationCalc
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) as StartTime
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) as EndTime
,	sc.SalesCodeDescription
,	ad.AppointmentDetailDuration
,	cl.ARBalance AR
,	eftat.EFTAccountTypeDescription
,	eftstat.EFTStatusDescription
,	ahs.TotalAccumQuantity HairSystemTotal
,	ahs.UsedAccumQuantity HairSystemUsed
,	ahs.AccumQuantityRemainingCalc HairSystemRemaining
,	ahs.LastUpdate HairSystemDate
,	asv.TotalAccumQuantity ServicesTotal
,	asv.UsedAccumQuantity ServicesUsed
,	asv.AccumQuantityRemainingCalc ServicesRemaining
,	asv.LastUpdate ServicesDate
,	asl.TotalAccumQuantity SolutionsTotal
,	asl.UsedAccumQuantity SolutionsUsed
,	asl.AccumQuantityRemainingCalc SolutionsRemaining
,	asl.LastUpdate SolutionsDate
,	apk.TotalAccumQuantity ProdKitTotal
,	apk.UsedAccumQuantity ProdKitUsed
,	apk.AccumQuantityRemainingCalc ProdKitRemaining
,	apk.LastUpdate ProdKitDate
,	hcsl.TotalAccumQuantity HCSLTotal
,	hcsl.UsedAccumQuantity HCSLUsed
,	hcsl.AccumQuantityRemainingCalc HCSLRemaining
,	hcsl.LastUpdate HCSLDate
,	sns.AccumQuantityRemainingCalc SNSRemaining
,	fpc.FeePayCycleDescription
,	CASE WHEN sc.SalesCodeDescription LIKE '%App%' OR sc.SalesCodeDescription LIKE '%New%Style%' THEN q.HairSystemOrderNumber ELSE NULL END AS 'HairSystemOrderNumber'
,	r.NotesClient AS 'UCENotesClient'
FROM dbo.datAppointment ap
INNER JOIN dbo.datAppointmentDetail ad
	ON ad.AppointmentGUID = ap.AppointmentGUID
INNER JOIN cfgSalesCode sc
	ON sc.SalesCodeID = ad.SalesCodeID
INNER JOIN dbo.datAppointmentEmployee ae
	ON ae.AppointmentGUID = ap.AppointmentGUID
INNER JOIN datEmployee sty
	ON sty.EmployeeGUID = ae.EmployeeGUID
	AND ( sty.EmployeeGUID = @StylistGUID OR @StylistGUID IS NULL)
INNER JOIN datClient cl
	ON cl.ClientGUID = ap.ClientGUID
INNER JOIN cfgCenter ce
	ON ce.CenterID = ap.CenterID
LEFT JOIN datClientEFT ceft
	ON ceft.ClientGUID = cl.ClientGUID
LEFT JOIN lkpFeePayCycle fpc
	ON ceft.FeePayCycleID = fpc.FeePayCycleID
LEFT JOIN lkpEFTAccountType eftat
	ON eftat.EFTAccountTypeID = ceft.EFTAccountTypeID
LEFT JOIN lkpEFTStatus eftStat
	on ceft.EFTStatusID = eftStat.EFTStatusID
INNER JOIN datClientMembership cm   --(WO#111071) Changed to pull the client membership from the appointment to match the Appointment2.rdl RH - 1/26/2015
	ON cm.ClientMembershipGUID = ap.ClientMembershipGUID
INNER JOIN cfgMembership m
	ON m.MembershipID = cm.MembershipID
--Accumulators!
LEFT JOIN datClientMembershipAccum ahs
	ON ahs.ClientMembershipGUID = cm.ClientMembershipGUID AND ahs.AccumulatorID = 8 --Hair Systems --New Styles
LEFT JOIN datClientMembershipAccum asv
	ON asv.ClientMembershipGUID = cm.ClientMembershipGUID AND asv.AccumulatorID = 9 --Services  --Salon Visits
LEFT JOIN datClientMembershipAccum asl
	ON asl.ClientMembershipGUID = cm.ClientMembershipGUID AND asl.AccumulatorID = 10 --Solutions  --Chemical
LEFT JOIN datClientMembershipAccum apk
	ON apk.ClientMembershipGUID = cm.ClientMembershipGUID AND apk.AccumulatorID = 11 --Product Kits
LEFT JOIN datClientMembershipAccum hcsl
	ON hcsl.ClientMembershipGUID = cm.ClientMembershipGUID AND hcsl.AccumulatorID = 41 --Hair Care and Styling Lesson
LEFT JOIN datClientMembershipAccum sns
	ON sns.ClientMembershipGUID = cm.ClientMembershipGUID AND sns.AccumulatorID = 42 --S&S
--Find suggested HSO
LEFT JOIN (SELECT HSO.HairSystemOrderNumber, ClientGUID
			,	ROW_NUMBER()OVER(PARTITION BY HSO.ClientGUID ORDER BY HSO.HairSystemOrderDate ASC) AS 'Ranking'
			FROM dbo.datHairSystemOrder HSO
			WHERE HSO.HairSystemOrderStatusID = 4)q  --CENT  --In center
	ON 	ap.ClientGUID = q.ClientGUID AND q.Ranking = 1

--Find UCE Notes
LEFT JOIN (SELECT NC.NotesClient, ClientGUID
			,	ROW_NUMBER()OVER(PARTITION BY NC.ClientGUID ORDER BY NC.NotesClientDate DESC) AS 'Ranking'
			FROM dbo.datNotesClient NC
			WHERE NC.NoteTypeID = 13)r  --UCE Notes
	ON 	ap.ClientGUID = r.ClientGUID AND r.Ranking = 1
WHERE ap.AppointmentDate >= @StartDate
	AND ap.AppointmentDate < @EndDate
	AND ISNULL(ap.IsDeletedFlag, 0) = 0
	AND ce.CenterNumber = @CenterID
	AND sc.SalesCodeDepartmentID BETWEEN 5010 AND 5061
ORDER BY ap.AppointmentDate
,	ap.StartTime
,	ap.EndTime
,	sty.FirstName + ' ' + sty.LastName
END
ELSE
IF(SELECT COUNT(SalesCodeID) FROM #service) > 1 AND (SELECT TOP 1 SalesCodeID FROM #service) = '9999'--ALL
BEGIN
INSERT INTO #Daily
SELECT
ap.AppointmentGUID
,	ap.ClientGUID
,	cl.ClientFullNameCalc Client
,	sty.EmployeeGUID
,	sty.FirstName + ' ' + sty.LastName Stylist
,	ce.CenterDescriptionFullCalc
,	m.MembershipDescription
,	cm.EndDate AS RenewalDate
,	cl.AnniversaryDate AS AnniversaryDate
,	ap.AppointmentDate ApptDate
	,LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) ApptTime
,	ap.AppointmentDurationCalc
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) as StartTime
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) as EndTime
,	sc.SalesCodeDescription
,	ad.AppointmentDetailDuration
,	cl.ARBalance AR
,	eftat.EFTAccountTypeDescription
,	eftstat.EFTStatusDescription
,	ahs.TotalAccumQuantity HairSystemTotal
,	ahs.UsedAccumQuantity HairSystemUsed
,	ahs.AccumQuantityRemainingCalc HairSystemRemaining
,	ahs.LastUpdate HairSystemDate
,	asv.TotalAccumQuantity ServicesTotal
,	asv.UsedAccumQuantity ServicesUsed
,	asv.AccumQuantityRemainingCalc ServicesRemaining
,	asv.LastUpdate ServicesDate
,	asl.TotalAccumQuantity SolutionsTotal
,	asl.UsedAccumQuantity SolutionsUsed
,	asl.AccumQuantityRemainingCalc SolutionsRemaining
,	asl.LastUpdate SolutionsDate
,	apk.TotalAccumQuantity ProdKitTotal
,	apk.UsedAccumQuantity ProdKitUsed
,	apk.AccumQuantityRemainingCalc ProdKitRemaining
,	apk.LastUpdate ProdKitDate
,	hcsl.TotalAccumQuantity HCSLTotal
,	hcsl.UsedAccumQuantity HCSLUsed
,	ISNULL(hcsl.AccumQuantityRemainingCalc,0) HCSLRemaining
,	hcsl.LastUpdate HCSLDate
,	sns.AccumQuantityRemainingCalc SNSRemaining
,	fpc.FeePayCycleDescription
,	CASE WHEN sc.SalesCodeDescription LIKE '%App%' OR sc.SalesCodeDescription LIKE '%New%Style%' THEN q.HairSystemOrderNumber ELSE NULL END AS 'HairSystemOrderNumber'
,	r.NotesClient AS 'UCENotesClient'
FROM dbo.datAppointment ap
INNER JOIN dbo.datAppointmentDetail ad
	ON ad.AppointmentGUID = ap.AppointmentGUID
INNER JOIN cfgSalesCode sc
	ON sc.SalesCodeID = ad.SalesCodeID
INNER JOIN dbo.datAppointmentEmployee ae
	ON ae.AppointmentGUID = ap.AppointmentGUID
INNER JOIN datEmployee sty
	ON sty.EmployeeGUID = ae.EmployeeGUID
	AND ( sty.EmployeeGUID = @StylistGUID OR @StylistGUID IS NULL)
INNER JOIN datClient cl
	ON cl.ClientGUID = ap.ClientGUID
INNER JOIN cfgCenter ce
	ON ce.CenterID = ap.CenterID
LEFT JOIN datClientEFT ceft
	ON ceft.ClientGUID = cl.ClientGUID
LEFT JOIN lkpFeePayCycle fpc
	ON ceft.FeePayCycleID = fpc.FeePayCycleID
LEFT JOIN lkpEFTAccountType eftat
	ON eftat.EFTAccountTypeID = ceft.EFTAccountTypeID
LEFT JOIN lkpEFTStatus eftStat
	on ceft.EFTStatusID = eftStat.EFTStatusID
INNER JOIN datClientMembership cm   --(WO#111071) Changed to pull the client membership from the appointment to match the Appointment2.rdl RH - 1/26/2015
	ON cm.ClientMembershipGUID = ap.ClientMembershipGUID
INNER JOIN cfgMembership m
	ON m.MembershipID = cm.MembershipID
--Accumulators!
LEFT JOIN datClientMembershipAccum ahs
	ON ahs.ClientMembershipGUID = cm.ClientMembershipGUID AND ahs.AccumulatorID = 8 --Hair Systems --New Styles
LEFT JOIN datClientMembershipAccum asv
	ON asv.ClientMembershipGUID = cm.ClientMembershipGUID AND asv.AccumulatorID = 9 --Services  --Salon Visits
LEFT JOIN datClientMembershipAccum asl
	ON asl.ClientMembershipGUID = cm.ClientMembershipGUID AND asl.AccumulatorID = 10 --Solutions  --Chemical
LEFT JOIN datClientMembershipAccum apk
	ON apk.ClientMembershipGUID = cm.ClientMembershipGUID AND apk.AccumulatorID = 11 --Product Kits
LEFT JOIN datClientMembershipAccum hcsl
	ON hcsl.ClientMembershipGUID = cm.ClientMembershipGUID AND hcsl.AccumulatorID = 41 --Hair Care and Styling Lesson
LEFT JOIN datClientMembershipAccum sns
	ON sns.ClientMembershipGUID = cm.ClientMembershipGUID AND sns.AccumulatorID = 42 --S&S
--Find suggested HSO
LEFT JOIN (SELECT HSO.HairSystemOrderNumber, ClientGUID
			,	ROW_NUMBER()OVER(PARTITION BY HSO.ClientGUID ORDER BY HSO.HairSystemOrderDate ASC) AS 'Ranking'
			FROM dbo.datHairSystemOrder HSO
			WHERE HSO.HairSystemOrderStatusID = 4)q  --CENT  --In center
	ON 	ap.ClientGUID = q.ClientGUID AND q.Ranking = 1
--Find UCE Notes
LEFT JOIN (SELECT NC.NotesClient, ClientGUID
			,	ROW_NUMBER()OVER(PARTITION BY NC.ClientGUID ORDER BY NC.NotesClientDate DESC) AS 'Ranking'
			FROM dbo.datNotesClient NC
			WHERE NC.NoteTypeID = 13)r  --UCE Notes
	ON 	ap.ClientGUID = r.ClientGUID AND r.Ranking = 1
WHERE ap.AppointmentDate >= @StartDate
	AND ap.AppointmentDate < @EndDate
	AND ISNULL(ap.IsDeletedFlag, 0) = 0
	AND ce.CenterNumber = @CenterID
	AND sc.SalesCodeDepartmentID BETWEEN 5010 AND 5061
ORDER BY ap.AppointmentDate
,	ap.StartTime
,	ap.EndTime
,	sty.FirstName + ' ' + sty.LastName
END
ELSE
BEGIN
INSERT INTO #Daily
SELECT
ap.AppointmentGUID
,	ap.ClientGUID
,	cl.ClientFullNameCalc Client
,	sty.EmployeeGUID
,	sty.FirstName + ' ' + sty.LastName Stylist
,	ce.CenterDescriptionFullCalc
,	m.MembershipDescription
,	cm.EndDate AS RenewalDate
,	cl.AnniversaryDate AS AnniversaryDate
,	ap.AppointmentDate ApptDate
	,LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) + ' - ' + LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) ApptTime
,	ap.AppointmentDurationCalc
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.StartTime, 100), 7)) as StartTime
,	LTRIM(RIGHT(CONVERT(VARCHAR(25), ap.EndTime, 100), 7)) as EndTime
,	sc.SalesCodeDescription
,	ad.AppointmentDetailDuration
,	cl.ARBalance AR
,	eftat.EFTAccountTypeDescription
,	eftstat.EFTStatusDescription
,	ahs.TotalAccumQuantity HairSystemTotal
,	ahs.UsedAccumQuantity HairSystemUsed
,	ahs.AccumQuantityRemainingCalc HairSystemRemaining
,	ahs.LastUpdate HairSystemDate
,	asv.TotalAccumQuantity ServicesTotal
,	asv.UsedAccumQuantity ServicesUsed
,	asv.AccumQuantityRemainingCalc ServicesRemaining
,	asv.LastUpdate ServicesDate
,	asl.TotalAccumQuantity SolutionsTotal
,	asl.UsedAccumQuantity SolutionsUsed
,	asl.AccumQuantityRemainingCalc SolutionsRemaining
,	asl.LastUpdate SolutionsDate
,	apk.TotalAccumQuantity ProdKitTotal
,	apk.UsedAccumQuantity ProdKitUsed
,	apk.AccumQuantityRemainingCalc ProdKitRemaining
,	apk.LastUpdate ProdKitDate
,	hcsl.TotalAccumQuantity HCSLTotal
,	hcsl.UsedAccumQuantity HCSLUsed
,	ISNULL(hcsl.AccumQuantityRemainingCalc,0) HCSLRemaining
,	hcsl.LastUpdate HCSLDate
,	ISNULL(sns.AccumQuantityRemainingCalc,0) SNSRemaining
,	fpc.FeePayCycleDescription
,	CASE WHEN sc.SalesCodeDescription LIKE '%App%' OR sc.SalesCodeDescription LIKE '%New%Style%' THEN q.HairSystemOrderNumber ELSE NULL END AS 'HairSystemOrderNumber'
,	r.NotesClient AS 'UCENotesClient'
FROM dbo.datAppointment ap
INNER JOIN dbo.datAppointmentDetail ad
	ON ad.AppointmentGUID = ap.AppointmentGUID
INNER JOIN cfgSalesCode sc
	ON sc.SalesCodeID = ad.SalesCodeID
INNER JOIN dbo.datAppointmentEmployee ae
	ON ae.AppointmentGUID = ap.AppointmentGUID
INNER JOIN datEmployee sty
	ON sty.EmployeeGUID = ae.EmployeeGUID
	AND ( sty.EmployeeGUID = @StylistGUID OR @StylistGUID IS NULL)
INNER JOIN datClient cl
	ON cl.ClientGUID = ap.ClientGUID
INNER JOIN cfgCenter ce
	ON ce.CenterID = ap.CenterID
LEFT JOIN datClientEFT ceft
	ON ceft.ClientGUID = cl.ClientGUID
LEFT JOIN lkpFeePayCycle fpc
	ON ceft.FeePayCycleID = fpc.FeePayCycleID
LEFT JOIN lkpEFTAccountType eftat
	ON eftat.EFTAccountTypeID = ceft.EFTAccountTypeID
LEFT JOIN lkpEFTStatus eftStat
	on ceft.EFTStatusID = eftStat.EFTStatusID
INNER JOIN datClientMembership cm   --(WO#111071) Changed to pull the client membership from the appointment to match the Appointment2.rdl RH - 1/26/2015
	ON cm.ClientMembershipGUID = ap.ClientMembershipGUID
INNER JOIN cfgMembership m
	ON m.MembershipID = cm.MembershipID
--Accumulators!
LEFT JOIN datClientMembershipAccum ahs
	ON ahs.ClientMembershipGUID = cm.ClientMembershipGUID AND ahs.AccumulatorID = 8 --Hair Systems --New Styles
LEFT JOIN datClientMembershipAccum asv
	ON asv.ClientMembershipGUID = cm.ClientMembershipGUID AND asv.AccumulatorID = 9 --Services --Salon Visits
LEFT JOIN datClientMembershipAccum asl
	ON asl.ClientMembershipGUID = cm.ClientMembershipGUID AND asl.AccumulatorID = 10 --Solutions  --Chemical
LEFT JOIN datClientMembershipAccum apk
	ON apk.ClientMembershipGUID = cm.ClientMembershipGUID AND apk.AccumulatorID = 11 --Product Kits
LEFT JOIN datClientMembershipAccum hcsl
	ON hcsl.ClientMembershipGUID = cm.ClientMembershipGUID AND hcsl.AccumulatorID = 41 --Hair Care and Styling Lesson
LEFT JOIN datClientMembershipAccum sns
	ON sns.ClientMembershipGUID = cm.ClientMembershipGUID AND sns.AccumulatorID = 42 --S & S
LEFT JOIN (SELECT HSO.HairSystemOrderNumber, ClientGUID
			,	ROW_NUMBER()OVER(PARTITION BY HSO.ClientGUID ORDER BY HSO.HairSystemOrderDate ASC) AS 'Ranking'
			FROM dbo.datHairSystemOrder HSO
			WHERE HSO.HairSystemOrderStatusID = 4)q  --CENT  --In center
	ON 	ap.ClientGUID = q.ClientGUID AND q.Ranking = 1
--Find UCE Notes
LEFT JOIN (SELECT NC.NotesClient, ClientGUID
			,	ROW_NUMBER()OVER(PARTITION BY NC.ClientGUID ORDER BY NC.NotesClientDate DESC) AS 'Ranking'
			FROM dbo.datNotesClient NC
			WHERE NC.NoteTypeID = 13)r  --UCE Notes
	ON 	ap.ClientGUID = r.ClientGUID AND r.Ranking = 1
WHERE ap.AppointmentDate >= @StartDate
	AND ap.AppointmentDate < @EndDate
	AND ISNULL(ap.IsDeletedFlag, 0) = 0
	AND ce.CenterNumber = @CenterID
	AND ad.SalesCodeID IN(SELECT SalesCodeID FROM #service)
ORDER BY ap.AppointmentDate
,	ap.StartTime
,	ap.EndTime
,	sty.FirstName + ' ' + sty.LastName
END

SELECT AppointmentGUID
     , ClientGUID
     , Client
     , EmployeeGUID
     , Stylist
     , CenterDescriptionFullCalc
     , MembershipDescription
     , RenewalDate
     , AnniversaryDate
     , ApptDate
     , ApptTime
     , AppointmentDurationCalc
     , StartTime
     , EndTime
     , SalesCodeDescription
     , AppointmentDetailDuration
     , AR
     , EFTAccountTypeDescription
     , EFTStatusDescription
     , HairSystemTotal
     , HairSystemUsed
     , HairSystemRemaining
     , HairSystemDate
     , ServicesTotal
     , ServicesUsed
     , ServicesRemaining
     , ServicesDate
     , SolutionsTotal
     , SolutionsUsed
     , SolutionsRemaining
     , SolutionsDate
     , ProdKitTotal
     , ProdKitUsed
     , ProdKitRemaining
     , ProdKitDate
     , HCSLTotal
     , HCSLUsed
     , HCSLRemaining
     , HCSLDate
	 , SNSRemaining
     , FeePayCycleDescription
     , HairSystemOrderNumber
	 , UCENotesClient
FROM #Daily
ORDER BY ApptDate
,	CAST(StartTime AS TIME)
,	CAST(EndTime AS TIME)
,	Stylist



END
