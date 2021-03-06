/* CreateDate: 02/08/2016 13:48:34.933 , ModifyDate: 02/08/2016 13:48:34.933 */
GO
/***********************************************************************
VIEW:					vwk_FranchiseNewStyleDayStatusMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		07/21/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_FranchiseNewStyleDayStatusMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_FranchiseNewStyleDayStatusMTD]
AS

SELECT
	--A.Actual,B.Goal, (B.Goal * .85) as MinBoundary,
	CASE WHEN A.Actual < (B.Goal * .85) THEN -1 --Negative if less than 85% of goal
             WHEN A.Actual > B.Goal THEN 1 --Positive if at or above goal
             ELSE 0
        END AS 'Status'
FROM    vwk_FranchiseNewStyleDayCountMTD A
,       vwk_FranchiseNewStyleDayGoalMTD B
GO
