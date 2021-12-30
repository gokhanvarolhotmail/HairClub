/* CreateDate: 12/17/2018 15:02:03.490 , ModifyDate: 01/28/2021 17:08:22.143 */
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashNewBusinessDetailsActivity
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB1 Flash Details
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
------------------------------------------------------------------------
CHANGE HISTORY:

01/05/2020 - KM - Added sort by Due Date
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_FlashNewBusinessDetailsActivity] 230, 190, '01/01/2021', '01/27/2021', 3
EXEC [spRpt_FlashNewBusinessDetailsActivity] 230, 200, '01/01/2021', '01/27/2021', 3
EXEC [spRpt_FlashNewBusinessDetailsActivity] 256, 210, '01/01/2021', '01/27/2021', 3
EXEC [spRpt_FlashNewBusinessDetailsActivity] 256, 220, '01/01/2021', '01/27/2021', 3
EXEC [spRpt_FlashNewBusinessDetailsActivity] 230, 230, '01/01/2021', '01/27/2021', 3
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_FlashNewBusinessDetailsActivity]
(
	@center INT
,	@type INT
,	@begdt DATETIME
,	@enddt DATETIME
,	@Filter INT

)
AS
BEGIN
	SET FMTONLY OFF;
	SET NOCOUNT OFF;

	/*
		@Type = Flash Heading

		190 = Consultations
		200 = BeBacks
		210 = Virtual Consultations
		220 = In-Person Consultations
		230 = 1st Consultations
	*/


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers ( CenterSSID INT, CenterNumber INT )


/********************************** Get list of centers *************************************/
IF @Filter = 1 -- A Franchise Region has been selected.
BEGIN
	INSERT	INTO #Centers
	SELECT	DISTINCT
			DC.CenterSSID
	,		DC.CenterNumber
	FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
				ON DC.RegionSSID = DR.RegionSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = DC.CenterTypeKey
	WHERE (DC.RegionSSID = @center OR @center = 0)
			AND DC.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN ( 'F', 'JV' )
END
ELSE	IF @Filter = 2 -- An Area Manager has been selected
BEGIN
	INSERT	INTO #Centers
	SELECT	DISTINCT
			DC.CenterSSID
	,		DC.CenterNumber
	FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = DC.CenterTypeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
	WHERE	(CMA.CenterManagementAreaSSID = @center OR @center = 0)
			AND CMA.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN ( 'C', 'HW' )
END
ELSE	IF @Filter = 3 -- A Center has been selected.
BEGIN
	INSERT	INTO #Centers
	SELECT	DISTINCT
			DC.CenterSSID
	,		DC.CenterNumber
	FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
	WHERE (DC.CenterNumber = @center OR @center = 0)
			AND DC.Active = 'Y'
END
ELSE	IF (@Filter = 4 AND @center = 355)
BEGIN
	INSERT	INTO #Centers
	SELECT	DISTINCT
			DC.CenterSSID
	,		DC.CenterNumber
	FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = DC.CenterTypeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
	WHERE	CMA.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN ( 'HW' )
END
ELSE	IF @Filter = 4
BEGIN
	INSERT	INTO #Centers
	SELECT	DISTINCT
			DC.CenterSSID
	,		DC.CenterNumber
	FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
				ON CT.CenterTypeKey = DC.CenterTypeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
	WHERE	CMA.Active = 'Y'
			AND CT.CenterTypeDescriptionShort IN ( 'C' )
END


--CONSULTS
SELECT	CASE WHEN @Filter = 1 THEN R.RegionDescription
			WHEN @Filter = 3
				AND DC.CenterTypeKey IN ( 3, 4 ) THEN R.RegionDescription
			ELSE CMA.CenterManagementAreaDescription
		END AS Area
,		DC.CenterNumber
,		DC.CenterDescriptionNumber
,		C.SFDC_LeadID AS SFDC_LeadID
,		dbo.fxProperCase(C.ContactFirstName) AS ContactFirstName
,		dbo.fxProperCase(C.ContactLastName) AS ContactLastName
,		A.ActivityDueDate
,		A.ResultCodeDescription
,		A.ActionCodeDescription
,		AD.NoSaleReason
,		AD.Performer
,		CASE WHEN (FAR.Consultation = 1) THEN 1 ELSE 0 END AS IsConsultation
,		CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5) THEN 1 ELSE 0 END AS IsBeBack
,		CASE WHEN FAR.Inhouse = 1 THEN 1 ELSE 0 END AS Inhouse
,		CASE WHEN FAR.BOSAppt = 1 THEN 1 ELSE 0 END AS BOSAppt --BOSREFVAN,BOSREFPORT,BOSREFSALT,BOSREFSTLOU,BOSREFTYCO,BOSREFTWSN
,		CASE WHEN FAR.BOSRef = 1 THEN 1 ELSE 0 END AS BOSRef --BOSREF
,		CASE WHEN FAR.BOSOthRef = 1 THEN 1 ELSE 0 END AS BOSOthRef --BOSDMREF,BOSBIOEMREF,BOSBIODMREF
,		CASE WHEN FAR.HCRef = 1 THEN 1 ELSE 0 END AS HCRef --CORP REFER,REFERAFRND,STYLEREFER,REGISSTYRFR,NBREFCARD
,		CASE WHEN FAR.BOSAppt = 1
				AND FAR.BeBack <> 1 THEN 'Bosley New Consultation'
			ELSE DS.SourceName
		END AS SourceName
