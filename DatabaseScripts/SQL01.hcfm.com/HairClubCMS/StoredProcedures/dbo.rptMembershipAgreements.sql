/* CreateDate: 02/20/2014 09:50:33.283 , ModifyDate: 12/06/2016 15:01:22.400 */
GO
/***********************************************************************

PROCEDURE:				rptMembershipAgreements

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

CHANGE HISTORY:
12/29/2014	RH	Added 'EXTMEMXU'to list of SalesCodeDescriptionShort - for Xtrands Upgrades from EXT.

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

rptMembershipAgreements '2/18/2014', 1, NULL, 0

rptMembershipAgreements '3/5/2014', 2, NULL, 0

rptMembershipAgreements '3/5/2014', 201, NULL, 0

rptMembershipAgreements '2/18/2014', 747, 25, 1 --Danny Ricchio --Bronze Solutions

***********************************************************************/
CREATE PROCEDURE [dbo].[rptMembershipAgreements]
	@EndDate DATETIME
	,	@CenterID INT
	,	@MembershipID INT = NULL
	,	@IncludeExceptionsOnly as bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @MembershipOrderType nvarchar(2) = 'MO'

	DECLARE @StartDate DATETIME
	SELECT @StartDate = DATEADD(day,-7,@EndDate)


    SELECT  TimeZoneID
    ,       [UTCOffset]
    ,       [UsesDayLightSavingsFlag]
    ,       [IsActiveFlag]
    ,       dbo.GetUTCFromLocal(@StartDate, [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCStartDate]
    ,       dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCEndDate]
    INTO    #UTCDateParms
    FROM    dbo.lkpTimeZone
    WHERE   [IsActiveFlag] = 1;


	/**************Create temp tables **********************************/
	IF OBJECT_ID('tempdb..#Centers') IS NOT NULL
	BEGIN
		DROP TABLE #Centers
	END
	CREATE TABLE #Centers
		(
			CenterID INT NOT NULL
			,	CenterDescriptionFullCalc NVARCHAR(110) NOT NULL
		)

	IF OBJECT_ID('tempdb..#SalesCodes') IS NOT NULL
	BEGIN
		DROP TABLE #SalesCodes
	END
	CREATE TABLE #SalesCodes
		(
			SalesCodeId int NOT NULL
			,	SalesCodeDescriptionShort nvarchar(10) NOT NULL
			,	SalesCodeDescription nvarchar(100) NOT NULL
		)


	--Insert code for Centers selection here
	IF @CenterID = 1 --Corporate
	BEGIN
		INSERT INTO #Centers
		SELECT CenterID
			,	CenterDescriptionFullCalc
		FROM dbo.cfgCenter
		WHERE CenterID LIKE '[2]%'
		AND IsActiveFlag = 1
	END
	ELSE
	IF @CenterID = 2 --Franchise
	BEGIN
		INSERT INTO #Centers
		SELECT CenterID
			,	CenterDescriptionFullCalc
		FROM dbo.cfgCenter
		WHERE CenterID LIKE '[78]%'
		AND IsActiveFlag = 1
	END
	ELSE
	BEGIN
		INSERT INTO #Centers
		SELECT CenterID
			,	CenterDescriptionFullCalc
		FROM dbo.cfgCenter
		WHERE CenterID = @CenterID
	END

	/*************************Find the Sales Codes*********************************/
	INSERT INTO #SalesCodes
		(SalesCodeId
		,	SalesCodeDescriptionShort
		,	SalesCodeDescription)
	SELECT SalesCodeId
		,	SalesCodeDescriptionShort
		,	SalesCodeDescription
	FROM cfgSalesCode
	WHERE SalesCodeDescriptionShort IN
				('INITASG', 'GUARANTEE','POSTEXTXU','CONV','POSTEXT','POSTEL',
					'NB2R', 'UPDCXL','NEWMEM','PCPXD','BOSASG','RENEW','PCPXU','NB2XU','EXTMEMXU')

	/************Main select statement*********************************/
	IF @IncludeExceptionsOnly = 1
	BEGIN
		SELECT cent.RegionID
			,	r.RegionDescription	AS 'RegionDescription'
			,	cent.CenterID AS 'CenterID'
			,	cent.CenterDescriptionFullCalc AS 'CenterDescriptionFullCalc'
			,	c.ClientIdentifier AS 'ClientIdentifier'
			,	c.ClientFullNameCalc AS 'ClientFullNameCalc'
			,	c.GenderID AS 'GenderID'
			,	g.GenderDescription AS 'GenderDescription'
			,	mem.MembershipDescription AS 'MembershipDescription'
			,	so.OrderDate AS 'OrderDate'
			,	cm.EndDate AS 'EndDate'
			,	sc.SalesCodeDescription AS 'SalesCodeDescription'
			,	dbo.fn_GetPreviousAppointmentDate(cm.ClientMembershipGUID) AS 'LastAppointmentDate'
			,	dbo.fn_GetNextAppointmentDate(cm.ClientMembershipGUID) AS 'NextAppointmentDate'
			,	CASE at.EFTAccountTypeID WHEN 1 THEN at.EFTAccountTypeDescription + ' ' + ISNULL(CAST(DATEPART(MM, eft.AccountExpiration) AS VARCHAR) + '/' + RIGHT(CAST(DATEPART(YY, eft.AccountExpiration) AS VARCHAR),2),'')
					ELSE at.EFTAccountTypeDescription END AS 'EFTType'
			,	pc.FeePayCycleDescription AS 'Paycycle'
			,	cfg.IsContractRequired AS 'IsContractRequired'
			, 	cm.MonthlyFee AS 'MonthlyFee'
			,	c.ARBalance AS 'ARBalance'
			,	cm.ContractPaidAmount AS 'ContractBalance'
			,	cmDoc.DocumentTypeDescription AS 'DocumentType'
			, 	cmDoc.[Description] AS 'DocumentDescription'
			,	CAST(cmDoc.CreateDate AS DATE) AS 'DocumentUploadDate'
			,	cmDoc.ClientMembershipDocumentGUID
		FROM datSalesOrder so
			INNER JOIN datSalesOrderDetail sod
				ON so.SalesOrderGUID = sod.SalesOrderGUID
			INNER JOIN #SalesCodes sc
				ON sc.SalesCodeId = sod.SalesCodeId
			INNER JOIN lkpSalesOrderType soType
				ON soType.SalesOrderTypeID = so.SalesOrderTypeID
			INNER JOIN datClient c
				ON c.ClientGUID = so.ClientGUID
			INNER JOIN dbo.lkpGender g
				ON c.GenderID = g.GenderID
			INNER JOIN datClientMembership cm
				ON so.ClientMembershipGUID = cm.ClientMembershipGUID
			INNER JOIN cfgMembership mem
				ON mem.MembershipId = cm.MembershipId
			INNER JOIN cfgCenter cent
				ON cent.CenterID = so.CenterID
			INNER JOIN lkpTimeZone tz ON cent.TimeZoneID = tz.TimeZoneID
			INNER JOIN dbo.lkpRegion r
				ON cent.RegionID = r.RegionID
			JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID
			LEFT JOIN datClientEFT eft
				ON so.ClientMembershipGUID = eft.ClientMembershipGUID
			LEFT JOIN  lkpFeePayCycle pc
				ON pc.FeePayCycleId = eft.FeePayCycleId
			LEFT JOIN lkpEFTAccountType at
				ON at.EFTAccountTypeID = eft.EFTAccountTypeID
			LEFT JOIN dbo.cfgConfigurationMembership cfg
				ON cfg.MembershipID = mem.MembershipID
			OUTER APPLY
			(
				SELECT
					doc.*,
					dt.DocumentTypeDescription,
					dt.DocumentTypeDescriptionShort
				FROM datClientMembershipDocument doc
					INNER JOIN lkpDocumentType dt ON dt.DocumentTypeId = doc.DocumentTypeId
				WHERE doc.ClientMembershipGUID = so.ClientMembershipGUID
					AND dt.DocumentTypeDescriptionShort = 'Agreement'
			) cmDoc
		WHERE so.CenterID IN(SELECT CenterID FROM #Centers)
			AND soType.SalesOrderTypeDescriptionShort = @MembershipOrderType
			AND (cfg.MembershipID = @MembershipID
					OR @MembershipID IS NULL)

			AND so.OrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate

			--AND dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate AND @EndDate

			--AND DATEADD(Hour,
			--	CASE WHEN tz.[UsesDayLightSavingsFlag] = 0
			--		THEN ( tz.[UTCOffset] )
			--	WHEN DATEPART(WK, so.OrderDate) <= 10
			--					OR DATEPART(WK, so.OrderDate) >= 45
			--		THEN ( tz.[UTCOffset] )
			--	ELSE ( ( tz.[UTCOffset] ) + 1 ) END,
			--	so.OrderDate) BETWEEN @StartDate AND @EndDate

			AND mem.MembershipID NOT IN(SELECT MembershipID FROM dbo.cfgMembership WHERE MembershipDescription LIKE '%ShowNoSale%')
			AND cmDoc.ClientMembershipDocumentGUID IS NULL
	END
	ELSE
	BEGIN --Show all - not just exceptions
		SELECT cent.RegionID
		,	r.RegionDescription	AS 'RegionDescription'
		,	cent.CenterID AS 'CenterID'
		,	cent.CenterDescriptionFullCalc AS 'CenterDescriptionFullCalc'
		,	c.ClientIdentifier AS 'ClientIdentifier'
		,	c.ClientFullNameCalc AS 'ClientFullNameCalc'
		,	c.GenderID AS 'GenderID'
		,	g.GenderDescription AS 'GenderDescription'
		,	mem.MembershipDescription AS 'MembershipDescription'
		,	so.OrderDate AS 'OrderDate'
		,	cm.EndDate AS 'EndDate'
		,	sc.SalesCodeDescription AS 'SalesCodeDescription'
		,	dbo.fn_GetPreviousAppointmentDate(cm.ClientMembershipGUID) AS 'LastAppointmentDate'
		,	dbo.fn_GetNextAppointmentDate(cm.ClientMembershipGUID) AS 'NextAppointmentDate'
		,	CASE at.EFTAccountTypeID WHEN 1 THEN at.EFTAccountTypeDescription + ' ' + ISNULL(CAST(DATEPART(MM, eft.AccountExpiration) AS VARCHAR) + '/' + RIGHT(CAST(DATEPART(YY, eft.AccountExpiration) AS VARCHAR),2),'')
				ELSE at.EFTAccountTypeDescription END AS 'EFTType'
		,	pc.FeePayCycleDescription AS 'Paycycle'
		,	cfg.IsContractRequired AS 'IsContractRequired'
		, 	cm.MonthlyFee AS 'MonthlyFee'
		,	c.ARBalance AS 'ARBalance'
		,	cm.ContractPaidAmount AS 'ContractBalance'
		,	cmDoc.DocumentTypeDescription AS 'DocumentType'
		, 	cmDoc.[Description] AS 'DocumentDescription'
		,	CAST(cmDoc.CreateDate AS DATE)  AS 'DocumentUploadDate'
		,	cmDoc.ClientMembershipDocumentGUID
	FROM datSalesOrder so
		INNER JOIN datSalesOrderDetail sod
			ON so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN #SalesCodes sc
			ON sc.SalesCodeId = sod.SalesCodeId
		INNER JOIN lkpSalesOrderType soType
			ON soType.SalesOrderTypeID = so.SalesOrderTypeID
		INNER JOIN datClient c
			ON c.ClientGUID = so.ClientGUID
		INNER JOIN dbo.lkpGender g
			ON c.GenderID = g.GenderID
		INNER JOIN datClientMembership cm
			ON so.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN cfgMembership mem
			ON mem.MembershipId = cm.MembershipId
		INNER JOIN cfgCenter cent
			ON cent.CenterID = so.CenterID
		INNER JOIN lkpTimeZone tz ON cent.TimeZoneID = tz.TimeZoneID
		INNER JOIN dbo.lkpRegion r
			ON cent.RegionID = r.RegionID
		JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID
		LEFT JOIN datClientEFT eft
			ON so.ClientMembershipGUID = eft.ClientMembershipGUID
		LEFT JOIN  lkpFeePayCycle pc
			ON pc.FeePayCycleId = eft.FeePayCycleId
		LEFT JOIN lkpEFTAccountType at
			ON at.EFTAccountTypeID = eft.EFTAccountTypeID
		LEFT JOIN dbo.cfgConfigurationMembership cfg
			ON cfg.MembershipID = mem.MembershipID
		OUTER APPLY
		(
			SELECT
				doc.*,
				dt.DocumentTypeDescription,
				dt.DocumentTypeDescriptionShort
			FROM datClientMembershipDocument doc
				INNER JOIN lkpDocumentType dt ON dt.DocumentTypeId = doc.DocumentTypeId
			WHERE doc.ClientMembershipGUID = so.ClientMembershipGUID
				AND dt.DocumentTypeDescriptionShort = 'Agreement'
		) cmDoc
	WHERE so.CenterID IN(SELECT CenterID FROM #Centers)
		AND soType.SalesOrderTypeDescriptionShort = @MembershipOrderType
		AND (cfg.MembershipID = @MembershipID
				OR @MembershipID IS NULL)

		AND so.OrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
		--AND dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate AND @EndDate

		--AND DATEADD(Hour,
		--	CASE WHEN tz.[UsesDayLightSavingsFlag] = 0
		--		THEN ( tz.[UTCOffset] )
		--	WHEN DATEPART(WK, so.OrderDate) <= 10
		--					OR DATEPART(WK, so.OrderDate) >= 45
		--		THEN ( tz.[UTCOffset] )
		--	ELSE ( ( tz.[UTCOffset] ) + 1 ) END,
		--	so.OrderDate) BETWEEN @StartDate AND @EndDate

		AND mem.MembershipID NOT IN(SELECT MembershipID FROM dbo.cfgMembership WHERE MembershipDescription LIKE '%ShowNoSale%')
	END

END
GO
