/* CreateDate: 06/03/2019 11:24:54.277 , ModifyDate: 11/06/2019 16:56:31.067 */
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashRecurringBusinessAddOns
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_FlashRecurringBusinessAddOns
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		06/03/2019
------------------------------------------------------------------------
NOTES:
@Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
------------------------------------------------------------------------
CHANGE HISTORY:
09/05/2019 - RH - Reduced the Add-On SalesCodes - removed the "Add-Ons:.."
09/11/2019 - RH - Added the "Add-Ons:" as counts
11/07/2019 - RH - Added New Styles, Salon Visits and Chemical Services add-ons
-----------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_FlashRecurringBusinessAddOns] '11/01/2019', '11/15/2019', 'C', 3

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FlashRecurringBusinessAddOns]
(
	@begdt DATETIME
,	@enddt DATETIME
,	@sType NVARCHAR(1)
,	@Filter INT
)

AS
BEGIN




/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	MainGroupSortOrder INT
,	CenterNumber INT
,	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescription NVARCHAR(20)
)


CREATE TABLE #AddOn (
		SalesCodeKey INT
,		SalesCodeSSID INT
,		SalesCodeDescriptionShort NVARCHAR(15)
,		SalesCodeDescription NVARCHAR(50)
,		SalesCodeDepartmentSSID INT
,		PriceType NVARCHAR(50)
)


/********************************** Get list of centers *************************************/
IF @sType = 'C' AND @Filter = 2  --By Area Managers
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS MainGroupID
		,		CMA.CenterManagementAreaDescription AS MainGroup
		,		CMA.CenterManagementAreaSortOrder AS MainGroupSortOrder
		,		DC.CenterNumber
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		CT.CenterTypeDescription
		FROM		HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE		CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN('C','HW')
END
IF @sType = 'C' AND @Filter = 3  -- By Centers
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterNumber AS 'MainGroupID'
		,		DC.CenterDescriptionNumber AS 'MainGroup'
		,		DC.CenterNumber AS 'MainGroupSortOrder'
		,		DC.CenterNumber
		,		DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		CT.CenterTypeDescription
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE	CT.CenterTypeDescriptionShort IN('C','HW')
				AND DC.Active = 'Y'
END


IF @sType = 'F'  --Always By Regions for Franchises
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DR.RegionSortOrder AS 'MainGroupSortOrder'
			,		DC.CenterNumber
			,		DC.CenterSSID
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			,		CASE WHEN CT.CenterTypeDescription = 'Joint' THEN 'Franchise' ELSE 'Franchise' END AS 'CenterTypeDescription'
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionSSID = DR.RegionSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.Active = 'Y'
END



/****************** Get Add-On Codes **************************************************************/

INSERT INTO #AddOn

