/* CreateDate: 10/16/2013 14:53:59.740 , ModifyDate: 03/19/2020 10:22:26.100 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_NB1SalesRefunds

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			HDu

DATE IMPLEMENTED:		8/17/2012

==============================================================================
DESCRIPTION:	New Business Sales Refunds
==============================================================================
NOTES:
10/17/2013 - RH - Rewrote the stored procedure with Marlon and Dominic
10/14/2016 - RH - Added ClientMembershipStatusDescription (#131245)
01/12/2017 - RH - Added CenterManagementAreaID and CenterManagementAreaDescription (#133833)
03/14/2018 - RH - (#145957) Changed CenterSSID to CenterNumber
03/16/2020 - RH - (TrackIT 7697) Added S_PRPAmt; Removed refunds for Capillus devices
==============================================================================
SAMPLE EXECUTION:

EXEC spRpt_NB1SalesRefunds 'C', '2/1/2020','2/29/2020', '450'

EXEC spRpt_NB1SalesRefunds 'F', '2/1/2020','2/29/2020', '450'
==============================================================================
*/

CREATE PROCEDURE [dbo].[spRpt_NB1SalesRefunds](
	@sType CHAR(1)
,	@StartDate SMALLDATETIME
,	@EndDate SMALLDATETIME
,	@Minimum MONEY = NULL
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

/********************************** Create temp table objects *************************************/

	CREATE TABLE #Centers (
		MainGroupSSID INT
	,	MainGroupDescription VARCHAR(50)
	,	MainGroupSortOrder INT
	,	CenterNumber INT
	,	CenterDescription VARCHAR(255)
	,	CenterType VARCHAR(50)
	)

	CREATE TABLE #Refunds(
		CenterKey INT
	,	ClientKey INT
	,	ClientMembershipKey INT
	,	ClientMembershipStatusDescription NVARCHAR(50)
	,	SoldMembershipKey INT
	,	TotalRefunds MONEY
	,	CurrentMembershipKey INT)

	CREATE TABLE #Temp(
		CenterKey INT
	,	ClientKey INT
	,	MaxServiceApptDate DATETIME
	,	MaxRemovalDate DATETIME
	,	MaxConversionDate DATETIME
	,	TotalPayments MONEY)


/********************************** Get list of centers *************************************/

IF @sType = 'C'
	BEGIN
		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupSSID'
				,		CMA.CenterManagementAreaDescription AS 'MainGroupDescription'
				,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
				,		DC.CenterNumber
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
				WHERE   DCT.CenterTypeDescriptionShort = 'C'
						AND DC.Active = 'Y'
	END

IF @sType = 'F'
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS 'MainGroupSSID'
				,		DR.RegionDescription AS 'MainGroupDescription'
				,		DR.RegionSortOrder AS 'MainGroupSortOrder'
				,		DC.CenterNumber
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE   DCT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
	END



/********************************** Find the Keys and TotalRefunds *******************************/

	INSERT INTO #Refunds(
		CenterKey
	,	ClientKey
	,	ClientMembershipKey
	,	ClientMembershipStatusDescription
	,	SoldMembershipKey
	,	TotalRefunds
	,	CurrentMembershipKey)
	SELECT CTR.CenterKey
	,	clt.ClientKey
	,	cm.ClientMembershipKey
	,	cm.ClientMembershipStatusDescription
	,	m.MembershipKey AS 'SoldMembershipKey'
	,	SUM(CASE WHEN fst.S_SurAmt < 0 THEN fst.S_SurAmt
					WHEN  fst.S_PRPAmt < 0 THEN fst.S_PRPAmt
					ELSE fst.ExtendedPrice END ) AS 'TotalRefunds'
	,	MAX([dbo].[GetCurrentMembershipKey](clt.ClientKey)) AS 'CurrentMembershipKey'
	FROM  HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			   ON fst.OrderDateKey = d.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON FST.CenterKey = CTR.CenterKey
		INNER JOIN #Centers
			ON #Centers.CenterNumber = CTR.CenterNumber
		INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			   ON fst.ClientKey = clt.ClientKey
		INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			   ON fst.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			   ON cm.MembershipKey = m.MembershipKey
		INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			   ON fst.SalesCodeKey = sc.SalesCodeKey
	WHERE d.FullDate BETWEEN @StartDate and @EndDate
		AND (fst.ExtendedPrice < 0 OR fst.S_SurAmt < 0 OR fst.S_PRPAmt < 0)
		AND m.RevenueGroupSSID = 1
		AND sc.SalesCodeDescription NOT LIKE 'Capillus%'
	GROUP BY CTR.CenterKey
	,	clt.ClientKey
	,	cm.ClientMembershipKey
	,	cm.ClientMembershipStatusDescription
	,	m.MembershipKey


