/*
==============================================================================

PROCEDURE:				spRpt_WarBoardMembershipChangeDetails

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		08/02/2012

==============================================================================
DESCRIPTION:	New Business War Board
==============================================================================
NOTES:	07/13/2018 - JL - (#149913) Replaced Corporate Regions with Areas, Changed CenterSSID to CenterNumber
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardMembershipChangeDetails] 6, 2018, 9
EXEC [spRpt_WarBoardMembershipChangeDetails] 6, 2018, 238
EXEC [spRpt_WarBoardMembershipChangeDetails] 6, 2018, 825
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_WarBoardMembershipChangeDetails] (
	@Month INT
,	@Year INT
,	@Center	INT)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @StartDate DATETIME
	,	@EndDate DATETIME

	SET @StartDate = CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)
	SET @EndDate = DATEADD(dd, -1, DATEADD(mm, 1, @StartDate))

	CREATE TABLE #Centers (
		CenterMembers INT
	,	CenterDescriptionNumber VARCHAR(50)
	,	RegionDescription VARCHAR(50)
	,	RegionSSID INT
	,   CenterNumber INT
	)


/***************************************************************************
	SELECT
	CMA.CenterManagementAreaDescription as 'RegionDescription'
,   CMA.CenterManagementAreaSSID as 'RegionSSID'

	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON	CT.CenterTypeKey = C.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
            ON C.CenterManagementAreaSSID = CMA. CenterManagementAreaSSID
	WHERE	CT.CenterTypeDescriptionShort IN('C')
			AND C.Active = 'Y'
	GROUP BY
	CMA.CenterManagementAreaDescription
,   CMA.CenterManagementAreaSSID

			SELECT DISTINCT c.ReportingCenterSSID
			,	c.CenterDescriptionNumber
			,	r.RegionDescription
			,	r.RegionSSID
			,   c.CenterTypeKey
			,   CenterTypeDescriptionShort
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON c.RegionSSID = r.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
					ON c.CenterTypeKey = t.CenterTypeKey
			WHERE c.CenterSSID = @Center
				AND c.Active='Y'

**********************************************/


	IF @Center>200 --Actual center was selected
		BEGIN
			INSERT INTO #Centers
			SELECT DISTINCT c.CenterNumber
			,	c.CenterDescriptionNumber
			,   CASE WHEN CenterTypeDescriptionShort = 'C' THEN CMA.CenterManagementAreaDescription else r.RegionDescription end
			,   CASE WHEN CenterTypeDescriptionShort = 'C' THEN CMA.CenterManagementAreaSSID  else r.RegionSSID end
			,  c.CenterNumber
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON c.RegionSSID = r.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
					ON c.CenterTypeKey = t.CenterTypeKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
		            ON C.CenterManagementAreaSSID = CMA. CenterManagementAreaSSID
			WHERE --c.CenterSSID = @Center
			    c.CenterNumber = @Center
				AND c.Active='Y'
				AND t.CenterTypeDescriptionShort NOT IN('HW') --exclude Hans Wiemann

		END
	ELSE IF @Center BETWEEN 1 AND 200      --Region was selected
		BEGIN
			INSERT INTO #Centers
			SELECT DISTINCT c.ReportingCenterSSID
			,	c.CenterDescriptionNumber
			--,	r.RegionDescription
			--,	r.RegionSSID
			--,   CMA.CenterManagementAreaDescription
			--,   CMA.CenterManagementAreaSSID
			,   CASE WHEN CenterTypeDescriptionShort = 'C' THEN CMA.CenterManagementAreaDescription else r.RegionDescription end
			,   CASE WHEN CenterTypeDescriptionShort = 'C' THEN CMA.CenterManagementAreaSSID  else r.RegionSSID end
			,   c.CenterNumber
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON c.RegionSSID = r.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
					ON c.CenterTypeKey = t.CenterTypeKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
		            ON C.CenterManagementAreaSSID = CMA. CenterManagementAreaSSID
			WHERE
			    --r.RegionSSID = @Center
				CMA.CenterManagementAreaSSID =  @Center
				AND c.Active='Y'
				AND t.CenterTypeDescriptionShort NOT IN('HW') --exclude Hans Wiemann
		END


	ELSE IF @Center=0 --Region was selected
		BEGIN
			INSERT INTO #Centers
			SELECT DISTINCT c.ReportingCenterSSID
			,	c.CenterDescriptionNumber
			,   CMA.CenterManagementAreaDescription
			,   CMA.CenterManagementAreaSSID
			--,	r.RegionDescription
			--,	r.RegionSSID
			,  c.CenterNumber
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				--INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
				--	ON c.RegionSSID = r.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
					ON c.CenterTypeKey = t.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
		            ON C.CenterManagementAreaSSID = CMA. CenterManagementAreaSSID
			WHERE	t.CenterTypeDescriptionShort IN('C')
					AND C.Active = 'Y'
