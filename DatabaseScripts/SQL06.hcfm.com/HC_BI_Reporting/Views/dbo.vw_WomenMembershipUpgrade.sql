/* CreateDate: 04/04/2017 14:01:02.360 , ModifyDate: 04/28/2017 13:35:28.970 */
GO
/***********************************************************************
VIEW:					[vw_WomenMembershipUpgrade]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			04/04/2017 (For Rev - an updateable spreadsheet)
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM dbo.[vw_WomenMembershipUpgrade] where CenterSSID = 201 ORDER BY CenterSSID, ClientName
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
				,		DD.FullDate AS 'PMCDate'
				,		CLT.ClientKey
				,		CLT.ClientFullName + ' (' + CONVERT(VARCHAR, CLT.ClientIdentifier) + ')' AS 'ClientName'
				,		DM.GenderDescription
				,		PrevDM.MembershipDescription AS 'ConvertedFrom'
				,		DM.MembershipKey AS 'ConvertedToMembershipKey'
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
						,	CASE WHEN DD2.FullDate BETWEEN '3/15/2017' AND '3/31/2017' THEN '3/15/2017'
							WHEN DD2.FullDate BETWEEN '4/01/2017' AND '4/14/2017' THEN '4/01/2017'
							WHEN DD2.FullDate BETWEEN '4/15/2017' AND '4/30/2017' THEN '4/15/2017'
							WHEN DD2.FullDate BETWEEN '5/01/2017' AND '5/14/2017' THEN '5/01/2017'
							WHEN DD2.FullDate BETWEEN '5/15/2017' AND '5/31/2017' THEN '5/15/2017'
							WHEN DD2.FullDate BETWEEN '6/01/2017' AND '6/14/2017' THEN '6/01/2017'
							WHEN DD2.FullDate BETWEEN '6/15/2017' AND '6/30/2017' THEN '6/15/2017'
							WHEN DD2.FullDate BETWEEN '7/01/2017' AND '7/14/2017' THEN '7/01/2017'
							WHEN DD2.FullDate BETWEEN '7/15/2017' AND '7/31/2017' THEN '7/15/2017'
							WHEN DD2.FullDate BETWEEN '8/01/2017' AND '8/14/2017' THEN '8/01/2017'
							END AS 'PaymentDate'
						,	PMC.PMCDate
					FROM PMC
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST2
						ON PMC.ClientKey = FST2.ClientKey
					INNER JOIN Rolling2Months DD
						ON FST2.OrderDateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD2
						ON FST2.OrderDateKey = DD2.DateKey
					WHERE  PCP_PCPAmt <> '0.00'
					AND DD2.FullDate > PMC.PMCDate
					GROUP BY CenterDescriptionNumber
						,	FST2.ClientKey
						,	ClientName
						,	DD2.FullDate
						,	PMC.PMCDate

)

,	NationalPricing AS (SELECT DMRBC.MembershipKey
							,	PMC.ConvertedTo
							,	CAST(ROUND(DMRBC.MembershipRate, 2) AS MONEY) AS 'NationalRate'
						FROM PMC
						LEFT OUTER JOIN HC_DeferredRevenue.dbo.DimMembershipRatesByCenter DMRBC
							ON DMRBC.CenterSSID = PMC.CenterSSID
								AND DMRBC.MembershipKey = PMC.ConvertedToMembershipKey
								AND GETDATE() BETWEEN DMRBC.RateStartDate AND DMRBC.RateEndDate
)



,	Upgrades AS (SELECT RegionSSID
			,	RegionDescription
			,	CenterSSID
			,	PMC.CenterDescriptionNumber
			,	InvoiceNumber
			,	PMC.PMCDate
			,	PMC.ClientKey
			,	PMC.ClientName
			,	GenderDescription
			,	ConvertedFrom
			,	PMC.ConvertedTo
			,	SalesCodeDescriptionShort
			,	SalesCodeDescription
			,	Department
			,	Division
			,	ExtendedPrice
			,	Tax1
			,	ExtendedPricePlusTax
			,	Employee1Key
			,	CRM
			,	CASE WHEN Payments.PaymentDate = '3/15/2017' THEN ISNULL(Payments.PCP_PCPAmt,0)  END AS '3/15/2017'
			,	CASE WHEN Payments.PaymentDate = '4/01/2017' THEN ISNULL(Payments.PCP_PCPAmt,0)  END AS '4/01/2017'
			,	CASE WHEN Payments.PaymentDate = '4/15/2017' THEN ISNULL(Payments.PCP_PCPAmt,0)  END AS '4/15/2017'
			,	CASE WHEN Payments.PaymentDate = '5/01/2017' THEN ISNULL(Payments.PCP_PCPAmt,0)  END AS '5/01/2017'
			,	CASE WHEN Payments.PaymentDate = '5/15/2017' THEN ISNULL(Payments.PCP_PCPAmt,0) END AS '5/15/2017'

			,	CASE WHEN Payments.PaymentDate = '6/01/2017' THEN ISNULL(Payments.PCP_PCPAmt,0)  END AS '6/01/2017'
			,	CASE WHEN Payments.PaymentDate = '6/15/2017' THEN ISNULL(Payments.PCP_PCPAmt,0) END AS '6/15/2017'
			,	CASE WHEN Payments.PaymentDate = '7/01/2017' THEN ISNULL(Payments.PCP_PCPAmt,0)  END AS '7/01/2017'
			,	CASE WHEN Payments.PaymentDate = '7/15/2017' THEN ISNULL(Payments.PCP_PCPAmt,0) END AS '7/15/2017'
			,	CASE WHEN Payments.PaymentDate = '8/01/2017' THEN ISNULL(Payments.PCP_PCPAmt,0)  END AS '8/01/2017'
			,	NP.NationalRate
		FROM PMC
		INNER JOIN Payments
			ON Payments.ClientKey = PMC.ClientKey
		INNER JOIN NationalPricing NP
			ON PMC.ConvertedToMembershipKey = NP.MembershipKey
		WHERE Payments.PaymentDate > PMC.PMCDate
		GROUP BY PMC.RegionSSID
			,	PMC.RegionDescription
			,	PMC.CenterSSID
			,	PMC.CenterDescriptionNumber
			,	PMC.InvoiceNumber
			,	PMC.PMCDate
			,	PMC.ClientKey
			,	PMC.ClientName
			,	PMC.GenderDescription
			,	PMC.ConvertedFrom
			,	PMC.ConvertedTo
			,	PMC.SalesCodeDescriptionShort
			,	PMC.SalesCodeDescription
			,	PMC.Department
			,	PMC.Division
			,	PMC.ExtendedPrice
			,	PMC.Tax1
			,	PMC.ExtendedPricePlusTax
			,	PMC.Employee1Key
			,	PMC.CRM
			,	Payments.PaymentDate
			,	NP.NationalRate
			,	ISNULL(Payments.PCP_PCPAmt,0)
)


,		Totals AS (SELECT	RegionSSID
				,	RegionDescription
				,	CenterSSID
				,	CenterDescriptionNumber
				,	InvoiceNumber
				,	PMCDate
				,	ClientKey
				,	ClientName
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
				,	NationalRate

				,	MAX([3/15/2017]) AS '3/15/2017'
				,	CASE WHEN ISNULL(MAX([3/15/2017]),0) >= NationalRate THEN 0  WHEN  ISNULL(MAX([3/15/2017]),0) = 0 THEN 0 ELSE 1 END AS '1_NatRate'

				,	MAX([4/01/2017]) AS '4/01/2017'
				,	CASE WHEN ISNULL(MAX([4/01/2017]),0) >= NationalRate THEN 0  WHEN  ISNULL(MAX([4/01/2017]),0) = 0 THEN 0 ELSE 1 END AS '2_NatRate'

				,	MAX([4/15/2017]) AS '4/15/2017'
				,	CASE WHEN ISNULL(MAX([4/15/2017]),0) >= NationalRate THEN 0  WHEN  ISNULL(MAX([4/15/2017]),0) = 0 THEN 0 ELSE 1 END AS '3_NatRate'

				,	MAX([5/01/2017]) AS '5/01/2017'
				,	CASE WHEN ISNULL(MAX([5/01/2017]),0)  >= NationalRate THEN 0  WHEN  ISNULL(MAX([5/01/2017]),0) = 0 THEN 0 ELSE 1 END AS '4_NatRate'

				,	MAX([5/15/2017]) AS '5/15/2017'
				,	CASE WHEN ISNULL(MAX([5/15/2017]),0) >= NationalRate THEN 0  WHEN  ISNULL(MAX([5/15/2017]),0) = 0 THEN 0 ELSE 1 END AS '5_NatRate'

				,	MAX([6/01/2017]) AS '6/01/2017'
				,	CASE WHEN ISNULL(MAX([6/01/2017]),0) >= NationalRate THEN 0  WHEN  ISNULL(MAX([6/01/2017]),0) = 0 THEN 0 ELSE 1 END AS '6_NatRate'

				,	MAX([6/15/2017]) AS '6/15/2017'
				,	CASE WHEN ISNULL(MAX([6/15/2017]),0) >= NationalRate THEN 0  WHEN  ISNULL(MAX([6/15/2017]),0) = 0 THEN 0 ELSE 1 END AS '7_NatRate'

				,	MAX([7/01/2017]) AS '7/01/2017'
				,	CASE WHEN ISNULL(MAX([7/01/2017]),0) >= NationalRate THEN 0  WHEN  ISNULL(MAX([7/01/2017]),0) = 0 THEN 0 ELSE 1 END AS '8_NatRate'

				,	MAX([7/15/2017]) AS '7/15/2017'
				,	CASE WHEN ISNULL(MAX([7/15/2017]),0) >= NationalRate THEN 0  WHEN  ISNULL(MAX([7/15/2017]),0) = 0 THEN 0 ELSE 1 END AS '9_NatRate'

				,	MAX([8/01/2017]) AS '8/01/2017'
				,	CASE WHEN ISNULL(MAX([8/01/2017]),0) >= NationalRate THEN 0  WHEN  ISNULL(MAX([8/01/2017]),0) = 0 THEN 0 ELSE 1 END AS '10_NatRate'

				FROM Upgrades
				GROUP BY RegionSSID
				,	RegionDescription
				,	CenterSSID
				,	CenterDescriptionNumber
				,	InvoiceNumber
				,	PMCDate
				,	ClientKey
				,	ClientName
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
				,	NationalRate)

SELECT Totals.RegionSSID
     , Totals.RegionDescription
     , Totals.CenterSSID
     , Totals.CenterDescriptionNumber
     , Totals.InvoiceNumber
     , Totals.PMCDate
     , Totals.ClientKey
     , Totals.ClientName
     , Totals.GenderDescription
     , Totals.ConvertedFrom
     , Totals.ConvertedTo
     , Totals.SalesCodeDescriptionShort
     , Totals.SalesCodeDescription
     , Totals.Department
     , Totals.Division
     , Totals.ExtendedPrice
     , Totals.Tax1
     , Totals.ExtendedPricePlusTax
     , Totals.Employee1Key
     , Totals.CRM
     , Totals.NationalRate

	 , CASE WHEN Totals.[3/15/2017] IS NOT NULL THEN Totals.[3/15/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NOT NULL THEN Totals.[4/01/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NOT NULL THEN Totals.[4/15/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NOT NULL THEN Totals.[5/01/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NOT NULL THEN Totals.[5/15/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NOT NULL THEN Totals.[6/01/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NOT NULL THEN Totals.[6/15/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NOT NULL THEN Totals.[7/01/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NULL AND Totals.[7/15/2017] IS NOT NULL THEN Totals.[7/15/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NULL AND Totals.[7/15/2017] IS NULL
				AND Totals.[8/01/2017] IS NOT NULL THEN Totals.[8/01/2017]
		END AS 'FirstPayment'
	, CASE WHEN Totals.[3/15/2017] IS NOT NULL THEN Totals.[1_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NOT NULL THEN Totals.[2_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NOT NULL THEN Totals.[3_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NOT NULL THEN Totals.[4_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NOT NULL THEN Totals.[5_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NOT NULL THEN Totals.[6_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NOT NULL THEN Totals.[7_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NOT NULL THEN Totals.[8_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NULL AND Totals.[7/15/2017] IS NOT NULL THEN Totals.[9_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NULL AND Totals.[7/15/2017] IS NULL
				AND Totals.[8/01/2017] IS NOT NULL THEN Totals.[10_NatRate]
		END AS 'First_IsLessThanNationalPricing'
		 , CASE WHEN Totals.[3/15/2017] IS NOT NULL THEN Totals.[4/15/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NOT NULL THEN Totals.[5/01/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NOT NULL THEN Totals.[5/15/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NOT NULL THEN Totals.[6/01/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NOT NULL THEN Totals.[6/15/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NOT NULL THEN Totals.[7/01/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NOT NULL THEN Totals.[7/15/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NOT NULL THEN Totals.[8/01/2017]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NULL AND Totals.[7/15/2017] IS NOT NULL THEN NULL
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NULL AND Totals.[7/15/2017] IS NULL
				AND Totals.[8/01/2017] IS NOT NULL THEN NULL
		END AS 'SecondPayment'
	, CASE WHEN Totals.[3/15/2017] IS NOT NULL THEN Totals.[3_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NOT NULL THEN Totals.[4_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NOT NULL THEN Totals.[5_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NOT NULL THEN Totals.[6_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NOT NULL THEN Totals.[7_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NOT NULL THEN Totals.[8_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NOT NULL THEN Totals.[9_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NOT NULL THEN Totals.[10_NatRate]
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NULL AND Totals.[7/15/2017] IS NOT NULL THEN NULL
			WHEN Totals.[3/15/2017] IS NULL AND Totals.[4/01/2017] IS NULL AND Totals.[4/15/2017] IS NULL AND Totals.[5/01/2017] IS NULL AND Totals.[5/15/2017] IS NULL AND Totals.[6/01/2017] IS NULL AND Totals.[6/15/2017] IS NULL AND Totals.[7/01/2017] IS NULL AND Totals.[7/15/2017] IS NULL
				AND Totals.[8/01/2017] IS NOT NULL THEN NULL
		END AS 'Second_IsLessThanNationalPricing'

FROM Totals
GO
