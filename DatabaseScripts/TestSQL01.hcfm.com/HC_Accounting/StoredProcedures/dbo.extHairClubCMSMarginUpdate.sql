/* CreateDate: 03/29/2013 12:52:49.690 , ModifyDate: 03/29/2013 13:29:26.890 */
GO
/*
==============================================================================
PROCEDURE:				extHairClubCMSMarginUpdate

DESTINATION SERVER:		SQL05

DESTINATION DATABASE: 	HC_Accounting

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 09/11/2012

LAST REVISION DATE: 	 03/12/2013

==============================================================================
DESCRIPTION:	Update Client Profitability table
==============================================================================
NOTES:
		* 09/11/2012 MVT - Created
		* 10/03/2012 MVT - Updated to fix financials. Exclude Sale Orders that are
						not tendered.
		* 10/11/2012 MVT - Added update logic for additional fields in Client Profitability.
		* 12/03/2012 MVT - Modified to use appointments to determine Count, Duration, and Cost for
					appointments
		* 12/20/2012 MVT - Modified to use sales orders to determine if appointment count and
						duration
		* 12/21/2012 MVT - changed "Profit" column to "Margin", added Margin_PCT column. Removed AppointmentCount column.
						Changed AppointmentDuration and AppointmentCost to ServiceDuration and ServiceCost.  Fixed calculations
						for revenue and Counts.
		* 03/12/2013 MVT - Updated the appointment per minute rate to $0.50
		* 03/14/2013 MVT - Added condition to exclude memberships prior to 1/1/2008
		* 03/29/2013 MVT - Moved proc from SQL01 HairClubCMS DB to SQL05.  Renamed from dbaClientProfitability

==============================================================================
SAMPLE EXECUTION:
EXEC [extHairClubCMSMarginUpdate] 0
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSMarginUpdate]
(
	@IsInitialUpdate bit
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @APPOINTMENT_RATE_PER_MINUTE AS Decimal(20,4) = 0.500

	-- Import only memberships starting on @MembershipStartDate and later.
	DECLARE @MembershipStartDate AS DateTime = '1/1/2008'


	DECLARE @Today AS Date = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

	-- Insert Client Memberships that do not already exist
	INSERT INTO [dbo].[dbaMargin]
			   ([ClientGUID]
			   ,[ClientIdentifier]
			   ,[ClientMembershipGUID]
			   ,[MembershipID]
			   ,[MembershipDescription]
			   ,[MembershipIdentifier]
			   ,[IsMembershipActive]
			   ,[MembershipStartDate]
			   ,[MembershipEndDate]
			   ,[MembershipDuration]
			   ,[Status]
			   ,[PaymentsTotal]
			   ,[RefundsTotal]
			   ,[ServiceRevenue]
			   ,[ProductRevenue]
			   ,[HairOrderCount]
			   ,[HairOrderTotalCost]
			   ,[FullService]
			   ,[Applications]
			   ,[Services]
			   ,[ServiceDuration]
			   ,[ServiceCost]
			   ,[CreateDate]
			   ,[CreateUser]
			   ,[LastUpdate]
			   ,[LastUpdateUser]
			   ,[ClientCenterId]
			   ,[BusinessSegment]
			   ,[ClientName])
		 SELECT c.ClientGUID
				, c.ClientIdentifier
				, cm.ClientMembershipGUID
				, m.MembershipID
				, m.MembershipDescription
				, cm.ClientMembershipIdentifier -- Membership Identifier
				, CASE WHEN cm.IsActiveFlag = 1 AND cm.BeginDate <= @Today AND cm.EndDate >= @Today THEN 1 ELSE 0 END
				, cm.BeginDate
				, cm.EndDate
				, 0 -- Duration
				, NULL -- Status
				, 0
				, 0
				, 0
				, 0
				, 0
				, 0
				, 0 -- Full Service
				, 0 -- Applications
				, 0 -- Services
				, 0 -- Appt Duration
				, 0 -- Appt Cost
				, GETUTCDATE()
				, 'sa'
				, GETUTCDATE()
				, 'sa'
				, c.CenterId
				, bs.[BusinessSegmentDescription]
				, c.[ClientFullNameAltCalc]
			FROM [HairClubCMS].dbo.datClient c
				INNER JOIN [HairClubCMS].dbo.datClientMembership cm ON c.ClientGUID = cm.ClientGUID
				INNER JOIN [HairClubCMS].dbo.cfgMembership m	ON m.MembershipID = cm.MembershipID
				INNER JOIN [HairClubCMS].dbo.lkpBusinessSegment bs ON bs.BusinessSegmentID = m.BusinessSegmentID
				LEFT JOIN dbaMargin cp ON cp.ClientMembershipGUID = cm.ClientMembershipGUID
			WHERE cm.[BeginDate] is not NULL AND cm.[BeginDate] >= @MembershipStartDate
				AND cp.ClientMembershipGUID IS NULL -- Only insert new client memberships


	-- Update if Membership is still active
	UPDATE cp SET
		cp.IsMembershipActive = CASE WHEN cm.IsActiveFlag = 1 AND cm.BeginDate <= @Today AND cm.EndDate >= @Today THEN 1 ELSE 0 END
	FROM dbaMargin cp
		INNER JOIN [HairClubCMS].dbo.datClientMembership cm ON cp.ClientMembershipGUID = cm.ClientMembershipGUID


	-- Update Profitability for Active Memberships or for Memberships that end today.
	UPDATE cp SET
		-- Determine duration up to today for active memberships
		cp.MembershipDuration =	CASE WHEN cm.EndDate IS NULL THEN 0
									 WHEN cm.EndDate < @Today THEN DATEDIFF (Day, cm.BeginDate , cm.EndDate )
								ELSE DATEDIFF (Day, cm.BeginDate , @TODAY ) END
		, cp.[Status] = cms.[ClientMembershipStatusDescription]
		, cp.PaymentsTotal = (SELECT ISNULL(SUM(ISNULL(sod.ExtendedPriceCalc, 0.0)), 0.0)
					FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
							INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
							Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot
															WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
							INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE so.IsVoidedFlag = 0
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 AND sod.ExtendedPriceCalc > 0
						 AND sct.SalesCodeTypeDescriptionShort = 'Membership')
		, cp.RefundsTotal = (SELECT ISNULL(SUM(ABS(ISNULL(sod.ExtendedPriceCalc, 0.0))), 0.0)
					FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
							INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
							Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
															WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
							INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE so.IsVoidedFlag = 0
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 AND sod.ExtendedPriceCalc < 0
						 AND sct.SalesCodeTypeDescriptionShort = 'Membership')
		, cp.ServiceRevenue = (SELECT ISNULL(SUM(ISNULL(sod.ExtendedPriceCalc, 0.0)), 0.0)
					FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
							INNER JOIN  [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
							Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
															WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
							INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE so.IsVoidedFlag = 0
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 --AND sod.ExtendedPriceCalc > 0
						 AND sct.SalesCodeTypeDescriptionShort = 'Service')
		, cp.ProductRevenue = (SELECT ISNULL(SUM(ISNULL(sod.ExtendedPriceCalc, 0.0)), 0.0)
					FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
							INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
							Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
															WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
							INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE so.IsVoidedFlag = 0
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 --AND sod.ExtendedPriceCalc > 0
						 AND sct.SalesCodeTypeDescriptionShort = 'Product')
		, cp.HairOrderCount = (SELECT COUNT(*) FROM [HairClubCMS].dbo.datHairSystemOrder hso with (nolock)
								WHERE hso.ClientMembershipGUID = cp.ClientMembershipGUID)
		, cp.HairOrderTotalCost = (SELECT ISNULL(SUM(ISNULL(hso.CostActual, 0.0)), 0.0) FROM [HairClubCMS].dbo.datHairSystemOrder hso with (nolock)
								WHERE hso.ClientMembershipGUID = cp.ClientMembershipGUID)
		, cp.ServiceDuration = (SELECT ISNULL(SUM(ISNULL(sc.[ServiceDuration], 0)), 0)
									FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
											INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
											Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
															WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
											INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
											INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
											INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
											INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
									WHERE so.IsVoidedFlag = 0
										 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
										 AND sct.SalesCodeTypeDescriptionShort = 'Service')
		, cp.FullService = (SELECT COUNT(sc.SalesCodeId)
					FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
							INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
							Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
											WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
							INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE so.IsVoidedFlag = 0
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 AND sc.[SalesCodeDescriptionShort] IN ('SVC','EXTLSVC','SVCPCP','EXTMEMSVC','LSVC','EXTSVC')
						 AND sct.SalesCodeTypeDescriptionShort = 'Service')
		, cp.Applications = (SELECT COUNT(sc.SalesCodeId)
					FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
							INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
							Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
											WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
							INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE so.IsVoidedFlag = 0
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 AND sc.[SalesCodeDescriptionShort] IN ('NB1A','APP')
						 AND sct.SalesCodeTypeDescriptionShort = 'Service')
		, cp.[Services] = (SELECT COUNT(sc.SalesCodeId)
					FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
							INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
							Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
											WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
							INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE so.IsVoidedFlag = 0
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 AND sct.SalesCodeTypeDescriptionShort = 'Service')

		, cp.LastUpdate = GETUTCDATE()
		, cp.LastUpdateUser = 'sa'
	FROM dbaMargin cp
		INNER JOIN [HairClubCMS].dbo.datClientMembership cm with (nolock) ON cp.ClientMembershipGUID = cm.ClientMembershipGUID
		LEFT JOIN [HairClubCMS].dbo.[lkpClientMembershipStatus] cms with (nolock) ON cms.[ClientMembershipStatusID] = cm.[ClientMembershipStatusID]
	WHERE @IsInitialUpdate = 1
		OR cp.IsMembershipActive = 1  -- Only update Active memberships or memberships that ended today.
		OR cm.EndDate = @Today


	-- Update Appointment Cost
	UPDATE cp SET
		 cp.ServiceCost = (CAST(ISNULL(cp.ServiceDuration,0) AS Decimal(20,4)) * @APPOINTMENT_RATE_PER_MINUTE)
	FROM dbaMargin cp
		INNER JOIN [HairClubCMS].dbo.datClientMembership cm with (nolock) ON cp.ClientMembershipGUID = cm.ClientMembershipGUID
	WHERE @IsInitialUpdate = 1
		OR cp.IsMembershipActive = 1  -- Only update Active memberships or memberships that ended today.
		OR cm.EndDate = @Today

END
GO