,		A.SourceSSID
,		CASE WHEN ISNULL(FAR.Accomodation, 'In Person Consult') = 'In Person Consult' AND Consultation = 1 THEN 1 ELSE 0 END AS 'InPersonConsultations'
,		CASE WHEN ISNULL(FAR.Accomodation, 'In Person Consult') <> 'In Person Consult' AND Consultation = 1 THEN 1 ELSE 0 END AS 'VirtualConsultations'
,		CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5) THEN CASE WHEN DD.FullDate < '12/1/2020' THEN 0 ELSE 1 END ELSE 0 END AS 'BeBacksToExclude'
,		CASE WHEN ( FAR.BOSRef = 1 OR FAR.BOSOthRef = 1 OR FAR.HCRef = 1 ) THEN CASE WHEN DD.FullDate < '12/1/2020' THEN 0 ELSE 1 END ELSE 0 END AS 'ReferralsToExclude'
INTO	#Consultations
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
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON R.RegionKey = DC.RegionKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
WHERE	DD.FullDate BETWEEN @begdt AND @enddt
		AND FAR.Show = 1
		AND FAR.Consultation = 1


-- BEBACKs
SELECT	CASE WHEN @Filter = 1 THEN R.RegionDescription
			WHEN @Filter = 3
				AND DC.CenterTypeKey IN ( 3, 4 ) THEN R.RegionDescription
			ELSE CMA.CenterManagementAreaDescription
		END AS Area
,		DC.CenterNumber
,		DC.CenterDescriptionNumber
,		C.SFDC_LeadID AS SFDC_LeadID
,		dbo.fxProperCase(C.ContactFirstName) AS ContactFirstName
,		dbo.fxProperCase(C.ContactLastName) AS ContactLastName
,		A.ActivityDueDate
,		A.ResultCodeDescription
,		A.ActionCodeDescription
,		AD.NoSaleReason
,		AD.Performer
,		CASE WHEN (FAR.Consultation = 1 AND FAR.BeBack <> 1) THEN 1 ELSE 0 END AS IsConsultation
,		CASE WHEN (FAR.BeBack = 1 OR FAR.ActionCodeKey = 5) THEN 1 ELSE 0 END AS IsBeBack
,		CASE WHEN FAR.Inhouse = 1 THEN 1 ELSE 0 END AS Inhouse
,		CASE WHEN FAR.BOSAppt = 1 THEN 1 ELSE 0 END AS BOSAppt --BOSREFVAN,BOSREFPORT,BOSREFSALT,BOSREFSTLOU,BOSREFTYCO,BOSREFTWSN
,		CASE WHEN FAR.BOSRef = 1 THEN 1 ELSE 0 END AS BOSRef --BOSREF
,		CASE WHEN FAR.BOSOthRef = 1 THEN 1 ELSE 0 END AS BOSOthRef --BOSDMREF,BOSBIOEMREF,BOSBIODMREF
,		CASE WHEN FAR.HCRef = 1 THEN 1 ELSE 0 END AS HCRef --CORP REFER,REFERAFRND,STYLEREFER,REGISSTYRFR,NBREFCARD
,		CASE WHEN FAR.BOSAppt = 1
				AND FAR.BeBack = 1 THEN 'Bosley New BEBACK'
			ELSE DS.SourceName
		END AS SourceName
,		A.SourceSSID
,		CASE WHEN DD.FullDate < '12/1/2020' THEN 0 ELSE 1 END AS 'ExcludeFromConsults'
,		CASE WHEN FAR.BOSRef = 1 THEN 1
			WHEN FAR.BOSOthRef = 1 THEN 1
			WHEN FAR.HCRef = 1 THEN 1
			ELSE 0
		END AS 'ExcludeFromBeBacks'
