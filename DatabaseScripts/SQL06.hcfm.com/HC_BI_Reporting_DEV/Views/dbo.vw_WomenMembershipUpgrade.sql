/***********************************************************************
VIEW:					[vw__WomenMembershipsUpgrades]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			04/04/2017 (For Rev - an updateable spreadsheet)
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM dbo.[vw__WomenMembershipsUpgrades]
***********************************************************************/
CREATE VIEW [dbo].[vw_WomenMembershipUpgrade]
AS


WITH Rolling2Months AS (
				SELECT	DD.FullDate
				,	DD.DateKey
				,	DD.MonthNumber
				,	DD.YearNumber
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN '3/11/2017' AND '5/31/2017'  --Dates set by Rev
				GROUP BY DD.FullDate
                ,	DD.DateKey
                ,	DD.MonthNumber
                ,	DD.YearNumber
		)

,	Centers AS (SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		CMA.CenterManagementAreaSortOrder
				,		CMA.CenterManagementAreaSSID
				,		CMA.CenterManagementAreaDescription
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
)
,	PMC AS (SELECT	C.RegionSSID
				,		C.RegionDescription
				,		C.CenterSSID
				,		C.CenterDescriptionNumber
				,		DSO.InvoiceNumber
				,		DD.FullDate AS 'PMC Date'
				,		CLT.ClientKey
				,		CLT.ClientFullName + ' (' + CONVERT(VARCHAR, CLT.ClientIdentifier) + ')' AS 'ClientName'
				,		DM.GenderDescription
				,		PrevDM.MembershipDescription AS 'ConvertedFrom'
				,		DM.MembershipDescription AS 'ConvertedTo'
				,		DSC.SalesCodeDescriptionShort
				,		DSC.SalesCodeDescription
				,		Dept.SalesCodeDepartmentSSID AS 'Department'
				,		Div.SalesCodeDivisionSSID AS 'Division'
				,		FST.ExtendedPrice
				,		FST.Tax1
				,		FST.ExtendedPricePlusTax
				,		FST.Employee1Key
				,		PFR.EmployeeFullName AS 'CRM'
				FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
						INNER JOIN Rolling2Months DD
							ON FST.OrderDateKey = DD.DateKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
							ON FST.CenterKey = CTR.CenterKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
							ON FST.ClientKey = CLT.ClientKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
							ON FST.SalesCodeKey = DSC.SalesCodeKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment Dept
							ON DSC.SalesCodeDepartmentKey = Dept.SalesCodeDepartmentKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision Div
							ON Dept.SalesCodeDivisionKey = Div.SalesCodeDivisionKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
							ON FST.SalesOrderKey = DSO.SalesOrderKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderType DSOT
							ON DSO.SalesOrderTypeKey = DSOT.SalesOrderTypeKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
							ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
							ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
							ON DCM.MembershipSSID = DM.MembershipSSID
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PrevDCM
							ON DSOD.PreviousClientMembershipSSID = PrevDCM.ClientMembershipSSID
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PrevDM
							ON PrevDCM.MembershipSSID = PrevDM.MembershipSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
							ON DCM.CenterKey = DC.CenterKey
						INNER JOIN Centers C
							ON DC.ReportingCenterSSID = C.CenterSSID
						LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR
							ON FST.Employee1Key = PFR.EmployeeKey

				WHERE   DSC.SalesCodeKey = 636 --Upgrade Membership
						AND DM.RevenueGroupDescription = 'Recurring Business'
						AND DM.GenderDescription = 'Female'

)

,	Payments AS  (SELECT	PMC.CenterDescriptionNumber
						,	FST2.ClientKey
						,	PMC.ClientName
						,	SUM(FST2.PCP_PCPAmt) AS 'PCP_PCPAmt'
						,	DD2.FullDate AS 'PaymentDate'
					FROM PMC
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST2
						ON PMC.ClientKey = FST2.ClientKey
					INNER JOIN Rolling2Months DD
						ON FST2.OrderDateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD2
						ON FST2.OrderDateKey = DD2.DateKey
					WHERE  PCP_PCPAmt <> '0.00'
					GROUP BY CenterDescriptionNumber
						,	FST2.ClientKey
						,	ClientName
						,	DD2.FullDate

)

SELECT RegionSSID
	,	RegionDescription
	,	CenterSSID
	,	PMC.CenterDescriptionNumber
	,	InvoiceNumber
	,	[PMC Date]
	,	PMC.ClientKey
	,	PMC.ClientName
	,	GenderDescription
	,	ConvertedFrom
	,	ConvertedTo
	,	SalesCodeDescriptionShort
	,	SalesCodeDescription
	,	Department
	,	Division
	,	ExtendedPrice
	,	Tax1
	,	ExtendedPricePlusTax
	,	Employee1Key
	,	CRM
	,	PCP_PCPAmt
	,	PaymentDate
FROM PMC
INNER JOIN Payments
ON Payments.ClientKey = PMC.ClientKey
