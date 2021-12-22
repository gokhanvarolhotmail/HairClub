/*****************************************************************************************************

PROCEDURE:				[rptMembershipAgreementUploadAnalysisDetail]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin/ Rachelen Hut

IMPLEMENTOR: 			Mike Tovbin/ Rachelen Hut

DATE IMPLEMENTED: 		02/17/2014

LAST REVISION DATE: 	02/17/2014

--------------------------------------------------------------------------------------------------------
NOTES: 	This stored procedure is used to report if membership documents have been uploaded.
It uses the stored procedure [selOrdersForAgreementAudit] as the basis.
@Filter = 1 By Regions, 2 By Area Managers, 3 By Center
--------------------------------------------------------------------------------------------------------

CHANGE HISTORY:
12/29/2014 - RH - Added 'EXTMEMXU'to list of SalesCodeDescriptionShort - for Xtrands Upgrades from EXT.
05/02/2017 - RH - Renamed rptMembershipAgreement, Added @StartDate and @Filter; Removed @MembershipID (This report has been moved to SharePoint)
07/10/2018 - RH - (#148631) Rewrote the stored procedure for performance and to remove duplicate values
12/07/2018 - RH - (Case 6688) Replaced datSalesOrder with datClientMembership; pulled BeginDate between @StartDate and @EndDate

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [rptMembershipAgreementUploadAnalysisDetail]  '11/1/2018','11/18/2018', 'C', 2, 3, 0
EXEC [rptMembershipAgreementUploadAnalysisDetail]  '11/1/2018','11/18/2018', 'C', 3, 1002, 1


EXEC [rptMembershipAgreementUploadAnalysisDetail]  '11/1/2018','11/18/2018', 'F',  1,6, 0
EXEC [rptMembershipAgreementUploadAnalysisDetail]  '11/1/2018','11/18/2018', 'F',  3,746, 0

*******************************************************************************************************/
CREATE PROCEDURE [dbo].[rptMembershipAgreementUploadAnalysisDetail]
		@StartDate DATETIME
	,	@EndDate DATETIME
	,	@CenterType NVARCHAR(1)
	,	@Filter INT
	,	@CenterID INT
	,	@IncludeExceptionsOnly INT

AS
BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.

SET NOCOUNT ON;

/**************Create temp tables **************************************************************/

CREATE TABLE #Centers (
	MainGroupID INT
	,	MainGroupDescription NVARCHAR(150)
	,	MainGroupSortOrder INT
	,	CenterID INT
	,	CenterNumber INT
	,	CenterDescriptionFullCalc NVARCHAR(150)
	)

--DROP TABLE #ClientMenbership
CREATE TABLE #ClientMembership(
		CenterID INT
	,	CenterDescriptionFullCalc NVARCHAR(50)
	,	ClientIdentifier INT
	,	ClientFullNameCalc NVARCHAR(250)
	,	ClientMembershipGUID NVARCHAR(50)
	,	GenderDescription NVARCHAR(50)
	,	MembershipDescription NVARCHAR(50)
	,	BeginDate DATE
	,	LastAppointmentDate DATE
	,	NextAppointmentDate DATE
	,	EFTType NVARCHAR(60)
	,	Paycycle NVARCHAR(60)
	,	IsContractRequired INT
	, 	MonthlyFee DECIMAL(14,8)
	,	ARBalance DECIMAL(14,8)
	,	ContractPaidAmount DECIMAL(14,8)
	,	DocumentTypeDescription NVARCHAR(100)
	, 	DocumentDescription NVARCHAR(100)
	,	DocumentUploadDate DATETIME
	,	ClientMembershipDocumentGUID NVARCHAR(50)
	,   AnniversaryDate  NVARCHAR(50)
	,   ClientHistoryTotalTime NVARCHAR(50)
	,	ArchiveDate  NVARCHAR(50)
)


CREATE TABLE #Doc(
		ClientIdentifier INT
	,	ClientMembershipGUID NVARCHAR(50)
	,	DocumentTypeDescription NVARCHAR(100)
	,	DocumentTypeDescriptionShort NVARCHAR(25)
	,	DocumentDescription NVARCHAR(100)
	,	DocumentUploadDate DATETIME
	,	ArchiveDate DATETIME
	,	ClientMembershipDocumentGUID  NVARCHAR(50)
)


