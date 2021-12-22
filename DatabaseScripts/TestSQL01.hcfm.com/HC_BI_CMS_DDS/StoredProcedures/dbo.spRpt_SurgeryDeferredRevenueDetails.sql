/* CreateDate: 07/11/2011 15:28:29.053 , ModifyDate: 09/16/2019 09:33:49.890 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
6/1/2010 - KM - Initial Rewrite to SQL06
--

==============================================================================
GRANT EXECUTE ON spRpt_SurgeryDeferredRevenueDetails30 TO IIS
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_SurgeryDeferredRevenueDetails] '5/31/2011'

==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_SurgeryDeferredRevenueDetails]
	@EndDate	DATETIME

AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

DECLARE
			@OutstandingStartDate DATETIME
		,	@StartDate DATETIME


SET @EndDate = @EndDate + ' 23:59'
SET @StartDate = DATEADD(M, -12,@EndDate)
SET @OutstandingStartDate = DATEADD(M,-13,@EndDate)


SELECT
	CTR.CenterTypeSSID,
	REG.RegionDescription,
	REG.RegionSortOrder,
	CTR.CenterSSID,
	CL.ClientIdentifier,
	CL.ClientFullName,
	CM.ClientMembershipStatusSSID as Status,
	MAX(cm.ClientMembershipBeginDate) AS 'SaleDate',
	MAX(CMA.AccumDate) as 'LastPaymentDate',
	SUM(CASE WHEN CMA.AccumDate < @StartDate THEN CONVERT(NUMERIC(15,2),[SF-Addtl_Surgery_Net$] + [SF-First_Surgery_Net$]) ELSE 0 END) as 'RecognizedRevenue',
	SUM(CASE WHEN CMA.AccumDate BETWEEN @StartDate AND @EndDate THEN CONVERT(NUMERIC(15,2),[SF-Addtl_Surgery_Net$] + [SF-First_Surgery_Net$]) ELSE 0 END) as 'DeferredRevenue',
	CONVERT(NUMERIC(15,2),SUM([SF-Addtl_Surgery_Contract_Amount] + [SF-First_Surgery_Contract_Amount])) as 'ContractPrice',
	--MAX(CASE WHEN SCD.SalesCodeDepartmentSSID = 5060 THEN ORDERDATEKEY ELSE NULL END) AS 'SurgeryDate',
	--SURG.SalesCodeKey as 'SC',
	--SCD.SalesCodeDepartmentSSID as 'Dept',
	--MAX(cm.ClientMembershipContractPrice) as 'contractpaid',
	MAX(CASE WHEN SCD.SalesCodeDepartmentSSID = 1099 THEN ORDERDATEKEY ELSE NULL END) AS 'CancelDate'

from bi_cms_dds.vwFactSalesFirstSurgeryInfo SURG
	INNER JOIN bi_cms_dds.vwDimClientMembership CM ON
		SURG.ClientMembershipKey = cm.ClientMembershipKey
	LEFT OUTER JOIN bi_cms_dds.vwDimAccumulatorAdjustment AA ON
		CM.ClientMembershipKey = AA.ClientMembershipKey
			AND AA.AccumulatorSSID IN (28)
	INNER JOIN bi_cms_dds.vwDimClient CL on
		CM.ClientKey = CL.ClientKey
	INNER JOIN bi_cms_dds.vwDimSalesCode SC ON
		SURG.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN bi_cms_dds.vwDimSalesCodeDepartment SCD ON
		SCD.SalesCodeDepartmentKey = SC.SalesCodeDepartmentKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter CTR ON
		CTR.CenterKey = surg.ClientHomeCenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimRegion REG on
		ctr.RegionKey = REG.RegionKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimDate DD on
		SURG.OrderDateKey = DD.DateKey
	INNER JOIN bi_cms_dds.vwDimClientMembershipAccum CMA ON
		CM.ClientMembershipKey = CMA.ClientMembershipKey
			and CMA.AccumulatorKey = 43
--
-- Get a list of client memberships to include in
--
	INNER JOIN (select CLM.ClientMembershipKey	from bi_cms_dds.vwDimAccumulatorAdjustment AA
						INNER JOIN bi_cms_dds.vwDimClientMembership CLM ON
							AA.ClientMembershipKey = CLM.ClientMembershipKey
						INNER JOIN bi_cms_dds.vwDimClient CL ON
							CLM.ClientKey = CL.ClientKey
					where AccumulatorSSID = '28'  ---Include Surgery Performed Client Memberships after End Date
							AND CLM.MembershipSSID IN (43,44)
							AND DateAdjustment > @EndDate

					UNION

					select CLM.ClientMembershipKey from bi_cms_dds.vwDimAccumulatorAdjustment AA
						INNER JOIN bi_cms_dds.vwDimClientMembership CLM ON
							AA.ClientMembershipKey = CLM.ClientMembershipKey
						INNER JOIN bi_cms_dds.vwDimClient CL ON
							CLM.ClientKey = CL.ClientKey
						LEFT OUTER JOIN bi_cms_dds.vwDimClientMembershipAccum CMA ON
							CLM.ClientMembershipKey = CMA.ClientMembershipKey
								AND CMA.AccumulatorKey = 43
					where AA.AccumulatorSSID IN ( 4,5) --Include cancelled, Sold Client Memberships after End Date
							AND CLM.MembershipSSID IN (43,44)
							AND AA.DateAdjustment > @EndDate
							AND CMA.AccumDate BETWEEN @StartDate AND @EndDate

					UNION

					select CLM.ClientMembershipKey from bi_cms_dds.vwDimAccumulatorAdjustment AA
						inner join bi_cms_dds.vwDimClientMembership CLM ON
							AA.ClientMembershipKey = CLM.ClientMembershipKey
						INNER JOIN bi_cms_dds.vwDimClient CL ON
							CLM.ClientKey = CL.ClientKey
					where CLM.ClientMembershipStatusSSID IN ( 1)  --Include Client Memberships with Last Payment only a year old
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
		CTR.CenterTypeSSID,
		REG.RegionDescription,
		REG.RegionSortOrder,
		CTR.CenterSSID,
		CL.clientidentifier,
		CL.ClientFullName,
		CM.clientmembershipkey,
		CM.ClientMembershipStatusSSID
HAVING
		SUM([SF-Addtl_Surgery_Net$] + [SF-First_Surgery_Net$] ) <> 0

END
GO
