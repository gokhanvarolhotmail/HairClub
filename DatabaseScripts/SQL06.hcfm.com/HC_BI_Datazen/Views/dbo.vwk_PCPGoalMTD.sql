/* CreateDate: 07/23/2015 16:40:49.723 , ModifyDate: 07/23/2015 17:34:31.753 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwk_PCPRevenueGoalMTD
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/23/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwk_PCPRevenueGoalMTD
***********************************************************************/
CREATE VIEW [dbo].[vwk_PCPGoalMTD]
AS


SELECT
		SUM(FA.Flash) AS 'OpenPCP'
        FROM    HC_Accounting.dbo.FactAccounting FA
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FA.PartitionDate = DD.FirstDateOfMonth
        WHERE   DD.FirstDateOfMonth BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND DATEADD(ms, -3, DATEADD(mm, 0, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 0)))
			AND FA.CenterID LIKE '[2]%'
			AND FA.AccountID = 10400
GO
