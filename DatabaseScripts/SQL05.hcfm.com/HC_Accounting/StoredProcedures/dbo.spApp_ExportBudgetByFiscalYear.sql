/* CreateDate: 08/13/2013 08:54:05.577 , ModifyDate: 05/14/2014 13:36:47.763 */
GO
/***********************************************************************
PROCEDURE:				spApp_ExportBudgetByFiscalYear
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Accounting
RELATED REPORT:
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:

This procedure exports the given fiscal year's budget
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spApp_ExportBudgetByFiscalYear 2014
***********************************************************************/
CREATE PROC [dbo].[spApp_ExportBudgetByFiscalYear]
(
	@FiscalYear INT
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


DECLARE @BeginDate SMALLDATETIME
DECLARE @EndDate SMALLDATETIME


-- Set the Beginning and End dates, based on the Fiscal year entered by the user.
--SET @BeginDate = CAST(( '7/1/' + CAST(( @FiscalYear - 1 ) AS VARCHAR) ) AS SMALLDATETIME)
--SET @EndDate = CAST(( '6/30/' + CAST(( @FiscalYear ) AS VARCHAR) ) AS SMALLDATETIME)
SET @BeginDate = CAST(( '1/1/' + CAST(( @FiscalYear ) AS VARCHAR) ) AS SMALLDATETIME)
SET @EndDate = CAST(( '12/31/' + CAST(( @FiscalYear ) AS VARCHAR) ) AS SMALLDATETIME)


-- Create a temp table, which contains the data to be summarized.
SELECT  a.CenterID AS 'Center'
,       a.AccountID AS 'Account'
,       0.0 AS 'BeginningBalance'
,       ISNULL(a.Budget, 0) AS 'Budget'
,       a.PartitionDate AS 'Date'
,       DATENAME(MONTH, a.PartitionDate) 'Period'
,       d.AccountDescription
INTO    #FactAccounting
FROM    dbo.FactAccounting a
        INNER JOIN HC_BI_ENT_DDS.[bi_ent_dds].[DimAccount] d
            ON a.AccountID = d.AccountID
WHERE   a.CenterID LIKE '2%'
        AND a.PartitionDate BETWEEN @BeginDate AND @EndDate
        AND ( a.AccountID < 10000
              OR a.AccountID IN ( 10110, 10235, 10240, 10410, 10440 ) )


-- Update the 'Period' column to reflect the month of the Fiscal year.
--UPDATE  [#FactAccounting]
--SET     Period = 'Period1'
--WHERE   Period = 'July'

--UPDATE  [#FactAccounting]
--SET     Period = 'Period2'
--WHERE   Period = 'August'

--UPDATE  [#FactAccounting]
--SET     Period = 'Period3'
--WHERE   Period = 'September'

--UPDATE  [#FactAccounting]
--SET     Period = 'Period4'
--WHERE   Period = 'October'

--UPDATE  [#FactAccounting]
--SET     Period = 'Period5'
--WHERE   Period = 'November'

--UPDATE  [#FactAccounting]
--SET     Period = 'Period6'
--WHERE   Period = 'December'

--UPDATE  [#FactAccounting]
--SET     Period = 'Period7'
--WHERE   Period = 'January'

--UPDATE  [#FactAccounting]
--SET     Period = 'Period8'
--WHERE   Period = 'February'

--UPDATE  [#FactAccounting]
--SET     Period = 'Period9'
--WHERE   Period = 'March'

--UPDATE  [#FactAccounting]
--SET     Period = 'Period10'
--WHERE   Period = 'April'

--UPDATE  [#FactAccounting]
--SET     Period = 'Period11'
--WHERE   Period = 'May'

--UPDATE  [#FactAccounting]
--SET     Period = 'Period12'
--WHERE   Period = 'June'

UPDATE  [#FactAccounting]
SET     Period = 'Period1'
WHERE   Period = 'January'

UPDATE  [#FactAccounting]
SET     Period = 'Period2'
WHERE   Period = 'February'

UPDATE  [#FactAccounting]
SET     Period = 'Period3'
WHERE   Period = 'March'

UPDATE  [#FactAccounting]
SET     Period = 'Period4'
WHERE   Period = 'April'

UPDATE  [#FactAccounting]
SET     Period = 'Period5'
WHERE   Period = 'May'

UPDATE  [#FactAccounting]
SET     Period = 'Period6'
WHERE   Period = 'June'

UPDATE  [#FactAccounting]
SET     Period = 'Period7'
WHERE   Period = 'July'

UPDATE  [#FactAccounting]
SET     Period = 'Period8'
WHERE   Period = 'August'

UPDATE  [#FactAccounting]
SET     Period = 'Period9'
WHERE   Period = 'September'

UPDATE  [#FactAccounting]
SET     Period = 'Period10'
WHERE   Period = 'October'

UPDATE  [#FactAccounting]
SET     Period = 'Period11'
WHERE   Period = 'November'

UPDATE  [#FactAccounting]
SET     Period = 'Period12'
WHERE   Period = 'December'


-- Display Results.
SELECT  CAST(Center AS VARCHAR) + '-' + CAST(Account AS VARCHAR) AS 'Account'
,       AccountDescription AS 'Description'
,       BeginningBalance AS [Beginning Balance]
,       ISNULL([Period1], 0) AS [Period 1]
,       ISNULL([Period2], 0) AS [Period 2]
,       ISNULL([Period3], 0) AS [Period 3]
,       ISNULL([Period4], 0) AS [Period 4]
,       ISNULL([Period5], 0) AS [Period 5]
,       ISNULL([Period6], 0) AS [Period 6]
,       ISNULL([Period7], 0) AS [Period 7]
,       ISNULL([Period8], 0) AS [Period 8]
,       ISNULL([Period9], 0) AS [Period 9]
,       ISNULL([Period10], 0) AS [Period 10]
,       ISNULL([Period11], 0) AS [Period 11]
,       ISNULL([Period12], 0) AS [Period 12]
,       ISNULL([Period1], 0) + ISNULL([Period2], 0) + ISNULL([Period3], 0) + ISNULL([Period4], 0) + ISNULL([Period5], 0) + ISNULL([Period6], 0)
        + ISNULL([Period7], 0) + ISNULL([Period8], 0) + ISNULL([Period9], 0) + ISNULL([Period10], 0) + ISNULL([Period11], 0) + ISNULL([Period12], 0) AS 'Total'
FROM    ( SELECT    a.[Center]
          ,         a.Account
          ,         a.BeginningBalance
          ,         a.Budget
          ,         a.Period
          ,         a.AccountDescription
          FROM      [#FactAccounting] a
        ) src PIVOT
( SUM(Budget) FOR [Period] IN ( [Period1], [Period2], [Period3], [Period4], [Period5], [Period6], [Period7], [Period8], [Period9], [Period10], [Period11],
                                [Period12] ) )
AS pvt
WHERE   ( ISNULL([Period1], 0) + ISNULL([Period2], 0) + ISNULL([Period3], 0) + ISNULL([Period4], 0) + ISNULL([Period5], 0) + ISNULL([Period6], 0)
          + ISNULL([Period7], 0) + ISNULL([Period8], 0) + ISNULL([Period9], 0) + ISNULL([Period10], 0) + ISNULL([Period11], 0) + ISNULL([Period12], 0) ) != 0.0
ORDER BY Center
,       Account

END
GO
