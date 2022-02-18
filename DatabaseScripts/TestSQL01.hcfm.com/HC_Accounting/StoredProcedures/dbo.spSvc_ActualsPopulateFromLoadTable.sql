/* CreateDate: 04/10/2013 10:15:45.013 , ModifyDate: 11/28/2017 15:24:21.163 */
GO
/***********************************************************************
PROCEDURE:				spSvc_ActualsPopulateFromLoadTable
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Accounting
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DESCRIPTION:			Actuals Upload
------------------------------------------------------------------------
NOTES:

04/09/2014 - DL - Updated procedure to use Great Plains period mapping table to obtain the correct fiscal period.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_ActualsPopulateFromLoadTable
***********************************************************************/
CREATE PROC [dbo].[spSvc_ActualsPopulateFromLoadTable]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;

/*
	ACTUALS Import Instructions

	1.  Save excel file provided by Accounting to local machine
	2.  In SQL05, right-click on HC_Accounting database and select "Tasks-->Import Data"
	3.	Change "Data source" to Microsoft Excel and browse to the recently saved Actuals file
	4.	Change DESTINATION "Server Name" and "Database" to "SQL05" and "HC_Accounting" respectively
	5.	Choose "Copy data from one or more tables or views"
	6.	Select "Sheet1$" for the source and "DataLoad" for the destination
	7.  Select "Edit Mappings"
	8.	Select "Delete rows in destination table"
	9.	The following fields should be mapped from "Source" to "Destination".  Everything else is ignored:
	a.	Year = Year
	b.	Period ID = Period
	c.	Converted Rate = Value
	d.	Segment2 = Account
	e.	Segment1 = Center
	10.	Finish through remaining steps and process immediately to import data
	11.	Run current stored procedure
	12.	Reprocess cube
*/


-- Remove possible NULL rows inserted from excel file
DELETE  FROM DataLoad
WHERE   [Center] IS NULL


-- UPDATE [Date] column from GP export format
UPDATE  DL
SET     DL.[Date] = DD.FullDate
FROM    DataLoad DL
        INNER JOIN tmpPeriodMapping TPM
            ON DL.Period = TPM.PeriodID
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON DL.[Year] = DD.FiscalYear
               AND TPM.FiscalMonth = DD.FiscalMonth
               AND DD.[DayOfMonth] = 1


-- Update existing records in FactAccountingActual table from DataLoad table
UPDATE  FA
SET     FA.Actual = DL.Value
,       FA.Forecast = DL.Value
,       FA.[Timestamp] = GETDATE()
FROM    FactAccounting FA
        INNER JOIN DataLoad DL
            ON FA.CenterID = DL.Center
               AND FA.AccountID = DL.Account
               AND FA.PartitionDate = DL.[Date]


-- Insert new records into FactAccountingActual table from DataLoad table
INSERT  INTO FactAccounting (
			CenterID
        ,	DateKey
        ,	PartitionDate
        ,	AccountID
        ,	Budget
        ,	Actual
        ,	Forecast
        ,	Timestamp
		)
        SELECT  DL.Center
        ,       DD.DateKey
        ,       DL.[Date]
        ,       DL.Account
        ,       0
        ,       DL.Value
        ,       DL.Value
        ,       GETDATE()
        FROM    DataLoad DL
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON DL.[Date] = DD.FullDate
        WHERE   NOT EXISTS ( SELECT *
                             FROM   FactAccounting
                             WHERE  CenterID = DL.Center
                                    AND PartitionDate = DL.[Date]
                                    AND AccountID = DL.Account )

END
GO
