/* CreateDate: 02/03/2021 13:53:15.300 , ModifyDate: 02/04/2021 09:22:52.763 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetRetailDataByCenterType
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HairClubCMS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		9/28/2020
DESCRIPTION:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetRetailDataByCenterType 2, NULL, NULL, 1, 1
EXEC spSvc_GetRetailDataByCenterType 2, NULL, NULL, 2, 1
EXEC spSvc_GetRetailDataByCenterType 2, NULL, NULL, 2, 2
EXEC spSvc_GetRetailDataByCenterType 2, NULL, NULL, 2, 3
EXEC spSvc_GetRetailDataByCenterType 2, NULL, NULL, 2, 4
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetRetailDataByCenterType]
(
	@CenterType INT
,	@StartDate DATETIME = NULL
,	@EndDate DATETIME = NULL
,	@ReportType INT
,	@Filter INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


/*

	@ReportType

	1 = Previous Month
	2 = Month To Date


	@Filter

	1 = Detailed Data
	2 = Summary By Center
	3 = Summary By Consultant
	4 = Summary By Stylist

*/


DECLARE @CurrentDate DATETIME


SET @CurrentDate = GETDATE()


-- Set Dates If Parameters are NULL
IF ( ( ( @StartDate IS NULL OR @EndDate IS NULL ) AND ( @ReportType = 1 ) ) OR ( DAY(@CurrentDate) = 1 ) ) --Previous Month or 1st of the Month
   BEGIN
		SET @StartDate = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentDate), 0))
		SET @EndDate = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -1, @CurrentDate)) +1, 0))
   END
ELSE IF ( ( ( @StartDate IS NULL OR @EndDate IS NULL ) AND ( @ReportType = 2 ) ) AND ( DAY(@CurrentDate) <> 1 ) ) --Month To Date
   BEGIN
		SET @StartDate = DATEADD(DAY, 0, DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentDate), 0))
		SET @EndDate = DATEADD(DAY, -1, CAST(CONVERT(VARCHAR, @CurrentDate, 10) AS DATETIME))
   END


/********************************** Return Results ***********************************************/
IF @Filter = 1 --Detailed Data
BEGIN
	SELECT	rd.CenterNumber
	,		rd.CenterDescription
	,		rd.InvoiceNumber
	,		rd.ClientIdentifier
	,		rd.ClientName
	,		rd.Membership
	,		rd.MembershipStatus
	,		rd.OrderDate
	,		rd.SalesCode
	,		rd.Description
	,		rd.SalesCodeDepartmentID
	,		rd.Department
	,		rd.Price
	,		rd.Tax
	,		rd.Total
	,		rd.Consultant
	,		rd.ConsultantPayrollID
	,		rd.Stylist
	,		rd.StylistPayrollID
	FROM	tmpRetailData rd
	WHERE	rd.OrderDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
END
ELSE IF @Filter = 2 --Summary By Center
BEGIN
	SELECT	rd.CenterNumber
	,		rd.CenterDescription
	,		SUM(rd.Price) AS 'TotalRetail'
	FROM	tmpRetailData rd
	WHERE	rd.OrderDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
	GROUP BY rd.CenterNumber
	,		rd.CenterDescription
	HAVING	SUM(rd.Price) <> 0
	ORDER BY SUM(rd.Price) DESC
END
ELSE IF @Filter = 3 --Summary By Consultant
BEGIN
	SELECT	rd.CenterNumber
	,		rd.CenterDescription
	,		rd.Consultant
	,		rd.ConsultantPayrollID
	,		SUM(rd.Price) AS 'TotalRetail'
	FROM	tmpRetailData rd
	WHERE	rd.OrderDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
			AND rd.Consultant <> ''
	GROUP BY rd.CenterNumber
	,		rd.CenterDescription
	,		rd.Consultant
	,		rd.ConsultantPayrollID
	HAVING	SUM(rd.Price) <> 0
	ORDER BY SUM(rd.Price) DESC
	,		rd.Consultant
END
ELSE IF @Filter = 4 --Summary By Stylist
BEGIN
	SELECT	rd.CenterNumber
	,		rd.CenterDescription
	,		rd.Stylist
	,		rd.StylistPayrollID
	,		SUM(rd.Price) AS 'TotalRetail'
	FROM	tmpRetailData rd
	WHERE	rd.OrderDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
			AND rd.Stylist <> ''
	GROUP BY rd.CenterNumber
	,		rd.CenterDescription
	,		rd.Stylist
	,		rd.StylistPayrollID
	HAVING	SUM(rd.Price) <> 0
	ORDER BY SUM(rd.Price) DESC
	,		rd.Stylist
END

END
GO
