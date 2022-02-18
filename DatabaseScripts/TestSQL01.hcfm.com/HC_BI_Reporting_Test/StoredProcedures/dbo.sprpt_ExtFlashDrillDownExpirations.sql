/* CreateDate: 04/18/2013 14:29:54.993 , ModifyDate: 03/08/2018 11:20:25.793 */
GO
/*
==============================================================================

PROCEDURE:				sprpt_ExtFlashDrillDownExpirations

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		04/18/2013

==============================================================================
DESCRIPTION:	EXT Flash Drilldown Expirations
==============================================================================
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
==============================================================================
CHANGE HISTORY:
11/27/2013 - RH - Commented out "AND cm.ClientMembershipStatusSSID IN (1)" for expirations.
03/23/2015 - RH - (#110054) Added roll-up filters - by Region, RSM, MA, RTM
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
01/06/2017 - RH - (#132688) Changed EmployeeKey for AreaManager to CenterManagementAreaSSID
03/07/2018 - RH - (#145957) Changed CenterSSID to CenterNumber
==============================================================================
SAMPLE EXECUTION:
EXEC sprpt_ExtFlashDrillDownExpirations 6, '12/1/2017', '12/31/2017',1
EXEC sprpt_ExtFlashDrillDownExpirations 10, '12/1/2017', '12/31/2017',2
EXEC sprpt_ExtFlashDrillDownExpirations 201, '12/1/2017', '12/31/2017',3

***********************************************************************/
CREATE PROCEDURE [dbo].[sprpt_ExtFlashDrillDownExpirations] (
	@CenterSSID INT
,	@begdt SMALLDATETIME
,	@enddt SMALLDATETIME
,	@Filter INT
) AS
BEGIN

	--SET FMTONLY OFF
	SET NOCOUNT OFF


	/*
		@Type 4 = New Business Expirations
    */

	/********************************** Create temp table objects *************************************/
	CREATE TABLE #Centers (
		CenterNumber INT
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


	/********************************** Get EXT Expiration data *************************************/

	SELECT CenterName, ClientNo, [Date], Membership
	FROM
		(SELECT C.CenterDescriptionNumber AS 'CenterName'
		,	CAST(CLT.ClientNumber_Temp As VARCHAR(20)) + ' - ' + CLT.ClientFullName As 'ClientNo'
		,	CM.ClientMembershipEndDate AS 'Date'
		,	M.MembershipDescription AS 'Membership'
		FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
				ON clt.CurrentExtremeTherapyClientMembershipSSID = cm.ClientMembershipSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
				ON cm.MembershipSSID = m.MembershipSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON cm.CenterKey = c.CenterKey
			INNER JOIN #Centers
				ON c.CenterNumber = #Centers.CenterNumber
		WHERE MembershipDescriptionShort LIKE 'EXT%'
			AND cm.ClientMembershipEndDate BETWEEN @begdt AND @enddt
		)q
	WHERE q.ClientNo IS NOT NULL

END
GO
