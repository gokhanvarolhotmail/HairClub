/* CreateDate: 04/18/2013 14:29:54.993 , ModifyDate: 01/06/2017 10:51:31.443 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
==============================================================================
SAMPLE EXECUTION:
EXEC sprpt_ExtFlashDrillDownExpirations 201, '12/1/2015', '12/31/2015',1
EXEC sprpt_ExtFlashDrillDownExpirations 201, '12/1/2015', '12/31/2015',2
EXEC sprpt_ExtFlashDrillDownExpirations 201, '12/1/2015', '12/31/2015',3

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
		CenterSSID INT
	)


/********************************** Get list of centers *************************************/
IF @CenterSSID BETWEEN 201 AND 899 -- A Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   DC.CenterSSID = @CenterSSID
				AND DC.Active = 'Y'
	END
ELSE IF @CenterSSID IN ( -2, 2, 3, 4, 5, 6, 1, 7, 8, 9, 10, 11, 12, 13, 14, 15 ) -- A Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
		WHERE   DC.RegionSSID = @CenterSSID
				AND DC.Active = 'Y'
	END
ELSE 	-- An Area Manager has been selected
BEGIN
		IF @Filter = 2
		BEGIN
			INSERT INTO #Centers
			SELECT DISTINCT AM.CenterSSID
			FROM    vw_AreaManager AM
			WHERE   AM.CenterManagementAreaSSID = @CenterSSID
					AND AM.Active = 'Y'
		END
END

	/********************************** Get EXT Expiration data *************************************/

	SELECT CenterName, ClientNo, Date, Membership
	FROM
		(SELECT C.CenterDescriptionNumber AS 'CenterName'
		,	CAST(CLT.ClientNumber_Temp As VARCHAR(20)) + ' - ' + CLT.ClientFullName As 'ClientNo'
		,	CM.ClientMembershipEndDate AS 'Date'
		,	M.MembershipDescription AS 'Membership'
		FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			INNER JOIN #Centers cntr
				ON clt.CenterSSID = cntr.CenterSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
				ON clt.CurrentExtremeTherapyClientMembershipSSID = cm.ClientMembershipSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
				ON cm.MembershipSSID = m.MembershipSSID
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON cm.CenterKey = c.CenterKey
		--WHERE m.MembershipSSID IN (6, 7, 8, 9)
		WHERE MembershipDescriptionShort LIKE 'EXT%'
			AND cm.ClientMembershipEndDate BETWEEN @begdt AND @enddt
			--AND cm.ClientMembershipStatusSSID IN (1)
		)q
	WHERE q.ClientNo IS NOT NULL

END
GO
