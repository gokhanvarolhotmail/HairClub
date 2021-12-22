/* CreateDate: 01/14/2015 15:37:37.850 , ModifyDate: 06/28/2018 17:20:47.423 */
GO
/*
==============================================================================

PROCEDURE:				[sprpt_XtrFlashDrillDown]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		01/14/2015

==============================================================================
DESCRIPTION:	Xtr Flash Drilldown
==============================================================================
NOTES:
04/29/2015	RH	Added Upgrade from EXT (WO#111709)
06/15/2015	RH	Changed joins for center to ClientMembership center instead of FST.
03/14/2018 - RH - (#145957) Changed CenterSSID to CenterNumber
==============================================================================
SAMPLE EXECUTION:
EXEC sprpt_XtrFlashDrillDown 3, 292, 15, '1/1/2018', '3/31/2018'  --RRXtrServices

EXEC sprpt_XtrFlashDrillDown 3, 203, 1, '3/1/2018', '3/31/2018'  --NBCount

EXEC sprpt_XtrFlashDrillDown 3, 203, 12, '3/1/2018', '3/31/2018' --NB NetCount --Xtrands Count

EXEC sprpt_XtrFlashDrillDown 3, 292, 6, '1/1/2018', '3/31/2018' --RRconv

EXEC sprpt_XtrFlashDrillDown 3, 292, 11, '1/1/2018', '3/31/2018'  --RRcancels

EXEC sprpt_XtrFlashDrillDown 3, 201, 10, '1/1/2018', '3/31/2018'--RRrenewals

EXEC sprpt_XtrFlashDrillDown 2, 9, 16, '1/1/2018', '3/31/2018' --UpgradeFromEXT

***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_XtrFlashDrillDown] (
	@Filter INT
,	@center INT
,	@type INT
,	@StartDate SMALLDATETIME
,	@EndDate SMALLDATETIME

) AS
BEGIN

	--SET FMTONLY OFF
	SET NOCOUNT OFF

/* 	@Filter = 1 for Region, 2 for Area, 3 for Center
	@center is CenterNumber or RegionID (CenterManagementAreaID)

	@Type

	1 = New Business Gross Count
	2 = New Business Sales
	3 = New Business Refunds
	4 = New Business Expirations
	6 = New Business Conversions
	8 = Recurring Revenue Sales
	10 = Recurring Revenue Renewals
	11 = Recurring Revenue Cancels
	12 = New Business Net Count
	15 = Recurring Revenue Xtr Services
	16 = Upgrade from EXT
*/

/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	CenterSSID INT
,	CenterNumber INT
)

CREATE TABLE #Final(
	CtrName	NVARCHAR(50)
			, OrdNo NVARCHAR(50)
			, TransNo NVARCHAR(50)
			, ClientKey INT
			, Client  NVARCHAR(150)
			, [Date] DATETIME
			, MembershipKey NVARCHAR(50)
			, Code NVARCHAR(50)
			, [Description] NVARCHAR(50)
			, Price MONEY
			, Tax MONEY
			, Consultant NVARCHAR(50)
			, Stylist NVARCHAR(50)
			, NBcount INT
			, NBcountnet INT
			, NBsales MONEY
			, NBrefunds INT
			, NBconversions INT
			, RRsales MONEY
			, RRcancels INT
			, XtrCancelDate DATETIME
			, RRrenewals INT
			, XtrRenewDate DATETIME
			, RRXtrServices INT
			, UpgFromEXT INT
			,	FirstRank INT
	)


/********************************** Get list of centers *************************************/
IF @Filter = 1										-- A Franchise Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
				,	DC.CenterNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   DC.RegionSSID = @Center
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ('F','JV')
	END
ELSE
	IF @Filter = 2									-- An Area Manager has been selected
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT DC.CenterSSID
		,	DC.CenterNumber
		FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   CMA.CenterManagementAreaSSID = @Center
				AND CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN('C')
	END
ELSE
IF @Filter = 3 									-- A Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
				,	DC.CenterNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   DC.CenterNumber = @Center
				AND DC.Active = 'Y'

	END


/********************************** Get Xtrands Renewals *************************************/

