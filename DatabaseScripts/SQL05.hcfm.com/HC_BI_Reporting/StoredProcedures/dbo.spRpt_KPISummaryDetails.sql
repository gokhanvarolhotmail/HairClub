/* CreateDate: 03/06/2019 10:41:34.563 , ModifyDate: 03/16/2020 17:21:17.750 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_KPISummaryDetail]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		04/13/2017

==============================================================================
DESCRIPTION:	Drill-down for all except @Type IN(36,37) PCP; similar to the NB Flash Detail
==============================================================================
NOTES:	@Type	= 36 for PCP Revenue Actual, 37 for Total Center Revenue Actual
		@Filter = 2 for Areas; 3 for Centers
		PromotionCodeSSID 'MHSA' = MICROSCOPIC HAIR AND SCALP ANALYSIS
==============================================================================
CHANGE HISTORY:
04/17/2017 - RH - Created this stored procedure to provide detail for PCP Revenue and Total Center Revenue
01/25/2019 - RH - (Case #7101) Removed Surgery$ 10320 from Actual and Budget RB Revenue
01/28/2019 - RH - (Case #7507) Added MDP$ and MDP#; Remove Surgery# 10220; Replaced [10530 - PCP - PCP Sales $] with [10536 - PCP - BIO & EXTMEM & Xtrands Sales $]
03/04/2019 - RH - (Case 8516) Add PromotionCodeSSID; WHEN @Type IN (1,2,6,8,17,32) THEN DCM.ClientMembershipContractPrice; Made this sp the drill-down instead of [spRpt_FlashNewBusinessDetails]
01/09/2020 - RH - (TrackIT 5115) Added S_SurAmt to NetNB1Revenue
03/16/2020 - RH - (TrackIT 7697) Added S_PRPCnt and S_PRPAmt to NB_NetNBCnt, NB_NetNBAmt and Surgery
==============================================================================
SAMPLE EXECUTION:

EXEC [spRpt_KPISummaryDetails]  234, 17, '02/01/2020', '02/29/2020'
EXEC [spRpt_KPISummaryDetails]  234, 18, '02/01/2020', '02/29/2020'


drop table #Output
drop table #Final

==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_KPISummaryDetails] (
	@CenterNumber INT
,	@Type INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)

AS
BEGIN
	SET FMTONLY OFF;
	SET NOCOUNT ON;



/*
	  @Type = Flash Heading


	  10 = Applications (NB1A - Initial New Style)
	  11 = XTR+ Conversions
	  26 = EXT Conversions
	  28 = XTR Conversions
	  14 = MDP #
	  15 = MDP $
	  17 = Total NB1 Net #
	  18 = Total NB1 Net $
	  32 = Xtrands #
	  33 = Xtrands $
	  34 = Laser #
	  35 = Laser $

	  ContractAmount for 1,2,6,8,17,32
   */


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	CenterSSID INT
,	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(104)
,	MainGroupKey INT
,	MainGroupDescription NVARCHAR(50)
,	MainGroupSortOrder INT
)



CREATE TABLE #Accounting(
	CenterSSID INT
,	CenterDescriptionNumber NVARCHAR(104)
,	PartitionDate DATETIME
,	AccountID INT
,	AccountDescription NVARCHAR(150)
,	Actual MONEY
,	Budget MONEY
)

CREATE TABLE #MDP (
	CenterNumber INT
,	CenterDescriptionNumber VARCHAR(60)
,	MainGroupKey INT
,	MainGroupDescription NVARCHAR(50)
,	MainGroupSortOrder INT
,	ClientIdentifier VARCHAR(50)
,	ClientLastName VARCHAR(50)
,	ClientFirstName VARCHAR(50)
,	SalesOrderDetailKey VARCHAR(20)
,	InvoiceNumber VARCHAR(50)
,	FullDate SMALLDATETIME
,	SalesCodeDescriptionShort VARCHAR(50)
,	SalesCodeDescription VARCHAR(60)
,	qty INT
,	ExtendedPrice DECIMAL(18,4)
,	Tax1 DECIMAL(18,4)
,	Tax2 DECIMAL(18,4)
,	Consultant VARCHAR(50)
,	CancelReasonDescription VARCHAR(MAX)
,	SalesCodeDepartmentSSID VARCHAR(50)
,	Stylist VARCHAR(50)
,	MembershipDescription VARCHAR(50)
,	ClientMembershipKey INT
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
)




