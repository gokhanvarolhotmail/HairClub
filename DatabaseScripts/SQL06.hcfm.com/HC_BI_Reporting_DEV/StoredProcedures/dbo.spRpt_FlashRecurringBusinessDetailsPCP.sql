/* CreateDate: 04/18/2016 11:23:05.040 , ModifyDate: 05/07/2019 14:49:34.060 */
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashRecurringBusinessDetailsPCP
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB2 Flash Details
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:  @Filter = 1 By Region, @Filter = 2 By Area Manager, @Filter = 3 By Center

@Type = 1 --XTR+ Opening PCP
@Type = 2 --XTR+ Closing PCP
@Type = 8 --EXT Opening PCP
@Type = 5 --EXT Closing PCP
@Type = 6 --XTRANDS Opening PCP
@Type = 7 --XTRANDS Closing PCP


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
03/29/2017 - RH - (#132569) Changed to include Transfers In and Out
04/28/2017 - RH - (#137105) Changed @Filter: 1 = By Region, 2 = By Area Manager and 3 = By Center to be consistent with other reports; @Filter changed to @Type
01/04/2018 - RH - (#138748) Added ClientMembershipStatusDescription
01/12/2018 - RH - (#145957) Added join on CenterType and removed Corporate Regions
03/06/2018 - RH - (#145957) Changed to WHERE DC.CenterNumber = @Center for @Filter = 3

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 2, '01/01/2018', '01/31/2018', 2, 2
EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 242, '01/01/2018', '01/31/2018', 8, 3


EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 6, '01/01/2018', '01/31/2018', 2, 1
EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 804, '01/01/2018', '01/31/2018', 2, 3


EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 20, '05/01/2019', '05/05/2019', 1, 2
EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 0, '05/01/2019', '05/15/2019', 1, 2
EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 0, '05/01/2019', '05/15/2019', 1, 4
EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 266, '05/01/2019', '05/15/2019', 1, 4
EXEC [spRpt_FlashRecurringBusinessDetailsPCP] 355, '05/01/2019', '05/15/2019', 1, 2


***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_FlashRecurringBusinessDetailsPCP]
(
	@Center INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@Type INT
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


CREATE TABLE #FactPCP(
	CenterNum INT
,	Center NVARCHAR(50)
,	ClientKey INT
,	Client_No INT
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Membership NVARCHAR(50)
,	OpenNotClose INT
,	MonthPCP INT
,	YearPCP INT
,	ClientMembershipStatusDescription NVARCHAR(50)
)

CREATE TABLE #OpenBioPCP(
	CenterNum INT
,	Center NVARCHAR(50)
,	ClientKey INT
,	Client_No INT
,	FirstName NVARCHAR(50)
,	LastName NVARCHAR(50)
,	Membership NVARCHAR(50)
,	OpenNotClose INT
,	MonthPCP INT
,	YearPCP INT
,	ClientMembershipStatusDescription NVARCHAR(50)
)

CREATE TABLE #CloseBioPCP(
		CenterNum INT
	,	Center NVARCHAR(50)
	,	ClientKey INT
	,	Client_No INT
	,	FirstName NVARCHAR(50)
	,	LastName NVARCHAR(50)
	,	Membership NVARCHAR(50)
	,	OpenNotClose INT
	,	MonthPCP INT
	,	YearPCP INT
	,	ClientMembershipStatusDescription NVARCHAR(50)
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

CREATE TABLE #TransferOut(
Tablename NVARCHAR(20)
,	CenterNumber INT
,	TransferOutCity NVARCHAR(150)
,	ClientKey INT
,	ClientIdentifier INT
,	TransferOutDate DATETIME
,	TransferOut INT
)

CREATE TABLE #TransferIn(
Tablename NVARCHAR(20)
,	CenterNumber INT
,	TransferInCity NVARCHAR(150)
,	ClientKey INT
,	ClientIdentifier INT
,	TransferInDate DATETIME
,	TransferIn INT
)

/********************************** Get list of centers *************************************/
IF @Filter = 1 -- A Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterNumber, DC.CenterKey
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   (DC.RegionSSID = @Center OR @Center = 0)
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ('F','JV')
	END

IF @Filter = 2  --An Area Manager has been selected
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT DC.CenterNumber, DC.CenterKey
		FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   --CMA.CenterManagementAreaSSID = @Center
		        (CMA.CenterManagementAreaSSID = @Center OR @Center = 0)
				AND CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort = 'C'
END
IF @Filter = 3  -- A Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterNumber, DC.CenterKey
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   DC.CenterNumber = @Center
				AND DC.Active = 'Y'
	END

IF @Filter = 4 AND @Center = 355
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT CTR.CenterNumber, CTR.CenterKey
	FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = CTR.CenterTypeKey
	WHERE   CMA.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN('HW')
END


IF @Filter = 4 AND @Center <> 355
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT CTR.CenterNumber, CTR.CenterKey
	FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = CTR.CenterTypeKey
	WHERE   CMA.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN('C')
END

/********************************** Display Data *************************************/
IF @Type IN(8,5,6,7,2)
BEGIN
	IF @Type = 8  ---EXT Opening PCP
	BEGIN
			INSERT INTO #FactPCP
         SELECT DC.CenterNumber AS 'CenterNum'
         ,      DC.CenterDescription AS 'Center'
		 ,	    DCLT.ClientKey
         ,      DCLT.ClientIdentifier AS 'Client_No'
         ,      DCLT.ClientFirstName AS 'FirstName'
         ,      DCLT.ClientLastName AS 'LastName'
         ,      M.MembershipDescription AS 'Membership'
         ,      NULL AS 'OpenNotClose'
		 ,		MONTH(DATEADD(MONTH,-1,@PCPStartDate)) AS 'MonthPCP'
		 ,		YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'YearPCP'
		,		memb_status.ClientMembershipStatusDescription
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
				OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipSSID
							  ,         DM.MembershipSSID
							  ,         DM.MembershipDescription
							  ,			DM.MembershipDescriptionShort
							  ,         DCM.ClientMembershipStatusDescription
							  ,         DCM.ClientMembershipBeginDate
							  ,         DCM.ClientMembershipEndDate
							  FROM     HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
										ON  ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
										ON DM.MembershipKey = DCM.MembershipKey
							  WHERE CLT.ClientKey = PD.ClientKey
							  ORDER BY  DCM.ClientMembershipEndDate DESC
							) memb_status
         WHERE  MONTH(DD.FullDate) = MONTH(@PCPStartDate)
                AND YEAR(DD.FullDate) = YEAR(@PCPStartDate)
                AND PD.EXT = 1
         ORDER BY DCLT.ClientLastName
         ,      DCLT.ClientFirstName
   END
