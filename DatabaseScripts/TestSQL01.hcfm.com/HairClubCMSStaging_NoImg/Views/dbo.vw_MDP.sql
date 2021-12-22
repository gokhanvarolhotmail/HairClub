/* CreateDate: 12/04/2018 16:40:16.527 , ModifyDate: 12/04/2018 16:41:09.903 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************************************
NOTES: Micro Dermal Pigmentation (Tattoos)
----------------------------------------------------------------------------------------------
SELECT * FROM dbo.[vw_MDP]
*********************************************************************************************/

CREATE VIEW [dbo].[vw_MDP]
AS

WITH Dates AS (SELECT   DD.OrderDate
				FROM	dbo.datSalesOrder  DD
				WHERE    DD.OrderDate BETWEEN DATEADD(yy, -1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) -- First Day of Year - 1 Year Ago
						AND GETDATE() -- Today
),



Area AS (SELECT  CMA.CenterManagementAreaID  MainGroupID
			,		CMA.CenterManagementAreaDescription MainGroup
			,		CMA.CenterManagementAreaSortOrder MainGroupSortOrder
			,		CTR.CenterNumber
			,		CTR.CenterDescriptionFullCalc
			,		CT.CenterTypeDescriptionShort
			FROM    dbo.cfgCenter CTR WITH (NOLOCK)
				INNER JOIN dbo.lkpCenterType CT WITH (NOLOCK)
					ON CT.CenterTypeID = CTR.CenterTypeID
				INNER JOIN dbo.cfgCenterManagementArea CMA WITH (NOLOCK)
					ON CMA.CenterManagementAreaID = CTR.CenterManagementAreaID
			WHERE   CT.CenterTypeDescriptionShort = 'C'
				AND CTR.IsActiveFlag = 1
			UNION
			SELECT  LR.RegionID MainGroupID
            ,     LR.RegionDescription MainGroup
			,	  LR.RegionSortOrder MainGroupSortOrder
            ,     CTR.CenterNumber
            ,     CTR.CenterDescriptionFullCalc
            ,     LCT.CenterTypeDescriptionShort
            FROM    dbo.cfgCenter CTR WITH (NOLOCK)
                            INNER JOIN dbo.lkpCenterType LCT WITH (NOLOCK)
                                ON LCT.CenterTypeID = CTR.CenterTypeID
                            INNER JOIN dbo.lkpRegion LR WITH (NOLOCK)
                                ON LR.RegionID = CTR.RegionID
            WHERE   LCT.CenterTypeDescriptionShort IN ( 'JV', 'F' )
                            AND CTR.IsActiveFlag = 1
)



SELECT  A.MainGroupID
,	    A.MainGroup
,	    A.MainGroupSortOrder
,	    ctr.CenterNumber
,       ctr.CenterDescription
,       so.InvoiceNumber

,		so.OrderDate
,       lb.BrandDescription
,       sc.SalesCodeDescriptionShort
,       sc.SalesCodeDescription

,       sod.ExtendedPriceCalc
,       sod.TotalTaxCalc
,       sod.PriceTaxCalc

FROM    dbo.datSalesOrderDetail sod
		INNER JOIN dbo.datSalesOrder so
            ON so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN Dates
			ON so.OrderDate = Dates.OrderDate
        INNER JOIN dbo.cfgSalesCode sc
            ON sc.SalesCodeID = sod.SalesCodeID
        INNER JOIN dbo.lkpBrand lb
                ON lb.BrandID = sc.BrandID
        INNER JOIN dbo.lkpSalesCodeDepartment scd
            ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
        INNER JOIN dbo.lkpSalesCodeDivision scdv
            ON scdv.SalesCodeDivisionID = scd.SalesCodeDivisionID
        INNER JOIN dbo.cfgCenter ctr
            ON ctr.CenterID = so.CenterID
        INNER JOIN Area A
            ON A.CenterNumber = ctr.CenterNumber

WHERE   lb.BrandDescriptionShort = 'MDP'
        AND so.IsVoidedFlag = 0
GO
