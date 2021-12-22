/***********************************************************************
PROCEDURE:				[spRpt_ContestCarnivalOfConversionsDetails]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Cloned spRpt_ContestNewHairResolution
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		04/26/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [dbo].[spRpt_ContestCarnivalOfConversionsDetails] 201

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestCarnivalOfConversionsDetails]
(@CenterNumber INT)

AS
BEGIN

DECLARE @ContestSSID INT
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'CarnivalOfConversions')
--SET @StartDate = '5/01/2018'
--SET @EndDate = '6/30/2018'

----For testing
SET @StartDate = '3/01/2018'
SET @EndDate = '3/30/2018'






SET FMTONLY OFF;
SET NOCOUNT OFF;

/********************************** Create Temp Table Objects *************************************/


CREATE TABLE #NationalRates(
	CenterID INT
,	MembershipID INT
,	MembershipDescription NVARCHAR(50)
,	MaleNationalRate DECIMAL(18,4)
,	FemaleNationalRate DECIMAL(18,4)
,	GenderID INT
)


/********************************** Get Conversions *************************************/

 SELECT C.CenterNumber
,		DD.FullDate
,		CLT.ClientIdentifier
,	CLT.ClientKey
,       CLT.ClientFullName
,		CLT.GenderSSID
,       ISNULL(FST.NB_BIOConvCnt,0) AS 'NB_BIOConvCnt'
,       ISNULL(FST.NB_XTRConvCnt,0) AS 'NB_XTRConvCnt'
,       ISNULL(FST.NB_EXTConvCnt,0) AS 'NB_EXTConvCnt'
,		CM.ClientMembershipSSID
,		CM.MembershipSSID
,		M.MembershipDescription AS 'CurrentMembership'
,		SOD.PreviousClientMembershipSSID
,		PREVM.MembershipDescription AS 'PreviousMembership'
,       E.EmployeeInitials AS 'Employee1Initials'
,       E2.EmployeeInitials AS 'Employee2Initials'
,       E.EmployeeFullName AS 'Employee1FullName'
,       E2.EmployeeFullName AS 'Employee2FullName'
,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY DD.FullDate DESC) AS 'Ranking'
INTO #Conv
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee1Key = E.EmployeeKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
			ON FST.Employee2Key = E2.EmployeeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
            ON (CASE WHEN ISNULL(FST.NB_BIOConvCnt,0) = 1 THEN CLT.CurrentBioMatrixClientMembershipSSID
			 WHEN ISNULL(FST.NB_EXTConvCnt,0) = 1 THEN CLT.CurrentExtremeTherapyClientMembershipSSID
			 WHEN ISNULL(FST.NB_XTRConvCnt,0) = 1 THEN CurrentXtrandsClientMembershipSSID
			ELSE COALESCE(CLT.CurrentBioMatrixClientMembershipSSID,CLT.CurrentXtrandsClientMembershipSSID,CLT.CurrentExtremeTherapyClientMembershipSSID,CLT.CurrentSurgeryClientMembershipSSID)END) = CM.ClientMembershipSSID  --Current membership from Client
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
            ON CM.MembershipSSID = M.MembershipSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON CM.CenterKey = C.CenterKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
            ON C.CenterTypeKey = CT.CenterTypeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
            ON C.RegionKey = R.RegionKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
            ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PREVCM
			ON SOD.PreviousClientMembershipSSID = PREVCM.ClientMembershipSSID
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PREVM
			ON PREVCM.MembershipSSID = PREVM.MembershipSSID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND C.CenterNumber = @CenterNumber
	    AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
					/*	'Removal - New Member'
						,	'NEW MEMBER TRANSFER'
						,	'Transfer Member Out'
						,	'Update Membership'	*/
        AND SOD.IsVoidedFlag = 0
		AND(ISNULL(FST.NB_BIOConvCnt,0) <> 0
				OR ISNULL(FST.NB_XTRConvCnt,0) <> 0
				OR ISNULL(FST.NB_EXTConvCnt,0) <> 0
				)

/********************  Find center and client information ***************************/
SELECT CenterNumber
     , FullDate
     , ClientIdentifier
	 ,	ClientKey
     , ClientFullName
     , GenderSSID
     , NB_BIOConvCnt
     , NB_XTRConvCnt
     , NB_EXTConvCnt
     , ClientMembershipSSID
     , MembershipSSID
     , CurrentMembership
     , PreviousClientMembershipSSID
     , PreviousMembership
     , Employee1Initials
     , Employee2Initials
     , Employee1FullName
     , Employee2FullName
INTO #Conversions
FROM #Conv
WHERE Ranking = 1
GROUP BY CenterNumber
     , FullDate
     , ClientIdentifier
	 , ClientKey
     , ClientFullName
     , GenderSSID
     , NB_BIOConvCnt
     , NB_XTRConvCnt
     , NB_EXTConvCnt
     , ClientMembershipSSID
     , MembershipSSID
     , CurrentMembership
     , PreviousClientMembershipSSID
     , PreviousMembership
     , Employee1Initials
     , Employee2Initials
     , Employee1FullName
     , Employee2FullName



