/* CreateDate: 05/03/2017 15:50:55.700 , ModifyDate: 07/10/2018 16:04:40.403 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************

PROCEDURE:				[rptMembershipAgreementUploadAnalysis]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin/ Rachelen Hut

IMPLEMENTOR: 			Mike Tovbin/ Rachelen Hut

DATE IMPLEMENTED: 		02/17/2014

LAST REVISION DATE: 	02/17/2014

--------------------------------------------------------------------------------------------------------
NOTES: 	This SUMMARY stored procedure is used to report if membership documents have been uploaded.
It uses the stored procedure [selOrdersForAgreementAudit] as the basis.
@Filter = 1 By Regions, 2 By Area Managers, 3 By Center
--------------------------------------------------------------------------------------------------------

CHANGE HISTORY:
12/29/2014 - RH - Added 'EXTMEMXU'to list of SalesCodeDescriptionShort - for Xtrands Upgrades from EXT.
05/02/2017 - RH - Renamed rptMembershipAgreement, Added @StartDate, Removed @MembershipID (This report has been moved to SharePoint)
07/10/2018 - RH - (#148631) Rewrote the stored procedure for performance and to remove duplicate values
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [rptMembershipAgreementUploadAnalysis] '3/1/2018','3/18/2018', 'C', 1

EXEC [rptMembershipAgreementUploadAnalysis] '3/1/2018','3/18/2018', 'C', 0

*******************************************************************************************************/
CREATE PROCEDURE [dbo].[rptMembershipAgreementUploadAnalysis]
		@StartDate DATETIME
	,	@EndDate DATETIME
	,	@CenterType NVARCHAR(1)
	,	@IncludeExceptionsOnly INT

AS
BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.

SET NOCOUNT ON;


/**************Create temp tables **********************************/

CREATE TABLE #Centers
       (      MainGroupID INT
       ,      MainGroupDescription NVARCHAR(150)
       ,      MainGroupSortOrder INT
       ,      CenterID INT
       ,      CenterNumber INT
       ,      CenterDescriptionFullCalc NVARCHAR(150)
       )


CREATE TABLE #SalesOrder(
		CenterID INT
	,	CenterDescriptionFullCalc NVARCHAR(50)
	,	ClientIdentifier INT
	,	ClientFullNameCalc NVARCHAR(250)
	,	ClientMembershipGUID NVARCHAR(50)
	,	GenderID INT
	,	GenderDescription NVARCHAR(50)
	,	MembershipDescription NVARCHAR(50)
	,	EndDate DATE
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
	,   AnniversaryDate DATETIME
	,   ClientHistoryTotalTime NVARCHAR(50)
	,	ArchiveDate DATETIME
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

/*************************Find Centers *********************************/

IF @CenterType = 'C'
BEGIN
INSERT  INTO #Centers
              SELECT CMA.CenterManagementAreaID AS 'MainGroupID'
              ,             CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
              ,             CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
              ,             C.CenterID
              ,             C.CenterNumber
              ,             C.CenterDescriptionFullCalc
              FROM    cfgCenter C
                           INNER JOIN dbo.lkpCenterType CT
                                  ON C.CenterTypeID = CT.CenterTypeID
                           INNER JOIN dbo.cfgCenterManagementArea CMA
                                  ON C.CenterManagementAreaID = CMA.CenterManagementAreaID
              WHERE   CT.CenterTypeDescriptionShort = 'C'
                           AND C.IsActiveFlag = 1
END
ELSE IF @CenterType = 'F'
BEGIN
INSERT  INTO #Centers
              SELECT  R.RegionID AS 'MainGroupID'
              ,             R.RegionDescription AS 'MainGroupDescription'
              ,             R.RegionSortOrder AS 'MainGroupSortOrder'
              ,             C.CenterID
              ,             C.CenterNumber
              ,             C.CenterDescriptionFullCalc
              FROM    cfgCenter C
                           INNER JOIN dbo.lkpCenterType CT
                                  ON C.CenterTypeID = CT.CenterTypeID
                           INNER JOIN lkpRegion R
                                  ON C.RegionID = R.RegionID
              WHERE   CT.CenterTypeDescriptionShort IN('F','JV')
                           AND C.IsActiveFlag = 1
