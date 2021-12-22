/* CreateDate: 09/13/2011 10:00:01.147 , ModifyDate: 08/20/2019 17:03:56.257 */
GO
/*
==============================================================================

PROCEDURE:				sprpt_SurgerySales

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Hung Du

DATE IMPLEMENTED:		09/13/2011

LAST REVISION DATE: 	08/20/2019

==============================================================================
DESCRIPTION:	Shows all surgery sales for a date range
==============================================================================
CHANGE HISTORY:
09/13/2011 - HD - Create
08/20/2019 - RH - Changed join on vwDimActivity to SFDC_TaskID

==============================================================================
GRANT EXECUTE ON sprpt_SurgerySales TO IIS
==============================================================================
SAMPLE EXECUTION:
EXEC [sprpt_SurgerySales] '8/1/2019', '8/5/2019', NULL

==============================================================================
*/
CREATE PROCEDURE [dbo].[sprpt_SurgerySales]
	@StartDate	DATETIME = NULL -- Optional, linked with EndDate , Defaults to Today
,	@EndDate	DATETIME = NULL -- Optional, linked with StartDate, Defaults to Today + 7 days
,	@DoctorRegionDescriptionShort VARCHAR(10) = NULL -- Optional

AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

IF (@StartDate IS NULL OR @StartDate ='' OR @EndDate IS NULL OR @EndDate = '')
BEGIN
	SELECT @StartDate = CONVERT(VARCHAR(10),GETDATE(),120)
	, @EndDate = DATEADD(DAY,7,@StartDate)
END


SELECT INFO.ClientHomeCenterKey as 'CenterKey'
	,	sum(CASE WHEN (INFO.AccumulatorKey = 48 /*or INFO.SalesCodeKey = 471*/)  THEN --AccumulatorKey is null for Cancels
				INFO.[SF-First_Surgery_Net_Sales] ELSE 0 END) AS 'First_Surgery_Net_Sales'
	,	sum(INFO.[SF-First_Surgery_Net$]) AS 'First_Surgery_Net$'
	,	dbo.divide(
			sum(INFO.[SF-First_Surgery_Net$]),
			sum(INFO.[SF-First_Surgery_Net_Sales])
		) as 'First_Surg_Rev_Per_Sales'
	,	sum(INFO.[SF-First_Surgery_Contract_Amount]) AS 'First_Surgery_Contract_Amount'
	,	sum(INFO.[SF-First_Surgery_Est_Grafts]) AS 'First_Surgery_Est_Grafts'
	,	dbo.divide(
			sum(INFO.[SF-First_Surgery_Contract_Amount]),
			sum(INFO.[SF-First_Surgery_Est_Grafts])
		) as 'First_Surgery_Est_Per_Grafts'

	,	sum(CASE WHEN (INFO.AccumulatorKey = 48 /*or INFO.SalesCodeKey = 471*/) THEN  --AccumulatorKey is null for Cancels
				INFO.[SF-Addtl_Surgery_Net_Sales] ELSE 0 END) AS 'Addtl_Surgery_Net_Sales'

	,	sum(INFO.[SF-Addtl_Surgery_Net$]) AS 'Addtl_Surgery_Net$'
	,	dbo.divide(
			sum(INFO.[SF-Addtl_Surgery_Net$]),
			sum(INFO.[SF-Addtl_Surgery_Net_Sales])
		) as'Addtl_Surg_Rev_Per_Sales'
	,	sum(INFO.[SF-Addtl_Surgery_Contract_Amount]) AS 'Addtl_Surgery_Contract_Amount'
	,	sum(INFO.[SF-Addtl_Surgery_Est_Grafts]) AS 'Addtl_Surgery_Est_Grafts'
	,	dbo.divide(
			sum(INFO.[SF-Addtl_Surgery_Contract_Amount]),
			sum(INFO.[SF-Addtl_Surgery_Est_Grafts])
		) as 'Addtl_Surgery_Est_Per_Grafts'
--
	,	sum(INFO.[SF-Total_Surgery_Performed]) AS 'Total_Surgery_Performed'
	,	sum(INFO.[SF-Total_Net$]) as 'Total_Net$'
	,	dbo.[Divide](
			SUM(INFO.[SF-Total_Net$]),
			SUM(INFO.[SF-Total_Surgery_Performed])
		) 'Total_Revenue_Per_Sales'
