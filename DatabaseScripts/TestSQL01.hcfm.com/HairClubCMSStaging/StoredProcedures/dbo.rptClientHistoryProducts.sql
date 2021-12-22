/* CreateDate: 06/19/2013 23:57:22.560 , ModifyDate: 01/04/2018 11:49:44.103 */
GO
/*===============================================================================================
-- Procedure Name:                  rptClientHistoryProducts
-- Procedure Description:
--
-- Created By:                      Mike Maass
-- Implemented By:                  Mike Maass
-- Last Modified By:				Rachelen Hut
--
-- Date Created:              06/18/13
-- Date Implemented:
-- Date Last Modified:        12/13/13
--
-- Destination Server:        HairclubCMS
-- Destination Database:
-- Related Application:       Hairclub CMS
================================================================================================
**NOTES**
12/05/2013 - RH - Changed the parameter to include an array of all memberships - past and present.
08/13/2014 - RH - Added AND SO.IsVoidedFlag = 0 (#105195)
01/04/2018 - RH - Changed code to use fnSplit, removed CAST in the WHERE clause to speed up the procedure (#137117)
================================================================================================
Sample Execution:
EXEC rptClientHistoryProducts 'B8B8B2CB-D164-406A-B28F-98A95C6E5731'

EXEC rptClientHistoryProducts '58770EA0-CBA8-4C59-A5DA-5C7567292273,1808DD75-791A-41A5-AF93-3B828F856D59'

================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientHistoryProducts]
		@ClientMembershipGUIDArray NVARCHAR(MAX)
AS
BEGIN


/***********Create temp table for the ClientMembershipGUID *****************************/



CREATE TABLE #guid(ClientMembershipGUID VARCHAR(MAX))

--Populate the temp table with the GUID's
INSERT INTO #guid
SELECT * FROM dbo.fnSplit(@ClientMembershipGUIDArray,',')



DECLARE @ProductsID int

SELECT @ProductsID = SalesCodeDivisionID FROM lkpSalesCodeDivision where SalesCodeDivisionDescriptionShort = 'Products'

SELECT  SO.ClientMembershipGUID
	,	M.MembershipDescription
	,	CM.BeginDate
	,	CM.EndDate
	,	M.MembershipSortOrder
	,	so.InvoiceNumber
	,	so.OrderDate
	,	sc.SalesCodeDescription
	,	sod.Quantity
	,	sod.[Price] as SalesPrice
	,	sod.[Discount] as Discount
	,	sod.[TotalTaxCalc]
	,	sod.[ExtendedPriceCalc]
	,	sod.[PriceTaxCalc]
	,	stylist.UserLogin as StylistName
	,	consultant.UserLogin as ConsultantName
FROM datSalesOrder so
	INNER JOIN datSalesOrderDetail sod
		ON so.SalesOrderGUID = sod.SalesOrderGUID
	INNER JOIN cfgSalesCode sc
		ON sod.SalesCodeID = sc.SalesCodeID
	INNER JOIN lkpSalesCodeDepartment scd
		ON sc.SalesCodeDepartmentID = scd.SalesCodeDepartmentID
	LEFT OUTER join datEmployee stylist
		ON sod.Employee2GUID = stylist.EmployeeGUID
	LEFT OUTER JOIN datEmployee consultant
		ON sod.Employee1GUID = consultant.EmployeeGUID
	INNER JOIN datClientMembership CM
		ON SO.ClientMembershipGUID = CM.ClientMembershipGUID
	INNER JOIN cfgMembership M
		ON CM.MembershipID = M.MembershipID
WHERE so.ClientMembershipGUID IN(SELECT ClientMembershipGUID FROM #guid)
	AND scd.SalesCodeDivisionID = @ProductsID
	AND so.IsVoidedFlag = 0


END
GO
