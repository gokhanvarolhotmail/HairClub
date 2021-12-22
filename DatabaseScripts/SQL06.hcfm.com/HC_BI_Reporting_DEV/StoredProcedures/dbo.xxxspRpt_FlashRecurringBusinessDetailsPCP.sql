/***********************************************************************
PROCEDURE:				spRpt_FlashRecurringBusinessDetailsPCP
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB2 Flash Details
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES: @Center = 2 - 14 is By Regions, CenterSSID is By Centers or @Filter = 3 CenterManagementAreaID

@Filter = 5 --EXT Closing PCP
@Filter = 6 --XTRANDS Flash Open PCP
@Filter = 7 --XTRANDS Flash Close PCP
@Filter = 8 --EXT Opening PCP
@Filter = 1 --XTR+ Opening PCP
@Filter = 2 --XTR+ Closing PCP
------------------------------------------------------------------------
CHANGE HISTORY:
10/08/2013 - DL - (#89184) Added Group By Region/RSM filter
10/15/2013 - DL - (#89184) Added @Filter procedure parameter
10/15/2013 - DL - (#89184) Added additional RSM roll-up filters
04/07/2014 - RH - (#100145) Changed WHERE DR.RegionSSID = @Center to WHERE DC.RegionSSID = @Center (under Region code for #Center)
05/07/2014 - RH - (#101325) Changed DC.CenterSSID AS 'CenterNum' to DCLT.CenterSSID;
							Changed INNER JOIN #CENTERS C ON DC.CenterSSID = C.CenterID
								to INNER JOIN #CENTERS C ON DCLT.CenterSSID = C.CenterID
09/05/2014 - DL - (#104796) Added Filter 5 for EXT Flash Open & Close PCP drill down
01/26/2015 - RH - (#111105) Added Filter 6 for XTRANDS Flash Open & 7 for Close PCP drill down
03/23/2015 - RH - Added Filter 8 for EXT Opening PCP, changed Filter 5 for only EXT Closing PCP
07/02/2015 - RH - Changed code to exclude EXT and Xtrands PCP in BIO only section
07/28/2015 - RH - (#116552) Changed PCP headings, not values, to one month earlier
10/30/2015 - RH - (#119813) Changed to SQL05.HC_Accounting.dbo.vwFactPCPDetail and pulled where ActiveBIO = 1
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
04/18/2016 - RH - (#122403) @Filter = 1 (XTR+ only) OpenNotClose: Show clients in Open PCP that are not in Close PCP - mark them as red in the report
11/07/2016 - RH - (#132305) Added temp tables for XTR+ PCP; Changed @Filter from Flash Recurring Business to XTR+
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 3, '10/1/2016', '11/1/2016', 1
EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 2, '10/1/2016', '11/1/2016', 2
EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 201, '10/1/2016', '11/1/2016', 2

EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 807, '10/1/2016', '11/1/2016', 7
***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_FlashRecurringBusinessDetailsPCP]
(
	@Center INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@Filter INT
)
AS
BEGIN

SET NOCOUNT OFF;

--Find PCP Start and End Dates and ConversionEndDate
DECLARE @PCPStartDate DATETIME
,	@PCPEndDate DATETIME
,	@ConversionEndDate DATETIME


SELECT @PCPStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@StartDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@StartDate))) --Beginning of the month
,	@PCPEndDate =  CONVERT(VARCHAR, MONTH(@EndDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@EndDate))
,	@ConversionEndDate = DATEADD(MINUTE,-1,@PCPEndDate)


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterID INT
	,	CenterKey INT
)

CREATE TABLE #OpenBioPCP(
	CenterNum INT
,	Center NVARCHAR(50)
,	Client_No INT
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Membership NVARCHAR(50)
,	OpenNotClose INT
,	MonthPCP INT
,	YearPCP INT
)

CREATE TABLE #CloseBioPCP(
		CenterNum INT
	,	Center NVARCHAR(50)
	,	Client_No INT
	,	FirstName NVARCHAR(50)
	,	LastName NVARCHAR(50)
	,	Membership NVARCHAR(50)
	,	OpenNotClose INT
	,	MonthPCP INT
	,	YearPCP INT
)

CREATE TABLE #OpenNotClose(
	CenterNum INT
	,	Center NVARCHAR(50)
	,	Client_No INT
	,	FirstName NVARCHAR(50)
	,	LastName NVARCHAR(50)
	,	Membership NVARCHAR(50)
	,	OpenNotClose INT
	,	MonthPCP INT
	,	YearPCP INT
)


/********************************** Get list of centers *************************************/
IF @Center BETWEEN 201 AND 896 -- A Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID, DC.CenterKey
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   DC.CenterSSID = @Center
				AND DC.Active = 'Y'
	END
