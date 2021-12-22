/* CreateDate: 01/16/2018 11:58:12.443 , ModifyDate: 01/16/2018 11:58:12.443 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
PROCEDURE:				spRpt_ConversionNewBusinessRetentionDetailsConversions
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED:		1/16/2018
LAST REVISION DATE: 	1/16/2018
==============================================================================
DESCRIPTION:	Finds Main Group for the Detail Report Headers
==============================================================================
NOTES:

==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_FindMainGroup 'C', 2, 6
EXEC spRpt_FindMainGroup 'C', 3, 201

EXEC spRpt_FindMainGroup 'F', 1, 6
EXEC spRpt_FindMainGroup 'F', 3, 804

==============================================================================*/
CREATE PROCEDURE [dbo].[spRpt_FindMainGroup](
	@sType NVARCHAR(1)
,	@Filter INT
,	@CenterSSID INT
)

AS
BEGIN
--SET FMTONLY OFF
SET NOCOUNT OFF

/*==============================================================================
	@sType							@Filter
		'C' = Corporate				1 = By Region
		'F' = Franchise				2 = By Area
									3 = By Center
==============================================================================*/

CREATE TABLE #MainGroup (
	MainGroup VARCHAR(50)
)

IF @Filter = 1	AND @sType = 'F'								-- A Region has been selected - Franchises
BEGIN
INSERT  INTO #MainGroup
		SELECT  DR.RegionDescription AS 'MainGroup'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
		WHERE   DR.RegionSSID = @CenterSSID
				AND DC.Active = 'Y'
				AND DCT.CenterTypeDescriptionShort IN ('F','JV')
END
ELSE
IF @Filter = 2	AND @sType = 'C'									-- An Area has been selected.
BEGIN
INSERT  INTO #MainGroup
		SELECT  CMA.CenterManagementAreaDescription AS 'MainGroup'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   DC.CenterManagementAreaSSID = @CenterSSID
				AND DC.Active = 'Y'
				AND DCT.CenterTypeDescriptionShort = 'C'
END
ELSE
IF @Filter = 3	AND @sType = 'C'									-- A Corporate Center has been selected.
BEGIN
INSERT  INTO #MainGroup
		SELECT 	DC.CenterDescriptionNumber AS 'MainGroup'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
		WHERE   DC.CenterSSID = @CenterSSID
				AND DC.Active = 'Y'
END
IF @Filter = 3	AND @sType = 'F'									-- A Franchise Center has been selected.
BEGIN
INSERT  INTO #MainGroup
		SELECT  DC.CenterDescriptionNumber AS 'MainGroup'
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
		WHERE   DC.CenterSSID = @CenterSSID
				AND DC.Active = 'Y'
END

SELECT TOP 1 * FROM #MainGroup

END
GO
