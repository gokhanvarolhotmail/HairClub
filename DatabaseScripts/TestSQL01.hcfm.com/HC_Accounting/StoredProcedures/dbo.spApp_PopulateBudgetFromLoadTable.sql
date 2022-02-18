/* CreateDate: 06/12/2013 17:20:15.193 , ModifyDate: 06/26/2019 10:38:54.327 */
GO
/***********************************************************************
PROCEDURE:				spApp_PopulateBudgetFromLoadTable
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Accounting
RELATED REPORT:
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		02/06/2009
------------------------------------------------------------------------
NOTES:

This procedure populates the FactAccounting table from the DataLoad table
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spApp_PopulateBudgetFromLoadTable
***********************************************************************/
CREATE PROC [dbo].[spApp_PopulateBudgetFromLoadTable]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/*
	BUDGETS Import Instructions

	1.  Save excel file provided by Accounting to local machine
	2.  In SQL05, right-click on HC_Accounting database and select "Tasks-->Import Data"
	3.	Change "Data source" to Microsoft Excel and browse to the recently saved Actuals file
	4.	Change DESTINATION "Server Name" and "Database" to "SQL05" and "HC_Accounting" respectively
	5.	Choose "Copy data from one or more tables or views"
	6.	Select "Sheet1$" for the source and "DataLoad" for the destination
	7.  Select "Edit Mappings"
	8.	Select "Delete rows in destination table"
	9.	The following fields should be mapped from "Source" to "Destination".  Everything else is ignored:
		a.	Center = Center
		b.	Account = Account
		c.	Date = Date
		d.	Amount = Value
		e.	Period = ValueType
		f.	Submit = Submit
	10.	Finish through remaining steps and process immediately to import data
	11.	Run current stored procedure
	12.	Reprocess cube
*/


/* Remove possible NULL rows inserted from excel file */
DELETE  FROM DataLoad
WHERE   Center IS NULL


/* Update existing records in FactAccounting table from DataLoad table */
UPDATE  FA
SET     FA.Budget = LoadTable.Budget
,       FA.Forecast = LoadTable.Budget
,       FA.[Timestamp] = GETDATE()
FROM    dbo.FactAccounting FA
        INNER JOIN ( SELECT Center
                     ,      [Date]
                     ,      Account
                     ,		CASE WHEN ValueType='Budget' THEN Value ELSE 0 END AS 'Budget'
					 ,		CASE WHEN ValueType='Forecast' THEN Value ELSE 0 END AS 'Forecast'
                     ,      GETDATE() AS 'Timestamp'
                     ,      Submit
                     FROM   dbo.DataLoad
                     WHERE  ValueType IN ( 'Budget', 'Forecast' )
                            AND Submit = 'yes'
                   ) LoadTable
            ON FA.CenterID = LoadTable.Center
               AND FA.AccountID = LoadTable.Account
               AND FA.PartitionDate = LoadTable.[Date]


/* Insert new records into FactAccounting table from DataLoad table */
INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	[Timestamp]
		)
        SELECT  DataLoad.Center
        ,       DD.DateKey
        ,       DataLoad.[Date]
        ,       DataLoad.Account
		,		MAX(CASE WHEN ValueType='Budget' THEN Value ELSE 0 END) AS 'Budget'
		,		MAX(CASE WHEN ValueType='Budget' THEN Value ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON dbo.DataLoad.[Date] = DD.FullDate
        WHERE   [ValueType] IN ( 'Budget', 'Forecast' )
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DataLoad.Center
                                        AND PartitionDate = DataLoad.[Date]
                                        AND AccountID = DataLoad.Account )
                AND DataLoad.[Submit] = 'yes'
        GROUP BY DataLoad.Center
        ,       DD.DateKey
        ,       DataLoad.[Date]
        ,       DataLoad.Account


