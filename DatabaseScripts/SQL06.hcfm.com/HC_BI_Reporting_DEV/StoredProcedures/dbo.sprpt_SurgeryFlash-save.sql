/* CreateDate: 08/15/2011 11:48:02.827 , ModifyDate: 08/15/2011 11:48:02.827 */
GO
/*
==============================================================================

PROCEDURE:				sprpt_SurgeryFlash

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
6/1/2011	- KM - Initial Rewrite to SQL06
7/13/2011	- KM - Added in changes to Deferred Revenue per AG
7/19/2011 - MB - Added code to treat JV centers as Franchise centers (WO# 64829)
--

==============================================================================
GRANT EXECUTE ON sprpt_SurgeryFlash TO IIS
==============================================================================
SAMPLE EXECUTION:
EXEC [sprpt_SurgeryFlash] '6/1/2011', '7/19/2011'

==============================================================================
*/
create PROCEDURE [dbo].[sprpt_SurgeryFlash-save]
	@StartDate	DATETIME
,	@EndDate	DATETIME
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

DECLARE
		@StartDateKey INT
	,	@EndDateKey INT
	,	@OutstandingStartDate DATETIME
	,	@OutstandingStartDate13 DATETIME

SET @EndDate = @EndDate + ' 23:59'
SET @StartDateKey = CONVERT(INT, CONVERT(VARCHAR, YEAR(@StartDate))
      + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(@StartDate)))=1 THEN '0' + CONVERT(VARCHAR, MONTH(@StartDate)) else CONVERT(VARCHAR, MONTH(@StartDate)) END
      + CASE WHEN LEN(CONVERT(VARCHAR, DAY(@StartDate)))=1 THEN '0' + CONVERT(VARCHAR, DAY(@StartDate)) ELSE CONVERT(VARCHAR, DAY(@StartDate)) END)

SET @EndDateKey = CONVERT(INT, CONVERT(VARCHAR, YEAR(@EndDate))
      + CASE WHEN LEN(CONVERT(VARCHAR, MONTH(@EndDate)))=1 THEN '0' + CONVERT(VARCHAR, MONTH(@EndDate)) ELSE CONVERT(VARCHAR, MONTH(@EndDate)) END
      + CASE WHEN LEN(CONVERT(VARCHAR, DAY(@EndDate)))=1 THEN '0' + CONVERT(VARCHAR, DAY(@EndDate)) ELSE CONVERT(VARCHAR, DAY(@EndDate)) END)
SET @OutstandingStartDate13 = DATEADD(M, -13, @EndDate)
SET @OutstandingStartDate = DATEADD(M, -12, @EndDate)

	/*
	drop table #surgeryconsultations
	drop table #surgerydata
	DROP TABLE #OUTSTANDINGPROCSBYCLIENT
	DROP TABLE #OUTSTANDINGPROCS
	drop table #surgerycenters
	*/
	---
	--- Build Base Center Table
	---

	SELECT
			DOCREG.DoctorRegionSSID as 'RegionID'
		,	DOCREG.DoctorRegionDescriptionShort as 'Region'
		,	CTR.CenterSSID as 'CenterID'
		,	CTR.CenterDescription as 'Center_Name'
		,	CTRTYPE.CenterTypeDescription as 'CenterType'
		,	CTRTYPE.CenterTypeDescriptionShort as 'Type'
	into #SurgeryCenters
	FROM dbo.synHC_ENT_DDS_vwDimCenter CTR

		inner join dbo.synHC_ENT_DDS_vwDimDoctorRegion DOCREG on
			CTR.DoctorRegionKey = DOCREG.DoctorRegionKey
				and DOCREG.DoctorRegionDescriptionShort <> 'unknown'
		inner join dbo.synHC_ENT_DDS_vwDimCenterType CTRTYPE on
			CTR.CenterTypeKey = CTRTYPE.CenterTypeKey
	---
	---Consultations for Surgery Flash
	---

	SELECT CASE
			when DACT.CenterSSID between 200 and 299 then DACT.CenterSSID + 100
			when DACT.CenterSSID between 700 and 899 then DACT.CenterSSID - 200
			else DACT.CenterSSID end
			AS 'CenterID'
	,	sum(IsConsultation) AS 'Consultations'
	,	sum(case when SurgeryOffered = 'Y' then 1 else 0 end) AS 'Sur_Consultations'
	into #SurgeryConsultations
	FROM dbo.synHC_MKTG_DDS_vwDimActivityResult FAR
		INNER JOIN dbo.synHC_MKTG_DDS_vwDimActivity  DACT
			ON FAR.ActivitySSID = DACT.ActivitySSID
	WHERE DACT.activityduedate BETWEEN @StartDate and @EndDate
	group by case
			when DACT.CenterSSID between 200 and 299 then DACT.CenterSSID + 100
			when DACT.CenterSSID between 700 and 899 then DACT.CenterSSID - 200
			else DACT.CenterSSID end
	order by 		case
			when DACT.CenterSSID between 200 and 299 then DACT.CenterSSID + 100
			when DACT.CenterSSID between 700 and 899 then DACT.CenterSSID - 200
			else DACT.CenterSSID end
