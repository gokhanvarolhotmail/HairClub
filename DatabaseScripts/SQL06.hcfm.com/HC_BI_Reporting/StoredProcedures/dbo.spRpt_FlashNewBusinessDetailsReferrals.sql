/* CreateDate: 03/17/2015 15:28:41.667 , ModifyDate: 01/28/2021 17:08:20.027 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashNewBusinessDetailsReferrals
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB1 Flash Details
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		03/17/2015
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_FlashNewBusinessDetailsReferrals 230, '11/01/2020', '11/30/2020', 3
EXEC spRpt_FlashNewBusinessDetailsReferrals 230, '01/01/2021', '01/27/2021', 3
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FlashNewBusinessDetailsReferrals]
(	@center INT
,	@begdt DATETIME
,	@enddt DATETIME
,	@Filter INT
)
AS
BEGIN

	SET NOCOUNT OFF

/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterNumber INT
)


/********************************** Get list of centers *************************************/
IF @Filter = 1										-- A Franchise Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   (DC.RegionSSID = @Center OR @Center = 0)
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ('F','JV')
	END
ELSE
	IF @Filter = 2									-- An Area Manager has been selected
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT DC.CenterNumber
		FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE
				(CMA.CenterManagementAreaSSID = @Center OR @center = 0)
				AND CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN('C','HW')
	END
ELSE
IF @Filter = 3 									-- A Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   DC.CenterNumber = @Center
				AND DC.Active = 'Y'

	END

ELSE
	IF @Filter = 4 AND @center = 355
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT DC.CenterNumber
		FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE
				CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN('HW')
	END

ELSE
	IF @Filter = 4
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT DC.CenterNumber
		FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE
				CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN('C')
	END


/***********************************************************************************************/
SELECT	CASE WHEN @Filter = 1 THEN R.RegionDescription
			WHEN @Filter = 3
				AND DC.CenterTypeKey IN ( 3, 4 ) THEN R.RegionDescription --Franchises
			ELSE CMA.CenterManagementAreaDescription
		END AS 'RegionDescription'
,		DC.CenterDescriptionNumber
,		C.ContactSSID
,		C.ContactFirstName
,		C.ContactLastName
,		A.ActivityDueDate
,		A.ResultCodeDescription
,		A.ActionCodeDescription
,		FAR.SourceKey
,		A.SourceSSID
,		DS.SourceName
,		DS.Media
,		CASE WHEN FAR.BOSRef = 1 THEN 1
			WHEN FAR.BOSOthRef = 1 THEN 1
			WHEN FAR.HCRef = 1 THEN 1
		END AS 'Referral'
,		AD.Performer
FROM	HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FAR.CenterKey = DC.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FAR.ActivityDueDateKey = DD.DateKey
		INNER JOIN #Centers CTR
			ON DC.CenterNumber = CTR.CenterNumber
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity A
			ON A.ActivityKey = FAR.ActivityKey
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact C
			ON A.SFDC_LeadID = C.SFDC_LeadID
		LEFT JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic AD
			ON A.SFDC_TaskID = AD.SFDC_TaskID
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
			ON DS.SourceKey = FAR.SourceKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON R.RegionKey = DC.RegionKey
WHERE	DD.FullDate BETWEEN @begdt AND @enddt
		AND DS.Media IN ( 'Referrals', 'Referral' )
		AND FAR.Show = 1
		AND FAR.BOSAppt <> 1
		AND DS.OwnerType <> 'Bosley Consult'

END
GO
