/* CreateDate: 07/26/2013 13:19:57.943 , ModifyDate: 02/07/2014 15:20:24.900 */
GO
/*
==============================================================================
PROCEDURE:				[extHairClubCMSMarginByYearUpdate_FromFactTable]

DESTINATION SERVER:		SQL05

DESTINATION DATABASE: 	HC_Accounting

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 07/26/2012

LAST REVISION DATE: 	 07/26/2012

==============================================================================
DESCRIPTION:	Update Client Profitability table
==============================================================================
NOTES:
		* 07/26/2013 MVT - Created
==============================================================================
SAMPLE EXECUTION:
EXEC [extHairClubCMSMarginByYearUpdate_FromFactTable] 1
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSMarginByYearUpdate_FromFactTable]
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
		SalesCodeKey INT
	)

	DECLARE @NewRecords TABLE (
		ClientMembershipKey int,
		ClientMembershipGuid uniqueidentifier,
		[Year] int
	)


	-- Find all Write off sales Codes.
	INSERT INTO @WriteOffSalesCodes (SalesCodeKey)
	SELECT [SalesCodeKey]
	FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesCode] dsc
	WHERE (dsc.[SalesCodeDepartmentSSID] = 2020 OR dsc.[SalesCodeDepartmentSSID] = 7040)
			AND dsc.SalesCodeDescriptionShort like '%WO'  -- Department (2020 or 7040 )and ending in %WO



	INSERT INTO @NewRecords (ClientMembershipKey, ClientMembershipGuid, [Year])
		(
			-- BEGIN DATE
			SELECT dcm.ClientMembershipKey, dcm.ClientMembershipSSID, YEAR(dcm.ClientMembershipBeginDate) as [Year]
			FROM [HC_BI_CMS_DDS].bi_cms_dds.DimClientMembership dcm with (nolock)
						LEFT JOIN dbaMarginByYear cp with (nolock) ON cp.ClientMembershipGUID = dcm.ClientMembershipSSID AND cp.[Year] = YEAR(dcm.ClientMembershipBeginDate)
					WHERE dcm.[ClientMembershipBeginDate] is not NULL AND dcm.[ClientMembershipBeginDate] >= @MembershipStartDate
						AND cp.ClientMembershipGUID IS NULL -- Only insert new client memberships

			UNION

			-- END DATE
			SELECT dcm.ClientMembershipKey, dcm.ClientMembershipSSID, YEAR(dcm.ClientMembershipEndDate) as [Year]
			FROM [HC_BI_CMS_DDS].bi_cms_dds.DimClientMembership dcm with (nolock)
						LEFT JOIN dbaMarginByYear cp with (nolock) ON cp.ClientMembershipGUID = dcm.ClientMembershipSSID AND cp.[Year] = YEAR(dcm.ClientMembershipEndDate)
					WHERE dcm.[ClientMembershipBeginDate] is not NULL AND dcm.[ClientMembershipBeginDate] >= @MembershipStartDate
						AND cp.ClientMembershipGUID IS NULL -- Only insert new client memberships
		)



	-- Insert Client Memberships that do not already exist
	INSERT INTO [dbo].[dbaMarginByYear]
			   ([ClientGUID]
			   ,[ClientIdentifier]
			   ,[ClientMembershipGUID]
			   ,[ClientMembershipKey]
			   ,[MembershipID]
			   ,[MembershipDescription]
			   ,[MembershipIdentifier]
			   ,[IsMembershipActive]
			   ,[MembershipStartDate]
			   ,[MembershipEndDate]
			   ,[MembershipDuration]
			   ,[Status]
			   ,[NetMembershipAmount]
			   ,[PaymentsTotal]
			   ,[RefundsTotal]
			   ,[ServiceRevenue]
			   ,[ProductRevenue]
			   ,[HairOrderCount]
			   ,[HairOrderTotalCost]
			   ,[FullService]
			   ,[Applications]
			   ,[NB1Applications]
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
			   ,[Year]
			   ,[NewContactYear]
			   ,[NB_EXTConvCnt]
			   ,[NB_BIOConvCnt]
			   ,[PCP_PCPAmt]
			   ,[PCP_NB2Amt]
		       ,[PCP_BioAmt]
	           ,[PCP_ExtMemAmt]
	           ,[PCP_NonPgmAmt]
			   ,[NB_TradAmt]
			   ,[NB_GradAmt]
			   ,[NB_ExtAmt]
			   ,[S_SurCnt]
			   ,[S_SurAmt]  )
		 SELECT dc.ClientSSID
				, dc.ClientIdentifier
				, nr.ClientMembershipGUID
				, nr.ClientMembershipKey
				, dm.MembershipSSID
				, dm.MembershipDescription
				, dcm.ClientMembershipIdentifier -- Membership Identifier
				, CASE WHEN dcm.ClientMembershipBeginDate <= @Today AND dcm.ClientMembershipEndDate >= @Today THEN 1 ELSE 0 END
				, dcm.ClientMembershipBeginDate
				, dcm.ClientMembershipEndDate
				, 0 -- Duration
				, NULL -- Status
				, 0
				, 0
				, 0
				, 0
				, 0
				, 0
				, 0
				, 0 -- Full Service
				, 0 -- Applications
				, 0 -- NB1Applications
				, 0 -- Services
				, 0 -- Appt Duration
				, 0 -- Appt Cost
				, GETUTCDATE()
				, 'sa'
				, GETUTCDATE()
				, 'sa'
				, dc.[CenterSSID]
				, dm.[BusinessSegmentDescription]
				, dc.[ClientFullName]
				, dc.[ClientGenderDescription]  -- Genger
				, (floor(datediff(week,dc.[ClientDateOfBirth],c.CreateDate)/(52)))-- Age
				, 0
				, nr.[Year]
				, CASE WHEN dmem.RevenueGroupDescriptionShort = 'NB' THEN YEAR(dcm.ClientMembershipBeginDate)
					ELSE ISNULL((SELECT TOP(1) YEAR(cm.ClientMembershipBeginDate)
							FROM [HC_BI_CMS_DDS].[bi_cms_dds].[DimClientMembership] cm
								INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] mem ON cm.[MembershipKey] = mem.MembershipKey
							WHERE cm.ClientKey = dc.ClientKey AND YEAR(cm.ClientMembershipBeginDate) <= nr.[Year]
								AND mem.RevenueGroupDescriptionShort = 'NB'
							ORDER BY cm.ClientMembershipBeginDate desc), 2007) END
				,0
				,0
				,0
				,0
				,0
				,0
				,0
				,0
				,0
				,0
				,0
				,0
			FROM @NewRecords nr
				INNER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimClientMembership dcm ON dcm.ClientMembershipKey = nr.ClientMembershipKey
				INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] dmem ON dcm.[MembershipKey] = dmem.MembershipKey
				INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimClient] dc ON dcm.ClientKey = dc.ClientKey
				INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] dm ON dm.MembershipKey= dcm.MembershipKey
				INNER JOIN [HairClubCMS].dbo.datClient c ON c.ClientGuid = dc.ClientSSID
			WHERE dcm.[ClientMembershipBeginDate] is not NULL
				AND dcm.[ClientMembershipBeginDate] >= @MembershipStartDate
				AND dc.[CenterSSID] is NOT NULL
			ORDER BY nr.ClientMembershipKey, nr.[Year]


	-- Update Age Range if not set
	UPDATE cp SET
		cp.[AgeRangeKey] = ar.[AgeID],
		cp.[AgeRangeDescription] = ar.[AgeDescription]
	FROM dbaMarginByYear cp
		LEFT JOIN DimAgeMarginByYear ar with (nolock) ON IIF(cp.Age IS NULL OR cp.Age < 0, -1, cp.Age) >= ar.AgeLow AND IIF(cp.Age IS NULL OR cp.Age < 0, -1, cp.Age) <= ar.AgeHigh
	WHERE cp.AgeRangeKey IS NULL

	-- Update if Membership is still active
	UPDATE cp SET
		cp.IsMembershipActive = CASE WHEN dcm.ClientMembershipBeginDate <= @Today AND dcm.ClientMembershipEndDate >= @Today THEN 1 ELSE 0 END,
		cp.MembershipStartDate = dcm.ClientMembershipBeginDate,
		cp.MembershipEndDate = dcm.ClientMembershipEndDate
	FROM dbaMarginByYear cp
		INNER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimClientMembership dcm with (nolock) ON cp.ClientMembershipKey = dcm.ClientMembershipKey


	-- Update Profitability for Active Memberships or for Memberships that end today.
	UPDATE cp SET
		-- Determine duration up to today for active memberships
		cp.MembershipDuration =	CASE WHEN cp.MembershipEndDate IS NULL THEN 0
									 WHEN cp.MembershipEndDate < @Today THEN DATEDIFF (Day,cp.MembershipStartDate , cp.MembershipEndDate )
								ELSE DATEDIFF (Day, cp.MembershipStartDate , @TODAY ) END
		, cp.[Status] = dcm.[ClientMembershipStatusDescription]
		, cp.[NetMembershipAmount] = (SELECT ISNULL(SUM(ISNULL(fst.[NetMembershipAmt], 0.0)), 0.0)
					FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
							INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
					WHERE YEAR(dso.OrderDate) = cp.[Year]
						 AND fst.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.PaymentsTotal = (SELECT ISNULL(SUM(ISNULL(fst.[NetMembershipAmt], 0.0)), 0.0)
					FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
							INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
					WHERE YEAR(dso.OrderDate) = cp.[Year]
						 AND fst.ClientMembershipKey = cp.ClientMembershipKey
						 AND fst.[NetMembershipAmt] > 0	)
		, cp.RefundsTotal = (SELECT ISNULL(SUM(ABS(ISNULL(fst.[NetMembershipAmt], 0.0))), 0.0)
					FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
							INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
							INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesCode] dsc with (nolock) ON dsc.SalesCodeKey = fst.SalesCodeKey
					WHERE YEAR(dso.OrderDate) = cp.[Year]
						 AND dso.ClientMembershipKey = cp.ClientMembershipKey
						 AND fst.[NetMembershipAmt] < 0
						 AND dsc.SalesCodeDescriptionShort not like '%WO')
		, cp.ServiceRevenue = (SELECT ISNULL(SUM(ISNULL(fst.ServiceAmt, 0.0)), 0.0)
					FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
							INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
					WHERE YEAR(dso.OrderDate) = cp.[Year]
						 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.ProductRevenue = (SELECT ISNULL(SUM(ISNULL(fst.RetailAmt, 0.0)), 0.0)
					FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
							INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
					WHERE YEAR(dso.OrderDate) = cp.[Year]
						 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.HairOrderCount = (SELECT COUNT(*) FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactHairSystemOrder] fhso with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimClientMembership] dcm with (nolock) ON dcm.ClientMembershipKey = fhso.ClientMembershipKey
								WHERE dcm.ClientMembershipKey = cp.ClientMembershipKey AND YEAR(fhso.HairSystemOrderDate) = cp.[Year])
		, cp.HairOrderTotalCost = (SELECT ISNULL(SUM(ISNULL(fhso.CostActual, 0.0)), 0.0) FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactHairSystemOrder] fhso with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimClientMembership] dcm with (nolock) ON dcm.ClientMembershipKey = fhso.ClientMembershipKey
								WHERE dcm.ClientMembershipKey = cp.ClientMembershipKey AND YEAR(fhso.HairSystemOrderDate) = cp.[Year])
		, cp.ServiceDuration = (SELECT ISNULL(SUM(ISNULL(dsc.[ServiceDuration], 0)), 0)
									FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
											INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
											INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesCode] dsc with (nolock) ON dsc.SalesCodeKey = fst.SalesCodeKey
									WHERE YEAR(dso.OrderDate) = cp.[Year]
										 AND dso.ClientMembershipKey = cp.ClientMembershipKey
										 AND dsc.SalesCodeTypeDescriptionShort = 'Service')
		, cp.FullService = (SELECT COUNT(dsc.SalesCodeKey)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
											INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
											INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesCode] dsc with (nolock) ON dsc.SalesCodeKey = fst.SalesCodeKey
									WHERE YEAR(dso.OrderDate) = cp.[Year]
										 AND dso.ClientMembershipKey = cp.ClientMembershipKey
										 AND dsc.SalesCodeDescriptionShort IN ('SVC','EXTLSVC','SVCPCP','EXTMEMSVC','LSVC','EXTSVC')
										 AND dsc.SalesCodeTypeDescriptionShort = 'Service')
		, cp.Applications = (SELECT COUNT(dsc.SalesCodeKey)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
											INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
											INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesCode] dsc with (nolock) ON dsc.SalesCodeKey = fst.SalesCodeKey
									WHERE YEAR(dso.OrderDate) = cp.[Year]
										 AND dso.ClientMembershipKey = cp.ClientMembershipKey
										 AND dsc.SalesCodeDescriptionShort IN ('NB1A','APP')
										 AND dsc.SalesCodeTypeDescriptionShort = 'Service')
		, cp.NB1Applications = (SELECT COUNT(dsc.SalesCodeKey)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
											INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
											INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesCode] dsc with (nolock) ON dsc.SalesCodeKey = fst.SalesCodeKey
									WHERE YEAR(dso.OrderDate) = cp.[Year]
										 AND dso.ClientMembershipKey = cp.ClientMembershipKey
										 AND dsc.SalesCodeDescriptionShort IN ('NB1A')
										 AND dsc.SalesCodeTypeDescriptionShort = 'Service')
		, cp.[Services] = (SELECT COUNT(dsc.SalesCodeKey)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
											INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
											INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesCode] dsc with (nolock) ON dsc.SalesCodeKey = fst.SalesCodeKey
									WHERE YEAR(dso.OrderDate) = cp.[Year]
										 AND dso.ClientMembershipKey = cp.ClientMembershipKey
										 AND dsc.SalesCodeTypeDescriptionShort = 'Service')

		, cp.[NB_EXTConvCnt] = (SELECT ISNULL(SUM(ISNULL(fst.[NB_EXTConvCnt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.[NB_BIOConvCnt] = (SELECT ISNULL(SUM(ISNULL(fst.[NB_BIOConvCnt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.[PCP_PCPAmt] = (SELECT ISNULL(SUM(ISNULL(fst.[PCP_PCPAmt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.[PCP_NB2Amt] = (SELECT ISNULL(SUM(ISNULL(fst.[PCP_NB2Amt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.[PCP_BioAmt] = (SELECT ISNULL(SUM(ISNULL(fst.[PCP_BioAmt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.[PCP_ExtMemAmt] = (SELECT ISNULL(SUM(ISNULL(fst.[PCP_ExtMemAmt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.[PCP_NonPgmAmt] = (SELECT ISNULL(SUM(ISNULL(fst.[PCPNonPgmAmt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.[NB_TradAmt] = (SELECT ISNULL(SUM(ISNULL(fst.[NB_TradAmt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.[NB_GradAmt] = (SELECT ISNULL(SUM(ISNULL(fst.[NB_GradAmt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.[NB_ExtAmt] = (SELECT ISNULL(SUM(ISNULL(fst.[NB_ExtAmt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.[S_SurCnt] = (SELECT ISNULL(SUM(ISNULL(fst.[S_SurCnt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)
		, cp.[S_SurAmt] = (SELECT ISNULL(SUM(ISNULL(fst.[S_SurAmt], 0.0)), 0.0)
								FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
										INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
								WHERE YEAR(dso.OrderDate) = cp.[Year]
									 AND dso.ClientMembershipKey = cp.ClientMembershipKey)

		, cp.LastUpdate = GETUTCDATE()
		, cp.LastUpdateUser = 'sa'
		, cp.WriteOff = (SELECT ISNULL(SUM(ABS(ISNULL(fst.NetMembershipAmt, 0.0))), 0.0)
					FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] fst with (nolock)
							INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesOrder] dso with (nolock) ON dso.SalesOrderKey = fst.SalesOrderKey
							INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimSalesCode] dsc with (nolock) ON dsc.SalesCodeKey = fst.SalesCodeKey
					WHERE YEAR(dso.OrderDate) = cp.[Year]
						 AND dso.ClientMembershipKey = cp.ClientMembershipKey
						 AND fst.[NetMembershipAmt] < 0
						 AND fst.SalesCodeKey in (SELECT SalesCodeKey FROM @WriteOffSalesCodes))
	FROM dbaMarginByYear cp
		INNER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimClientMembership dcm with (nolock) ON dcm.ClientMembershipKey = cp.ClientMembershipKey
	WHERE @IsInitialUpdate = 1
		OR cp.IsMembershipActive = 1  -- Only update Active memberships or memberships that ended today.
		OR cp.MembershipEndDate = @Today


	-- Update Appointment Cost
	UPDATE cp SET
		 cp.ServiceCost = (CAST(ISNULL(cp.ServiceDuration,0) AS Decimal(20,4)) * @APPOINTMENT_RATE_PER_MINUTE)
	FROM dbaMarginByYear cp
		INNER JOIN [HC_BI_CMS_DDS].bi_cms_dds.DimClientMembership dcm with (nolock) ON dcm.ClientMembershipKey = cp.ClientMembershipKey
	WHERE @IsInitialUpdate = 1
		OR cp.IsMembershipActive = 1  -- Only update Active memberships or memberships that ended today.
		OR cp.MembershipEndDate = @Today

END
GO
