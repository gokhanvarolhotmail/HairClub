/* CreateDate: 09/18/2012 17:21:42.690 , ModifyDate: 03/07/2018 15:54:46.557 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[sprpt_ExtFlashDrillDown]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		01/14/2015

==============================================================================
DESCRIPTION:	Ext Flash Drilldown
==============================================================================
NOTES:
@Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
==============================================================================
CHANGE HISTORY:
04/29/2015 - RH - Added Upgrade from EXT (#111709)
06/12/2015 - RH - Changed to match the XTR Drill down version
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
01/05/2017 - RH - (#132688) Added @Filter to the sub-report for Area Managers
03/07/2018 - RH - (#145957) Changed CenterSSID to CenterNumber
==============================================================================
SAMPLE EXECUTION:
EXEC sprpt_ExtFlashDrillDown 6, 15, '5/1/2015', '5/31/2015',1  --RRExtServices

EXEC sprpt_ExtFlashDrillDown 6, 1, '5/1/2015', '5/31/2015',1  --NBCount

EXEC sprpt_ExtFlashDrillDown 7, 2, '5/1/2015', '5/31/2015',2  --New Business Sales

EXEC sprpt_ExtFlashDrillDown 9, 6, '5/1/2015', '5/31/2015',2 --RRconv

EXEC sprpt_ExtFlashDrillDown 3, 8, '5/1/2015', '5/31/2015',2 --Recurring Revenue Sales

EXEC sprpt_ExtFlashDrillDown 292, 11, '5/1/2015', '5/31/2015',3  --RRcancels

EXEC sprpt_ExtFlashDrillDown 201, 10, '5/1/2015', '5/31/2015',3 --RRrenewals

EXEC sprpt_ExtFlashDrillDown 238, 12, '3/1/2018', '3/31/2018',3 --NB NetCount

***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_ExtFlashDrillDown] (
	@CenterSSID INT
,	@type INT
,	@begdt DATETIME
,	@enddt DATETIME
,	@Filter INT

) AS
BEGIN

--SET FMTONLY OFF
SET NOCOUNT OFF


	/*
		@type

		1 = New Business Gross Count
		2 = New Business Sales
		3 = New Business Refunds
		4 = New Business Expirations
		6 = New Business Conversions
		8 = Recurring Revenue Sales
		10 = Recurring Revenue Renewals
		11 = Recurring Revenue Cancels
		12 = New Business Net Count
		15 = Recurring Revenue Ext Services

   */

/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterNumber INT
)

CREATE TABLE #Final(
	CtrName	NVARCHAR(50)
			, OrdNo NVARCHAR(50)
			, TransNo NVARCHAR(50)
			, ClientNo  NVARCHAR(150)
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
			, ExtCancelDate DATETIME
			, RRrenewals INT
			, ExtRenewDate DATETIME
			, RRExtServices INT
			, FirstRank INT
	)

/********************************** Get list of centers *************************************/
 IF @Filter = 1								-- A Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
		WHERE   DC.RegionSSID = @CenterSSID
				AND DC.Active = 'Y'
	END
ELSE 										-- An Area Manager has been selected
IF @Filter = 2
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT DC.CenterNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   CMA.CenterManagementAreaSSID = @CenterSSID
				AND CMA.Active = 'Y'
	END
ELSE
IF @Filter = 3								-- A Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   DC.CenterNumber = @CenterSSID
				AND DC.Active = 'Y'
	END

/********************************** Get EXT Renewals *************************************/

	-- Get Renewals
	SELECT  FST.ClientKey
		,	1 AS 'RRrenewals'
		,	DD.FullDate AS 'ExtRenewDate'
		,	FST.MembershipKey
	INTO #Renewals
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
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
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON DC.CenterKey = DCM.CenterKey
	INNER JOIN #Centers
		ON #Centers.CenterNumber = DC.CenterNumber
	WHERE DD.FullDate BETWEEN @begdt AND @enddt
		AND DSC.SalesCodeDepartmentSSID = 1090  --Renewals
		AND M.MembershipSSID IN(SELECT MembershipSSID FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
								WHERE RevenueGroupSSID = 2 AND BusinessSegmentSSID = 2)
	GROUP BY FST.ClientKey
		,	DD.FullDate
		,	FST.MembershipKey


