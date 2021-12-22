/***********************************************************************

PROCEDURE:				rptOrdersForAgreementAudit

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

DATE IMPLEMENTED: 		02/17/2014

--------------------------------------------------------------------------------------------------------
NOTES: 	Return Agreement Audit detail  This report is based on the stored procedure selOrdersForAgreementAudit
		*** When Updating this proc you have to update rptFeeExceptions too.
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

rptOrdersForAgreementAudit '201,203,204', '12/1/2014', '12/31/2014', 0, 1

rptOrdersForAgreementAudit '201,203,204', '12/1/2014', '12/31/2014', 0, 0

rptOrdersForAgreementAudit '201', '12/1/2014', '12/31/2014', 0, 0

***********************************************************************/
CREATE PROCEDURE [dbo].[rptOrdersForAgreementAudit]
	@CenterId as NVARCHAR(MAX),
	@StartDate as datetime,
	@EndDate as datetime,
	@IncludeExceptionsOnly as bit,
	@IncludeAllCorpCentersOnly as bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @MembershipOrderType nvarchar(2) = 'MO'
	DECLARE @Today datetime

	--Find selected centers
	IF @IncludeAllCorpCentersOnly=0
	BEGIN

		DECLARE @Centers TABLE
				(
					CenterId INT NOT NULL
				)
		INSERT INTO @Centers (CenterId)
		SELECT item FROM fnSplit(@CenterID,',')

	END

	--Find Sales Codes
	DECLARE @SalesCodes TABLE
		(
			SalesCodeId int NOT NULL,
			SalesCodeDescriptionShort nvarchar(10) NOT NULL,
			SalesCodeDescription nvarchar(100) NOT NULL
		)

	SET @EndDate = DATEADD(Second, -1, DATEADD(Day, 1, @EndDate))

	SELECT @Today = (DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())))


    SELECT  TimeZoneID
    ,       [UTCOffset]
    ,       [UsesDayLightSavingsFlag]
    ,       [IsActiveFlag]
    ,       dbo.GetUTCFromLocal(@StartDate, [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCStartDate]
    ,       dbo.GetUTCFromLocal(DATEADD(SECOND, 86399, @EndDate), [UTCOffset], [UsesDayLightSavingsFlag]) AS [UTCEndDate]
    INTO    #UTCDateParms
    FROM    dbo.lkpTimeZone
    WHERE   [IsActiveFlag] = 1;


	INSERT INTO @SalesCodes
		(SalesCodeId, SalesCodeDescriptionShort, SalesCodeDescription)
	SELECT SalesCodeId, SalesCodeDescriptionShort, SalesCodeDescription
		FROM cfgSalesCode
		WHERE SalesCodeDescriptionShort IN
					('INITASG', 'GUARANTEE','POSTEXTXU','CONV','POSTEXT','POSTEL',
						'NB2R', 'UPDCXL','NEWMEM','PCPXD','BOSASG','RENEW','PCPXU', 'NB2XU')



	SELECT
		cent.CenterId,
		cent.CenterDescriptionFullCalc as CenterDescription,
		c.ClientFullNameCalc as ClientName,
		mem.MembershipDescription as Membership,
		so.OrderDate as SaleDate,
		cm.EndDate as ContractEndDate,
		cm.ContractPrice as ContractPrice,
		cm.MonthlyFee as MonthlyFee,
		pc.FeePayCycleDescription as PayCycle,
		sc.SalesCodeDescription,
		cmDoc.DocumentTypeDescription as DocumentType,
		cmDoc.[Description] as DocumentDescription,
		cmDoc.CreateDate as DocumentUploadDate,
		cmDoc.ClientMembershipDocumentGUID,
		cm.ContractPrice - ISNULL(cm.ContractPaidAmount,0) as ContractBalance,
		gen.GenderDescriptionShort,
		at.EFTAccountTypeDescription,
		c.ARBalance,
		last_appt.AppointmentDate AS LastAppointmentDate,
		next_appt.AppointmentDate AS NextAppointmentDate
	FROM datSalesOrder so
		INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN @SalesCodes sc ON sc.SalesCodeId = sod.SalesCodeId
		INNER JOIN lkpSalesOrderType soType ON soType.SalesOrderTypeID = so.SalesOrderTypeID
		INNER JOIN datClient c ON c.ClientGUID = so.ClientGUID
		INNER JOIN datClientMembership cm ON so.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN cfgMembership mem ON mem.MembershipId = cm.MembershipId
		INNER JOIN cfgCenter cent ON cent.CenterId = so.CenterId
		INNER JOIN cfgConfigurationCenter centConfig ON centConfig.CenterID = cent.CenterID
		INNER JOIN lkpCenterBusinessType cbt ON cbt.CenterBusinessTypeID = centConfig.CenterBusinessTypeID
		INNER JOIN lkpTimeZone tz ON cent.TimeZoneID = tz.TimeZoneID
		JOIN #UTCDateParms AS [UTCDateParms] ON UTCDateParms.TimeZoneID = tz.TimeZoneID
		LEFT JOIN lkpGender gen ON gen.GenderID = c.GenderID
		LEFT JOIN datClientEFT eft ON eft.ClientMembershipGUID = so.ClientMembershipGUID
		LEFT JOIN lkpEFTAccountType at ON at.EFTAccountTypeID = eft.EFTAccountTypeID
		LEFT JOIN  lkpFeePayCycle pc ON pc.FeePayCycleId = eft.FeePayCycleId
		OUTER APPLY
		(
			SELECT Top(1) oa_appt.*
				FROM datAppointment oa_appt
				WHERE oa_appt.AppointmentDate <= @Today
					 AND oa_appt.ClientMembershipGUID = cm.ClientMembershipGUID
					 AND ISNULL(oa_appt.IsDeletedFlag,0) = 0
				ORDER BY oa_appt.AppointmentDate desc
		) last_appt
		OUTER APPLY
		(
			SELECT Top(1) oa_appt.*
				FROM datAppointment oa_appt
				WHERE oa_appt.AppointmentDate > @Today
					 AND oa_appt.ClientMembershipGUID = cm.ClientMembershipGUID
					 AND ISNULL(oa_appt.IsDeletedFlag,0) = 0
				ORDER BY oa_appt.AppointmentDate
		) next_appt
		OUTER APPLY
		(
			SELECT Top(1)
				doc.*,
				dt.DocumentTypeDescription,
				dt.DocumentTypeDescriptionShort
			FROM datClientMembershipDocument doc
				INNER JOIN lkpDocumentType dt ON dt.DocumentTypeId = doc.DocumentTypeId
			WHERE doc.ClientMembershipGUID = so.ClientMembershipGUID
				AND dt.DocumentTypeDescriptionShort = 'Agreement'
		) cmDoc
	WHERE ((@IncludeAllCorpCentersOnly = 1 AND cbt.CenterBusinessTypeDescriptionShort = 'cONEctCorp')
		OR (@IncludeAllCorpCentersOnly = 0 AND  so.CenterId IN(SELECT CenterId FROM @Centers)))
		AND soType.SalesOrderTypeDescriptionShort = @MembershipOrderType
		AND (@IncludeExceptionsOnly = 0 OR
				(@IncludeExceptionsOnly = 1 AND cmDoc.ClientMembershipDocumentGUID IS NULL))

		AND so.OrderDate BETWEEN UTCDateParms.UTCStartDate AND UTCDateParms.UTCEndDate
		--AND dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) BETWEEN @StartDate AND @EndDate

		--AND DATEADD(Hour,
		--					CASE WHEN tz.[UsesDayLightSavingsFlag] = 0
		--						THEN ( tz.[UTCOffset] )
		--					WHEN DATEPART(WK, so.OrderDate) <= 10
		--									OR DATEPART(WK, so.OrderDate) >= 45
		--						THEN ( tz.[UTCOffset] )
		--					ELSE ( ( tz.[UTCOffset] ) + 1 ) END,
		--				so.OrderDate) BETWEEN @StartDate AND @EndDate
	Order By cent.CenterID, so.OrderDate

END
