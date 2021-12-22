/*
==============================================================================

PROCEDURE:				[spRpt_SurgeryDeferredRevenueDetailsByCenter]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED:		06/01/2011

LAST REVISION DATE: 	06/01/2011

==============================================================================
DESCRIPTION:	Shows all new business surgery sales for a date range
==============================================================================
NOTES:

	07/18/2011	KM	Modified derivation of Last Payment Date
	07/19/2011	KM	Modified derivation of Center to Client's Center
	08/18/2011	MB	Added code to return data by region as well as center
	04/20/2012	MB	Added formula for Balance column (WO# 74702)
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_SurgeryDeferredRevenueDetailsByCenter] 350, '9/30/2011'

==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_SurgeryDeferredRevenueDetailsByCenter]
	@Center INT
,	@EndDate DATETIME

AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @OutstandingStartDate DATETIME
	, @StartDate DATETIME


	SET @EndDate = @EndDate + ' 23:59'
	SET @StartDate = DATEADD(M, -12, @EndDate)
	SET @OutstandingStartDate = DATEADD(M, -13, @EndDate)


	SELECT CTR.CenterTypeSSID
	,	REG.RegionDescription
	,	REG.RegionSortOrder
	,	CTR.CenterSSID
	,	CTR.CenterDescription
	,	CL.ClientIdentifier
	,	CL.ClientFullName
	,	CM.ClientMembershipStatusSSID as Status
	,	MAX(cm.ClientMembershipBeginDate) AS 'SaleDate'
	,	MAX(LPMT.LastPayment) as 'LastPayment'
	,	SUM(CASE WHEN LPMT.LastPayment < @StartDate THEN CONVERT(NUMERIC(15,2),[SF-Addtl_Surgery_Net$] + [SF-First_Surgery_Net$]) ELSE 0 END) AS 'RecognizedRevenue'
	,	SUM(CASE WHEN LPMT.LastPayment BETWEEN @StartDate AND @EndDate THEN CONVERT(NUMERIC(15,2),[SF-Addtl_Surgery_Net$] + [SF-First_Surgery_Net$]) ELSE 0 END) AS 'DeferredRevenue'
	,	CONVERT(NUMERIC(15,2),SUM([SF-Addtl_Surgery_Contract_Amount] + [SF-First_Surgery_Contract_Amount])) AS 'ContractPrice'
	,	MAX(CASE WHEN SCD.SalesCodeDepartmentSSID = 1099 THEN ORDERDATEKEY ELSE NULL END) AS 'CancelDate'
	,	CASE WHEN DATEDIFF(DAY, MAX(cm.ClientMembershipBeginDate), GETDATE()) < 60 THEN 1
			WHEN DATEDIFF(DAY, MAX(cm.ClientMembershipBeginDate), GETDATE()) > 90 THEN 3
			ELSE 2
		END AS 'last_surgery_group'
	,	MM.MembershipDescription
	,	NextAppt.SurgeryDate AS 'next_appt'
	,	CONVERT(NUMERIC(15,2),SUM([SF-Addtl_Surgery_Contract_Amount] + [SF-First_Surgery_Contract_Amount]))
			-
			SUM(CASE WHEN LPMT.LastPayment BETWEEN @StartDate AND @EndDate THEN CONVERT(NUMERIC(15,2),[SF-Addtl_Surgery_Net$] + [SF-First_Surgery_Net$]) ELSE 0 END)
		AS 'Balance'

	FROM dbo.synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo SURG
		INNER JOIN dbo.synHC_CMS_DDS_vwDimClientMembership CM
			ON SURG.ClientMembershipKey = cm.ClientMembershipKey
		LEFT OUTER JOIN dbo.synHC_CMS_DDS_vwDimAccumulatorAdjustment AA
			ON CM.ClientMembershipKey = AA.ClientMembershipKey
			AND AA.AccumulatorSSID IN (28)
		INNER JOIN dbo.synHC_CMS_DDS_vwDimClient CL
			ON CL.ClientKey = CM.ClientKey
		INNER JOIN dbo.synHC_CMS_DDS_vwDimSalesCode SC
			ON SURG.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN dbo.synHC_CMS_DDS_vwDimSalesCodeDepartment SCD
			ON SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
		INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter CTR
			ON CL.CenterSSID = CTR.CenterSSID
		INNER JOIN dbo.synHC_ENT_DDS_vwDimRegion REG
			ON CTR.RegionKey = REG.RegionKey
		INNER JOIN dbo.synHC_ENT_DDS_vwDimDate DD
			ON SURG.OrderDateKey = DD.DateKey
		INNER JOIN dbo.synHC_CMS_DDS_vwDimClientMembershipAccum CMA
			ON CM.ClientMembershipKey = CMA.ClientMembershipKey
			AND CMA.AccumulatorKey = 43
		LEFT OUTER JOIN (
			SELECT CLIENTMEMBERSHIPKEY,MAX(DATEADJUSTMENT) AS LastPayment FROM
				dbo.synHC_CMS_DDS_vwDimAccumulatorAdjustment
					WHERE ACCUMULATORKEY = 43 and DateAdjustment <= @EndDate
				group by clientmembershipkey
					) LPMT on
		CM.ClientMembershipKey = LPMT.ClientMembershipKey
		Inner JOIN (
			SELECT CLM.ClientMembershipKey
			FROM dbo.synHC_CMS_DDS_vwDimAccumulatorAdjustment AA
				INNER JOIN dbo.synHC_CMS_DDS_vwDimClientMembership CLM
					ON AA.ClientMembershipKey = CLM.ClientMembershipKey
				INNER JOIN dbo.synHC_CMS_DDS_vwDimClient CL
					ON CLM.ClientKey = CL.ClientKey
			WHERE AccumulatorSSID = '28'  ---Include Surgery Performed Client Memberships after End Date
				AND CLM.MembershipSSID IN (43,44)
				AND DateAdjustment > @EndDate

			UNION

			SELECT CLM.ClientMembershipKey
			FROM dbo.synHC_CMS_DDS_vwDimAccumulatorAdjustment AA
				INNER JOIN dbo.synHC_CMS_DDS_vwDimClientMembership CLM
					ON AA.ClientMembershipKey = CLM.ClientMembershipKey
				INNER JOIN dbo.synHC_CMS_DDS_vwDimClient CL
					ON CLM.ClientKey = CL.ClientKey
				LEFT OUTER JOIN dbo.synHC_CMS_DDS_vwDimClientMembershipAccum CMA
					ON CLM.ClientMembershipKey = CMA.ClientMembershipKey
					AND CMA.AccumulatorKey = 43
			WHERE AA.AccumulatorSSID IN ( 4,5) --Include cancelled, Sold Client Memberships after End Date
				AND CLM.MembershipSSID IN (43,44)
				AND AA.DateAdjustment > @EndDate
				AND CMA.AccumDate BETWEEN @StartDate AND @EndDate

			UNION

			SELECT CLM.ClientMembershipKey
			FROM dbo.synHC_CMS_DDS_vwDimAccumulatorAdjustment AA
				INNER JOIN dbo.synHC_CMS_DDS_vwDimClientMembership CLM
					ON AA.ClientMembershipKey = CLM.ClientMembershipKey
				INNER JOIN dbo.synHC_CMS_DDS_vwDimClient CL
					ON CLM.ClientKey = CL.ClientKey
			WHERE CLM.ClientMembershipStatusSSID IN ( 1)  --Include Client Memberships with Last Payment only a year old
				AND CLM.MembershipSSID IN (43,44)
				AND	AccumulatorSSID = 7
				AND DateAdjustment >= @OutstandingStartDate
		) MBRTABLE
			ON SURG.ClientMembershipKey = MBRTABLE.ClientMembershipKey
		INNER JOIN dbo.synHC_CMS_DDS_vwDimMembership MM
			ON CM.MembershipKey = MM.MembershipKey
		LEFT OUTER JOIN (
			SELECT ClientMembershipKey
			,	MIN(AppointmentDate) AS 'SurgeryDate'
			FROM dbo.synHC_CMS_DDS_vwDimAppointment
			WHERE AppointmentDate >= GETDATE()
				AND ISNULL(IsDeletedFlag, 0) = 0
				AND AppointmentSubject = 'Perform Surgery'
			GROUP BY ClientMembershipKey
		) NextAppt
			ON SURG.ClientMembershipKey = NextAppt.ClientMembershipKey
		INNER JOIN dbo.synHC_ENT_DDS_vwDimDoctorRegion DRR
			ON CTR.DoctorRegionSSID = DRR.DoctorRegionSSID
	WHERE (CTR.CenterSSID = @Center
			OR DRR.DoctorRegionSSID = @Center)
			AND ctr.CenterSSID like '[356]%'
		AND DD.FullDate <= @EndDate
		AND SCD.SalesCodeDepartmentSSID IN (
			1005, 1010, 1030, 1040, 1075, 1090  --Contract Total
			, 5060, 1099	--Surgery or Cancel Dates
			, 2025, 2020	--Membership & PostEXT Revenue
		)
	GROUP BY CTR.CenterTypeSSID
	,	REG.RegionDescription
	,	REG.RegionSortOrder
	,	CTR.CenterSSID
	,	CTR.CenterDescription
	,	CL.clientidentifier
	,	CL.ClientFullName
	,	CM.clientmembershipkey
	,	CM.ClientMembershipStatusSSID
	,	MM.MembershipDescription
	,	NextAppt.SurgeryDate
	HAVING SUM([SF-Addtl_Surgery_Net$] + [SF-First_Surgery_Net$] ) <> 0
	ORDER BY	REG.RegionSortOrder
			,	CTR.CenterSSID
			,	CL.ClientFullName

END