ELSE
IF @Type = 5  --EXT Closing PCP
   BEGIN
		INSERT INTO #FactPCP
         SELECT DC.CenterNumber AS 'CenterNum'
         ,      DC.CenterDescription AS 'Center'
		 ,	    DCLT.ClientKey
         ,      DCLT.ClientIdentifier AS 'Client_No'
         ,      DCLT.ClientFirstName AS 'FirstName'
         ,      DCLT.ClientLastName AS 'LastName'
         ,      M.MembershipDescription AS 'Membership'
         ,      NULL AS 'OpenNotClose'
		 ,		MONTH(DATEADD(MONTH,-1,@PCPEndDate)) AS 'MonthPCP'
		 ,		YEAR(DATEADD(MONTH,-1,@PCPEndDate)) AS 'YearPCP'
		 ,		memb_status.ClientMembershipStatusDescription
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
				OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipSSID
							  ,         DM.MembershipSSID
							  ,         DM.MembershipDescription
							  ,			DM.MembershipDescriptionShort
							  ,         DCM.ClientMembershipStatusDescription
							  ,         DCM.ClientMembershipBeginDate
							  ,         DCM.ClientMembershipEndDate
							  FROM     HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
										ON  ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
										ON DM.MembershipKey = DCM.MembershipKey
							  WHERE CLT.ClientKey = PD.ClientKey
							  ORDER BY  DCM.ClientMembershipEndDate DESC
							) memb_status
         WHERE  MONTH(DD.FullDate) = MONTH(@PCPEndDate)
                AND YEAR(DD.FullDate) = YEAR(@PCPEndDate)
                AND PD.EXT = 1
         ORDER BY DCLT.ClientLastName
         ,      DCLT.ClientFirstName
