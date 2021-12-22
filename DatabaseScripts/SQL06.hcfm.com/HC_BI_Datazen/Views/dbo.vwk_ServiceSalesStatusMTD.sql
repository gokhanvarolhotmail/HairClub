/* CreateDate: 07/27/2015 14:37:50.557 , ModifyDate: 07/27/2015 14:37:50.557 */
GO
/***********************************************************************
VIEW:					vwk_ServiceSalesStatusMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/27/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT Status FROM vwk_ServiceSalesStatusMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_ServiceSalesStatusMTD]
AS

SELECT  CASE WHEN A.Actual < (B.Goal * .9) THEN -1
             WHEN A.Actual > B.Goal THEN 1
             ELSE 0
        END AS 'Status'
FROM    vwk_ServiceSalesActualsMTD A
,       vwk_ServiceSalesGoalMTD B
GO
