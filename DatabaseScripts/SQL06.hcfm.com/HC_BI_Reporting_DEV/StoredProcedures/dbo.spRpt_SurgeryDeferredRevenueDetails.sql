/*
==============================================================================

PROCEDURE:				spRpt_SurgeryDeferredRevenueDetails

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED:		06/01/2011

LAST REVISION DATE: 	06/01/2011

==============================================================================
DESCRIPTION:	Shows all new business surgery sales for a date range
==============================================================================

==============================================================================
NOTES:
--
	06/01/2010	- KM	Initial Rewrite to SQL06
	07/18/2011	- KM	Modified derivation of Last Payment Date
	07/19/2011	- KM	Modified derivation of Center to Client's Center
	09/01/2011	- KM	66297 - Added Surgery Date to this report
	10/02/2012	- MB	Rewrote report to point to new BI tables (WO# 80055)
	03/12/2013  - KM    Fixed bug that was not including cancelled memberships after end date
						reviewed spRPT_SurgeryDeferredRevenueDetailsByCenter to find bug
	03/27/2013  - KM    Fixed report to derive Surgery Date differently
	06/04/2013  - KM    Added in center restriction to only include [356] ctrs

==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_SurgeryDeferredRevenueDetails] '6/1/2013'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_SurgeryDeferredRevenueDetails]
	@EndDate	DATETIME
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @OutstandingStartDate DATETIME
	,	@StartDate DATETIME


	SET @EndDate = @EndDate + ' 23:59'
	SET @StartDate = DATEADD(M, -12,@EndDate)
	SET @OutstandingStartDate = DATEADD(M,-13,@EndDate)

	SELECT A.ClientMembershipKey
	,	MIN(A.AppointmentDate) AS 'SurgeryDate'
	INTO #SurgeryAppt
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimAppointment A
		left outer join HC_BI_CMS_DDS.bi_cms_dds.factappointmentdetail fad
			on A.appointmentkey = fad.AppointmentKey
	WHERE A.CenterSSID like '[2356]%'
		AND A.AppointmentDate >= GETDATE()
		AND ISNULL(A.IsDeletedFlag, 0) = 0
		AND fad.SalesCodeKey = 481
	Group by A.ClientMembershipKey



	SELECT CONVERT(VARCHAR(11), @EndDate, 101) AS 'ReportPeriod'
	,	CType.CenterTypeSSID
	,	R.RegionDescription AS 'Region'
	,	R.RegionSortOrder
	,	C.CenterSSID AS 'CenterID'
	,	C.CenterDescription
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName + ' (' + CAST(CLT.ClientIdentifier AS VARCHAR) + ')' AS 'ClientFullName'
	,	CM.ClientMembershipStatusSSID AS 'Status'
	,	MAX(CM.ClientMembershipBeginDate) AS 'SaleDate'
	,	MAX(LPMT.LastPayment) AS 'LastPaymentDate'
	,	SUM(CASE WHEN LPMT.LastPayment < @StartDate THEN FST.S1_NetSalesAmt + FST.SA_NetSalesAmt ELSE 0 END) AS 'RecognizedRevenue'
	,	SUM(CASE WHEN LPMT.LastPayment BETWEEN @StartDate AND @EndDate THEN FST.S1_NetSalesAmt + FST.SA_NetSalesAmt ELSE 0 END) AS 'DeferredRevenue'
	,	SUM(FST.S1_ContractAmountAmt + FST.SA_ContractAmountAmt) AS 'ContractPrice'
	,	MAX(CASE WHEN SC.SalesCodeDepartmentSSID=5060 THEN DD.FullDate ELSE NULL END) AS 'SurgeryDate'
	,	MAX(CM.ClientMembershipContractPrice) AS 'ContractPaid'
	,	MAX(CASE WHEN SC.SalesCodeDepartmentSSID=1099 THEN DD.FullDate ELSE NULL END) AS 'CancelDate'
	,	0 AS 'Balance'
	,	MAX(#SurgeryAppt.SurgeryDate) AS 'FutureSurgeryDate'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON CM.CenterKey = c.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CType
			ON C.CenterTypeKey = CType.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimDoctorRegion DDR
			ON C.DoctorRegionKey = DDR.DoctorRegionKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = R.RegionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		LEFT OUTER JOIN  #SurgeryAppt
			ON FST.ClientMembershipKey = #SurgeryAppt.ClientMembershipKey
		LEFT OUTER JOIN (
			SELECT AA.ClientMembershipKey
			,	MAX(DateAdjustment) AS 'LastPayment'
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimAccumulatorAdjustment AA
			WHERE AA.AccumulatorKey=43
				AND AA.DateAdjustment <= @EndDate
			GROUP BY AA.ClientMembershipKey
		) LPMT
			ON FST.ClientMembershipKey = LPMT.ClientMembershipKey
		INNER JOIN (
			SELECT AA.ClientMembershipKey
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimAccumulatorAdjustment AA
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON AA.ClientMembershipKey = CM.ClientMembershipKey
			WHERE AA.AccumulatorSSID=28 ---Include Surgery Performed Client Memberships after End Date
				AND CM.MembershipSSID IN (43, 44)
				AND AA.DateAdjustment > @EndDate

			UNION

			SELECT AA.ClientMembershipKey
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimAccumulatorAdjustment AA
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON AA.ClientMembershipKey = CM.ClientMembershipKey
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum CMA
					ON CM.ClientMembershipKey = CMA.ClientMembershipKey
					AND CMA.AccumulatorKey=43
			WHERE AA.AccumulatorSSID in (4,5)		--Include cancelled, Sold Client Memberships after End Date
				AND CM.MembershipSSID IN (43, 44)
				AND AA.DateAdjustment > @EndDate
				AND CMA.AccumDate BETWEEN @StartDate AND @EndDate

			UNION

			SELECT AA.ClientMembershipKey
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimAccumulatorAdjustment AA
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON AA.ClientMembershipKey = CM.ClientMembershipKey
			WHERE AA.AccumulatorSSID=7
				AND CM.ClientMembershipStatusSSID=1  --Include Client Memberships with Last Payment only a year old
				AND CM.MembershipSSID IN (43, 44)
				AND AA.DateAdjustment >= @OutstandingStartDate
		) MembershipTable
			ON FST.ClientMembershipKey = MembershipTable.ClientMembershipKey
	WHERE DD.FullDate <= @EndDate
		AND SC.SalesCodeDepartmentSSID IN (1005, 1010, 1030, 1040, 1075, 1090, 5060, 1099, 2025, 2020)
		AND c.CenterSSID like '[2356]%'
	GROUP BY CType.CenterTypeSSID
	,	R.RegionDescription
	,	R.RegionSortOrder
	,	C.CenterSSID
	,	C.CenterDescription
	,	CLT.ClientIdentifier
	,	CLT.ClientFullName
	,	CLT.ClientIdentifier
	,	CM.ClientMembershipStatusSSID
	,	cm.ClientMembershipKey
	HAVING SUM(FST.S1_NetSalesAmt + FST.SA_NetSalesAmt) <> 0
	ORDER BY R.RegionSortOrder
	,	C.CenterSSID
	,	CLT.ClientFullName
END
