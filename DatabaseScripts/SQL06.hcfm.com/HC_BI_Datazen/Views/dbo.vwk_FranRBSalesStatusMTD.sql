/* CreateDate: 05/06/2016 15:12:15.337 , ModifyDate: 05/06/2016 15:12:15.337 */
GO
/***********************************************************************
VIEW:					vwk_FranRBSalesStatusMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_FranRBSalesStatusMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_FranRBSalesStatusMTD]
AS

SELECT  CASE WHEN A.Actual < (B.Goal * .9) THEN -1
             WHEN A.Actual > B.Goal THEN 1
             ELSE 0
        END AS 'Status'
FROM    vwk_FranRBSalesCountMTD A
,       vwk_FranRBSalesGoalMTD B
GO