--
	,	SUM(INFO.[SF-Total_Grafts]) as 'TotalGrafts'
	,	dbo.[Divide] (
			SUM(INFO.[SF-Total_Net$]),
			SUM(INFO.[SF-Total_Grafts])
		) 'Total_Est_per_Grafts'
--
	,	SUM(INFO.[SF-Total_POSTEXTPMT_Count]) as 'Total_POSTEXTPMT_Count'
	,	SUM(INFO.[SF-Total_POSTEXTPMT]) as 'Total_POSTEXTPMT'
--
	,	SUM(INFO.[SF-DepositsTaken]) AS 'DepositCount'
	,	SUM(INFO.[SF-DepositsTaken$]) as 'SF-DepositsTaken$'
INTO #SurgeryData
FROM [HC_BI_CMS_DDS].[bi_cms_dds].[vwFactSalesFirstSurgeryInfo] INFO
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.vwDimSalesCode SC
		ON INFO.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.vwDimClient CL
		ON INFO.ClientKey = CL.ClientKey
WHERE INFO.SalesCodeKey NOT IN (20,17,21,19,30,32,36)
--AND INFO.SalesCodeKey NOT IN (471,493,469)
--AND INFO.SalesCodeDepartmentSSID NOT IN ('1099','1030','1030','2020')
AND INFO.OrderDate BETWEEN @StartDate and @EndDate
GROUP BY ClientHomeCenterKey


--The #SurgeryData contains PostEXT counts for any and all clients in the date range
--This is a table of PostEXT that are from the clients in the Sales
SELECT cl.CenterKey
,SUM(PostEXT.TotalAccumQuantity) AS TotalPostEXT
INTO #PostEXTData
FROM (
	SELECT DISTINCT INFO.ClientMembershipKey, INFO.CenterKey
	FROM [HC_BI_CMS_DDS].[bi_cms_dds].[vwFactSalesFirstSurgeryInfo] INFO
	WHERE INFO.SalesCodeKey NOT IN (20,17,21,19,30,32,36)
	AND INFO.OrderDate BETWEEN @StartDate and @EndDate
	AND INFO.AccumulatorKey = 48
	AND (INFO.[SF-First_Surgery_Net_Sales] >0 OR INFO.[SF-Addtl_Surgery_Net_Sales] >0)
) cl
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[vwDimClientMembershipAccum] PostEXT
	ON cl.ClientMembershipKey = PostEXT.ClientMembershipKey
	AND PostEXT.AccumulatorKey IN (62,67) --PostEXT Accumulator
GROUP BY cl.CenterKey


SELECT CASE
	WHEN DACT.CenterSSID BETWEEN 200 AND 299 THEN DACT.CenterSSID + 100
	WHEN DACT.CenterSSID BETWEEN 700 AND 899 THEN DACT.CenterSSID - 200
	ELSE DACT.CenterSSID END
	AS 'CenterID'
,	SUM(IsConsultation) AS 'Consultations'
,	SUM(CASE WHEN SurgeryOffered = 'Y' THEN 1 ELSE 0 END) AS 'Sur_Consultations'
INTO #ConsultationData
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwDimActivityResult  FAR
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimActivity DACT
	ON FAR.SFDC_TaskID = DACT.SFDC_TaskID
WHERE DACT.activityduedate BETWEEN @StartDate and @EndDate
GROUP BY CASE
	WHEN DACT.CenterSSID BETWEEN 200 AND 299 THEN DACT.CenterSSID + 100
	WHEN DACT.CenterSSID BETWEEN 700 AND 899 THEN DACT.CenterSSID - 200
	ELSE DACT.CenterSSID END