SELECT sc.SalesCodeKey
            ,             sc.SalesCodeSSID
            ,             sc.SalesCodeDescriptionShort
            ,             sc.SalesCodeDescription
            ,             sc.SalesCodeDepartmentSSID
			,		CASE WHEN (sc.SalesCodeDescriptionShort LIKE 'EFTFEEADDON%' AND (sc.SalesCodeDescriptionShort LIKE '%SH'
																					OR sc.SalesCodeDescriptionShort LIKE '%LH'
																					OR sc.SalesCodeDescriptionShort LIKE '%OM'
																					OR sc.SalesCodeDescriptionShort LIKE '%EL'
																					OR sc.SalesCodeDescriptionShort LIKE '%NS'
																																)) THEN 'PCPNonPGM_Payment'
						WHEN (sc.SalesCodeDescriptionShort LIKE 'MEMADDONPMT%' AND (sc.SalesCodeDescriptionShort LIKE '%SH'
																					OR sc.SalesCodeDescriptionShort LIKE '%LH'
																					OR sc.SalesCodeDescriptionShort LIKE '%OM'
																					OR sc.SalesCodeDescriptionShort LIKE '%EL'
																					OR sc.SalesCodeDescriptionShort LIKE '%NS'	)) THEN 'PCPNonPGM_Payment'
						WHEN (sc.SalesCodeDescription LIKE 'Add-On:%' AND (sc.SalesCodeDescriptionShort LIKE '%SH'
																					OR sc.SalesCodeDescriptionShort LIKE '%LH'
																					OR sc.SalesCodeDescriptionShort LIKE '%OM'
																					OR sc.SalesCodeDescriptionShort LIKE '%EL'
																					OR sc.SalesCodeDescriptionShort LIKE '%NS'	)) THEN 'PCPNonPGM_Count'
						WHEN sc.SalesCodeDescriptionShort LIKE 'EFTFEEADDON%' AND sc.SalesCodeDescriptionShort LIKE '%PK' THEN 'Retail_Payment'
						WHEN sc.SalesCodeDescriptionShort LIKE 'MEMADDONPMT%' AND sc.SalesCodeDescriptionShort LIKE '%PK' THEN 'Retail_Payment'
						WHEN sc.SalesCodeDescription LIKE 'Add-On:%'  AND sc.SalesCodeDescriptionShort LIKE '%PK' THEN 'Retail_Count'
						WHEN (sc.SalesCodeDescriptionShort LIKE 'EFTFEEADDON%' AND (sc.SalesCodeDescriptionShort LIKE '%SS'
																					OR sc.SalesCodeDescriptionShort LIKE '%SV'
																					OR sc.SalesCodeDescriptionShort LIKE '%CH'	)) THEN 'Service_Payment'
						WHEN (sc.SalesCodeDescriptionShort LIKE 'MEMADDONPMT%' AND (sc.SalesCodeDescriptionShort LIKE '%SS'
																					OR sc.SalesCodeDescriptionShort LIKE '%SV'
																					OR sc.SalesCodeDescriptionShort LIKE '%CH'	)) THEN 'Service_Payment'
						WHEN (sc.SalesCodeDescription LIKE 'Add-On:%'  AND (sc.SalesCodeDescriptionShort LIKE '%SS'
																					OR sc.SalesCodeDescriptionShort LIKE '%SV'
																					OR sc.SalesCodeDescriptionShort LIKE '%CH'	)) THEN 'Service_Count'
					ELSE '' END AS PriceType
            FROM   HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			WHERE (sc.SalesCodeDescriptionShort LIKE 'EFTFEEADDON%' AND (sc.SalesCodeDescriptionShort LIKE '%SH'
																					OR sc.SalesCodeDescriptionShort LIKE '%LH'
																					OR sc.SalesCodeDescriptionShort LIKE '%OM'
																					OR sc.SalesCodeDescriptionShort LIKE '%EL'
																					OR sc.SalesCodeDescriptionShort LIKE '%NS'
																					OR sc.SalesCodeDescriptionShort LIKE '%PK'
																					OR sc.SalesCodeDescriptionShort LIKE '%SS'
																					OR sc.SalesCodeDescriptionShort LIKE '%SV'
																					OR sc.SalesCodeDescriptionShort LIKE '%CH')
				OR sc.SalesCodeDescriptionShort LIKE 'MEMADDONPMT%'AND (sc.SalesCodeDescriptionShort LIKE '%SH'
																					OR sc.SalesCodeDescriptionShort LIKE '%LH'
																					OR sc.SalesCodeDescriptionShort LIKE '%OM'
																					OR sc.SalesCodeDescriptionShort LIKE '%EL'
																					OR sc.SalesCodeDescriptionShort LIKE '%NS'
																					OR sc.SalesCodeDescriptionShort LIKE '%PK'
																					OR sc.SalesCodeDescriptionShort LIKE '%SS'
																					OR sc.SalesCodeDescriptionShort LIKE '%SV'
																					OR sc.SalesCodeDescriptionShort LIKE '%CH')
				OR sc.SalesCodeDescription LIKE 'Add-On:%' AND (sc.SalesCodeDescriptionShort LIKE '%SH'
																					OR sc.SalesCodeDescriptionShort LIKE '%LH'
																					OR sc.SalesCodeDescriptionShort LIKE '%OM'
																					OR sc.SalesCodeDescriptionShort LIKE '%EL'
																					OR sc.SalesCodeDescriptionShort LIKE '%NS'
																					OR sc.SalesCodeDescriptionShort LIKE '%PK'
																					OR sc.SalesCodeDescriptionShort LIKE '%SS'
																					OR sc.SalesCodeDescriptionShort LIKE '%SV'
																					OR sc.SalesCodeDescriptionShort LIKE '%CH'))


--SELECT '#AddOn' AS tablename, * FROM #AddOn




/********************** Find clients with AddOns ***************************************/

