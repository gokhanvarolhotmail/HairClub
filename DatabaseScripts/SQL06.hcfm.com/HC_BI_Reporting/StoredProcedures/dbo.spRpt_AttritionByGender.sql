/* CreateDate: 09/19/2012 15:39:41.723 , ModifyDate: 12/09/2014 14:52:55.463 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
PROCEDURE:				spRpt_AttritionByGender
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			HD
DATE IMPLEMENTED:		06/01/2011
LAST REVISION DATE: 	06/01/2011
==============================================================================
DESCRIPTION:	Shows all new sales and cancels for a date range
==============================================================================
NOTES:
	06/01/2010	- HD	Initial Rewrite to SQL06
	06/20/2013  - KM	(#87847) Modified to limit conversion to be only BIO memberships
	06/24/2013  - KM    (#86151) Modified report to always convert startdate to the last date of previous month
	07/24/2013	- KM	Modified to use FactSalesTransaction
	07/25/2013  - MB	Reformatted and ensured dates are correct (WO# 86151)
	12/09/2014	- RH	Added code for pre-Xtrands for historical conversion data.
==============================================================================
GRANT EXECUTE ON spRpt_AttritionByGender TO IIS
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_AttritionByGender '7/1/12', '6/30/13', 'c'
==============================================================================*/
CREATE PROCEDURE [dbo].[spRpt_AttritionByGender]
	@StartDate	DATETIME
,	@EndDate	DATETIME
,	@sType VARCHAR(10)
AS
BEGIN
	--SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @PCPStartDate DATETIME
	,	@PCPEndDate DATETIME


	DECLARE @CenterList TABLE (
		[CenterID] [int] NULL
	)


	SELECT @PCPStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@startdate)) + '/1/' + CONVERT(VARCHAR, YEAR(@startdate)))
	,	@PCPEndDate = DATEADD(MONTH, 1, @EndDate)


/***************** Create temp tables ******************************************************************/

CREATE TABLE #AllConv(
 CenterID INT
