/* CreateDate: 02/07/2018 12:46:58.133 , ModifyDate: 02/07/2018 15:18:09.390 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_GetCenters
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
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
WHERE   CenterTypeKey = 2
        AND Active = 'Y'
ORDER BY CenterDescription;

END
GO
