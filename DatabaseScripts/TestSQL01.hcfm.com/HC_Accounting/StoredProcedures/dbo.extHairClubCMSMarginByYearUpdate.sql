/* CreateDate: 07/17/2013 18:02:12.360 , ModifyDate: 07/24/2013 14:17:44.740 */
GO
/*
==============================================================================
PROCEDURE:				extHairClubCMSMarginByYearUpdate

DESTINATION SERVER:		SQL05

DESTINATION DATABASE: 	HC_Accounting

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 07/17/2012

LAST REVISION DATE: 	 07/17/2012

==============================================================================
DESCRIPTION:	Update Client Profitability table
==============================================================================
NOTES:
		* 07/17/2013 MVT - Created
==============================================================================
SAMPLE EXECUTION:
EXEC [extHairClubCMSMarginByYearUpdate] 1
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSMarginByYearUpdate]
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


	DECLARE @WriteOffSalesCodes TABLE (
		SalesCodeID INT
	)

	DECLARE @NewRecords TABLE (
		ClientMembershipGuid uniqueidentifier,
		[Year] int
	)


	-- Find all Write off sales Codes.
	INSERT INTO @WriteOffSalesCodes (SalesCodeID)
	SELECT SalesCodeID
	FROM [HairClubCMS].dbo.cfgSalesCode sc
		INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
	WHERE (scd.SalesCodeDepartmentID = 2020 OR scd.SalesCodeDepartmentID = 7040)
			AND sc.SalesCodeDescriptionShort like '%WO'  -- Department (2020 or 7040 )and ending in %WO



	INSERT INTO @NewRecords (ClientMembershipGuid, [Year])
		(
			-- BEGIN DATE
			SELECT cm.ClientMembershipGuid, YEAR(cm.BeginDate) as [Year]
			FROM [HairClubCMS].dbo.datClient c
						INNER JOIN [HairClubCMS].dbo.datClientMembership cm ON c.ClientGUID = cm.ClientGUID
						INNER JOIN [HairClubCMS].dbo.cfgMembership m	ON m.MembershipID = cm.MembershipID
						INNER JOIN [HairClubCMS].dbo.lkpBusinessSegment bs ON bs.BusinessSegmentID = m.BusinessSegmentID
						LEFT JOIN dbaMarginByYear cp ON cp.ClientMembershipGUID = cm.ClientMembershipGUID AND cp.[Year] = YEAR(cm.BeginDate)
					WHERE cm.[BeginDate] is not NULL AND cm.[BeginDate] >= @MembershipStartDate
						AND cp.ClientMembershipGUID IS NULL -- Only insert new client memberships

			UNION

			-- END DATE
			SELECT cm.ClientMembershipGuid, YEAR(cm.EndDate) as [Year]
			FROM [HairClubCMS].dbo.datClient c
						INNER JOIN [HairClubCMS].dbo.datClientMembership cm ON c.ClientGUID = cm.ClientGUID
						INNER JOIN [HairClubCMS].dbo.cfgMembership m	ON m.MembershipID = cm.MembershipID
						INNER JOIN [HairClubCMS].dbo.lkpBusinessSegment bs ON bs.BusinessSegmentID = m.BusinessSegmentID
						LEFT JOIN dbaMarginByYear cp ON cp.ClientMembershipGUID = cm.ClientMembershipGUID AND cp.[Year] = YEAR(cm.EndDate)
					WHERE cm.[BeginDate] is not NULL AND cm.[BeginDate] >= @MembershipStartDate
						AND cp.ClientMembershipGUID IS NULL -- Only insert new client memberships
		)



	-- Insert Client Memberships that do not already exist
	INSERT INTO [dbo].[dbaMarginByYear]
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
			   ,[ClientName]
			   ,[Gender]
			   ,[Age]
			   ,[WriteOff]
			   ,[Year])
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
				, g.[GenderDescription]  -- Genger
				, (floor(datediff(week,c.[DateOfBirth],c.CreateDate)/(52)))-- Age
				, 0
				, nr.[Year]
			FROM @NewRecords nr
				INNER JOIN [HairClubCMS].dbo.datClientMembership cm ON nr.ClientMembershipGuid = cm.ClientMembershipGuid
				INNER JOIN [HairClubCMS].dbo.datClient c ON c.ClientGuid = cm.ClientGuid
				INNER JOIN [HairClubCMS].dbo.cfgMembership m	ON m.MembershipID = cm.MembershipID
				INNER JOIN [HairClubCMS].dbo.lkpBusinessSegment bs ON bs.BusinessSegmentID = m.BusinessSegmentID
				LEFT JOIN [HairClubCMS].dbo.lkpGender g ON g.GenderID = c.GenderID
			WHERE cm.[BeginDate] is not NULL AND cm.[BeginDate] >= @MembershipStartDate
			ORDER BY nr.ClientMembershipGuid, nr.[Year]


	-- Update Age Range if not set
	UPDATE cp SET
		cp.[AgeRangeKey] = ar.[AgeRangeKey],
		cp.[AgeRangeDescription] = ar.[AgeRangeDescription]
	FROM dbaMarginByYear cp
		LEFT JOIN  [HC_BI_ENT_DDS].bi_ent_dds.DimAgeRange ar ON ISNULL(cp.Age, 0) >= ar.BeginAge AND ISNULL(cp.Age, 0) <= ar.EndAge
	WHERE cp.AgeRangeKey IS NULL

	-- Update if Membership is still active
	UPDATE cp SET
		cp.IsMembershipActive = CASE WHEN cm.IsActiveFlag = 1 AND cm.BeginDate <= @Today AND cm.EndDate >= @Today THEN 1 ELSE 0 END
	FROM dbaMarginByYear cp
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
					WHERE so.IsVoidedFlag = 0 AND so.IsClosedFlag = 1 AND YEAR(so.OrderDate) = cp.[Year]
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 AND sod.ExtendedPriceCalc > 0
						 AND scd.SalesCodeDepartmentID = 2020)   -- Department 2020
						-- AND sct.SalesCodeTypeDescriptionShort = 'Membership')
		, cp.RefundsTotal = (SELECT ISNULL(SUM(ABS(ISNULL(sod.ExtendedPriceCalc, 0.0))), 0.0)
					FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
							INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
							Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
															WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
							INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE so.IsVoidedFlag = 0 AND so.IsClosedFlag = 1 AND YEAR(so.OrderDate) = cp.[Year]
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 AND sod.ExtendedPriceCalc < 0
						 AND scd.SalesCodeDepartmentID = 2020 AND sc.SalesCodeDescriptionShort not like '%WO')	-- Department 2020	and not ending in %WO
						 --AND sct.SalesCodeTypeDescriptionShort = 'Membership')
		, cp.ServiceRevenue = (SELECT ISNULL(SUM(ISNULL(sod.ExtendedPriceCalc, 0.0)), 0.0)
					FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
							INNER JOIN  [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
							Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
															WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
							INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE so.IsVoidedFlag = 0 AND so.IsClosedFlag = 1 AND YEAR(so.OrderDate) = cp.[Year]
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 --AND sod.ExtendedPriceCalc > 0
						 AND scd.SalesCodeDepartmentID >= 5000 AND scd.SalesCodeDepartmentID < 5100)	--- Department 50XX
						-- AND sct.SalesCodeTypeDescriptionShort = 'Service')
		, cp.ProductRevenue = (SELECT ISNULL(SUM(ISNULL(sod.ExtendedPriceCalc, 0.0)), 0.0)
					FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
							INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
							Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
															WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
							INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE so.IsVoidedFlag = 0 AND so.IsClosedFlag = 1 AND YEAR(so.OrderDate) = cp.[Year]
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 --AND sod.ExtendedPriceCalc > 0
						 AND scd.SalesCodeDepartmentID >= 3000 AND scd.SalesCodeDepartmentID < 3100)	--- Department 30XX
						-- AND sct.SalesCodeTypeDescriptionShort = 'Product')
		, cp.HairOrderCount = (SELECT COUNT(*) FROM [HairClubCMS].dbo.datHairSystemOrder hso with (nolock)
								WHERE hso.ClientMembershipGUID = cp.ClientMembershipGUID AND YEAR(hso.HairSystemOrderDate) = cp.[Year])
		, cp.HairOrderTotalCost = (SELECT ISNULL(SUM(ISNULL(hso.CostActual, 0.0)), 0.0) FROM [HairClubCMS].dbo.datHairSystemOrder hso with (nolock)
								WHERE hso.ClientMembershipGUID = cp.ClientMembershipGUID AND YEAR(hso.HairSystemOrderDate) = cp.[Year])
		, cp.ServiceDuration = (SELECT ISNULL(SUM(ISNULL(sc.[ServiceDuration], 0)), 0)
									FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
											INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
											Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
															WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
											INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
											INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
											INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
											INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
									WHERE so.IsVoidedFlag = 0 AND so.IsClosedFlag = 1 AND YEAR(so.OrderDate) = cp.[Year]
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
					WHERE so.IsVoidedFlag = 0 AND so.IsClosedFlag = 1 AND YEAR(so.OrderDate) = cp.[Year]
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
					WHERE so.IsVoidedFlag = 0 AND so.IsClosedFlag = 1 AND YEAR(so.OrderDate) = cp.[Year]
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
					WHERE so.IsVoidedFlag = 0 AND so.IsClosedFlag = 1 AND YEAR(so.OrderDate) = cp.[Year]
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 AND sct.SalesCodeTypeDescriptionShort = 'Service')

		, cp.LastUpdate = GETUTCDATE()
		, cp.LastUpdateUser = 'sa'
		, cp.WriteOff = (SELECT ISNULL(SUM(ABS(ISNULL(sod.ExtendedPriceCalc, 0.0))), 0.0)
					FROM [HairClubCMS].dbo.datSalesOrder so with (nolock)
							INNER JOIN [HairClubCMS].dbo.datSalesOrderDetail sod with (nolock) ON so.SalesOrderGUID = sod.SalesOrderGUID
							Cross Apply (Select Top(1) * from [HairClubCMS].dbo.datSalesOrderTender sot with (nolock)
															WHERE sot.SalesOrderGUID = so.SalesOrderGUID) tender
							INNER JOIN [HairClubCMS].dbo.cfgSalesCode sc with (nolock) ON sc.SalesCodeID = sod.SalesCodeID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDepartment scd with (nolock) ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeDivision div with (nolock) ON div.SalesCodeDivisionID = scd.SalesCodeDivisionID
							INNER JOIN [HairClubCMS].dbo.lkpSalesCodeType sct with (nolock) ON sct.SalesCodeTypeID = sc.SalesCodeTypeID
					WHERE so.IsVoidedFlag = 0 AND so.IsClosedFlag = 1 AND YEAR(so.OrderDate) = cp.[Year]
						 AND so.ClientMembershipGUID = cp.ClientMembershipGUID
						 AND sc.SalesCodeID in (SELECT SalesCodeID FROM @WriteOffSalesCodes))
	FROM dbaMarginByYear cp
		INNER JOIN [HairClubCMS].dbo.datClientMembership cm with (nolock) ON cp.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN [HairClubCMS].dbo.datClient c with (nolock) ON c.ClientGuid = cp.ClientGuid
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