/************************* Find the Dates and Total Payments *************************************/

	INSERT INTO #Temp(
		CenterKey
	,	ClientKey
	,	MaxServiceApptDate
	,	MaxRemovalDate
	,	MaxConversionDate
	,	TotalPayments)
	SELECT  ref.CenterKey
	,	ref.ClientKey
	,	MAX(CASE WHEN sc.SalesCodeSSID IN (647, 648,  407, 711, 672, 393) THEN d.FullDate ELSE NULL END) AS 'MaxServiceApptDate'
	,	MAX(CASE WHEN SC.SalesCodeSSID IN ( 399 ) THEN d.FullDate ELSE NULL END) AS 'MaxRemovalDate'
	,	MAX(CASE WHEN FST.NB_BIOConvCnt > 0 OR FST.NB_EXTConvCnt > 0 THEN d.FullDate ELSE NULL END) AS 'MaxConversionDate'
	,	( SUM(CASE WHEN FST.NB_TradAmt > 0 THEN FST.NB_TradAmt ELSE 0 END)
		+ SUM(CASE WHEN FST.NB_GradAmt > 0 THEN FST.NB_GradAmt ELSE 0 END)
		+ SUM(CASE WHEN FST.NB_ExtAmt > 0 THEN FST.NB_ExtAmt ELSE 0 END)
		+ SUM(CASE WHEN FST.S_SurAmt > 0 THEN FST.S_SurAmt ELSE 0 END)
		+ SUM(CASE WHEN FST.S_PRPAmt > 0 THEN FST.S_PRPAmt ELSE 0 END)
		+ SUM(CASE WHEN FST.S_PostExtAmt > 0 THEN FST.S_PostExtAmt ELSE 0 END) ) AS 'TotalPayments'

	FROM #Refunds ref
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
			ON ref.ClientMembershipKey = fst.ClientMembershipKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON fst.OrderDateKey = d.DateKey
		INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
			ON fst.SalesCodeKey = sc.SalesCodeKey
	GROUP BY ref.CenterKey
	,	ref.ClientKey


/************************** Final select statement for the result set *******************************/

	SELECT #Centers.MainGroupSSID
	,	#Centers.MainGroupDescription
	,	#Centers.MainGroupSortOrder
	,	ctr.CenterDescriptionNumber AS 'Center'
	,	clt.ClientFullName + ' - ' +  CAST(clt.ClientIdentifier AS VARCHAR(12)) AS 'Client_No'
	,	m.MembershipDescription AS 'MembershipSold'
	,	mCurrent.MembershipDescription AS 'CurrentMembership'
	,	cm.ClientMembershipStatusDescription
	,	cm.ClientMembershipBeginDate AS 'SaleDate'
	,	#Temp.MaxServiceApptDate AS 'SVCorAPPDate'
	,	#Temp.MaxConversionDate AS 'ConvDate'
	,	#Temp.MaxRemovalDate AS 'RemovalDate'
	,	cm.ClientMembershipContractPrice AS 'ContractPrice'
	,	ISNULL(#temp.TotalPayments, 0) AS 'PaymentsRecvd'
	,	#Refunds.TotalRefunds AS 'RefundsPaid'
	,	( #Refunds.TotalRefunds + ISNULL(#temp.TotalPayments, 0) ) AS 'TotalPaid'

	FROM #Refunds
		LEFT OUTER JOIN #Temp
			ON #Refunds.ClientKey = #Temp.ClientKey
		INNER JOIN  HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON #Refunds.CenterKey = ctr.CenterKey
		INNER JOIN #Centers
            ON ctr.CenterNumber = #Centers.CenterNumber
		INNER JOIN  HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON #Refunds.ClientKey = clt.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON #Refunds.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipKey = m.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership mCurrent
			ON #Refunds.CurrentMembershipKey = mCurrent.MembershipKey
	WHERE ( #Refunds.TotalRefunds + ISNULL(#Temp.TotalPayments, 0) ) <= @minimum
		AND mCurrent.MembershipSSID <> 11 --remove any cancellations -- where MembershipDescription = 'Cancel'




END
GO
