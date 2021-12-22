/***********************************************************************
PROCEDURE:				spRpt_FlashRecurringBusinessDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB2 Flash Details
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
------------------------------------------------------------------------
CHANGE HISTORY:
10/08/2013 - DL - (#89184) Added Group By Region/RSM filter
10/15/2013 - DL - (#89184) Added @Filter procedure parameter
10/15/2013 - DL - (#89184) Added additional RSM roll-up filters
10/19/2013 - DL - Removed the following line from the procedure: SET @enddt = @enddt + ' 23:59:59'
11/04/2013 - DL - (#93429) Used the @Type parameter to use a separate query for Retail Data.
				  Main query joined from FactSalesTransactions --> DimClientMembership --> DimCenter.
				  Retail query joined from FactSalesTransactions --> DimCenter.
04/03/2014 - DL - Changed query to output ClientIdentifier instead of ClientKey
04/07/2014 - RH - (#100145) Changed WHERE DR.RegionSSID = @CenterSSID to WHERE DC.RegionSSID = @CenterSSID
					(under Region code for #Center)
11/25/2014 - RH - (#108216) Added 28 = XTR Conversions, 7 = XTR sales
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
08/03/2016 - DL - (#127248) Added membership description to the output table and query
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID
04/14/2017 - RH - (#137105) Changed logic for finding Area centers to use DimCenterManagementArea
01/12/2018 - RH - (#145957) Added join on CenterType and removed Corporate Regions
03/13/2019 - RH - (Case 8228) Changed CenterSSID to CenterNumber
05/20/2019 - JL - (Case 4824) Added drill down to report

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_FlashRecurringBusinessDetails 6, '01/01/2019', '01/31/2019', 22, 1
EXEC spRpt_FlashRecurringBusinessDetails 14, '10/01/2019', '10/31/2019', 10, 2
EXEC spRpt_FlashRecurringBusinessDetails 238, '01/01/2019', '01/31/2019', 13, 3
EXEC spRpt_FlashRecurringBusinessDetails 804, '01/01/2019', '01/31/2019',12, 3

EXEC spRpt_FlashRecurringBusinessDetails 804, '01/01/2019', '01/31/2019',12, 3

EXEC spRpt_FlashRecurringBusinessDetails 24, '10/01/2019', '10/9/2019', 14, 2
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FlashRecurringBusinessDetails]
(
	@CenterSSID INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@Type INT
,	@Filter INT
)
AS
BEGIN
	--SET FMTONLY OFF
	SET NOCOUNT OFF



	/*
		@Type = Flash Heading

		12 = PCP $
		13 = PCP & Non Program $
		14 = Service $
		15 = Retail $
		22 = Upgrades
		23 = Downgrades
		24 = Cancels
		25 = XTR+ Conversions
		26 = EXT Conversions
		28 = XTR Conversions
		10 = Net Nb1 Apps
		6  = Ext sales
		7  = XTR sales
		27 = NB1 Removals
		36 = EXT Expirations	--This calls the stored procedure spRpt_FlashRecurringBusinessDetailsExpirations
	*/


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	CenterNumber INT
)

CREATE TABLE #Output (
	center INT
,	center_name VARCHAR(50)
,	Region VARCHAR(255)
,	RegionID INT
,	client_no INT
,	ClientMembershipSSID UNIQUEIDENTIFIER
,	MembershipDescription NVARCHAR(50)
,	last_name VARCHAR(255)
,	first_name VARCHAR(255)
,	transact_no INT
,	ticket_no INT
,	date DATETIME
,	code VARCHAR(50)
,	description VARCHAR(50)
,	department INT
,	qty INT
,	Price MONEY
,	tax_1 MONEY
,	tax_2 MONEY
,	performer VARCHAR(50)
,	stylist VARCHAR(50)
,	CancelReasonID INT
,	CancelReasonDescription VARCHAR(500)
,	voided BIT
,	PCP_PCPAmt MONEY
,	PCP_NB2Amt MONEY
,	ServiceAmt MONEY
,	RetailAmt MONEY
,	NB_BIOConvCnt INT
,	NB_ExtConvCnt INT
,	NB_XTRConvCnt INT
,	NB_AppsCnt INT
,	NB_ExtCnt INT
,	NB_XTRCnt INT
,	Upgrades INT
,	Downgrades INT
,	Cancels INT
,	Removals INT