CREATE TABLE #EFT(
		ClientIdentifier INT
	,	ClientMembershipGUID NVARCHAR(50)
	,	EFTType NVARCHAR(60)
	,	Paycycle NVARCHAR(60)
)

/*************************Find Centers ********************************************************/


IF (@CenterType = 'C' AND @Filter = 2)										--By Areas
BEGIN
INSERT  INTO #Centers
		SELECT C.CenterManagementAreaID AS 'MainGroupID'
		,		CenterManagementAreaDescription AS 'MainGroupDescription'
		,		CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
		,		C.CenterID
		,		C.CenterNumber
		,		C.CenterDescriptionFullCalc
		FROM    cfgCenter C
				INNER JOIN dbo.cfgCenterManagementArea CMA
					ON C.CenterManagementAreaID = CMA.CenterManagementAreaID
                INNER JOIN dbo.lkpCenterType ct
					ON C.CenterTypeID = ct.CenterTypeID
		WHERE   CMA.CenterManagementAreaID = @CenterID
				AND CMA.IsActiveFlag = 1
				AND C.IsActiveFlag = 1
END
ELSE IF (@CenterType = 'C' AND @Filter = 3)										--A center has been selected
BEGIN
INSERT  INTO #Centers
		SELECT C.CenterManagementAreaID AS 'MainGroupID'
		,		CenterManagementAreaDescription AS 'MainGroupDescription'
		,		CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
		,		C.CenterID
		,		C.CenterNumber
		,		C.CenterDescriptionFullCalc
		FROM    cfgCenter C
				INNER JOIN dbo.cfgCenterManagementArea CMA
					ON C.CenterManagementAreaID = CMA.CenterManagementAreaID

		WHERE   C.CenterID = @CenterID
				AND C.IsActiveFlag = 1
END
ELSE IF (@CenterType = 'F' AND @Filter = 1)
BEGIN
INSERT  INTO #Centers
		SELECT   R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroupDescription'
		,		R.RegionSortOrder
		,		C.CenterID
		,		C.CenterNumber
		,		C.CenterDescriptionFullCalc
		FROM    cfgCenter C
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
				INNER JOIN lkpCenterType ct
					ON C.CenterTypeID = ct.CenterTypeID

		WHERE   ct.CenterTypeDescriptionShort in ('F', 'JV')
				AND C.IsActiveFlag = 1
				AND R.RegionID = @CenterID
END
ELSE IF (@CenterType = 'F' AND @Filter = 3)
BEGIN
	INSERT  INTO #Centers
	SELECT  R.RegionID AS 'MainGroupID'
		,		R.RegionDescription AS 'MainGroupDescription'
		,		R.RegionSortOrder AS 'MainGroupSortOrder'
		,		C.CenterID
		,		C.CenterNumber
		,		C.CenterDescriptionFullCalc
		FROM    cfgCenter C
				INNER JOIN lkpRegion R
					ON C.RegionID = R.RegionID
				INNER JOIN lkpCenterType ct
					ON C.CenterTypeID = ct.CenterTypeID
		WHERE   ct.CenterTypeDescriptionShort in ('F', 'JV')
				AND C.IsActiveFlag = 1
				AND C.CenterID = @CenterID
END


/****************** Find Client Membership **********************************************/

INSERT INTO #ClientMembership

