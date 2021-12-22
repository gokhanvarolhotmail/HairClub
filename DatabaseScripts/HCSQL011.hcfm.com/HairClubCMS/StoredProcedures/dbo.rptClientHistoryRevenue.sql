/* CreateDate: 06/19/2013 23:57:22.523 , ModifyDate: 01/04/2018 11:50:45.987 */
GO
/*===============================================================================================
-- Procedure Name:                  rptClientHistoryRevenue
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
12/03/2013 - RH - Changed the parameter to include an array of all memberships - past and present.
08/13/2014 - RH - Added AND so.IsVoidedFlag = 0 (WO#105195)
01/04/2018 - RH - Changed code to use fnSplit, removed CAST in the WHERE clause to speed up the procedure (#137117)

================================================================================================
Sample Execution:
EXEC rptClientHistoryRevenue 'B8B8B2CB-D164-406A-B28F-98A95C6E5731'

EXEC rptClientHistoryRevenue '58770EA0-CBA8-4C59-A5DA-5C7567292273,1808DD75-791A-41A5-AF93-3B828F856D59'
================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientHistoryRevenue]
	@ClientMembershipGUIDArray NVARCHAR(MAX)
AS
BEGIN


CREATE TABLE #guid(ClientMembershipGUID VARCHAR(MAX))

--Populate the temp table with the GUID's
INSERT INTO #guid
SELECT * FROM dbo.fnSplit(@ClientMembershipGUIDArray,',')

DECLARE @MembershipReveueID int
DECLARE @MembershipPaymentID int

SELECT @MembershipReveueID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment where SalesCodeDepartmentDescriptionShort = 'MRRevenue'
SELECT @MembershipPaymentID = SalesCodeDepartmentID FROM lkpSalesCodeDepartment where SalesCodeDepartmentDescriptionShort = 'MSARPmt'


Select SO.ClientMembershipGUID
	,	M.MembershipDescription
	,	CM.BeginDate
	,	CM.EndDate
	,	M.MembershipSortOrder
	,	so.InvoiceNumber
	,	so.OrderDate
	,	sc.SalesCodeDescription
	,	tt.TenderTypeDescription
	,	sot.[Amount] as TenderAmount
FROM datSalesOrder so
	INNER JOIN datSalesOrderDetail sod
		ON so.SalesOrderGUID = sod.SalesOrderGUID
	INNER JOIN cfgSalesCode sc
		ON sod.SalesCodeId = sc.SalesCodeID
	INNER JOIN datSalesOrderTender sot
		ON so.SalesOrderGUID = sot.SalesOrderGUID
	INNER JOIN lkpTenderType tt
		ON sot.TenderTypeID = tt.TenderTypeID
	INNER JOIN datClientMembership CM
		ON SO.ClientMembershipGUID = CM.ClientMembershipGUID
	INNER JOIN cfgMembership M
		ON CM.MembershipID = M.MembershipID
WHERE SO.ClientMembershipGUID  IN(SELECT ClientMembershipGUID FROM #guid)
	AND (sc.SalesCodeDepartmentID  = @MembershipReveueID OR sc.SalesCodeDepartmentID = @MembershipPaymentID)
	AND so.IsVoidedFlag = 0


END
GO