/********************************** Get EXT Cancellations *************************************/
SELECT  FST.ClientKey
	,	1 AS 'RRcancels'
	,	DD.FullDate AS 'ExtCancelDate'
	,	FST.MembershipKey
INTO #Cancels
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
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
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON DC.CenterKey = DCM.CenterKey
	INNER JOIN #Centers
		ON #Centers.CenterNumber = DC.CenterNumber
WHERE DD.FullDate BETWEEN @begdt AND @enddt
	AND DSC.SalesCodeDepartmentSSID = 1099  --Cancellations
	AND M.MembershipSSID IN(SELECT MembershipSSID FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
							WHERE RevenueGroupSSID = 2 AND BusinessSegmentSSID = 2)
GROUP BY FST.ClientKey
	,	DD.FullDate
	,	FST.MembershipKey


/********************************** Get Sales data *************************************/
SELECT C.CenterDescriptionNumber AS 'CtrName'
,	DSO.TicketNumber_Temp As 'OrdNo'
,	CASE WHEN SOD.TransactionNumber_Temp = -1 THEN CONVERT(VARCHAR, SOD.SalesOrderDetailKey) ELSE CONVERT(VARCHAR, SOD.TransactionNumber_Temp) END AS 'TransNo'
,	CAST(CLT.ClientIdentifier As VARCHAR(20)) + ' - ' + CLT.ClientFullName As 'ClientNo'
,	FST.ClientKey
,	DSO.OrderDate As 'Date'
,	FST.MembershipKey
,	DSC.SalesCodeDescriptionShort As 'Code'
,	M.MembershipDescription As 'Description'
,	FST.ExtendedPrice As 'Price'
,	FST.tax1 As 'Tax'
,	E_Con.EmployeeInitials As 'Consultant'
,	E_Sty.EmployeeInitials As 'Stylist'
,	FST.NB_GrossNB1Cnt AS 'NBcount'
,	FST.NB_ExtCnt AS 'NBcountnet'
,	FST.NB_ExtAmt AS 'NBsales'
,	CASE WHEN FST.NB_ExtAmt < 0 THEN FST.NB_ExtAmt ELSE 0 END AS 'NBrefunds'
,	FST.NB_ExtConvCnt AS 'NBconversions'
,	FST.PCP_ExtMemAmt AS 'RRsales'
,	NULL AS 'RRcancels'
,	NULL AS 'ExtCancelDate'
,	NULL AS 'RRrenewals'
,	NULL AS 'ExtRenewDate'
,	CASE WHEN DSC.SalesCodeDepartmentSSID IN (5035) THEN 1 ELSE 0 END AS 'RRExtServices'
,	NULL AS FirstRank
INTO #subFinal
FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = dd.DateKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
		ON FST.SalesCodeKey = DSC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
        ON FST.SalesOrderKey = DSO.SalesOrderKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
        ON DSO.ClientMembershipKey = DCM.ClientMembershipKey --Change FST to DSO
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON DCM.MembershipKey = M.MembershipKey
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON DCM.CenterKey = C.CenterKey  --Change FST to DCM
	INNER JOIN #Centers
		ON C.CenterNumber = #Centers.CenterNumber
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON C.CenterTypeKey = CT.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
		ON C.RegionKey = R.RegionKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Con
		ON FST.Employee1Key = E_Con.EmployeeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E_Sty
		ON FST.Employee2Key = E_Sty.EmployeeKey
WHERE DD.FullDate BETWEEN @begdt AND @enddt
	AND (
		FST.NB_GrossNB1Cnt <> 0
		OR FST.NB_ExtCnt <> 0
		OR FST.NB_ExtAmt <> 0
		OR CASE WHEN FST.NB_ExtAmt < 0 THEN FST.NB_ExtAmt ELSE 0 END <> 0
		OR FST.NB_ExtConvCnt <> 0
		OR FST.PCP_ExtMemAmt <> 0
		OR CASE WHEN DSC.SalesCodeDepartmentSSID IN (5035) THEN 1 ELSE 0 END <> 0
		)
