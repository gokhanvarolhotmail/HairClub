/* CreateDate: 08/10/2015 15:22:12.160 , ModifyDate: 08/10/2015 15:22:12.160 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwk_FranchiseLeadsStatusMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_FranchiseLeadsStatusMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_FranchiseLeadsStatusMTD]
AS

SELECT  CASE WHEN A.Actual < (B.Goal * .9) THEN -1
             WHEN A.Actual > B.Goal THEN 1
             ELSE 0
        END AS 'Status'
FROM    vwk_FranchiseLeadsCountMTD A
,       vwk_FranchiseLeadsGoalMTD B
GO