SELECT	ctr.CenterID
	,	ctr.CenterDescriptionFullCalc
	,	clt.ClientIdentifier
	,	clt.ClientFullNameCalc
	,	cm.ClientMembershipGUID
	,	g.GenderDescription
	,	m.MembershipDescription
	,	cm.BeginDate
	,	NULL AS 'LastAppointmentDate'
	,	NULL AS  'NextAppointmentDate'
	,	NULL AS 'EFTType'
	,	NULL AS  'Paycycle'
	,	cfg.IsContractRequired
	, 	cm.MonthlyFee
	,	clt.ARBalance
	,	cm.ContractPaidAmount
	,	NULL AS 'DocumentTypeDescription'
	, 	NULL AS 'DocumentDescription'
	,	NULL AS 'DocumentUploadDate'
	,	NULL AS 'ClientMembershipDocumentGUID'
	,   CASE WHEN AnniversaryDate  IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN trans.FirstOrderDate ELSE clt.AnniversaryDate END AS 'AnniversaryDate'
	,   cast(DATEDIFF(m,CASE WHEN AnniversaryDate IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN trans.FirstOrderDate ELSE clt.AnniversaryDate END,getdate())/12 as varchar(25)) + ' Years and ' + cast(DATEDIFF(m,CASE WHEN clt.AnniversaryDate IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN trans.FirstOrderDate ELSE clt.AnniversaryDate END,getdate())%12 as varchar(25)) + ' Months' as ClientHistoryTotalTime
	,   NULL AS 'ArchiveDate'
FROM dbo.datClient clt
	INNER JOIN dbo.cfgCenter ctr
		ON clt.CenterID = ctr.CenterID
	INNER JOIN #Centers
		ON #Centers.CenterNumber = ctr.CenterNumber
	INNER JOIN dbo.datClientMembership cm
		ON (cm.ClientMembershipGUID = clt.CurrentBioMatrixClientMembershipGUID
			OR cm.ClientMembershipGUID = clt.CurrentExtremeTherapyClientMembershipGUID
			OR cm.ClientMembershipGUID = clt.CurrentSurgeryClientMembershipGUID
			OR cm.ClientMembershipGUID = clt.CurrentXtrandsClientMembershipGUID)
	INNER JOIN dbo.cfgMembership m
		ON m.MembershipID = cm.MembershipID
	INNER JOIN dbo.lkpGender g
		ON g.GenderID = clt.GenderID
	LEFT JOIN dbo.cfgConfigurationMembership cfg
		ON cfg.MembershipID = m.MembershipID
	OUTER APPLY
	(
		SELECT TOP 1
			ClientGUID,
			MIN(OrderDate) as FirstOrderDate
			FROM dbo.datsalesorder so
			WHERE isvoidedflag = 0
			AND clt.ClientGUID = so.ClientGUID
			GROUP BY ClientGUID
	) Trans
WHERE cm.BeginDate BETWEEN @StartDate AND @EndDate
	AND m.MembershipDescriptionShort NOT IN ( 'SHOWNOSALE', 'SNSSURGOFF' )
GROUP BY ctr.CenterID
,         ctr.CenterDescriptionFullCalc
,         clt.ClientIdentifier
,         clt.ClientFullNameCalc
,         cm.ClientMembershipGUID
,         g.GenderDescription
,         m.MembershipDescription
,         cm.BeginDate
,         cfg.IsContractRequired
,         cm.MonthlyFee
,         clt.ARBalance
,         cm.ContractPaidAmount
,	   CASE WHEN clt.AnniversaryDate  IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN trans.FirstOrderDate ELSE clt.AnniversaryDate END
,	   cast(DATEDIFF(m,CASE WHEN AnniversaryDate IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN trans.FirstOrderDate ELSE clt.AnniversaryDate END,getdate())/12 as varchar(25)) + ' Years and ' + cast(DATEDIFF(m,CASE WHEN clt.AnniversaryDate IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN trans.FirstOrderDate ELSE clt.AnniversaryDate END, getdate())%12 as varchar(25)) + ' Months'



/************************* Find the Previous Appointment Date *******************************/

UPDATE CM
SET LastAppointmentDate =  dbo.fn_GetPreviousAppointmentDate(CM.ClientMembershipGUID)
FROM #ClientMembership CM
INNER JOIN dbo.datSalesOrder DSO
	ON CM.ClientMembershipGUID = DSO.ClientMembershipGUID
WHERE CM.LastAppointmentDate IS NULL

/************************* Find the Next Appointment Date ***********************************/

UPDATE CM
SET NextAppointmentDate = CONVERT(DATETIME,dbo.fn_GetNextAppointmentDate(CM.ClientMembershipGUID) )
FROM #ClientMembership CM
INNER JOIN dbo.datSalesOrder DSO
	ON CM.ClientMembershipGUID = DSO.ClientMembershipGUID