CREATE TABLE #Output (
	CenterNumber INT
,	CenterDescriptionNumber VARCHAR(60)
,	MainGroupKey INT
,	MainGroupDescription NVARCHAR(50)
,	MainGroupSortOrder INT
,	ClientIdentifier VARCHAR(50)
,	ClientLastName VARCHAR(50)
,	ClientFirstName VARCHAR(50)
,	SalesOrderDetailKey VARCHAR(20)
,	InvoiceNumber VARCHAR(50)
,	FullDate SMALLDATETIME
,	SalesCodeDescriptionShort VARCHAR(50)
,	SalesCodeDescription VARCHAR(60)
,	qty INT
,	ExtendedPrice DECIMAL(18,4)
,	Tax1 DECIMAL(18,4)
,	Tax2 DECIMAL(18,4)
,	Consultant VARCHAR(50)
,	CancelReasonDescription VARCHAR(MAX)
,	SalesCodeDepartmentSSID VARCHAR(50)
,	Stylist VARCHAR(50)
,	MembershipDescription VARCHAR(50)
,	ClientMembershipKey INT
,	NB_GrossNB1Cnt INT
,	NB_TradCnt INT
,	NB_TradAmt DECIMAL(18,4)
,	NB_GradCnt INT
,	NB_GradAmt DECIMAL(18,4)
,	NB_ExtCnt INT
,	NB_ExtAmt DECIMAL(18,4)
,	NB_XtrCnt INT
,	NB_XtrAmt DECIMAL(18,4)
,	S_SurCnt INT
,	S_SurAmt DECIMAL(18,4)
,	S_PostExtCnt INT
,	S_PostExtAmt DECIMAL(18,4)
,	NB_AppsCnt INT
,	NB_BIOConvCnt INT
,	NB_EXTConvCnt INT
,	NB_XTRConvCnt INT
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
,	NB_NetNBCnt INT
,	NB_NetNBAmt DECIMAL(18,4)
,   NB_LaserCnt INT
,   NB_LaserAmt DECIMAL(18,4)
,	S_PRPCnt INT
,	S_PRPAmt DECIMAL(18,4)
)

CREATE TABLE #Final (
	CenterNumber INT
,	CenterDescriptionNumber VARCHAR(60)
,	MainGroupKey INT
,	MainGroupDescription NVARCHAR(50)
,	MainGroupSortOrder INT
,	ClientIdentifier VARCHAR(50)
,	ClientLastName VARCHAR(50)
,	ClientFirstName VARCHAR(50)
,	SalesOrderDetailKey VARCHAR(20)
,	InvoiceNumber VARCHAR(50)
,	FullDate SMALLDATETIME
,	SalesCodeDescriptionShort VARCHAR(50)
,	SalesCodeDescription VARCHAR(60)
,	qty INT
,	graphs INT
,	ExtendedPrice DECIMAL(18,4)
,	Tax1 DECIMAL(18,4)
,	Tax2 DECIMAL(18,4)
,	Consultant VARCHAR(50)
,	CancelReasonDescription VARCHAR(MAX)
,	SalesCodeDepartmentSSID VARCHAR(50)
,	Stylist VARCHAR(50)
,	MembershipDescription VARCHAR(50)
,	GroupBy VARCHAR(50)
,	LaserTherapy VARCHAR(50)
,	PromotionCodeSSID VARCHAR(50)
)

CREATE TABLE #Laser(
	CenterNumber INT
,	LaserCnt INT
,	LaserAmt DECIMAL(18,4)
)



-- Find Partition Date for FactAccounting

DECLARE @StartPartitionDate DATETIME
SET @StartPartitionDate = @StartDate

/********************************** Get list of centers *************************************/

INSERT INTO #Centers
SELECT
	DC.CenterSSID
,	DC.CenterNumber
,	DC.CenterDescriptionNumber
,	CASE WHEN DCT.CenterTypeDescriptionShort IN('F','JV') THEN DR.RegionKey ELSE CMA.CenterManagementAreaKey END AS MainGroupKey
,	CASE WHEN DCT.CenterTypeDescriptionShort IN('F','JV') THEN DR.RegionDescription ELSE CMA.CenterManagementAreaDescription END AS MainGroupDescription
,	CASE WHEN DCT.CenterTypeDescriptionShort IN('F','JV') THEN DR.RegionSortOrder ELSE CMA.CenterManagementAreaSortOrder END AS MainGroupSortOrder
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
			ON DCT.CenterTypeKey = DC.CenterTypeKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
			ON DR.RegionKey = DC.RegionKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
