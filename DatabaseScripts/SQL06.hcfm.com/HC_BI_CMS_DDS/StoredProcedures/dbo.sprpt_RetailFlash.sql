/* CreateDate: 10/03/2019 23:03:43.177 , ModifyDate: 10/03/2019 23:03:43.177 */
GO
/***********************************************************************

PROCEDURE:				sprpt_RetailFlash	VERSION  1.0

DESTINATION SERVER:		SQL06

DESTINATION DATABASE:	INFOSTORE

RELATED APPLICATION:	Retail Flash - sub report

AUTHOR:					Kevin Murdoch

IMPLEMENTOR:			Kevin Murdoch

DATE IMPLEMENTED:		4/1/2012

LAST REVISION DATE:		4/1/2012

--------------------------------------------------------------------------------------------------------
NOTES:
	3/27/2012	KMurdoch	Initial Creation

--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
sprpt_RetailFlash 'c', '3/1/12', '3/31/12', 0

***********************************************************************/


CREATE   PROCEDURE [dbo].[sprpt_RetailFlash] (
	@sType CHAR(1)
,	@begdt smalldatetime
,	@enddt smalldatetime
,	@ReportType INT
) AS
	SET NOCOUNT ON

	SET @enddt = @enddt + ' 23:59'

	DECLARE @country INT
	SET @country=0
	/*
		@Country
		0 = All
		1 = US
		2 = Canada
	*/

	DECLARE @Sales TABLE (
		[CenterSSID] [int] NULL
	,	[EmployeeID] [int] NULL
	,	[Adhesives$] [money] NULL
	,	[ShampCond$] [money] NULL
	,	[Styling$] [money] NULL
	,	[EXTProd$] [money] NULL
	,	[Kits$] [money] NULL
	,	[LaserComb$] [money] NULL
	,	[Misc$] [money] NULL
	,	[Retail$] [money] NULL
	,	[RetailFree$] [money] NULL
	,	[Service#] [int] NULL
	,	UNIQUE NONCLUSTERED (CENTERSSID, EmployeeID)
	)

	--CREATE INDEX [IX_TMP_CENTER] ON @SALES
	--(EMPLOYEEID)


	INSERT @Sales
	SELECT
			c.CenterSSID
		,	ISNULL(stylist.Identifier,staff.Identifier) AS 'EmployeeID'
		,	SUM(CASE WHEN scd.SalesCodeDepartmentSSID in (3010,3020) THEN t.ExtendedPrice ELSE 0 END) AS 'Adhesives'
		,	SUM(CASE WHEN scd.SalesCodeDepartmentSSID in (3030,3040) THEN t.ExtendedPrice ELSE 0 END) AS 'Shampoo/Cond'
		,	SUM(CASE WHEN scd.SalesCodeDepartmentSSID in (3050) THEN t.ExtendedPrice ELSE 0 END) AS 'Styling'
		,	SUM(CASE WHEN scd.SalesCodeDepartmentSSID in (3060)
				and sc.SalesCodeDescriptionShort not in ('HM3V5','EXTPMTLC','EXTPMTLCP') THEN t.ExtendedPrice ELSE 0 END) AS 'EXT Products'
		,	SUM(CASE WHEN scd.SalesCodeDepartmentSSID in (3070) THEN t.ExtendedPrice ELSE 0 END) AS 'Kits'
		,	SUM(CASE WHEN scd.SalesCodeDepartmentSSID in (3080) THEN t.ExtendedPrice ELSE 0 END) AS 'Misc'
		,	SUM(CASE WHEN sc.SalesCodeDescriptionShort in ('HM3V5','EXTPMTLC','EXTPMTLCP') then t.ExtendedPrice ELSE 0 END) AS 'LaserComb'
		,	SUM(CASE WHEN scd.SalesCodeDivisionSSID = 30 THEN t.ExtendedPrice ELSE 0 END) AS 'Retail'
		,	SUM(CASE WHEN t.ExtendedPrice= 0
				AND scd.SalesCodeDivisionSSID = 30
				AND scd.SalesCodeDepartmentSSID not in (3060) THEN T.Quantity*sc.PriceDefault ELSE 0 END) AS 'RetailFree'
		,	SUM(CASE WHEN scd.SalesCodeDepartmentSSID between 5010 and 5040 THEN 1 ELSE 0 END) AS 'ServicesCt'

	FROM hc_bi_cms_dds.bi_cms_dds.FactSalesTransaction t
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod
			on t.salesorderdetailkey = sod.SalesOrderDetailKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrder so
			on t.salesorderkey = so.SalesOrderKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			on t.CenterKey = c.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
			on c.RegionKey = r.RegionKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc
			on t.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
			on sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
		--INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership clm
		--	on t.ClientMembershipKey = clm.ClientMembershipKey
		--INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership mem
		--	on clm.MembershipKey = mem.MembershipKey
		LEFT OUTER JOIN HC_BI_Reporting.dbo.Employee stylist
			on sod.Performer2_Temp = stylist.Code
				and so.CenterSSID = stylist.Center
		LEFT OUTER JOIN HC_BI_Reporting.dbo.Employee staff
			on sod.Performer_temp = staff.Code
				and so.centerssid = staff.Center
		--LEFT OUTER Join HC_BI_Reporting.dbo.cmspositions StylistPos
		--	on stylist.position = StylistPos.positionID
		--LEFT OUTER Join HC_BI_Reporting.dbo.cmspositions staffPos
		--	on staff.position = staffPos.positionid
	WHERE
			so.CenterSSID like '[278]__'
		AND	(scd.SalesCodeDivisionSSID in (30,50) or sc.SalesCodeDescriptionShort in ('HM3V5','EXTPMTLC','EXTPMTLCP'))
		AND so.OrderDate BETWEEN @begdt AND @enddt
		AND so.IsVoidedFlag = 0
	GROUP BY c.CenterSSID,ISNULL(stylist.Identifier,staff.Identifier)


--SELECT * FROM @Sales

	SELECT [Center].CenterOwnershipSSID
	,	Region.RegionSSID
	,	Region.RegionSortOrder
	,	Region.RegionDescription
	,	CenterDescriptionNumber as 'Center'
	,	ISNULL(EMP.Full_Name, 'Unknown') as 'Employee'
	,	ISNULL([Sales].Retail$,0) AS 'TotalRetail'
	,	ISNULL([Sales].Service#,0) AS 'TotalService#'
	,	ISNULL([Sales].RetailFree$,0) AS 'RetailFree'
	,	[dbo].[DIVIDE](ISNULL([Sales].Retail$,0),ISNULL([Sales].Service#,0)) as 'SalesPerService'
	,	ISNULL([Sales].ShampCond$, 0) AS 'ShampCond'
	,	ISNULL([Sales].Styling$, 0) AS 'Styling'
	,	ISNULL([Sales].Adhesives$, 0) AS 'Adhesives'
	,	ISNULL([Sales].EXTProd$, 0) AS 'EXTProd'
	,	ISNULL([Sales].LaserComb$, 0) AS 'LaserComb'
	,	ISNULL([Sales].Kits$, 0) AS 'Kits'
	,	ISNULL([Sales].Misc$,0) AS 'Miscellaneous'
	,	[Center].CountryRegionDescriptionShort
	,	CASE WHEN @sType = 'C'
			THEN
				CASE WHEN @ReportType=0 THEN
					Region.RegionDescription
				ELSE
					CASE WHEN [Center].CountryRegionDescriptionShort='US' THEN
						CASE Region.RegionDescription
							WHEN 'Southeast Sabers' THEN 'Butler'
							WHEN 'West Coast Rhinos' THEN 'Little'
							WHEN 'Northeast Beasts' THEN 'Craft'
							WHEN 'Central Sting' THEN 'Morgan'
						END
					ELSE 'Unknown' END
				END
			ELSE 'Arditi'
		END AS 'Grouping'
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter Center
		LEFT OUTER JOIN @Sales [Sales]
			ON [Center].CenterSSID=[Sales].CenterSSID
		LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion Region
			ON [Center].RegionKey=Region.RegionKey
		LEFT OUTER JOIN HC_BI_Reporting.dbo.Employee emp
			ON Sales.EmployeeID = EMP.Identifier
	WHERE [Center].CenterSSID LIKE
		CASE @sType
			WHEN 'C' THEN '[2]__'
			WHEN 'F' THEN '[78]__'
		END
		AND [Center].Active = 'Y'
		AND [Center].CountryRegionDescriptionShort LIKE
			CASE @country
				WHEN 0 THEN '[UC]%'
				WHEN 1 THEN 'U%'
				WHEN 2 THEN 'C%'
			END
	ORDER BY [Region].RegionSortOrder,[Center].CenterSSID,EMP.Full_Name


	----select * from @Sales
GO
