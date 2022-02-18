/* CreateDate: 06/22/2015 08:37:25.737 , ModifyDate: 03/07/2017 18:45:57.070 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthConfirmationsExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		06/22/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthConfirmationsExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthConfirmationsExport]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get Confirmation Data *************************************/
SELECT  CTR.CenterSSID
,		CAST(DC.ContactSSID AS VARCHAR(10)) AS 'LeadID'
,       REPLACE(DC.ContactFirstName, ',', ' ') AS 'FirstName'
,       REPLACE(DC.ContactLastName, ',', ' ') AS 'LastName'
,		DA.ActivitySSID
,		DA.ActivityDueDate
,		DA.ActivityStartTime
,		DA.ActionCodeSSID
,		DA.ResultCodeSSID
,		DA.ActivityTypeSSID
,		DA.ActivityCompletionDate
,		DA.ActivityCompletionTime
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON CTR.CenterSSID = DA.CenterSSID
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
            ON DC.ContactSSID = DA.ContactSSID
WHERE	DA.ActivityDueDate > DATEADD(DAY, -7, GETDATE())
		AND DA.ActionCodeSSID IN ( 'CONFIRM' )
		AND DA.ResultCodeSSID NOT IN ( 'PRANK' )
		AND CTR.CenterSSID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )
ORDER BY CTR.CenterSSID
,		DA.ActivityDueDate
,		DA.ActivityStartTime

END
GO
