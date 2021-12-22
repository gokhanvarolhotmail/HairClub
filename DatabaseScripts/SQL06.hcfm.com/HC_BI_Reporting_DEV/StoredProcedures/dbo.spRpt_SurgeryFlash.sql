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
NOTES:
--
06/01/2011 - KM - Initial Rewrite to SQL06
07/13/2011 - KM - Added in changes to Deferred Revenue per AG
07/19/2011 - MB - Added code to treat JV centers as Franchise centers (WO# 64829)
08/25/2011 - KM - Added logic to Net sales to handle cancels (WO# 66154)
12/19/2011 - MB - Filtered out BeBacks from Consultations (WO# 70091)
01/19/2012 - KM - WO# 71306 - Added Active Flag to select
08/17/2012 - MB - Rewrite to point to BI environment on SQL06 (DR/DP Request)
08/28/2012 - MB - Changed report to use client center instead of transaction center (WO# 78889)
08/28/2012 - MB - Changed report to filter out BeBacks from the Surgery Consultation counts (WO# 78961)
09/05/2012 - HD - Correct the Percent_Surgery calculation, it was backwards
09/07/2012 - MB - Removed Outstanding Procedures section
09/11/2012 - HD - Corrected the surgery offered count to exclude bebacks
02/20/2014 - DL - Joined on DimSalesOrder instead of on FactSalesTransactions for the ClientMembershipKey
==============================================================================
SAMPLE EXECUTION:
EXEC [sprpt_SurgeryFlash] '11/18/2013', '11/29/2013'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_SurgeryFlash]
	@StartDate	DATETIME
,	@EndDate	DATETIME
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @OutstandingStartDate DATETIME

SET @EndDate = @EndDate + ' 23:59'
SET @OutstandingStartDate = DATEADD(M, -12, @EndDate)


CREATE TABLE #Centers (
	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	RegionID INT
,	Region VARCHAR(50)
,	CenterTypeLongDescription VARCHAR(50)
,	CenterTypeShortDescription VARCHAR(1)
,	ReportingCenterSSID INT
)


INSERT  INTO #Centers
        SELECT  DC.CenterSSID
        ,       DC.CenterDescription
        ,       DDR.DoctorRegionSSID
        ,       DDR.DoctorRegionDescriptionShort
        ,       CASE WHEN DCT.CenterTypeDescription = 'Joint' THEN 'Franchise'
                     ELSE DCT.CenterTypeDescription
                END
        ,       CASE WHEN DCT.CenterTypeDescriptionShort = 'JV' THEN 'F'
                     ELSE DCT.CenterTypeDescriptionShort
                END
        ,       DC.ReportingCenterSSID
        FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimDoctorRegion DDR
                    ON DC.DoctorRegionKey = DDR.DoctorRegionKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                    ON DC.CenterTypeKey = DCT.CenterTypeKey
        WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[356]%'
                AND DC.Active = 'Y'


SELECT DC.ReportingCenterSSID
,		SUM(ISNULL(FAR.Consultation, 0)) AS 'conultations'
,		SUM(CASE WHEN FAR.BeBack = 1 THEN 0 ELSE ISNULL(FAR.SurgeryOffered, 0) END) AS 'SurgeryOffered'
INTO	#Consultations
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FAR.ActivityDueDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FAR.CenterKey = DC.CenterKey
		INNER JOIN #Centers C
			ON DC.ReportingCenterSSID = C.ReportingCenterSSID
WHERE	DD.FullDate BETWEEN @StartDate AND @EndDate
GROUP BY DC.ReportingCenterSSID
ORDER BY DC.ReportingCenterSSID


SELECT	DC.ReportingCenterSSID
,		ISNULL(SUM(FST.S1_NetSalesCnt), 0) AS 'First_Surgery_Net_Sales'
,		ISNULL(SUM(FST.S1_NetSalesAmt), 0) AS 'First_Surgery_Net$'
,		dbo.DIVIDE(ISNULL(SUM(FST.S1_NetSalesAmt), 0), ISNULL(SUM(FST.S1_NetSalesCnt), 0)) AS 'First_Surg_Rev_Per_Sales'
,		ISNULL(SUM(FST.S1_ContractAmountAmt), 0) AS 'First_Surgery_Contract_Amount'
,		ISNULL(SUM(FST.S1_EstGraftsCnt), 0) AS 'First_Surgery_Est_Grafts'
,		dbo.DIVIDE(ISNULL(SUM(FST.S1_ContractAmountAmt), 0), ISNULL(SUM(FST.S1_EstGraftsCnt), 0)) AS 'First_Surgery_Est_Per_Grafts'

,		ISNULL(SUM(FST.SA_NetSalesCnt), 0) AS 'Addtl_Surgery_Net_Sales'
,		ISNULL(SUM(FST.SA_NetSalesAmt), 0) AS 'Addtl_Surgery_Net$'
,		dbo.DIVIDE(ISNULL(SUM(FST.SA_NetSalesAmt), 0), ISNULL(SUM(FST.SA_NetSalesCnt), 0)) AS 'Addtl_Surg_Rev_Per_Sales'
,		ISNULL(SUM(FST.SA_ContractAmountAmt), 0) AS 'Addtl_Surgery_Contract_Amount'
,		ISNULL(SUM(FST.SA_EstGraftsCnt), 0) AS 'Addtl_Surgery_Est_Grafts'
,		dbo.DIVIDE(ISNULL(SUM(FST.SA_ContractAmountAmt), 0), ISNULL(SUM(FST.SA_EstGraftsCnt), 0)) AS 'Addtl_Surgery_Est_Per_Grafts'

,		ISNULL(SUM(FST.S_SurgeryPerformedCnt), 0) AS 'Total_Surgery_Performed'
,		ISNULL(SUM(FST.S_SurgeryPerformedAmt), 0) AS 'Total_Net$'
,		dbo.DIVIDE(ISNULL(SUM(FST.S_SurgeryPerformedAmt), 0), ISNULL(SUM(FST.S_SurgeryPerformedCnt), 0)) AS 'Total_Revenue_Per_Sales'
,		ISNULL(SUM(FST.S_SurgeryGraftsCnt), 0) AS 'Total_Grafts'
,		dbo.DIVIDE(ISNULL(SUM(FST.S_SurgeryPerformedAmt), 0), ISNULL(SUM(FST.S_SurgeryGraftsCnt), 0)) AS 'Total_Est_per_Grafts'

,		ISNULL(SUM(FST.S_PostExtCnt), 0) AS 'Total_POSTEXTPMT_Count'
,		ISNULL(SUM(FST.S_PostExtAmt), 0) AS 'Total_POSTEXTPMT'
,		ISNULL(SUM(FST.S1_DepositsTakenCnt), 0) AS 'DepositCount'
,		ISNULL(SUM(FST.S1_DepositsTakenAmt), 0) AS 'SF-DepositsTaken$'
INTO	#Surgery
FROM	HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON DCM.CenterKey = DC.CenterKey
		INNER JOIN #Centers C
			ON DC.ReportingCenterSSID = C.ReportingCenterSSID
WHERE	DD.FullDate BETWEEN @StartDate AND @EndDate
GROUP BY DC.ReportingCenterSSID
ORDER BY DC.ReportingCenterSSID


SELECT	CTR.RegionID
,		CTR.Region
,		CTR.CenterSSID AS 'Center'
,		CTR.CenterDescription AS 'Center_Name'
,		CTR.CenterTypeLongDescription AS 'CenterType'
,		CTR.CenterTypeShortDescription AS 'Type'
,		ISNULL(CSLT.Conultations, 0) AS 'Consultations'
,		ISNULL(CSLT.SurgeryOffered, 0) AS 'Sur_Consultations'
,		dbo.DIVIDE(ISNULL(CSLT.SurgeryOffered, 0),ISNULL(CSLT.Conultations, 0)) AS 'Percent_Surgery'
,		ISNULL(S.First_Surgery_Net_Sales, 0) AS 'First_Surgery_Net_Sales'
,		dbo.DIVIDE(ISNULL(S.First_Surgery_Net_Sales, 0), ISNULL(CSLT.SurgeryOffered, 0)) AS 'First_Surgery_Percent_Sales'
,		ISNULL(S.First_Surgery_Net$, 0) AS 'First_Surgery_Net$'
,		ISNULL(S.First_Surg_Rev_Per_Sales, 0) AS 'First_Surg_Rev_Per_Sales'
,		ISNULL(S.First_Surgery_Contract_Amount, 0) AS 'First_Surgery_Contract_Amount'
,		ISNULL(S.First_Surgery_Est_Grafts, 0) AS 'First_Surgery_Est_Grafts'
,		ISNULL(S.First_Surgery_Est_Per_Grafts, 0) AS 'First_Surgery_Est_Per_Grafts'
,		ISNULL(S.Addtl_Surgery_Net_Sales, 0) AS 'Addtl_Surgery_Net_Sales'
,		ISNULL(S.Addtl_Surgery_Net$, 0) AS 'Addtl_Surgery_Net$'
,		ISNULL(S.Addtl_Surg_Rev_Per_Sales, 0) AS 'Addtl_Surg_Rev_Per_Sales'
,		ISNULL(S.Addtl_Surgery_Contract_Amount, 0) AS 'Addtl_Surgery_Contract_Amount'
,		ISNULL(S.Addtl_Surgery_Est_Grafts, 0) AS 'Addtl_Surgery_Est_Grafts'
,		ISNULL(S.Addtl_Surgery_Est_Per_Grafts, 0) AS 'Addtl_Surgery_Est_Per_Grafts'
,		ISNULL(S.Total_Surgery_Performed, 0) AS 'Total_Surgery_Performed'
,		ISNULL(S.Total_Net$, 0) AS 'Total_Net$'
,		ISNULL(S.Total_Revenue_Per_Sales, 0) AS 'Total_Revenue_Per_Sales'
,		ISNULL(S.Total_Grafts, 0) AS 'Total_Grafts'
,		ISNULL(S.Total_Est_per_Grafts, 0) AS 'Total_Est_per_Grafts'
,		ISNULL(S.Total_POSTEXTPMT_Count, 0) AS 'Total_POSTEXTPMT_Count'
,		ISNULL(S.Total_POSTEXTPMT, 0) AS 'Total_POSTEXTPMT'
,		ISNULL(S.DepositCount, 0) AS 'DepositCount'
FROM	#Centers CTR
		LEFT OUTER JOIN #Consultations CSLT
			ON CTR.ReportingCenterSSID = CSLT.ReportingCenterSSID
		LEFT OUTER JOIN #Surgery S
			ON CTR.ReportingCenterSSID = S.ReportingCenterSSID

END