WHERE   DC.CenterNumber = @CenterNumber
		AND DC.Active = 'Y'




/***************************** Find NB Laser Membership Counts and Revenue ************************************/
INSERT INTO #Laser
SELECT  DISTINCT
		q.CenterNumber
--,       q.CenterDescription
,       SUM(ISNULL(q.LaserCnt,0)) AS LaserCnt
,       SUM(ISNULL(q.LaserAmt,0)) AS LaserAmt
FROM (SELECT DD.FullDate
		,	C.CenterNumber
		,	ISNULL(FST.NB_LaserCnt, 0) AS LaserCnt
		,	ISNULL(FST.NB_LaserAmt, 0) AS LaserAmt
		,	SC.SalesCodeDescriptionShort
		,	SC.SalesCodeDescription
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
						INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
							ON FST.OrderDateKey = dd.DateKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
							ON fst.SalesCodeKey = sc.SalesCodeKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
							ON FST.SalesOrderKey = SO.SalesOrderKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
							ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
							ON SO.ClientMembershipKey = CM.ClientMembershipKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
							ON cm.MembershipKey = m.MembershipKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C				--Keep HomeCenter-based
							ON cm.CenterKey = c.CenterKey
						INNER JOIN #Centers
							ON C.CenterNumber = #Centers.CenterNumber
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
							ON FST.ClientKey = CLT.ClientKey
				WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
						AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
						AND SO.IsVoidedFlag = 0

							)q					--Membership Revenue

GROUP BY q.CenterNumber



/**************** Find MDP  *********************************************************************************************/

IF @Type IN(14,15)
BEGIN
INSERT INTO #MDP
SELECT  CTRS.CenterNumber, CTRS.CenterDescriptionNumber, CTRS.MainGroupKey, CTRS.MainGroupDescription, CTRS.MainGroupSortOrder, CLT.ClientIdentifier, CLT.ClientLastName, CLT.ClientFirstName
,       sod.SalesOrderDetailKey, SO.InvoiceNumber, DD.FullDate, SC.SalesCodeDescriptionShort, sc.SalesCodeDescription
,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
				WHEN m.BusinessSegmentSSID = 3
					AND SC.Salescodedepartmentssid = 1010 THEN 1
				ELSE FST.Quantity
		END AS qty
,       CASE WHEN @Type IN ( 1,2,6,32) THEN DCM.ClientMembershipContractPrice
				ELSE FST.ExtendedPrice
		END AS ExtendedPrice
,       FST.Tax1, FST.Tax2, E.EmployeeInitials AS Consultant
,       CASE WHEN sc.SalesCodeDescriptionShort = 'CANCEL' THEN CR.CancelReasonDescription ELSE NULL END AS CancelReasonDescription
,       sc.SalesCodeDepartmentSSID
,       E2.EmployeeInitials AS Stylist
,       M.MembershipDescription
,		DCM.ClientMembershipKey
,		FST.NB_MDPCnt
,		FST.NB_MDPAmt
FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
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
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON SO.ClientMembershipKey = DCM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
		ON DCM.MembershipKey = m.MembershipKey			--Changed to MembershipKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON DCM.CenterKey = C.CenterKey
	INNER JOIN #Centers CTRS
		ON C.CenterNumber = CTRS.CenterNumber
	LEFT JOIN HC_BI_Reporting.dbo.DimCancelReason cr
		ON cr.CancelReasonID = sod.CancelReasonID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
	AND SO.IsVoidedFlag = 0
	AND (FST.NB_MDPCnt <> 0 OR FST.NB_MDPAmt <> 0)

/****************** Find Promo Code, Type and Amount for MDP *******************************************************************************************/

SELECT O.ClientIdentifier
,	CLT.ContactKey
,	FL.PromotionCodeKey
,	PC.PromotionCodeSSID
INTO #MDPPromo
FROM #Output O
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON CLT.ClientIdentifier = O.ClientIdentifier
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
	ON CLT.contactkey = FAR.ContactKey
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
	ON FL.ContactKey = FAR.ContactKey
LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode PC
	ON PC.PromotionCodeKey = FL.PromotionCodeKey
WHERE FAR.Consultation = 1
GROUP BY O.ClientIdentifier,
         CLT.contactkey,
         FL.PromotionCodeKey,
         PC.PromotionCodeSSID