--
--Surgery Flash
--
SELECT

		CTR.CenterSSID as 'CenterID'
	,	sum(CASE WHEN Surg.AccumulatorKey = 48 THEN
				SURG.[SF-First_Surgery_Net_Sales] ELSE 0 END) AS 'First_Surgery_Net_Sales'
	,	sum(SURG.[SF-First_Surgery_Net$]) AS 'First_Surgery_Net$'
	,	dbo.divide(
			sum(SURG.[SF-First_Surgery_Net$]),
			sum(SURG.[SF-First_Surgery_Net_Sales])
		) as 'First_Surg_Rev_Per_Sales'
	,	sum(SURG.[SF-First_Surgery_Contract_Amount]) AS 'First_Surgery_Contract_Amount'
	,	sum(SURG.[SF-First_Surgery_Est_Grafts]) AS 'First_Surgery_Est_Grafts'
	,	dbo.divide(
			sum(SURG.[SF-First_Surgery_Contract_Amount]),
			sum(SURG.[SF-First_Surgery_Est_Grafts])
		) as 'First_Surgery_Est_Per_Grafts'

	,	sum(CASE WHEN Surg.AccumulatorKey = 48 THEN
				SURG.[SF-Addtl_Surgery_Net_Sales] ELSE 0 END) AS 'Addtl_Surgery_Net_Sales'

	,	sum(SURG.[SF-Addtl_Surgery_Net$]) AS 'Addtl_Surgery_Net$'
	,	dbo.divide(
			sum(SURG.[SF-Addtl_Surgery_Net$]),
			sum(SURG.[SF-Addtl_Surgery_Net_Sales])
		) as'Addtl_Surg_Rev_Per_Sales'
	,	sum(SURG.[SF-Addtl_Surgery_Contract_Amount]) AS 'Addtl_Surgery_Contract_Amount'
	,	sum(SURG.[SF-Addtl_Surgery_Est_Grafts]) AS 'Addtl_Surgery_Est_Grafts'
	,	dbo.divide(
			sum(SURG.[SF-Addtl_Surgery_Contract_Amount]),
			sum(SURG.[SF-Addtl_Surgery_Est_Grafts])
		) as 'Addtl_Surgery_Est_Per_Grafts'
--
	,	sum(SURG.[SF-Total_Surgery_Performed]) AS 'Total_Surgery_Performed'
	,	sum(SURG.[SF-Total_Net$]) as 'Total_Net$'
	,	dbo.[Divide](
			SUM(SURG.[SF-Total_Net$]),
			SUM(SURG.[SF-Total_Surgery_Performed])
		) 'Total_Revenue_Per_Sales'
--
	,	SUM(SURG.[SF-Total_Grafts]) as 'TotalGrafts'
	,	dbo.[Divide] (
			SUM(SURG.[SF-Total_Net$]),
			SUM(SURG.[SF-Total_Grafts])
		) 'Total_Est_per_Grafts'
--
	,	SUM(SURG.[SF-Total_POSTEXTPMT_Count]) as 'Total_POSTEXTPMT_Count'
	,	SUM(SURG.[SF-Total_POSTEXTPMT]) as 'Total_POSTEXTPMT'
--
	,	SUM(SURG.[SF-DepositsTaken]) AS 'DepositCount'
	,	SUM(SURG.[SF-DepositsTaken$]) as 'SF-DepositsTaken$'