END

/****************** Find Sales Order information **********************************************/

INSERT INTO #SalesOrder
SELECT	CTR.CenterID
	,	CTR.CenterDescriptionFullCalc
	,	c.ClientIdentifier
	,	c.ClientFullNameCalc
	,	mem.ClientMembershipGUID
	,	c.GenderID
	,	g.GenderDescription
	,	mem.MembershipDescription
	,	mem.EndDate
	,	NULL AS 'LastAppointmentDate'
	,	NULL AS  'NextAppointmentDate'
	,	NULL AS 'EFTType'
	,	NULL AS  'Paycycle'
	,	cfg.IsContractRequired
	, 	mem.MonthlyFee
	,	c.ARBalance
	,	mem.ContractPaidAmount
	,	NULL AS 'DocumentTypeDescription'
	, 	NULL AS 'DocumentDescription'
	,	NULL AS 'DocumentUploadDate'
	,	NULL AS 'ClientMembershipDocumentGUID'
	,   CASE WHEN AnniversaryDate  IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN trans.FirstOrderDate ELSE c.AnniversaryDate END AS 'AnniversaryDate'
	,   cast(DATEDIFF(m,CASE WHEN AnniversaryDate IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN trans.FirstOrderDate ELSE c.AnniversaryDate END,getdate())/12 as varchar(25)) + ' Years and ' + cast(DATEDIFF(m,CASE WHEN AnniversaryDate IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN FirstOrderDate ELSE c.AnniversaryDate END,getdate())%12 as varchar(25)) + ' Months' as ClientHistoryTotalTime
	,   NULL AS 'ArchiveDate'
FROM datSalesOrder so
	INNER JOIN cfgCenter CTR
		ON so.CenterID = CTR.CenterID
	INNER JOIN #Centers
		ON #Centers.CenterNumber = CTR.CenterNumber
	INNER JOIN datSalesOrderDetail sod
		ON so.SalesOrderGUID = sod.SalesOrderGUID
	INNER JOIN lkpSalesOrderType soType
		ON soType.SalesOrderTypeID = so.SalesOrderTypeID
	INNER JOIN datClient c
		ON c.ClientGUID = so.ClientGUID
	INNER JOIN dbo.lkpGender g
		ON c.GenderID = g.GenderID
	CROSS APPLY
		(SELECT TOP 1 ClientMembershipGUID
		, M.MembershipID
		, M.MembershipDescription
		,	M.MembershipDescriptionShort
		,	CM.EndDate
		,	CM.ContractPaidAmount
		,	CM.MonthlyFee
		,	ROW_NUMBER()OVER(PARTITION BY ClientGUID, CM.ClientMembershipGUID  ORDER BY CM.EndDate DESC) AS Ranking
				FROM datClientMembership CM
				INNER JOIN cfgMembership M
					ON M.MembershipId = CM.MembershipId
				WHERE CM.ClientGUID = C.ClientGUID
				) mem
	LEFT JOIN dbo.cfgConfigurationMembership cfg
		ON cfg.MembershipID = mem.MembershipID
	OUTER APPLY
	(
		SELECT TOP 1
			ClientGUID,
			MIN(OrderDate) as FirstOrderDate
			FROM datsalesorder so
			WHERE isvoidedflag = 0
			AND c.ClientGUID = so.ClientGUID
			GROUP BY ClientGUID
	) Trans
WHERE soType.SalesOrderTypeDescriptionShort = 'MO'
	AND so.OrderDate BETWEEN @StartDate AND @EndDate
	AND mem.MembershipDescriptionShort NOT IN ( 'SHOWNOSALE', 'SNSSURGOFF' )
	AND mem.Ranking = 1