/******* Find National Rates per gender *******************************************************/
INSERT INTO #NationalRates
SELECT CFG.CenterID   ---CenterID for ColoradoSprings is 1002
	,	CFG.MembershipID
	,	M.MembershipDescription
	,	ISNULL(CFG.ContractPriceMale/M.DurationMonths,'0.00') AS 'MaleNationalRate'
	,	ISNULL(CFG.ContractPriceFemale/M.DurationMonths,'0.00') AS 'FemaleNationalRate'
	,	ISNULL(M.GenderID,0) AS 'GenderID'
	FROM SQL05.HairClubCMS.dbo.cfgCenterMembership CFG
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON CTR.CenterNumber = CFG.CenterID
	INNER JOIN #Conversions
		ON #Conversions.CenterNumber = CTR.CenterNumber
	INNER JOIN SQL05.HairClubCMS.dbo.cfgMembership M
		ON M.MembershipID = CFG.MembershipID
	WHERE M.MembershipDescription NOT IN('Hair Club For Kids')
		AND M.MembershipDescription NOT LIKE 'Model%'
		AND M.MembershipDescription NOT LIKE 'Employee%'
	GROUP BY CFG.ContractPriceMale / M.DurationMonths
		   ,	ContractPriceFemale / M.DurationMonths
		   ,	CFG.CenterID
		   ,	CFG.MembershipID
		   ,	M.MembershipDescription
		   ,	ISNULL(M.GenderID,0)



/***************** Find National Rate per client and client membership ******************************************/


SELECT CONV.ClientIdentifier

,		CASE WHEN CONV.GenderSSID = 1 THEN ROUND(NR.MaleNationalRate,2)
			WHEN CONV.GenderSSID = 2 THEN ROUND(NR.FemaleNationalRate,2)
			ELSE ROUND(NR.FemaleNationalRate,2)
		END AS 'NationalRate'
INTO #CltRate
FROM #Conversions CONV
LEFT JOIN #NationalRates NR
	ON CONV.CenterNumber = NR.CenterID
WHERE CONV.MembershipSSID = NR.MembershipID
		AND CONV.GenderSSID = NR.GenderID



/************* Get FirstPayment AFTER Conversion and Second Payment AFTER Conversion **************/


SELECT  DC.CenterNumber
,		FST.ClientKey
,		CONV.ClientIdentifier
,		FST.ClientMembershipKey
,		DSC.SalesCodeDepartmentSSID
,	CONV.FullDate AS 'ConvDate'
,		DD.FullDate
,		DD.MonthNumber
,		FST.ExtendedPrice
,		ROW_NUMBER()OVER(PARTITION BY FST.ClientKey ORDER BY DD.FullDate DESC) AS 'Ranking'

INTO #Payments
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Conversions CONV
			ON FST.ClientKey = CONV.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON FST.ClientMembershipKey = DCM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DCM.MembershipSSID = DM.MembershipSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON DCM.CenterKey = DC.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
            ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
WHERE   DD.FullDate >= @StartDate
		AND DSC.SalesCodeDepartmentSSID IN ( 2020 )
		AND DD.FullDate >= CONV.FullDate  --Find payments that are past the conversion date
		AND FST.ExtendedPrice <> '0.00'


/********** Final Select *******************************************************************/

SELECT CenterNumber
     ,ClientIdentifier
     , ClientKey
     , ClientFullName
     , GenderSSID
     , NB_BIOConvCnt
     , NB_XTRConvCnt
     , NB_EXTConvCnt
     , ClientMembershipSSID
     , MembershipSSID
     , CurrentMembership
     , PreviousClientMembershipSSID
     , PreviousMembership
     , Employee1Initials
     , Employee1FullName
     , NationalRate
     , ConvDate
	 ,	SUM(ISNULL(LastPayment,'0.00')) AS 'LastPayment'
	 ,	SUM(ISNULL(PreviousPayment,'0.00')) AS 'PreviousPayment'

FROM

(SELECT #Conversions.CenterNumber
     , #Conversions.ClientIdentifier
     , #Conversions.ClientKey
     , ClientFullName
     , GenderSSID
     , NB_BIOConvCnt
     , NB_XTRConvCnt
     , NB_EXTConvCnt
     , ClientMembershipSSID
     , MembershipSSID
     , CurrentMembership
     , PreviousClientMembershipSSID
     , PreviousMembership
     , Employee1Initials
     , Employee2Initials
     , Employee1FullName
     , Employee2FullName
     , NationalRate
     , ConvDate
     , CASE WHEN Ranking = 1 THEN ExtendedPrice END AS 'LastPayment'
	 ,	CASE WHEN Ranking = 2 THEN ExtendedPrice END AS 'PreviousPayment'

FROM #Conversions
LEFT JOIN #CltRate
	ON #CltRate.ClientIdentifier = #Conversions.ClientIdentifier
INNER JOIN #Payments
	ON #Payments.ClientIdentifier = #Conversions.ClientIdentifier
	)q
GROUP BY q.CenterNumber
       , q.ClientIdentifier
       , q.ClientKey
       , q.ClientFullName
       , q.GenderSSID
       , q.NB_BIOConvCnt
       , q.NB_XTRConvCnt
       , q.NB_EXTConvCnt
       , q.ClientMembershipSSID
       , q.MembershipSSID
       , q.CurrentMembership
       , q.PreviousClientMembershipSSID
       , q.PreviousMembership
       , q.Employee1Initials
       , q.Employee1FullName
       , q.NationalRate
       , q.ConvDate


END