ELSE IF @Center IN ( -2, 2, 3, 4, 5, 6, 1, 7, 8, 9, 10, 11, 12, 13, 14, 15 ) -- A Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID, DC.CenterKey
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
		WHERE   DC.RegionSSID = @Center
				AND DC.Active = 'Y'
	END
ELSE -- An Area Manager has been selected
IF @Filter = 3
BEGIN
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT AM.CenterSSID, AM.CenterKey
		FROM    vw_AreaManager AM
		WHERE   AM.CenterManagementAreaSSID = @Center
				AND AM.Active = 'Y'
	END
END


/********************************** Display Data *************************************/

IF @Filter = 8  ---EXT Opening PCP
BEGIN
         SELECT DCLT.CenterSSID AS 'CenterNum'
         ,      DC.CenterDescription AS 'Center'
         ,      DCLT.ClientIdentifier AS 'Client_No'
         ,      DCLT.ClientFirstName AS 'FirstName'
         ,      DCLT.ClientLastName AS 'LastName'
         ,      M.MembershipDescription AS 'Membership'
         ,      NULL AS 'OpenNotClose'
		 ,		MONTH(DATEADD(MONTH,-1,@PCPStartDate)) AS 'MonthPCP'
		 ,		YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'YearPCP'
        FROM   HC_Accounting.dbo.FactPCPDetail PD
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON PD.DateKey = DD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
                    ON PD.ClientKey = DCLT.ClientKey
				INNER JOIN #Centers
                    ON PD.CenterKey = #Centers.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                    ON PD.CenterKey = DC.CenterKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
                    ON PD.MembershipKey = M.MembershipKey
         WHERE  MONTH(DD.FullDate) = MONTH(@PCPStartDate)
                AND YEAR(DD.FullDate) = YEAR(@PCPStartDate)
                AND PD.EXT = 1
         ORDER BY DCLT.ClientLastName
         ,      DCLT.ClientFirstName
   END
ELSE
IF @Filter = 5  --EXT Closing PCP
   BEGIN
         SELECT DCLT.CenterSSID AS 'CenterNum'
         ,      DC.CenterDescription AS 'Center'
         ,      DCLT.ClientIdentifier AS 'Client_No'
         ,      DCLT.ClientFirstName AS 'FirstName'
         ,      DCLT.ClientLastName AS 'LastName'
         ,      M.MembershipDescription AS 'Membership'
         ,      NULL AS 'OpenNotClose'
		 ,		MONTH(DATEADD(MONTH,-1,@PCPEndDate)) AS 'MonthPCP'
		 ,		YEAR(DATEADD(MONTH,-1,@PCPEndDate)) AS 'YearPCP'
        FROM   HC_Accounting.dbo.FactPCPDetail PD
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON PD.DateKey = DD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
                    ON PD.ClientKey = DCLT.ClientKey
				INNER JOIN #Centers
                    ON PD.CenterKey = #Centers.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                    ON PD.CenterKey = DC.CenterKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
                    ON PD.MembershipKey = M.MembershipKey
         WHERE  MONTH(DD.FullDate) = MONTH(@PCPEndDate)
                AND YEAR(DD.FullDate) = YEAR(@PCPEndDate)
                AND PD.EXT = 1
         ORDER BY DCLT.ClientLastName
         ,      DCLT.ClientFirstName