GROUP BY CTR.CenterID
	,	#Centers.CenterNumber
	,	CTR.CenterDescriptionFullCalc
	,	c.ClientIdentifier
	,	c.ClientFullNameCalc
	,	mem.ClientMembershipGUID
	,	c.GenderID
	,	g.GenderDescription
	,	mem.MembershipDescription
	,	mem.EndDate
	,	cfg.IsContractRequired
	, 	mem.MonthlyFee
	,	c.ARBalance
	,	mem.ContractPaidAmount
	,   CASE WHEN AnniversaryDate  IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN trans.FirstOrderDate ELSE c.AnniversaryDate END
	,   cast(DATEDIFF(m,CASE WHEN AnniversaryDate IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN trans.FirstOrderDate ELSE c.AnniversaryDate END,getdate())/12 as varchar(25)) + ' Years and ' + cast(DATEDIFF(m,CASE WHEN AnniversaryDate IN( '1900-01-01 00:00:00.000','1990-01-01 00:00:00.000','1991-01-01 00:00:00.000') THEN FirstOrderDate ELSE c.AnniversaryDate END, getdate())%12 as varchar(25)) + ' Months'

/************************* Find the Previous Appointment Date *******************************/

UPDATE SO
SET LastAppointmentDate =  dbo.fn_GetPreviousAppointmentDate(SO.ClientMembershipGUID)
FROM #SalesOrder SO
INNER JOIN dbo.datSalesOrder DSO
	ON SO.ClientMembershipGUID = DSO.ClientMembershipGUID
WHERE LastAppointmentDate IS NULL

/************************* Find the Next Appointment Date ***********************************/

UPDATE SO
SET NextAppointmentDate = CONVERT(DATETIME,dbo.fn_GetNextAppointmentDate(SO.ClientMembershipGUID) )
FROM #SalesOrder SO
INNER JOIN dbo.datSalesOrder DSO
	ON SO.ClientMembershipGUID = DSO.ClientMembershipGUID
WHERE NextAppointmentDate IS NULL


/************** Find Client EFT information ***************************************************/

INSERT INTO #EFT
SELECT SO.ClientIdentifier
,	SO.ClientMembershipGUID
,	CASE EAT.EFTAccountTypeID WHEN 1 THEN EAT.EFTAccountTypeDescription + ' ' + ISNULL(CAST(DATEPART(MM, EFT.AccountExpiration) AS VARCHAR) + '/' + RIGHT(CAST(DATEPART(YY, EFT.AccountExpiration) AS VARCHAR),2),'')
		ELSE EAT.EFTAccountTypeDescription END AS 'EFTType'
,	FPC.FeePayCycleDescription AS 'Paycycle'
FROM #SalesOrder SO
	LEFT JOIN datClientEFT EFT
		ON SO.ClientMembershipGUID = EFT.ClientMembershipGUID
	LEFT JOIN  lkpFeePayCycle FPC
		ON FPC.FeePayCycleId = EFT.FeePayCycleId
	LEFT JOIN lkpEFTAccountType EAT
		ON EAT.EFTAccountTypeID = EFT.EFTAccountTypeID


/****************** Find Document Information *************************************************/

INSERT INTO #Doc
SELECT 	SO.ClientIdentifier
		,	SO.ClientMembershipGUID
		,	DT.DocumentTypeDescription
		,	DT.DocumentTypeDescriptionShort
		,	DOC.[Description] AS 'DocumentDescription'
		,	CASE WHEN DT.DocumentTypeDescription = 'Agreement' THEN DOC.CreateDate  ELSE '' END AS 'DocumentUploadDate'
		,	CASE WHEN DT.DocumentTypeDescription = 'ARCHIVE' then DOC.CreateDate else '' END AS 'ArchiveDate'
		,	DOC.ClientMembershipDocumentGUID
		FROM #SalesOrder SO
		LEFT JOIN datClientMembershipDocument DOC
			ON DOC.ClientMembershipGUID = SO.ClientMembershipGUID
		LEFT JOIN lkpDocumentType DT
			ON DT.DocumentTypeId = DOC.DocumentTypeId
		WHERE DOC.ClientMembershipGUID = SO.ClientMembershipGUID
			AND DT.DocumentTypeDescriptionShort in  ('Agreement', 'ARCHIVE')