END
ELSE
IF @Type = 6  --Xtrands Open PCP
BEGIN
		INSERT INTO #FactPCP
        SELECT DC.CenterNumber AS 'CenterNum'
        ,      DC.CenterDescription AS 'Center'
		,	   DCLT.ClientKey
        ,      DCLT.ClientIdentifier AS 'Client_No'
        ,      DCLT.ClientFirstName AS 'FirstName'
        ,      DCLT.ClientLastName AS 'LastName'
        ,      M.MembershipDescription AS 'Membership'
        ,      NULL AS 'OpenNotClose'
		,		MONTH(DATEADD(MONTH,-1,@PCPStartDate)) AS 'MonthPCP'
		,		YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'YearPCP'
		,		memb_status.ClientMembershipStatusDescription
		FROM   HC_Accounting.dbo.FactPCPDetail PD
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PD.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON PD.CenterKey = DC.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
			ON PD.ClientKey = DCLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PD.MembershipKey = M.MembershipKey
		OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipSSID
							  ,         DM.MembershipSSID
							  ,         DM.MembershipDescription
							  ,			DM.MembershipDescriptionShort
							  ,         DCM.ClientMembershipStatusDescription
							  ,         DCM.ClientMembershipBeginDate
							  ,         DCM.ClientMembershipEndDate
							  FROM     HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
										ON  ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
										ON DM.MembershipKey = DCM.MembershipKey
							  WHERE CLT.ClientKey = PD.ClientKey
							  ORDER BY  DCM.ClientMembershipEndDate DESC
							) memb_status
		INNER JOIN #Centers
			ON PD.CenterKey = #Centers.CenterKey
			WHERE  MONTH(DD.FullDate) = MONTH(@PCPStartDate)
				AND YEAR(DD.FullDate) = YEAR(@PCPStartDate)
				AND PD.XTR = 1

        ORDER BY DCLT.ClientLastName
        ,      DCLT.ClientFirstName
END
ELSE
IF @Type = 7  --Xtrands Close PCP
BEGIN
		INSERT INTO #FactPCP
         SELECT DC.CenterNumber AS 'CenterNum'
         ,      DC.CenterDescription AS 'Center'
		 ,		DCLT.ClientKey
         ,      DCLT.ClientIdentifier AS 'Client_No'
         ,      DCLT.ClientFirstName AS 'FirstName'
         ,      DCLT.ClientLastName AS 'LastName'
         ,      M.MembershipDescription AS 'Membership'
         ,      NULL AS 'OpenNotClose'
		 ,		MONTH(DATEADD(MONTH,-1,@PCPEndDate)) AS 'MonthPCP'
		 ,		YEAR(DATEADD(MONTH,-1,@PCPEndDate)) AS 'YearPCP'
		 ,		memb_status.ClientMembershipStatusDescription
		 FROM   HC_Accounting.dbo.FactPCPDetail PD
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON PD.DateKey = DD.DateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON PD.CenterKey = DC.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
				ON PD.ClientKey = DCLT.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON PD.MembershipKey = M.MembershipKey
			OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipSSID
							  ,         DM.MembershipSSID
							  ,         DM.MembershipDescription
							  ,			DM.MembershipDescriptionShort
							  ,         DCM.ClientMembershipStatusDescription
							  ,         DCM.ClientMembershipBeginDate
							  ,         DCM.ClientMembershipEndDate
							  FROM     HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
										ON  ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
										ON DM.MembershipKey = DCM.MembershipKey
							  WHERE CLT.ClientKey = PD.ClientKey
							  ORDER BY  DCM.ClientMembershipEndDate DESC
							) memb_status
			INNER JOIN #Centers
				ON PD.CenterKey = #Centers.CenterKey
         WHERE  MONTH(DD.FullDate) = MONTH(@PCPEndDate)
                AND YEAR(DD.FullDate) = YEAR(@PCPEndDate)
                AND PD.XTR = 1
         ORDER BY DCLT.ClientLastName
         ,      DCLT.ClientFirstName