SELECT *
FROM (
SELECT
CASE WHEN @DoctorRegionDescriptionShort != '' OR @DoctorRegionDescriptionShort IS NOT NULL THEN @DoctorRegionDescriptionShort
	WHEN CenterType.CenterTypeDescriptionShort = 'JV' THEN 'Franchise'
	ELSE CenterType.CenterTypeDescription END AS 'CenterType'
,DoctorRegion.[DoctorRegionDescriptionShort] 'Region'
,SUM(ISNULL(Consultations.Consultations,0)) 'Consultations' -- Total
,SUM(ISNULL(Consultations.Sur_Consultations,0)) 'Sur_Consultations' --Surgery Consultations
,dbo.DIVIDE(
	SUM(ISNULL(Consultations.Sur_Consultations,0))
	,SUM(ISNULL(Consultations.Consultations,0))
) 'Percent_Surgery' --Sur%
--
,SUM(ISNULL(Surgery.First_Surgery_Net_Sales,0)) + SUM(ISNULL(Surgery.Addtl_Surgery_Net_Sales,0)) 'Sale' --Sales = 1st+Additionals
,dbo.DIVIDE(
	SUM(ISNULL(Surgery.First_Surgery_Net_Sales,0)) + SUM(ISNULL(Surgery.Addtl_Surgery_Net_Sales,0))
	,SUM(ISNULL(Consultations.Sur_Consultations,0))
) 'Percent_Close' --Close %
,SUM(ISNULL(Surgery.First_Surgery_Net$,0)) + SUM(ISNULL(Surgery.Addtl_Surgery_Net$,0)) 'Collected' --Collected
--
,SUM(ISNULL(Surgery.First_Surgery_Contract_Amount,0)) + SUM(ISNULL(Surgery.Addtl_Surgery_Contract_Amount,0)) 'Est' --Est
,SUM(ISNULL(Surgery.First_Surgery_Est_Grafts,0)) + SUM(ISNULL(Surgery.Addtl_Surgery_Est_Grafts,0)) 'Grafts'--Grafts
,dbo.DIVIDE(
	SUM(ISNULL(Surgery.First_Surgery_Contract_Amount,0)) + SUM(ISNULL(Surgery.Addtl_Surgery_Contract_Amount,0))
	,SUM(ISNULL(Surgery.First_Surgery_Est_Grafts,0)) + SUM(ISNULL(Surgery.Addtl_Surgery_Est_Grafts,0))
) 'Est_Per_Graft' --$/Graft
--
,SUM(ISNULL(Surgery.Addtl_Surgery_Net_Sales,0)) 'Add_Surgery'--Addtl Surgery
,dbo.DIVIDE(
	SUM(ISNULL(Surgery.Addtl_Surgery_Net_Sales,0))
	,SUM(ISNULL(Surgery.First_Surgery_Net_Sales,0)) + SUM(ISNULL(Surgery.Addtl_Surgery_Net_Sales,0))
) 'Percent_Add_Surgery'--Percent of Surgerys that were Addtl surgery
--
,SUM(ISNULL(PostEXT.TotalPostEXT,0)) 'PostEXT' --PostEXT in Sales
,dbo.DIVIDE(
	SUM(ISNULL(PostEXT.TotalPostEXT,0))
	,SUM(ISNULL(Surgery.First_Surgery_Net_Sales,0)) + SUM(ISNULL(Surgery.Addtl_Surgery_Net_Sales,0))
) 'Percent_PostEXT' --Percent of Surgery that have POSTEXT

,SUM(ISNULL(Surgery.Total_POSTEXTPMT_Count,0)) 'PostEXTAll' --PostEXT All

FROM HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter Center
INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[vwDimDoctorRegion] DoctorRegion
	ON Center.DoctorRegionKey= DoctorRegion.DoctorRegionKey
	AND Center.DoctorRegionKey > 0
	AND (@DoctorRegionDescriptionShort IS NULL
		OR @DoctorRegionDescriptionShort = ''
		OR DoctorRegion.DoctorRegionDescriptionShort = @DoctorRegionDescriptionShort)
	--AND DoctorRegion.Active = 1

INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenterType CenterType
	ON Center.CenterTypeKey = CenterType.CenterTypeKey
	--AND Center.CenterTypeKey > 0

LEFT OUTER JOIN #SurgeryData Surgery
	ON Center.CenterKey = Surgery.CenterKey

LEFT OUTER JOIN #PostEXTData PostEXT
	ON Center.CenterKey = PostEXT.CenterKey

LEFT OUTER JOIN #ConsultationData Consultations
	ON Center.CenterSSID = Consultations.CenterID

--WHERE --Center.Active = 'Y'
GROUP BY CenterType.CenterTypeDescription, CenterType.CenterTypeDescriptionShort, DoctorRegion.DoctorRegionDescriptionShort
) tbl
ORDER BY CenterType, Region


DROP TABLE #ConsultationData
DROP TABLE #SurgeryData
DROP TABLE #PostEXTData

END
GO