/****************** Queries for the fields for MDP *******************************************************************************************/

	IF @Type=14 --MDP #
		BEGIN
		INSERT INTO #Final
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,MDP.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	PRO.PromotionCodeSSID
			FROM #MDP MDP
			LEFT JOIN #MDPPromo PRO
				ON PRO.ClientIdentifier = MDP.ClientIdentifier
			WHERE NB_MDPCnt<>0
		END
	ELSE IF @Type=15 --MDP $
		BEGIN
		INSERT INTO #Final
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,MDP.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	PRO.PromotionCodeSSID
			FROM #MDP MDP
			LEFT JOIN #MDPPromo PRO
				ON PRO.ClientIdentifier = MDP.ClientIdentifier
			WHERE NB_MDPAmt<>0
		END

		SELECT * FROM #Final
END

ELSE
BEGIN


/***************** Populate #Output ************************************************************************************************/

INSERT  INTO #Output
SELECT  CTRS.CenterNumber, CTRS.CenterDescriptionNumber, CTRS.MainGroupKey, CTRS.MainGroupDescription, CTRS.MainGroupSortOrder, CLT.ClientIdentifier, CLT.ClientLastName, CLT.ClientFirstName
,       sod.SalesOrderDetailKey, SO.InvoiceNumber, DD.FullDate, SC.SalesCodeDescriptionShort, sc.SalesCodeDescription
,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
				WHEN m.BusinessSegmentSSID = 3
					AND SC.Salescodedepartmentssid = 1010 THEN 1
				WHEN ISNULL(FST.S_SurCnt,0) <> 0 THEN ISNULL(FST.S_SurCnt,0)
				WHEN ISNULL(FST.S_PRPCnt,0) <> 0 THEN ISNULL(FST.S_PRPCnt,0)
				ELSE FST.Quantity
		END AS qty
,       CASE WHEN @Type IN ( 1,2,6,32) THEN DCM.ClientMembershipContractPrice
			WHEN ISNULL(FST.S_SurAmt,0) <> 0 THEN ISNULL(FST.S_SurAmt,0)
			WHEN ISNULL(FST.S_PRPAmt,0) <> 0 THEN ISNULL(FST.S_PRPAmt,0)
				ELSE FST.ExtendedPrice
		END AS ExtendedPrice
,       FST.Tax1, FST.Tax2, E.EmployeeInitials AS Consultant
,       CASE WHEN sc.SalesCodeDescriptionShort = 'CANCEL' THEN CR.CancelReasonDescription ELSE NULL END AS CancelReasonDescription
,       sc.SalesCodeDepartmentSSID
,       E2.EmployeeInitials AS Stylist
,       M.MembershipDescription
,		DCM.ClientMembershipKey
,       ISNULL(FST.NB_GrossNB1Cnt, 0) AS NB_GrossNB1Cnt
,       ISNULL(FST.NB_TradCnt, 0) AS NB_TradCnt
,       ISNULL(FST.NB_TradAmt, 0) AS NB_TradAmt
,       ISNULL(FST.NB_GradCnt, 0) AS NB_GradCnt
,       ISNULL(FST.NB_GradAmt, 0) AS NB_GradAmt
,       ISNULL(FST.NB_ExtCnt, 0) AS NB_ExtCnt
,       ISNULL(FST.NB_ExtAmt, 0) AS NB_ExtAmt
,       ISNULL(FST.NB_XtrCnt, 0) AS NB_XtrCnt
,       ISNULL(FST.NB_XtrAmt, 0) AS NB_XtrAmt

,       ISNULL(FST.S_SurCnt, 0) + ISNULL(FST.S_PRPCnt, 0) AS S_SurCnt
,       ISNULL(FST.S_SurAmt, 0) + ISNULL(FST.S_PRPAmt, 0) AS S_SurAmt