END

ELSE IF @Type = 2  --Find XTR+ Closing PCP
BEGIN
	--BIO Closed PCP
INSERT INTO #FactPCP
SELECT 	C.CenterNumber  AS 'CenterNum'
,		C.CenterDescriptionNumber AS 'Center'
,		CLT.ClientKey
,		CLT.ClientIdentifier AS 'Client_No'
,		CLT.ClientFirstName AS 'FirstName'
,		CLT.ClientLastName AS 'LastName'
,		M.MembershipDescription AS 'Membership'
,		NULL AS 'OpenNotClose'
,		MONTH(DATEADD(MONTH,-1,@PCPEndDate)) AS 'MonthPCP'
,		YEAR(DATEADD(MONTH,-1,@PCPEndDate) ) AS 'YearPCP'
,		memb_status.ClientMembershipStatusDescription
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
	OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipSSID
							  ,         DM.MembershipSSID
							  ,         DM.MembershipDescription
							  ,			DM.MembershipDescriptionShort
							  ,         DCM.ClientMembershipStatusDescription
							  ,         DCM.ClientMembershipBeginDate
							  ,         DCM.ClientMembershipEndDate
							  FROM     HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
										ON  ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
										ON DM.MembershipKey = DCM.MembershipKey
							  WHERE CLT.ClientKey = PCPD.ClientKey
							  ORDER BY  DCM.ClientMembershipEndDate DESC
							) memb_status
WHERE DD.MonthNumber = MONTH(@PCPEndDate)
	AND DD.YearNumber = YEAR(@PCPEndDate)
	AND PCPD.ActiveBIO = 1

END

/**********Find Transfers ********************************************************/

INSERT INTO #TransferOut
SELECT  'TransOut' AS Tablename
,		DC.CenterNumber
,		DC.CenterDescriptionNumber AS 'TransferOutCity'
,       CLT.ClientKey
,		CLT.ClientIdentifier
,       MAX(DD.FullDate) AS 'TransferOutDate'
,		CASE WHEN SC.SalesCodeKey = 665 THEN 1
			ELSE 0 END AS 'TransferOut'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey
		INNER JOIN #FactPCP
			ON	#FactPCP.ClientKey = FST.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
			ON FST.MembershipKey = MBR.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND (SC.SalesCodeKey IN(665)) --TransferOut
GROUP BY CASE WHEN SC.SalesCodeKey = 665 THEN 1
       ELSE 0
       END
       , DC.CenterNumber
       , DC.CenterDescriptionNumber
       , CLT.ClientKey
	   ,	CLT.ClientIdentifier


INSERT INTO #TransferIn
SELECT  'TransIn' AS Tablename
,	DC.CenterNumber
,	DC.CenterDescriptionNumber AS 'TransferInCity'
,   CLT.ClientKey
,	CLT.ClientIdentifier
,   MAX(DD.FullDate) AS 'TransferDate'
,	CASE WHEN SC.SalesCodeKey = 1723 THEN 1
		ELSE 0 END AS 'TransferIn'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON FST.CenterKey = DC.CenterKey
	INNER JOIN #FactPCP
		ON	#FactPCP.ClientKey = FST.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
		ON FST.MembershipKey = MBR.MembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND (SC.SalesCodeKey IN(1723))						--TransferIn