--			WHERE c.CenterSSID LIKE '[2]%'
--				AND c.Active='Y'
		END



	SELECT --c.ReportingCenterSSID AS 'CenterSSID'
	  c.CenterNumber
	,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END) AS 'Upgrades'
	,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1080) THEN 1 ELSE 0 END) AS 'Downgrades'
	INTO #Change
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Centers
--			ON C.ReportingCenterSSID = #Centers.CenterSSID
            ON c.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipSSID = m.MembershipSSID
--		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
--			ON C.CenterTypeKey = CT.CenterTypeKey
--		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
--			ON C.RegionKey = r.RegionKey
	WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeDepartmentSSID IN (1070, 1080)
	GROUP BY c.CenterNumber
	--c.ReportingCenterSSID


	SELECT
	C.CenterNumber AS 'center'
	--C.ReportingCenterSSID AS 'center'
	,	C.CenterDescription AS 'CenterName'
	,	#Centers.RegionDescription AS 'Region'
	,	#Centers.RegionSSID AS 'RegionID'
	,	CLT.ClientKey AS 'client_no'
	,	CM.ClientMembershipSSID
	,	CLT.ClientLastName AS 'last_name'
	,	CLT.ClientFirstName AS 'first_name'
	,	CONVERT(VARCHAR, CM.ClientKey) + ' - ' + CLT.ClientFullName AS 'ClientName'
	,	FST.SalesOrderDetailKey AS 'transact_no'
	,	FST.SalesOrderKey AS 'ticket_no'
	,	DD.FullDate AS 'date'
	,	SC.SalesCodeDescription AS 'code'
	,	SC.SalesCodeDepartmentKey AS 'department'
	,	FST.Quantity AS 'qty'
	,	FST.Price
	,	FST.Tax1 AS 'tax_1'
	,	FST.Tax2 AS 'tax_2'
	,	E.EmployeeInitials AS 'performer'
	,	SOD.CancelReasonID
	,	'' AS 'CancelReasonDescription'
	,	SO.IsVoidedFlag AS 'voided'
	,	CASE WHEN SC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END AS 'UpgradeCount'
	,	CASE WHEN SC.SalesCodeDepartmentSSID IN (1080) THEN 1 ELSE 0 END AS 'DowngradeCount'
	,	ISNULL(dbo.fxMembershipChangeDetails(CM.ClientMembershipSSID, FST.SalesOrderKey), '') AS 'MembershipChange'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON C.CenterTypeKey = CT.CenterTypeKey
--		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
--			ON C.RegionKey = r.RegionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee1Key = E.EmployeeKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
			ON FST.Employee2Key = E2.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON SO.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipSSID = m.MembershipSSID
		INNER JOIN #Centers
			--ON C.ReportingCenterSSID = #Centers.CenterSSID
			  ON C.CenterNumber = #Centers.CenterNumber
	WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeDepartmentSSID IN (1070, 1080)
END
