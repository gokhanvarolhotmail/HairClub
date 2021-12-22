/*
==============================================================================
PROCEDURE:				[rptSalesAnalysisByCode]
VERSION:				v1.0
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS42
AUTHOR: 				Hdu
IMPLEMENTOR: 			Hdu
DATE IMPLEMENTED: 		 4/22/2008
LAST REVISION DATE: 	 3/3/2010
==============================================================================
DESCRIPTION:
==============================================================================
-- Notes:
	01/31/2013 - MM - Exclude Membership Management for the Report
	10/05/2017 - RH - Added code @EndDate = @EndDate + '23:59:59'

==============================================================================
SAMPLE EXECUTION:
EXEC [rptSalesAnalysisByCode] 201, '08/15/2017', '08/15/2017', 0
==============================================================================
*/
CREATE PROCEDURE [dbo].[rptSalesAnalysisByCode]
@CenterId INT = 201
,@StartDate DATETIME
,@EndDate DATETIME
,@GenderID INT = 0 --0 All, 1 Male, 2 Female
AS
BEGIN

	SET NOCOUNT ON

	SET @EndDate = @EndDate + '23:59:59'

	DECLARE @MembershipManagement_DivisionID int

	SELECT @MembershipManagement_DivisionID = SalesCodeDivisionID FROM lkpSalesCodeDivision where SalesCodeDivisionDescriptionShort = 'MbrMgmt'

	IF @GenderID = 0
		SELECT
		scdv.SalesCodeDivisionID
		,scdv.SalesCodeDivisionDescription

		,sc.SalesCodeDepartmentID
		,scd.SalesCodeDepartmentDescription
		,CAST(sc.SalesCodeDepartmentID AS VARCHAR) + ' - ' + scd.SalesCodeDepartmentDescription AS Department

		,sc.SalesCodeID
		,sc.SalesCodeDescriptionShort
		,sc.SalesCodeDescription
		,sc.SalesCodeDescriptionShort + ' - ' + sc.SalesCodeDescription AS Code

		,so.OrderDate
		,so.InvoiceNumber

		,sod.Quantity
		,sod.Discount
		,sod.Price * sod.Quantity AS TotalPrice
		,sod.TotalTaxCalc AS TaxTotal
		,sod.PriceTaxCalc AS Total
		--Details
		,cl.ClientFullNameCalc
		,csh.EmployeeInitials AS Cashier
		FROM dbo.datSalesOrderDetail sod
		INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
			INNER JOIN lkpSalesCodeDepartment scd ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
				INNER JOIN lkpSalesCodeDivision scdv ON scdv.SalesCodeDivisionID = scd.SalesCodeDivisionID
					AND scdv.SalesCodeDivisionID <> @MembershipManagement_DivisionID
		INNER JOIN datSalesOrder so ON so.SalesOrderGUID = sod.SalesOrderGUID
				AND so.CenterID = @CenterId
				AND so.OrderDate BETWEEN @StartDate and @EndDate
				AND so.IsVoidedFlag <> 1
			LEFT OUTER JOIN datEmployee csh ON csh.EmployeeGUID = so.EmployeeGUID
			INNER JOIN datClient cl ON cl.ClientGUID = so.ClientGUID

	ELSE
		SELECT
		scdv.SalesCodeDivisionID
		,scdv.SalesCodeDivisionDescription

		,sc.SalesCodeDepartmentID
		,scd.SalesCodeDepartmentDescription
		,CAST(sc.SalesCodeDepartmentID AS VARCHAR) + ' - ' + scd.SalesCodeDepartmentDescription AS Department

		,sc.SalesCodeID
		,sc.SalesCodeDescriptionShort
		,sc.SalesCodeDescription
		,sc.SalesCodeDescriptionShort + ' - ' + sc.SalesCodeDescription AS Code

		,so.OrderDate
		,so.InvoiceNumber

		,sod.Quantity
		,sod.Discount
		,sod.Price * sod.Quantity AS TotalPrice
		,sod.TotalTaxCalc AS TaxTotal
		,sod.PriceTaxCalc AS Total
		--Details
		,cl.ClientFullNameCalc
		,csh.EmployeeInitials AS Cashier
		FROM dbo.datSalesOrderDetail sod
		INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
			INNER JOIN lkpSalesCodeDepartment scd ON scd.SalesCodeDepartmentID = sc.SalesCodeDepartmentID
				INNER JOIN lkpSalesCodeDivision scdv ON scdv.SalesCodeDivisionID = scd.SalesCodeDivisionID
					AND scdv.SalesCodeDivisionID <> @MembershipManagement_DivisionID
		INNER JOIN datSalesOrder so ON so.SalesOrderGUID = sod.SalesOrderGUID
				AND so.CenterID = @CenterId
				AND so.OrderDate BETWEEN @StartDate and @EndDate
				AND so.IsVoidedFlag <> 1
			LEFT OUTER JOIN datEmployee csh ON csh.EmployeeGUID = so.EmployeeGUID
			INNER JOIN datClient cl ON cl.ClientGUID = so.ClientGUID
				AND cl.GenderID = @GenderID

END