GROUP BY C.CenterDescriptionNumber
,	DSO.TicketNumber_Temp
,	SOD.TransactionNumber_Temp
,	SOD.SalesOrderDetailKey
,	SOD.TransactionNumber_Temp
,	CLT.ClientIdentifier
,	FST.ClientKey
,	CLT.ClientFullName
,	DSO.OrderDate
,	FST.MembershipKey
,	DSC.SalesCodeDescriptionShort
,	M.MembershipDescription
,	FST.ExtendedPrice
,	FST.tax1
,	E_Con.EmployeeInitials
,	E_Sty.EmployeeInitials
,	FST.NB_GrossNB1Cnt
,	FST.NB_ExtCnt
,	FST.NB_ExtAmt
,	FST.NB_ExtAmt
,	FST.NB_ExtConvCnt
,	FST.PCP_ExtMemAmt
,	DSC.SalesCodeDepartmentSSID


IF @type = 11
BEGIN
	--Select to rank multiple records and pull the latest one for cancels
	INSERT INTO #Final
	SELECT CtrName
			, OrdNo
			, TransNo
			, ClientNo
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
			, #Cancels.ExtCancelDate
			, NULL AS RRrenewals
			, NULL AS ExtRenewDate
			, RRExtServices
			,ROW_NUMBER() OVER(PARTITION BY SF.ClientNo ORDER BY #Cancels.ExtCancelDate DESC) AS FirstRank
	FROM #subFinal SF
		LEFT JOIN #Cancels
			ON SF.ClientKey = #Cancels.ClientKey
	GROUP BY CtrName
			, OrdNo
			, TransNo
			, ClientNo
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
			, #Cancels.ExtCancelDate
			, RRExtServices
			,	FirstRank
	END
	ELSE
	IF @type = 10
	BEGIN
	--Select to rank multiple records and pull the latest one for renewals
	INSERT INTO #Final
	SELECT CtrName
			, OrdNo
			, TransNo
			, ClientNo
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
			, #Renewals.ExtRenewDate
			, RRExtServices
			,ROW_NUMBER() OVER(PARTITION BY SF.ClientNo ORDER BY #Renewals.ExtRenewDate DESC) AS FirstRank
			FROM #subFinal SF
			LEFT JOIN #Renewals
			ON SF.ClientKey = #Renewals.ClientKey
			GROUP BY CtrName
			, OrdNo
			, TransNo
			, ClientNo
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
			, #Renewals.ExtRenewDate
			, RRExtServices
			,	FirstRank
	END
	ELSE
	IF @type = 12
	BEGIN
		INSERT INTO #Final
		SELECT CtrName
			, OrdNo
			, TransNo
			, ClientNo
			, [Date]
			, MembershipKey
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
			, RRcancels
			, ExtCancelDate
			, RRrenewals
			, ExtRenewDate
			, RRExtServices
			,ROW_NUMBER() OVER(PARTITION BY SF.ClientNo ORDER BY SF.[Date] DESC) AS FirstRank
		FROM #subFinal SF
		WHERE Code IN ('GUARANTEE','INITASG','CANCEL')
		AND SF.NBcountnet <> 0
		GROUP BY CtrName
			, OrdNo
			, TransNo
			, ClientNo
			, [Date]
			, MembershipKey
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
			, RRcancels
			, ExtCancelDate
			, RRrenewals
			, ExtRenewDate
			, RRExtServices
			, FirstRank

	END
	ELSE
	BEGIN
		INSERT INTO #Final
		SELECT CtrName
                , OrdNo
                , TransNo
                , ClientNo
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
                , NULL AS RRrenewals
                , NULL AS ExtRenewDate
                , RRExtServices
				,	NULL AS FirstRank
		FROM #subFinal SF
		GROUP BY CtrName
			, OrdNo
			, TransNo
			, ClientNo
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
			, RRExtServices
	END


--SELECT * FROM #Final

IF @type = 1 --New Business Gross Count
	BEGIN
		SELECT *
		FROM #Final
		WHERE NBcount<>0


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
ELSE IF @type = 12 --New Business Net Count
	BEGIN
		SELECT *
		FROM #Final
		WHERE NBcountnet<>0
		AND FirstRank = 1
	END
ELSE IF @type = 15 --Recurring Revenue Ext Services
	BEGIN
		SELECT *
		FROM #Final
		WHERE RRExtServices<>0
	END


END
GO
