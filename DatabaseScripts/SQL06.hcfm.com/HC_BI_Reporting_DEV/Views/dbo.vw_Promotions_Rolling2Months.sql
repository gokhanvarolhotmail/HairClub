/* CreateDate: 11/18/2019 11:13:09.077 , ModifyDate: 11/18/2019 11:50:21.143 */
GO
/***********************************************************************
VIEW:					vw_Promotions_Rolling2Months
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		11/18/2019
------------------------------------------------------------------------
NOTES:
This view is used to find the promotions per center
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vw_Promotions_Rolling2Months
***********************************************************************/
CREATE VIEW [dbo].[vw_Promotions_Rolling2Months]
AS

--Find dates for Rolling 2 Years

WITH Rolling2Months AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-2,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of two months ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
		),
	Centers AS (SELECT
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
				WHERE DC.Active = 'Y'
				AND DCT.CenterTypeDescriptionShort = 'C'
		)


SELECT CTR.CenterSSID
,	CTR.CenterNumber
,	CTR.CenterDescriptionNumber
,	CTR.MainGroupKey
,	CTR.MainGroupDescription
,	CTR.MainGroupSortOrder
,	FAR.Consultation
,	CLT.ClientIdentifier
,	CLT.ContactKey
,	CLT.ClientFullName
,	M.MembershipDescription
,	DCM.ClientMembershipBeginDate
,	DCM.ClientMembershipEndDate
,	FL.PromotionCodeKey
,	PC.PromotionCodeSSID
,	RDD.FullDate
FROM Centers CTR
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
	ON CLT.CenterSSID = CTR.CenterSSID
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
	ON CLT.contactkey = FAR.ContactKey
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
	ON FL.ContactKey = FAR.ContactKey
INNER JOIN Rolling2Months RDD
	ON FAR.ActivityDueDateKey = RDD.DateKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
	ON (CLT.CurrentBioMatrixClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentSurgeryClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentExtremeTherapyClientMembershipSSID = DCM.ClientMembershipSSID
	OR CLT.CurrentXtrandsClientMembershipSSID = DCM.ClientMembershipSSID)
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
	ON M.MembershipKey = DCM.MembershipKey
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode PC
	ON PC.PromotionCodeKey = FL.PromotionCodeKey
WHERE FAR.Consultation = 1
AND FL.PromotionCodeKey <> -1
GO
