/* CreateDate: 08/02/2012 09:23:50.630 , ModifyDate: 05/20/2019 11:04:23.953 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashRecurringBusinessDetailsExpirations
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
04/07/2014 - RH - (#100145) Changed WHERE DR.RegionSSID = @CenterSSID to WHERE DC.RegionSSID = @CenterSSID
					(under Region code for #Center)
11/25/2014 - RH - (#108216) Added more generic code for the WHERE clause in case EXT NB memberships are added
12/01/2014 - RH - Removed AND cm.ClientMembershipStatusSSID IN ( 1 )
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID; Changed logic to use @Filter to populate #Centers
01/12/2018 - RH - (#145957) Added join on CenterType and removed Corporate Regions
05/20/2019 - JL - (Case 4824) Added drill down to report

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_FlashRecurringBusinessDetailsExpirations 10, '01/01/2018', '01/31/2018', 2
EXEC spRpt_FlashRecurringBusinessDetailsExpirations 287, '01/01/2018', '01/31/2018', 3

EXEC spRpt_FlashRecurringBusinessDetailsExpirations 6, '01/01/2018', '01/31/2018', 1
EXEC spRpt_FlashRecurringBusinessDetailsExpirations 807, '01/01/2018', '01/31/2018', 3
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FlashRecurringBusinessDetailsExpirations]
(
	@CenterSSID INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@Filter INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterSSID INT
)


/********************************** Get list of centers *************************************/
IF @Filter = 3 -- A Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   DC.CenterSSID = @CenterSSID
				AND DC.Active = 'Y'
	END
ELSE IF @Filter = 1 -- A Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   (DC.RegionSSID = @CenterSSID OR @CenterSSID = 0)
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN('F','JV')
	END

ELSE IF @Filter = 4 AND @CenterSSID = 355
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT CTR.CenterSSID
	FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = CTR.CenterTypeKey
	WHERE   CMA.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN('HW')
END

ELSE IF @Filter = 4 AND @CenterSSID <> 355
BEGIN
	INSERT INTO #Centers
	SELECT DISTINCT CTR.CenterSSID
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
			SELECT DISTINCT DC.CenterSSID
			FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE   --CMA.CenterManagementAreaSSID = @CenterSSID
			        (CMA.CenterManagementAreaSSID = @CenterSSID OR @CenterSSID = 0)
					AND CMA.Active = 'Y'
					AND DC.Active = 'Y'
					--AND CT.CenterTypeDescriptionShort = 'C'
					AND CT.CenterTypeDescriptionShort IN('C','HW')
		END
END



SELECT  C.CenterNumber AS 'CenterID'
,       C.CenterDescription AS 'Center'
,       C.CenterDescriptionNumber AS 'CenterName'
,		CASE WHEN @Filter = 1 THEN R.RegionDescription
				WHEN @Filter = 3 AND C.CenterTypeKey IN(3,4) THEN R.RegionDescription
					ELSE CMA.CenterManagementAreaDescription END AS 'Region'
,		CASE WHEN @Filter = 1 THEN R.RegionSSID
				WHEN @Filter = 3 AND C.CenterTypeKey IN(3,4) THEN R.RegionSSID
					ELSE CMA.CenterManagementAreaSSID END AS 'RegionID'
,       clt.ClientIdentifier AS 'client_no'
,       CONVERT(VARCHAR, clt.ClientIdentifier) + ' - ' + clt.ClientFullName AS 'ClientName'
,       M.MembershipDescription
,       CM.ClientMembershipEndDate
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
		INNER JOIN #Centers cntr
			ON clt.CenterSSID = cntr.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON clt.CurrentExtremeTherapyClientMembershipSSID = cm.ClientMembershipSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipSSID = m.MembershipSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON clt.CenterSSID = c.CenterSSID
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
				ON C.RegionKey = r.RegionKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON C.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
WHERE   M.BusinessSegmentKey = 3  --EXT
				AND M.RevenueGroupDescription = 'New Business'
				AND M.MembershipDescriptionShort NOT LIKE '%BOS%'  --Bosley
				AND M.MembershipDescriptionShort NOT LIKE '%POST%'  --Post EXT
                AND cm.ClientMembershipEndDate BETWEEN @StartDate
                                               AND     @EndDate
                AND cm.ClientMembershipStatusSSID IN ( 1 )



END
GO
