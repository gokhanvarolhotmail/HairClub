/* CreateDate: 08/04/2015 16:38:54.130 , ModifyDate: 08/04/2015 16:38:54.130 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwk_PCPDollarsStatusMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_PCPDollarsStatusMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_PCPDollarsStatusMTD]
AS

SELECT  CASE WHEN A.Actual < (B.Goal * .9) THEN -1
             WHEN A.Actual > B.Goal THEN 1
             ELSE 0
        END AS 'Status'
FROM    vwk_PCPDollarsCountMTD A
,       vwk_PCPDollarsGoalMTD B
GO
