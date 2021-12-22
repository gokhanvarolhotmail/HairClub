/***********************************************************************
PROCEDURE:				spRpt_GetCenters
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		2/7/2018
DESCRIPTION:			2/7/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_GetCenters
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_GetCenters]
AS
BEGIN

SET NOCOUNT ON;


SELECT  CenterSSID
,       CenterDescription + ' (' + CAST(CenterNumber AS VARCHAR(4)) + ')' AS 'CenterDescriptionNumber'
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter
WHERE   CenterTypeKey IN ( 2, 3, 4 )
        AND Active = 'Y'
ORDER BY CenterDescription

END