,       ISNULL(FST.S_PostExtCnt, 0) AS S_PostExtCnt
,       ISNULL(FST.S_PostExtAmt, 0) AS S_PostExtAmt
,       ISNULL(FST.NB_AppsCnt, 0) AS NB_AppsCnt
,       ISNULL(FST.NB_BIOConvCnt, 0) AS NB_BIOConvCnt
,		ISNULL(FST.NB_EXTConvCnt, 0) AS NB_EXTConvCnt
,		ISNULL(FST.NB_XTRConvCnt, 0) AS NB_XTRConvCnt
,       ISNULL(FST.NB_MDPCnt,0) AS NB_MDPCnt
,       ISNULL(FST.NB_MDPAmt,0) AS NB_MDPAmt
,       ( ISNULL(FST.NB_TradCnt, 0)
			+ ISNULL(FST.NB_GradCnt, 0)
			+ ISNULL(FST.NB_ExtCnt, 0)
			+ ISNULL(FST.NB_XtrCnt, 0)
			+ ISNULL(FST.S_PostExtCnt, 0)
			+ ISNULL(FST.NB_MDPCnt, 0)
			+ ISNULL(FST.S_SurCnt, 0)
			+ ISNULL(FST.S_PRPCnt, 0)) AS NB_NetNBCnt
,       ( ISNULL(FST.NB_TradAmt, 0)
			+ ISNULL(FST.NB_GradAmt, 0)
			+ ISNULL(FST.NB_ExtAmt, 0)
			+ ISNULL(FST.NB_XtrAmt, 0)
			+ ISNULL(FST.S_PostExtAmt, 0)
			+ ISNULL(FST.NB_MDPAmt, 0)
			+ ISNULL(FST.S_SurAmt,0)
			+ ISNULL(FST.NB_LaserAmt, 0)
			+ ISNULL(FST.S_PRPAmt, 0)) AS NB_NetNBAmt
,       ISNULL(FST.NB_LaserCnt,0) AS NB_LaserCnt
,       ISNULL(FST.NB_LaserAmt,0) AS NB_LaserAmt
,		ISNULL(FST.S_PRPCnt,0) AS S_PRPCnt
,		ISNULL(FST.S_PRPAmt,0) AS S_PRPAmt
FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
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
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON SO.ClientMembershipKey = DCM.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
		ON DCM.MembershipKey = m.MembershipKey			--Changed to MembershipKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON DCM.CenterKey = C.CenterKey
	INNER JOIN #Centers CTRS
		ON C.CenterNumber = CTRS.CenterNumber
	LEFT JOIN HC_BI_Reporting.dbo.DimCancelReason cr
		ON cr.CancelReasonID = sod.CancelReasonID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
	AND SO.IsVoidedFlag = 0
	AND (  ISNULL(FST.NB_GrossNB1Cnt, 0) <> 0
		OR ISNULL(FST.NB_TradCnt, 0) <> 0
		OR ISNULL(FST.NB_TradAmt,0) <> 0
		OR ISNULL(FST.NB_GradCnt,0) <> 0
		OR ISNULL(FST.NB_GradAmt,0) <> 0
		OR ISNULL(FST.NB_ExtCnt,0) <> 0
		OR ISNULL(FST.NB_ExtAmt,0) <> 0
		OR ISNULL(FST.NB_XtrCnt,0) <> 0
		OR ISNULL(FST.NB_XtrAmt,0) <> 0
		OR ISNULL(FST.S_PostExtCnt,0) <> 0
		OR ISNULL(FST.S_PostExtAmt,0) <> 0
		OR ISNULL(FST.S_SurCnt, 0) <> 0
		OR ISNULL(FST.S_SurAmt, 0) <> 0
		OR ISNULL(FST.S_PRPCnt,0) <> 0
		OR ISNULL(FST.S_PRPAmt,0) <> 0
		OR ISNULL(FST.NB_AppsCnt, 0) <> 0
		OR ISNULL(FST.NB_BIOConvCnt, 0) <> 0
		OR ISNULL(FST.NB_EXTConvCnt, 0) <> 0
		OR ISNULL(FST.NB_XTRConvCnt, 0) <> 0
		OR ISNULL(FST.NB_LaserCnt, 0) <> 0
		OR ISNULL(FST.NB_LaserAmt, 0) <> 0
		OR ISNULL(FST.NB_MDPCnt, 0) <> 0
		OR ISNULL(FST.NB_MDPAmt, 0) <> 0
		)
