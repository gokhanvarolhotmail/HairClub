/* CreateDate: 08/12/2015 17:00:10.010 , ModifyDate: 08/12/2015 17:18:07.817 */
GO
/***********************************************************************
VIEW:					vwk_TotalCenterSalesStatusMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/27/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT Status FROM [vwk_TotalCenterSalesStatusMTD]
***********************************************************************/
CREATE VIEW [dbo].[vwk_TotalCenterSalesStatusMTD]
AS

SELECT  CASE WHEN A.Actual < (B.Goal * .9) THEN -1
             WHEN A.Actual > B.Goal THEN 1
             ELSE 0
        END AS 'Status'
FROM    vwk_TotalCenterSalesActualsMTD A
,       vwk_TotalCenterSalesGoalMTD B
GO
