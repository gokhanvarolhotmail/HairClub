/* CreateDate: 07/21/2015 12:34:08.077 , ModifyDate: 08/04/2015 17:16:03.197 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