,	Total_Conv INT
,	Male_Conv INT
,	Female_Conv INT)



	IF @sType = 'c'
		BEGIN
			INSERT INTO @CenterList
			SELECT CenterSSID AS 'CenterID'
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE CenterSSID LIKE '2%'
				AND Active = 'Y'
		END
	ELSE
		BEGIN
			INSERT INTO @CenterList
			SELECT CenterSSID  AS 'CenterID'
				FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE CenterSSID LIKE '[78]__'
				AND Active = 'Y'
		END

		/*********** Find Open PCP *****************************************************/

		SELECT ce.CenterSSID AS 'CenterID'
		,	SUM(CASE g.GenderSSID WHEN 'M' THEN pcp.PCP - pcp.Extreme ELSE 0 END) AS 'MPCP'
		,	SUM(CASE g.GenderSSID WHEN 'F' THEN pcp.PCP - pcp.Extreme ELSE 0 END) AS 'FPCP'
		INTO #OpenPCP
		FROM HC_Accounting.dbo.FactPCP pcp
			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
				ON ce.CenterKey = pcp.CenterKey
			LEFT JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
				ON d.DateKey = pcp.DateKey
			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender g
				ON g.GenderKey = pcp.GenderKey
			INNER JOIN @CenterList c
				ON pcp.CenterID = c.CenterID
		WHERE d.MonthNumber = MONTH(@PCPStartDate)
			AND d.YearNumber = YEAR(@PCPStartDate)
		GROUP BY ce.CenterSSID

		/*********** Find Closed PCP *****************************************************/

		SELECT ce.CenterSSID AS 'CenterID'
		,	SUM(CASE g.GenderSSID WHEN 'M' THEN pcp.PCP - pcp.Extreme ELSE 0 END) AS 'MPCP'
		,	SUM(CASE g.GenderSSID WHEN 'F' THEN pcp.PCP - pcp.Extreme ELSE 0 END) AS 'FPCP'
		INTO #ClosePCP
		FROM HC_Accounting.dbo.FactPCP pcp
			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
				ON ce.CenterKey = pcp.CenterKey
			LEFT JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
				ON d.DateKey = pcp.DateKey
			LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender g
				ON g.GenderKey = pcp.GenderKey
			INNER JOIN @CenterList c
				ON pcp.CenterID = c.CenterID
		WHERE d.MonthNumber = MONTH(@PCPEndDate)
			AND d.YearNumber = YEAR(@PCPEndDate)
		GROUP BY ce.CenterSSID

		/*********** Find Conversions *****************************************************/

	IF @StartDate < '5/15/2014'--Pre Xtrands  --Added RH 12/09/2014
	BEGIN
		INSERT INTO #AllConv
		SELECT ce.CenterSSID AS 'CenterID'
			--,	SUM(t.NB_BIOConvCnt + t.NB_XTRConvCnt) As 'Total_Conv'
			,	SUM(t.NB_BIOConvCnt) - SUM(t.NB_EXTConvCnt) As 'Total_Conv'
			,	SUM(CASE WHEN cl.ClientGenderDescriptionShort = 'Male' THEN 1 ELSE 0 END) As 'Male_Conv'
			,	SUM(CASE WHEN cl.ClientGenderDescriptionShort = 'Female' THEN 1 ELSE 0 END) As 'Female_Conv'
			FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.DateKey = t.OrderDateKey
				LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
					ON ce.CenterKey = t.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
					ON cl.ClientKey = t.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = t.MembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = t.SalesCodeKey
				INNER JOIN @CenterList c
					ON ce.CenterSSID = c.CenterID
			WHERE d.FullDate BETWEEN @StartDate and @EndDate
				AND (t.NB_BIOConvCnt <> 0)
			GROUP BY ce.CenterSSID
	END
	ELSE
	BEGIN
		INSERT INTO #AllConv
		SELECT ce.CenterSSID AS 'CenterID'
			,	SUM(t.NB_BIOConvCnt + t.NB_XTRConvCnt) As 'Total_Conv'
			,	SUM(CASE WHEN cl.ClientGenderDescriptionShort = 'Male' THEN 1 ELSE 0 END) As 'Male_Conv'
			,	SUM(CASE WHEN cl.ClientGenderDescriptionShort = 'Female' THEN 1 ELSE 0 END) As 'Female_Conv'
			FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
					ON d.DateKey = t.OrderDateKey
				LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
					ON ce.CenterKey = t.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl
					ON cl.ClientKey = t.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
					ON m.MembershipKey = t.MembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
					ON sc.SalesCodeKey = t.SalesCodeKey
				INNER JOIN @CenterList c
					ON ce.CenterSSID = c.CenterID
			WHERE d.FullDate BETWEEN @StartDate and @EndDate
				AND (t.NB_BIOConvCnt <> 0 OR t.NB_XTRConvCnt <> 0)
			GROUP BY ce.CenterSSID
	END

		/*********** Final Select **********************************************************/


		SELECT C.CenterSSID AS 'Center_Num'
		,	C.CenterDescriptionNumber AS 'CenterName'
		,	R.RegionDescription AS 'Region'
		,	R.RegionSSID AS 'RegionID'
		,	ISNULL(opcp.[MPCP], 0) + ISNULL(opcp.[FPCP], 0) AS 'TOTALOPENED'
		,	ISNULL(cpcp.[MPCP], 0) + ISNULL(cpcp.[FPCP], 0) AS 'TOTALCLOSED'
		,	ISNULL(opcp.[MPCP], 0) AS 'MOPENED'
		,	ISNULL(cpcp.[MPCP], 0) AS 'MCLOSED'
		,	ISNULL(opcp.[FPCP], 0) AS 'FOPENED'
		,	ISNULL(cpcp.[FPCP], 0) AS 'FCLOSED'
		,	ISNULL(aConv.Total_Conv, 0) AS 'Total_Conv'
		,	ISNULL(aConv.Male_Conv, 0) AS 'Male_Conv'
		,	ISNULL(aConv.Female_Conv, 0) AS 'Female_Conv'
		,	MONTH(@PCPEndDate) AS 'ClosedPCPMonth'
		,	YEAR(@PCPEndDate) AS 'ClosedPCPYear'
		FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			INNER JOIN @CenterList CTR
				ON c.CenterSSID = CTR.CenterID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
				ON C.RegionKey = r.RegionKey
			LEFT OUTER JOIN #OpenPCP oPCP
				ON c.CenterSSID = oPCP.CenterID
			LEFT OUTER JOIN #ClosePCP cPCP
				ON c.CenterSSID = cPCP.CenterID
			LEFT OUTER JOIN #AllConv aConv
				ON c.CenterSSID = aConv.CenterID
		ORDER BY R.RegionSSID
		,	C.CenterSSID

END
GO
