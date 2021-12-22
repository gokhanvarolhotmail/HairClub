/* CreateDate: 09/19/2018 11:33:56.003 , ModifyDate: 08/20/2019 17:22:49.860 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
CHANGE HISTORY:
08/20/2019 - RH - Removed ContactSSID and ActivitySSID
***********************************************************************
select * from [vw_ClosingByConsultant_Rolling2Years] order by ContactFullName
***********************************************************************/
--Full select [dbo].[vwClosingByConsultant]


CREATE VIEW [dbo].[vw_ClosingByConsultant_Rolling2Years]
AS

WITH Centers
	AS (SELECT  CMA.CenterManagementAreaSSID
				,		CMA.CenterManagementAreaDescription
				,		CMA.CenterManagementAreaSortOrder
				,		DC.CenterNumber
				,		DC.CenterKey
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
				WHERE   DCT.CenterTypeDescriptionShort = 'C'
						AND DC.Active = 'Y'
),
 Rolling2Years AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.FirstDateOfMonth
				,	DD.MonthNumber
				,	DD.YearNumber
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(yy, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))	--First date of year two years ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) ))				--KEEP Today at 11:59PM

				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.FirstDateOfMonth
				,	DD.MonthNumber
				,	DD.YearNumber
)




SELECT  CenterManagementAreaSSID
				,		CenterManagementAreaDescription
				,		CenterManagementAreaSortOrder
				,		CenterNumber
				,		C.CenterKey
				,		CenterDescriptionNumber
				,		CenterTypeDescriptionShort
,		E.EmployeeKey
,		DAD.Performer
,		DA.ActivityDueDate
,		DA.ActivitySSID
,		ISNULL(DA.ActionCodeDescription, '') AS 'ActionCode'
,		ISNULL(DA.ResultCodeDescription, '') AS 'ResultCode'
,		ISNULL(DAD.NoSaleReason, '') AS 'NoSaleReason'
,		CASE WHEN DAD.SolutionOffered <> '' THEN DAD.SolutionOffered ELSE M.MembershipDescription END AS 'SolutionOffered'
,		CASE WHEN DA.ResultCodeDescription = 'Show Sale' THEN FST.ExtendedPrice
				WHEN DA.ResultCodeDescription = 'Show No Sale' THEN ISNULL(DAD.PriceQuoted, '') ELSE '' END AS 'PriceQuoted'
,		CASE WHEN FAR.Consultation = 1 THEN 'Consultation'
				WHEN FAR.BeBack = 1 THEN 'BeBack' END AS 'Type'
,		DC.ContactFullName
,		ISNULL(DAD.GenderDescription,DC.ContactGender) AS 'ContactGender'
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN Centers C
			ON C.CenterKey = FAR.CenterKey
        INNER JOIN Rolling2Years ROLL
			ON ROLL.DateKey = FAR.ActivityDueDateKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
			ON DA.ActivityKey = FAR.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
			ON DC.SFDC_LeadID = DA.SFDC_LeadID
		LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult DAR
			ON DAR.SFDC_TaskID = DA.SFDC_TaskID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAD
			ON DAD.SFDC_TaskID = DA.SFDC_TaskID
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON DAD.Performer = E.EmployeeFullName AND E.IsActiveFlag = 1
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.contactkey = FAR.ContactKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			ON FST.ContactKey = CLT.contactkey
				AND SalesCodeKey = 467  --INITASG
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON M.MembershipKey = FST.MembershipKey

WHERE   (FAR.Consultation = 1 OR FAR.BeBack = 1)
	AND DA.ResultCodeDescription IN ('Show Sale','Show No Sale')
	AND  M.MembershipDescription <> 'New Client (ShowNoSale)'
UNION
SELECT  CenterManagementAreaSSID
,		CenterManagementAreaDescription
,		CenterManagementAreaSortOrder
,		CenterNumber
,		C.CenterKey
,		CenterDescriptionNumber
,		CenterTypeDescriptionShort
,		E.EmployeeKey
,		DAD.Performer
,		DA.ActivityDueDate
,		DA.ActivitySSID
,		ISNULL(DA.ActionCodeDescription, '') AS 'ActionCode'
,		ISNULL(DA.ResultCodeDescription, '') AS 'ResultCode'
,		ISNULL(DAD.NoSaleReason, '') AS 'NoSaleReason'
,		CASE WHEN DAD.SolutionOffered <> '' THEN DAD.SolutionOffered ELSE M.MembershipDescription END AS 'SolutionOffered'
,		CASE WHEN DA.ResultCodeDescription = 'Show Sale' THEN FST.ExtendedPrice
				WHEN DA.ResultCodeDescription = 'Show No Sale' THEN ISNULL(DAD.PriceQuoted, '') ELSE '' END AS 'PriceQuoted'
,		'Referral' AS 'Type'
,		DC.ContactFullName
,		ISNULL(DAD.GenderDescription,DC.ContactGender) AS 'ContactGender'
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
        INNER JOIN Centers C
			ON C.CenterKey = FAR.CenterKey
        INNER JOIN Rolling2Years ROLL
			ON ROLL.DateKey = FAR.ActivityDueDateKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
			ON DA.ActivityKey = FAR.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
			ON DC.SFDC_LeadID = DA.SFDC_LeadID
		LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult DAR
			ON DAR.SFDC_TaskID = DA.SFDC_TaskID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAD
			ON DAD.SFDC_TaskID = DA.SFDC_TaskID
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON DAD.Performer = E.EmployeeFullName AND E.IsActiveFlag = 1
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.contactkey = FAR.ContactKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			ON FST.ContactKey = CLT.contactkey
				AND SalesCodeKey = 467  --INITASG
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON M.MembershipKey = FST.MembershipKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
					ON FAR.ActivityKey = A.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
					ON A.SourceSSID = DS.SourceSSID

WHERE  DS.Media IN ('Referrals', 'Referral')
		AND (FAR.BOSRef = 1 OR
			 FAR.BOSOthRef = 1 OR
			 FAR.HCRef = 1)
		AND FAR.BOSAppt <> 1
		AND DA.ResultCodeDescription IN ('Show Sale','Show No Sale')
		AND  M.MembershipDescription <> 'New Client (ShowNoSale)'
GO
