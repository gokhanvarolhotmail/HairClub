/* CreateDate: 12/17/2018 12:10:25.690 , ModifyDate: 08/31/2021 16:59:36.843 */
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashNewBusinessDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB1 Flash Details
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
------------------------------------------------------------------------
CHANGE HISTORY:
12/26/2012 - MB - Changed query so that surgery monies go to appropriate center
01/22/2013 - MB - Changed query to bring back contract price for some drilldowns (WO# 82649)
02/22/2013 - KM - Modified Group by to by Sales Code - Member1
03/05/2013 - KM - Modified Group by to be by Member1 only
04/08/2013 - KM - Modified ClientNo to be ClientIdentifer rather than ClientKey
05/22/2013 - MB - Added filter for IsVoidedFlag
06/04/2013 - MB - Added InvoiceNumber and SalesOrderDetailKey to output (WO# 87259)
06/13/2013 - KM - (#86761) Modified select to derive membership from SOD rather than SO for SC = 'CANCEL'
06/13/2013 - KM - (#86761) Modified quantity for INITASG Surgery Sales to be 1 rather than Graft Count (found in testing)
10/08/2013 - DL - (#89184) Added Group By Region/RSM filter
10/15/2013 - DL - (#89184) Added @Filter procedure parameter
10/15/2013 - DL - (#89184) Added additional RSM roll-up filters
10/19/2013 - DL - Removed the following line from the procedure: SET @enddt = @enddt + ' 23:59:59'
01/27/2014 - DL - (#94826) Added additional query to determine Applications using Transaction Center.
04/07/2014 - RH - (#100145) Changed WHERE DR.RegionSSID = @CenterSSID to WHERE DC.RegionSSID = @CenterSSID (under Region code for #Center)
05/03/2014 - RH - (#102515) Added @type 32 = Xtrands # and 33 = Xtrands $; Added NB_XtrCnt and NB_XtrAmt to the fields and the totals for NB_NetNBCnt and NB_NetNBAmt.
04/21/2015 - RH - (Kevin) Changed prevm. to m. in code to find Member1 to remove 'Unknown' in the report.
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
04/27/2016 - RH - (#125714) Changed to Home-center based (CM.CenterSSID) for Applications - to match the NB Flash Summary and the NB Warboard
08/04/2016 - DL - (#126571) Added Laser Therapy column query for #Net Sales count drilldown
10/10/2016 - RH - (#123213) Added CM.MembershipCancelReasonDescription from datClientMembership synonym; Changed to MembershipKey
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID; Added @Filter
01/18/2017 - RH - (#132688) Added CenterManagementAreaSSID,CenterManagementAreaDescription to #Output
04/14/2017 - RH - (#137105) Changed logic for finding Area centers to use DimCenterManagementArea
08/07/2017 - RH - (#141865) (For @type = 8) Changed Qty to S_SurCnt for "Surgery #" and Qty to "Grafts"
01/11/2018 - RH - (#145957) Added join on CenterType and removed Corporate Regions
06/18/2018 - RH - Added Hans Wiemannn CT.CenterTypeDescriptionShort IN('C','HW')
12/17/2018 - RH - (Case 6815) This version includes MDP, joins PostEXT to EXT, joins Trad and Grad
12/31/2018 - RH - (Case 6815) Added LaserCnt and LaserAmt
03/04/2019 - RH - (Case 8516) Add PromotionCodeSSID
05/20/2019 - JL - (Case 4824) Added drill down to report
09/27/2019 - JL - (TrackIT 1448/TFS 13158) Change MDP to RestorInk in header and grouping
10/16/2019 - JL - (TrackIT 1737) Change join in #laser to join CLT.CenterSSID = c.CenterSSID to Keep HomeCenter-based
01/07/2020 - RH - (TrackIT 4257) Added S_SurAmt
01/16/2020 - RH - Temporary fix until the NB_MDPAmt is changed - added SC.SalesCodeDescription NOT LIKE 'Add-On%' for RestorInk (email from MO and Rev)
01/23/2020 - RH - Returned NB_MDPCnt and NB_MDPAmt back to the original code since this issue has been fixed in the extract.
03/03/2020 - RH - TrackIT 7697 Changed to use S_PRPAmt for MEDADDON - ExtendedPrice was duplicating the $$ for surgery
03/11/2020 - RH - TrackIT 7697 Added @Type = 41 for PRP # and 42 for PRP $; Added PRP to Surgery totals
03/11/2021 - NC - Add New tables due to refactor (HC_BI_SFDC.dbo.Lead L ).
------------------------------------------------------------------------
SAMPLE EXECUTION:


EXEC spRpt_FlashNewBusinessDetails 234, 8,	'2/1/2020', '2/29/2020', 3
EXEC spRpt_FlashNewBusinessDetails 234, 9,	'2/1/2020', '2/29/2020', 3
EXEC spRpt_FlashNewBusinessDetails 234, 17,	'2/1/2020', '2/29/2020', 3
EXEC spRpt_FlashNewBusinessDetails 234, 18,	'2/1/2020', '2/29/2020', 3
EXEC spRpt_FlashNewBusinessDetails 234, 41,	'2/1/2020', '2/29/2020', 3
EXEC spRpt_FlashNewBusinessDetails 234, 42,	'2/1/2020', '2/29/2020', 3

EXEC spRpt_FlashNewBusinessDetails 0, 9,	'2/1/2020', '2/29/2020', 2
EXEC spRpt_FlashNewBusinessDetails 0, 6,	'2/1/2020', '2/29/2020', 2
EXEC spRpt_FlashNewBusinessDetails 0, 6,	'2/1/2020', '2/29/2020', 1
EXEC spRpt_FlashNewBusinessDetails 9, 190,	'2/1/2020', '2/29/2020', 1
EXEC spRpt_FlashNewBusinessDetails 201, 1,	'2/1/2020', '2/29/2020', 4
EXEC spRpt_FlashNewBusinessDetails 0, 17,	'2/1/2020', '2/29/2020', 2

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FlashNewBusinessDetails]
(
	@center INT
,	@type INT
,	@begdt DATETIME
,	@enddt DATETIME
,	@Filter INT
)
AS
BEGIN

/*****FOR TESTING **********************
DECLARE @center INT
DECLARE @type INT
DECLARE @begdt DATETIME
DECLARE @enddt DATETIME
DECLARE @Filter INT

SET @center =234
SET @type   =8
SET @begdt  ='6/15/2021'
SET @enddt  ='6/30/2021'
SET @Filter =3
*/

   /*
	  @Type = Flash Heading

	  1 = Total NB1 Gross #
	  2 = Traditional # + Grad # (XP #)
	  3 = Traditional $ + Gradual $ (XP $)
	  6 = Extreme # + PostEXT #
	  7 = Extreme $ + PostEXT $
	  8 = Surgery #
	  9 = Surgery $
	  10 = Applications
	  11 = Conversions (Excludes EXT + XTR Conversions)
	  14 = MDP #
	  15 = MDP $
	  17 = Total NB1 Net #
	  18 = Total NB1 Net $
	  32 = Xtrands #
	  33 = Xtrands $
	  34 = Laser #
	  35 = Laser $
	  41 = PRP #
	  42 = PRP $

	  ContractAmount for 1,2,6,32 (#)
   */


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	CenterID INT
,	CenterNumber INT
,	CenterDescriptionNumber NVARCHAR(104)
,	MainGroupKey INT
,	MainGroupDescription NVARCHAR(50)
,	MainGroupSortOrder INT
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
,	Voided VARCHAR(10)
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
,	S_PRPCnt INT
,	S_PRPAmt DECIMAL(18,4)
,	NB_AppsCnt INT
,	NB_BIOConvCnt INT
,	NB_MDPCnt INT
,	NB_MDPAmt DECIMAL(18,4)
,	NB_NetNBCnt INT
,	NB_NetNBAmt DECIMAL(18,4)
)


/********************************** Get list of centers *************************************/
IF @Filter = 1										-- A Franchise Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
				,	DC.CenterNumber
				,	DC.CenterDescriptionNumber
				,	DR.RegionKey AS MainGroupKey
				,	DR.RegionDescription AS MainGroupDescription
				,	DR.RegionSortOrder AS MainGroupSortOrder
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   (DC.RegionSSID = @Center OR @Center = 0)
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ('F','JV')
	END
ELSE
IF @Filter = 2
		BEGIN
			INSERT INTO #Centers
			SELECT DC.CenterSSID
			,	DC.CenterNumber
			,	DC.CenterDescriptionNumber
			,	CMA.CenterManagementAreaKey AS MainGroupKey
			,	CMA.CenterManagementAreaDescription AS MainGroupDescription
			,	CMA.CenterManagementAreaSortOrder AS MainGroupSortOrder
			FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			WHERE   (CMA.CenterManagementAreaSSID = @Center OR @Center = 0)
					AND CMA.Active = 'Y'
					AND DC.Active = 'Y'
					AND CT.CenterTypeDescriptionShort IN('C','HW')

	END

ELSE
IF @Filter = 3 									-- A Center has been selected.
	BEGIN
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
		WHERE   DC.CenterNumber = @Center
				AND DC.Active = 'Y'

	END
ELSE
IF (@Filter = 4 AND @center = 355)
			BEGIN
				INSERT INTO #Centers
				SELECT DISTINCT DC.CenterSSID
				,	DC.CenterNumber
				,	DC.CenterDescriptionNumber
				,	CMA.CenterManagementAreaKey AS MainGroupKey
				,	CMA.CenterManagementAreaDescription AS MainGroupDescription
				,	CMA.CenterManagementAreaSortOrder AS MainGroupSortOrder
				FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE    CMA.Active = 'Y'
						AND CT.CenterTypeDescriptionShort IN ('HW')
			END

ELSE
IF @Filter = 4
			BEGIN
				INSERT INTO #Centers
				SELECT DISTINCT DC.CenterSSID
				,	DC.CenterNumber
				,	DC.CenterDescriptionNumber
				,	CMA.CenterManagementAreaKey AS MainGroupKey
				,	CMA.CenterManagementAreaDescription AS MainGroupDescription
				,	CMA.CenterManagementAreaSortOrder AS MainGroupSortOrder
				FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE   CMA.Active = 'Y'
						AND CT.CenterTypeDescriptionShort IN ('C')
			END

/**************** Find MDP  *********************************************************************************************/

SELECT  CTRS.CenterNumber, CTRS.CenterDescriptionNumber, CTRS.MainGroupKey, CTRS.MainGroupDescription, CTRS.MainGroupSortOrder, CLT.ClientIdentifier, CLT.ClientLastName, CLT.ClientFirstName
,       sod.SalesOrderDetailKey, SO.InvoiceNumber, DD.FullDate, SC.SalesCodeDescriptionShort, sc.SalesCodeDescription
,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
				WHEN m.BusinessSegmentSSID = 3
					AND SC.Salescodedepartmentssid = 1010 THEN 1
				ELSE FST.Quantity
		END AS qty
,       CASE WHEN @Type IN ( 1,2,6,8,17,32) THEN DCM.ClientMembershipContractPrice
				ELSE FST.ExtendedPrice
		END AS ExtendedPrice
,       FST.Tax1, FST.Tax2, E.EmployeeInitials AS Consultant
,       CASE WHEN sc.SalesCodeDescriptionShort = 'CANCEL' THEN CR.CancelReasonDescription ELSE NULL END AS CancelReasonDescription
,       sc.SalesCodeDepartmentSSID
,       E2.EmployeeInitials AS Stylist
,       CASE WHEN ISNULL(SO.IsVoidedFlag, 0) = 1 THEN 'v'
				ELSE ''
		END AS Voided
,       M.MembershipDescription
,		DCM.ClientMembershipKey
,		FST.NB_MDPCnt
,		FST.NB_MDPAmt
INTO #MDP
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
WHERE   DD.FullDate BETWEEN @BegDt AND @EndDt
	AND ( SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
			OR SC.SalesCodeDescriptionShort = 'ADDBIOSYS' )
	AND SO.IsVoidedFlag = 0
	AND (FST.NB_MDPCnt <> 0 OR FST.NB_MDPAmt <> 0)


/****************** Find Promo Code, Type and Amount for MDP *******************************************************************************************/
/*CODE WITH OUT SENCE DUE TO #OutPut doesn't have any information at this point*/
SELECT O.ClientIdentifier
,	CLT.ContactKey
,	PC.PromotionCodeKey
,	PC.PromotionCodeSSID
INTO #MDPPromo
FROM #Output O
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON CLT.ClientIdentifier = O.ClientIdentifier
INNER JOIN HC_BI_SFDC.dbo.Lead L  WITH (NOLOCK) --> Added 07/15
	ON CLT.SFDC_Leadid = L.Id
LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS WITH (NOLOCK) --> Added 07/15
    ON DS.SourceSSID = L.RecentSourceCode__c
LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode PC
	ON PC.PromotionCodeKey = DS.PromoCode
--WHERE FAR.Consultation = 1
GROUP BY O.ClientIdentifier,
         CLT.contactkey,
         PC.PromotionCodeKey,
         PC.PromotionCodeSSID

/************** Code removed from code has been added ***************
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
	ON CLT.contactkey = FAR.ContactKey
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
	ON FL.ContactKey = FAR.ContactKey
********************************************************************/

/****************** Queries for the fields for MDP *******************************************************************************************/

IF @Type=14 --MDP #
	BEGIN
		SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,MDP.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
		,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
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
		SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,MDP.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
		,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
		,	 MembershipDescription  AS GroupBy
		,	'' AS LaserTherapy
		,	PRO.PromotionCodeSSID
		FROM #MDP MDP
		LEFT JOIN #MDPPromo PRO
			ON PRO.ClientIdentifier = MDP.ClientIdentifier
		WHERE NB_MDPAmt<>0
	END;

/***************** Populate #Output ************************************************************************************************/
with cte as (
select FST.*,ROW_NUMBER() OVER(PARTITION BY clt.ClientIdentifier ORDER BY sod.OrderDate ASC) as RowNum
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
		)

INSERT  INTO #Output
SELECT  DISTINCT CTRS.CenterNumber, CTRS.CenterDescriptionNumber, CTRS.MainGroupKey, CTRS.MainGroupDescription, CTRS.MainGroupSortOrder, CLT.ClientIdentifier, CLT.ClientLastName, CLT.ClientFirstName
,       sod.SalesOrderDetailKey, SO.InvoiceNumber, DD.FullDate, SC.SalesCodeDescriptionShort, sc.SalesCodeDescription
,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
				WHEN (m.BusinessSegmentSSID = 3 AND SC.Salescodedepartmentssid = 1010) THEN 1
				ELSE FST.Quantity
		END AS qty
,       CASE WHEN @Type IN ( 1,2,6,32) THEN DCM.ClientMembershipContractPrice
			ELSE FST.ExtendedPrice
		END AS ExtendedPrice
,       FST.Tax1, FST.Tax2, E.EmployeeInitials AS Consultant
,       CASE WHEN sc.SalesCodeDescriptionShort = 'CANCEL' THEN CR.CancelReasonDescription ELSE NULL END AS CancelReasonDescription
,       sc.SalesCodeDepartmentSSID
,       E2.EmployeeInitials AS Stylist
,       CASE WHEN ISNULL(SO.IsVoidedFlag, 0) = 1 THEN 'v'
				ELSE ''
		END AS Voided
,       M.MembershipDescription
,		DCM.ClientMembershipKey
,       ISNULL(FST.NB_GrossNB1Cnt, 0) + ISNULL(FST.NB_MDPCnt, 0) AS NB_GrossNB1Cnt
,       ISNULL(FST.NB_TradCnt, 0) AS NB_TradCnt
,       ISNULL(FST.NB_TradAmt, 0) AS NB_TradAmt
,       ISNULL(FST.NB_GradCnt, 0) AS NB_GradCnt
,       ISNULL(FST.NB_GradAmt, 0) AS NB_GradAmt
,       ISNULL(FST.NB_ExtCnt, 0) AS NB_ExtCnt
,       ISNULL(FST.NB_ExtAmt, 0) AS NB_ExtAmt
,       ISNULL(FST.NB_XtrCnt, 0) AS NB_XtrCnt
,       ISNULL(FST.NB_XtrAmt, 0) AS NB_XtrAmt
,       ISNULL(FST.S_SurCnt, 0) + ISNULL(FST.S_PRPCnt,0) AS S_SurCnt	--Add PRP to the total counts
,       ISNULL(FST.S_SurAmt, 0) + ISNULL(FST.S_PRPAmt,0) AS S_SurAmt	--Add PRP to the total counts
,       ISNULL(FST.S_PostExtCnt, 0) AS S_PostExtCnt
,       ISNULL(FST.S_PostExtAmt, 0) AS S_PostExtAmt
,	ISNULL(FST.S_PRPCnt,0) AS S_PRPCnt
,	ISNULL(FST.S_PRPAmt,0) AS S_PRPAmt
,       ISNULL(FST.NB_AppsCnt, 0) AS NB_AppsCnt
,       ISNULL(FST.NB_BIOConvCnt, 0) AS NB_BIOConvCnt
,       ISNULL(FST.NB_MDPCnt,0) AS NB_MDPCnt
,       ISNULL(FST.NB_MDPAmt,0) AS NB_MDPAmt
,       ( ISNULL(FST.NB_TradCnt, 0) + ISNULL(FST.NB_GradCnt, 0) + ISNULL(FST.NB_ExtCnt, 0) + ISNULL(FST.NB_XtrCnt, 0) + ISNULL(FST.S_PostExtCnt, 0)+ ISNULL(FST.NB_MDPCnt, 0) + ISNULL(FST.S_SurCnt,0) + ISNULL(FST.S_PRPCnt,0)) AS NB_NetNBCnt
,       ( ISNULL(FST.NB_TradAmt, 0) + ISNULL(FST.NB_GradAmt, 0) + ISNULL(FST.NB_ExtAmt, 0) + ISNULL(FST.NB_XtrAmt, 0) + ISNULL(FST.S_PostExtAmt, 0) +  ISNULL(FST.NB_MDPAmt, 0) +  ISNULL(FST.NB_LASERAmt, 0) + ISNULL(FST.S_SurAmt,0) + ISNULL(FST.S_PRPAmt,0))  AS NB_NetNBAmt
FROM  cte FST
    INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
        ON FST.OrderDateKey = dd.DateKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
        ON fst.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
		ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON SO.ClientMembershipKey = DCM.ClientMembershipKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
        ON dcm.MembershipKey = m.MembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C  --Keep HomeCenter-based
        ON clt.CenterSSID = c.CenterSSID
    INNER JOIN #Centers CTRS
        ON C.CenterNumber = CTRS.CenterNumber
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON FST.Employee1Key = E.EmployeeKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
		ON FST.Employee2Key = E2.EmployeeKey
	LEFT JOIN HC_BI_Reporting.dbo.DimCancelReason cr
		ON cr.CancelReasonID = sod.CancelReasonID
WHERE   DD.FullDate BETWEEN @BegDt AND @EndDt
	AND ( SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
			OR SC.SalesCodeDescriptionShort = 'ADDBIOSYS' )
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
		OR ISNULL(FST.S_PRPCnt,0) <> 0
		OR ISNULL(FST.S_PRPAmt,0) <> 0
		OR ISNULL(FST.S_SurCnt, 0) <> 0
		OR ISNULL(FST.S_SurAmt, 0) <> 0
		OR ISNULL(FST.NB_AppsCnt, 0) <> 0
		OR ISNULL(FST.NB_BIOConvCnt, 0) <> 0
		OR ISNULL(FST.NB_LaserCnt, 0) <> 0
		OR ISNULL(FST.NB_LaserAmt, 0) <> 0
		OR ISNULL(FST.NB_MDPCnt, 0) <> 0
		OR ISNULL(FST.NB_MDPAmt, 0) <> 0)
		AND FST.RowNum = '1'
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
,         ISNULL(FST.S_SurAmt, 0)
,         ISNULL(FST.S_PostExtCnt, 0)
,         ISNULL(FST.S_PostExtAmt, 0)
,		ISNULL(FST.S_PRPCnt,0)
,		ISNULL(FST.S_PRPAmt,0)
,         ISNULL(FST.NB_AppsCnt, 0)
,         ISNULL(FST.NB_BIOConvCnt, 0)
,         ISNULL(FST.NB_MDPCnt,0)
,         ISNULL(FST.NB_MDPAmt,0)
,         ISNULL(FST.NB_LaserAmt,0)
,         ISNULL(FST.NB_LaserCnt,0)
,         (ISNULL(FST.NB_TradCnt, 0) + ISNULL(FST.NB_GradCnt, 0) + ISNULL(FST.NB_ExtCnt, 0) + ISNULL(FST.NB_XtrCnt, 0) + ISNULL(FST.S_PostExtCnt, 0) + ISNULL(FST.NB_MDPCnt, 0) + ISNULL(FST.S_SurCnt,0) + ISNULL(FST.S_PRPCnt,0))
,         ( ISNULL(FST.NB_TradAmt, 0) + ISNULL(FST.NB_GradAmt, 0) + ISNULL(FST.NB_ExtAmt, 0) + ISNULL(FST.NB_XtrAmt, 0) + ISNULL(FST.S_PostExtAmt, 0) +  ISNULL(FST.NB_MDPAmt, 0) +  ISNULL(FST.NB_LASERAmt, 0) + ISNULL(FST.S_SurAmt,0)  + ISNULL(FST.S_PRPAmt,0))
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
,	PC.PromotionCodeKey
,	PC.PromotionCodeSSID
INTO #Promo
FROM #Output O
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON CLT.ClientIdentifier = O.ClientIdentifier
INNER JOIN HC_BI_SFDC.dbo.Lead L  WITH (NOLOCK) --> Added 07/15
	ON CLT.SFDC_Leadid = L.Id
LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS WITH (NOLOCK) --> Added 07/15
    ON DS.SourceSSID = L.RecentSourceCode__c
LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode PC WITH (NOLOCK)
    ON PC.PromotionCodeSSID = DS.PromoCode
--WHERE FAR.Consultation = 1 --> Pending for review due to all new leads come with 00Q5
GROUP BY O.ClientIdentifier,
         CLT.contactkey,
         PC.PromotionCodeKey,
         PC.PromotionCodeSSID


/************** Code removed from code has been added ***************
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
	ON CLT.contactkey = FAR.ContactKey
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
	ON FL.ContactKey = FAR.ContactKey
********************************************************************/

	IF @Type=1 --Total NB1 Gross #
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	NB_GrossNB1Cnt as qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,  	  MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE NB_GrossNB1Cnt<>0
		END
	ELSE IF @Type=2 --Traditional # + Grad #
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE (NB_TradCnt <> 0 OR NB_GradCnt <> 0)
		END
	ELSE IF @Type=3 --Traditional $ + Gradual $
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE (NB_TradAmt <> 0 OR NB_GradAmt <> 0)
		END

	ELSE IF @Type=6 --Extreme # + PostEXT #
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 (NB_ExtCnt + S_PostExtCnt) AS qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE (NB_ExtCnt <> 0 OR S_PostExtCnt <> 0)
			ORDER BY MainGroupSortOrder, CenterDescriptionNumber
		END
	ELSE IF @Type=7 --Extreme $ + PostEXT $
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE (NB_ExtAmt <> 0 OR S_PostExtAmt <> 0)
		END
	ELSE IF @Type=8 --Surgery Count
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
				,	CASE WHEN SalesCodeDescriptionShort LIKE 'MEDADDON%' THEN ISNULL(S_PRPCnt,0) ELSE ISNULL(S_SurCnt,0) END AS  qty
				,	NULL AS grafts
				,	CASE WHEN SalesCodeDescriptionShort LIKE 'MEDADDON%' THEN ISNULL(S_PRPAmt,0) ELSE ISNULL(S_SurAmt,0) END ExtendedPrice
				,	Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
				,	 MembershipDescription  AS GroupBy
				,	'' AS LaserTherapy
				,	P.PromotionCodeSSID
				,	ROW_NUMBER()OVER(PARTITION BY O.ClientIdentifier ORDER BY O.FullDate DESC) AS Ranking
				FROM #Output O
				LEFT JOIN #Promo P
					ON P.ClientIdentifier = O.ClientIdentifier
				WHERE (ISNULL(S_PRPCnt,0) <> 0 OR ISNULL(S_SurCnt,0) <>0)
		END
	ELSE IF @Type=9 --Surgery Amount
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
				,	CASE WHEN SalesCodeDescriptionShort LIKE 'MEDADDON%' THEN ISNULL(S_PRPCnt,0) ELSE ISNULL(S_SurCnt,0) END AS  qty
				,	NULL AS grafts
				,	CASE WHEN SalesCodeDescriptionShort LIKE 'MEDADDON%' THEN ISNULL(S_PRPAmt,0) ELSE ISNULL(S_SurAmt,0) END ExtendedPrice
				,	Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
				,	 MembershipDescription  AS GroupBy
				,	'' AS LaserTherapy
				,	P.PromotionCodeSSID
				FROM #Output O
				LEFT JOIN #Promo P
					ON P.ClientIdentifier = O.ClientIdentifier
				WHERE (ISNULL(S_PRPAmt,0) <> 0 OR ISNULL(S_SurAmt,0) <>0)

		END

			ELSE IF @Type=41 --PRP Count
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
				,	ISNULL(S_PRPCnt,0) AS  qty
				,	NULL AS grafts
				,	ISNULL(S_PRPAmt,0) ExtendedPrice
				,	Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
				,	 MembershipDescription  AS GroupBy
				,	'' AS LaserTherapy
				,	P.PromotionCodeSSID

				FROM #Output O
				LEFT JOIN #Promo P
					ON P.ClientIdentifier = O.ClientIdentifier
				WHERE ISNULL(S_PRPCnt,0) <>0
		END

	ELSE IF @Type=42 --PRP Amount
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
				,	ISNULL(S_PRPCnt,0) AS  qty
				,	NULL AS grafts
				,	ISNULL(S_PRPAmt,0) AS ExtendedPrice
				,	Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
				,	 MembershipDescription  AS GroupBy
				,	'' AS LaserTherapy
				,	P.PromotionCodeSSID
				FROM #Output O
				LEFT JOIN #Promo P
					ON P.ClientIdentifier = O.ClientIdentifier
				WHERE  ISNULL(S_PRPAmt,0) <> 0

		END

	ELSE IF @Type=10 --Applications
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE NB_AppsCnt<>0
		END

	ELSE IF @Type=11 --Conversions (Excludes EXT + XTR Conversions)
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE NB_BIOConvCnt<>0
		END


	ELSE IF @Type=32 --Xtrands #
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE NB_XtrCnt<>0
		END
	ELSE IF @Type=33 --Xtrands $
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,SalesCodeDescriptionShort,SalesCodeDescription
			,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE NB_XtrAmt<>0
		END
	ELSE IF @Type=34 --LaserCnt #
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,O.SalesCodeDescriptionShort,O.SalesCodeDescription
			,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	ISNULL(q_LSR.SalesCodeDescription, '') AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
				OUTER APPLY (
								  -- Get Laser Membership NB Counts
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
                                 WHERE     DSO.IsVoidedFlag = 0
									AND (DSC.SalesCodeDescription LIKE '%EXT%Laser%Payment'
										OR														--For Capillus
										DSC.SalesCodeDescriptionShort LIKE 'EXTPMTCAP%')
										AND DSC.SalesCodeDepartmentSSID = 2020
										AND DCM.ClientMembershipKey = O.ClientMembershipKey
								  ORDER BY DD.FullDate DESC
                                ) q_LSR
				LEFT JOIN #Promo P
					ON P.ClientIdentifier = O.ClientIdentifier
			WHERE  (O.SalesCodeDescription LIKE '%EXT%Laser%Payment' OR	O.SalesCodeDescriptionShort LIKE 'EXTPMTCAP%')
					AND O.SalesCodeDepartmentSSID = 2020
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
                     O.ExtendedPrice,
                     O.Tax1,
                     O.Tax2,
                     O.Consultant,
                     O.CancelReasonDescription,
                     O.SalesCodeDepartmentSSID,
                     O.Stylist,
                     O.Voided,
                     O.MembershipDescription,
                     O.MembershipDescription,
					 P.PromotionCodeSSID
		END
	ELSE IF @Type=35 --LaserAmt $
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber,FullDate,O.SalesCodeDescriptionShort,O.SalesCodeDescription
			,	 qty,NULL AS grafts,ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	ISNULL(p_LSR.SalesCodeDescription, '') AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
				OUTER APPLY (
								  -- Get Laser Membership Revenue
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
                                  WHERE     DSO.IsVoidedFlag = 0
									AND (DSC.SalesCodeDescription LIKE '%EXT%Laser%Payment'
										OR														--For Capillus
										DSC.SalesCodeDescriptionShort LIKE 'EXTPMTCAP%')
										AND DSC.SalesCodeDepartmentSSID = 2020
										AND DCM.ClientMembershipKey = O.ClientMembershipKey
								  ORDER BY DD.FullDate DESC
                                ) p_LSR
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE (O.SalesCodeDescription LIKE '%EXT%Laser%Payment' OR	O.SalesCodeDescriptionShort LIKE 'EXTPMTCAP%')
					AND O.SalesCodeDepartmentSSID = 2020
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
                     O.ExtendedPrice,
                     O.Tax1,
                     O.Tax2,
                     O.Consultant,
                     O.CancelReasonDescription,
                     O.SalesCodeDepartmentSSID,
                     O.Stylist,
                     O.Voided,
                     O.MembershipDescription,
                     O.MembershipDescription,
					 P.PromotionCodeSSID
		END

	ELSE IF @Type=17 --Total NB1 Net #
		BEGIN

            SELECT DISTINCT
				O.CenterNumber
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
			,	ISNULL(NB_NetNBCnt,0) AS qty
			,	O.NB_NetNBAmt AS ExtendedPrice
			,	O.Tax1
			,	O.Tax2
			,	O.Consultant
			,	O.CancelReasonDescription
			,	O.SalesCodeDepartmentSSID
			,	O.Stylist
			,	O.Voided
			,	O.MembershipDescription
			,	O.MembershipDescription AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
            FROM    #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
            WHERE   ISNULL(NB_NetNBCnt,0) <> 0
		END
	ELSE IF @Type=18 --Total NB1 Net $
		BEGIN
			SELECT CenterNumber,CenterDescriptionNumber,MainGroupKey,MainGroupDescription,MainGroupSortOrder,O.ClientIdentifier,ClientLastName,ClientFirstName,SalesOrderDetailKey,InvoiceNumber
			,	FullDate
			,	SalesCodeDescriptionShort
			,	SalesCodeDescription
			,	 ISNULL(NB_NetNBCnt,0) AS qty
			,	O.NB_NetNBAmt AS ExtendedPrice,Tax1,Tax2,Consultant,CancelReasonDescription,SalesCodeDepartmentSSID,Stylist,Voided,MembershipDescription
			,	 MembershipDescription  AS GroupBy
			,	'' AS LaserTherapy
			,	P.PromotionCodeSSID
			FROM #Output O
			LEFT JOIN #Promo P
				ON P.ClientIdentifier = O.ClientIdentifier
			WHERE NB_NetNBAmt<>0

		END



END
GO