INTO #SurgeryData
from dbo.synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo SURG
	inner join dbo.synHC_ENT_DDS_vwDimCenter CTR on
		SURG.ClientHomeCenterKey = CTR.CenterKey
	inner join dbo.synHC_CMS_DDS_vwDimSalesCode SC on
		sc.SalesCodeKey = SURG.SalesCodeKey
	inner join dbo.synHC_CMS_DDS_DimClient CL on
		SURG.ClientKey = CL.ClientKey
	left outer join #SurgeryConsultations CONS on
		SURG.ClientHomeCenterKey = CONS.CenterID

where OrderDateKey between @StartDateKey and @EndDateKey
and SURG.SalesCodeKey not in (20,17,21,19,30,32,36)
group by
		CTR.CenterSSID

order by CTR.CenterSSID

--
-- Create table of Outstanding Procedures by Client by Center
--

SELECT
	CTR.CenterSSID AS 'CenterID',
	--CL.ClientIdentifier,
	SUM(CASE WHEN CMA.AccumDate BETWEEN @OutstandingStartDate AND @EndDate THEN CONVERT(NUMERIC(15,2),[SF-Addtl_Surgery_Net$] + [SF-First_Surgery_Net$]) ELSE 0 END) as 'OutstandingPrice',
	CONVERT(NUMERIC(15,2),SUM([SF-Addtl_Surgery_Contract_Amount] + [SF-First_Surgery_Contract_Amount])) as 'OutstandingEstimate'
	--SUM(CASE WHEN CMA.AccumDate < @StartDate THEN CONVERT(NUMERIC(15,2),[SF-Addtl_Surgery_Net$] + [SF-First_Surgery_Net$]) ELSE 0 END) as 'RecognizedRevenue',
	--MAX(CASE WHEN SCD.SalesCodeDepartmentSSID = 5060 THEN ORDERDATEKEY ELSE NULL END) AS 'SurgeryDate',
	--SURG.SalesCodeKey as 'SC',
	--SCD.SalesCodeDepartmentSSID as 'Dept',
	--MAX(cm.ClientMembershipContractPrice) as 'contractpaid',
	--MAX(CASE WHEN SCD.SalesCodeDepartmentSSID = 1099 THEN ORDERDATEKEY ELSE NULL END) AS 'CancelDate'
into #OutstandingProcsByClient
from dbo.synHC_CMS_DDS_vwFactSalesFirstSurgeryInfo SURG
	INNER JOIN dbo.synHC_CMS_DDS_vwDimClientMembership CM ON
		SURG.ClientMembershipKey = cm.ClientMembershipKey
	LEFT OUTER JOIN dbo.synHC_CMS_DDS_vwDimAccumulatorAdjustment AA ON
		CM.ClientMembershipKey = AA.ClientMembershipKey
			AND AA.AccumulatorSSID IN (28)
	INNER JOIN dbo.synHC_CMS_DDS_vwDimClient CL on
		CL.ClientKey = CM.ClientKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimSalesCode SC ON
		SURG.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimSalesCodeDepartment SCD ON
		SC.SalesCodeDepartmentKey = SCD.SalesCodeDepartmentKey
	INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter CTR ON
		SURG.ClientHomeCenterKey = CTR.CenterKey
	INNER JOIN dbo.synHC_ENT_DDS_vwDimDate DD on
		SURG.OrderDateKey = DD.DateKey
	INNER JOIN dbo.synHC_CMS_DDS_vwDimClientMembershipAccum CMA ON
		CM.ClientMembershipKey = CMA.ClientMembershipKey
			and CMA.AccumulatorKey = 43
--
-- Get a list of client memberships to include in
--
	INNER JOIN (
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
					) MBRTABLE ON
					SURG.ClientMembershipKey = MBRTABLE.ClientMembershipKey

where
		(
			DD.FullDate <= @EndDate
		)
	AND

		(
			SCD.SalesCodeDepartmentSSID IN (1005,1010,1030,1040,1075,1090,  --Contract Total
												5060,1099, --Surgery or Cancel Dates
												2025,2020  --Membership & PostEXT Revenue
												)
		)



group by
		CTR.CenterSSID
		--,CL.clientidentifier
HAVING
		SUM([SF-Addtl_Surgery_Net$] + [SF-First_Surgery_Net$] ) <> 0

--
-- Create table of Outstanding Procedures by Center
--

SELECT
	CenterID as 'CenterID',
	COUNT(*) as 'Outstanding_Count',
	SUM(OutstandingPrice) as 'Outstanding_Total',
	SUM(OutstandingEstimate) as 'Outstanding_Est'