-- Get Renewals
SELECT  FST.ClientKey
	,	1 AS 'RRrenewals'
	,	DD.FullDate AS 'XtrRenewDate'
	,	FST.MembershipKey
INTO #Renewals
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON FST.OrderDateKey = dd.DateKey
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON FST.CenterKey = CTR.CenterKey
INNER JOIN #Centers
	ON #Centers.CenterNumber = CTR.CenterNumber
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
	ON FST.SalesCodeKey = DSC.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
	ON FST.SalesOrderKey = DSO.SalesOrderKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
	ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
	ON DSO.ClientMembershipKey = DCM.ClientMembershipKey --Change FST to DSO
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
	ON DCM.MembershipSSID = M.MembershipSSID
WHERE DSC.SalesCodeDepartmentSSID = 1090  --Renewals
AND M.MembershipSSID IN(SELECT MembershipSSID FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
							WHERE RevenueGroupSSID = 2 AND BusinessSegmentSSID = 6)
AND DD.FullDate BETWEEN @StartDate AND @EndDate
GROUP BY FST.ClientKey
	,	DD.FullDate
	,	FST.MembershipKey

/********************************** Get Xtrands Cancellations *************************************/

SELECT  FST.ClientKey
	,	1 AS 'RRcancels'
	,	DD.FullDate AS 'XtrCancelDate'
	,	FST.MembershipKey
INTO #Cancels
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		ON FST.CenterKey = CTR.CenterKey
	INNER JOIN #Centers
		ON #Centers.CenterNumber = CTR.CenterNumber
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
		ON FST.SalesCodeKey = DSC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
		ON FST.SalesOrderKey = DSO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		ON DSO.ClientMembershipKey = DCM.ClientMembershipKey --Change FST to DSO
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON DCM.MembershipSSID = M.MembershipSSID
WHERE DSC.SalesCodeDepartmentSSID = 1099  --Cancellations
	AND M.MembershipSSID IN(SELECT MembershipSSID FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
							WHERE RevenueGroupSSID = 2 AND BusinessSegmentSSID = 6)
	AND DD.FullDate BETWEEN @StartDate AND @EndDate
GROUP BY FST.ClientKey
	,	DD.FullDate
	,	FST.MembershipKey


/********************************** Get Sales data *************************************/

SELECT C.CenterDescriptionNumber AS 'CtrName'
,	DSO.TicketNumber_Temp As 'OrdNo'
,	CASE WHEN SOD.TransactionNumber_Temp = -1 THEN CONVERT(VARCHAR, SOD.SalesOrderDetailKey) ELSE CONVERT(VARCHAR, SOD.TransactionNumber_Temp) END AS 'TransNo'
,	CLT.ClientKey
,	CAST(CLT.ClientIdentifier As VARCHAR(20)) + ' - ' + CLT.ClientFullName As 'Client'
,	DSO.OrderDate As 'Date'
,	FST.MembershipKey
,	SC.SalesCodeDescriptionShort As 'Code'
,	m.MembershipDescription As 'Description'
,	FST.ExtendedPrice As 'Price'
,	FST.tax1 As 'Tax'
,	E_Con.EmployeeInitials As 'Consultant'
,	E_Sty.EmployeeInitials As 'Stylist'
,	FST.NB_GrossNB1Cnt AS 'NBcount'
,	FST.NB_XtrCnt AS 'NBcountnet'
,	FST.NB_XtrAmt AS 'NBsales'
,	CASE WHEN FST.NB_XtrAmt < 0 THEN FST.NB_XtrAmt ELSE 0 END AS 'NBrefunds'
,	FST.NB_XtrConvCnt AS 'NBconversions'
,	FST.PCP_XtrAmt AS 'RRsales'
,	NULL AS 'RRcancels'
,	NULL AS 'XtrCancelDate'
,	NULL AS 'RRrenewals'
,	NULL AS 'XtrRenewDate'
,	CASE WHEN SC.SalesCodeDepartmentSSID IN (5038) THEN 1 ELSE 0 END AS 'RRXtrServices'
,	CASE WHEN SC.SalesCodeSSID IN (787) AND SC.SalesCodeDepartmentSSID = 1070 THEN 1 ELSE 0 END AS 'UpgFromEXT'
,	NULL AS FirstRank
INTO #subFinal
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON fst.SalesCodeKey = sc.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
		ON FST.SalesOrderKey = DSO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON DSO.ClientMembershipKey = CM.ClientMembershipKey --Change FST to SO
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON CM.MembershipSSID = M.MembershipSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON CM.CenterKey = C.CenterKey  --Change FST to CM
	INNER JOIN #Centers
		ON #Centers.CenterNumber = C.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON C.CenterTypeKey = CT.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
		ON C.RegionKey = r.RegionKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Con
		ON FST.Employee1Key = E_Con.EmployeeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Sty
		ON FST.Employee2Key = E_Sty.EmployeeKey
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	AND (
		FST.NB_GrossNB1Cnt <> 0
		OR FST.NB_XtrCnt <> 0
		OR FST.NB_XtrAmt <> 0
		OR CASE WHEN FST.NB_XtrAmt < 0 THEN FST.NB_XtrAmt ELSE 0 END <> 0
		OR FST.NB_XtrConvCnt <> 0
		OR FST.PCP_XtrAmt <> 0
		OR CASE WHEN SC.SalesCodeDepartmentSSID IN (5038) THEN 1 ELSE 0 END <> 0
		OR CASE WHEN SC.SalesCodeSSID IN (787) AND SC.SalesCodeDepartmentSSID = 1070 THEN 1 ELSE 0 END <> 0
		)