SELECT #Centers.MainGroupID
,	#Centers.MainGroup
,	#Centers.MainGroupSortOrder
,	#Centers.CenterNumber
,	#Centers.CenterSSID
,	#Centers.CenterDescription
,	#Centers.CenterDescriptionNumber
,	#Centers.CenterTypeDescription
,	CLT.ClientLastName
,	CLT.ClientFirstName
,	FST.ClientKey
,	CLT.ClientIdentifier
,	M.MembershipDescription
,	M.BusinessSegmentDescriptionShort
,	FST.SalesOrderDetailKey
,	FST.SalesOrderKey
,	DD.FullDate
,	SC.SalesCodeDescriptionShort
,	SC.SalesCodeDescription
,	FST.Quantity
,	CM.ClientMembershipMonthlyFee
,	FST.ExtendedPrice
,	FST.Tax1
,	FST.Tax2
,	E.EmployeeInitials AS 'performer'
,	E2.EmployeeInitials AS 'stylist'
,	FST.PCP_NB2Amt
,	SC.SalesCodeSSID
,	SC.SalesCodeKey
,	CASE WHEN ADDON.PriceType = 'PCPNonPGM_Payment' THEN FST.ExtendedPrice  ELSE 0 END AS PCPNonPGM_Payment
,	CASE WHEN ADDON.PriceType = 'Service_Payment' THEN FST.ExtendedPrice  ELSE 0 END AS Service_Payment
,	CASE WHEN ADDON.PriceType = 'Retail_Payment' THEN FST.ExtendedPrice  ELSE 0 END AS Retail_Payment
,	CASE WHEN ADDON.PriceType = 'PCPNonPGM_Count' THEN FST.Quantity ELSE 0 END AS PCPNonPGM_Count
,	CASE WHEN ADDON.PriceType = 'Service_Count' THEN FST.Quantity  ELSE 0 END AS Service_Count
,	CASE WHEN ADDON.PriceType = 'Retail_Count' THEN FST.Quantity  ELSE 0 END AS Retail_Count
,	NULL AS CANCELADDON
,	SOD.ClientMembershipAddOnID
,	FST.ClientServicedCnt
INTO #FSTAddOns
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
		ON FST.ClientMembershipKey = CM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON M.MembershipKey = CM.MembershipKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FST.CenterKey = CTR.CenterKey
	INNER JOIN #Centers
		ON CTR.CenterNumber = #Centers.CenterNumber
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CTR.CenterTypeKey = CT.CenterTypeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON FST.Employee1Key = E.EmployeeKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
		ON FST.Employee2Key = E2.EmployeeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
		ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN #AddOn ADDON
		ON ADDON.SalesCodeKey = FST.SalesCodeKey
WHERE DD.FullDate BETWEEN @begdt AND @enddt
AND SO.IsVoidedFlag = 0
AND M.BusinessSegmentDescriptionShort <> 'SUR'


/************  Find Cancels for AddOns  **********************************************************/

SELECT #FSTAddOns.CenterNumber
,	#FSTAddOns.ClientIdentifier
,	(-1) AS CANCELADDON
,	#FSTAddOns.ClientMembershipAddOnID AS FSTADDONClientMembershipAddOnID
,	SOD.ClientMembershipAddOnID
INTO #Cancels
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN #FSTAddOns
		ON #FSTAddOns.ClientKey = FST.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
		ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON (FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
			AND #FSTAddOns.ClientMembershipAddOnID = SOD.ClientMembershipAddOnID)
WHERE SC.SalesCodeDescriptionShort = 'CANCELADDON'


UPDATE #FSTAddOns
SET #FSTAddOns.CANCELADDON = #Cancels.CANCELADDON
FROM #FSTAddOns
INNER JOIN #Cancels
	ON #Cancels.CenterNumber = #FSTAddOns.CenterNumber
WHERE #Cancels.ClientIdentifier = #FSTAddOns.ClientIdentifier
AND #Cancels.ClientMembershipAddOnID = #FSTAddOns.ClientMembershipAddOnID



/*********** Pivot for the SUMMARY page using ADDON clients *********************************/

SELECT MainGroupID
,	MainGroup
,	MainGroupSortOrder
,	CenterNumber
,	CenterSSID
,	CenterDescription
,	CenterDescriptionNumber
,	CenterTypeDescription
,	ClientIdentifier
,	ClientLastName
,	ClientFirstName
,	MembershipDescription

,	SUM(CANCELADDON) AS CANCELADDON

,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort = 'ADDONOM' THEN PCPNonPGM_Count ELSE 0 END) AS OmbreCnt
,	SUM(CASE WHEN  #FSTAddOns.SalesCodeSSID IN(1633,1639) THEN PCPNonPGM_Payment ELSE 0 END) AS OmbreAmt --Payments Only for Revenue

,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort = 'ADDONEL' THEN PCPNonPGM_Count ELSE 0 END) AS ExLaceCnt
,	SUM(CASE WHEN  #FSTAddOns.SalesCodeSSID IN(1634,1640) THEN PCPNonPGM_Payment ELSE 0 END) AS ExLaceAmt

,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort = 'ADDONLH' THEN PCPNonPGM_Count ELSE 0 END) AS LongHairCnt
,	SUM(CASE WHEN  #FSTAddOns.SalesCodeSSID IN(1632,1638,1659) THEN PCPNonPGM_Payment ELSE 0 END) AS LongHairAmt

,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort = 'ADDONSH' THEN PCPNonPGM_Count ELSE 0 END) AS SignatureCnt
,	SUM(CASE WHEN  #FSTAddOns.SalesCodeSSID IN(1631,1637) THEN PCPNonPGM_Payment ELSE 0 END) AS SignatureAmt

,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort = 'ADDONNS' THEN PCPNonPGM_Count ELSE 0 END) AS NSDCnt
,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort IN('EFTFEEADDONNS','MEMADDONPMTNS') THEN PCPNonPGM_Payment ELSE 0 END) AS NSDAmt  --New Styles

