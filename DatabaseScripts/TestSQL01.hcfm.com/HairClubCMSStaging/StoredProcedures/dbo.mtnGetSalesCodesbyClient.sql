/* CreateDate: 02/18/2013 06:45:39.377 , ModifyDate: 02/27/2017 09:49:21.087 */
GO
/***********************************************************************

PROCEDURE:				mtnGetProductsbyClient	VERSION  1.0

DESTINATION SERVER:		SQL01

DESTINATION DATABASE:	HairClubCMS

RELATED APPLICATION:	iPAD Appointment Management

AUTHOR:					Kevin Murdoch

IMPLEMENTOR:			Kevin Murdoch

DATE IMPLEMENTED:		4/16/2012

LAST REVISION DATE:		4/16/2012

--------------------------------------------------------------------------------------------------------
NOTES:
	4/16/2012	KMurdoch	Initial Creation
	4/17/2012	agile.wupchurch	Added SalesCodeID
	4/20/2012	KMurdoch	Added IsSalesCodeKitFlag

--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
mtnGetSalesCodesbyClient '201','AAFBC12E-4D29-4F02-A9AF-009493C4FFE3', 'Product'

	CenterID = Logged in Center
	ClientMembershipGUID = From datAppointment - ClientMembershipGUID
	SalesCodeType = 'Product' for Products; 'Service' for Services
***********************************************************************/

CREATE  PROCEDURE [dbo].[mtnGetSalesCodesbyClient] (
	@CenterID int
,	@ClientMembershipGUID UniqueIdentifier
,	@SalesCodeType varchar(10)

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
		,	ISNULL(ISNULL(cscm.Price, scc.PriceRetail), 0) as 'Price'
		,	ISNULL(cctr1.TaxRate,0) as 'TaxRate1'
		,	ISNULL(cctr2.TaxRate,0) as 'TaxRate2'
		,	sc.IsSalesCodeKitFlag as 'IsSalesCodeKitFlag'
	FROM datClientMembership clm
		inner join cfgSalesCodeMembership cscm
			on clm.MembershipID = cscm.MembershipID
		inner join cfgsalescodecenter scc
			on cscm.SalesCodeCenterID = scc.SalesCodeCenterID
		inner join cfgSalesCode sc
			on scc.SalesCodeID = sc.SalesCodeID
		inner join lkpSalesCodeType sct
			on sc.SalesCodeTypeID = sct.SalesCodeTypeID
		inner join lkpSalesCodeDepartment scd
			on sc.SalesCodeDepartmentID = scd.SalesCodeDepartmentID
		left outer join cfgCenterTaxRate cctr1
			on ISNULL(cscm.TaxRate1ID, scc.TaxRate1ID) = cctr1.CenterTaxRateID
		left outer join cfgCenterTaxRate cctr2
			on ISNULL(cscm.TaxRate2ID, scc.TaxRate2ID) = cctr2.CenterTaxRateID
	WHERE
		scc.CenterID = @CenterID
		and clm.ClientMembershipGUID = @clientmembershipguid
		and sct.SalesCodeTypeDescriptionShort = @SalesCodeType
	order by sc.SalesCodeDepartmentID,sc.SalesCodeDescription
END
GO