END
ELSE
IF @Filter = 6  --Xtrands Open PCP
BEGIN
        SELECT DCLT.CenterSSID AS 'CenterNum'
        ,      DC.CenterDescription AS 'Center'
        ,      DCLT.ClientIdentifier AS 'Client_No'
        ,      DCLT.ClientFirstName AS 'FirstName'
        ,      DCLT.ClientLastName AS 'LastName'
        ,      M.MembershipDescription AS 'Membership'
        ,      NULL AS 'OpenNotClose'
		,		MONTH(DATEADD(MONTH,-1,@PCPStartDate)) AS 'MonthPCP'
		,		YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'YearPCP'
		FROM   HC_Accounting.dbo.FactPCPDetail PD
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PD.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON PD.CenterKey = DC.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
			ON PD.ClientKey = DCLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PD.MembershipKey = M.MembershipKey
		INNER JOIN #Centers
			ON PD.CenterKey = #Centers.CenterKey
			WHERE  MONTH(DD.FullDate) = MONTH(@PCPStartDate)
				AND YEAR(DD.FullDate) = YEAR(@PCPStartDate)
				AND PD.XTR = 1
        ORDER BY DCLT.ClientLastName
        ,      DCLT.ClientFirstName
END
ELSE
IF @Filter = 7  --Xtrands Close PCP
BEGIN
         SELECT DCLT.CenterSSID AS 'CenterNum'
         ,      DC.CenterDescription AS 'Center'
         ,      DCLT.ClientIdentifier AS 'Client_No'
         ,      DCLT.ClientFirstName AS 'FirstName'
         ,      DCLT.ClientLastName AS 'LastName'
         ,      M.MembershipDescription AS 'Membership'
         ,      NULL AS 'OpenNotClose'
		 ,		MONTH(DATEADD(MONTH,-1,@PCPEndDate)) AS 'MonthPCP'
		 ,		YEAR(DATEADD(MONTH,-1,@PCPEndDate)) AS 'YearPCP'
		 FROM   HC_Accounting.dbo.FactPCPDetail PD
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON PD.DateKey = DD.DateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON PD.CenterKey = DC.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
				ON PD.ClientKey = DCLT.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON PD.MembershipKey = M.MembershipKey
			INNER JOIN #Centers
				ON PD.CenterKey = #Centers.CenterKey
         WHERE  MONTH(DD.FullDate) = MONTH(@PCPEndDate)
                AND YEAR(DD.FullDate) = YEAR(@PCPEndDate)
                AND PD.XTR = 1
         ORDER BY DCLT.ClientLastName
         ,      DCLT.ClientFirstName
END
ELSE IF @Filter = 1  --The rest of the stored procedure is to find XTR+ PCP clients and mark OpenNotClose with red in the report; or find Close XTR+ PCP
BEGIN
	--BIO Open PCP
INSERT INTO #OpenBioPCP
SELECT DCLT.CenterSSID AS 'CenterNum'
,	DC.CenterDescription AS 'Center'
,	DCLT.ClientIdentifier AS 'Client_No'
,	DCLT.ClientFirstName AS 'FirstName'
,	DCLT.ClientLastName AS 'LastName'
,	M.MembershipDescription AS 'Membership'
,	NULL AS 'OpenNotClose'
,	MONTH(DATEADD(MONTH,-1,@PCPStartDate)) AS 'MonthPCP'
,	YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'YearPCP'

FROM HC_Accounting.dbo.vwFactPCPDetail PCPD
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
        ON PCPD.ClientKey = DCLT.ClientKey
	INNER JOIN #Centers
        ON PCPD.CenterKey = #Centers.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
        ON PCPD.CenterKey = DC.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON PCPD.MembershipKey = M.MembershipKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON PCPD.DateKey = DD.DateKey