GROUP BY m.BusinessSegmentSSID
,         FST.Quantity
,         DCM.ClientMembershipContractPrice
,         FST.ExtendedPrice
,         CR.CancelReasonDescription
,         ISNULL(FST.NB_GrossNB1Cnt, 0)
,         ISNULL(FST.NB_TradCnt, 0)
,         ISNULL(FST.NB_TradAmt, 0)
,         ISNULL(FST.NB_GradCnt, 0)
,         ISNULL(FST.NB_GradAmt, 0)
,         ISNULL(FST.NB_ExtCnt, 0)
,         ISNULL(FST.NB_ExtAmt, 0)
,         ISNULL(FST.NB_XtrCnt, 0)
,         ISNULL(FST.NB_XtrAmt, 0)
,         ISNULL(FST.S_SurCnt, 0)
,		  ISNULL(FST.S_SurAmt, 0)
,         ISNULL(FST.S_PRPCnt, 0)
,		  ISNULL(FST.S_PRPAmt, 0)
,         ISNULL(FST.S_PostExtCnt, 0)
,         ISNULL(FST.S_PostExtAmt, 0)
,         ISNULL(FST.NB_AppsCnt, 0)
,         ISNULL(FST.NB_BIOConvCnt, 0)
,         ISNULL(FST.NB_EXTConvCnt, 0)
,         ISNULL(FST.NB_XTRConvCnt, 0)
,         ISNULL(FST.NB_MDPCnt,0)
,         ISNULL(FST.NB_MDPAmt,0)
,       ( ISNULL(FST.NB_TradCnt, 0)
			+ ISNULL(FST.NB_GradCnt, 0)
			+ ISNULL(FST.NB_ExtCnt, 0)
			+ ISNULL(FST.NB_XtrCnt, 0)
			+ ISNULL(FST.S_PostExtCnt, 0)
			+ ISNULL(FST.NB_MDPCnt, 0)
			+ ISNULL(FST.S_SurCnt, 0)
			+ ISNULL(FST.S_PRPCnt,0) )
,       ( ISNULL(FST.NB_TradAmt, 0)
			+ ISNULL(FST.NB_GradAmt, 0)
			+ ISNULL(FST.NB_ExtAmt, 0)
			+ ISNULL(FST.NB_XtrAmt, 0)
			+ ISNULL(FST.S_PostExtAmt, 0)
			+ ISNULL(FST.NB_MDPAmt, 0)
			+ ISNULL(FST.S_SurAmt,0)
			+ ISNULL(FST.NB_LaserAmt, 0)
			+ ISNULL(FST.S_PRPCnt,0) )
,         ISNULL(FST.NB_LaserCnt,0)
,         ISNULL(FST.NB_LaserAmt,0)
,         CTRS.CenterNumber
,         CTRS.CenterDescriptionNumber
,         CTRS.MainGroupKey
,         CTRS.MainGroupDescription
,         CTRS.MainGroupSortOrder
,         CLT.ClientIdentifier
,         CLT.ClientLastName
,         CLT.ClientFirstName
,         SOD.SalesOrderDetailKey
,         SO.InvoiceNumber
,         DD.FullDate
,         SC.SalesCodeDescriptionShort
,         SC.SalesCodeDescription
,         FST.Tax1
,         FST.Tax2
,         E.EmployeeInitials
,         SC.SalesCodeDepartmentSSID
,         E2.EmployeeInitials
,         m.MembershipDescription
,         DCM.ClientMembershipKey
,		  SO.IsVoidedFlag



/****************** Find Promo Code, Type and Amount *******************************************************************************************/

SELECT O.ClientIdentifier
,	CLT.ContactKey
,	FL.PromotionCodeKey
,	PC.PromotionCodeSSID
INTO #Promo
FROM #Output O
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON CLT.ClientIdentifier = O.ClientIdentifier
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
	ON CLT.contactkey = FAR.ContactKey
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
	ON FL.ContactKey = FAR.ContactKey
LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode PC
	ON PC.PromotionCodeKey = FL.PromotionCodeKey
WHERE FAR.Consultation = 1
GROUP BY O.ClientIdentifier,
         CLT.contactkey,
         FL.PromotionCodeKey,
         PC.PromotionCodeSSID