/************ Combine data ********************************************************************/

UPDATE SO
SET SO.EFTType = #EFT.EFTType
FROM #SalesOrder SO
LEFT JOIN #EFT
	ON #EFT.ClientMembershipGUID = SO.ClientMembershipGUID
WHERE SO.EFTType IS NULL

UPDATE SO
SET SO.Paycycle = #EFT.Paycycle
FROM #SalesOrder SO
LEFT JOIN #EFT
	ON #EFT.ClientMembershipGUID = SO.ClientMembershipGUID
WHERE SO.Paycycle IS NULL


UPDATE SO
SET SO.DocumentTypeDescription = #Doc.DocumentTypeDescription
FROM #SalesOrder SO
LEFT JOIN #Doc
	ON #Doc.ClientMembershipGUID = SO.ClientMembershipGUID
WHERE SO.DocumentTypeDescription IS NULL

UPDATE SO
SET SO.DocumentDescription = #Doc.DocumentDescription
FROM #SalesOrder SO
LEFT JOIN #Doc
	ON #Doc.ClientMembershipGUID = SO.ClientMembershipGUID
WHERE SO.DocumentDescription IS NULL

UPDATE SO
SET SO.DocumentUploadDate = #Doc.DocumentUploadDate
FROM #SalesOrder SO
LEFT JOIN #Doc
	ON #Doc.ClientMembershipGUID = SO.ClientMembershipGUID
WHERE SO.DocumentUploadDate IS NULL

UPDATE SO
SET SO.ClientMembershipDocumentGUID = #Doc.ClientMembershipDocumentGUID
FROM #SalesOrder SO
LEFT JOIN #Doc
	ON #Doc.ClientMembershipGUID = SO.ClientMembershipGUID
WHERE SO.ClientMembershipDocumentGUID IS NULL

UPDATE SO
SET SO.ArchiveDate = #Doc.ArchiveDate
FROM #SalesOrder SO
LEFT JOIN #Doc
	ON #Doc.ClientMembershipGUID = SO.ClientMembershipGUID
WHERE SO.ArchiveDate IS NULL

/***************** IF @IncludeExceptionsOnly = 1 then show all documents that don't have a ClientMembershipDocumentGUID ELSE Show All *************/

IF @IncludeExceptionsOnly = 1
BEGIN
SELECT  #Centers.MainGroupID
	,	#Centers.MainGroupDescription
	,	#Centers.MainGroupSortOrder
	,	#Centers.CenterID
	,	#Centers.CenterNumber
	,	#Centers.CenterDescriptionFullCalc
	,	COUNT(#SalesOrder.ClientIdentifier) AS 'Count'
FROM #SalesOrder
INNER JOIN #Centers
	ON #Centers.CenterID = #SalesOrder.CenterID
WHERE #SalesOrder.ClientMembershipDocumentGUID IS NULL  --This limits this selection --IF @IncludeExceptionsOnly = 1
GROUP BY #Centers.MainGroupID
	,	#Centers.MainGroupDescription
	,	#Centers.MainGroupSortOrder
	,	#Centers.CenterID
	,	#Centers.CenterNumber
	,	#Centers.CenterDescriptionFullCalc
END
ELSE
BEGIN
SELECT  #Centers.MainGroupID
	,	#Centers.MainGroupDescription
	,	#Centers.MainGroupSortOrder
	,	#Centers.CenterID
	,	#Centers.CenterNumber
	,	#Centers.CenterDescriptionFullCalc
    ,	COUNT(#SalesOrder.ClientIdentifier) AS 'Count'
FROM #SalesOrder
INNER JOIN #Centers
	ON #Centers.CenterID = #SalesOrder.CenterID
GROUP BY #Centers.MainGroupID
	,	#Centers.MainGroupDescription
	,	#Centers.MainGroupSortOrder
	,	#Centers.CenterID
	,	#Centers.CenterNumber
	,	#Centers.CenterDescriptionFullCalc
END


END
GO