GROUP BY CASE WHEN SC.SalesCodeKey = 1723 THEN 1
       ELSE 0
       END
	   ,	DC.CenterNumber
       , DC.CenterDescriptionNumber
       , CLT.ClientKey
       , CLT.ClientIdentifier


SELECT CenterNum
,	Center
,	Client_No
,	FirstName
,	LastName
,	Membership
,	ISNULL(OpenNotClose,0) AS 'OpenNotClose'
,	MonthPCP
,	YearPCP
,	TransferOutCity
,	TransferOutDate
,	TransferInCity
,	CASE WHEN TransferOutDate IS NOT NULL THEN 1 ELSE 0 END AS 'Transfer'
,	ClientMembershipStatusDescription
FROM #FactPCP
LEFT JOIN #TransferIn
	ON #TransferIn.ClientKey = #FactPCP.ClientKey
LEFT JOIN #TransferOut
	ON #TransferOut.ClientKey = #FactPCP.ClientKey

END

/************************************************************************************************/
/*  IF @Type = 1 Find XTR+ PCP OPEN clients and mark OpenNotClose with red in the report
	and green for Transfers in the report     */
/************************************************************************************************/


ELSE IF @Type = 1
BEGIN
	--BIO Open PCP
INSERT INTO #OpenBioPCP
SELECT DC.CenterNumber AS 'CenterNum'
,	DC.CenterDescription AS 'Center'
,	DCLT.ClientKey
,	DCLT.ClientIdentifier AS 'Client_No'
,	DCLT.ClientFirstName AS 'FirstName'
,	DCLT.ClientLastName AS 'LastName'
,	M.MembershipDescription AS 'Membership'
,	NULL AS 'OpenNotClose'
,	MONTH(DATEADD(MONTH,-1,@PCPStartDate)) AS 'MonthPCP'
,	YEAR(DATEADD(MONTH,-1,@PCPStartDate)) AS 'YearPCP'
,	memb_status.ClientMembershipStatusDescription
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
	OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipSSID
							  ,         DM.MembershipSSID
							  ,         DM.MembershipDescription
							  ,			DM.MembershipDescriptionShort
							  ,         DCM.ClientMembershipStatusDescription
							  ,         DCM.ClientMembershipBeginDate
							  ,         DCM.ClientMembershipEndDate
							  FROM     HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
										ON  ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
										ON DM.MembershipKey = DCM.MembershipKey
							  WHERE CLT.ClientKey = PCPD.ClientKey
							  ORDER BY  DCM.ClientMembershipEndDate DESC
							) memb_status
WHERE  MONTH(DD.FullDate) = MONTH(@PCPStartDate)
    AND YEAR(DD.FullDate) = YEAR(@PCPStartDate)
	AND PCPD.ActiveBIO = 1
ORDER BY DCLT.ClientLastName
,   DCLT.ClientFirstName

INSERT INTO #CloseBioPCP
SELECT 	C.CenterNumber  AS 'CenterNum'
,	C.CenterDescriptionNumber AS 'Center'
,	CLT.ClientKey
,	CLT.ClientIdentifier AS 'Client_No'
,	CLT.ClientFirstName AS 'FirstName'
,	CLT.ClientLastName AS 'LastName'
,	M.MembershipDescription AS 'Membership'
,	NULL AS 'OpenNotClose'
,	MONTH(DATEADD(MONTH,-1,@PCPEndDate)) AS 'MonthPCP'
,   YEAR(DATEADD(MONTH,-1,@PCPEndDate) ) AS 'YearPCP'
,	memb_status.ClientMembershipStatusDescription
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
	OUTER APPLY ( SELECT TOP 1
										DCM.ClientMembershipSSID
							  ,         DM.MembershipSSID
							  ,         DM.MembershipDescription
							  ,			DM.MembershipDescriptionShort
							  ,         DCM.ClientMembershipStatusDescription
							  ,         DCM.ClientMembershipBeginDate
							  ,         DCM.ClientMembershipEndDate
							  FROM     HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
										ON  ( DCM.ClientMembershipSSID = CLT.CurrentBioMatrixClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentExtremeTherapyClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentSurgeryClientMembershipSSID
										  OR DCM.ClientMembershipSSID = CLT.CurrentXtrandsClientMembershipSSID )
									INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
										ON DM.MembershipKey = DCM.MembershipKey
							  WHERE CLT.ClientKey = PCPD.ClientKey
							  ORDER BY  DCM.ClientMembershipEndDate DESC
							) memb_status
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