--,   PCP_LaserCnt INT
--,   PCP_LaserAmt INT
)

/********************************** Get list of centers *************************************/
IF @Filter = 3 -- A Center has been selected.
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT
			DC.CenterNumber
	FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
	WHERE   DC.CenterNumber = @CenterSSID
			AND DC.Active = 'Y'
END
ELSE IF @Filter = 1 -- A Region has been selected. Franchise only
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT
			DC.CenterNumber
	FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
				ON DC.RegionSSID = DR.RegionSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE   (DC.RegionSSID = @CenterSSID OR @CenterSSID = 0)
			AND DC.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN('F','JV')
END

ELSE IF (@Filter = 4 AND @CenterSSID = 355)
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT CTR.CenterNumber
	FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = CTR.CenterTypeKey
	WHERE   CMA.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN('HW')
END


ELSE IF (@Filter = 4 AND @CenterSSID <> 355)
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT CTR.CenterNumber
	FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = CTR.CenterTypeKey
	WHERE   CMA.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN('C')
END

ELSE -- An Area Manager has been selected
BEGIN
		IF @Filter = 2
		BEGIN
			INSERT INTO #Centers
			SELECT DISTINCT CTR.CenterNumber
			FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			WHERE   (CMA.CenterManagementAreaSSID = @CenterSSID OR @CenterSSID = 0)
					AND CMA.Active = 'Y'
					AND (CenterSSID not in (1087, 341))
		END
END