/*************** Insert into #Final ***************************************************************************************************************/

	 IF @Type=10 --Applications
		BEGIN
		INSERT INTO #Final
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ISNULL(ExtendedPrice,0) AS ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE NB_AppsCnt<>0
		END

	ELSE IF @Type=11 -- XTR+ Conversions
		BEGIN
		INSERT INTO #Final
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ISNULL(ExtendedPrice,0) AS ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE NB_BIOConvCnt<>0
		END

	ELSE IF @Type=26 -- EXT Conversions
		BEGIN
		INSERT INTO #Final
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ISNULL(ExtendedPrice,0) AS ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE NB_EXTConvCnt<>0
		END


	ELSE IF @Type=28 -- XTR Conversions
		BEGIN
		INSERT INTO #Final
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ISNULL(ExtendedPrice,0) AS ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE NB_XTRConvCnt<>0
		END

	ELSE IF @Type=34 --LaserCnt #
		BEGIN
		INSERT INTO #Final
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,O.SalesCodeDescriptionShort,O.SalesCodeDescription
			,	 qty,NULL AS grafts
			--,ISNULL(ExtendedPrice,0) AS ExtendedPrice
			,ISNULL(NB_LaserAmt,0) AS ExtendedPrice
			,Tax1
			,Tax2
			,Consultant
			,CancelReasonDescription
			,SalesCodeDepartmentSSID
			,Stylist
			,MembershipDescription
			,MembershipDescription  AS GroupBy
			,ISNULL(q_LSR.SalesCodeDescription, '') AS LaserTherapy
			,P.PromotionCodeSSID
			FROM #Output O
				OUTER APPLY (
								  -- Get Laser Membership NB Counts
                                  --SELECT    TOP 1
								  SELECT    DISTINCT
											FST.ClientKey
                                  ,         DCM.ClientMembershipKey
                                  ,         DSC.SalesCodeDescriptionShort
                                  ,         REPLACE(DSC.SalesCodeDescription, ' Payment', '') AS SalesCodeDescription
                                  FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
                                            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
                                                ON FST.OrderDateKey = DD.DateKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
                                                ON FST.SalesCodeKey = DSC.SalesCodeKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
                                                ON FST.SalesOrderKey = DSO.SalesOrderKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH ( NOLOCK )
                                                ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
                                                ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
									WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
											AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
											AND DSO.IsVoidedFlag = 0
										    AND DCM.ClientMembershipKey = O.ClientMembershipKey
											AND (FST.NB_LaserAmt <> 0 OR FST.NB_Lasercnt <> 0)
                                ) q_LSR
				LEFT JOIN #Promo P
					ON P.ClientIdentifier = O.ClientIdentifier
			GROUP BY ISNULL(q_LSR.SalesCodeDescription, ''),
                     O.CenterNumber,
                     O.CenterDescriptionNumber,
                     O.MainGroupKey,
                     O.MainGroupDescription,
                     O.MainGroupSortOrder,
                     O.ClientIdentifier,
                     O.ClientLastName,
                     O.ClientFirstName,
                     O.SalesOrderDetailKey,
                     O.InvoiceNumber,
                     O.FullDate,
                     O.SalesCodeDescriptionShort,
                     O.SalesCodeDescription,
                     O.qty,
                     --O.ExtendedPrice,
					 O.NB_LaserAmt,
                     O.Tax1,
                     O.Tax2,
                     O.Consultant,
                     O.CancelReasonDescription,
                     O.SalesCodeDepartmentSSID,
                     O.Stylist,
                     O.MembershipDescription,
					 P.PromotionCodeSSID
		END
	ELSE IF @Type=35 --LaserAmt $
		BEGIN
		INSERT INTO #Final
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,O.SalesCodeDescriptionShort,O.SalesCodeDescription
			,qty,NULL AS grafts
			--,ISNULL(ExtendedPrice,0) AS ExtendedPrice
			,ISNULL(O.NB_LaserAmt,0) AS ExtendedPrice
			,Tax1
			,Tax2
			,Consultant
			,CancelReasonDescription
			,SalesCodeDepartmentSSID
			,Stylist
			,MembershipDescription
			,MembershipDescription  AS GroupBy
			,ISNULL(p_LSR.SalesCodeDescription, '') AS LaserTherapy
			,P.PromotionCodeSSID
			FROM #Output O
				OUTER APPLY (
								  -- Get Laser Membership Revenue
                                  --SELECT    TOP 1
								  SELECT    DISTINCT
											FST.ClientKey
                                  ,         DCM.ClientMembershipKey
                                  ,         DSC.SalesCodeDescriptionShort
                                  ,         REPLACE(DSC.SalesCodeDescription, ' Payment', '') AS SalesCodeDescription
                                  FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
                                            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
                                                ON FST.OrderDateKey = DD.DateKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
                                                ON FST.SalesCodeKey = DSC.SalesCodeKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
                                                ON FST.SalesOrderKey = DSO.SalesOrderKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH ( NOLOCK )
                                                ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
                                                ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
									WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
											AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
											AND DSO.IsVoidedFlag = 0
										    AND DCM.ClientMembershipKey = O.ClientMembershipKey
											AND (FST.NB_LaserAmt <> 0 OR FST.NB_Lasercnt <> 0)

                                ) p_LSR
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			GROUP BY ISNULL(p_LSR.SalesCodeDescription, ''),
                     O.CenterNumber,
                     O.CenterDescriptionNumber,
                     O.MainGroupKey,
                     O.MainGroupDescription,
                     O.MainGroupSortOrder,
                     O.ClientIdentifier,
                     O.ClientLastName,
                     O.ClientFirstName,
                     O.SalesOrderDetailKey,
                     O.InvoiceNumber,
                     O.FullDate,
                     O.SalesCodeDescriptionShort,
                     O.SalesCodeDescription,
                     O.qty,
					 O.NB_LaserAmt,
                     O.Tax1,
                     O.Tax2,
                     O.Consultant,
                     O.CancelReasonDescription,
                     O.SalesCodeDepartmentSSID,
                     O.Stylist,
                     O.MembershipDescription,
					 P.PromotionCodeSSID
		END

	ELSE IF @Type=17 --Total NB1 Net #
		BEGIN
		INSERT INTO #Final
            SELECT  O.CenterNumber
			,	O.CenterDescriptionNumber
			,	O.MainGroupKey
			,	O.MainGroupDescription
			,	O.MainGroupSortOrder
			,	O.ClientIdentifier
			,	O.ClientLastName
			,	O.ClientFirstName
			,	O.SalesOrderDetailKey
			,	O.InvoiceNumber
			,	O.FullDate
			,	O.SalesCodeDescriptionShort
			,	O.SalesCodeDescription
			,	CASE WHEN ISNULL(S_PRPCnt,0) <> 0 THEN O.S_PRPCnt
					WHEN ISNULL(S_SurCnt,0) <> 0 THEN O.S_SurCnt
					ELSE O.qty END AS qty
			,	NULL AS graphs
			,	CASE WHEN ISNULL(S_PRPAmt,0) <> 0 THEN O.S_PRPAmt
					WHEN ISNULL(S_SurAmt,0) <> 0 THEN O.S_SurAmt
				ELSE ISNULL(O.ExtendedPrice,0) END AS ExtendedPrice
			,	O.Tax1
			,	O.Tax2
			,	O.Consultant
			,	O.CancelReasonDescription
			,	O.SalesCodeDepartmentSSID
			,	O.Stylist
			,	O.MembershipDescription
			,	O.MembershipDescription AS GroupBy
			,		ISNULL(o_LSR.SalesCodeDescription, '') AS LaserTherapy
			,	P.PromotionCodeSSID
            FROM    #Output O
                    OUTER APPLY (
								  -- Get Laser Device sales
                                  SELECT    TOP 1
											FST.ClientKey
                                  ,         DCM.ClientMembershipKey
                                  ,         DSC.SalesCodeDescriptionShort
                                  ,         REPLACE(DSC.SalesCodeDescription, ' Payment', '') AS SalesCodeDescription
                                  FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
                                            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
                                                ON FST.OrderDateKey = DD.DateKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
                                                ON FST.SalesCodeKey = DSC.SalesCodeKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
                                                ON FST.SalesOrderKey = DSO.SalesOrderKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH ( NOLOCK )
                                                ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
                                                ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
                                  WHERE     DSC.SalesCodeSSID IN ( 682, 781, 853, 855, 856, 857, 858, 859, 673, 674, 780, 852, 854 )
                                            AND DSO.IsVoidedFlag = 0
											AND DCM.ClientMembershipKey = O.ClientMembershipKey
								  ORDER BY DD.FullDate DESC
                                ) o_LSR
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
            WHERE   ISNULL(NB_NetNBCnt,0) <> 0
		END
	ELSE IF @Type=18 --Total NB1 Net $
		BEGIN
		INSERT INTO #Final
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	CASE WHEN ISNULL(S_PRPCnt,0) <> 0 THEN O.S_PRPCnt
					WHEN ISNULL(S_SurCnt,0) <> 0 THEN O.S_SurCnt
					ELSE O.qty END AS qty
			,	NULL AS grafts
			,    CASE WHEN ISNULL(S_PRPAmt,0) <> 0 THEN O.S_PRPAmt
					WHEN ISNULL(S_SurAmt,0) <> 0 THEN O.S_SurAmt
				ELSE ISNULL(O.ExtendedPrice,0) END AS ExtendedPrice
			,    Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE NB_NetNBAmt<>0

		END

		SELECT * FROM #Final


END

END
GO