/**********Find Transfers ********************************************************/

INSERT INTO #TransferOut
SELECT  'TransOut' AS Tablename
,		DC.CenterNumber
,		DC.CenterDescriptionNumber AS 'TransferOutCity'
,       CLT.ClientKey
,		CLT.ClientIdentifier
,       MAX(DD.FullDate) AS 'TransferOutDate'
,		CASE WHEN SC.SalesCodeKey = 665 THEN 1
			ELSE 0 END AS 'TransferOut'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey
		INNER JOIN #OpenBioPCP
			ON	#OpenBioPCP.ClientKey = FST.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
			ON FST.MembershipKey = MBR.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND (SC.SalesCodeKey IN(665)) --TransferOut
GROUP BY CASE WHEN SC.SalesCodeKey = 665 THEN 1
       ELSE 0
       END
       , DC.CenterNumber
       , DC.CenterDescriptionNumber
       , CLT.ClientKey
	   ,	CLT.ClientIdentifier


INSERT INTO #TransferIn
SELECT  'TransIn' AS Tablename
,	DC.CenterNumber
,	DC.CenterDescriptionNumber AS 'TransferInCity'
,   CLT.ClientKey
,	CLT.ClientIdentifier
,   MAX(DD.FullDate) AS 'TransferDate'
,	CASE WHEN SC.SalesCodeKey = 1723 THEN 1
		ELSE 0 END AS 'TransferIn'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON FST.CenterKey = DC.CenterKey
	INNER JOIN #OpenBioPCP
		ON	#OpenBioPCP.ClientKey = FST.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
		ON FST.MembershipKey = MBR.MembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND (SC.SalesCodeKey IN(1723))						--TransferIn
GROUP BY CASE WHEN SC.SalesCodeKey = 1723 THEN 1
       ELSE 0
       END
	   ,	DC.CenterNumber
       , DC.CenterDescriptionNumber
       , CLT.ClientKey
       , CLT.ClientIdentifier


SELECT CenterNum
,	Center
,	Client_No
,	FirstName
,	LastName
,	Membership
,	CASE WHEN TransferOutDate IS NOT NULL THEN 0 ELSE ISNULL(OpenNotClose,0) END AS 'OpenNotClose'
,	MonthPCP
,	YearPCP
,	TransferOutCity
,	TransferOutDate
,	TransferInCity
,	CASE WHEN TransferOutDate IS NOT NULL THEN 1 ELSE 0 END AS 'Transfer'
,	ClientMembershipStatusDescription
FROM #OpenBioPCP
LEFT JOIN #TransferIn
	ON #TransferIn.ClientKey = #OpenBioPCP.ClientKey
LEFT JOIN #TransferOut
	ON #TransferOut.ClientKey = #OpenBioPCP.ClientKey
GROUP BY CASE WHEN TransferOutDate IS NOT NULL THEN 0
       ELSE ISNULL(OpenNotClose ,0)
       END
       , CASE WHEN TransferOutDate IS NOT NULL THEN 1
       ELSE 0
       END
       , CenterNum
       , Center
       , Client_No
       , FirstName
       , LastName
       , Membership
       , MonthPCP
       , YearPCP
       , TransferOutCity
       , TransferOutDate
       , TransferInCity
       , ClientMembershipStatusDescription

END



END
GO
