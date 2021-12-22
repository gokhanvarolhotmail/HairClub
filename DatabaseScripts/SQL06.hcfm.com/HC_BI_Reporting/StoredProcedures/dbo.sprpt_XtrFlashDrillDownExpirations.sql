/*
==============================================================================

PROCEDURE:				[sprpt_XtrFlashDrillDownExpirations]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		01/14/2015

==============================================================================
DESCRIPTION:	Xtr Flash Drilldown Expirations
==============================================================================
NOTES:

==============================================================================
CHANGE HISTORY:

02/03/2015 - RH - Added CurrentXtrandsClientMembershipSSID to the COALESCE statement
03/14/2018 - RH - (#145957) Changed CenterSSID to CenterNumber
==============================================================================
SAMPLE EXECUTION:
EXEC sprpt_XtrFlashDrillDownExpirations 3, 201, 4, '1/1/2018', '3/20/2018'

***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_XtrFlashDrillDownExpirations] (
	@Filter INT
,	@center INT
,	@type INT
,	@StartDate SMALLDATETIME
,	@EndDate SMALLDATETIME
) AS
BEGIN

	--SET FMTONLY OFF
	SET NOCOUNT OFF


	/*	@Filter = 1 for Region, 2 for Area, 3 for Center
		@center is CenterNumber or RegionID (CenterManagementAreaID)
		@Type 	4 = New Business Expirations
	*/

/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterSSID INT
,	CenterNumber INT
)



/********************************** Get list of centers *******************************************/

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



/********************************** Get Xtr Expiration data *************************************/

SELECT C.CenterDescriptionNumber AS 'CenterName'
,	CLT.ClientFullName  + ' - ' + CAST(CLT.ClientIdentifier As VARCHAR(10)) As 'Client'
,	CM.ClientMembershipEndDate AS 'Date'
,	M.MembershipDescription AS 'Membership'
FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON clt.CenterSSID = C.CenterSSID
	INNER JOIN #Centers cntr
		ON C.CenterNumber = cntr.CenterNumber
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
		ON COALESCE(clt.CurrentXtrandsClientMembershipSSID,clt.CurrentBioMatrixClientMembershipSSID,clt.CurrentSurgeryClientMembershipSSID,clt.CurrentExtremeTherapyClientMembershipSSID) = cm.ClientMembershipSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
		ON cm.MembershipSSID = m.MembershipSSID
WHERE m.MembershipSSID IN (70,75)
	AND cm.ClientMembershipEndDate BETWEEN @StartDate AND @EndDate


	/*MembershipSSID	MembershipDescription
		70				Xtrands (New)			NB
		75				Xtrands 6				NB
	*/

END