INTO #OutstandingProcs
from #OutstandingProcsByClient
GROUP BY CenterID
ORDER BY CenterID
--
--  Main Data Set
--
SELECT
		#SurgeryCenters.RegionID as 'RegionID',
		#SurgeryCenters.Region as 'Region',
		#SurgeryCenters.CenterID as 'Center',
		#SurgeryCenters.Center_Name as 'Center_Name',
		CASE WHEN #SurgeryCenters.CenterType ='Joint' THEN 'Franchise' ELSE #SurgeryCenters.CenterType END as 'CenterType',
		CASE WHEN #SurgeryCenters.[Type] = 'JV' THEN 'F' ELSE #SurgeryCenters.[Type] END as 'Type',
		ISNULL(#SurgeryConsultations.Consultations,0) as 'Consultations',
		ISNULL(#SurgeryConsultations.Sur_Consultations,0) as 'Sur_Consultations',
		dbo.divide
			(
			#SurgeryConsultations.Sur_Consultations,
			#SurgeryConsultations.Consultations
			) as 'Percent_Surgery',
		#SurgeryData.First_Surgery_Net_Sales as 'First_Surgery_Net_Sales',
		dbo.divide
			(
			#SurgeryData.First_Surgery_Net_Sales,
			#SurgeryConsultations.Sur_Consultations
			) as 'First_Surgery_Percent_Sales',
		ISNULL(#SurgeryData.First_Surgery_Net$,0) as 'First_Surgery_Net$',
		ISNULL(#SurgeryData.First_Surg_Rev_Per_Sales,0) as 'First_Surgery_Revenue_Per_Sales',
		ISNULL(#SurgeryData.First_Surgery_Contract_Amount,0) as 'First_Surgery_Contract_Amount',
		ISNULL(#SurgeryData.First_Surgery_Est_Grafts,0) as 'First_Surgery_Est_Grafts',
		ISNULL(#SurgeryData.First_Surgery_Est_Per_Grafts,0) as 'First_Surgery_Est_Per_Grafts',
		ISNULL(#SurgeryData.Addtl_Surgery_Net_Sales,0) as 'Addtl_Surgery_Net_Sales',
		ISNULL(#SurgeryData.Addtl_Surgery_Net$,0) as 'Addtl_Surgery_Net$',
		ISNULL(#SurgeryData.Addtl_Surg_Rev_Per_Sales,0) as 'Addtl_Surgery_Revenue_Per_Sales',
		ISNULL(#SurgeryData.Addtl_Surgery_Contract_Amount,0) as 'Addtl_Surgery_Contract_Amount',
		ISNULL(#SurgeryData.Addtl_Surgery_Est_Grafts,0) as 'Addtl_Surgery_Est_Grafts',
		ISNULL(#SurgeryData.Addtl_Surgery_Est_Per_Grafts,0) as 'Addtl_Surgery_Est_Per_Grafts',
		ISNULL(#SurgeryData.Total_Surgery_Performed,0) as 'Total_Surgery_Performed',
		ISNULL(#SurgeryData.Total_Net$,0) as 'Total_Net$',
		ISNULL(#SurgeryData.Total_Revenue_Per_Sales,0) as 'Total_Revenue_Per_Sales',
		ISNULL(#SurgeryData.TotalGrafts,0) as 'Total_Grafts',
		ISNULL(#SurgeryData.Total_Est_per_Grafts,0) as 'Total_Est_Per_Grafts',
		ISNULL(#SurgeryData.Total_POSTEXTPMT_Count,0) as 'Total_PostEXTPMT_Count',
		ISNULL(#SurgeryData.Total_POSTEXTPMT,0) as 'Total_PostEXTPMT',
		ISNULL(#OutstandingProcs.Outstanding_Count,0) as 'Outstanding_Count',
		ISNULL(#OutstandingProcs.Outstanding_Total,0) as 'Outstanding_Total',
		ISNULL(#OutstandingProcs.Outstanding_Est,0) as 'Outstanding_Est',
		ISNULL(#SurgeryData.DepositCount,0) as 'DepositCount'

FROM #SurgeryCenters
	left outer join #OutstandingProcs on
		#SurgeryCenters.CenterID = #OutstandingProcs.CenterID
	left outer join #SurgeryData on
		#SurgeryCenters.CenterID = #SurgeryData.CenterID
	left outer join #SurgeryConsultations on
		#SurgeryCenters.CenterID = #SurgeryConsultations.CenterID
order by 	#SurgeryCenters.CenterID
END
GO