WHERE CM.NextAppointmentDate IS NULL


/************** Find Client EFT information ***************************************************/

INSERT INTO #EFT
SELECT CM.ClientIdentifier
,	CM.ClientMembershipGUID
,	CASE EAT.EFTAccountTypeID WHEN 1 THEN EAT.EFTAccountTypeDescription + ' ' + ISNULL(CAST(DATEPART(MM, EFT.AccountExpiration) AS VARCHAR) + '/' + RIGHT(CAST(DATEPART(YY, EFT.AccountExpiration) AS VARCHAR),2),'')
		ELSE EAT.EFTAccountTypeDescription END AS 'EFTType'
,	FPC.FeePayCycleDescription AS 'Paycycle'
FROM #ClientMembership CM
	LEFT JOIN dbo.datClientEFT EFT
		ON CM.ClientMembershipGUID = EFT.ClientMembershipGUID
	LEFT JOIN  dbo.lkpFeePayCycle FPC
		ON FPC.FeePayCycleId = EFT.FeePayCycleId
	LEFT JOIN dbo.lkpEFTAccountType EAT
		ON EAT.EFTAccountTypeID = EFT.EFTAccountTypeID


/****************** Find Document Information *************************************************/

INSERT INTO #Doc
SELECT 	CM.ClientIdentifier
		,	CM.ClientMembershipGUID
		,	DT.DocumentTypeDescription
		,	DT.DocumentTypeDescriptionShort
		,	DOC.[Description] AS 'DocumentDescription'
		,	CASE WHEN DT.DocumentTypeDescription = 'Agreement' THEN DOC.CreateDate  ELSE '' END AS 'DocumentUploadDate'
		,	CASE WHEN DT.DocumentTypeDescription = 'ARCHIVE' then DOC.CreateDate else '' END AS 'ArchiveDate'
		,	DOC.ClientMembershipDocumentGUID
		FROM #ClientMembership CM
		LEFT JOIN dbo.datClientMembershipDocument DOC
			ON DOC.ClientMembershipGUID = CM.ClientMembershipGUID
		LEFT JOIN dbo.lkpDocumentType DT
			ON DT.DocumentTypeId = DOC.DocumentTypeId
		WHERE DOC.ClientMembershipGUID = CM.ClientMembershipGUID
			AND DT.DocumentTypeDescriptionShort in  ('Agreement', 'ARCHIVE')


/************ Combine data ********************************************************************/

UPDATE CM
SET CM.EFTType = #EFT.EFTType
FROM #ClientMembership CM
LEFT JOIN #EFT
	ON #EFT.ClientMembershipGUID = CM.ClientMembershipGUID
WHERE CM.EFTType IS NULL

UPDATE CM
SET CM.Paycycle = #EFT.Paycycle
FROM #ClientMembership CM
LEFT JOIN #EFT
	ON #EFT.ClientMembershipGUID = CM.ClientMembershipGUID
WHERE CM.Paycycle IS NULL


UPDATE CM
SET CM.DocumentTypeDescription = #Doc.DocumentTypeDescription
FROM #ClientMembership CM
LEFT JOIN #Doc
	ON #Doc.ClientMembershipGUID = CM.ClientMembershipGUID
WHERE CM.DocumentTypeDescription IS NULL

UPDATE CM
SET CM.DocumentDescription = #Doc.DocumentDescription
FROM #ClientMembership CM
LEFT JOIN #Doc
	ON #Doc.ClientMembershipGUID = CM.ClientMembershipGUID
WHERE CM.DocumentDescription IS NULL

UPDATE CM
SET CM.DocumentUploadDate = #Doc.DocumentUploadDate
FROM #ClientMembership CM
LEFT JOIN #Doc
	ON #Doc.ClientMembershipGUID = CM.ClientMembershipGUID
WHERE CM.DocumentUploadDate IS NULL

UPDATE CM
SET CM.ClientMembershipDocumentGUID = #Doc.ClientMembershipDocumentGUID
FROM #ClientMembership CM
LEFT JOIN #Doc
	ON #Doc.ClientMembershipGUID = CM.ClientMembershipGUID
