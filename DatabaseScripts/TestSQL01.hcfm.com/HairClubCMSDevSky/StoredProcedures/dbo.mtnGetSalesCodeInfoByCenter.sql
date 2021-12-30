/* CreateDate: 02/18/2013 06:45:39.367 , ModifyDate: 02/27/2017 09:49:21.023 */
GO
/***********************************************************************

PROCEDURE:				mtnGetSalesCodeInfoByCenter	VERSION  1.0

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	iPAD Appointment Management

AUTHOR:					Kevin Murdoch

IMPLEMENTOR:			Kevin Murdoch

DATE IMPLEMENTED:		4/18/2012

LAST REVISION DATE:		4/18/2012

--------------------------------------------------------------------------------------------------------
NOTES:
	4/16/2012	KMurdoch	Initial Creation
	4/17/2012	agile.wupchurch	Added SalesCodeID
	4/20/2012	KMurdoch	Added IsSalesCodeKit Flag

--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
mtnGetSalesCodeInfoByCenter '201'

	CenterID = Logged in Center

	Sales Code Types
	1 = Product
	2 = Service
	3 = ARPayment
	4 = Membership
	5 = Misc
***********************************************************************/

CREATE  PROCEDURE [dbo].[mtnGetSalesCodeInfoByCenter] (
	@CenterID int

) AS
	BEGIN


	SET NOCOUNT ON

	SELECT
			sc.SalesCodeID as 'ID'
		,	sc.SalesCodeDepartmentID as 'DepartmentID'
		,	scd.SalesCodeDepartmentDescription as 'DepartmentDescription'
		,	sc.SalesCodeSortOrder as 'SalesCodeSortOrder'
		,	sc.SalesCodeDescriptionShort as 'SalesCodeDescriptionShort'
		,	sc.SalesCodeDescription as 'SalesCodeDescription'
		,	sc.SalesCodeTypeID
		,	sct.SalesCodeTypeDescriptionShort
		,	ISNULL(scc.PriceRetail, 0) as 'Price'
		,	ISNULL(cctr1.TaxRate,0) as 'TaxRate1'
		,	ISNULL(cctr2.TaxRate,0) as 'TaxRate2'
		,	IsSalesCodeKitFlag as 'IsSalesCodeKitFlag'
	FROM cfgsalescodecenter scc

		inner join cfgSalesCode sc
			on scc.SalesCodeID = sc.SalesCodeID
		inner join lkpSalesCodeType sct
			on sc.SalesCodeTypeID = sct.SalesCodeTypeID
		inner join lkpSalesCodeDepartment scd
			on sc.SalesCodeDepartmentID = scd.SalesCodeDepartmentID
		left outer join cfgCenterTaxRate cctr1
			on scc.TaxRate1ID = cctr1.CenterTaxRateID
		left outer join cfgCenterTaxRate cctr2
			on scc.TaxRate2ID = cctr2.CenterTaxRateID
	WHERE
		scc.CenterID = @CenterID
	order by sc.salescodetypeid,sc.SalesCodeDepartmentID,sc.SalesCodeDescription
END
GO
