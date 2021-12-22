/***********************************************************************
VIEW:					vwk_NewStyleDayStatusMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_NewStyleDayStatusMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_NewStyleDayStatusMTD]
AS

SELECT
	--A.Actual,B.Goal, (B.Goal * .85) as MinBoundary,
	CASE WHEN A.Actual < (B.Goal * .85) THEN -1 --Negative if less than 85% of goal
             WHEN A.Actual > B.Goal THEN 1 --Positive if at or above goal
             ELSE 0
        END AS 'Status'
FROM    vwk_NewStyleDayCountMTD A
,       vwk_NewStyleDayGoalMTD B