INTO	#BeBacks
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
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON R.RegionKey = DC.RegionKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
WHERE	DD.FullDate BETWEEN @begdt AND @enddt
		AND FAR.Show = 1


IF @type = 190 --Consultations
BEGIN
	SELECT	c.Area
	,		c.CenterNumber
	,		c.CenterDescriptionNumber
	,		c.SFDC_LeadID
	,		c.ContactFirstName
	,		c.ContactLastName
	,		c.ActivityDueDate
	,		c.ResultCodeDescription
	,		c.ActionCodeDescription
	,		c.NoSaleReason
	,		c.Performer
	,		c.IsConsultation
	,		c.IsBeBack
	,		c.Inhouse
	,		c.BOSAppt
	,		c.BOSRef
	,		c.BOSOthRef
	,		c.HCRef
	,		c.SourceName
	,		c.SourceSSID
	FROM	#Consultations c
	ORDER BY c.CenterNumber
	,		c.ActivityDueDate
END
ELSE IF @type = 200 --BeBacks
BEGIN
	SELECT	bb.Area
	,		bb.CenterNumber
	,		bb.CenterDescriptionNumber
	,		bb.SFDC_LeadID
	,		bb.ContactFirstName
	,		bb.ContactLastName
	,		bb.ActivityDueDate
	,		bb.ResultCodeDescription
	,		bb.ActionCodeDescription
	,		bb.NoSaleReason
	,		bb.Performer
	,		bb.IsConsultation
	,		bb.IsBeBack
	,		bb.Inhouse
	,		bb.BOSAppt
	,		bb.BOSRef
	,		bb.BOSOthRef
	,		bb.HCRef
	,		bb.SourceName
	,		bb.SourceSSID
	FROM	#BeBacks bb
	WHERE	ISNULL(bb.IsBeBack, 0) = 1
			AND ISNULL(bb.ExcludeFromBeBacks, 0) = 0
	ORDER BY bb.CenterNumber
	,		bb.ActivityDueDate
END
ELSE IF @type = 210 --Virtual Consultations
BEGIN
	SELECT	c.Area
	,		c.CenterNumber
	,		c.CenterDescriptionNumber
	,		c.SFDC_LeadID
	,		c.ContactFirstName
	,		c.ContactLastName
	,		c.ActivityDueDate
	,		c.ResultCodeDescription
	,		c.ActionCodeDescription
	,		c.NoSaleReason
	,		c.Performer
	,		c.IsConsultation
	,		c.IsBeBack
	,		c.Inhouse
	,		c.BOSAppt
	,		c.BOSRef
	,		c.BOSOthRef
	,		c.HCRef
	,		c.SourceName
	,		c.SourceSSID
	FROM	#Consultations c
	WHERE	ISNULL(c.VirtualConsultations, 0) = 1
	ORDER BY c.CenterNumber
	,		c.ActivityDueDate
END
ELSE IF @type = 220 --In-Person Consultations
BEGIN
	SELECT	c.Area
	,		c.CenterNumber
	,		c.CenterDescriptionNumber
	,		c.SFDC_LeadID
	,		c.ContactFirstName
	,		c.ContactLastName
	,		c.ActivityDueDate
	,		c.ResultCodeDescription
	,		c.ActionCodeDescription
	,		c.NoSaleReason
	,		c.Performer
	,		c.IsConsultation
	,		c.IsBeBack
	,		c.Inhouse
	,		c.BOSAppt
	,		c.BOSRef
	,		c.BOSOthRef
	,		c.HCRef
	,		c.SourceName
	,		c.SourceSSID
	FROM	#Consultations c
	WHERE	ISNULL(c.InPersonConsultations, 0) = 1
	ORDER BY c.CenterNumber
	,		c.ActivityDueDate
END
ELSE IF @type = 230 --1st Consultations
BEGIN
	SELECT	c.Area
	,		c.CenterNumber
	,		c.CenterDescriptionNumber
	,		c.SFDC_LeadID
	,		c.ContactFirstName
	,		c.ContactLastName
	,		c.ActivityDueDate
	,		c.ResultCodeDescription
	,		c.ActionCodeDescription
	,		c.NoSaleReason
	,		c.Performer
	,		c.IsConsultation
	,		c.IsBeBack
	,		c.Inhouse
	,		c.BOSAppt
	,		c.BOSRef
	,		c.BOSOthRef
	,		c.HCRef
	,		c.SourceName
	,		c.SourceSSID
	FROM	#Consultations c
	WHERE	( ISNULL(c.BeBacksToExclude, 0) = 0
				AND ISNULL(c.ReferralsToExclude, 0) = 0 )
	ORDER BY c.CenterNumber
	,		c.ActivityDueDate
END
END
GO
