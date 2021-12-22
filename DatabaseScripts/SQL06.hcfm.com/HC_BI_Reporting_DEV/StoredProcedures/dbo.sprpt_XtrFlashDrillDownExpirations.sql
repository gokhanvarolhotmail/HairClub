/* CreateDate: 01/14/2015 15:24:32.067 , ModifyDate: 03/14/2018 11:11:55.403 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

02/03/2015	RH	Added CurrentXtrandsClientMembershipSSID to the COALESCE statement

==============================================================================
SAMPLE EXECUTION:
EXEC sprpt_XtrFlashDrillDownExpirations 201, '1/1/2018', '3/20/2018'

***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_XtrFlashDrillDownExpirations] (
	@center INT
,	@StartDate SMALLDATETIME
,	@EndDate SMALLDATETIME) AS
BEGIN

	--SET FMTONLY OFF
	SET NOCOUNT OFF


	/*
		@Type

		4 = New Business Expirations
   */

/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterNumber INT
)


/********************************** Get list of centers *************************************/

INSERT INTO #Centers
SELECT c.CenterNumber
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
		ON c.RegionSSID = r.RegionSSID
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
		ON c.CenterTypeKey = t.CenterTypeKey
WHERE c.CenterSSID = @center
	AND c.Active='Y'


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
GO
