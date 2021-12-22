/* CreateDate: 05/06/2016 14:52:00.913 , ModifyDate: 05/06/2016 14:53:09.420 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					[vwk_FranNBSalesStatusMTD]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		05/06/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwk_FranNBSalesStatusMTD]
***********************************************************************/
CREATE VIEW [dbo].[vwk_FranNBSalesStatusMTD]
AS

SELECT  CASE WHEN A.Actual < (B.Goal * .9) THEN -1
             WHEN A.Actual > B.Goal THEN 1
             ELSE 0
        END AS 'Status'
FROM    vwk_FranNBSalesCountMTD A
,       vwk_FranNBSalesGoalMTD B
GO
