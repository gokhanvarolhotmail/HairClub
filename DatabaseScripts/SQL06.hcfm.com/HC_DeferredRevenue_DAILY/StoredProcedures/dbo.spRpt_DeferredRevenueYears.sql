/***********************************************************************
PROCEDURE:				spRpt_DeferredRevenueYears
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_DeferredRevenue
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		2/2/2018
DESCRIPTION:			2/2/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_DeferredRevenueYears
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_DeferredRevenueYears]
AS
BEGIN

SET NOCOUNT ON;

SELECT 2019 AS 'ID', 2019 AS 'Description'
UNION
SELECT 2020 AS 'ID', 2020 AS 'Description'
UNION
SELECT 2021 AS 'ID', 2021 AS 'Description'
END
