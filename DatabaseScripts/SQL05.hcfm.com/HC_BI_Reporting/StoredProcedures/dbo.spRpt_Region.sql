/* CreateDate: 01/05/2015 15:29:49.957 , ModifyDate: 01/05/2015 15:29:49.957 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_Region]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			DashBoard reports use this for their parameter @Region
AUTHOR:					Rachelen Hut

------------------------------------------------------------------------
CHANGE HISTORY:
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_Region]'C'

EXEC [spRpt_Region]'F'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_Region]
(
@CenterType CHAR(1)
)
AS
BEGIN

	SET NOCOUNT ON
	SET FMTONLY OFF

	SELECT DISTINCT RegionDescription, CT.CenterTypeDescription
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON R.RegionKey = C.RegionKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON C.CenterTypeKey = CT.CenterTypeKey
	WHERE CT.CenterTypeDescription NOT IN ('Surgery', 'Joint','Unknown')
		AND R.RegionDescription <> 'Unknown'
		AND LEFT(CT.CenterTypeDescription,1) = @CenterType
		AND C.Active = 'Y'

END
GO
