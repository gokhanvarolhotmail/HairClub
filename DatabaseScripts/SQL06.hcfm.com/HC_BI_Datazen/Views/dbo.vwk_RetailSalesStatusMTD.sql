/* CreateDate: 07/27/2015 11:47:20.573 , ModifyDate: 07/27/2015 11:47:20.573 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwk_RetailSalesStatusMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/27/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_RetailSalesStatusMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_RetailSalesStatusMTD]
AS

SELECT  CASE WHEN A.Actual < (B.Goal * .9) THEN -1
             WHEN A.Actual > B.Goal THEN 1
             ELSE 0
        END AS 'Status'
FROM    vwk_RetailSalesActualsMTD A
,       vwk_RetailSalesGoalMTD B
GO