,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort = 'ADDONSS' THEN Service_Count ELSE 0 END) AS SSCnt
,	SUM(CASE WHEN  #FSTAddOns.SalesCodeSSID IN(1636,1642) THEN [Service_Payment] ELSE 0 END) AS SSAmt

,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort = 'ADDONCH' THEN Service_Count ELSE 0 END) AS CHCnt
,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort IN('EFTFEEADDONCH','MEMADDONPMTCH') THEN [Service_Payment] ELSE 0 END) AS CHAmt  --Chemical Services

,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort = 'ADDONSV' THEN Service_Count ELSE 0 END) AS SVCnt
,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort IN('EFTFEEADDONSV','MEMADDONPMTSV') THEN [Service_Payment] ELSE 0 END) AS SVAmt  --Salon Visits

,	SUM(CASE WHEN  #FSTAddOns.SalesCodeDescriptionShort = 'ADDONPK' THEN Retail_Count ELSE 0 END) AS PKCnt
,	SUM(CASE WHEN  #FSTAddOns.SalesCodeSSID IN(1635,1641) THEN Retail_Payment ELSE 0 END) AS PKAmt
INTO #Pivot
FROM #FSTAddOns
GROUP BY MainGroupID
,	MainGroup
,	MainGroupSortOrder
,	CenterNumber
,	CenterSSID
,	CenterDescription
,	CenterDescriptionNumber
,	CenterTypeDescription
,	ClientIdentifier
,	ClientLastName
,	ClientFirstName
,	MembershipDescription


--SELECT * FROM #Pivot

/************** Final select  ************************************************************/

SELECT MainGroupID
,       MainGroup
,       MainGroupSortOrder
,       CenterNumber
,       CenterSSID
,       CenterDescription
,       CenterDescriptionNumber
,       CenterTypeDescription
,       ClientIdentifier
,       ClientLastName
,       ClientFirstName
,       MembershipDescription
,		ISNULL(CANCELADDON,0) AS CANCELADDON
,	    OmbreCnt
,       OmbreAmt
,       ExLaceCnt
,       ExLaceAmt
,       LongHairCnt
,       LongHairAmt
,       SignatureCnt
,       SignatureAmt
,       SSCnt
,       SSAmt
,       PKCnt
,       PKAmt
,		NSDCnt
,		NSDAmt
,		CHCnt
,		CHAmt
,		SVCnt
,		SVAmt
,	   (ISNULL(OmbreCnt,0)
				+ ISNULL(ExLaceCnt,0)
				+ ISNULL(LongHairCnt,0)
				+ ISNULL(SignatureCnt,0)
				+ ISNULL(SSCnt,0)
				+ ISNULL(PKCnt,0)
				+ ISNULL(NSDCnt,0)
				+ ISNULL(CHCnt,0)
				+ ISNULL(SVCnt,0)
				+ ISNULL(CANCELADDON,0)
				) AS TotalCnt

,	   (ISNULL(OmbreAmt,'0.00')
				+ ISNULL(ExLaceAmt,'0.00')
				+ ISNULL(LongHairAmt,'0.00')
				+ ISNULL(SignatureAmt,'0.00')
				+ ISNULL(SSAmt,'0.00')
				+ ISNULL(PKAmt,'0.00')
				+ ISNULL(NSDAmt,'0.00')
				+ ISNULL(CHAmt,'0.00')
				+ ISNULL(SVAmt,'0.00')
				) AS TotalAmt
FROM #Pivot



END
GO
