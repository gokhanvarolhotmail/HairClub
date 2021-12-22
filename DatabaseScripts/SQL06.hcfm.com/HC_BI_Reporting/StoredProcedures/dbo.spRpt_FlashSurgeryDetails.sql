/* CreateDate: 10/02/2013 15:25:59.090 , ModifyDate: 04/11/2018 14:50:38.007 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spRpt_FlashSurgeryDetails]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_BI_Reportint]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	This procedure is the new Surgery Flash report
==============================================================================
NOTES:

10/09/2013 - MB - Changed the Procedure Done revenue amount to come from surgery perform transaction
02/20/2014 - DL - Joined on DimSalesOrder instead of on FactSalesTransactions for the ClientMembershipKey
04/11/2018 - RH - (#148857) Added Add-Ons
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_FlashSurgeryDetails] 5, 214, '4/1/2018', '4/15/2018'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_FlashSurgeryDetails] (
	@ReportType INT
,	@CenterSSID INT
,	@StartDate DATETIME
,	@EndDate DATETIME
) AS
BEGIN
	SET NOCOUNT ON

/*
@ReportType

1 = First Surgeries
2 = Additional Surgeries
3 = PostEXT
4 = Procedures Done
5 = Add-Ons
*/

/****  Find MembershipSSID for First Surgery and Additional Surgeries **************************/

DECLARE @MembershipSSID INT

SET @MembershipSSID =
CASE @ReportType
	WHEN 1 THEN 43
	WHEN 2 THEN 44
END

/********** Find information according to ReportType ****************************************/

IF @ReportType IN (1, 2)  --Surgeries
BEGIN
	SELECT CTR.CenterDescriptionNumber
	,	CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientFullName'
	,	CLT.BosleySiebelID
	,	M.MembershipDescription
	,	DD.FullDate AS 'SalesOrderDate'
	,	CM.ClientMembershipContractPrice AS 'Revenue'
	,	0 AS 'Grafts'
	,	0 AS 'PerGraft'
	,	FST.SalesCodeKey
	,	DSC.SalesCodeDescription
	,	E.UserLogin AS 'ReferringCounselor'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON DSO.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FST.CenterKey = CTR.CenterKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee1Key = E.EmployeeKey
	WHERE CTR.CenterSSID = @CenterSSID
		AND DD.FullDate BETWEEN @StartDate AND @EndDate
		AND (FST.S_SurCnt >= 1
				AND CM.MembershipSSID = @MembershipSSID)
		AND DSO.IsVoidedFlag = 0
END


IF @ReportType = 3  --PostEXT
BEGIN
	SELECT CTR.CenterDescriptionNumber
	,	CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientFullName'
	,	CLT.BosleySiebelID
	,	M.MembershipDescription
	,	DD.FullDate AS 'SalesOrderDate'
	,	CM.ClientMembershipContractPrice AS 'Revenue'
	,	FST.SalesCodeKey
	,	DSC.SalesCodeDescription
	,	0 AS 'Grafts'
	,	0 AS 'PerGraft'
	,	E.UserLogin AS 'ReferringCounselor'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON DSO.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FST.CenterKey = CTR.CenterKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee1Key = E.EmployeeKey
	WHERE CTR.CenterSSID = @CenterSSID
		AND DD.FullDate BETWEEN @StartDate AND @EndDate
		AND FST.S_PostExtCnt >= 1
		AND DSO.IsVoidedFlag = 0
END


IF @ReportType = 4   -- Procedures Done
BEGIN
	SELECT CTR.CenterDescriptionNumber
	,	CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientFullName'
	,	CLT.BosleySiebelID
	,	M.MembershipDescription
	,	DD.FullDate AS 'SalesOrderDate'
	,	FST.ExtendedPrice AS 'Revenue'
	,	FST.SalesCodeKey
	,	DSC.SalesCodeDescription
	,	FST_Grafts.Quantity AS 'Grafts'
	,	dbo.DIVIDE(FST.ExtendedPrice, FST_Grafts.Quantity) AS 'PerGraft'
	,	E.UserLogin AS 'ReferringCounselor'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON DSO.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST_Grafts
			ON CM.ClientMembershipKey = FST_Grafts.ClientMembershipKey
			AND FST_Grafts.SalesCodeKey = 1701
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FST.CenterKey = CTR.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee1Key = E.EmployeeKey
	WHERE CTR.CenterSSID = @CenterSSID
		AND DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSC.SalesCodeKey = 1701
		AND DSO.IsVoidedFlag = 0
END

--Find Add-Ons SalesCodeKeys

SELECT SalesCodeKey,
       SalesCodeSSID,
       SalesCodeDescription,
       SalesCodeDescriptionShort,
	   SalesCodeTypeDescription
INTO #AddOnSalesCodes
FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode
WHERE (SalesCodeDescription LIKE '%TriGen%'OR SalesCodeDescription LIKE '%Medical%Add-On%')
AND SalesCodeTypeDescription = 'Membership'



IF @ReportType = 5   --Add-Ons
BEGIN
	SELECT CTR.CenterDescriptionNumber
	,	CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientFullName'
	,	CLT.BosleySiebelID
	,	M.MembershipDescription
	,	DD.FullDate AS 'SalesOrderDate'
	,	FST.ExtendedPrice AS 'Revenue'
	,	FST.SalesCodeKey
	,	AOSC.SalesCodeDescription
	,	0 AS 'Grafts'
	,	0 AS 'PerGraft'
	,	E.UserLogin AS 'ReferringCounselor'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN #AddOnSalesCodes AOSC
			ON FST.SalesCodeKey = AOSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON DSO.ClientMembershipKey = CM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FST.CenterKey = CTR.CenterKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee1Key = E.EmployeeKey
	WHERE CTR.CenterSSID = @CenterSSID
		AND DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSO.IsVoidedFlag = 0
END

END
GO