/* 10305 - NB - Traditional Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       DL.Account
			,       DL.Value
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account = 3005
					AND DL.Submit = 'yes'
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10305 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10305
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account = 3005
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10305 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       DL.Account


/* 10306 - NB - Xtrands Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       DL.Account
			,       DL.Value
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account = 3020
					AND DL.Submit = 'yes'
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10306 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10306
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account = 3020
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10306 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       DL.Account


/* 10310 - NB - Gradual Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       DL.Account
			,       DL.Value
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account = 3010
					AND DL.Submit = 'yes'
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10310 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10310
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account = 3010
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10310 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       DL.Account


/* 10315 - NB - Extreme Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       DL.Account
			,       DL.Value
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account = 3006
					AND DL.Submit = 'yes'
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10315 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10315
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account = 3006
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10315 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       DL.Account


/* 10320 - NB - Surgery Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       DL.Account
			,       DL.Value
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account = 3111
					AND DL.Submit = 'yes'
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10320 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10320
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account = 3111
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10320 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       DL.Account


/* 10325 - NB - PostEXT Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       DL.Account
			,       DL.Value
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account = 3113
					AND DL.Submit = 'yes'
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10325 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10325
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account = 3113
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10325 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       DL.Account


/* 10233 - NB - Net Sales (Incl PEXT) $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       ROUND(SUM(DL.Value), 2) AS 'Value'
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account IN ( 3005, 3020, 3010, 3006, 3111, 3113, 3097 )
					AND DL.Submit = 'yes'
			GROUP BY DL.Center
			,       DD.DateKey
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10233 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10233
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account IN ( 3005, 3020, 3010, 3006, 3111, 3113, 3097 )
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10233 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date



/* 10530 - PCP - PCP Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       DL.Account
			,       DL.Value
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account = 3030
					AND DL.Submit = 'yes'
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10530 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10530
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account = 3030
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10530 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       DL.Account


/* 10535 - PCP - EXTMEM Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       DL.Account
			,       DL.Value
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account = 3021
					AND DL.Submit = 'yes'
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10535 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10535
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account = 3021
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10535 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       DL.Account


/* 10531 - Xtrands Recurring Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       DL.Account
			,       DL.Value
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account = 3023
					AND DL.Submit = 'yes'
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10531 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10531
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account = 3023
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10531 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       DL.Account


/* 10575 - Service Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       DL.Account
			,       DL.Value
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account = 3085
					AND DL.Submit = 'yes'
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10575 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10575
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account = 3085
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10575 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       DL.Account



/* 10536 - PCP - BIO & EXTMEM & Xtrands Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       ROUND(SUM(DL.Value), 2) AS 'Value'
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account IN ( 3030, 3023, 3021 )
					AND DL.Submit = 'yes'
			GROUP BY DL.Center
			,       DD.DateKey
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10536 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10536
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account IN ( 3030, 3023, 3021 )
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10536 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date


/* 10532 - PCP - BIO Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       DL.Account
			,       DL.Value
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account = 3030
					AND DL.Submit = 'yes'
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10532 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10532
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       MAX(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account = 3030
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10532 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       DL.Account


/*  10555 - Retail Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       ROUND(SUM(DL.Value), 2) AS 'Value'
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account IN ( 3090 )
					AND DL.Submit = 'yes'
			GROUP BY DL.Center
			,       DD.DateKey
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10555 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10555
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account IN ( 3090 )
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10555 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date


/*  10559 - Retail & Laser Devices $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       ROUND(SUM(DL.Value), 2) AS 'Value'
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account IN ( 3090, 3096 )
					AND DL.Submit = 'yes'
			GROUP BY DL.Center
			,       DD.DateKey
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10559 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10559
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account IN ( 3090, 3096 )
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10559 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date


/*  10551 - PCP Laser Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       ROUND(SUM(DL.Value), 2) AS 'Value'
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account IN ( 3096 )
					AND DL.Submit = 'yes'
			GROUP BY DL.Center
			,       DD.DateKey
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10551 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10551
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account IN ( 3096 )
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10551 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date


/*  10552 - NB Laser Sales $ */
UPDATE	FA
SET		FA.Budget = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Forecast = CASE WHEN LoadTable.Value < 0 THEN ( LoadTable.Value * -1 ) ELSE LoadTable.Value END
,		FA.Timestamp = GETDATE()
FROM	FactAccounting FA
		INNER JOIN (
			SELECT  DL.Center AS 'CenterID'
			,       DD.DateKey
			,       ROUND(SUM(DL.Value), 2) AS 'Value'
			FROM    DataLoad DL
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON DL.Date = DD.FullDate
			WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
					AND DL.Account IN ( 3097 )
					AND DL.Submit = 'yes'
			GROUP BY DL.Center
			,       DD.DateKey
		) LoadTable
			ON FA.CenterID = LoadTable.CenterID
			AND FA.DateKey = LoadTable.DateKey
WHERE   FA.AccountID IN ( 10552 )


INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.Date
        ,       10552
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Budget'
        ,       SUM(CASE WHEN DL.ValueType = 'Budget' THEN CASE WHEN DL.Value < 0 THEN ( DL.Value * -1 ) ELSE DL.Value END ELSE 0 END) AS 'Forecast'
        ,       MAX(GETDATE()) AS 'Timestamp'
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.Date = DD.FullDate
        WHERE   DL.ValueType IN ( 'Budget', 'Forecast' )
				AND DL.Account IN ( 3097 )
                AND NOT EXISTS ( SELECT *
                                 FROM   FactAccounting
                                 WHERE  CenterID = DL.Center
                                        AND PartitionDate = DL.Date
                                        AND AccountID = 10552 )
                AND DL.Submit = 'yes'
        GROUP BY DL.Center
        ,       DD.DateKey
        ,       DL.Date

END
GO