WHERE  MONTH(DD.FullDate) = MONTH(@PCPStartDate)
    AND YEAR(DD.FullDate) = YEAR(@PCPStartDate)
	AND PCPD.ActiveBIO = 1
ORDER BY DCLT.ClientLastName
,   DCLT.ClientFirstName

INSERT INTO #CloseBioPCP
SELECT 	C.CenterSSID  AS 'CenterNum'
,	C.CenterDescriptionNumber AS 'Center'
,	CLT.ClientIdentifier AS 'Client_No'
,	CLT.ClientFirstName AS 'FirstName'
,	CLT.ClientLastName AS 'LastName'
,	M.MembershipDescription AS 'Membership'
,	NULL AS 'OpenNotClose'
,	MONTH(DATEADD(MONTH,-1,@PCPEndDate)) AS 'MonthPCP'
,   YEAR(DATEADD(MONTH,-1,@PCPEndDate) ) AS 'YearPCP'
FROM HC_Accounting.dbo.vwFactPCPDetail PCPD
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON PCPD.CenterKey = C.CenterKey
	INNER JOIN #Centers
        ON PCPD.CenterKey = #Centers.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON PCPD.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON PCPD.MembershipKey = M.MembershipKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON PCPD.DateKey = DD.DateKey
WHERE DD.MonthNumber = MONTH(@PCPEndDate)
	AND DD.YearNumber = YEAR(@PCPEndDate)
	AND PCPD.ActiveBIO = 1


--Find clients who are in Opening, but not in Close
INSERT INTO #OpenNotClose
SELECT CenterNum
,   Center
,   Client_No
,   FirstName
,   LastName
,   Membership
,   1 AS 'OpenNotClose'
,	MONTH(DATEADD(MONTH,-1,@PCPEndDate)) AS 'MonthPCP'
,	YEAR(DATEADD(MONTH,-1,@PCPEndDate)) AS 'YearPCP'
FROM #OpenBioPCP
WHERE Client_No NOT IN (SELECT Client_No FROM #CloseBioPCP)

UPDATE #OpenBioPCP
SET OpenNotClose = 1
WHERE Client_No IN (SELECT Client_No FROM #OpenNotClose)
AND #OpenBioPCP.OpenNotClose IS NULL

SELECT CenterNum
,	Center
,	Client_No
,	FirstName
,	LastName
,	Membership
,	ISNULL(OpenNotClose,0) AS OpenNotClose
,	MonthPCP
,	YearPCP
FROM #OpenBioPCP
END
ELSE IF @Filter = 2  --Find XTR+ Closing PCP
BEGIN

INSERT INTO #CloseBioPCP
SELECT 	C.CenterSSID  AS 'CenterNum'
,	C.CenterDescriptionNumber AS 'Center'
,	CLT.ClientIdentifier AS 'Client_No'
,	CLT.ClientFirstName AS 'FirstName'
,	CLT.ClientLastName AS 'LastName'
,	M.MembershipDescription AS 'Membership'
,	NULL AS 'OpenNotClose'
,	MONTH(DATEADD(MONTH,-1,@PCPEndDate)) AS 'MonthPCP'
,   YEAR(DATEADD(MONTH,-1,@PCPEndDate) ) AS 'YearPCP'
FROM HC_Accounting.dbo.vwFactPCPDetail PCPD
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON PCPD.CenterKey = C.CenterKey
	INNER JOIN #Centers
        ON PCPD.CenterKey = #Centers.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON PCPD.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON PCPD.MembershipKey = M.MembershipKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON PCPD.DateKey = DD.DateKey
WHERE DD.MonthNumber = MONTH(@PCPEndDate)
	AND DD.YearNumber = YEAR(@PCPEndDate)
	AND PCPD.ActiveBIO = 1

SELECT * FROM #CloseBioPCP
END

END
