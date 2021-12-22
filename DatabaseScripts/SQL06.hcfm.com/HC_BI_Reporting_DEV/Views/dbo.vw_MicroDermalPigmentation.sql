/***********************************************************************
VIEW:					vw_MicroDermalPigmentation
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR:			Rachelen Hut
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM dbo.vw_MicroDermalPigmentation
***********************************************************************/
CREATE VIEW [dbo].[vw_MicroDermalPigmentation]
AS

WITH Dates AS (SELECT   DD.OrderDate
				FROM	HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DD
				WHERE    DD.OrderDate BETWEEN DATEADD(yy, -1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 1 Year Ago
						AND GETDATE() -- Today
),



Area AS (SELECT  CMA.CenterManagementAreaSSID  MainGroupID
			,		CMA.CenterManagementAreaDescription MainGroup
			,		CMA.CenterManagementAreaSortOrder MainGroupSortOrder
			,		CTR.CenterNumber
			,		CTR.CenterDescriptionNumber
			,		CT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR WITH (NOLOCK)
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT WITH (NOLOCK)
					ON CT.CenterTypeSSID = CTR.CenterTypeSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA WITH (NOLOCK)
					ON CMA.CenterManagementAreaSSID = CTR.CenterManagementAreaSSID
			WHERE   CT.CenterTypeDescriptionShort = 'C'
				AND CTR.Active = 'Y'
			UNION
			SELECT  R.RegionSSID MainGroupID
            ,     R.RegionDescription MainGroup
			,	  R.RegionSortOrder MainGroupSortOrder
            ,     CTR.CenterNumber
            ,     CTR.CenterDescriptionNumber
            ,     CT.CenterTypeDescriptionShort
            FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR WITH (NOLOCK)
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT WITH (NOLOCK)
					ON CT.CenterTypeSSID = CTR.CenterTypeSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R WITH (NOLOCK)
					ON CTR.RegionKey = R.RegionKey
            WHERE   CT.CenterTypeDescriptionShort IN ( 'JV', 'F' )
                            AND CTR.Active = 'Y'
)
SELECT  A.MainGroupID
				,	    A.MainGroup
				,	    A.MainGroupSortOrder
				,	    A.CenterNumber
				,       A.CenterDescriptionNumber
				,       so.InvoiceNumber

				,		so.OrderDate
				,       sc.SalesCodeDescriptionShort
				,       sc.SalesCodeDescription

				,       sod.ExtendedPriceCalc
				,       sod.TotalTaxCalc
				,       sod.PriceTaxCalc

				,		dc.ClientFirstName
				,		dc.ClientLastName


				FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod
							ON FST.SalesOrderDetailKey = sod.SalesOrderDetailKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
							ON so.SalesOrderKey = sod.SalesOrderKey
						INNER JOIN Dates
							ON so.OrderDate = Dates.OrderDate
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
							ON sod.SalesCodeSSID = sc.SalesCodeSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
							ON CTR.CenterKey = FST.CenterKey
						INNER JOIN Area A
							ON A.CenterNumber = ctr.CenterNumber
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient dc
							ON dc.ClientSSID = so.ClientSSID

				WHERE   sc.SalesCodeDescription LIKE 'MDP%'
						AND so.IsVoidedFlag = 0