GROUP BY C.CenterDescriptionNumber
,	DSO.TicketNumber_Temp
,	SOD.TransactionNumber_Temp
,	SOD.SalesOrderDetailKey
,	SOD.TransactionNumber_Temp
,	CLT.ClientKey
,	CLT.ClientIdentifier
,	CLT.ClientFullName
,	DSO.OrderDate
,	FST.MembershipKey
,	SC.SalesCodeDescriptionShort
,	m.MembershipDescription
,	SC.SalesCodeSSID
,	FST.ExtendedPrice
,	FST.tax1
,	E_Con.EmployeeInitials
,	E_Sty.EmployeeInitials
,	FST.NB_GrossNB1Cnt
,	FST.NB_XtrCnt
,	FST.NB_XtrAmt
,	FST.NB_XtrAmt
,	FST.NB_XtrConvCnt
,	FST.PCP_XtrAmt
,	SC.SalesCodeDepartmentSSID

IF @Type = 11

BEGIN
--Select to rank multiple records and pull the latest one for cancels
INSERT INTO #Final
SELECT CtrName
		, OrdNo
		, TransNo
		,	SF.ClientKey
		, Client
		, [Date]
		, SF.MembershipKey
		, Code
		, [Description]
		, Price
		, Tax
		, Consultant
		, Stylist
		, NBcount
		, NBcountnet
		, NBsales
		, NBrefunds
		, NBconversions
		, RRsales
		, #Cancels.RRcancels
		, #Cancels.XtrCancelDate
		, NULL AS 'RRrenewals'
		, NULL AS 'XtrRenewDate'
		, RRXtrServices
		, UpgFromEXT
		,ROW_NUMBER() OVER(PARTITION BY SF.ClientKey ORDER BY #Cancels.XtrCancelDate DESC) AS FirstRank
		FROM #subFinal SF
			LEFT JOIN #Cancels
				ON SF.ClientKey = #Cancels.ClientKey
GROUP BY CtrName
		, OrdNo
		, TransNo
		, SF.ClientKey
		, Client
		, [Date]
		, SF.MembershipKey
		, Code
		, [Description]
		, Price
		, Tax
		, Consultant
		, Stylist
		, NBcount
		, NBcountnet
		, NBsales
		, NBrefunds
		, NBconversions
		, RRsales
		, #Cancels.RRcancels
		, #Cancels.XtrCancelDate
		, RRXtrServices
		, UpgFromEXT
		,	FirstRank
END
ELSE
IF @type = 10
BEGIN
--Select to rank multiple records and pull the latest one for cancels
INSERT INTO #Final
SELECT CtrName
		, OrdNo
		, TransNo
		, SF.ClientKey
		, Client
		, [Date]
		, SF.MembershipKey
		, Code
		, [Description]
		, Price
		, Tax
		, Consultant
		, Stylist
		, NBcount
		, NBcountnet
		, NBsales
		, NBrefunds
		, NBconversions
		, RRsales
		, NULL AS RRcancels
		, NULL AS ExtCancelDate
		, #Renewals.RRrenewals
		, #Renewals.XtrRenewDate
		, RRXtrServices
		, UpgFromEXT
		,ROW_NUMBER() OVER(PARTITION BY SF.ClientKey ORDER BY #Renewals.XtrRenewDate DESC) AS FirstRank
		FROM #subFinal SF
		LEFT JOIN #Renewals
		ON SF.ClientKey = #Renewals.ClientKey
		GROUP BY CtrName
		, OrdNo
		, TransNo
		, SF.ClientKey
		, Client
		, [Date]
		, SF.MembershipKey
		, Code
		, [Description]
		, Price
		, Tax
		, Consultant
		, Stylist
		, NBcount
		, NBcountnet
		, NBsales
		, NBrefunds
		, NBconversions
		, RRsales
		, #Renewals.RRrenewals
		, #Renewals.XtrRenewDate
		, RRXtrServices
		, UpgFromEXT
		,	FirstRank
END

ELSE
BEGIN
	INSERT INTO #Final
	SELECT CtrName
            , OrdNo
            , TransNo
            , SF.ClientKey
			, Client
            , [Date]
            , SF.MembershipKey
            , Code
            , [Description]
            , Price
            , Tax
            , Consultant
            , Stylist
            , NBcount
            , NBcountnet
            , NBsales
            , NBrefunds
            , NBconversions
            , RRsales
            , NULL AS RRcancels
            , NULL AS XtrCancelDate
            , NULL AS RRrenewals
            , NULL AS XtrRenewDate
            , RRXtrServices
            , UpgFromEXT
			,	NULL AS FirstRank
	FROM #subFinal SF
	GROUP BY CtrName
		, OrdNo
		, TransNo
		, SF.ClientKey
		, Client
		, [Date]
		, SF.MembershipKey
		, Code
		, [Description]
		, Price
		, Tax
		, Consultant
		, Stylist
		, NBcount
		, NBcountnet
		, NBsales
		, NBrefunds
		, NBconversions
		, RRsales
		, RRXtrServices
		, UpgFromEXT
END

--SELECT * FROM #Final

IF @type = 1 --New Business Gross Count
	BEGIN
		SELECT *
		FROM #Final
		WHERE NBcount<>0
		--AND Code IN('INITASG','CONV') --causing the summary and detail to not match
		--AND Price > '0.00'
	END
ELSE IF @type = 12 --New Business Net Count
	BEGIN
		SELECT *
		FROM #Final
		WHERE NBcountnet<>0
	END
ELSE IF @type = 2 --New Business Sales
	BEGIN
		SELECT *
		FROM #Final
		WHERE NBsales<>0
	END
ELSE IF @type = 3 --New Business Refunds
	BEGIN
		SELECT *
		FROM #Final
		WHERE NBrefunds<>0
	END
ELSE IF @type = 6 --New Business Conversions
	BEGIN
		SELECT *
		FROM #Final
		WHERE NBconversions<>0
	END
ELSE IF @type = 8 --Recurring Revenue Sales
	BEGIN
		SELECT *
		FROM #Final
		WHERE RRsales<>0
	END
ELSE IF @type = 10 --Recurring Revenue Renewals
	BEGIN
		SELECT *
		FROM #Final
		WHERE RRrenewals<>0
		AND FirstRank = 1
	END
ELSE IF @type = 11 --Recurring Revenue Cancels
	BEGIN
		SELECT *
		FROM #Final
		WHERE RRcancels<>0
		AND FirstRank = 1
	END
ELSE IF @type = 15 --Recurring Revenue Xtr Services
	BEGIN
		SELECT *
		FROM #Final
		WHERE RRXtrServices<>0
	END
ELSE IF @type = 16 --Upgrade from EXT
	BEGIN
		SELECT *
		FROM #Final
		WHERE UpgFromEXT<>0
	END

END
GO
