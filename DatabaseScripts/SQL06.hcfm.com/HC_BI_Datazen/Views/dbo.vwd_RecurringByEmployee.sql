/***********************************************************************
VIEW:					vwd_RecurringByEmployee
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		08/21/2015
------------------------------------------------------------------------
NOTES:
01/26/2018 - RH - Added CenterType (#145957)
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_RecurringByEmployee
***********************************************************************/
CREATE VIEW [dbo].[vwd_RecurringByEmployee]
AS


WITH Rolling3Months AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	MAX(DD.MonthWorkdaysTotal) AS 'MonthWorkdaysTotal'
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-3,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of two months ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				, DD.YearNumber
		)


	SELECT  DD.FullDate
,	DD.YearNumber
,	DD.MonthNumber
,	CTR.CenterSSID
,	E2.EmployeeFullName AS 'Stylist'
,	E1.EmployeeFullName AS 'Consultant'
,	CLT.ClientFullName
,	M.MembershipDescription
,	CASE WHEN ISNULL(FST.NB_BIOConvCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_BIOConvCnt'
,	CASE WHEN ISNULL(FST.NB_ExtConvCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_ExtConvCnt'
,	CASE WHEN ISNULL(FST.NB_XTRConvCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_XTRConvCnt'
,	(CASE WHEN ISNULL(FST.NB_BIOConvCnt, 0) <> 0 THEN 1 ELSE 0 END
	+ CASE WHEN ISNULL(FST.NB_ExtConvCnt, 0) <> 0 THEN 1 ELSE 0 END
	+ CASE WHEN ISNULL(FST.NB_XTRConvCnt, 0) <> 0 THEN 1 ELSE 0 END) AS 'TotalConv'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN Rolling3Months DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FST.CenterKey = CTR.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON CT.CenterTypeKey = CTR.CenterTypeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON FST.MembershipKey = M.MembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
	LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E1
		ON FST.Employee1Key = E1.EmployeeKey
	LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
		ON FST.Employee2Key = E2.EmployeeKey
WHERE CT.CenterTypeDescriptionShort = 'C'
	AND (ISNULL(FST.NB_BIOConvCnt, 0) <> 0
	OR ISNULL(FST.NB_ExtConvCnt, 0) <> 0
	OR ISNULL(FST.NB_XTRConvCnt, 0) <> 0)
GROUP BY CASE WHEN ISNULL(FST.NB_BIOConvCnt ,0) <> 0 THEN 1
       ELSE 0
       END
       , CASE WHEN ISNULL(FST.NB_ExtConvCnt ,0) <> 0 THEN 1
       ELSE 0
       END
       , CASE WHEN ISNULL(FST.NB_XTRConvCnt ,0) <> 0 THEN 1
       ELSE 0
       END
       , DD.FullDate
       , DD.YearNumber
       , DD.MonthNumber
       , CTR.CenterSSID
       , CLT.ClientFullName
       , M.MembershipDescription
       , E1.EmployeeFullName
       , E2.EmployeeFullName