/****************** Select by @Type **************************************************************/

	IF @Type=15
	BEGIN
		INSERT INTO #Output
		SELECT C.CenterNumber AS 'center'
		,	C.CenterDescription AS 'center_name'
		,	CASE WHEN @Filter = 1 THEN R.RegionDescription
				WHEN @Filter = 3 AND C.CenterTypeKey IN(3,4) THEN R.RegionDescription
					ELSE CMA.CenterManagementAreaDescription END AS 'Region'
		--,	R.RegionSSID AS 'RegionID'
		,	CASE WHEN @Filter = 1 THEN R.RegionSSID
				WHEN @Filter = 3 AND C.CenterTypeKey IN(3,4) THEN R.RegionSSID
					ELSE CMA.CenterManagementAreaSSID END AS 'RegionID'
		,	CLT.ClientIdentifier AS 'client_no'
		,	CM.ClientMembershipSSID
		,	m.MembershipDescription
		,	CLT.ClientLastName AS 'last_name'
		,	CLT.ClientFirstName AS 'first_name'
		,	FST.SalesOrderDetailKey AS 'transact_no'
		,	FST.SalesOrderKey AS 'ticket_no'
		,	DD.FullDate AS 'date'
		,	SC.SalesCodeDescriptionShort AS 'code'
		,	SC.SalesCodeDescription AS 'description'
		,	SC.SalesCodeDepartmentKey AS 'department'
		,	FST.Quantity AS 'qty'
		,	CASE WHEN @Type IN (22, 23) THEN CM.ClientMembershipMonthlyFee ELSE FST.ExtendedPrice END AS 'Price'
		,	FST.Tax1 AS 'tax_1'
		,	FST.Tax2 AS 'tax_2'
		,	E.EmployeeInitials AS 'performer'
		,	E2.EmployeeInitials AS 'stylist'
		,	SOD.CancelReasonID
		,	'' AS 'CancelReasonDescription'
		,	SO.IsVoidedFlag AS 'voided'
		,	CASE WHEN ISNULL(FST.PCP_PCPAmt, 0) <> 0 THEN 1 ELSE 0 END AS 'PCP_PCPAmt'
		,	CASE WHEN ISNULL(FST.PCP_NB2Amt, 0) <> 0 THEN 1 ELSE 0 END AS 'PCP_NB2Amt'
		,	CASE WHEN ISNULL(FST.ServiceAmt, 0) <> 0 THEN 1 ELSE 0 END AS 'ServiceAmt'
		,	CASE WHEN ISNULL(FST.RetailAmt, 0) <> 0 THEN 1 ELSE 0 END AS 'RetailAmt'
		,	CASE WHEN ISNULL(FST.NB_BIOConvCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_BIOConvCnt'
		,	CASE WHEN ISNULL(FST.NB_ExtConvCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_ExtConvCnt'
		,	CASE WHEN ISNULL(FST.NB_XTRConvCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_XTRConvCnt'  --Added 11/25/2014 RH
		,	CASE WHEN ISNULL(FST.NB_AppsCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_AppsCnt'
		,	CASE WHEN ISNULL(FST.NB_ExtCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_ExtCnt'
		,	CASE WHEN ISNULL(FST.NB_XTRCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_XTRCnt'  --Added 11/25/2014 RH
		,	CASE WHEN SC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END AS 'Upgrades'
		,	CASE WHEN SC.SalesCodeDepartmentSSID IN (1080) THEN 1 ELSE 0 END AS 'Downgrades'
		,	CASE WHEN SC.SalesCodeDepartmentSSID IN (1099)
				AND M.RevenueGroupDescriptionShort='PCP' THEN 1 ELSE 0 END
			AS 'Cancels'
		,	CASE WHEN SC.SalesCodeSSID IN (399) THEN 1 ELSE 0 END AS 'Removals'

		--,	CASE WHEN ISNULL(FST.PCP_LaserCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'PCP_LaserCnt'
		--,	CASE WHEN ISNULL(FST.PCP_LaserAmt, 0) <> 0 THEN 1 ELSE 0 END AS 'PCP_LaserAmt'

		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = dd.DateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
				ON FST.ClientMembershipKey = cm.ClientMembershipKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FST.CenterKey = c.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON fst.SalesCodeKey = sc.SalesCodeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON C.CenterTypeKey = CT.CenterTypeKey
			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
				ON C.RegionKey = r.RegionKey
			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON C.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
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
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
				ON cm.MembershipSSID = m.MembershipSSID
			INNER JOIN #Centers
				ON C.CenterNumber = #Centers.CenterNumber
		WHERE DD.FullDate BETWEEN @StartDate AND @EndDate

	END
	ELSE
	BEGIN
		INSERT INTO #Output
		SELECT C.CenterNumber AS 'center'
		,	C.CenterDescription AS 'center_name'
		,	CASE WHEN @Filter = 1 THEN R.RegionDescription
				WHEN @Filter = 3 AND C.CenterTypeKey IN(3,4) THEN R.RegionDescription
					ELSE CMA.CenterManagementAreaDescription END AS 'Region'
		,	CASE WHEN @Filter = 1 THEN R.RegionSSID
				WHEN @Filter = 3 AND C.CenterTypeKey IN(3,4) THEN R.RegionSSID
					ELSE CMA.CenterManagementAreaSSID END AS 'RegionID'
		,	CLT.ClientIdentifier AS 'client_no'
		,	CM.ClientMembershipSSID
		,	m.MembershipDescription
		,	CLT.ClientLastName AS 'last_name'
		,	CLT.ClientFirstName AS 'first_name'
		,	FST.SalesOrderDetailKey AS 'transact_no'
		,	FST.SalesOrderKey AS 'ticket_no'
		,	DD.FullDate AS 'date'
		,	SC.SalesCodeDescriptionShort AS 'code'
		,	SC.SalesCodeDescription AS 'description'
		,	SC.SalesCodeDepartmentKey AS 'department'
		,	FST.Quantity AS 'qty'
		,	CASE WHEN @Type IN (22, 23) THEN CM.ClientMembershipMonthlyFee ELSE FST.ExtendedPrice END AS 'Price'
		,	FST.Tax1 AS 'tax_1'
		,	FST.Tax2 AS 'tax_2'
		,	E.EmployeeInitials AS 'performer'
		,	E2.EmployeeInitials AS 'stylist'
		,	SOD.CancelReasonID
		,	'' AS 'CancelReasonDescription'
		,	SO.IsVoidedFlag AS 'voided'
		,	CASE WHEN ISNULL(FST.PCP_PCPAmt, 0) <> 0 THEN 1 ELSE 0 END AS 'PCP_PCPAmt'
		,	CASE WHEN ISNULL(FST.PCP_NB2Amt, 0) <> 0 THEN 1 ELSE 0 END AS 'PCP_NB2Amt'
		,	CASE WHEN ISNULL(FST.ServiceAmt, 0) <> 0 THEN 1 ELSE 0 END AS 'ServiceAmt'
		,	CASE WHEN ISNULL(FST.RetailAmt, 0) <> 0 THEN 1 ELSE 0 END AS 'RetailAmt'
		,	CASE WHEN ISNULL(FST.NB_BIOConvCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_BIOConvCnt'
		,	CASE WHEN ISNULL(FST.NB_ExtConvCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_ExtConvCnt'
		,	CASE WHEN ISNULL(FST.NB_XTRConvCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_XTRConvCnt' --Added 11/25/2014 RH
		,	CASE WHEN ISNULL(FST.NB_AppsCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_AppsCnt'
		,	CASE WHEN ISNULL(FST.NB_ExtCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_ExtCnt'
		,	CASE WHEN ISNULL(FST.NB_XTRCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'NB_XTRCnt' --Added 11/25/2014 RH
		,	CASE WHEN SC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END AS 'Upgrades'
		,	CASE WHEN SC.SalesCodeDepartmentSSID IN (1080) THEN 1 ELSE 0 END AS 'Downgrades'
		,	CASE WHEN SC.SalesCodeDepartmentSSID IN (1099)
				AND M.RevenueGroupDescriptionShort='PCP' THEN 1 ELSE 0 END
			AS 'Cancels'
		,	CASE WHEN SC.SalesCodeSSID IN (399) THEN 1 ELSE 0 END AS 'Removals'

		--,	CASE WHEN ISNULL(FST.PCP_LaserCnt, 0) <> 0 THEN 1 ELSE 0 END AS 'PCP_LaserCnt'
		--,	CASE WHEN ISNULL(FST.PCP_LaserAmt, 0) <> 0 THEN 1 ELSE 0 END AS 'PCP_LaserAmt'

		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = dd.DateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
				ON FST.ClientMembershipKey = cm.ClientMembershipKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON cm.CenterKey = c.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON fst.SalesCodeKey = sc.SalesCodeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON C.CenterTypeKey = CT.CenterTypeKey
			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
				ON C.RegionKey = r.RegionKey
			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON C.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
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
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
				ON cm.MembershipSSID = m.MembershipSSID
			INNER JOIN #Centers
				ON C.CenterNumber = #Centers.CenterNumber
		WHERE DD.FullDate BETWEEN @StartDate AND @EndDate

	END



	IF @Type=12 --PCP $
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE PCP_PCPAmt=1
		END
	ELSE IF @Type=13 --PCP & Non Program $
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE PCP_NB2Amt=1
		END
	ELSE IF @Type=14 --Service $
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE ServiceAmt=1
		END
	ELSE IF @Type=15 --Retail $
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE RetailAmt=1
		END
	ELSE IF @Type=22 --Upgrades
		BEGIN
			SELECT *
			,	ISNULL(dbo.fxMembershipChangeDetails(ClientMembershipSSID, ticket_no), '') AS 'MembershipChange'
			FROM #Output
			WHERE Upgrades=1
		END
	ELSE IF @Type=23 --Downgrades
		BEGIN
			SELECT *
			,	ISNULL(dbo.fxMembershipChangeDetails(ClientMembershipSSID, ticket_no), '') AS 'MembershipChange'
			FROM #Output
			WHERE Downgrades=1
		END
	ELSE IF @Type=24 --Cancels
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE Cancels=1
		END
	ELSE IF @Type=25 --BIO Conversions
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE NB_BIOConvCnt=1
		END
	ELSE IF @Type=26 --EXT Conversions
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE NB_ExtConvCnt=1
		END
	ELSE IF @Type=28 --XTR Conversions  --Added 11/25/2014 RH
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE NB_XTRConvCnt=1
		END
	ELSE IF @Type=10 --Net Nb1 Apps
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE NB_AppsCnt=1
		END
	ELSE IF @Type=6 --Ext sales
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE NB_ExtCnt=1
		END
	ELSE IF @Type=7 --XTR sales  --Added 11/25/2014 RH
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE NB_XTRCnt=1
		END
	ELSE IF @Type=27 --NB1 Removals
		BEGIN
			SELECT *
			,	'' AS 'MembershipChange'
			FROM #Output
			WHERE Removals=1
		END

	--ELSE IF @Type=32 --Laser
	--	BEGIN
	--		SELECT *
	--		,	'' AS 'MembershipChange'
	--		FROM #Output
	--		WHERE PCP_LaserCnt=1
	--	END

END
