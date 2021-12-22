/* CreateDate: 04/19/2016 17:06:18.530 , ModifyDate: 04/19/2016 17:06:18.530 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					[vwk_CorpNBSalesStatusMTD]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		04/19/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwk_CorpNBSalesStatusMTD]
***********************************************************************/
CREATE VIEW [dbo].[vwk_CorpNBSalesStatusMTD]
AS

SELECT  CASE WHEN A.Actual < (B.Goal * .9) THEN -1
             WHEN A.Actual > B.Goal THEN 1
             ELSE 0
        END AS 'Status'
FROM    vwk_CorpNBSalesCountMTD A
,       vwk_CorpNBSalesGoalMTD B
GO