WHERE CM.ClientMembershipDocumentGUID IS NULL

UPDATE CM
SET CM.ArchiveDate = #Doc.ArchiveDate
FROM #ClientMembership CM
LEFT JOIN #Doc
	ON #Doc.ClientMembershipGUID = CM.ClientMembershipGUID
WHERE CM.ArchiveDate IS NULL

/***************** IF @IncludeExceptionsOnly = 1 then show all documents that don't have a ClientMembershipDocumentGUID ELSE Show All *************/

IF @IncludeExceptionsOnly = 1
BEGIN
SELECT  #Centers.MainGroupID
	,	#Centers.MainGroupDescription
	,	#Centers.MainGroupSortOrder
	,	#Centers.CenterID
	,	#Centers.CenterNumber
	,	#Centers.CenterDescriptionFullCalc
	,	CM.ClientIdentifier
	,	CM.ClientFullNameCalc
	,	CM.ClientMembershipGUID
	,	CM.GenderDescription
	,	CM.MembershipDescription
	,	CM.BeginDate
	,	CM.LastAppointmentDate
	,	CM.NextAppointmentDate
	,	CM.EFTType
	,	CM.Paycycle
	,	CM.IsContractRequired
	,	CM.MonthlyFee
	,	CM.ARBalance
	,	CM.ContractPaidAmount
	,	CM.DocumentTypeDescription
	,	CM.DocumentDescription
	,	CASE WHEN CM.DocumentUploadDate IS NULL THEN 'X' ELSE CAST(CM.DocumentUploadDate AS NVARCHAR(101)) END AS DocumentUploadDate
	,	CM.ClientMembershipDocumentGUID
	,	CASE WHEN CM.AnniversaryDate IS NULL THEN 'X' ELSE CAST(CM.AnniversaryDate AS NVARCHAR(101)) END AS AnniversaryDate
	,	CM.ClientHistoryTotalTime
	,	CASE WHEN CM.ArchiveDate IS NULL THEN 'X' WHEN CM.ArchiveDate = 'Jan  1 1900 12:00AM' THEN 'X' ELSE CM.ArchiveDate END AS ArchiveDate
FROM #ClientMembership CM
INNER JOIN #Centers
	ON #Centers.CenterID = CM.CenterID
WHERE CM.ClientMembershipDocumentGUID IS NULL  --This limits this selection --IF @IncludeExceptionsOnly = 1
END
ELSE
BEGIN
SELECT  #Centers.MainGroupID
	,	#Centers.MainGroupDescription
	,	#Centers.MainGroupSortOrder
	,	#Centers.CenterID
	,	#Centers.CenterNumber
	,	#Centers.CenterDescriptionFullCalc
	,	CM.ClientIdentifier
	,	CM.ClientFullNameCalc
	,	CM.ClientMembershipGUID
	,	CM.GenderDescription
	,	CM.MembershipDescription
	,	CM.BeginDate
	,	CM.LastAppointmentDate
	,	CM.NextAppointmentDate
	,	CM.EFTType
	,	CM.Paycycle
	,	CM.IsContractRequired
	,	CM.MonthlyFee
	,	CM.ARBalance
	,	CM.ContractPaidAmount
	,	CM.DocumentTypeDescription
	,	CM.DocumentDescription
	,	CASE WHEN DocumentUploadDate IS NULL THEN 'X' ELSE CAST(CM.DocumentUploadDate AS NVARCHAR(101)) END AS DocumentUploadDate
	,	CM.ClientMembershipDocumentGUID
	,	CASE WHEN CM.AnniversaryDate IS NULL THEN 'X' ELSE CAST(CM.AnniversaryDate AS NVARCHAR(101)) END ASAnniversaryDate
	,	CM.ClientHistoryTotalTime
	,	CASE WHEN CM.ArchiveDate IS NULL THEN 'X' WHEN CM.ArchiveDate = 'Jan  1 1900 12:00AM' THEN 'X' ELSE CM.ArchiveDate END AS ArchiveDate
FROM #ClientMembership CM
INNER JOIN #Centers
	ON #Centers.CenterID = CM.CenterID
END


END
